within Buildings.Utilities.Math.Functions.Examples;
model Factorial "Test case for evaluation of factorials"
  extends Modelica.Icons.Example;

  Integer fac "Factorial of n";
  Integer n "n";

equation
  n = integer(floor(time));
  fac = Buildings.Utilities.Math.Functions.factorial(n);

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/Factorial.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=12.9),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for the evaluation of
factorials.
</p>
</html>", revisions="<html>
<ul>
<li>
June 6, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end Factorial;
