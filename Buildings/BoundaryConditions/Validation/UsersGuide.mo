within Buildings.BoundaryConditions.Validation;
package UsersGuide
  "User's Guide"
  extends Modelica.Icons.Information;
  annotation (
    preferredView="info",
    Documentation(
      info="<html>
<p>
The package <a href=\"modelica://Buildings.BoundaryConditions.Validation.BESTEST\">Buildings.BoundaryConditions.Validation.BESTEST</a>
contains the models that are used for the BESTEST validation ASHRAE 2020 for weather data acquisition and postprocessing.
</p>
<p>
Each model represents a different climate with different days as shown in the tables below.
All examples have a script that runs the simulation according to the specifications and derive the required Json file as reported below.
</p>
<p>
The weather radiation data has to be provided at different orientations and inclinations.
</p>
<p><i>Table 2:&nbsp;</i>Azimuth and Slope for Surfaces</p>
<table summary = \"Azimuth and Slope for Surfaces\" cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Azimuth</p></td>
<td><p>Slope</p></td>
</tr>
<tr>
<td><p>Horizontal</p></td>
<td><p>0&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>South</p></td>
<td><p>90&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>East</p></td>
<td><p>90&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>North</p></td>
<td><p>90&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>West</p></td>
<td><p>90&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>45&deg; East of South</p></td>
<td><p>90&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>45&deg; West of South</p></td>
<td><p>90&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>East</p></td>
<td><p>30&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>South</p></td>
<td><p>30&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>West</p></td>
<td><p>30&deg; from horizontal</p></td>
</tr>
</table>

<br><p><i>Additional parameters and correlations</i></p>
<ul>
<li>Ground reflectance &rho; is set to 0 for cases from WD100 to WD500 and 0.2 for WD600</li>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.SkyTemperature.BlackBody\">Sky black body temperature</a>
calculated using Horizontal radiation or dew point temperature and sky cover.
</li>
<li>Diffused radiation calculated using <a href=\"modelica://Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez\">Perez</a> and
<a href=\"modelica://Buildings.BoundaryConditions.SolarIrradiation.DiffuseIsotropic\">Isotropic</a> sky models</li>
</ul>
<h4>Outputs required</h4>
<p><i>Annual Outputs</i></p>
<p><b>&nbsp;</b>The following outputs are  provided for an annual simulation:</p>
<ul>
<li>Average dry bulb temperature (&deg;C)</li>
<li>Average relative humidity (%)</li>
<li>Average dewpoint temperature (&deg;C)</li>
<li>Average humidity ratio (kg moisture/kg dry air)</li>
<li>Average wet bulb temperature (&deg;C)</li>
<li>Sum of total, beam, and diffuse solar radiation incident on each surface (Wh/m2)</li>
</ul>
<br><p><i>Hourly Outputs</i></p>
<p>The following outputs are  provided for each hour of the days specified for each test case in Table 3:</p>
<ul>
<li>Dry bulb temperature (&deg;C)</li>
<li>Relative humidity (%)</li>
<li>Dewpoint temperature (&deg;C)</li>
<li>Humidity ratio (kg moisture/kg dry air)</li>
<li>Wet bulb temperature (&deg;C)</li>
<li>Windspeed (m/s)</li>
<li>Wind direction (degrees from north)</li>
<li>Station pressure (mbar)</li>
<li>Total cloud cover (tenths of sky)</li>
<li>Opaque cloud cover (tenths of sky)</li>
<li>Sky temperature (&deg;C)</li>
<li>Sum of total, beam, and diffuse solar radiation incident on each surface (Wh/m2)&nbsp;</li>
</ul>
<br><p><i>Table 3: Specific Days for Output</i></p>
<table summary = \"Specific Days for Output\" cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Case </p></td>
<td><p>Days</p></td>
</tr>
<tr>
<td><p>WD100 </p></td>
<td><p>May 4th, July 14th, September 6th</p></td>
</tr>
<tr>
<td><p>WD200 </p></td>
<td><p>May 24th, August 26th</p></td>
</tr>
<tr>
<td><p>WD300 </p></td>
<td><p>February 7th, August 13th</p></td>
</tr>
<tr>
<td><p>WD400 </p></td>
<td><p>January 24th, July 1st</p></td>
</tr>
<tr>
<td><p>WD500 </p></td>
<td><p>March 1st, September 14th</p></td>
</tr>
<tr>
<td><p>WD600 </p></td>
<td><p>May 4th, July 14th, September 6th</p></td>
</tr>
</table>
<br><p><i>Sub-hourly Outputs</i></p>
<p>The following outputs are  provided at each timestep of the days specified for each test case in Table 3:</p>
<ul>
<li>Dry bulb temperature (C)</li>
<li>Relative humidity (%)</li>
<li>Sum of total, beam, and diffuse solar radiation incident on each surface (Wh/m2) </li>
</ul>
<p>The following outputs are  provided integrated hourly for the days specified for each test case in Table 3:</p>
<ul>
<li>Total incident horizontal solar radiation (Wh/m2)</li>
<li>Total incident horizontal beam solar radiation (Wh/m2)</li>
<li>Total incident horizontal diffuse solar radiation (Wh/m2) </li>
</ul>
<h4>Validation results</h4>
<p>(Not available yet)</p>
<h4>Implementation</h4>
<p>To generate the data shown in this user guide, run </p>
<pre>
cd Buildings/Resources/Data/BoundaryConditions/Validation/BESTEST
python3 generateResults.py -p
</pre>
<p>At the beginning of the Python script there are several options that the user can choose, by default the script will:
</p>
<ul>
<li>Clone the last master branch of the Buildings repository into a temporary directory</li>
<li>Execute all the simulations and create the folders with the .mat and .json files inside the BESTEST/Simulations folder</li>
</ul>
<h4>References</h4>
<p>(Not available yet)</p>
</html>",
      revisions="<html>
<ul>
<li>
March 11, 2020, by Ettore Zanetti:<br/>
first implementation of BESTEST weather validation
</li>
</ul>
</html>"));
end UsersGuide;
