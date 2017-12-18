within Buildings.Fluid.Actuators.Valves;
model TwoWayPolynomial "Two way valve with polynomial characteristic"
  extends Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv(
    phi=l + pol_y*(1 - l));

  parameter Real[:] c
    "Polynomial coefficients, starting with fixed offset";

protected
  constant Integer nP = 100
    "Number of points for initial algorithm test";
  Real pol_y = sum(c.*{y_actual^i for i in 0:size(c,1)-1})
    "Polynomial of valve control signal";

  // Test the validity of the provided valve coefficients
initial equation
  // We compute the analytic derivative of the polynomial for y=(1/points),
  // where the derivative of y^j = j*y^(j-1).
  if size(c, 1)>=2 then
    for i in 0:nP/2 loop
      assert(sum({c[j+1]*j*(i/nP)^(j-1) for j in 1:size(c, 1) - 1})>=0,
      "The provided valve polynomial coefficients 
      do not lead to a strictly increasing characteristic for y=" + String(i/nP)+ ". This is not allowed.");
    end for;
  end if;
  assert(c[1]>=0, "The provided valve polynomial coefficients do not lead to 
  a valve opening that is larger than or equal to zero for a control signal of zero.");
  assert(sum(c)<=1.1, "The provided valve polynomial coefficients do not lead to 
  a valve opening that is smaller than or equal to one for a control signal of one.");

annotation (
defaultComponentName="val",
Documentation(info="<html>
<p>
Two way valve with polynomial opening characteristic.
The polynomial coefficients are defined using parameter <code>c</code>.
The elements of <code>c</code> are coefficients for increasing powers of <code>y</code>,
starting with the power <code>0</code>, which corresponds to a fixed offset.
This valve model can be used to implement valves with a custom
opening characteristic, such as a combination
of a linear and an equal percentage characteristic.
</p>
<p>
This model is based on the partial valve model
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>.
Check this model for more information, such
as the regularization near the origin.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 30, 2017 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayPolynomial;
