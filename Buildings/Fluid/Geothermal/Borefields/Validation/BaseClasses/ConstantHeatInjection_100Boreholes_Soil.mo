within Buildings.Fluid.Geothermal.Borefields.Validation.BaseClasses;
record ConstantHeatInjection_100Boreholes_Soil
  "Soil data record for 100 boreholes validation case"
  extends Buildings.Fluid.Geothermal.Borefields.Data.Soil.Template(
    kSoi=2.5,
    dSoi=1800,
    cSoi=1200);
  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="soiDat",
Documentation(
info="<html>
<p>
This record contains the soil data of a field of <i>100</i> boreholes.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 27, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantHeatInjection_100Boreholes_Soil;
