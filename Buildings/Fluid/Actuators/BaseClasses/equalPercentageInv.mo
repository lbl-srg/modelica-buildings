within Buildings.Fluid.Actuators.BaseClasses;
function equalPercentageInv
  "Inverse funcion of valve opening characteristics for equal percentage valve"
  import Modelica.Math.Matrices;
  extends Modelica.Icons.Function;

  input Real phi(min=0) "Ratio actual to nominal mass flow rate, phi=Cv(y)/Cv(y=1)";
  input Real R "Rangeability, R=50...100 typically";
  input Real l(min=0, max=1) "Valve leakage, l=Kv(y=0)/Kv(y=1)";
  input Real delta "Range of significant deviation from equal percentage law";
  output Real y(max=1, unit="") "Valve opening signal, y=1 is fully open";
protected
   Real roots[3,2] = fill(0, 3, 2);
   Real a "Polynomial coefficient";
   Real b "Polynomial coefficient";
   Real c "Polynomial coefficient";
   Real d "Polynomial coefficient";
   Real logR "=log(R)";
   Real z "Auxiliary variable";
   Real q "Auxiliary variable";
   Real p "Auxiliary variable";
   Real phiL = Buildings.Fluid.Actuators.BaseClasses.equalPercentage(
    y=delta/2, R=R, l=l, delta=delta);
   Real phiU = Buildings.Fluid.Actuators.BaseClasses.equalPercentage(
    y=3/2*delta, R=R, l=l, delta=delta);
algorithm
  logR := Modelica.Math.log(R);
  if phi < phiL then
    y := delta * (phi - l) / (R^(delta-1) - l);
  else
    if phi > phiU then
      y := Modelica.Math.log(phi) / logR + 1;
    else
      z := (3*delta/2);
      q := delta*R^z*logR;
      p := R^z;
      a := (q - 2*p + 2*R^delta)/(delta^3*R);
      b := (-5*q + 12*p - 13*R^delta + l*R)/(2*delta^2*R);
      c := (7*q - 18*p + 24*R^delta - 6*l*R)/(4*delta*R);
      d := (-3*q + 8*p - 9*R^delta + 9*l*R)/(8*R);
      roots := Modelica.Math.Vectors.Utilities.roots({a, b, c, d - phi});
      if (roots[1,1] >= phiL and roots[1,1] <= phiU) and abs(roots[1,2])<Modelica.Constants.eps then y := roots[1,1];
      else
        if (roots[2,1] >= phiL and roots[2,1] <= phiU) and abs(roots[2,2])<Modelica.Constants.eps then y := roots[2,1];
        else y := roots[3,1];
        end if;
      end if;
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
  smoothOrder=1);
end equalPercentageInv;
