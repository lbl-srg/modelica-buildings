within Buildings.Fluid.HeatPumps.Compressors;
model ReciprocatingCompressor
  "Model for a reciprocating compressor, based on Jin (2002)"
  extends Buildings.Fluid.HeatPumps.Compressors.BaseClasses.PartialCompressor;

  parameter Modelica.SIunits.VolumeFlowRate pisDis
    "Piston displacement";

  parameter Real cleFac(
    min = 0,
    final unit = "1")
    "Clearance factor";

  parameter Modelica.SIunits.Efficiency etaEle
    "Electro-mechanical efficiency of the compressor";

  parameter Modelica.SIunits.Power PLos(min = 0)
    "Constant part of the compressor power losses";

  parameter Modelica.SIunits.AbsolutePressure pDro
    "Pressure drop at suction and discharge of the compressor";

  parameter Modelica.SIunits.TemperatureDifference dTSup(min = 0)
    "Superheating at compressor suction";

  Modelica.SIunits.MassFlowRate m_flow
    "Refrigerant mass flow rate";

  Modelica.SIunits.Power PThe
    "Theoretical power consumed by the compressor";

  Modelica.SIunits.Efficiency COP(start=5)
    "Heating COP of the compressor";

protected
  Modelica.SIunits.IsentropicExponent k(start = 1.2)
    "Isentropic exponent of the refrigerant";

  Real pisDis_norm
    "Normalized piston displacement at part load conditions";

equation
  // Limit compressor speed to the full load speed
  pisDis_norm = Buildings.Utilities.Math.Functions.smoothLimit(y, 0.0, 1.0, 0.001);

  if isOn then
    // Suction pressure
    pSuc = Buildings.Utilities.Math.Functions.smoothMin(pEva - pDro, pCon - pDro, 0.01*ref.pCri);
    // Discharge pressure
    pDis = pCon + pDro;
    // Refrigerant mass flow rate
    k = ref.isentropicExponentVap_Tv(TSuc, vSuc);
    m_flow = pisDis_norm*pisDis/vSuc*(1 + cleFac
       - cleFac*(PR)^(1/k));
    // Theoretical power of the compressor
    PThe = k/(k-1) * m_flow*pSuc*vSuc*((PR)^((k-1)/k)-1);
    // Power consumed by the compressor
    P = PThe/etaEle + PLos;
    // Temperature at suction of the compressor
    TSuc = port_a.T + dTSup;
    // Energy balance of the compressor
    port_a.Q_flow = m_flow * (hEva - hCon);
    port_b.Q_flow = - (port_a.Q_flow + P);
    -port_b.Q_flow = P * COP;
  else
    // Heat pump is turned off
    k = 1.0;
    pSuc = pEva;
    pDis = pCon;
    m_flow = 0;
    PThe = 0;
    P = 0;
    TSuc = port_a.T;
    port_a.Q_flow = 0;
    port_b.Q_flow = 0;
    COP = 1.0;
  end if;

  annotation (defaultComponentName="scrCom",
    Documentation(info="<html>
<p>
Model for a reciprocating processor, as detailed in Jin (2002). The rate of heat transferred to the evaporator is given by:
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
Variable speed is acheived by multiplying the full load piston displacement
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
January 25, 2019, by Michael Wetter:<br/>
Added start value to avoid warning in JModelica.
</li>
<li>
May 30, 2017, by Filip Jorissen:<br/>
Removed <code>pressure_error</code> as
this is replaced by
<a href=\"modelica://Buildings.Fluid.HeatPumps.Compressors.BaseClasses.TemperatureProtection\">
Buildings.Fluid.HeatPumps.Compressors.BaseClasses.TemperatureProtection</a>.
See <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/769\">#769</a>.
</li>
<li>
November 14, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReciprocatingCompressor;
