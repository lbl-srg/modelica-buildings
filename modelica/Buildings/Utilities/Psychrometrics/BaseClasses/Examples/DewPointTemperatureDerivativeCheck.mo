within Buildings.Utilities.Psychrometrics.BaseClasses.Examples;
model DewPointTemperatureDerivativeCheck
  "Model to test correct implementation of derivative"

 annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                    graphics),
                     Commands(file="DewPointTemperatureDerivativeCheck.mos" "run"),
    experiment(
      StartTime=273.15,
      StopTime=473.15,
      Algorithm="Euler"),
    experimentSetupOutput);
  annotation (
    Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
October 29, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  Real x;
  Real y;
  parameter Real uniCon(unit="K/s") = 1 "Constant to convert units";
initial equation
   y=x;
equation
  x=Buildings.Utilities.Psychrometrics.BaseClasses.dewPointTemperature(T=time*uniCon);
  der(y)=der(x);
  assert(abs(x-y) < 1E-2, "Model has an error");
end DewPointTemperatureDerivativeCheck;
