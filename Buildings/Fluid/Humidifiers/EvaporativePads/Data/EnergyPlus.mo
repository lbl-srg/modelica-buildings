within Buildings.Fluid.Humidifiers.EvaporativePads.Data;
record EnergyPlus
  "Data for CELdek EnergyPlus typical evaporative pad with varying pad depth"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    final efficiency(
      v={0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5},
      eta={0.7927+0.9586*dep-1.0321*dep^2+0.0*dep^3,
        0.6733+1.4136*dep-1.7693*dep^2+0.5293*dep^3,
        0.567+1.8544*dep-2.4818*dep^2+0.986*dep^3,
        0.4739+2.2668*dep-3.1452*dep^2+1.3699*dep^3,
        0.3939+2.6364*dep-3.7349*dep^2+1.6812*dep^3,
        0.3271+2.949*dep-4.2263*dep^2+1.9198*dep^3,
        0.2733+3.1904*dep-4.5948*dep^2+2.0857*dep^3,
        0.2327+3.3463*dep-4.8159*dep^2+2.1788*dep^3,
        0.2052+3.4026*dep-4.865*dep^2+2.1993*dep^3,
        0.1909+3.3448*dep-4.7175*dep^2+2.1471*dep^3,
        0.1897+3.1589*dep-4.3489*dep^2+2.0222*dep^3}),
    final dp_nominal=185.304,
    final v_nominal=4.575,
    final n=1.8);
  parameter Modelica.Units.SI.Length dep = 0.1524
    "Depth of the rigid media evaporative pad";
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
end EnergyPlus;
