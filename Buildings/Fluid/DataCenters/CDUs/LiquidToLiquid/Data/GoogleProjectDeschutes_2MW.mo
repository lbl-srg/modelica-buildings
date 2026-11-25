within Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data;
record GoogleProjectDeschutes_2MW
  "Data record for a Google Project Deschutes CDU"
  extends Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.Generic_epsNTU(
    Q_flow_nominal=-2E6,
    mRac_flow_nominal=32.04,
    mPla_flow_nominal=31.45,
    TApp_nominal=3,
    TRacOut_nominal=273.15 + 29.8,
    dpHexPla_nominal=53000,
    dpHexRac_nominal=60000,
    dpFilRac_nominal=46000,
    medPla=Buildings.Fluid.DataCenters.CDUs.Types.Media.Water,
    medRac=Buildings.Fluid.DataCenters.CDUs.Types.Media.PropyleneGlycol,
    phiGlyRac=0.25,
    dpPumpExt_nominal=586000,
    pumpExtHead(
      V_flow=mRac_flow_nominal/rhoRac_default*{0.00, 0.25, 0.50, 0.75, 1.00, 1.30},
      dp={852000, 850000, 845500, 842000, 838200, 817400}
        - {r^nRac*dpHexRac_nominal + r^nFilRac*dpFilRac_nominal
           for r in {0.00, 0.25, 0.50, 0.75, 1.00, 1.30}}),
    pumpEfficiency(
      V_flow=mRac_flow_nominal/rhoRac_default*{1},
      eta={0.658}));

  annotation (
  defaultComponentName="datCDU",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
This data record is for the 5th-generation CDU of Google, named
<em>Project Deschutes</em>. This unit is specified for the following data
(Google and Open Compute Project, 2026):
</p>
<table summary=\"Google Project Deschutes CDU specifications\">
  <thead>
    <tr>
      <th style=\"text-align: left;\">Description</th>
      <th style=\"text-align: right;\">Value</th>
      <th style=\"text-align: left;\">Unit</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style=\"text-align: left;\">IT loop flow</td>
      <td style=\"text-align: right;\">500<br/>32.04</td>
      <td style=\"text-align: left;\">GPM<br/>kg/s (PG25 at 29.8 &deg;C)</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Facility loop flow</td>
      <td style=\"text-align: right;\">500<br/>31.45</td>
      <td style=\"text-align: left;\">GPM<br/>kg/s (water at 26.8 &deg;C)</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">IT loop dP available (set point range)</td>
      <td style=\"text-align: right;\">80-90<br/>551,581 - 620,528</td>
      <td style=\"text-align: left;\">psi<br/>Pa</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">IT loop dP available at 500 GPM (2 pumps, 100% speed)</td>
      <td style=\"text-align: right;\">106.2<br/>732,200</td>
      <td style=\"text-align: left;\">psi<br/>Pa</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Facility loop dP (100% open control valve at 500 GPM)</td>
      <td style=\"text-align: right;\">15.3<br/>105,540</td>
      <td style=\"text-align: left;\">psi<br/>Pa</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Secondary heat exchanger dP at 500 GPM</td>
      <td style=\"text-align: right;\">8.67<br/>59,760</td>
      <td style=\"text-align: left;\">psi<br/>Pa</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Thermal load</td>
      <td style=\"text-align: right;\">2000</td>
      <td style=\"text-align: left;\">kW</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Approach temperature</td>
      <td style=\"text-align: right;\">3</td>
      <td style=\"text-align: left;\">&deg;C</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Facility loop entering temperature</td>
      <td style=\"text-align: right;\">26.8</td>
      <td style=\"text-align: left;\">&deg;C</td>
    </tr>
    <tr>
      <td style=\"text-align: left;\">Maximum power consumption (2 pumps rated 37 kW each)</td>
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
<p>
The rack-side pump curve <code>pumpExtHead</code> models 2 sealless pumps
(SPECK TOEMA065200) operating in parallel at full speed with internal filtration
(Figure 5.1.1 of Google and Open Compute Project, 2026).
The nominal external head <code>dpPumpExt_nominal</code> is set to the midpoint of
the specified available differential pressure range.
On the facility side, the total primary pressure drop at 100% control valve opening
is split equally between <code>dpHexPla_nominal</code> and <code>dpValve_nominal</code>
to achieve a valve authority of <i>0.5</i>.
</p>
<h4>References</h4>
<ul>
<li>
Google and Open Compute Project,
<a href=\"https://www.opencompute.org/documents/ocp-specification-deschutes-v1-0-pdf/\">
Project Deschutes: Data Center Facilities, Version 1.0.0</a>,
February 26, 2026.
</li>
<li>
Hussam Kabbani,
<a href=\"https://arpa-e.energy.gov/sites/default/files/2026-01/Day1_06b_Google_Kabbani.pdf\">
Project Deschutes: A 2MW CDU</a>,
ARPA-E COOLERCHIPS Meeting, November 20-21, 2025.
</li>
<li>
OCP 2026. Open Compute Project meeting,
<a href=\"https://www.opencompute.org/projects/cooling-environments/coolant-distribution-unit/\">
CDU Information WP</a>. March 24, 2026.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 24, 2026, by Michael Wetter:<br/>
Updated nominal mass flow rates, primary and secondary heat exchanger and filter
pressure drops, 2-pump external head curve, and pump efficiency to match the
Project Deschutes Version 1.0.0 specification, and added links to the specifications.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4926\">Buildings, #4926</a>.
</li>
<li>
November 13, 2026, by Michael Wetter:<br/>
Aligned <code>TRacOut_nominal</code> and <code>dpPumpExt_nominal</code> with the
specification table, and updated <code>pumpExtHead</code> to avoid an unphysical
shutoff head.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4926\">Buildings, #4926</a>.
</li>
<li>
October 17, 2026, by Nauman Rafique:<br/>
Corrected sign of <code>Q_flow_nominal</code>.<br/>
Added nominal mass flow rates from the specification table.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4787\">Buildings, #4787</a>.
</li>
<li>
April 13, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end GoogleProjectDeschutes_2MW;
