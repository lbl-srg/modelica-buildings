within Buildings.Utilities.Math.Examples;
model SmoothBlocks "Test model for smooth min and smooth max functions"
  extends Modelica.Icons.Example;
  SmoothMax smoMax(deltaX=0.5) annotation (Placement(transformation(extent={{
            -20,40},{0,60}})));
  Modelica.Blocks.Math.Max max annotation (Placement(transformation(extent={{
            -20,0},{0,20}})));
  Modelica.Blocks.Sources.Sine sine(f=8)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Sine sine1(f=1)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Diagnostics.AssertEquality assEquMax(threShold=0.08)
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Utilities.Math.SmoothMin smoMin(deltaX=0.5)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Math.Min Min annotation (Placement(transformation(extent={{
            -20,-80},{0,-60}})));
  Diagnostics.AssertEquality assEquMin(threShold=0.08)
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
equation

  connect(sine.y, smoMax.u1) annotation (Line(points={{-59,70},{-40,70},{-40,56},
          {-22,56}}, color={0,0,127}));
  connect(sine.y, max.u1) annotation (Line(points={{-59,70},{-40,70},{-40,16},{
          -22,16}}, color={0,0,127}));
  connect(sine1.y, smoMax.u2) annotation (Line(points={{-79,10},{-48,10},{-48,
          44},{-22,44}}, color={0,0,127}));
  connect(sine1.y, max.u2) annotation (Line(points={{-79,10},{-48,10},{-48,4},{
          -22,4}}, color={0,0,127}));
  connect(smoMax.y, assEquMax.u1) annotation (Line(points={{1,50},{20,50},{20,
          36},{38,36}}, color={0,0,127}));
  connect(max.y, assEquMax.u2) annotation (Line(points={{1,10},{20,10},{20,24},
          {38,24}}, color={0,0,127}));
  connect(sine.y, smoMin.u1) annotation (Line(points={{-59,70},{-40,70},{-40,
          -24},{-22,-24}}, color={0,0,127}));
  connect(sine.y, Min.u1) annotation (Line(points={{-59,70},{-40,70},{-40,-64},
          {-22,-64}}, color={0,0,127}));
  connect(sine1.y, smoMin.u2) annotation (Line(points={{-79,10},{-48,10},{-48,
          -36},{-22,-36}}, color={0,0,127}));
  connect(sine1.y, Min.u2) annotation (Line(points={{-79,10},{-48,10},{-48,-76},
          {-22,-76}}, color={0,0,127}));
  connect(smoMin.y, assEquMin.u1) annotation (Line(points={{1,-30},{20,-30},{20,
          -44},{38,-44}}, color={0,0,127}));
  connect(Min.y, assEquMin.u2) annotation (Line(points={{1,-70},{20,-70},{20,
          -56},{38,-56}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/SmoothBlocks.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the implementation of blocks that approximate non-differentiable functions
by smooth functions.
</p>
</html>", revisions="<html>
<ul>
<li>
November 12, 2013, by Michael Wetter:<br/>
Added missing parameter value for <code>sine1.freqHz</code>.
</li>
<li>
August 15, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmoothBlocks;
