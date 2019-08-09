within Buildings.Fluid.CHPs.BaseClasses.Validation;
model AssertWatTem "Validate model AssertWatTem"

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));

  CHPs.BaseClasses.AssertWatTem assWatTem(per=per)
    "Assert if water temperature is outside boundaries"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Controls.OBC.CDL.Continuous.Sources.TimeTable
                                    TWat(table=[0,273.15 + 20; 300,273.15 + 80;
        600,273.15 + 100; 900,273.15 + 100], smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
                          "Water temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation

  connect(TWat.y[1], assWatTem.TWat)
    annotation (Line(points={{-39,0},{38,0}}, color={0,0,127}));
annotation (
  experiment(StopTime=900, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/AssertWatTem.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.AssertWatMas\">
Buildings.Fluid.CHPs.BaseClasses.AssertWatMas</a>
for sending a warning message if the water temperature is outside boundaries.
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
end AssertWatTem;
