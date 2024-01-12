within Buildings.Fluid.Geothermal.ZonedThermalStorage.Data.Borefield;
record Template
  "Template for borefield data records"
  extends Modelica.Icons.Record;
  parameter
    Buildings.Fluid.Geothermal.ZonedThermalStorage.Data.Filling.Template filDat
    "Filling data";
  parameter Buildings.Fluid.Geothermal.ZonedThermalStorage.Data.Soil.Template soiDat
    "Soil data";
  parameter
    Buildings.Fluid.Geothermal.ZonedThermalStorage.Data.Configuration.Template conDat
    "Configuration data";

  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="borFieDat",
Documentation(
info="<html>
<p>
This record is a template for the records in
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedThermalStorage\">
Buildings.Fluid.Geothermal.ZonedThermalStorage</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end Template;
