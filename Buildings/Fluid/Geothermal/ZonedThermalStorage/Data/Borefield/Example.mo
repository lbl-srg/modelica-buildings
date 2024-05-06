within Buildings.Fluid.Geothermal.ZonedThermalStorage.Data.Borefield;
record Example "Borefield data record for the examples"
  extends
    Buildings.Fluid.Geothermal.ZonedThermalStorage.Data.Borefield.Template(
    filDat=
        Buildings.Fluid.Geothermal.ZonedThermalStorage.Data.Filling.Bentonite(),
    soiDat=Buildings.Fluid.Geothermal.ZonedThermalStorage.Data.Soil.SandStone(),
    conDat=
        Buildings.Fluid.Geothermal.ZonedThermalStorage.Data.Configuration.Example());

  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="borFieDat",
Documentation(
info="<html>
<p>
This record presents an example on how to define borefield records
using the template in
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedThermalStorage.Template\">
Buildings.Fluid.Geothermal.ZonedThermalStorage.Template</a>.
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
