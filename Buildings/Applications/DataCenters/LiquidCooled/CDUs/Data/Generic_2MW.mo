within Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data;
record Generic_2MW
  "Generic data record for a 2 MW CDU"
  extends Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data.Generic_epsNTU(
    Q_flow_nominal=2E6,
    TRac_b_nominal=273.15 + 45,
    dpHexPla_nominal=80000,
    dpPum_nominal=60000);

  annotation (
  defaultComponentName="datCDU",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic record for a 2 MW CDU.
</p>
</html>", revisions="<html>
<ul>
<li>
April 13, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic_2MW;
