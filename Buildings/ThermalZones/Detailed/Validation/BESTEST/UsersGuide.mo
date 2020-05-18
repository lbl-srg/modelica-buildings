within Buildings.ThermalZones.Detailed.Validation.BESTEST;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation(preferredView="info",
  Documentation(info="<html>
<p>
The package <a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.BESTEST\">
Buildings.ThermalZones.Detailed.Validation.BESTEST</a> contains the models
that were used for the BESTEST validation (ANSI/ASHRAE 2007). The basic model from which all other
models extend from is <a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600FF\">
Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600FF</a>.
</p>
<p>
All examples have a script that runs an annual simulation and
plots the results with the minimum, mean and maximum value
listed in the ANSI/ASHRAE Standard 140-2007.
</p>
<p>
The script compares the following quantities:
</p>
<ul>
<li>
For free floating cases, the annual hourly integrated minimum (and maximum)
zone air temperature, and the annual mean zone air temperature.
</li>
<li>
For cases with heating and cooling, the annual heating and cooling energy,
and the annual hourly integrated minimum (and maximum) peak heating and cooling power.
</li>
</ul>
<p>
Note that in addition to the BESTESTs, the window model has been validated separately
in Nouidui et al. (2012).
</p>
<h4>Implementation</h4>
<p>
Heating and cooling is controlled using the PI controller
<a href=\"modelica://Buildings.Controls.Continuous.LimPID\">
Buildings.Controls.Continuous.LimPID</a>
with anti-windup.
</p>
<p>
Hourly averaged values and annual mean values are computed using an instance of
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.MovingMean\">
Buildings.Controls.OBC.CDL.Continuous.MovingMean</a>.
</p>
<h4>Validation results</h4>
<p>
The data used for validation are from \"RESULTS5-2A.xlsx\" in folder \"/Sec5-2AFiles/Informative Materials\"
of <a href=\"https://xp20.ashrae.org/140-2017/\">Supplemental Files for ANSI/ASHRAE Standard 140-2017,
Standard Method of Test for the Evaluation of Building Energy Analysis Computer Programs</a>.
</p>

<h5>Heating and cooling cases</h5>
<p>
The simulations of cases with heating and cooling are validated by comparing the
annual heating and cooling energy, the peak heating and cooling demand with the validation
data. In addition, one day load profiles are also validated.
The detailed comparison, which also shows the peak load hours, are shown
in the table after the plots below.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/annual_cooling.png\"
     alt=\"annual_cooling.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/annual_heating.png\"
     alt=\"annual_heating.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/peak_cooling.png\"
     alt=\"peak_cooling.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/peak_heating.png\"
     alt=\"peak_heating.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/hourly_load_600_Jan4.png\"
     alt=\"hourly_load_600_Jan4.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/hourly_load_900_Jan4.png\"
     alt=\"hourly_load_900_Jan4.png\" />
</p>
<!-- table start: load data -->
<table border = \"1\" summary=\"Annual load\">
<tr><td colspan=\"10\"><b>Annual heating load (MWh)</b></td></tr>
<tr>
<th>Case</th>
<th>ESP/DMU</th>
<th>BLAST/US-IT</th>
<th>DOE21D/NREL</th>
<th>SRES-SUN/NREL</th>
<th>SRES/BRE</th>
<th>S3PAS/SPAIN</th>
<th>TSYS/BEL-BRE</th>
<th>TASE/FINLAND</th>
<th>MBL/LBNL</th>
</tr><tr>
<td>Case600</td>
<td>4.296</td>
<td>4.773</td>
<td>5.709</td>
<td>5.226</td>
<td>5.596</td>
<td>4.882</td>
<td>4.872</td>
<td>5.362</td>
<td>5.292</td>
</tr>
<tr>
<td>Case610</td>
<td>4.355</td>
<td>4.806</td>
<td>5.786</td>
<td>5.280</td>
<td>5.620</td>
<td>4.971</td>
<td>4.970</td>
<td>5.383</td>
<td>5.320</td>
</tr>
<tr>
<td>Case620</td>
<td>4.613</td>
<td>5.049</td>
<td>5.944</td>
<td>5.554</td>
<td>5.734</td>
<td>5.564</td>
<td>5.073</td>
<td>5.728</td>
<td>5.454</td>
</tr>
<tr>
<td>Case630</td>
<td>5.050</td>
<td>5.359</td>
<td>6.469</td>
<td>5.883</td>
<td>6.001</td>
<td>6.095</td>
<td>5.624</td>
<td>0.000</td>
<td>5.713</td>
</tr>
<tr>
<td>Case640</td>
<td>2.751</td>
<td>2.888</td>
<td>3.543</td>
<td>3.255</td>
<td>3.803</td>
<td>3.065</td>
<td>3.043</td>
<td>3.309</td>
<td>3.429</td>
</tr>
<tr>
<td>Case650</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
</tr>
<tr>
<td>Case900</td>
<td>1.170</td>
<td>1.610</td>
<td>1.872</td>
<td>1.897</td>
<td>1.988</td>
<td>1.730</td>
<td>1.655</td>
<td>2.041</td>
<td>1.788</td>
</tr>
<tr>
<td>Case920</td>
<td>3.313</td>
<td>3.752</td>
<td>4.255</td>
<td>4.093</td>
<td>4.058</td>
<td>4.235</td>
<td>3.776</td>
<td>4.300</td>
<td>3.901</td>
</tr>
<tr>
<td>Case940</td>
<td>0.793</td>
<td>1.021</td>
<td>1.239</td>
<td>1.231</td>
<td>1.411</td>
<td>1.179</td>
<td>1.080</td>
<td>1.323</td>
<td>1.186</td>
</tr>
<tr>
<td>Case950</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
</tr>
<tr>
<td>Case960</td>
<td>2.311</td>
<td>2.664</td>
<td>2.928</td>
<td>2.884</td>
<td>2.851</td>
<td>2.943</td>
<td>3.373</td>
<td>2.816</td>
<td>3.100</td>
</tr>
<tr><td colspan=\"10\"><b>Annual cooling load (MWh)</b></td></tr>
<tr>
<th>Case</th>
<th>ESP/DMU</th>
<th>BLAST/US-IT</th>
<th>DOE21D/NREL</th>
<th>SRES-SUN/NREL</th>
<th>SRES/BRE</th>
<th>S3PAS/SPAIN</th>
<th>TSYS/BEL-BRE</th>
<th>TASE/FINLAND</th>
<th>MBL/LBNL</th>
</tr><tr>
<td>Case600</td>
<td>6.137</td>
<td>6.433</td>
<td>7.079</td>
<td>7.278</td>
<td>7.964</td>
<td>6.492</td>
<td>6.492</td>
<td>6.778</td>
<td>6.687</td>
</tr>
<tr>
<td>Case610</td>
<td>3.915</td>
<td>4.851</td>
<td>4.852</td>
<td>5.448</td>
<td>5.778</td>
<td>4.764</td>
<td>4.601</td>
<td>5.506</td>
<td>5.168</td>
</tr>
<tr>
<td>Case620</td>
<td>3.417</td>
<td>4.092</td>
<td>4.334</td>
<td>4.633</td>
<td>5.004</td>
<td>4.011</td>
<td>3.901</td>
<td>4.351</td>
<td>4.113</td>
</tr>
<tr>
<td>Case630</td>
<td>2.129</td>
<td>3.108</td>
<td>2.489</td>
<td>3.493</td>
<td>3.701</td>
<td>2.489</td>
<td>2.416</td>
<td>0.000</td>
<td>3.179</td>
</tr>
<tr>
<td>Case640</td>
<td>5.952</td>
<td>6.183</td>
<td>6.759</td>
<td>7.026</td>
<td>7.811</td>
<td>6.247</td>
<td>6.246</td>
<td>6.508</td>
<td>6.472</td>
</tr>
<tr>
<td>Case650</td>
<td>4.816</td>
<td>5.140</td>
<td>5.795</td>
<td>5.894</td>
<td>6.545</td>
<td>5.088</td>
<td>5.119</td>
<td>5.456</td>
<td>5.363</td>
</tr>
<tr>
<td>Case900</td>
<td>2.132</td>
<td>2.600</td>
<td>2.455</td>
<td>3.165</td>
<td>3.415</td>
<td>2.572</td>
<td>2.485</td>
<td>2.599</td>
<td>2.192</td>
</tr>
<tr>
<td>Case920</td>
<td>1.840</td>
<td>2.616</td>
<td>2.440</td>
<td>2.943</td>
<td>3.092</td>
<td>2.457</td>
<td>2.418</td>
<td>2.613</td>
<td>2.308</td>
</tr>
<tr>
<td>Case940</td>
<td>2.079</td>
<td>2.536</td>
<td>2.340</td>
<td>3.036</td>
<td>3.241</td>
<td>2.489</td>
<td>2.383</td>
<td>2.516</td>
<td>2.113</td>
</tr>
<tr>
<td>Case950</td>
<td>0.387</td>
<td>0.526</td>
<td>0.538</td>
<td>0.921</td>
<td>0.589</td>
<td>0.551</td>
<td>0.561</td>
<td>0.771</td>
<td>0.473</td>
</tr>
<tr>
<td>Case960</td>
<td>0.488</td>
<td>0.666</td>
<td>0.428</td>
<td>0.803</td>
<td>0.718</td>
<td>0.643</td>
<td>0.411</td>
<td>0.786</td>
<td>0.615</td>
</tr>
</table>
<br/>
<table border = \"1\" summary=\"Peak load\">
<tr><td colspan=\"17\"><b>Peak heating load (kW)</b></td></tr>
<tr>
<th rowspan=\"2\">Case</th>
<th colspan=\"2\">ESP/DMU</th>
<th colspan=\"2\">BLAST/US-IT</th>
<th colspan=\"2\">DOE21D/NREL</th>
<th colspan=\"2\">SRES-SUN/NREL</th>
<th colspan=\"2\">S3PAS/SPAIN</th>
<th colspan=\"2\">TSYS/BEL-BRE</th>
<th colspan=\"2\">TASE/FINLAND</th>
<th colspan=\"2\">MBL/LBNL</th>
</tr>
<tr>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
</tr><tr>
<td>Case600</td>
<td>3.437</td>
<td>04-Jan:5</td>
<td>3.940</td>
<td>04-Jan:5</td>
<td>4.045</td>
<td>04-Jan:5</td>
<td>4.258</td>
<td>04-Jan:2</td>
<td>4.037</td>
<td>04-Jan:2</td>
<td>3.931</td>
<td>04-Jan:6</td>
<td>4.354</td>
<td>04-Jan:2</td>
<td>4.172</td>
<td>4-Jan:6</td>
</tr>
<tr>
<td>Case610</td>
<td>3.437</td>
<td>04-Jan:5</td>
<td>3.941</td>
<td>04-Jan:5</td>
<td>4.034</td>
<td>04-Jan:5</td>
<td>4.258</td>
<td>04-Jan:2</td>
<td>4.037</td>
<td>04-Jan:2</td>
<td>3.922</td>
<td>04-Jan:6</td>
<td>4.354</td>
<td>04-Jan:2</td>
<td>4.172</td>
<td>4-Jan:6</td>
</tr>
<tr>
<td>Case620</td>
<td>3.591</td>
<td>04-Jan:6</td>
<td>3.941</td>
<td>04-Jan:5</td>
<td>4.046</td>
<td>04-Jan:5</td>
<td>4.277</td>
<td>04-Jan:2</td>
<td>4.277</td>
<td>04-Jan:2</td>
<td>3.922</td>
<td>04-Jan:6</td>
<td>4.379</td>
<td>04-Jan:2</td>
<td>4.172</td>
<td>4-Jan:6</td>
</tr>
<tr>
<td>Case630</td>
<td>3.592</td>
<td>04-Jan:7</td>
<td>3.941</td>
<td>04-Jan:5</td>
<td>4.025</td>
<td>04-Jan:5</td>
<td>4.280</td>
<td>04-Jan:2</td>
<td>4.278</td>
<td>04-Jan:2</td>
<td>3.922</td>
<td>04-Jan:6</td>
<td>0.000</td>
<td>N/A</td>
<td>4.172</td>
<td>4-Jan:6</td>
</tr>
<tr>
<td>Case640</td>
<td>5.232</td>
<td>04-Jan:7</td>
<td>5.486</td>
<td>04-Jan:8</td>
<td>5.943</td>
<td>04-Jan:8</td>
<td>6.530</td>
<td>04-Jan:8</td>
<td>6.347</td>
<td>04-Jan:8</td>
<td>5.722</td>
<td>04-Jan:8</td>
<td>6.954</td>
<td>04-Jan:8</td>
<td>6.957</td>
<td>4-Jan:8</td>
</tr>
<tr>
<td>Case650</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>04-Jan:N/A</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case900</td>
<td>2.850</td>
<td>04-Jan:7</td>
<td>3.453</td>
<td>04-Jan:7</td>
<td>3.557</td>
<td>04-Jan:7</td>
<td>3.760</td>
<td>04-Jan:7</td>
<td>3.608</td>
<td>04-Jan:8</td>
<td>3.517</td>
<td>04-Jan:7</td>
<td>3.797</td>
<td>04-Jan:7</td>
<td>3.579</td>
<td>4-Jan:7</td>
</tr>
<tr>
<td>Case920</td>
<td>3.308</td>
<td>04-Jan:7</td>
<td>3.703</td>
<td>04-Jan:7</td>
<td>3.805</td>
<td>04-Jan:7</td>
<td>4.013</td>
<td>04-Jan:7</td>
<td>4.029</td>
<td>04-Jan:7</td>
<td>3.708</td>
<td>04-Jan:7</td>
<td>4.061</td>
<td>04-Jan:7</td>
<td>3.885</td>
<td>4-Jan:7</td>
</tr>
<tr>
<td>Case940</td>
<td>3.980</td>
<td>04-Jan:7</td>
<td>5.028</td>
<td>04-Jan:8</td>
<td>5.665</td>
<td>04-Jan:8</td>
<td>6.116</td>
<td>04-Jan:8</td>
<td>6.117</td>
<td>04-Jan:8</td>
<td>5.122</td>
<td>03-Jan:9</td>
<td>6.428</td>
<td>04-Jan:8</td>
<td>6.017</td>
<td>4-Jan:8</td>
</tr>
<tr>
<td>Case950</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case960</td>
<td>2.410</td>
<td>04-Jan:7</td>
<td>2.751</td>
<td>04-Jan:8</td>
<td>2.727</td>
<td>04-Jan:8</td>
<td>2.863</td>
<td>04-Jan:8</td>
<td>2.852</td>
<td>04-Jan:8</td>
<td>2.522</td>
<td>04-Jan:8</td>
<td>2.779</td>
<td>04-Jan:8</td>
<td>2.880</td>
<td>4-Jan:8</td>
</tr>
<tr><td colspan=\"17\"><b>Peak cooling load (kW)</b></td></tr>
<tr>
<th rowspan=\"2\">Case</th>
<th colspan=\"2\">ESP/DMU</th>
<th colspan=\"2\">BLAST/US-IT</th>
<th colspan=\"2\">DOE21D/NREL</th>
<th colspan=\"2\">SRES-SUN/NREL</th>
<th colspan=\"2\">S3PAS/SPAIN</th>
<th colspan=\"2\">TSYS/BEL-BRE</th>
<th colspan=\"2\">TASE/FINLAND</th>
<th colspan=\"2\">MBL/LBNL</th>
</tr>
<tr>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
</tr><tr>
<td>Case600</td>
<td>6.194</td>
<td>17-Oct:13</td>
<td>5.965</td>
<td>16-Oct:14</td>
<td>6.656</td>
<td>16-Oct:13</td>
<td>6.827</td>
<td>16-Oct:14</td>
<td>6.286</td>
<td>25-Nov:14</td>
<td>6.486</td>
<td>16-Oct:14</td>
<td>6.812</td>
<td>17-Oct:14</td>
<td>6.597</td>
<td>17-Oct:13</td>
</tr>
<tr>
<td>Case610</td>
<td>5.669</td>
<td>25-Nov:13</td>
<td>5.824</td>
<td>25-Nov:14</td>
<td>6.064</td>
<td>13-Jan:14</td>
<td>6.371</td>
<td>25-Nov:14</td>
<td>6.170</td>
<td>25-Nov:14</td>
<td>5.675</td>
<td>25-Nov:14</td>
<td>6.146</td>
<td>17-Oct:14</td>
<td>6.254</td>
<td>25-Nov:13</td>
</tr>
<tr>
<td>Case620</td>
<td>3.634</td>
<td>26-Jul:16</td>
<td>4.075</td>
<td>26-Jul:17</td>
<td>4.430</td>
<td>26-Jul:17</td>
<td>4.593</td>
<td>26-Jul:17</td>
<td>4.297</td>
<td>26-Jul:17</td>
<td>4.275</td>
<td>26-Jul:17</td>
<td>5.096</td>
<td>26-Jul:16</td>
<td>4.033</td>
<td>26-Jul:17</td>
</tr>
<tr>
<td>Case630</td>
<td>3.072</td>
<td>26-Jul:16</td>
<td>3.704</td>
<td>26-Jul:17</td>
<td>3.588</td>
<td>26-Jul:17</td>
<td>4.116</td>
<td>26-Jul:17</td>
<td>3.665</td>
<td>26-Jul:17</td>
<td>3.608</td>
<td>26-Jul:17</td>
<td>0.000</td>
<td>N/A</td>
<td>3.548</td>
<td>26-Jul:17</td>
</tr>
<tr>
<td>Case640</td>
<td>6.161</td>
<td>17-Oct:13</td>
<td>5.892</td>
<td>16-Oct:14</td>
<td>6.576</td>
<td>16-Oct:14</td>
<td>6.776</td>
<td>16-Oct:14</td>
<td>6.250</td>
<td>25-Nov:14</td>
<td>6.442</td>
<td>16-Oct:14</td>
<td>6.771</td>
<td>17-Oct:14</td>
<td>6.539</td>
<td>17-Oct:13</td>
</tr>
<tr>
<td>Case650</td>
<td>6.031</td>
<td>17-Oct:13</td>
<td>5.831</td>
<td>16-Oct:14</td>
<td>6.516</td>
<td>16-Oct:14</td>
<td>6.671</td>
<td>16-Oct:14</td>
<td>6.143</td>
<td>25-Nov:14</td>
<td>6.378</td>
<td>17-Oct:14</td>
<td>6.679</td>
<td>17-Oct:14</td>
<td>6.475</td>
<td>17-Oct:14</td>
</tr>
<tr>
<td>Case900</td>
<td>2.888</td>
<td>17-Oct:14</td>
<td>3.155</td>
<td>06-Oct:15</td>
<td>3.458</td>
<td>17-Oct:14</td>
<td>3.871</td>
<td>17-Oct:14</td>
<td>3.334</td>
<td>17-Oct:15</td>
<td>3.567</td>
<td>17-Oct:15</td>
<td>3.457</td>
<td>17-Oct:15</td>
<td>3.124</td>
<td>17-Oct:15</td>
</tr>
<tr>
<td>Case920</td>
<td>2.385</td>
<td>26-Jul:16</td>
<td>2.933</td>
<td>26-Jul:17</td>
<td>3.109</td>
<td>26-Jul:17</td>
<td>3.487</td>
<td>26-Jul:17</td>
<td>3.071</td>
<td>26-Jul:17</td>
<td>3.050</td>
<td>26-Jul:17</td>
<td>3.505</td>
<td>26-Jul:17</td>
<td>2.849</td>
<td>26-Jul:17</td>
</tr>
<tr>
<td>Case940</td>
<td>2.888</td>
<td>17-Oct:14</td>
<td>3.155</td>
<td>06-Oct:15</td>
<td>3.458</td>
<td>17-Oct:14</td>
<td>3.871</td>
<td>17-Oct:14</td>
<td>3.334</td>
<td>17-Oct:15</td>
<td>3.567</td>
<td>17-Oct:15</td>
<td>3.457</td>
<td>17-Oct:15</td>
<td>3.124</td>
<td>17-Oct:15</td>
</tr>
<tr>
<td>Case950</td>
<td>2.033</td>
<td>02-Sep:14</td>
<td>2.621</td>
<td>02-Sep:15</td>
<td>2.664</td>
<td>02-Sep:15</td>
<td>3.170</td>
<td>02-Sep:14</td>
<td>2.677</td>
<td>02-Sep:15</td>
<td>2.686</td>
<td>02-Sep:15</td>
<td>2.867</td>
<td>02-Sep:14</td>
<td>2.425</td>
<td>2-Sep:15</td>
</tr>
<tr>
<td>Case960</td>
<td>0.953</td>
<td>16-Aug:16</td>
<td>1.144</td>
<td>26-Jul:16</td>
<td>1.057</td>
<td>26-Jul:16</td>
<td>1.370</td>
<td>26-Jul:16</td>
<td>1.179</td>
<td>26-Jul:16</td>
<td>1.378</td>
<td>26-Jul:16</td>
<td>1.403</td>
<td>26-Jul:16</td>
<td>1.252</td>
<td>27-Jul:16</td>
</tr>
</table>
<br/>
<!-- table end: load data -->

<h5>Free floating cases</h5>
<p>
The following plots compare the maximum, minimum and average zone temperature simulated with
the Modelica Buildings Library with the values simulated by other tools. The simulation
is also validated by comparing one-day simulation results in different days, and by
comparing the distribution of the annual temperature. The detailed comparisons, which also
show the peak temperature hour, are shown in the table after the plots.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/max_temperature.png\"
     alt=\"max_temperature.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/min_temperature.png\"
     alt=\"min_temperature.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/FF_temperature_600FF_Jan4.png\"
     alt=\"FF_temperature_600FF_Jan4.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/FF_temperature_900FF_Jan4.png\"
     alt=\"FF_temperature_900FF_Jan4.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/FF_temperature_650FF_Jul27.png\"
     alt=\"FF_temperature_650FF_Jul27.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/FF_temperature_950FF_Jul27.png\"
     alt=\"FF_temperature_950FF_Jul27.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/ave_temperature.png\"
     alt=\"ave_temperature.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/bin_temperature_900FF.png\"
     alt=\"bin_temperature_900FF.png\" />
</p>

<!-- table start: free float data -->
<table border = \"1\" summary=\"Peak temperature\">
<tr><td colspan=\"17\"><b>Maximum temperature (&deg;C)</b></td></tr>
<tr>
<th rowspan=\"2\">Case</th>
<th colspan=\"2\">ESP/DMU</th>
<th colspan=\"2\">BLAST/US-IT</th>
<th colspan=\"2\">DOE21D/NREL</th>
<th colspan=\"2\">SRES-SUN/NREL</th>
<th colspan=\"2\">S3PAS/SPAIN</th>
<th colspan=\"2\">TSYS/BEL-BRE</th>
<th colspan=\"2\">TASE/FINLAND</th>
<th colspan=\"2\">MBL/LBNL</th>
</tr>
<tr>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
</tr><tr>
<td>Case600FF</td>
<td>64.9</td>
<td>17-Oct:15</td>
<td>65.1</td>
<td>16-Oct:15</td>
<td>69.5</td>
<td>17-Oct:15</td>
<td>68.6</td>
<td>16-Oct:15</td>
<td>64.9</td>
<td>16-Oct:16</td>
<td>65.3</td>
<td>17-Oct:16</td>
<td>65.3</td>
<td>15-Oct:16</td>
<td>65.3</td>
<td>17-Oct:16</td>
</tr>
<tr>
<td>Case650FF</td>
<td>63.2</td>
<td>17-Oct:15</td>
<td>63.5</td>
<td>16-Oct:15</td>
<td>68.2</td>
<td>17-Oct:15</td>
<td>67.0</td>
<td>16-Oct:15</td>
<td>63.3</td>
<td>16-Oct:16</td>
<td>63.7</td>
<td>17-Oct:16</td>
<td>63.8</td>
<td>16-Oct:16</td>
<td>64.0</td>
<td>17-Oct:16</td>
</tr>
<tr>
<td>Case900FF</td>
<td>41.8</td>
<td>17-Oct:15</td>
<td>43.4</td>
<td>02-Sep:16</td>
<td>42.7</td>
<td>02-Sep:15</td>
<td>44.8</td>
<td>02-Sep:15</td>
<td>43.0</td>
<td>02-Sep:15</td>
<td>42.5</td>
<td>17-Oct:15</td>
<td>43.2</td>
<td>15-Sep:15</td>
<td>42.2</td>
<td>2-Sep:16</td>
</tr>
<tr>
<td>Case950FF</td>
<td>35.5</td>
<td>02-Sep:16</td>
<td>36.2</td>
<td>02-Sep:16</td>
<td>35.9</td>
<td>02-Sep:16</td>
<td>38.5</td>
<td>02-Sep:15</td>
<td>36.1</td>
<td>02-Sep:16</td>
<td>35.7</td>
<td>02-Sep:15</td>
<td>37.6</td>
<td>15-Sep:16</td>
<td>36.2</td>
<td>2-Sep:16</td>
</tr>
<tr><td colspan=\"17\"><b>Minimum temperature (&deg;C)</b></td></tr>
<tr>
<th rowspan=\"2\">Case</th>
<th colspan=\"2\">ESP/DMU</th>
<th colspan=\"2\">BLAST/US-IT</th>
<th colspan=\"2\">DOE21D/NREL</th>
<th colspan=\"2\">SRES-SUN/NREL</th>
<th colspan=\"2\">S3PAS/SPAIN</th>
<th colspan=\"2\">TSYS/BEL-BRE</th>
<th colspan=\"2\">TASE/FINLAND</th>
<th colspan=\"2\">MBL/LBNL</th>
</tr>
<tr>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
</tr><tr>
<td>Case600FF</td>
<td>-15.6</td>
<td>04-Jan:7</td>
<td>-17.1</td>
<td>04-Jan:8</td>
<td>-18.8</td>
<td>04-Jan:8</td>
<td>-18.0</td>
<td>04-Jan:7</td>
<td>-17.8</td>
<td>04-Jan:8</td>
<td>-17.8</td>
<td>04-Jan:7</td>
<td>-18.5</td>
<td>08-Jan:9</td>
<td>-19.0</td>
<td>4-Jan:8</td>
</tr>
<tr>
<td>Case650FF</td>
<td>-22.6</td>
<td>04-Jan:6</td>
<td>-23.0</td>
<td>04-Jan:7</td>
<td>-21.6</td>
<td>04-Jan:2</td>
<td>-23.0</td>
<td>04-Jan:2</td>
<td>-22.9</td>
<td>04-Jan:2</td>
<td>-22.8</td>
<td>04-Jan:7</td>
<td>-22.9</td>
<td>02-Jan:23</td>
<td>-23.3</td>
<td>4-Jan:3</td>
</tr>
<tr>
<td>Case900FF</td>
<td>-1.6</td>
<td>04-Jan:8</td>
<td>-3.2</td>
<td>04-Jan:8</td>
<td>-4.3</td>
<td>04-Jan:8</td>
<td>-4.5</td>
<td>04-Jan:8</td>
<td>-4.0</td>
<td>04-Jan:8</td>
<td>-6.4</td>
<td>04-Jan:8</td>
<td>-5.6</td>
<td>08-Jan:9</td>
<td>-5.3</td>
<td>4-Jan:8</td>
</tr>
<tr>
<td>Case950FF</td>
<td>-19.5</td>
<td>04-Jan:6</td>
<td>-20.0</td>
<td>04-Jan:7</td>
<td>-18.6</td>
<td>04-Jan:7</td>
<td>-19.7</td>
<td>04-Jan:7</td>
<td>-20.2</td>
<td>04-Jan:7</td>
<td>-19.3</td>
<td>04-Jan:7</td>
<td>-20.0</td>
<td>07-Jan:22</td>
<td>-20.6</td>
<td>4-Jan:7</td>
</tr>
</table>
<br/>
<!-- table end: free float data -->
<h4>Implementation</h4>
<p>
To generate the data shown in this user guide, run
</p>
<pre>
  cd Buildings/Resources/src/ThermalZones/Detailed/Validation/BESTEST
  python3 simulateAndPlot.py
</pre>
<h4>References</h4>
<p>
ANSI/ASHRAE. 2007. ANSI/ASHRAE Standard 140-2007,
Standard Method of Test for the Evaluation of Building Energy Analysis Computer Programs.
</p>
<p>
Thierry Stephane Nouidui, Michael Wetter, and Wangda Zuo.
<a href=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/2012-simBuild-windowValidation.pdf\">
Validation of the window model of the Modelica Buildings library.</a>
<i>Proc. of the 5th SimBuild Conference</i>, Madison, WI, USA, August 2012.
</p>
</html>"));
end UsersGuide;
