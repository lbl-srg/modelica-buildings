within Buildings.Fluid.Humidifiers.EvaporativePads.Data.EvapcoTest;
record ManufacturerA6inchVersion1
  "Evapco test data for a 6-inch Version 1 evaporative pad from Manufacturer A"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    final efficiency(
      v={0,1.27,1.524,1.778,2.032,2.2352,2.5146,2.7686,3.0226,3.302,3.556,5,10},
      eta={0.819,0.744,0.731,0.714,0.695,0.681,0.664,0.66,0.647,0.634,0.623,0.553,
        0.373}),
    final dp_nominal=48.5238,
    final v_nominal=3.556,
    final n=1.7360);

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
July 08, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end ManufacturerA6inchVersion1;
