within Buildings.Fluid.CHPs.BaseClasses.Validation;
model AssertPower "Validate model AssertPower"
  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));
  CHPs.BaseClasses.AssertPower assPow(per=per)
    "Assert if electric power is outside boundaries"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Controls.OBC.CDL.Continuous.Sources.TimeTable
                                    PEleDem(table=[0,0; 300,500; 600,2000; 900,
        3001; 1200,0; 1500,6000; 2000,6000], smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
               "Electricity demand"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(PEleDem.y[1], assPow.PEleDem)
    annotation (Line(points={{-39,0},{38,0}}, color={0,0,127}));
annotation (
  experiment(StopTime=1800, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/AssertPower.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.AssertPower\">
Buildings.Fluid.CHPs.BaseClasses.AssertPower</a>
for sending a warning message if the electric power is outside boundaries.
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
end AssertPower;
