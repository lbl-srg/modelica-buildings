within Buildings.Fluid.Chillers.Compressors;
model ScrollCompressor
  "Model for a scroll compressor, based on Jin (2002)"

  extends Buildings.Fluid.Chillers.Compressors.BaseClasses.PartialCompressor;

  parameter Real volRat(min = 1.0, final unit = "1")
    "Built-in volume ratio";

  parameter Modelica.SIunits.VolumeFlowRate v_flow(min = 0)
    "Refrigerant volume flow rate at suction at full load conditions";

  parameter Modelica.SIunits.MassFlowRate leaCoe(min = 0, max = 1)
    "Leakage coefficient";

  parameter Modelica.SIunits.Efficiency etaEle
    "Electro-mechanical efficiency of the compressor";

  parameter Modelica.SIunits.Power PLos(min = 0)
    "Constant part of the compressor power losses";

  parameter Modelica.SIunits.TemperatureDifference dTSup(min = 0)
    "Superheating at compressor suction";

  Modelica.SIunits.MassFlowRate m_flow
    "Refrigerant mass flow rate";

  Modelica.SIunits.MassFlowRate mLea_flow "Refrigerant leakage mass flow rate";

  Modelica.SIunits.AbsolutePressure pDis(start = 1000e3)
    "Discharge pressure of the compressor";

  Modelica.SIunits.AbsolutePressure pSuc(start = 100e3)
    "Suction pressure of the compressor";

  Modelica.SIunits.SpecificVolume vSuc(start = 1e-4, min = 0)
    "Specific volume of the refrigerant at suction of the compressor";

  Modelica.SIunits.Power PThe
    "Theoretical power consumed by the compressor";

  Modelica.SIunits.Temperature TSuc
    "Temperature at suction of the compressor";

  Modelica.SIunits.Efficiency COP
    "Heating COP of the compressor";

protected
  Modelica.SIunits.IsentropicExponent k(start = 1.2)
    "Isentropic exponent of the refrigerant";

  Real v_norm
    "Normalized refrigerant volume flow rate at
     suction at part load conditions";

  Real PR(min = 0.0, unit = "1", start = 2.0)
    "Pressure ratio";

  Real PRInt(start = 1.5)
    "Built-in pressure ratio";

  Real U(start = 1)
    "Shutdown signal for invalid pressure ratios";

equation

  PR = max(pDis/pSuc, 0);
  PRInt = volRat^k;

  // The compressor is turned off if the resulting condensing pressure is lower
  // than the evaporating pressure
  when PR <= 1.0 then
    U = 0;
  elsewhen PR > 1.01 then
    U = 1;
  end when;

  // The specific volume at suction of the compressor is calculated
  // from the Martin-Hou equation of state
  vSuc = ref.specificVolumeVap_pT(pSuc, TSuc);

  // Limit compressor speed to the full load speed
  if enable_variable_speed then
    v_norm = min(1.0, max(0.0,y));
  else
    if y > 0.0 then // fixme: not robust to numerical noise
      v_norm = 1.0;
    else
      v_norm = 0.0;
    end if;
  end if;

  if y > 0.0 then // fixme: not robust to numerical noise
    // Suction pressure
    pSuc = pEva;
    // Discharge pressure
    pDis = pCon;
    // Refrigerant mass flow rate
    mLea_flow = leaCoe*PR;
    m_flow =v_norm*U*Buildings.Utilities.Math.Functions.smoothMax(
      v_flow/vSuc - mLea_flow,
      1e-5*v_flow/vSuc,
      1e-6*v_flow/vSuc);

    // Theoretical power of the compressor
    k = Buildings.Fluid.Chillers.Compressors.Refrigerants.R410A.isentropicExponentVap_Tv(TSuc, vSuc);
    if abs(PR-PRInt)/PRInt > 1e-6 then
    // If the external pressure ratio does not match the built-in pressure ratio
      PThe = v_norm * k/(k- 1.0) * pSuc *v_flow
             * (((k - 1.0)/k)*PR/volRat + 1.0/k * PRInt^((k - 1.0)/k) - 1.0);
    else
    // If the external pressure ratio matches the built-in pressure ratio
      PThe = v_norm * k/(k-1) * pSuc*v_flow*((PRInt)^((k-1)/k)-1);
    end if;

    // Temperature at suction of the compressor
    TSuc = port_a.T + dTSup;

    // Power consumed by the compressor
    P = (PThe / etaEle + PLos) * U;

    // Energy balance of the compressor
     port_a.Q_flow = m_flow * (hEva - hCon);
     port_b.Q_flow = - (port_a.Q_flow + P);
     -port_b.Q_flow = P * COP;
  else
    // Heat pump is turned off
    k = 1.0;
    pSuc = pEva;
    pDis = pCon;
    mLea_flow = 0;
    m_flow = 0;
    PThe = 0;
    P = 0;
    TSuc = port_a.T;
    port_a.Q_flow = 0;
    port_b.Q_flow = 0;
    COP = 1.0;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    defaultComponentName="scrCom",
    Documentation(info="<html>
<p>
Model for a scroll processor, as detailed in Jin (2002). The rate of heat transfered to the evaporator is given by:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>Eva</sub> = m&#775;<sub>ref</sub> ( h<sub>Vap</sub>(T<sub>Eva</sub>) - h<sub>Liq</sub>(T<sub>Con</sub>) ).
</p>
<p>
The power consumed by the compressor is given by a linear efficiency relation:
</p>
<p align=\"center\" style=\"font-style:italic;\">
P = P<sub>Theoretical</sub> / &eta; + P<sub>Loss,constant</sub>.
</p>
<p>
Variable speed is achieved by multiplying the full load suction volume flow rate
by the normalized compressor speed. The power and heat transfer rates are forced
to zero if the resulting heat pump state has higher evaporating pressure than
condensing pressure.
</p>
<h4>Assumptions and limitations</h4>
<p>
The compression process is assumed isentropic. The thermal energy 
of superheating is ignored in the evaluation of the heat transfered to the refrigerant 
in the evaporator. There is no supercooling.
</p>
<h4>References</h4>
<p>
H. Jin.
<i>
Parameter estimation based models of water source heat pumps.
</i>
PhD Thesis. Oklahoma State University. Stillwater, Oklahoma, USA. 2012.
</p>
</html>", revisions="<html>
<ul>
<li>
November 11, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ScrollCompressor;
