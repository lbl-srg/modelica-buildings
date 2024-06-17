within Buildings.Fluid.Geothermal.ZonedBorefields.Data.Borefield;
record Validation "Borefield data record for the validation models"
  extends Buildings.Fluid.Geothermal.ZonedBorefields.Data.Borefield.Template(
    filDat=
        Buildings.Fluid.Geothermal.ZonedBorefields.Data.Filling.Bentonite(),
    soiDat=Buildings.Fluid.Geothermal.ZonedBorefields.Data.Soil.SandStone(),
    conDat=
        Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Validation());

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
May 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end Validation;
