within Buildings.Utilities.Math.Functions.Examples;
model QuinticHermite "Example model using quintic Hermite spline"
  extends Modelica.Icons.Example;
  parameter Real a = 0.5 "Exponential argument coefficient";
  parameter Real x1 = 1 "Lower abscissa value";
  parameter Real x2 = 2.6 "Upper abscissa value";
  parameter Real y1 = -x1 "Lower ordinate value";

  parameter Real y1d = -1 "Lower derivative";
  parameter Real y2d = a*exp(a*x2) "Upper derivative";
  parameter Real y1dd = 0 "Lower second derivative";
  parameter Real y2dd= a^2*exp(a*x2) "Upper second derivative";

  Real x = time "Abscissa value";
  Real y "Ordinate value";
  Real dy "Time derivative of ordinate value";
  Real ddy "Second time derivative of ordinate value";
  Real y2 "Second ordinate section";

equation
  y2 = exp(a*x2);

  y= noEvent(smooth(2,if x>x2 then exp(a*x)
     elseif x<x1 then -time
     else Buildings.Utilities.Math.Functions.quinticHermite(x=x,x1=x1,x2=x2,y1=y1,y2=y2,y1d=y1d,y2d=y2d,y1dd=y1dd,y2dd=y2dd)));
  dy=der(y);
  ddy=der(dy);
  annotation (experiment(Tolerance=1E-6, StopTime=3),
    Documentation(info="<html>
<p>
Demonstration of the use of a quintic Hermite spline interpolation function.
</p>
</html>", revisions="<html>
<ul>
<li>
April 19, 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/QuinticHermite.mos"
        "Simulate and plot"));
end QuinticHermite;
