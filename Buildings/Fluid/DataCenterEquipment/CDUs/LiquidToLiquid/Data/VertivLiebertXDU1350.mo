within Buildings.Fluid.DataCenterEquipment.CDUs.LiquidToLiquid.Data;
record VertivLiebertXDU1350
  "Data record for a Vertiv Liebert XDU 1350 CDU"
  extends Buildings.Fluid.DataCenterEquipment.CDUs.LiquidToLiquid.Data.Generic_epsNTU(
    Q_flow_nominal=1350E3,
    mRac_flow_nominal=20.6,
    mPla_flow_nominal=20.6,
    TApp_nominal=4,
    TRacOut_nominal=273.15 + 32,
    dpHexPla_nominal=84000,
    medPla=Buildings.Fluid.DataCenterEquipment.CDUs.Types.Media.Water,
    medRac=Buildings.Fluid.DataCenterEquipment.CDUs.Types.Media.PropyleneGlycol,
    phiGlyRac=0.2,
    dpPumpExt_nominal=500000,
    pumpExtHead(
      V_flow=mRac_flow_nominal/rhoRac_default*{0.000, 0.250, 0.500, 0.750, 1.000},
      dp=dpPumpExt_nominal*({3.846, 3.676, 3.231, 2.538, 1.0})),
    VExp=24E-3);

  annotation (
  defaultComponentName="datCDU",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
This data record is for a Vertiv Liebert XDU 1350.
This unit is specified for the following data:
</p>
<p>
<table>
  <thead>
    <tr>
      <th style=\"text-align: left;\">Description</th>
      <th style=\"text-align: right;\">Value</th>
      <th style=\"text-align: left;\">Unit</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style=\"text-align: left;\">Thermal load</td>
      <td style=\"text-align: right;\">1368</td>
      <td style=\"text-align: left;\">kW</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Approach temperature</td>
      <td style=\"text-align: right;\">4</td>
      <td style=\"text-align: left;\">°C</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Liquids</td>
      <td style=\"text-align: right;\">DI water, PG20</td>
      <td style=\"text-align: left;\"></td>
    </tr>
  </tbody>
</table>
</p>
<h4>References</h4>
<p>
Vertiv, Liebert XDU 1350 data sheet, SL-70799 (R10/25)
</p>
</html>", revisions="<html>
<ul>
<li>
July 13, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end VertivLiebertXDU1350;
