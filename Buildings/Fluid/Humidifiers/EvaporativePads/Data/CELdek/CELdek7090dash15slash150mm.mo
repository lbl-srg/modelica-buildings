within Buildings.Fluid.Humidifiers.EvaporativePads.Data.CELdek;
record CELdek7090dash15slash150mm
  "Data for CELdek EnergyPlus typical 6-inch evaporative pad"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    final efficiency(
      v={0,0.5,0.75,1,1.255,1.511,1.766,2.021,2.277,2.532,2.788,3.043,3.298,3.554,
        4.064,4.575},
      eta={0.915,0.85,0.821,0.796,0.772,0.75,0.731,0.714,0.698,0.683,0.67,0.658,
        0.647,0.636,0.616,0.596}),
    final dp_nominal=185.304,
    final v_nominal=4.575,
    final n=1.8);

  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
Performance data for a 6-inch evaporative pad. See the documentation of
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Data.CELdek\">
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
end CELdek7090dash15slash150mm;
