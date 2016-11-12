within Buildings.Utilities.Psychrometrics.Functions.BaseClasses.Examples;
model DewPointTemperatureDerivativeCheck
  "Model to test correct implementation of derivative"
  extends Modelica.Icons.Example;

  Real y "Function value";
  Real y_comp "Function value for comparison";
  Real err "Integration error";
  Modelica.SIunits.Temperature T "Temperature";
initial equation
  y=y_comp;
equation
  T =  273.15 + 50 + time^3 * 50;
  y=Buildings.Utilities.Psychrometrics.Functions.pW_TDewPoi(T=T);
  der(y)=der(y_comp);
  err = y-y_comp;
  assert(abs(err)/max(1, abs(y)) < 1E-2, "Derivative implementation has an error or solver tolerance is too low.");
annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Functions/BaseClasses/Examples/DewPointTemperatureDerivativeCheck.mos"
        "Simulate and plot"),
      experiment(
        StartTime=-1,
        StopTime=1,
        Tolerance=1E-8),
      Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>",   revisions="<html>
<ul>
<li>
April 22, 2016, by Michael Wetter:<br/>
Changed accuarcy test in assertion to use the relative error because the
magnitude of <code>y</code> is <i>1E5</i> and hence testing an absolute
error is too stringent.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/510\">Buildings, issue 510</a>.
</li>
<li>
August 17, 2015 by Michael Wetter:<br/>
Updated regression test to have slope that is different from one.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/303\">issue 303</a>.
</li>
<li>
October 4, 2014, by Michael Wetter:<br/>
Added a high tolerance which is needed for OpenModelica to pass the assert
statement.
</li>
<li>
October 29, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DewPointTemperatureDerivativeCheck;
