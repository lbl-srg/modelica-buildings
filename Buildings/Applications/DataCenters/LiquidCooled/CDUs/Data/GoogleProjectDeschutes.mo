within Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data;
record GoogleProjectDeschutes
  "Data record for a Google Project Deschutes CDU"
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
This unit is specified as for the following data:
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
      <td style=\"text-align: left;\">Operating pressure</td>
      <td style=\"text-align: right;\">0-130<br>0 - 896,319</td>
      <td style=\"text-align: left;\">psig<br>Pa</td>
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
      <td style=\"text-align: left;\">CDU weight, wet</td>
      <td style=\"text-align: right;\">6910<br>3134</td>
      <td style=\"text-align: left;\">lbs<br>kg</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">CDU weight, dry</td>
      <td style=\"text-align: right;\">5310<br>2409</td>
      <td style=\"text-align: left;\">lbs<br>kg</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Power consumption</td>
      <td style=\"text-align: right;\">74</td>
      <td style=\"text-align: left;\">kW</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Pump voltage</td>
      <td style=\"text-align: right;\">380-416 (480 is doable)</td>
      <td style=\"text-align: left;\">Vac</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Heat exchanger</td>
      <td style=\"text-align: right;\">Liquid to liquid<br>(dual pass recommended)</td>
      <td style=\"text-align: left;\"></td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Liquids</td>
      <td style=\"text-align: right;\">DI water, PG25</td>
      <td style=\"text-align: left;\"></td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">CDU dimensions<br>W x H x D</td>
      <td style=\"text-align: right;\">65.25 x 91.44 x 42.29<br>1.657 x 2.323 x 1.074</td>
      <td style=\"text-align: left;\">inches<br>m</td>
    </tr>
  </tbody>
</table>
<div>
  <strong>Assumptions &amp; Calculations:</strong>
  <ul>
    <li><strong>Volume to Mass Conversion:</strong> 500 GPM is equivalent to 0.031545 m&sup3;/s.</li>
    <li><strong>IT Loop (DI Water):</strong> Density at 20 &deg;C is assumed to be <strong>998 kg/m&sup3;</strong>, resulting in a mass flow of 31.48 kg/s. Specific heat capacity (c<sub>p</sub>) is assumed to be <strong>4.18 kJ/(kg&middot;K)</strong>.</li>
    <li><strong>Facility Loop (PG25):</strong> Density of 25% Propylene Glycol at 20 &deg;C is assumed to be <strong>1024 kg/m&sup3;</strong>, resulting in a mass flow of 32.30 kg/s.</li>
    <li><strong>Temperature Calculation:</strong> Assuming the 45 &deg;C \"from the IT loop\" refers to the hot return fluid entering the CDU from the servers. To dissipate the 2000 kW thermal load at 31.48 kg/s flow, the water must cool by 15.2 &deg;C (&Delta;T = 2000 / (31.48 &times; 4.18)). This makes the IT loop supply temperature 29.8 &deg;C. Applying the 3 K approach temperature (T<sub>IT,supply</sub> - T<sub>Facility,entering</sub>), the required entering temperature from the facility loop is <strong>26.8 &deg;C</strong>. <em>(Note: If the 45 &deg;C was meant as the supply temperature to the IT loop, the facility entering temperature would simply be 42 &deg;C).</em></li>
  </ul>
</div>
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
