within Buildings.Fluid.Geothermal.Borefields.Validation.BaseClasses;
record ConstantHeatInjection_100Boreholes_Filling
  "Filling data record for 100 boreholes validation case"
  extends Buildings.Fluid.Geothermal.Borefields.Data.Filling.Template(
      kFil=1.15,
      dFil=1600,
      cFil=800);
  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="filDat",
Documentation(
info="<html>
<p>
This record contains the filling data of a field of <i>100</i> boreholes.
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
end ConstantHeatInjection_100Boreholes_Filling;
