within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.Examples;
model ConvectionResistance
  "Model that tests a basic segment that is used to build a borehole"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Water "Medium in the pipes";

  parameter Modelica.SIunits.SpecificHeatCapacity cpMed=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Specific heat capacity of the fluid";
  parameter Modelica.SIunits.ThermalConductivity kMed=
      Medium.thermalConductivity(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Thermal conductivity of the fluid";
  parameter Modelica.SIunits.DynamicViscosity mueMed=Medium.dynamicViscosity(
      Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Dynamic viscosity of the fluid";

 parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    3000/10/4200 "Nominal mass flow rate";
 Modelica.SIunits.MassFlowRate m_flow "Mass flow rate";
 Modelica.SIunits.ThermalResistance R
    "Thermal resistance between the fluid and the tube";
protected
 constant Real conv(unit="1/s")=1 "Conversion factor";

algorithm
  m_flow :=m_flow_nominal*(time - 0.5)*2*conv;
  R := Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.convectionResistance(
    hSeg=10,
    rTub=0.02,
    kMed=kMed,
    mueMed=mueMed,
    cpMed=cpMed,
    m_flow=m_flow,
    m_flow_nominal=m_flow_nominal);
 annotation (
experiment(StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/BaseClasses/Examples/ConvectionResistance.mos"
        "Simulate and plot"),
                  Documentation(info="<html>
<p>
This example tests the function for the convective thermal resistance
inside the pipe.
</p>
</html>", revisions="<html>
<ul>
<li>
February 14, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConvectionResistance;
