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
  <p>Following plots shows the results of free floating cases. The first plot shows
  whether the simuations track the zone air temperature within minimium and maximum
  values published in the BESTEST.
  The annual mean zone air temperatures are shown in the second plot. It checks whether
  the annual mean zone air temperature (last value of the data set) is
  within the standard minimum and maximum values. The detailed comparisons are
  shown in the table below.
  </p>
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
  <th>Standard_Maximum<sub>min</sub></th>
  <th>Standard_Maximum<sub>max</sub></th>
  <th>Standard_Maximum<sub>mean</sub></th>
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
  <th>Standard_Minimum<sub>min</sub></th>
  <th>Standard_Minimum<sub>max</sub></th>
  <th>Standard_Minimum<sub>mean</sub></th>
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
  <th>Standard_Mean<sub>min</sub></th>
  <th>Standard_Mean<sub>max</sub></th>
  <th>Standard_Mean<sub>mean</sub></th>
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
  <p>
  The plots below shows the results for the cases with heating and cooling. They compare
  the annual heating and cooling energy, peak heating and cooling demand with their
  corresponding minimum and maximum values from the standard. The detailed comparisons are
  shown in the table below.
  </p>
  <p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/annual_energy.png\"
       alt=\"annual_energy.png\" />
  <img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/peak_demand.png\"
       alt=\"peak_demand.png\" />
  </p>
  <table border = \"1\" summary=\"Annual energy and peak load\">
  <tr><td colspan=\"9\"><b>Annual energy (MWh)</b>
      </td>
  </tr>
  <tr>
  <th rowspan=\"2\" valign=\"middle\">Case</th>
  <th colspan=\"4\">Heating</th>
  <th colspan=\"4\">Cooling</th>
  </tr>
  <tr>
  <td><b>Energy</b></td>
  <td><b>Standard_Minimum</b></td>
  <td><b>Standard_Maximum</b></td>
  <td><b>Standard_Mean</b></td>
  <td><b>Energy</b></td>
  <td><b>Standard_Minimum</b></td>
  <td><b>Standard_Maximum</b></td>
  <td><b>Standard_Mean</b></td>
  </tr>
  <tr>
<td>Case600</td>
<td>5.3</td>
<td>4.3</td>
<td>5.7</td>
<td>5.1</td>
<td>6.7</td>
<td>6.1</td>
<td>8.0</td>
<td>6.8</td>
</tr>
<tr>
<td>Case610</td>
<td>5.3</td>
<td>4.4</td>
<td>5.8</td>
<td>5.1</td>
<td>5.2</td>
<td>3.9</td>
<td>5.8</td>
<td>5.0</td>
</tr>
<tr>
<td>Case620</td>
<td>5.5</td>
<td>4.6</td>
<td>5.9</td>
<td>5.4</td>
<td>4.1</td>
<td>3.4</td>
<td>5.0</td>
<td>4.2</td>
</tr>
<tr>
<td>Case630</td>
<td>5.7</td>
<td>5.0</td>
<td>6.5</td>
<td>5.8</td>
<td>3.2</td>
<td>2.1</td>
<td>3.7</td>
<td>2.8</td>
</tr>
<tr>
<td>Case640</td>
<td>3.4</td>
<td>2.8</td>
<td>3.8</td>
<td>3.2</td>
<td>6.5</td>
<td>6.0</td>
<td>7.8</td>
<td>6.6</td>
</tr>
<tr>
<td>Case650</td>
<td>0.0</td>
<td>0.0</td>
<td>0.0</td>
<td>0.0</td>
<td>5.4</td>
<td>4.8</td>
<td>6.5</td>
<td>5.5</td>
</tr>
<tr>
<td>Case900</td>
<td>1.8</td>
<td>1.2</td>
<td>2.0</td>
<td>1.7</td>
<td>2.2</td>
<td>2.1</td>
<td>3.4</td>
<td>2.7</td>
</tr>
<tr>
<td>Case920</td>
<td>3.9</td>
<td>3.3</td>
<td>4.3</td>
<td>4.0</td>
<td>2.3</td>
<td>1.8</td>
<td>3.1</td>
<td>2.6</td>
</tr>
<tr>
<td>Case940</td>
<td>1.2</td>
<td>0.8</td>
<td>1.4</td>
<td>1.2</td>
<td>2.1</td>
<td>2.1</td>
<td>3.2</td>
<td>2.6</td>
</tr>
<tr>
<td>Case950</td>
<td>0.0</td>
<td>0.0</td>
<td>0.0</td>
<td>0.0</td>
<td>0.5</td>
<td>0.4</td>
<td>0.9</td>
<td>0.6</td>
</tr>
<tr>
<td>Case960</td>
<td>3.1</td>
<td>2.3</td>
<td>3.4</td>
<td>2.8</td>
<td>0.6</td>
<td>0.4</td>
<td>0.8</td>
<td>0.6</td>
</tr>
  <tr><td colspan=\"9\"><b>Peak load (kW)</b>
      </td>
  </tr>
  <tr>
  <th rowspan=\"2\" valign=\"middle\">Case</th>
  <th colspan=\"4\">Heating</th>
  <th colspan=\"4\">Cooling</th>
  </tr>
  <tr>
  <td><b>Peak</b></td>
  <td><b>Standard_Minimum</b></td>
  <td><b>Standard_Maximum</b></td>
  <td><b>Standard_Mean</b></td>
  <td><b>Peak</b></td>
  <td><b>Standard_Minimum</b></td>
  <td><b>Standard_Maximum</b></td>
  <td><b>Standard_Mean</b></td>
  </tr>
  <tr>
