within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SingleStepSetpointChange "Single-step setpoint change"

  parameter Boolean ascSet
    "True: command the setpoint toward the allowed maximum setpoint; False: command the setpoint toward the allowed minimum setpoint";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uAllMaxSet
    "Allowed maximum setpoint"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,-38},{-100,2}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uAllMinSet
    "Allowed minimum setpoint"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCurSet
    "Current setpoint"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
        iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna
    "True: change the setpoint to the allowed minimum or maximum setpoint"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSet
    "Commanded setpoint"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Switch swiMinMax
    "Switch between the allowed minimum and maximum setpoints"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conAscSet(final k=ascSet)
    "Constant for ascending setpoint change"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swiEna
    "Switch for enabling setpoint change"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Min uCurSetAllMin
    "Current setpoint should not be smaller than the allowed minimum setpoint"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

  Buildings.Controls.OBC.CDL.Reals.Max uCurSetAllMax
    "Current setpoint should not be larger than the allowed maximum setpoint"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(uEna, swiEna.u2) annotation (Line(points={{-180,120},{-100,120},{-100,
          -70},{18,-70}}, color={255,0,255}));
  connect(uCurSet, swiEna.u3) annotation (Line(points={{-180,40},{-80,40},{-80,-78},
          {18,-78}},      color={0,0,127}));
  connect(conAscSet.y, swiMinMax.u2) annotation (Line(points={{-38,30},{-30,30},{-30,
          -30},{-22,-30}}, color={255,0,255}));
  connect(swiMinMax.y, swiEna.u1) annotation (Line(points={{2,-30},{10,-30},{10,
          -62},{18,-62}},      color={0,0,127}));
  connect(uAllMaxSet,uCurSetAllMin. u1) annotation (Line(points={{-180,-40},{-140,-40},
          {-140,80},{100,80},{100,6},{118,6}},
                                            color={0,0,127}));
  connect(uAllMinSet,uCurSetAllMax. u1) annotation (Line(points={{-180,-120},{-120,
          -120},{-120,60},{40,60},{40,6},{58,6}}, color={0,0,127}));
  connect(swiEna.y,uCurSetAllMax. u2) annotation (Line(points={{42,-70},{50,-70},
          {50,-6},{58,-6}}, color={0,0,127}));
  connect(uCurSetAllMax.y,uCurSetAllMin. u2)
    annotation (Line(points={{82,0},{100,0},{100,-6},{118,-6}},
                                                             color={0,0,127}));
  connect(uCurSetAllMin.y, yComSet)
    annotation (Line(points={{142,0},{180,0}}, color={0,0,127}));
  connect(uAllMaxSet, swiMinMax.u1) annotation (Line(points={{-180,-40},{-140,-40},
          {-140,-22},{-22,-22}}, color={0,0,127}));
  connect(uAllMinSet, swiMinMax.u3) annotation (Line(points={{-180,-120},{-120,-120},
          {-120,-38},{-22,-38}}, color={0,0,127}));
  annotation (defaultComponentName="sinSteSetCha",
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,-100},{100,100}},
      lineColor={0,0,0},
      radius=0,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
      textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    extent={{-160,-140},{160,140}},
    grid={2,2})),
    Documentation(info="<html>

<p>
This block conducts a single-step setpoint change as below:
</p>

<ul>
<li>
If the setpoint change enabling input <code>uEna</code> is <code>true</code>, the commanded setpoint <code>yComSet</code> 
equals the allowed maximum setpoint <code>uAllMaxSet</code> if the parameter <code>ascSet</code> is set to <code>true</code>, or 
equals the allowed minimum setpoint <code>uAllMinSet</code> if <code>ascSet</code> is set to <code>false</code>.
</li>
<li>
If the setpoint change enabling input <code>uEna</code> is <code>false</code>, the commanded setpoint <code>yComSet</code> 
equals <code>min(uAllMaxSet,max(uAllMinSet,uCurSet))</code>.
</li>
</ul>

<p>
Note that the commanded setpoint <code>yComSet</code> is intended to be received by an external
setpoint controller, which will execute the setpoint change and pass the new setpoint
back to <code>uCurSet</code> in this block, completing a full control loop.
</p>

</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleStepSetpointChange;
