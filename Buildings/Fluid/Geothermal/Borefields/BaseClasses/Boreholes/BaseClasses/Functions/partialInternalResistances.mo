within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions;
partial function partialInternalResistances
  "Partial model for borehole resistance calculation"
  extends Modelica.Icons.Function;

  // Geometry of the borehole
  input Boolean use_Rb = false
    "True if the value Rb should be used instead of calculated";
  input Real Rb(unit="(m.K)/W") "Borehole thermal resistance";
  input Modelica.Units.SI.Height hSeg "Height of the element";
  input Modelica.Units.SI.Radius rBor "Radius of the borehole";
  // Geometry of the pipe
  input Modelica.Units.SI.Radius rTub "Radius of the tube";
  input Modelica.Units.SI.Length eTub "Thickness of the tubes";
  input Modelica.Units.SI.Length sha
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole";

  // Thermal properties
  input Modelica.Units.SI.ThermalConductivity kFil
    "Thermal conductivity of the grout";
  input Modelica.Units.SI.ThermalConductivity kSoi
    "Thermal conductivity of the soi";
  input Modelica.Units.SI.ThermalConductivity kTub
    "Thermal conductivity of the tube";
  input Modelica.Units.SI.ThermalConductivity kMed
    "Thermal conductivity of the fluid";
  input Modelica.Units.SI.DynamicViscosity muMed
    "Dynamic viscosity of the fluid";
  input Modelica.Units.SI.SpecificHeatCapacity cpMed
    "Specific heat capacity of the fluid";
  input Modelica.Units.SI.MassFlowRate m_flow_nominal "Nominal mass flow rate";

  // Outputs
  output Real x "Capacity location";

protected
  parameter Real pi = 3.141592653589793 "pi";

  Real rTub_in = rTub-eTub "Inner radius of tube";

  Real RConv(unit="(m.K)/W")=
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
      hSeg=hSeg,
      rTub=rTub,
      eTub=eTub,
      kMed=kMed,
      muMed=muMed,
      cpMed=cpMed,
      m_flow=m_flow_nominal,
      m_flow_nominal=m_flow_nominal)*hSeg;

  Boolean test=false "thermodynamic test for R and x value";

  Real RCondPipe(unit="(m.K)/W") =  Modelica.Math.log((rTub)/rTub_in)/(2*Modelica.Constants.pi*kTub)
    "Thermal resistance of the pipe wall";

  Real Rb_internal(unit="(m.K)/W")
    "Resistance from the fluid in the pipe to the borehole wall";

  Real Rb_multipole(unit="(m.K)/W")
    "Theoretical Fluid-to-borehole-wall resistance evaluated from the multipole method";

  Integer i=1 "Loop counter";

annotation (
  Documentation(info="<html>
<p>
This partial function defines the common inputs to functions that calculate
the borehole internal resistances.
</p>
</html>", revisions="<html>
<ul>
<li>
June 4, 2023, by Michael Wetter:<br/>
Corrected variability.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1762\">IBPSA, #1762</a>.
</li>
<li>
February 28, 2022, by Massimo Cimmino:<br/>
Changed function to be <code>pure</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1582\">IBPSA, #1582</a>.
</li>
<li>
July 18, 2018 by Massimo Cimmino:<br/>
Implemented multipole method.
</li>
<li>
February 14, 2014 by Michael Wetter:<br/>
Added an assert statement to test for non-physical values.
</li>
<li>
February 12, 2014, by Damien Picard:<br/>
Remove the flow dependency of the resistances, as this function calculates the conduction resistances only.
</li>
<li>
January 24, 2014, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
January 23, 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end partialInternalResistances;
