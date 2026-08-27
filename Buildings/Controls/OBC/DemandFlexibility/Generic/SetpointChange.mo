within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SetpointChange "Setpoint change"

  parameter Real setChaDel(min=0,start=0)
    "Setpoint change delta; always positive"
    annotation (Dialog(enable = use_mulSteSetCha));
  parameter Boolean ascSet
    "True: ascending setpoint; False: descending setpoint";
  parameter Boolean use_mulSteSetCha
    "If true, there are multiple smaller and incremental setpoint change steps; if false, there is a single setpoint change step";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uAllMaxSet
    "Allowed maximum setpoint"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
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
    "True: enable setpoint change"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "New setpoint"
    annotation (Placement(transformation(extent={{160,-100},{200,-60}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conAscSet(final k=ascSet)
    "Constant for ascending setpoint change"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiEna
    "Switch for enabling setpoint change"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Min uCurSetAllMin
    "Current setpoint should not be smaller than the allowed minimum setpoint"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Max uCurSetAllMax
    "Current setpoint should not be larger than the allowed maximum setpoint"
    annotation (Placement(transformation(extent={{60,-112},{80,-92}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal sigChaSetChaDel(
    final realTrue=setChaDel,
    final realFalse=-1*setChaDel)
    if use_mulSteSetCha
    "Sign change for the setpoint change delta"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Reals.Add addCurSet if use_mulSteSetCha
    "Adding setpoint change delta to the current setpoint"
    annotation (Placement(transformation(extent={{-60,36},{-40,56}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiMinMax if not use_mulSteSetCha
    "Switch between the allowed minimum and maximum setpoints"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(uEna, swiEna.u2)
    annotation (Line(points={{-180,120},{-10,120},{-10,-40},{-2,-40}},
      color={255,0,255}));
  connect(uCurSet, swiEna.u3)
    annotation (Line(points={{-180,40},{-140,40},{-140,-48},{-2,-48}},
      color={0,0,127}));
  connect(uAllMaxSet,uCurSetAllMin. u1)
    annotation (Line(points={{-180,-60},{-120,-60},{-120,-74},{118,-74}},
      color={0,0,127}));
  connect(uCurSetAllMax.y,uCurSetAllMin. u2)
    annotation (Line(points={{82,-102},{100,-102},{100,-86},{118,-86}},
      color={0,0,127}));
  connect(uCurSetAllMin.y, y)
    annotation (Line(points={{142,-80},{180,-80}}, color={0,0,127}));
  connect(conAscSet.y, sigChaSetChaDel.u)
    annotation (Line(points={{-118,90},{-102,90}}, color={255,0,255}));
  connect(addCurSet.y, swiEna.u1)
    annotation (Line(points={{-38,46},{-20,46},{-20,-32},{-2,-32}},
      color={0,0,127}));
  connect(uAllMaxSet,swiMinMax. u1)
    annotation (Line(points={{-180,-60},{-120,-60},{-120,8},{-62,8}},
      color={0,0,127}));
  connect(conAscSet.y, swiMinMax.u2)
    annotation (Line(points={{-118,90},{-110,90},{-110,0},{-62,0}},
      color={255,0,255}));
  connect(swiMinMax.y, swiEna.u1)
    annotation (Line(points={{-38,0},{-20,0},{-20,-32},{-2,-32}},
      color={0,0,127}));
  connect(swiMinMax.u3, uAllMinSet)
    annotation (Line(points={{-62,-8},{-100,-8},{-100,-120},{-180,-120}},
    color={0,0,127}));
  connect(sigChaSetChaDel.y, addCurSet.u1)
    annotation (Line(points={{-78,90},{-70,90},{-70,52},{-62,52}},
      color={0,0,127}));
  connect(uCurSet, addCurSet.u2)
    annotation (Line(points={{-180,40},{-62,40}},
      color={0,0,127}));
  connect(swiEna.y, uCurSetAllMax.u1)
    annotation (Line(points={{22,-40},{40,-40},{40,-96},{58,-96}}, color={0,0,127}));
  connect(uAllMinSet, uCurSetAllMax.u2)
    annotation (Line(points={{-180,-120},{-100,-120},{-100,-108},{58,-108}},
      color={0,0,127}));
  annotation (defaultComponentName="setCha",
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
This block conducts a setpoint change as follows:
</p>
<ul>
<li>
If the setpoint change enabling input <code>uEna</code> is <code>true</code>:
</li>
<ul>
<li>
If <code>use_mulSteSetCha</code> is <code>true</code>, the output is
<code>y = min(uAllMaxSet, max(uAllMinSet, uCurSet + setChaDel))</code> if the
parameter <code>ascSet</code> is set to <code>true</code>, or is
<code>y = min(uAllMaxSet, max(uAllMinSet, uCurSet - setChaDel))</code> if
<code>ascSet</code> is set to <code>false</code>.
</li>
<li>
If <code>use_mulSteSetCha</code> is <code>false</code>, the output <code>y</code> equals the
allowed maximum setpoint <code>uAllMaxSet</code> if the parameter
<code>ascSet</code> is set to <code>true</code>, or equals the allowed minimum
setpoint <code>uAllMinSet</code> if <code>ascSet</code> is set to <code>false</code>.
</li>
</ul>
<li>
If the setpoint change enabling input <code>uEna</code> is <code>false</code>, the
output is <code>y = min(uAllMaxSet, max(uAllMinSet, uCurSet))</code>.
</li>
</ul>
<p>
Note that the output <code>y</code> is intended to be received by a downstream
setpoint controller, which will process the setpoint change and pass its new
setpoint back to <code>uCurSet</code>, completing a full control loop.
</p>
</html>",revisions="<html>
<ul>
<li>
June 01, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SetpointChange;
