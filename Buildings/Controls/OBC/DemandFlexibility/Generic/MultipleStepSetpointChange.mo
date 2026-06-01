within Buildings.Controls.OBC.DemandFlexibility.Generic;
block MultipleStepSetpointChange "Multiple-step setpoint change"

  parameter Real setChaDel(min=0)
    "Setpoint change delta; always positive";

  parameter Boolean ascSet
    "If true, command the setpoint toward the allowed maximum setpoint, otherwise toward the allowed minimum setpoint";

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
    "If true, allow the setpoint to be changed, otherwise output uCurSet, constrained within uAllMinSet and uAllMaxSet"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "New setpoint"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conAscSet(final k=ascSet)
    "Constant for ascending setpoint change"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swiEna
    "Switch for enabling setpoint change"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Min uCurSetAllMin
    "Current setpoint should not be smaller than the allowed minimum setpoint"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

  Buildings.Controls.OBC.CDL.Reals.Max uCurSetAllMax
    "Current setpoint should not be larger than the allowed maximum setpoint"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal sigChaSetChaDel(realTrue=setChaDel, realFalse=-1*setChaDel)
    "Sign change for the setpoint change delta"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Add addCurSet
    "Adding setpoint change delta to the current setpoint"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

equation
  connect(uEna, swiEna.u2) annotation (Line(points={{-180,120},{-20,120},{-20,
          -50},{-2,-50}}, color={255,0,255}));
  connect(uCurSet, swiEna.u3) annotation (Line(points={{-180,40},{-140,40},{
          -140,-58},{-2,-58}},
                          color={0,0,127}));
  connect(uAllMaxSet,uCurSetAllMin. u1) annotation (Line(points={{-180,-40},{
          -120,-40},{-120,30},{100,30},{100,6},{118,6}},
                                            color={0,0,127}));
  connect(uAllMinSet,uCurSetAllMax. u1) annotation (Line(points={{-180,-120},{
          40,-120},{40,6},{58,6}},                color={0,0,127}));
  connect(swiEna.y,uCurSetAllMax. u2) annotation (Line(points={{22,-50},{50,-50},
          {50,-6},{58,-6}}, color={0,0,127}));
  connect(uCurSetAllMax.y,uCurSetAllMin. u2)
    annotation (Line(points={{82,0},{100,0},{100,-6},{118,-6}},
                                                             color={0,0,127}));
  connect(uCurSetAllMin.y, y)
    annotation (Line(points={{142,0},{180,0}}, color={0,0,127}));
  connect(conAscSet.y, sigChaSetChaDel.u)
    annotation (Line(points={{-118,-90},{-102,-90}}, color={255,0,255}));
  connect(sigChaSetChaDel.y, addCurSet.u2) annotation (Line(points={{-78,-90},{-70,
          -90},{-70,-36},{-62,-36}}, color={0,0,127}));
  connect(uCurSet, addCurSet.u1) annotation (Line(points={{-180,40},{-70,40},{-70,
          -24},{-62,-24}}, color={0,0,127}));
  connect(addCurSet.y, swiEna.u1) annotation (Line(points={{-38,-30},{-30,-30},
          {-30,-42},{-2,-42}},color={0,0,127}));
  annotation (defaultComponentName="mulSteSetCha",
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
This block conducts a multiple-step setpoint change as follows:
</p>

<ul>
<li>
If the setpoint change enabling input <code>uEna</code> is <code>true</code>, the output is <code>y = min(uAllMaxSet, max(uAllMinSet, uCurSet + setChaDel))</code> 
if the parameter <code>ascSet</code> is set to <code>true</code>, or is <code>y = min(uAllMaxSet, max(uAllMinSet, uCurSet - setChaDel))</code>
if <code>ascSet</code> is set to <code>false</code>.
</li>
<li>
If the setpoint change enabling input <code>uEna</code> is <code>false</code>, the output is <code>y = min(uAllMaxSet, max(uAllMinSet, uCurSet))</code>.
</li>
</ul>

<p>
Note that the output <code>y</code> is intended to be received by a downstream
setpoint controller, which will process the setpoint change and pass its new setpoint
back to <code>uCurSet</code>, completing a full control loop.
</p>

</html>",
        revisions="<html>
<ul>
<li>
June 01, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end MultipleStepSetpointChange;
