within Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data;
record VertivLiebertXDU1350
  "Data record for a Vertiv Liebert XDU 1350 CDU"
  extends Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.Generic_epsNTU(
    Q_flow_nominal=-1368E3,
    mRac_flow_nominal=20.18,
    mPla_flow_nominal=19.91,
    TApp_nominal=4,
    TRacOut_nominal=273.15 + 36,
    dpHexPla_nominal=37000,
    dpHexRac_nominal=37000,
    dpFilRac_nominal=30800,
    nFilRac=1.99,
    medPla=Buildings.Fluid.DataCenters.CDUs.Types.Media.Water,
    medRac=Buildings.Fluid.DataCenters.CDUs.Types.Media.PropyleneGlycol,
    phiGlyRac=0.2,
    dpPumpExt_nominal=353200,
    pumpExtHead(
      V_flow=mRac_flow_nominal/rhoRac_default*{0.000, 0.250, 0.500, 0.750, 1.000, 1.250, 1.500},
      dp={497600, 481700, 456400, 417100, 353200, 256800, 198000}),
    pumpEfficiency(
      V_flow=mRac_flow_nominal/rhoRac_default*{1},
      eta={0.413}),
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
      <td style=\"text-align: left;\">&deg;C</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Facility loop entering temperature (ASHRAE W3)</td>
      <td style=\"text-align: right;\">32</td>
      <td style=\"text-align: left;\">&deg;C</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Nominal volumetric flow rate (primary and secondary)</td>
      <td style=\"text-align: right;\">1200</td>
      <td style=\"text-align: left;\">L/min</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Maximum secondary flow rate (3 pumps with filtration)</td>
      <td style=\"text-align: right;\">1800</td>
      <td style=\"text-align: left;\">L/min</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Primary loop dP at 1200 L/min (plain water)</td>
      <td style=\"text-align: right;\">74,000</td>
      <td style=\"text-align: left;\">Pa</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Maximum power consumption (3 pumps)</td>
      <td style=\"text-align: right;\">20.5</td>
      <td style=\"text-align: left;\">kW</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Liquids</td>
      <td style=\"text-align: right;\">DI water, PG20</td>
      <td style=\"text-align: left;\"></td>
    </tr>
  </tbody>
</table>
<p>
The rack-side pump specification assumes 3 pumps operating in parallel with internal
50 &mu;m filtration.
The filter pressure drop <code>dpFilRac_nominal</code> and flow exponent
<code>nFilRac</code> are obtained from the difference between the published 3-pump
external differential pressure curves without and with filtration.
On the facility side, the total primary circuit pressure drop for water is split
equally between <code>dpHexPla_nominal</code> and <code>dpValve_nominal</code> to
achieve a valve authority of <i>0.5</i>.
</p>
<h4>References</h4>
<ul>
<li>
Vertiv,
<a href=\"https://www.vertiv.com/48ea5d/globalassets/products/thermal-management/high-density-solutions/vertiv-liebert-xdu-coolant-distribution-units/vertiv-liebert-xdu1350-cdu-ds-a4-emea-mka4l0ukxduds1350-web.pdf\">
Liebert XDU 1350 Coolant Distribution Unit (CDU) data sheet, MKA4L0UKXDUDS1350 - Rev. 1- (R01/23)</a>.
</li>
<li>
Vertiv,
<a href=\"https://www.vertiv.com/49283c/globalassets/shared/liebert-xdu1350-coolant-distribution-unitcdu-ds-en-na-sl-70799-web.pdf\">
Liebert XDU 1350 Coolant Distribution Unit (CDU) data sheet, SL-70799 (R10/25)</a>.
</li>
<li>
Vertiv,
<a href=\"https://www.vertiv.com/48ef40/globalassets/products/thermal-management/high-density-solutions/liebert-xdu1350-coolant-distribution-unit-application-and-planning-guide-sl-70618.pdf\">
Liebert XDU1350 Coolant Distribution Unit Application and Planning Guide, SL-70618</a>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 24, 2026, by Michael Wetter:<br/>
Updated nominal temperatures, mass flow rates, primary and secondary pressure drops,
filter exponent, 3-pump external head curve, and pump efficiency to match the Vertiv
catalog data, and added links to the data sheets and application guide.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4926\">Buildings, #4926</a>.
</li>
<li>
November 13, 2026, by Michael Wetter:<br/>
Aligned <code>Q_flow_nominal</code> with the specification table and set
<code>dpHexRac_nominal</code> so that the total pump head curve decreases monotonically.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4926\">Buildings, #4926</a>.
</li>
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
