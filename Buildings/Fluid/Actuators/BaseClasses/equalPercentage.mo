within Buildings.Fluid.Actuators.BaseClasses;
function equalPercentage
  "Valve opening characteristics for equal percentage valve"
  extends Modelica.Icons.Function;

  input Real y "Valve opening signal, y=1 is fully open";
  input Real R "Rangeability, R=50...100 typically";
  input Real l(min=0, max=1) "Valve leakage, l=Kv(y=0)/Kv(y=1)";
  input Real delta "Range of significant deviation from equal percentage law";
  output Real phi "Ratio actual to nominal mass flow rate, phi=Cv(y)/Cv(y=1)";
protected
   Real a "Polynomial coefficient";
   Real b "Polynomial coefficient";
   Real c "Polynomial coefficient";
   Real d "Polynomial coefficient";
   Real logR "=log(R)";
   Real z "Auxiliary variable";
   Real q "Auxiliary variable";
   Real p "Auxiliary variable";
algorithm
  if y < delta/2 then
    phi := l + y * (R^(delta-1) - l) / delta;
  else
    if (y > (3/2 * delta)) then
      phi := R^(y-1);
    else
      logR := Modelica.Math.log(R);
      z := (3*delta/2);
      q := delta*R^z*logR;
      p := R^z;
      a := (q - 2*p + 2*R^delta)/(delta^3*R);
      b := (-5*q + 12*p - 13*R^delta + l*R)/(2*delta^2*R);
      c := (7*q - 18*p + 24*R^delta - 6*l*R)/(4*delta*R);
      d := (-3*q + 8*p - 9*R^delta + 9*l*R)/(8*R);
      phi  := d + y * ( c + y * ( b + y * a));
    end if;
  end if;
annotation (
Documentation(info="<html>
<p>
This function computes the opening characteristics of an equal percentage valve.
</p><p>
The function is used by the model
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage\">
Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage</a>.
</p><p>
For <code>y &lt; delta/2</code>, the valve characteristics is linear. For <code> y &gt; 3*delta/2</code>
the valve characteristics is equal percentage. In between, a cubic spline is used to ensure
that the valve characteristics is once continuously differentiable with respect to <code>y</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 11, 2016 by Michael Wetter:<br/>
Corrected wrong hyperlink in documentation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/450\">issue 450</a>.
</li>
<li>
March 30, 2011 by Michael Wetter:<br/>
Added <code>zeroDerivative</code> keyword.
</li>
<li>
June 5, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
smoothOrder=1,
derivative(zeroDerivative=R, zeroDerivative=l, zeroDerivative=delta)=der_equalPercentage);
end equalPercentage;
