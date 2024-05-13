within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses;
block SamplerWithResetThreshold
  "Sampler with a reset and a threshold"
  parameter Real lowLim = 1
    "Lower limit for triggering the sampling";
  parameter Real y_reset = 1
    "The value of y when the reset occurs";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Input real signal"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput trigger
    "Resets the output when trigger becomes true"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
   "Sampling output"
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant thr(final k=lowLim)
    "Threshold"
    annotation (Placement(transformation(extent={{-80,-38},{-60,-18}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler yRec(
    final y_start=y_reset)
    "Record the input when sampling is triggered"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant reset(
    final k=y_reset)
    "Reset value"
    annotation (Placement(transformation(origin={0,148}, extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or samTri "Sampling trigger"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(
    final h=0)
    "Check if the input signal is larger than the threshold"
    annotation (Placement(transformation(origin={-8,-50}, extent={{-32,20},{-12,40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between sampling the input signal and the reset value"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgRes(
    final pre_u_start=false)
    "Detect if the reset is triggered"
    annotation (Placement(transformation(origin={0,-40}, extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgThr(
    final pre_u_start=false)
    "Detect if the threshold is exceeded"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
equation
  connect(yRec.y, y) annotation (Line(points={{82,50},{120,50}},
         color={0,0,127}));
  connect(thr.y, gre.u2) annotation (Line(points={{-58,-28},{-42,-28}},
         color={0,0,127}));
  connect(gre.u1, u) annotation (Line(points={{-42,-20},{-50,-20},{-50,10},{-120,
          10}}, color={0,0,127}));
  connect(yRec.u, swi.y)
    annotation (Line(points={{58,50},{22,50}}, color={0,0,127}));
  connect(edgRes.u, trigger) annotation (Line(points={{-82,-80},{-120,-80}},  color={255,0,255}));
  connect(edgRes.y, swi.u2) annotation (Line(points={{-58,-80},{-10,-80},{-10,50},
          {-2,50}}, color={255,0,255}));
  connect(swi.u3, u)
    annotation (Line(points={{-2,42},{-50,42},{-50,10},{-120,10}},
        color={0,0,127}));
  connect(swi.u1, reset.y) annotation (Line(points={{-2,58},{-40,58},{-40,68},{-58,
          68}}, color={0,0,127}));
  connect(samTri.u2, edgRes.y) annotation (Line(points={{38,-28},{30,-28},{30,-80},
          {-58,-80}}, color={255,0,255}));
  connect(samTri.y, yRec.trigger)
    annotation (Line(points={{62,-20},{70,-20},{70,38}}, color={255,0,255}));
  connect(edgThr.y, samTri.u1)
    annotation (Line(points={{22,-20},{38,-20}}, color={255,0,255}));
  connect(edgThr.u, gre.y) annotation (Line(points={{-2,-20},{-18,-20}},color={255,0,255}));
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
September 20, 2023, by Sen Huang:<br/>
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
