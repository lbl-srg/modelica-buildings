within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences;
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
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage, does not include stages like X + WSE"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaSet
    "Current chiller stage setpoint, does not include stages like X + WSE"
    annotation (Placement(transformation(extent={{-160,-110},{-120,-70}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiSta
    "Stage for condenser water pumps control"
    annotation (Placement(transformation(extent={{120,-60},{160,-20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logicla and"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
protected
  CDL.Integers.Switch                        swi4
                                                 "Logical switch"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));

public
  CDL.Interfaces.BooleanInput uEnaPla "Just enabling plant" annotation (
      Placement(transformation(extent={{-160,-50},{-120,-10}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
equation
  connect(uUpsDevSta, and2.u1)
    annotation (Line(points={{-140,80},{-82,80}}, color={255,0,255}));
  connect(uStaUp, and2.u2)
    annotation (Line(points={{-140,40},{-100,40},{-100,72},{-82,72}},
      color={255,0,255}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{-58,80},{-42,80}},color={255,0,255}));
  connect(uUpsDevSta, and1.u1)
    annotation (Line(points={{-140,80},{-110,80},{-110,10},{-82,10}},
      color={255,0,255}));
  connect(uStaDow, and1.u2)
    annotation (Line(points={{-140,-10},{-110,-10},{-110,2},{-82,2}},
      color={255,0,255}));
  connect(and1.y, swi2.u2)
    annotation (Line(points={{-58,10},{-42,10}},color={255,0,255}));
  connect(uStaUp, swi.u2)
    annotation (Line(points={{-140,40},{38,40}}, color={255,0,255}));
  connect(uStaSet, swi3.u3) annotation (Line(points={{-140,-90},{-54,-90},{-54,
          -18},{-2,-18}},
                     color={255,127,0}));
  connect(uStaSet, swi2.u1) annotation (Line(points={{-140,-90},{-54,-90},{-54,
          18},{-42,18}},
                     color={255,127,0}));
  connect(uStaSet, swi1.u1) annotation (Line(points={{-140,-90},{-54,-90},{-54,
          88},{-42,88}},
                     color={255,127,0}));
  connect(uChiSta, swi2.u3) annotation (Line(points={{-140,-60},{-48,-60},{-48,
          2},{-42,2}},
                    color={255,127,0}));
  connect(uChiSta, swi1.u3) annotation (Line(points={{-140,-60},{-48,-60},{-48,
          72},{-42,72}},
                     color={255,127,0}));
  connect(swi2.y, swi3.u1) annotation (Line(points={{-18,10},{-10,10},{-10,-2},
          {-2,-2}},
        color={255,127,0}));
  connect(swi1.y, swi.u1) annotation (Line(points={{-18,80},{30,80},{30,48},{38,
          48}},
        color={255,127,0}));
  connect(uStaDow, swi3.u2)
    annotation (Line(points={{-140,-10},{-2,-10}}, color={255,0,255}));
  connect(swi3.y, swi.u3) annotation (Line(points={{22,-10},{30,-10},{30,32},{
          38,32}}, color={255,127,0}));
  connect(uEnaPla, swi4.u2) annotation (Line(points={{-140,-30},{-100,-30},{
          -100,-40},{78,-40}}, color={255,0,255}));
  connect(uStaSet, swi4.u1) annotation (Line(points={{-140,-90},{-54,-90},{-54,
          -32},{78,-32}}, color={255,127,0}));
  connect(swi.y, swi4.u3) annotation (Line(points={{62,40},{70,40},{70,-48},{78,
          -48}}, color={255,127,0}));
  connect(swi4.y, yChiSta)
    annotation (Line(points={{102,-40},{140,-40}}, color={255,127,0}));
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
          textString="uStaSet"),
        Text(
          extent={{-98,88},{-50,72}},
          textColor={255,0,255},
          textString="uUpsDevSta"),
        Text(
          extent={{-98,28},{-64,16}},
          textColor={255,0,255},
          textString="uStaUp"),
        Text(
          extent={{68,8},{98,-8}},
          textColor={255,127,0},
          textString="yChiSta"),
        Text(
          extent={{-100,6},{-62,-6}},
          textColor={255,0,255},
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
          extent={{-96,-56},{-62,-68}},
          textColor={255,127,0},
          textString="uChiSta"),
        Text(
          extent={{-100,-22},{-62,-34}},
          textColor={255,0,255},
          textString="uEnaPla")}),
  Documentation(info="<html>
<p>
This block generates stage signal as input for the condenser water pump control. 
</p>
<ul>
<li>
When there is no stage change command (<code>uStaUp=false</code>, 
<code>uStaDow=false</code>), it outputs current stage setpoint <code>uStaSet</code>.
</li>
<li>
When there is a stage up command (<code>uStaUp=true</code>, <code>uStaDow=false</code>),
which means that the stage setpoint <code>uStaSet</code> has changed up to a new stage,
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
When there is a stage down command (<code>uStaUp=false</code>, <code>uStaDow=true</code>),
which means that the stage setpoint <code>uStaSet</code> has changed down to a new stage,
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
