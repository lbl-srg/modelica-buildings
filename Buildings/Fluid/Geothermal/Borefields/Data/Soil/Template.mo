within Buildings.Fluid.Geothermal.Borefields.Data.Soil;
record Template
  "Template for soil data records"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.ThermalConductivity kSoi
    "Thermal conductivity of the soil material";
  parameter Modelica.Units.SI.SpecificHeatCapacity cSoi
    "Specific heat capacity of the soil material";
  parameter Modelica.Units.SI.Density dSoi(displayUnit="kg/m3")
    "Density of the soil material";
  parameter Boolean steadyState = dSoi*cSoi < Modelica.Constants.eps
    "Flag, if true, then material is computed using steady-state heat conduction"
    annotation(Evaluate=true);
  final parameter Modelica.Units.SI.ThermalDiffusivity aSoi=
    if (dSoi*cSoi < Modelica.Constants.eps) then 1E20 else kSoi/(dSoi*cSoi)
    "Heat diffusion coefficient of the soil material";
  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="soiDat",
Documentation(
info="<html>
<p>
This record is a template for the records in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.Data.Soil\">
Buildings.Fluid.Geothermal.Borefields.Data.Soil</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 15, 2026, by Michael Wetter:<br/>
Applied the <code>steadyState</code> flag to zero out effective soil volumetric heat capacity in steady-state mode and guarded <code>aSoi</code> against division by zero.
</li>
<li>
July 15, 2018, by Michael Wetter:<br/>
Revised implementation, added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code>.
Corrected check of real variable against zero which is not allowed in Modelica.
</li>
<li>
June28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end Template;
