within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block EnableCWPump
  "Generate staging index for condenser water pump control"

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before enabling or disabling condenser water pump"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp "Stage-up command"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage-down command"
    annotation (Placement(transformation(extent={{-160,-30},{-120,10}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage, does not include stages like X + WSE"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaSet
    "Current chiller stage setpoint, does not include stages like X + WSE"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiSta
    "Stage for condenser water pumps control"
    annotation (Placement(transformation(extent={{120,20},{160,60}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logicla and"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

equation
  connect(uStaSet, intToRea.u)
    annotation (Line(points={{-140,-80},{-102,-80}}, color={255,127,0}));
  connect(uUpsDevSta, and2.u1)
    annotation (Line(points={{-140,80},{-82,80}}, color={255,0,255}));
  connect(uStaUp, and2.u2)
    annotation (Line(points={{-140,40},{-100,40},{-100,72},{-82,72}},
      color={255,0,255}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{-58,80},{-2,80}}, color={255,0,255}));
  connect(intToRea.y, swi1.u1)
    annotation (Line(points={{-78,-80},{-40,-80},{-40,88},{-2,88}},
      color={0,0,127}));
  connect(uUpsDevSta, and1.u1)
    annotation (Line(points={{-140,80},{-110,80},{-110,10},{-82,10}},
      color={255,0,255}));
  connect(uStaDow, and1.u2)
    annotation (Line(points={{-140,-10},{-100,-10},{-100,2},{-82,2}},
      color={255,0,255}));
  connect(and1.y, swi2.u2)
    annotation (Line(points={{-58,10},{-2,10}}, color={255,0,255}));
  connect(intToRea.y, swi2.u1)
    annotation (Line(points={{-78,-80},{-40,-80},{-40,18},{-2,18}},
      color={0,0,127}));
  connect(uStaUp, swi.u2)
    annotation (Line(points={{-140,40},{38,40}}, color={255,0,255}));
  connect(swi1.y, swi.u1)
    annotation (Line(points={{22,80},{30,80},{30,48},{38,48}},
      color={0,0,127}));
  connect(uStaDow, swi3.u2)
    annotation (Line(points={{-140,-10},{38,-10}}, color={255,0,255}));
  connect(swi2.y, swi3.u1)
    annotation (Line(points={{22,10},{30,10},{30,-2},{38,-2}},
      color={0,0,127}));
  connect(intToRea.y, swi3.u3)
    annotation (Line(points={{-78,-80},{-40,-80},{-40,-18},{38,-18}},
      color={0,0,127}));
  connect(swi3.y, swi.u3)
    annotation (Line(points={{62,-10},{70,-10},{70,20},{30,20},{30,32},{38,32}},
      color={0,0,127}));
  connect(swi.y, reaToInt.u)
    annotation (Line(points={{62,40},{78,40}}, color={0,0,127}));
  connect(reaToInt.y, yChiSta)
    annotation (Line(points={{102,40},{140,40}}, color={255,127,0}));
  connect(uChiSta, intToRea1.u)
    annotation (Line(points={{-140,-40},{-102,-40}}, color={255,127,0}));
  connect(intToRea1.y, swi1.u3)
    annotation (Line(points={{-78,-40},{-20,-40},{-20,72},{-2,72}}, color={0,0,127}));
  connect(intToRea1.y, swi2.u3)
    annotation (Line(points={{-78,-40},{-20,-40},{-20,2},{-2,2}}, color={0,0,127}));

annotation (
  defaultComponentName="enaNexCWP",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-100},{120,100}})),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,-82},{-62,-94}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uStaSet"),
        Text(
          extent={{-98,88},{-50,72}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uUpsDevSta"),
        Text(
          extent={{-98,28},{-64,16}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaUp"),
        Text(
          extent={{68,8},{98,-8}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yChiSta"),
        Text(
          extent={{-98,-12},{-60,-24}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaDow"),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,60},{0,-60},{60,0},{0,60}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,-46},{-62,-58}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uChiSta")}),
  Documentation(info="<html>
<p>
This block generates stage signal as input for condenser water pump control. 
</p>
<ul>
<li>
When there is no stage change command (<code>uStaUp=false</code>, 
<code>uStaDow=false</code>), it outputs current stage setpoint <code>uStaSet</code>.
</li>
<li>
When there is stage up command (<code>uStaUp=true</code>, <code>uStaDow=false</code>)
which means stage setpoint <code>uStaSet</code> has changed up to new stage,
<ol>
<li>
When the minimum bypass flow has not been reset (<code>uUpsDevSta=false</code>),
the stage index for condenser water pump control should still be the old stage 
(<code>yChiSta</code> = <code>uChiSta</code>).
</li>
<li>
When the minimum bypass flow has been reset (<code>uUpsDevSta=true</code>),
the stage index for condenser water pump control should be the stage setpoint
<code>uStaSet</code>.
</li>
</ol>
</li>
<li>
When there is stage down command (<code>uStaUp=false</code>, <code>uStaDow=true</code>)
which means stage setpoint <code>uStaSet</code> has changed down to new stage,
<ol>
<li>
When the head pressure control of the chiller being shut off has not been disabled 
(<code>uUpsDevSta=false</code>), the stage index for condenser water pump control 
should still be the old stage (<code>yChiSta</code> = <code>uChiSta</code>).
</li>
<li>
When the head pressure control of the chiller being shut off has been disabled 
(<code>uUpsDevSta=true</code>), the stage index for condenser water pump control 
should be the current stage setpoint <code>uStaSet</code>.
</li>
</ol>
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
February 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableCWPump;
