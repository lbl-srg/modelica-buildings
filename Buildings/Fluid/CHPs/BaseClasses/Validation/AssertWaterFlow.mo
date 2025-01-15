within Buildings.Fluid.CHPs.BaseClasses.Validation;
model AssertWaterFlow "Validate model AssertWaterFlow"
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.CHPs.BaseClasses.AssertWaterFlow assWatMas(mWatMin_flow=per.mWatMin_flow)
    "Assert if water mass flow is outside boundaries"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable mWat_flow(
    table=[0,0; 300,0.05; 360,0.5;
           600,0.05; 900,0.05],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Sources.BooleanTable runSig(table={300,1000})
    "Flag is true when electricity/heat demand larger than zero"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

equation
  connect(mWat_flow.y[1], assWatMas.mWat_flow) annotation (Line(points={{-38,-20},
          {0,-20},{0,-4},{38,-4}}, color={0,0,127}));
  connect(runSig.y, assWatMas.runSig) annotation (Line(points={{-39,20},{0,20},{
          0,4},{38,4}}, color={255,0,255}));

annotation (
  experiment(StopTime=900, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/AssertWaterFlow.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.AssertWaterFlow\">
Buildings.Fluid.CHPs.BaseClasses.AssertWaterFlow</a>
for sending a warning message if the water mass flow is outside boundaries.
</p>
</html>", revisions="<html>
<ul>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end AssertWaterFlow;
