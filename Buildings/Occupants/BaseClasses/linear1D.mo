within Buildings.Occupants.BaseClasses;
function linear1D "Mapping a continuous input to a binary output through a linear relation"
  input Real x "Continuous variable";
  input Real A=1.0 "Slope of the linear function";
  input Real B=1.0 "Intercept of the linear function";
  output Boolean y "Binary variable";
protected
  Real p =  min(1,A*x+B) "p shoud be less than 1";
algorithm
  p := if 0 < p then p else 0 "p shoud be no less than 0";
  y := Occupancy.Utilities.BinaryVariableGeneration(p);
annotation (Documentation(info="<html>
<p>
This function generates a random binary variable with the input of a continuous variable x from a 
linear relation.
</p>
<p>
The probability of being 1 is calculated from the input x with the slope A and the intercept B. 
Then a random generator generates the output, which should be a binary variable.
</p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end linear1D;
