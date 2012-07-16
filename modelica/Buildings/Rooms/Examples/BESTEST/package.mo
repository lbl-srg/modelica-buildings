within Buildings.Rooms.Examples;
package BESTEST "BESTEST validation models"
  extends Modelica.Icons.ExamplesPackage;
  constant Integer nStaRef = 6 "Number of states in a reference material";


annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains the models that were used
for the BESTEST validation (ASHRAE/ANSI 2007).
The basic model from which all other models extend from is
<a href=\"modelica://Buildings.Rooms.Examples.BESTEST.Case600FF\">
Buildings.Rooms.Examples.BESTEST.Case600FF</a>.
All examples have a script that runs an annual simulation and
plots the results with the minimum, mean and maximum value
listed in the ASHRAE/ANSI Standard 140-2007.
</p>
<h4>References</h4>
<p>
ASHRAE/ANSI. 2007. ASHRAE/ANSI Standard 140-2007, Standard Method of Test for the Evaluation of Building Energy Analysis Computer Programs.
</p>
</html>"));
end BESTEST;
