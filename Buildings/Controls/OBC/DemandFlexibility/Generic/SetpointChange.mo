within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SetpointChange "Setpoint change"

  parameter Real setChaDel(min=0,start=0)
    "Setpoint change delta; always positive"
    annotation (Dialog(enable = incCha));
  parameter Boolean ascSet
    "True: ascending setpoint; False: descending setpoint";
  parameter Boolean incCha
    "True: the setpoint change step is incremental";

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
    "True: enable setpoint change"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "New setpoint"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conAscSet(final k=ascSet)
    "Constant for ascending setpoint change"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiEna
    "Switch for enabling setpoint change"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Min uCurSetAllMin
    "Current setpoint should not be smaller than the allowed minimum setpoint"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Reals.Max uCurSetAllMax
    "Current setpoint should not be larger than the allowed maximum setpoint"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal sigChaSetChaDel(
    realTrue=setChaDel, realFalse=-1*setChaDel) if incCha
    "Sign change for the setpoint change delta"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Reals.Add addCurSet if incCha
    "Adding setpoint change delta to the current setpoint"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiMinMax if not incCha
    "Switch between the allowed minimum and maximum setpoints"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(uEna, swiEna.u2) annotation (Line(points={{-180,120},{-10,120},{-10,-50},
          {-2,-50}}, color={255,0,255}));
  connect(uCurSet, swiEna.u3) annotation (Line(points={{-180,40},{-140,40},{
          -140,-58},{-2,-58}}, color={0,0,127}));
  connect(uAllMaxSet,uCurSetAllMin. u1) annotation (Line(points={{-180,-40},{
          -120,-40},{-120,30},{100,30},{100,6},{118,6}}, color={0,0,127}));
  connect(uCurSetAllMax.y,uCurSetAllMin. u2)
    annotation (Line(points={{82,0},{100,0},{100,-6},{118,-6}}, color={0,0,127}));
  connect(uCurSetAllMin.y, y)
    annotation (Line(points={{142,0},{180,0}}, color={0,0,127}));
  connect(conAscSet.y, sigChaSetChaDel.u)
    annotation (Line(points={{-118,70},{-102,70}}, color={255,0,255}));
  connect(addCurSet.y, swiEna.u1) annotation (Line(points={{-38,70},{-20,70},{-20,
          -42},{-2,-42}}, color={0,0,127}));
  connect(uAllMaxSet,swiMinMax. u1) annotation (Line(points={{-180,-40},{-120,-40},
          {-120,-2},{-62,-2}}, color={0,0,127}));
  connect(conAscSet.y, swiMinMax.u2) annotation (Line(points={{-118,70},{-110,70},
          {-110,-10},{-62,-10}}, color={255,0,255}));
  connect(swiMinMax.y, swiEna.u1) annotation (Line(points={{-38,-10},{-20,-10},{
          -20,-42},{-2,-42}}, color={0,0,127}));
  connect(swiMinMax.u3, uAllMinSet) annotation (Line(points={{-62,-18},{-80,-18},
          {-80,-120},{-180,-120}}, color={0,0,127}));
  connect(sigChaSetChaDel.y, addCurSet.u1) annotation (Line(points={{-78,70},{-70,
          70},{-70,76},{-62,76}}, color={0,0,127}));
  connect(uCurSet, addCurSet.u2) annotation (Line(points={{-180,40},{-70,40},{-70,
          64},{-62,64}}, color={0,0,127}));
  connect(swiEna.y, uCurSetAllMax.u1) annotation (Line(points={{22,-50},{40,-50},
          {40,6},{58,6}}, color={0,0,127}));
  connect(uAllMinSet, uCurSetAllMax.u2) annotation (Line(points={{-180,-120},{50,
          -120},{50,-6},{58,-6}}, color={0,0,127}));
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
If <code>incCha</code> is <code>true</code>, the output is
<code>y = min(uAllMaxSet, max(uAllMinSet, uCurSet + setChaDel))</code> if the
parameter <code>ascSet</code> is set to <code>true</code>, or is
<code>y = min(uAllMaxSet, max(uAllMinSet, uCurSet - setChaDel))</code> if
<code>ascSet</code> is set to <code>false</code>.
</li>
<li>
If <code>incCha</code> is <code>false</code>, the output <code>y</code> equals the
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
