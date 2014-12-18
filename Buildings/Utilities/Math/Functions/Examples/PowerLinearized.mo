within Buildings.Utilities.Math.Functions.Examples;
model PowerLinearized
  "Test problem for function that linearizes y=x^n below some threshold"
  extends Modelica.Icons.Example;
  Real T4(start=300^4) "Temperature raised to 4-th power";
  Real T "Temperature";
  Real TExact "Temperature";
equation
  T = (1+500*time);
  T = Buildings.Utilities.Math.Functions.powerLinearized(x=T4, x0=243.15^4, n=0.25);
  TExact = abs(T4)^(1/4);

  annotation(experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/PowerLinearized.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.Functions.powerLinearized\">
Buildings.Utilities.Math.Functions.powerLinearized</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 8, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PowerLinearized;
