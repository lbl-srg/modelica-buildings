within Buildings.Fluid.Humidifiers.EvaporativePads.Data.MuntersCELdek;
record CELdek7090dash15slash150mm
  "Data for CELdek EnergyPlus typical 6-inch evaporative pad"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    final efficiency(
      v={0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5,10},
      eta={0.926,0.908,0.881,0.854,0.828,0.808,0.788,0.766,0.752,0.731,0.719,0.547}),
    final dp_nominal=160,
    final v_nominal=3.5,
    final n=1.9259);

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
end CELdek7090dash15slash150mm;
