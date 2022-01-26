within Buildings.Fluid.Geothermal.Boreholes.BaseClasses.Examples;
model ConvectionResistance
  "Model that tests a basic segment that is used to build a borehole"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Water "Medium in the pipes";

  parameter Modelica.Units.SI.SpecificHeatCapacity cpMed=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Specific heat capacity of the fluid";
  parameter Modelica.Units.SI.ThermalConductivity kMed=
      Medium.thermalConductivity(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Thermal conductivity of the fluid";
  parameter Modelica.Units.SI.DynamicViscosity mueMed=Medium.dynamicViscosity(
      Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Dynamic viscosity of the fluid";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=3000/10/4200
    "Nominal mass flow rate";
  Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  Modelica.Units.SI.ThermalResistance R
    "Thermal resistance between the fluid and the tube";
protected
 constant Real conv(unit="1/s")=1 "Conversion factor";

equation
  m_flow =m_flow_nominal*(time - 0.5)*2*conv;
  R = Buildings.Fluid.Geothermal.Boreholes.BaseClasses.convectionResistance(
    hSeg=10,
    rTub=0.02,
    kMed=kMed,
    mueMed=mueMed,
    cpMed=cpMed,
    m_flow=m_flow,
    m_flow_nominal=m_flow_nominal);
 annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Boreholes/BaseClasses/Examples/ConvectionResistance.mos"
        "Simulate and plot"),
                  Documentation(info="<html>
<p>
This example tests the function for the convective thermal resistance
inside the pipe.
</p>
</html>", revisions="<html>
<ul>
<li>
June 26, 2018, by Michael Wetter:<br/>
Replaced <code>algorithm</code> with <code>equation</code>.
</li>
<li>
February 14, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConvectionResistance;
