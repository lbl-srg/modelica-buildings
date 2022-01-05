within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Examples;
model DerivateCubicSpline
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.ContinuousClock clock "Clock"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.DerivativesCubicSpline
    cubSpl "Derivatives of cubic spline"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(clock.y, cubSpl.u)
    annotation (Line(points={{-39,0},{-12,0}},         color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ActiveBeams/BaseClasses/Examples/DerivateCubicSpline.mos"
        "Simulate and plot"),
        Documentation(info="<html>
<p>
The example tests the implementation of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.DerivativesCubicSpline\">
Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.DerivativesCubicSpline</a>.
Default vectors are: <i>x=[0,0.5,1]</i> and <i>y=[0,0.75,1]</i>.
Input to the model is the simulation time.
</p>
</html>", revisions="<html>
<ul>
<li>
June 13, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 20, 2016, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end DerivateCubicSpline;
