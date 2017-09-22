within Buildings.Fluid.HeatPumps.Compressors;
model ScrollCompressor
  "Model for a scroll compressor, based on Jin (2002)"
  extends Buildings.Fluid.HeatPumps.Compressors.BaseClasses.PartialCompressor;

  parameter Real volRat(
    min = 1.0,
    final unit = "1")
    "Built-in volume ratio";

  parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal(min=0)
    "Refrigerant volume flow rate at suction at full load conditions";

  parameter Modelica.SIunits.MassFlowRate leaCoe(
    min = 0)
    "Leakage mass flow rate at a pressure ratio of 1";

  parameter Modelica.SIunits.Efficiency etaEle
    "Electro-mechanical efficiency of the compressor";

  parameter Modelica.SIunits.Power PLos(min = 0)
    "Constant part of the compressor power losses";

  parameter Modelica.SIunits.TemperatureDifference dTSup(min = 0)
    "Superheating at compressor suction";

  Modelica.SIunits.MassFlowRate m_flow
    "Refrigerant mass flow rate";

  Modelica.SIunits.MassFlowRate mLea_flow "Refrigerant leakage mass flow rate";

  Modelica.SIunits.Power PThe
    "Theoretical power consumed by the compressor";

  Modelica.SIunits.Efficiency COP
    "Heating COP of the compressor";

protected
  Modelica.SIunits.IsentropicExponent k(start = 1.2)
    "Isentropic exponent of the refrigerant";

  Real v_norm
    "Normalized refrigerant volume flow rate at
     suction at part load conditions";

  Real PRInt(start = 2.0)
    "Built-in pressure ratio";

equation
  PRInt = volRat^k;

  // Limit compressor speed to the full load speed
  v_norm = Buildings.Utilities.Math.Functions.smoothLimit(y, 0.0, 1.0, 0.001);

  if isOn then
    // Suction pressure
    pSuc = pEva;
    // Discharge pressure
    pDis = pCon;
    // Refrigerant mass flow rate
    mLea_flow = leaCoe*PR;
    m_flow = v_norm*
      Buildings.Utilities.Math.Functions.smoothMax(
      V_flow_nominal/vSuc - mLea_flow,
      1e-5*V_flow_nominal/vSuc,
      1e-6*V_flow_nominal/vSuc);

    // Theoretical power of the compressor
    k = ref.isentropicExponentVap_Tv(TSuc, vSuc);
    // If the external pressure ratio does not match the built-in pressure ratio
    PThe = v_norm * k/(k - 1.0) * pSuc * V_flow_nominal
      * (((k - 1.0)/k) * PR/volRat + 1.0/k * PRInt^((k - 1.0)/k) - 1.0);
    // This equation reduces to the  equation for the built-in pressure ratio
    // if the external pressure ratio matches the built-in pressure ratio:
    // PThe = v_norm * k/(k - 1.0) * pSuc*v_flow * ((PRInt)^((k - 1.0)/k) - 1.0)

    // Temperature at suction of the compressor
    TSuc = port_a.T + dTSup;

    // Power consumed by the compressor
    P = (PThe/etaEle + PLos);

    // Energy balance of the compressor
     port_a.Q_flow = m_flow * (hEva - hCon);
     port_b.Q_flow = - (port_a.Q_flow + P);
     -port_b.Q_flow = P * COP;
  else
    // Heat pump is turned off
    k = 1.0;
    pSuc = pEva;
    pDis = pCon;
    mLea_flow = 0.0;
    m_flow = 0.0;
    PThe = 0.0;
    P = 0.0;
    TSuc = port_a.T;
    port_a.Q_flow = 0.0;
    port_b.Q_flow = 0.0;
    COP = 1.0;
  end if;

  annotation (    defaultComponentName="scrCom",
    Documentation(info="<html>
<p>
Model for a scroll processor, as detailed in Jin (2002). The rate of heat transferred to the evaporator is given by:
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
of superheating is ignored in the evaluation of the heat transferred to the refrigerant
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
May 30, 2017, by Filip Jorissen:<br/>
Removed <code>pressure_error</code> as
this is replaced by
<a href=\"modelica://Buildings.Fluid.HeatPumps.Compressors.BaseClasses.TemperatureProtection\">
Buildings.Fluid.HeatPumps.Compressors.BaseClasses.TemperatureProtection</a>.
See <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/769\">#769</a>.
</li>
<li>
November 11, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ScrollCompressor;
