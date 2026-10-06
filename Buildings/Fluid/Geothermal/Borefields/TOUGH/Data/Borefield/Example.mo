within Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Borefield;
record Example
  "Example definition of a borefield data record"
  extends
    Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Borefield.Template(
    filDat=Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Filling.Bentonite(),
    conDat=
        Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Configuration.Example());
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="borFieDat",
Documentation(
info="<html>
<p>This record presents an example on how to define borefield records
using the template in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Borefield.Template\">
Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Borefield.Template</a>.</p>
</html>",
revisions="<html>
<ul>
<li>
June 22, 2026, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Example;
