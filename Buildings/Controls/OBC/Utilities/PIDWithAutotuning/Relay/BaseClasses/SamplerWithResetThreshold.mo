within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses;
block SamplerWithResetThreshold
  "Sampler with a reset and a threshold"
  parameter Real lowLim = 1
    "Lower limit for triggering the sampling";
  parameter Real y_reset = 1
    "The value of y when the reset occurs";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Input real signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput trigger
    "Resets the output when trigger becomes true" annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
   "Sampling output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant thr(final k=lowLim)
    "Threshold"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler yRec(final y_start=y_reset)
    "Record the input when sampling is triggered"
    annotation (Placement(transformation(extent={{60,10},{80,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant reset(final k=y_reset)
    "Reset value"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or samTri "Sampling trigger"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(final h=0)
    "Check if the input signal is larger than the threshold"
    annotation (Placement(transformation(extent={{-32,20},{-12,40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between sampling the input signal and the reset value"
    annotation (Placement(transformation(extent={{-16,10},{4,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgRes(final pre_u_start=false)
    "Detect if the reset is triggered"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgThr(final pre_u_start=false)
    "Detect if the threshold is exceeded"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
equation
  connect(yRec.y, y) annotation (Line(points={{82,0},{106,0},{106,0},{120,0}},
        color={0,0,127}));
  connect(thr.y, gre.u2) annotation (Line(points={{-58,0},{-40,0},{-40,22},{-34,
          22}}, color={0,0,127}));
  connect(gre.u1, u) annotation (Line(points={{-34,30},{-46,30},{-46,60},{-120,
          60}}, color={0,0,127}));
  connect(yRec.u, swi.y)
    annotation (Line(points={{58,0},{6,0}}, color={0,0,127}));
  connect(edgRes.u, trigger) annotation (Line(points={{-82,-40},{-92,-40},{-92,
          -60},{-120,-60}}, color={255,0,255}));
  connect(edgRes.y, swi.u2) annotation (Line(points={{-58,-40},{-32,-40},{-32,0},
          {-18,0}}, color={255,0,255}));
  connect(swi.u3, u)
    annotation (Line(points={{-18,8},{-46,8},{-46,60},{-120,60}},
        color={0,0,127}));
  connect(swi.u1, reset.y) annotation (Line(points={{-18,-8},{-26,-8},{-26,-80},
          {-58,-80}}, color={0,0,127}));
  connect(samTri.u2, edgRes.y) annotation (Line(points={{38,42},{30,42},{30,-40},
          {-58,-40}}, color={255,0,255}));
  connect(samTri.y, yRec.trigger)
    annotation (Line(points={{62,50},{70,50},{70,12}}, color={255,0,255}));
  connect(edgThr.y, samTri.u1)
    annotation (Line(points={{22,50},{38,50}}, color={255,0,255}));
  connect(edgThr.u, gre.y) annotation (Line(points={{-2,50},{-8,50},{-8,30},{
          -10,30}}, color={255,0,255}));
  annotation (
        defaultComponentName = "samResThr",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
This block samples the input real signal <code>u</code> when <code>u</code> is larger than a threshold.
On the other hand, when the input boolean signal <code>trigger</code> becomes true, the output <code>y</code> is reset to a default value.
</p>
</html>"));
end SamplerWithResetThreshold;
