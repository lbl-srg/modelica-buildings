within Buildings.Fluid.Humidifiers.EvaporativePads.Data.EvapcoTest;
record ManufacturerB6inchVersion3
  "Evapco test data for a 6-inch Version 3 evaporative pad from Manufacturer B"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    final efficiency(
      v={1.27,  1.524, 1.778, 2.032, 2.286, 2.54,  2.794, 3.048, 3.302,
       3.556},
      eta={0.753, 0.737, 0.719, 0.701, 0.687, 0.681, 0.661, 0.649, 0.636,
       0.627}),
    final dp_nominal=74.652,
    final v_nominal=3.556,
    final n=1.8610);

  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
Performance data for a 6-inch evaporative pad. See the documentation of
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Data.MuntersCELdek\">
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
end ManufacturerB6inchVersion3;
