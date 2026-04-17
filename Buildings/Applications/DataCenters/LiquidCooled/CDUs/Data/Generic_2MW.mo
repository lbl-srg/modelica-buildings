within Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data;
record Generic_2MW
  "Generic data record for a 2 MW CDU"
  extends Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data.Generic_epsNTU(
    Q_flow_nominal=2E6,
    TRac_a_nominal=273.15 + 45,
    dpHexPla_nominal=80000,
    dpPum_nominal=60000);

  annotation (
  defaultComponentName="datCDU",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic record for a 2 MW CDU.
</p>
<h4>References</h4>
<p>
fixme
Cheng Chen, Dennis Trieu, Tejas Shah, Allen Guo, Jaylen Cheng, Christopher Chapman, Sukhvinder Kang,
Eran Dagan, Assaf Dinstag,Jane Yao.
<a href=\"https://www.opencompute.org/documents/oai-system-liquid-cooling-guidelines-in-ocp-template-mar-3-2023-update-pdf\">
OCP OAI SYSTEM LIQUID COOLING GUIDELINES</a>.
2023.
<p>
</html>", revisions="<html>
<ul>
<li>
April 13, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic_2MW;
