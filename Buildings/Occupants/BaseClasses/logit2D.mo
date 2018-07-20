within Buildings.Occupants.BaseClasses;
function logit2D "Mapping two continuous inputs to a binary output through a 2-dimension logistic relation"
  input Real x1 "The first input variable";
  input Real x2 "The second input variable";
  input Real A=1.0 "Parameter defining the 2D logistic relation: mutiplier for the first input";
  input Real B=1.0 "Parameter defining the 2D logistic relation: mutiplier for the second input";
  input Real C=1.0 "Parameter defining the 2D logistic relation: intercept";
  output Boolean y "Binary variable";
protected
  Real p =  Modelica.Math.exp(A*x1+B*x2+C)/(Modelica.Math.exp(A*x1+B*x2+C)+1);
algorithm
  y := Occupancy.Utilities.BinaryVariableGeneration(p);
annotation (preferredView="info", Documentation(info="<html>
<p>
This function generates a random binary variable with two inputs x1 and x2 from a 2-dimension
logistic relation.
</p>
<p>
The probability of being 1 is calculated from the inputs x1 and x2 from a 2D logistic relation with
three predefined parameters A (mutiplier for x1), B (mutiplier for x2) and C (intercept). Then a
random generator generates the output, which should be a binary variable.
</p>
</html>"));
end logit2D;
