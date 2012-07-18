within Buildings.Rooms.Examples;
package BESTEST "BESTEST validation models"
  extends Modelica.Icons.ExamplesPackage;
  constant Integer nStaRef = 6 "Number of states in a reference material";

annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains the models that were used
for the BESTEST validation (ANSI/ASHRAE 2007).
The basic model from which all other models extend from is
<a href=\"modelica://Buildings.Rooms.Examples.BESTEST.Case600FF\">
Buildings.Rooms.Examples.BESTEST.Case600FF</a>.
</p>
<p>
All examples have a script that runs an annual simulation and
plots the results with the minimum, mean and maximum value
listed in the ANSI/ASHRAE Standard 140-2007.
</p>
<p>
The script compares the following quantities
</p>
<p>
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
</p>
<h4>Implementation</h4>
<p>
Heating and cooling is controlled using the PI controller
<a href=\"modelica://Buildings.Controls.Continuous.LimPID\">
Buildings.Controls.Continuous.LimPID</a>
with anti-windup.
</p>
<p>
Hourly averaged values, and annual mean values,
are computed using an instance of
<a href=\"modelica://Modelica.Blocks.Math.Mean</a>
Modelica.Blocks.Math.Mean</a>.
</p>
<h4>References</h4>
<p>
ANSI/ASHRAE. 2007. ANSI/ASHRAE Standard 140-2007, Standard Method of Test for the Evaluation of Building Energy Analysis Computer Programs.
</p>
</html>"));
end BESTEST;
