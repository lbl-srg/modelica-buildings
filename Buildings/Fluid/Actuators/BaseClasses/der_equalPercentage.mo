within Buildings.Fluid.Actuators.BaseClasses;
function der_equalPercentage
  "Derivative of valve opening characteristics for equal percentage valve"
  extends Modelica.Icons.Function;

  input Real y "Valve opening signal, y=1 is fully open";
  input Real R "Rangeability, R=50...100 typically";
  input Real l(min=0, max=1) "Valve leakage, l=Kv(y=0)/Kv(y=1)";
  input Real delta "Range of significant deviation from equal percentage law";
  input Real der_y "Derivative of valve opening signal";
  output Real der_phi
    "Derivative of ratio actual to nominal mass flow rate, dphi/dy";
protected
   Real a "Polynomial coefficient";
   Real b "Polynomial coefficient";
   Real c "Polynomial coefficient";
   Real logR "=log(R)";
   Real z "Auxiliary variable";
   Real q "Auxiliary variable";
   Real p "Auxiliary variable";
algorithm
  if y < delta/2 then
    der_phi := (R^(delta-1) - l) / delta * der_y;
  else
    if (y > (3/2 * delta)) then
      der_phi := R^(y-1)*Modelica.Math.log(R) * der_y;
    else
      logR := Modelica.Math.log(R);
      z := (3*delta/2);
      q := delta*R^z*logR;
      p := R^z;
      a := (q - 2*p + 2*R^delta)/(delta^3*R);
      b := (-5*q + 12*p - 13*R^delta + l*R)/(2*delta^2*R);
      c := (7*q - 18*p + 24*R^delta - 6*l*R)/(4*delta*R);
      der_phi  := (c + y * ( 2*b + 3*a*y)) * der_y;
    end if;
  end if;
annotation (
Documentation(info="<html>
<p>
This function computes the derivative of the opening characteristics of an equal percentage valve.
</p><p>
The function is the derivative of
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.equalPercentage\">
Buildings.Fluid.Actuators.BaseClasses.equalPercentage</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 30, 2011 by Michael Wetter:<br/>
Removed inputs for which no derivative is implemented from the argument list, and added
<code>zeroDerivative</code> keyword in function that calls this function.
</li>
<li>
February 4, 2010 by Michael Wetter:<br/>
Fixed implementation of derivative function.
</li>
<li>
June 6, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_equalPercentage;
