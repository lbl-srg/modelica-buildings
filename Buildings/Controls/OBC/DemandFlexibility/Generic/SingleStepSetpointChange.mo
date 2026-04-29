within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SingleStepSetpointChange "Single-step setpoint change"

  parameter Real alwDev(min=1E-6)
    "Allowed deviation for equality";
  parameter Boolean setChaMod
    "Setpoint change mode; true to go to the target setpoint value, false to go to the default setpoint value";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxSet
    "Target setpoint: the setpoint under load-shed or load-increase scenarios"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,-38},{-100,2}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMinSet
    "Default setpoint: the setpoint under normal conditions"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCurSet "Current setpoint"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna
    "\"Enable\" signal for the setpoint change"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSet
    "Command setpoint output: the setpoint that an external controller should change to"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reach_uMaxSet "Reached the target setpoint"
    annotation (Placement(transformation(extent={{160,70},{200,110}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reach_uMinSet "Reached the default setpoint" annotation (Placement(
    transformation(extent={{160,-110},{200,-70}}), iconTransformation(extent={{100,-70},
            {140,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiDefTar
    "Switch between the default setpoint and the target setpoint"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant setChaModCon(final k=
        setChaMod) "Setpoint change mode boolean constant"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiEna
    "Switch for the \"enable\" signal"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Min uCurSetLimMin
    "Current setpoint should be no smaller than the minimum setpoint limit"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Reals.Max uCurSetLimMax
    "Current setpoint should be no larger than the maximum setpoint limit"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.RealEqual reaEquMaxSet(alwDev=
        alwDev)
    "Check if the current setpoint and the target setpoint are equal to each other"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.RealEqual reaEquMinSet(alwDev=
        alwDev)
    "Check if the current setpoint and the default setpoint are equal to each other"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));
equation
  connect(uEna, swiEna.u2) annotation (Line(points={{-180,120},{-104,120},{-104,
          -70},{-2,-70}}, color={255,0,255}));
  connect(uCurSet, swiEna.u3) annotation (Line(points={{-180,40},{-56,40},{-56,
          -78},{-2,-78}}, color={0,0,127}));
  connect(setChaModCon.y, swiDefTar.u2) annotation (Line(points={{-118,-170},{-48,
          -170},{-48,-30},{-42,-30}}, color={255,0,255}));
  connect(uMaxSet, swiDefTar.u1) annotation (Line(points={{-180,-40},{-110,-40},
          {-110,-22},{-42,-22}}, color={0,0,127}));
  connect(uMinSet, swiDefTar.u3) annotation (Line(points={{-180,-120},{-76,-120},
          {-76,-38},{-42,-38}}, color={0,0,127}));
  connect(swiDefTar.y, swiEna.u1) annotation (Line(points={{-18,-30},{-12,-30},
          {-12,-62},{-2,-62}}, color={0,0,127}));
  connect(reaEquMaxSet.y, reach_uMaxSet) annotation (Line(points={{2,150},{80,
          150},{80,90},{180,90}}, color={255,0,255}));
  connect(uCurSet, reaEquMaxSet.u1) annotation (Line(points={{-180,40},{-122,40},
          {-122,156},{-22,156}}, color={0,0,127}));
  connect(uMaxSet, reaEquMaxSet.u2) annotation (Line(points={{-180,-40},{-136,-40},
          {-136,144},{-22,144}}, color={0,0,127}));
  connect(uCurSet, reaEquMinSet.u1) annotation (Line(points={{-180,40},{-56,40},
          {-56,-144},{-22,-144}}, color={0,0,127}));
  connect(uMinSet, reaEquMinSet.u2) annotation (Line(points={{-180,-120},{-64,-120},
          {-64,-156},{-22,-156}}, color={0,0,127}));
  connect(reaEquMinSet.y, reach_uMinSet) annotation (Line(points={{2,-150},{80,
          -150},{80,-90},{180,-90}}, color={255,0,255}));
  connect(uMaxSet, uCurSetLimMin.u1) annotation (Line(points={{-180,-40},{-136,-40},
          {-136,68},{82,68},{82,6},{98,6}}, color={0,0,127}));
  connect(uMinSet, uCurSetLimMax.u1) annotation (Line(points={{-180,-120},{-130,
          -120},{-130,56},{10,56},{10,6},{38,6}}, color={0,0,127}));
  connect(swiEna.y, uCurSetLimMax.u2) annotation (Line(points={{22,-70},{32,-70},
          {32,-6},{38,-6}}, color={0,0,127}));
  connect(uCurSetLimMax.y, uCurSetLimMin.u2)
    annotation (Line(points={{62,0},{76,0},{76,-6},{98,-6}}, color={0,0,127}));
  connect(uCurSetLimMin.y, yComSet)
    annotation (Line(points={{122,0},{180,0}}, color={0,0,127}));
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
    extent={{-160,-200},{160,200}},
    grid={2,2})),
    Documentation(info="<html>
<p>
This block changes a setpoint from one setpoint value to another setpoint value
in a single step when the \"enable\" signal becomes <code>true</code>.
</p>

<p>
Several input variables are defined as follows: 
</p>

<ul>
<li>
<code>uCurSet</code>: the current setpoint, which represents the current value of the setpoint from an 
external zone temperature controller or equipment controller.
This is the setpoint that needs to be changed during load-shed or load-increase
demand flexibility actions.
</li>
<li>
<code>uMinSet</code>: the default setpoint, which represents the 
hypothetical setpoint value if a setpoint were to not participate in load-shed or load-increase
demand flexibility actions. 
The current setpoint <code>uCurSet</code> is expected to have the same value as the default setpoint when 
the demand flexibility actions are not active.
The default setpoint is constant most of the time, although its 
value could change when the occupancy mode is switched between the unoccupied mode and the occupied mode.
The default setpoint serves as either a lower limit or an upper limit for the current setpoint <code>uCurSet</code>.
</li>
<li>
<code>uMaxSet</code>: the target setpoint, which represents the setpoint value under 
load-shed or load-increase demand flexibility actions.
The current setpoint <code>uCurSet</code> is expected to have the same value as the target setpoint when 
the demand flexibility actions are active.
The target setpoint is constant most of the time, although its 
value could change when the occupancy mode is switched between the unoccupied mode and the occupied mode. 
The target setpoint serves as either a lower limit or an upper limit for the current setpoint <code>uCurSet</code>.
</li>
</ul>

<p>
The parameter <code>setChaMod</code> specifies whether the current 
setpoint <code>uCurSet</code> shall change to the <code>uMinSet</code> value or the 
<code>uMaxSet</code> value in a single step. 
The resultant setpoint will be outputted as the  command setpoint 
<code>yComSet</code>, which 
represents the new setpoint that a zone or a piece of equipment shall have. 
The output variable <code>yComSet</code> is intended to be received by an external
zone temperature controller or equipment controller, which will execute the setpoint change and pass the new setpoint
back to the input variable <code>uCurSet</code> in this block, completing a full control loop.
</p>

<p>
The <code>uEna</code> boolean input variable 
specifies whether a setpoint has an \"enable\" signal to execute the single-step setpoint change operation. When the 
<code>uEna</code> input variable is set to <code>true</code>, either <code>uMinSet</code> or 
<code>uMaxSet</code> is passed to <code>yComSet</code>, depending on the parameter value of <code>setChaMod</code>.
When <code>uEna</code> is changed to <code>false</code> from a previous 
<code>true</code> value, <code>yComSet</code> will simply take the value <code>uCurSet</code> 
and will not be reverted to the previous value,either <code>uMinSet</code> or <code>uMaxSet</code>,
before the setpoint change operation. 
Reversing this unidirectional change to the current setpoint <code>uCurSet</code> needs to happen 
outside of this block. 
</p>

<p>
Output variables also include boolean flags that specify whether the current 
setpoint has reached the default setpoint <code>uMinSet</code> or the target setpoint 
<code>uMaxSet</code>. 
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
