within IceStorage.Validation;
package Experiment "Validation from experimental data"
  extends Modelica.Icons.ExamplesPackage;

annotation (Documentation(info="<html>
<p>
This package contains calibration examples using experimental data from 
the Intelligent Building Agents Laboraotry at the National Institute of Standards and Technology.
</p>

<p>
The experimental data are located at \"IceStorage/Resources/data/Experiment\".
 
The data are prepared into 5 columns, and the description of each column is explained below.
<ul>
<li>
1st column: time step in seconds
</li>
<li>
2nd column: measured ice tank inlet temperature in Celsius
</li>
<li>
3rd column: measured ice tank outlet temperature in Celsius
</li>
<li>
4th column: measured ice tank mass flow rate in kg/s
</li>
<li>
5th column: measured dimensionless ice tank state-of-charge
</li>
</ul>
</p>

</html>"));
end Experiment;