<td>Case600</td>
<td>4.2</td>
<td>3.4</td>
<td>4.4</td>
<td>4.0</td>
<td>6.6</td>
<td>6.0</td>
<td>6.8</td>
<td>6.5</td>
</tr>
<tr>
<td>Case610</td>
<td>4.2</td>
<td>3.4</td>
<td>4.4</td>
<td>4.0</td>
<td>6.3</td>
<td>5.7</td>
<td>6.4</td>
<td>6.0</td>
</tr>
<tr>
<td>Case620</td>
<td>4.2</td>
<td>3.6</td>
<td>4.4</td>
<td>4.1</td>
<td>4.1</td>
<td>3.6</td>
<td>5.1</td>
<td>4.3</td>
</tr>
<tr>
<td>Case630</td>
<td>4.2</td>
<td>3.6</td>
<td>4.3</td>
<td>4.0</td>
<td>3.6</td>
<td>3.1</td>
<td>4.1</td>
<td>3.6</td>
</tr>
<tr>
<td>Case640</td>
<td>7.0</td>
<td>5.2</td>
<td>7.0</td>
<td>6.0</td>
<td>6.6</td>
<td>5.9</td>
<td>6.8</td>
<td>6.4</td>
</tr>
<tr>
<td>Case650</td>
<td>0.0</td>
<td>0.0</td>
<td>0.0</td>
<td>0.0</td>
<td>6.5</td>
<td>5.8</td>
<td>6.7</td>
<td>6.3</td>
</tr>
<tr>
<td>Case900</td>
<td>3.6</td>
<td>2.9</td>
<td>3.8</td>
<td>3.5</td>
<td>3.2</td>
<td>2.9</td>
<td>3.9</td>
<td>3.4</td>
</tr>
<tr>
<td>Case920</td>
<td>3.9</td>
<td>3.3</td>
<td>4.1</td>
<td>3.8</td>
<td>2.9</td>
<td>2.4</td>
<td>3.5</td>
<td>3.1</td>
</tr>
<tr>
<td>Case940</td>
<td>6.1</td>
<td>4.0</td>
<td>6.4</td>
<td>5.5</td>
<td>3.2</td>
<td>2.9</td>
<td>3.9</td>
<td>3.4</td>
</tr>
<tr>
<td>Case950</td>
<td>0.0</td>
<td>0.0</td>
<td>0.0</td>
<td>0.0</td>
<td>2.4</td>
<td>2.0</td>
<td>3.2</td>
<td>2.7</td>
</tr>
<tr>
<td>Case960</td>
<td>2.9</td>
<td>2.4</td>
<td>2.9</td>
<td>2.7</td>
<td>1.3</td>
<td>1.0</td>
<td>1.4</td>
<td>1.2</td>
</tr>
  </table>
  <br/>
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
