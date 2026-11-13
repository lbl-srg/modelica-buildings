within Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data;
record VertivLiebertXDU1350
  "Data record for a Vertiv Liebert XDU 1350 CDU"
  extends Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.Generic_epsNTU(
    Q_flow_nominal=-1350E3,
    mRac_flow_nominal=20.4,
    mPla_flow_nominal=20.4,
    TApp_nominal=4,
    TRacOut_nominal=273.15 + 32,
    dpHexPla_nominal=0.84E5,
    medPla=Buildings.Fluid.DataCenters.CDUs.Types.Media.Water,
    medRac=Buildings.Fluid.DataCenters.CDUs.Types.Media.PropyleneGlycol,
    phiGlyRac=0.2,
    dpPumpExt_nominal=3.5E5,
    dpFilRac_nominal=0.3E5,
    pumpExtHead(
      V_flow=mRac_flow_nominal/rhoRac_default*{0.000, 0.250, 0.500, 0.750, 1.000, 1.250, 1.500, 1.750},
      dp=dpPumpExt_nominal*({1.315, 1.264, 1.209, 1.128, 1.000, 0.805, 0.521, 0.127})),
    VExp=24E-3);

  annotation (
  defaultComponentName="datCDU",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
This data record is for a Vertiv Liebert XDU 1350.
This unit is specified for the following data:
</p>
<table summary=\"Vertiv Liebert XDU 1350 CDU specifications\">
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
<p>
The rack-side pump specification assumes 3 pumps operating and the unit having a filter.
</p>
<h4>References</h4>
<p>
Vertiv, Liebert XDU 1350 data sheet,
MKA4L0UKXDUDS1350 - Rev. 1- (R01/23)
</p>
</html>", revisions="<html>
<ul>
<li>
November 10, 2026, by Michael Wetter:<br/>
Corrected pump and filter pressure, and mass flow rate.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4872\">Buildings, #4872</a>.
</li>
<li>
October 17, 2026, by Nauman Rafique:<br/>
Corrected sign of <code>Q_flow_nominal</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4787\">Buildings, #4787</a>.
</li>
<li>
July 13, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end VertivLiebertXDU1350;
