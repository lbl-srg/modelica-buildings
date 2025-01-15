within Buildings.Fluid.CHPs.BaseClasses.Validation;
model AssertWaterTemperature "Validate model AssertWaterTemperature"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.CHPs.BaseClasses.AssertWaterTemperature assWatTem(TWatMax=per.TWatMax)
             "Assert if water temperature is outside boundaries"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TWat(
    table=[0,273.15 + 20; 300,273.15 + 80;
           600,273.15 + 100; 900,273.15 + 100],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Water temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(TWat.y[1], assWatTem.TWat)
    annotation (Line(points={{-38,0},{38,0}}, color={0,0,127}));

annotation (
  experiment(StopTime=900, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/AssertWaterTemperature.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.AssertWaterTemperature\">
Buildings.Fluid.CHPs.BaseClasses.AssertWaterTemperature</a>
for sending a warning message if the water temperature is outside boundaries.
</p>
</html>", revisions="<html>
<ul>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end AssertWaterTemperature;
