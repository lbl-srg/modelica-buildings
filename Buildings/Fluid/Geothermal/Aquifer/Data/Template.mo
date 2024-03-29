within Buildings.Fluid.Geothermal.Aquifer.Data;
record Template
  "Template for soil data records"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.ThermalConductivity kSoi
    "Thermal conductivity of the soil material";
  parameter Modelica.Units.SI.SpecificHeatCapacity cSoi
    "Specific heat capacity of the soil material";
  parameter Modelica.Units.SI.Density dSoi(displayUnit="kg/m3")
    "Density of the soil material";
  parameter Real phi(final unit="1")
    "Reservoir porosity";
  parameter Modelica.Units.SI.Velocity K
    "Hydraulic conductivity";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  defaultComponentPrefixes="parameter",
  defaultComponentName="aquDat",
  Documentation(
info="<html>
<p>
This record is a template for the records in
<a href=\"modelica://Buildings.Fluid.Geothermal.Aquifer.MultiWell\">
Buildings.Fluid.Geothermal.Aquifer.MultiWell</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 25, 2024, by Michael Wetter:<br/>
Corrected broken link.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1855\">IBPSA, issue 1855</a>.
</li>
<li>
May 2023, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end Template;
