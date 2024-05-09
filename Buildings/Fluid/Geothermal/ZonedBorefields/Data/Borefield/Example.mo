within Buildings.Fluid.Geothermal.ZonedBorefields.Data.Borefield;
record Example "Borefield data record for the examples"
  extends
    Buildings.Fluid.Geothermal.ZonedBorefields.Data.Borefield.Template(
    filDat=
        Buildings.Fluid.Geothermal.ZonedBorefields.Data.Filling.Bentonite(),
    soiDat=Buildings.Fluid.Geothermal.ZonedBorefields.Data.Soil.SandStone(),
    conDat=
        Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Example());

  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="borFieDat",
Documentation(
info="<html>
<p>
This record presents an example on how to define borefield records
using the template in
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Template\">
Buildings.Fluid.Geothermal.ZonedBorefields.Template</a>.
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
end Example;
