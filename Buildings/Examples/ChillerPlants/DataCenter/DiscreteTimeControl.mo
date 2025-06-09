within Buildings.Examples.ChillerPlants.DataCenter;
model DiscreteTimeControl
  "Model of data center with trim and respond control"
  extends Buildings.Examples.ChillerPlants.DataCenter.BaseClasses.DataCenter;
  extends Modelica.Icons.Example;

  BaseClasses.Controls.TrimAndRespond triAndRes(
    yEqu0=0,
    samplePeriod=120,
    uTri=0,
    yDec=-0.03,
    yInc=0.03) "Trim and respond controller"
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));
equation
  connect(feedback.y, triAndRes.u) annotation (Line(
      points={{-191,200},{-162,200}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(triAndRes.y, linPieTwo.u) annotation (Line(
      points={{-139,200},{-122,200}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlants/DataCenter/DiscreteTimeControl.mos"
        "Simulate and plot"), Documentation(info="<html> 
<p>
This model is the chilled water plant with trim and respond control,
which is a discrete time control logic.
</p>
<p>
The trim and respond logic is approximated by a PI controller which
significantly reduces computing time. The model is described at
<a href=\"modelica://Buildings.Examples.ChillerPlants.DataCenter\">
Buildings.Examples.ChillerPlants.DataCenter</a>.
</p>
<p>
See
<a href=\"modelica://Buildings.Examples.ChillerPlants.DataCenter.ContinuousTimeControl\">
Buildings.Examples.ChillerPlants.DataCenter.ContinuousTimeControl</a>
for an implementation that approximates the trim and respond
logic by a continuous time controller.
</p>
</html>", revisions="<html>
<ul>
<li>
January 13, 2015, by Michael Wetter:<br/>
Moved base model to
<a href=\"modelica://Buildings.Examples.ChillerPlant.BaseClasses.DataCenter\">
Buildings.Examples.ChillerPlant.BaseClasses.DataCenter</a>.
</li>
<li>
December 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-300},{
            400,300}}),
                    graphics),
    experiment(StartTime=13046400, Tolerance=1e-6, StopTime=13651200));
end DiscreteTimeControl;
