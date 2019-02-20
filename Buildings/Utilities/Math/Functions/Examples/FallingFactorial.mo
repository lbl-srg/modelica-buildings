within Buildings.Utilities.Math.Functions.Examples;
model FallingFactorial
  "Test case for evaluation of falling factorials"
  extends Modelica.Icons.Example;

  Integer falFac[10] "Falling factorial of n";
  Integer n "n";

equation
  n = integer(floor(time));

  for k in 1:10 loop
    falFac[k] = Buildings.Utilities.Math.Functions.fallingFactorial(n,k);
  end for;

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/FallingFactorial.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=13.9),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for the evaluation of
falling factorials.
</p>
</html>", revisions="<html>
<ul>
<li>
June 6, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end FallingFactorial;
