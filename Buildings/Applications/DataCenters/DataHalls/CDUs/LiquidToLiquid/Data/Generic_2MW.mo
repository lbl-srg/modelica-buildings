within Buildings.Applications.DataCenters.DataHalls.CDUs.LiquidToLiquid.Data;
record Generic_2MW
  "Generic data record for a 2 MW CDU"
  extends Buildings.Applications.DataCenters.DataHalls.CDUs.LiquidToLiquid.Data.Generic_epsNTU(
    Q_flow_nominal=2E6,
    TRacOut_nominal=273.15 + 45,
    dpHexPla_nominal=80000,
    dpPumpExt_nominal=500000,
    pumpExtHead(
      V_flow=mRac_flow_nominal/rhoRac_default*{0.000, 0.250, 0.500, 0.750, 1.000},
      dp=dpPumpExt_nominal*({3.846, 3.676, 3.231, 2.538, 1.0})));

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
