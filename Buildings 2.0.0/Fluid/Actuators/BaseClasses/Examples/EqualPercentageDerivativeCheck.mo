within Buildings.Fluid.Actuators.BaseClasses.Examples;
model EqualPercentageDerivativeCheck
  extends Modelica.Icons.Example;

 parameter Real R = 50 "Rangeability";
 parameter Real delta = 0.01 "Value where transition occurs";
 parameter Real l = 0.001 "Leakage";
  Real x;
  Real y;
initial equation
   y=x;
equation
  x=Buildings.Fluid.Actuators.BaseClasses.equalPercentage(time, R, l, delta);
  der(y)=der(x);
  assert(abs(x-y) < 1E-2, "Model has an error");

 annotation(experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/BaseClasses/Examples/EqualPercentageDerivativeCheck.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
June 6, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end EqualPercentageDerivativeCheck;
