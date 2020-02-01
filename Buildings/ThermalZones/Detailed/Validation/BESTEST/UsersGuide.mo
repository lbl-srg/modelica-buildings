within Buildings.ThermalZones.Detailed.Validation.BESTEST;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation(preferredView="info",
  Documentation(info="<html>
  <p>
  The package <code>Buildings.ThermalZones.Detailed.Validation.BESTEST</code> contains the models 
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
  <p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/hourly_temp.png\"
       alt=\"hourly_temp.png\" />
  <img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/annual_temp.png\"
       alt=\"annual_temp.png\" />
  </p>
       
  <table border = \"1\" summary=\"Annual zone temperature\">
  <tr><td colspan=\"5\"><b>Maximum annual hourly zone temperature (&deg;C)</b>
      </td>
  </tr>
  <tr>
  <th>Case</th>
  <th>Maximum</th>
  <th>Minimum of Standard Maximum</th>
  <th>Maximum of Standard Maximum</th>
  <th>Mean of Standard Maximum</th>
  </tr>
  <tr>
  <td>Case600FF</td>
  <td>65.7</td>
  <td>64.9</td>
  <td>69.5</td>
  <td>66.2</td>
  </tr>
  <tr>
  <td>Case650FF</td>
  <td>64.5</td>
  <td>63.2</td>
  <td>68.2</td>
  <td>64.7</td>
  </tr>
  <tr>
  <td>Case900FF</td>
  <td>42.3</td>
  <td>41.6</td>
  <td>44.8</td>
  <td>43.1</td>
  </tr>
  <tr>
  <td>Case950FF</td>
  <td>36.2</td>
  <td>35.5</td>
  <td>38.5</td>
  <td>36.5</td>
  </tr>
  <tr><td colspan=\"5\"><b>Minimum annual hourly zone temperature (&deg;C)</b>
      </td>
  </tr>
  <tr>
  <th>Case</th>
  <th>Minimum</th>
  <th>Minimum of Standard Minimum</th>
  <th>Maximum of Standard Minimum</th>
  <th>Mean of Standard Minimum</th>
  </tr>
  <tr>
  <td>Case600FF</td>
  <td>-19.0</td>
  <td>-18.8</td>
  <td>-15.6</td>
  <td>-17.6</td>
  </tr>
  <tr>
  <td>Case650FF</td>
  <td>-23.4</td>
  <td>-23.0</td>
  <td>-21.6</td>
  <td>-22.7</td>
  </tr>
  <tr>
  <td>Case900FF</td>
  <td>-5.3</td>
  <td>-6.4</td>
  <td>-1.6</td>
  <td>-4.2</td>
  </tr>
  <tr>
  <td>Case950FF</td>
  <td>-20.6</td>
  <td>-20.2</td>
  <td>-18.6</td>
  <td>-19.6</td>
  </tr>
  <tr><td colspan=\"5\"><b>Annual mean zone temperature (&deg;C)</b>
      </td>
  </tr>
  <tr>
  <th>Case</th>
  <th>Mean</th>
  <th>Minimum of Standard Mean</th>
  <th>Maximum of Standard Mean</th>
  <th>Mean of Standard Mean</th>
  </tr>
  <tr>
  <td>Case600FF</td>
  <td>24.4</td>
  <td>24.2</td>
  <td>25.9</td>
  <td>25.1</td>
  </tr>
  <tr>
  <td>Case650FF</td>
  <td>18.1</td>
  <td>18.0</td>
  <td>19.6</td>
  <td>18.7</td>
  </tr>
  <tr>
  <td>Case900FF</td>
  <td>24.5</td>
  <td>24.5</td>
  <td>25.9</td>
  <td>25.2</td>
  </tr>
  <tr>
  <td>Case950FF</td>
  <td>13.8</td>
  <td>14.0</td>
  <td>15.0</td>
  <td>14.4</td>
  </tr>
  </table>
  <br/>
  <li>
  For cases with heating and cooling, the annual heating and cooling energy,
  and the annual hourly integrated minimum (and maximum) peak heating and cooling power.
  </li>
  <p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/annual_energy.png\"
       alt=\"annual_energy.png\" />
  <img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/peak_demand.png\"
       alt=\"peak_demand.png\" />
  </p>      
  </ul>
  <br/>
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
  <h4>References</h4>
  <p>
  ANSI/ASHRAE. 2007. ANSI/ASHRAE Standard 140-2007, Standard Method of Test for the Evaluation of Building Energy Analysis Computer Programs.
  </p>
  <p>
  Thierry Stephane Nouidui, Michael Wetter, and Wangda Zuo.
  <a href=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/2012-simBuild-windowValidation.pdf\">
  Validation of the window model of the Modelica Buildings library.</a>
  <i>Proc. of the 5th SimBuild Conference</i>, Madison, WI, USA, August 2012.
  </p>
  </html>"));
end UsersGuide;
