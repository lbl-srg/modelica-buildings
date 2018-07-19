within Occupancy.BaseFunction;
function Logit1D "Mapping a continuous input to a binary output through a logistic relation"
  input Real x "Continuous variable";
  input Real A=1.0 "Parameter defining the logistic relation: Slope";
  input Real B=1.0 "Parameter defining the logistic relation: Intercept";
  output Boolean y "Binary variable";
protected
  Real p =  Modelica.Math.exp(A*x+B)/(Modelica.Math.exp(A*x+B)+1);
algorithm
  y := Occupancy.Utilities.BinaryVariableGeneration(p);
annotation (preferredView="info", Documentation(info="<html>
<p>
This function generates a random binary variable with the input of a continuous variable x from a 
logistic relation.
</p>
<p>
The probability of being 1 is calculated from the input x  from a logistic relation with the 
slope A and the intercept B. Then a random generator generates the output, which should be a 
binary variable.
</p>
</html>"));
end Logit1D;
