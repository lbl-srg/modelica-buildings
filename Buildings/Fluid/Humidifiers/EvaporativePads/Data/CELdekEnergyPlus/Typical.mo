within Buildings.Fluid.Humidifiers.EvaporativePads.Data.CELdekEnergyPlus;
record Typical
  "Data for CELdek EnergyPlus typical evaporative pad with varying pad depth"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    efficiency(
      v={0,0.5,0.75,1,1.255,1.511,1.766,2.021,2.277,2.532,2.788,3.043,3.298,3.554,
        4.064,4.575},
      eta={0.915*0.1524/dep,0.85*0.1524/dep,0.821*0.1524/dep,0.796*0.1524/dep,
        0.772*0.1524/dep,0.75*0.1524/dep,0.731*0.1524/dep,0.714*0.1524/dep,
        0.698*0.1524/dep,0.683*0.1524/dep,0.67*0.1524/dep,0.658*0.1524/dep,
        0.647*0.1524/dep,0.636*0.1524/dep,0.616*0.1524/dep,0.596*0.1524/dep}),
    dp_nominal=185.304,
    v_nominal=4.575,
    n=1.8);
  parameter Modelica.Units.SI.Length dep = 0.1524
    "Depth of the rigid media evaporative pad";
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
Performance data for a 6-inch evaporative pad. See the documentation of
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
end Typical;
