within Buildings.Fluid.Humidifiers.EvaporativePads.Data.CELdekEnergyPlus;
record Typical12Inches "Data for CELdek EnergyPlus typical 12-inch evaporative pad"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    efficiency(
      v={0,0.5,0.75,1,1.255,1.511,1.766,2.021,2.277,2.532,2.788,3.043,3.298,3.554,
        4.064,4.575,45.75,457.5},
      eta={0.989,0.955,0.941,0.93,0.92,0.911,0.904,0.898,0.892,0.887,0.882,0.877,
        0.872,0.866,0.85,0.829,0,0}),
    dp_nominal=370.608,
    v_nominal=4.575,
    n=1.8);

  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
Performance data for a 12-inch evaporative pad. See the documentation of
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Data.CELdekEnergyPlus\">
Buildings.Fluid.Humidifiers.EvaporativePads.Data.CELdekEnergyPlus</a>.
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
