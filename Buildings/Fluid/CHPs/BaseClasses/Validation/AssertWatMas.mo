within Buildings.Fluid.CHPs.BaseClasses.Validation;
model AssertWatMas "Validate model AssertWatMas"
  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));
  CHPs.BaseClasses.AssertWatMas assWatMas(per=per)
    "Assert if water mass flow is outside boundaries"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Controls.OBC.CDL.Continuous.Sources.TimeTable
                                    mWat_flow(table=[0,0; 300,0.05; 360,0.5;
        600,0.05; 900,0.05], smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Sources.BooleanTable runSig(table={300,1000})
    "Flag is true when electricity/heat demand larger than zero"
    annotation (Placement(transformation(extent={{-60,6},{-40,26}})));
equation
  connect(runSig.y, assWatMas.runSig) annotation (Line(points={{-39,16},{-0.5,16},
          {-0.5,4},{38,4}}, color={255,0,255}));
  connect(mWat_flow.y[1], assWatMas.mWat_flow) annotation (Line(points={{-39,
          -20},{0,-20},{0,-4},{38,-4}}, color={0,0,127}));
annotation (
  experiment(StopTime=900, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/AssertWatMas.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.AssertWatMas\">
Buildings.Fluid.CHPs.BaseClasses.AssertWatMas</a>
for sending a warning message if the water mass flow is outside boundaries.
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
end AssertWatMas;
