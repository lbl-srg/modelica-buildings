within Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data;
record GoogleProjectDeschutes
  "Data record for a Google Project Deschutes CDU"
  extends
    Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data.Generic_epsNTU(
    Q_flow_nominal=2E6,
    TRacOut_nominal=273.15 + 45,
    dpHexPla_nominal=80000,
    dpPum_nominal=60000);

  annotation (
  defaultComponentName="datCDU",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
This data record is for the 5th generation CDU unit of Google, named
\"Project Deschutes\". This unit is specified for the following data (OCP, 2026):
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
      <td style=\"text-align: left;\">IT Loop flow</td>
      <td style=\"text-align: right;\">31.48</td>
      <td style=\"text-align: left;\">kg/s</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Facility Loop flow</td>
      <td style=\"text-align: right;\">32.30</td>
      <td style=\"text-align: left;\">kg/s</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">IT Loop dP available</td>
      <td style=\"text-align: right;\">80-90<br>551,581 - 620,528</td>
      <td style=\"text-align: left;\">psi<br>Pa</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Facility Loop dP</td>
      <td style=\"text-align: right;\">15-27<br>103,421 - 186,159</td>
      <td style=\"text-align: left;\">psid<br>Pa</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Thermal load</td>
      <td style=\"text-align: right;\">2000</td>
      <td style=\"text-align: left;\">kW</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Approach temperature</td>
      <td style=\"text-align: right;\">3</td>
      <td style=\"text-align: left;\">°C</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Facility Loop entering temperature</td>
      <td style=\"text-align: right;\">26.8</td>
      <td style=\"text-align: left;\">°C</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Power consumption</td>
      <td style=\"text-align: right;\">74</td>
      <td style=\"text-align: left;\">kW</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Liquids</td>
      <td style=\"text-align: right;\">DI water, PG25</td>
      <td style=\"text-align: left;\"></td>
    </tr>
  </tbody>
</table>
</p>
<h4>References</h4>
<p>
OCP 2026. Open Compute Project meeting, CDU Information WP. March 24, 2026.
</p>
</html>", revisions="<html>
<ul>
<li>
April 13, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end GoogleProjectDeschutes;
