within Buildings.Fluid.Humidifiers.EvaporativePads.Data.CelDekEnergyPlus;
record Typical12Inches
  "Data for CelDek EnergyPlus typical 12-inch evaporative pad"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    efficiency(
      v={0,0.5,0.75,1,1.255,1.511,1.766,2.021,2.277,2.532,2.788,3.043,3.298,3.554,
        4.064,4.575,45.75,457.5},
      eta={0.989,0.955,0.941,0.93,0.92,0.911,0.904,0.898,0.892,0.887,0.882,0.877,
        0.872,0.866,0.85,0.829,0,0}),
    pressure(
      v={0,0.5,0.75,1,1.255,1.511,1.766,2.021,2.277,2.532,2.788,3.043,3.298,3.554,
        4.064,4.575,45.75,457.5},
      dp={0,6.892,14.3,24,36.122,50.453,66.803,85.159,105.552,127.775,151.963,
        177.891,205.619,235.235,299.452,370.608,23384,1475418}));

  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
Evaporative pad performance data.
See the documentation of
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Data.CelDekEnergyPlus\">
Buildings.Fluid.Humidifiers.EvaporativePads.Data.CelDekEnergyPlus</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Typical12Inches;
