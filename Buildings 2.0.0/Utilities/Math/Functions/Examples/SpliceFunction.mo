within Buildings.Utilities.Math.Functions.Examples;
model SpliceFunction
  extends Modelica.Icons.Example;

  Real y "Function value";
equation
  y=Buildings.Utilities.Math.Functions.spliceFunction(
                                            pos=10, neg=-10, x=time-0.4, deltax=0.2);
  annotation(experiment(StartTime=-1, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/SpliceFunction.mos"
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
end SpliceFunction;
