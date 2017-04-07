within Buildings.Utilities.Math.Functions.Examples;
model InverseXRegularized
  "Test problem for function that replaces 1/x around the origin by a twice continuously differentiable function"
  extends Modelica.Icons.Example;
  Real x "Independent variable";
  parameter Real delta = 0.5 "Small value for approximation";
  final parameter Real deltaInv = 1/delta "Inverse value of delta";

  final parameter Real a = -15*deltaInv "Polynomial coefficient";
  final parameter Real b = 119*deltaInv^2 "Polynomial coefficient";
  final parameter Real c = -361*deltaInv^3 "Polynomial coefficient";
  final parameter Real d = 534*deltaInv^4 "Polynomial coefficient";
  final parameter Real e = -380*deltaInv^5 "Polynomial coefficient";
  final parameter Real f = 104*deltaInv^6 "Polynomial coefficient";

  Real y "Function value";
  Real xInv "Function value";
  Real dy_dt "First derivative of y with respect to t";
  Real d2y_dt2 "Second derivative of y with respect to t";
equation
  x=2*time-1;
  xInv = if ( abs(x) > 0.1)   then 1 / x else 0;
  y = Buildings.Utilities.Math.Functions.inverseXRegularized(
       x=x,
       delta=delta, deltaInv=deltaInv,
       a=a, b=b, c=c, d=d, e=e, f=f);
  dy_dt=der(y);
  d2y_dt2=der(dy_dt);
  annotation(experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/InverseXRegularized.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.Functions.inverseXRegularized\">
Buildings.Utilities.Math.Functions.inverseXRegularized</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 8, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end InverseXRegularized;
