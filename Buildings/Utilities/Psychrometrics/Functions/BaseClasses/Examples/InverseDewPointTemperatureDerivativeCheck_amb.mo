within Buildings.Utilities.Psychrometrics.Functions.BaseClasses.Examples;
model InverseDewPointTemperatureDerivativeCheck_amb
  "Model to test correct implementation of derivative"
  extends Modelica.Icons.Example;

  Real y "Function value";
  Real y_comp "Function value for comparison";
  Real err(unit="K", displayUnit="K") "Integration error";
  Modelica.Units.SI.Pressure p_w "Water vapor partial pressure";
initial equation
  y=y_comp;
equation
  p_w =  611 + (7383-661)/2 + (7383-661)/2 * time^3;
  y = Buildings.Utilities.Psychrometrics.Functions.TDewPoi_pW_amb(p_w=p_w);
  der(y) = der(y_comp);
  err = y-y_comp;
  assert(abs(err) < 1E-2, "Derivative implementation has an error or solver tolerance is too low.");
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Functions/BaseClasses/Examples/InverseDewPointTemperatureDerivativeCheck_amb.mos"
        "Simulate and plot"),
    experiment(
      StartTime=-1,
      StopTime=1,
      Tolerance=1E-9),
    Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
August 17, 2015 by Michael Wetter:<br/>
Updated regression test to have slope that is different from one.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/303\">issue 303</a>.
</li>
<li>
October 29, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end InverseDewPointTemperatureDerivativeCheck_amb;
