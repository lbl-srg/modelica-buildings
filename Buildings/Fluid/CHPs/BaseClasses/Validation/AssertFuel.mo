within Buildings.Fluid.CHPs.BaseClasses.Validation;
model AssertFuel "Validate model AssertFuel"

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.CHPs.BaseClasses.AssertFuel assFue(final per=per)
    "Assert if fuel flow is outside boundaries"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable mFue_flow(
    final table=[0,0; 300,1; 600,3.5; 900,0],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Fuel flow rate"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(mFue_flow.y[1], assFue.mFue_flow) annotation (Line(points={{-38,0},
          {38,0}}, color={0,0,127}));

annotation (
  experiment(StopTime=1200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/AssertFuel.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.AssertFuel\">
Buildings.Fluid.CHPs.BaseClasses.AssertFuel</a>
for sending a warning message if the fuel flow rate is outside boundaries.
</p>
</html>", revisions="<html>
<ul>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end AssertFuel;
