within Buildings.Utilities.Math.Functions.Examples;
model RegNonZeroPowerDerivative_2_Check
  extends Modelica.Icons.Example;

 parameter Real n=0.33 "Exponent";
 parameter Real delta = 0.1 "Abscissa value where transition occurs";

  Real x;
  Real y;
initial equation
   y=x;
equation
  x=Buildings.Utilities.Math.Functions.BaseClasses.der_regNonZeroPower(
                                                             time,n, delta, time);
  der(y)=der(x);
  assert(abs(x-y) < 1E-2, "Model has an error");

 annotation(experiment(StartTime=-1, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/RegNonZeroPowerDerivative_2_Check.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RegNonZeroPowerDerivative_2_Check;
