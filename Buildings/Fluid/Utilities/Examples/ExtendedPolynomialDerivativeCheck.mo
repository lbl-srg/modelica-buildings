within Buildings.Fluid.Utilities.Examples;
model ExtendedPolynomialDerivativeCheck
  extends Modelica.Icons.Example;

  parameter Real[:] c={0.1162,1.5404,-1.4825,0.7664,-0.1971}
    "Polynomial coefficients";
  parameter Real xMin=1 "Minimum x value for polynomial";
  parameter Real xMax=2 "Maximum x value for polynomial";

  Real x;
  Real y;
initial equation
   y=x;
equation
  x=Buildings.Fluid.Utilities.extendedPolynomial(
      x=time, c=c, xMin=xMin, xMax=xMax);
  der(y)=der(x);
  assert(abs(x-y) < 1E-2, "Model has an error");

 annotation(experiment(StopTime=4),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Utilities/Examples/ExtendedPolynomialDerivativeCheck.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2011 by Michael Wetter:<br/>
Changed order of argument list to make <code>x</code> the first argument.
</li>
<li>
April 14, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExtendedPolynomialDerivativeCheck;
