within Buildings.Utilities.Math.Functions.BaseClasses;
function der_inverseXRegularized "Derivative of inverseXRegularised function"
  extends Modelica.Icons.Function;
 input Real x "Abscissa value";
 input Real delta(min=Modelica.Constants.eps)
    "Abscissa value below which approximation occurs";
 input Real deltaInv = 1/delta "Inverse value of delta";

 input Real a = -15*deltaInv "Polynomial coefficient";
 input Real b = 119*deltaInv^2 "Polynomial coefficient";
 input Real c = -361*deltaInv^3 "Polynomial coefficient";
 input Real d = 534*deltaInv^4 "Polynomial coefficient";
 input Real e = -380*deltaInv^5 "Polynomial coefficient";
 input Real f = 104*deltaInv^6 "Polynomial coefficient";

 input Real x_der "Abscissa value";
 output Real y_der "Function value";

algorithm
  y_der :=if (x > delta or x < -delta) then -x_der/x/x elseif (x < delta/2 and x > -delta/2) then x_der/(delta*delta) else
    Buildings.Utilities.Math.Functions.BaseClasses.der_smoothTransition(
       x=x,
       x_der=x_der,
       delta=delta,
       deltaInv=deltaInv,
       a=a, b=b, c=c, d=d, e=e, f=f);
annotation (
Documentation(
info="<html>
<p>
Implementation of the first derivative of the function
<a href=\"modelica://Buildings.Utilities.Math.Functions.inverseXRegularized\">
Buildings.Utilities.Math.Functions.inverseXRegularized</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 22, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_inverseXRegularized;
