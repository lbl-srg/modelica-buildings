within Buildings.Utilities.Psychrometrics.Functions.BaseClasses.Examples;
model DewPointTemperatureDerivativeCheck
  "Model to test correct implementation of derivative"
  extends Modelica.Icons.Example;

    Real x;
    Real y;
    parameter Real uniCon(unit="K/s") = 1 "Constant to convert units";
initial equation
     y=x;
equation
    x=Buildings.Utilities.Psychrometrics.Functions.pW_TDewPoi(  T=time*uniCon);
    der(y)=der(x);
    assert(abs(x-y) < 1E-2, "Model has an error");
   annotation(                       __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Functions/BaseClasses/Examples/DewPointTemperatureDerivativeCheck.mos"
        "Simulate and plot"),
      experiment(
        StartTime=273.15,
        StopTime=473.15,
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
