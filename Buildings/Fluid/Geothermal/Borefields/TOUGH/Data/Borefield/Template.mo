within Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Borefield;
record Template
  "Template for borefield data records"
  extends Modelica.Icons.Record;
  parameter Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Filling.Template filDat
    "Filling data";
  parameter Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Configuration.Template conDat
    "Configuration data";

  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="borFieDat",
Documentation(
info="<html>
<p>
This record is a template for the records in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Borefield\">
Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Borefield</a>.
</p>
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
