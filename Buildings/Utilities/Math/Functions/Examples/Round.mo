within Buildings.Utilities.Math.Functions.Examples;
model Round "Example for round function"
  extends Modelica.Icons.Example;
  Real ym2 "Function value";
  Real ym1 "Function value";
  Real y "Function value";
  Real y1 "Function value";
  Real y2 "Function value";
equation
  ym2=Buildings.Utilities.Math.Functions.round(x=time*100, n=-2)/100;
  ym1=Buildings.Utilities.Math.Functions.round(x=time*10, n=-1)/10;
  y=Buildings.Utilities.Math.Functions.round(x=time, n=0);
  y1=Buildings.Utilities.Math.Functions.round(x=time/10, n=1)*10;
  y2=Buildings.Utilities.Math.Functions.round(x=time/100, n=2)*100;
  annotation(experiment(StartTime=-2,Tolerance=1e-6, StopTime=2.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/Round.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.Functions.round\">
Buildings.Utilities.Math.Functions.round</a>
for different values of <i>n</i>.
Arguments and return values are scale to simplify the show that the scaling for the rounding
is implemented correctly.
</p>
</html>", revisions="<html>
<ul>
<li>
October 19, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Round;
