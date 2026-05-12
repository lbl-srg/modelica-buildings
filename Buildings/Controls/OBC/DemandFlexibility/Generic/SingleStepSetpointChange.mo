within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SingleStepSetpointChange "Single-step setpoint change"

  parameter Boolean reverseActing
    "True: command the setpoint to the minimum; False: command the setpoint to the maximum";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxSet "Maximum setpoint"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,-38},{-100,2}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMinSet "Minimum setpoint"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCurSet "Current setpoint"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
        iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna
    "The signal to enable setpoint change"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSet "Commanded setpoint"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swiMinMax
    "Switch between the minimum and maximum setpoint"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant reverseActingCon(final k=
        reverseActing)
    "Boolean constant for reverse acting"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swiEna
    "Switch for enabling the setpoint change signal"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Min uCurSetLimMin
    "Current setpoint should not be smaller than the minimum setpoint input"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

  Buildings.Controls.OBC.CDL.Reals.Max uCurSetLimMax
    "Current setpoint should not be larger than the maximum setpoint input"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(uEna, swiEna.u2) annotation (Line(points={{-180,120},{-100,120},{-100,
          -70},{18,-70}}, color={255,0,255}));
  connect(uCurSet, swiEna.u3) annotation (Line(points={{-180,40},{-80,40},{-80,-78},
          {18,-78}},      color={0,0,127}));
  connect(reverseActingCon.y, swiMinMax.u2) annotation (Line(points={{-38,30},{-30,
          30},{-30,-30},{-22,-30}}, color={255,0,255}));
  connect(swiMinMax.y, swiEna.u1) annotation (Line(points={{2,-30},{10,-30},{10,
          -62},{18,-62}},      color={0,0,127}));
  connect(uMaxSet, uCurSetLimMin.u1) annotation (Line(points={{-180,-40},{-140,-40},
          {-140,80},{100,80},{100,6},{118,6}},
                                            color={0,0,127}));
  connect(uMinSet, uCurSetLimMax.u1) annotation (Line(points={{-180,-120},{-120,
          -120},{-120,60},{40,60},{40,6},{58,6}}, color={0,0,127}));
  connect(swiEna.y, uCurSetLimMax.u2) annotation (Line(points={{42,-70},{50,-70},
          {50,-6},{58,-6}}, color={0,0,127}));
  connect(uCurSetLimMax.y, uCurSetLimMin.u2)
    annotation (Line(points={{82,0},{100,0},{100,-6},{118,-6}},
                                                             color={0,0,127}));
  connect(uCurSetLimMin.y, yComSet)
    annotation (Line(points={{142,0},{180,0}}, color={0,0,127}));
  connect(uMinSet, swiMinMax.u1) annotation (Line(points={{-180,-120},{-120,
          -120},{-120,-22},{-22,-22}}, color={0,0,127}));
  connect(uMaxSet, swiMinMax.u3) annotation (Line(points={{-180,-40},{-140,-40},
          {-140,-38},{-22,-38}}, color={0,0,127}));
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
This block changes a setpoint to either the minimum setpoint value or the maximum setpoint value
in a single step when the signal to enable setpoint change becomes <code>true</code>.
</p>

<p>
All input and output variables are defined as follows: 
</p>

<ul>
<li>
<code>uEna</code>: a boolean input variable, which  
specifies whether to enable the single-step setpoint change operation or not.
</li>
<li>
<code>uCurSet</code>: the current setpoint, which represents the setpoint value that an 
external setpoint controller currently has.
</li>
<li>
<code>uMinSet</code>: the minimum setpoint, which represents the lowest setpoint value
that the commanded setpoint <code>yComSet</code> is allowed to have.
</li>
<li>
<code>uMaxSet</code>: the maximum setpoint, which represents the highest setpoint value
that the commanded setpoint <code>yComSet</code> is allowed to have.
</li>
<li>
<code>yComSet</code>: the commanded setpoint, which represents the setpoint value 
that an external setpoint controller should change to.
</li>
</ul>

<p>
This block conducts a single-step setpoint change as below:
</p>

<ul>
<li>
If the enabling setpoint limits input (<code>uEna</code>) is true, the new setpoint (<code>yComSet</code>) 
equals the allowed minimum setpoint <code>uMinSet</code> if reverseActing is set to <code>true</code>, or 
equals the allowed maximum setpoint if <code>reverseActing</code> is <code>false</code>.
</li>
<li>
If the enabling setpoint limits input (<code>uEna</code>) is <code>false</code>, the new setpoint (<code>yComSet</code>) 
equals <code>min(uMaxSet,max(uMinSet,uCurSet))</code>.
</li>
</ul>

<p>
Note that the output variable <code>yComSet</code> is intended to be received by an external
setpoint controller, which will execute the setpoint change and pass the new setpoint
back to the input variable <code>uCurSet</code> in this block, completing a full control loop.
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
