within Buildings.Utilities.Psychrometrics.Functions.BaseClasses.Examples;
model InverseDewPointTemperatureDerivativeCheck_amb
  "Model to test correct implementation of derivative"
  extends Modelica.Icons.Example;

  Real x;
  Real y;
  parameter Real uniCon(unit="Pa/s") = 1 "Constant to convert units";
initial equation
  y = x;
equation
  x = Buildings.Utilities.Psychrometrics.Functions.TDewPoi_pW_amb(p_w=time*uniCon);
  der(y) = der(x);
  assert(abs(x - y) < 1E-2, "Model has an error");
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Functions/BaseClasses/Examples/InverseDewPointTemperatureDerivativeCheck_amb.mos"
        "Simulate and plot"),
    experiment(
      StartTime=611,
      StopTime=7383),
    Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
October 29, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end InverseDewPointTemperatureDerivativeCheck_amb;
