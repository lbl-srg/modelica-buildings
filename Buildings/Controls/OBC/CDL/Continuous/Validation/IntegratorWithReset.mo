within Buildings.Controls.OBC.CDL.Continuous.Validation;
model IntegratorWithReset
  "Test model for integrator with reset"
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset intDef
    "Integrator with default values"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset intWitRes1(
    final y_start=5,
    final k=0.5)
    "Integrator with reset"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset intWitRes2(
    final y_start=-5,
    final k=0.5)
    "Integrator with reset and y_reset = 2"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cons(
    final k=10)
    "Constant as source term"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booleanPulse(
    final width=0.5,
    final period=0.2)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger sampleTrigger(
    final period=0.2)
    "Sample trigger"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp(
    final height=-1,
    final duration=1,
    final offset=-2)
    "Ramp as a source term"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

equation
  connect(cons.y,intWitRes1.u)
    annotation (Line(points={{-38,70},{-20,70},{-20,30},{-2,30}},color={0,0,127}));
  connect(cons.y,intWitRes2.u)
    annotation (Line(points={{-38,70},{-20,70},{-20,-10},{-2,-10}},color={0,0,127}));
  connect(sampleTrigger.y,intWitRes1.trigger)
    annotation (Line(points={{-38,10},{10,10},{10,18}},color={255,0,255}));
  connect(booleanPulse.y,intWitRes2.trigger)
    annotation (Line(points={{-38,-70},{10,-70},{10,-22}},color={255,0,255}));
  connect(ramp.y,intWitRes2.y_reset_in)
    annotation (Line(points={{-38,-30},{-14,-30},{-14,-18},{-2,-18}},color={0,0,127}));
  connect(cons.y,intDef.u)
    annotation (Line(points={{-38,70},{-2,70}},color={0,0,127}));
  connect(ramp.y,intWitRes1.y_reset_in)
    annotation (Line(points={{-38,-30},{-14,-30},{-14,22},{-2,22}},color={0,0,127}));
  connect(ramp.y,intDef.y_reset_in)
    annotation (Line(points={{-38,-30},{-14,-30},{-14,62},{-2,62}},color={0,0,127}));
  connect(sampleTrigger.y,intDef.trigger)
    annotation (Line(points={{-38,10},{-26,10},{-26,52},{10,52},{10,58}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/IntegratorWithReset.mos" "Simulate and plot"),
    Documentation(
      info="<html>
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
</html>",
      revisions="<html>
<ul>
<li>
March 23, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end IntegratorWithReset;
