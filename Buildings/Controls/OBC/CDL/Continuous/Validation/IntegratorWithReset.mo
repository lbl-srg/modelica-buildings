within Buildings.Controls.OBC.CDL.Continuous.Validation;
model IntegratorWithReset "Test model for integrator with reset"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cons(k=10) "Constant as source term"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset intWitRes1(
    y_start=5, reset=Types.Reset.Parameter,
    k=0.5,
    y_reset=2)   "Integrator with reset"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset intWitRes2(
    y_reset=10,
    y_start=-5,
    reset=Types.Reset.Input,
    k=0.5)     "Integrator with reset and y_reset = 2"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse
    booleanPulse(width=0.5, period=0.2) "Boolean pulse"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset intNoReset(
    reset=Types.Reset.Disabled,
    k=0.5,
    y_start=1)
    "Integrator without reset"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger
    sampleTrigger(period=0.2) "Sample trigger"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp(
    height=-1,
    duration=1,
    offset=-2) "Ramp as a source term"
    annotation (Placement(transformation(extent={{-60,-38},{-40,-18}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset intDef
    "Integrator with default values"
    annotation (Placement(transformation(extent={{-12,-90},{8,-70}})));
equation
  connect(cons.y, intWitRes1.u) annotation (Line(points={{-39,70},{-26,70},{-26,
          30},{-12,30}}, color={0,0,127}));
  connect(intNoReset.u, cons.y) annotation (Line(points={{-12,70},{-12,70},{-28,
          70},{-39,70}}, color={0,0,127}));
  connect(cons.y, intWitRes2.u) annotation (Line(points={{-39,70},{-39,70},{-26,
          70},{-26,-20},{-12,-20}}, color={0,0,127}));
  connect(sampleTrigger.y, intWitRes1.trigger) annotation (Line(points={{-39,10},
          {0,10},{0,18}},             color={255,0,255}));
  connect(booleanPulse.y, intWitRes2.trigger)
    annotation (Line(points={{-39,-60},{0,-60},{0,-32}},   color={255,0,255}));
  connect(ramp.y, intWitRes2.y_reset_in) annotation (Line(points={{-39,-28},{
          -39,-28},{-34,-28},{-12,-28}},
                                     color={0,0,127}));
  connect(cons.y, intDef.u) annotation (Line(points={{-39,70},{-26,70},{-26,-80},
          {-14,-80}}, color={0,0,127}));
          annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/IntegratorWithReset.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset\">
Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset</a>
with and without reset, and with different start values
and reset values.
</p>
<p>
The integrator <code>intWitRes1</code> is triggered by a sample trigger
which becomes true at <i>t=0</i>, while <code>intWitRes2</code> is triggered
by a boolean pulse with is true at <i>t=0</i>.
Hence, <code>intWitRes1</code> starts with <code>y(0)=y_reset</code> while
<code>intWitRes2</code> starts with <code>y(0)=y_start</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2017, by Jianjun Hu:<br/>
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
end IntegratorWithReset;
