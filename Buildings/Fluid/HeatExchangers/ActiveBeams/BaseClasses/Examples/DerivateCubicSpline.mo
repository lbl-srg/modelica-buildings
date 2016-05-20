within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Examples;
model DerivateCubicSpline
  import Buildings;
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Clock clock
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.DerivativesCubicSpline
    cubSpl annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(clock.y, cubSpl.u)
    annotation (Line(points={{-39,0},{-12,0}},         color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),experiment(StopTime=1),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ActiveBeams/BaseClasses/Examples/DerivateCubicSpline.mos"
        "Simulate and plot"),
        Documentation(info="<html>
<p>
The example tests the implementation of <a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.DerivatesCubicSpline\">
Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.DerivatesCubicSpline</a>. Default vectors are: x=[0,0.5,1] and y=[0,0.75,1]. Simulation time is the input to the model.



 <p>

</html>"));
end DerivateCubicSpline;
