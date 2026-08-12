within Buildings.Fluid.Geothermal.ZonedBorefields.Data.Borefield;
record Rectangle3Zones10Boreholes
  "Borefield data for rectangular 3-zone borefield with 10 boreholes per zone"
  extends Buildings.Fluid.Geothermal.ZonedBorefields.Data.Borefield.Template(
    filDat=Buildings.Fluid.Geothermal.ZonedBorefields.Data.Filling.Bentonite(),
    soiDat=Buildings.Fluid.Geothermal.ZonedBorefields.Data.Soil.SandStone(),
    conDat=Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Rectangle3Zones10Boreholes());

  annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="borFieDat",
    Documentation(info="<html>
<p>
Example borefield data record for a rectangular 3-zone borefield with ten
single-U-tube boreholes per zone.
</p>
<p>
This record combines the rectangular 3-zone configuration data with standard
bentonite filling and sandstone soil data.
</p>
</html>", revisions="<html>
<ul>
<li>
August 2026, by Lone Meertens:<br/>
First implementation for examples combining zoned borefields with horizontal
plug-flow piping.
</li>
</ul>
</html>"));
end Rectangle3Zones10Boreholes;