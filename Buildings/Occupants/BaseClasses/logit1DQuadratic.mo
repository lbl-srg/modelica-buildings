within Buildings.Occupants.BaseClasses;
function logit1DQuadratic "Mapping a continuous input to a binary output through a quadratic logistic relation"
  input Real x "Continous variable";
  input Real A=1.0 "Parameter defining the quadratic logistic relation";
  input Real B=1.0 "Parameter defining the quadratic logistic relation";
  input Real C=1.0 "Parameter defining the quadratic logistic relation";
  input Real D=1.0 "Parameter defining the quadratic logistic relation";
  output Boolean y "Binary variable";
protected
  Real p =  A + C/(1+ Modelica.Math.exp(-B*(Modelica.Math.log10(x)-D)));
algorithm
  y := Occupancy.Utilities.BinaryVariableGeneration(p);
annotation (preferredView="info", Documentation(info="<html>
<p>
This function generates a random binary variable with the input of a continuous variable x from a 
quadratic logistic relation.
</p>
<p>
The probability of being 1 is calculated from the input x from a quadratic logistic relation with 
four predefined parameters A, B, C and D. Then a random generator generates the output, which 
should be a binary variable.
</p>
</html>"));
end logit1DQuadratic;
