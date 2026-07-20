within Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Filling;
record Template
  "Template for filling data records"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.ThermalConductivity kFil
    "Thermal conductivity of the borehole filling material";
  parameter Modelica.Units.SI.SpecificHeatCapacity cFil
    "Specific heat capacity of the borehole filling material";
  parameter Modelica.Units.SI.Density dFil(displayUnit="kg/m3")
    "Density of the borehole filling material";
  parameter Boolean steadyState = dFil*cFil < Modelica.Constants.eps
    "Flag, if true, then material is computed using steady-state heat conduction"
    annotation(Evaluate=true);
  final parameter Modelica.Units.SI.ThermalDiffusivity aFil=
    if (dFil*cFil < Modelica.Constants.eps) then 1E20 else kFil/(dFil*cFil)
    "Heat diffusion coefficient of the borehole filling material";
  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="filDat",
Documentation(
info="<html>
<p>This record is a template for the records in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Filling\">
Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Filling</a>.</p>
</html>",
revisions="<html>
<ul>
<li>
June 22, 2026, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Template;
