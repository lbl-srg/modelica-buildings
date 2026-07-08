within Buildings.Fluid.Humidifiers.EvaporativePads.Data.MuntersCELdek;
record CELdek7090dash15slash100mm
  "Data for CELdek EnergyPlus typical 12-inch evaporative pad"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    final efficiency(
      v={0,0.5,1,1.5,2,2.5,3,3.5,4,5,10},
      eta={0.836,0.815,0.768,0.73,0.699,0.672,0.649,0.628,0.61,0.551,0.364}),
    final dp_nominal=173.84,
    final v_nominal=4.5,
    final n=1.9259);

  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
Performance data for a 12-inch evaporative pad. See the documentation of
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
end CELdek7090dash15slash100mm;
