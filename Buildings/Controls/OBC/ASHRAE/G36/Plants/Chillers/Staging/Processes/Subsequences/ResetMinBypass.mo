within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences;
block ResetMinBypass
  "Sequence for minimum chilled water flow setpoint reset"

  parameter Real byPasSetTim(unit="s")
    "Time constant for resetting minimum bypass flow";
  parameter Real aftByPasSetTim(
    final unit="s",
    final quantity="Time") = 60
    "Time after setpoint achieved";
  parameter Real relFloThr=0.95
    "Relative flow rate to check if the flow has achieved setpoint"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before reset minimum flow setpoint"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaPro
    "Indicate if there is stage change"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-10},{-160,30}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinChiWat_setpoint(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSetChaPro
    "True: it is in the setpoint change process"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMinBypRes
    "True: minimum chilled water flow bypass valve has been reset successfully"
    annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{120,110},{140,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=aftByPasSetTim)
    "Check if it has been over threshold time after new setpoint achieved"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "In staging process and the upstream device status has been changed"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not notChaSet
    "Not in the setpoint changing process"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And and6
    "Check if it is not in the setpoint changing process and the setpoint has been achieved"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Check if the valve is being changed"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Edge when the valve has been reset successfully"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg3
    "Edge when it starts changing the minimum bypass flow valve"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 "Logical and"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and7 "Logical and"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=byPasSetTim)
    "Check the flow setpoint after changing time"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold achSet(
    final t=relFloThr,
    final h=0.01)
    "Check if chilled water flow rate achieves the minimum flow setpoint"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nonZerCon(
    final k=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Non-zero constant"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Divide relFlo "Relative flow rate"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Reals.Max nonZer "Non zero output"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

equation
  connect(uUpsDevSta, and2.u1)
    annotation (Line(points={{-180,120},{-142,120}},color={255,0,255}));
  connect(uStaPro, and2.u2) annotation (Line(points={{-180,80},{-150,80},{-150,112},
          {-142,112}},color={255,0,255}));
  connect(and2.y, and1.u1)
    annotation (Line(points={{-118,120},{118,120}},color={255,0,255}));
  connect(uStaPro, not1.u) annotation (Line(points={{-180,80},{-150,80},{-150,60},
          {-142,60}}, color={255,0,255}));
  connect(lat.y, and1.u2)
    annotation (Line(points={{102,80},{108,80},{108,112},{118,112}},
      color={255,0,255}));
  connect(not1.y, edg1.u)
    annotation (Line(points={{-118,60},{-102,60}}, color={255,0,255}));
  connect(edg1.y, lat.clr)
    annotation (Line(points={{-78,60},{70,60},{70,74},{78,74}},
      color={255,0,255}));
  connect(and2.y, and3.u1)
    annotation (Line(points={{-118,120},{-50,120},{-50,0},{-42,0}},
      color={255,0,255}));
  connect(tim.passed, and4.u2)
    annotation (Line(points={{62,-8},{78,-8}}, color={255,0,255}));
  connect(uSetChaPro, notChaSet.u)
    annotation (Line(points={{-180,-140},{-102,-140}}, color={255,0,255}));
  connect(notChaSet.y, and6.u2) annotation (Line(points={{-78,-140},{-10,-140},{
          -10,-8},{-2,-8}},   color={255,0,255}));
  connect(and1.y, and4.u1) annotation (Line(points={{142,120},{150,120},{150,40},
          {70,40},{70,0},{78,0}},   color={255,0,255}));
  connect(and4.y, edg.u)
    annotation (Line(points={{102,0},{118,0}},   color={255,0,255}));
  connect(uStaPro, edg3.u) annotation (Line(points={{-180,80},{-60,80},{-60,-120},
          {18,-120}},       color={255,0,255}));
  connect(edg3.y, lat1.clr) annotation (Line(points={{42,-120},{60,-120},{60,-126},
          {78,-126}},        color={255,0,255}));
  connect(lat1.y, and5.u2) annotation (Line(points={{102,-120},{110,-120},{110,-108},
          {118,-108}},color={255,0,255}));
  connect(uStaPro, and5.u1) annotation (Line(points={{-180,80},{-60,80},{-60,-100},
          {118,-100}},color={255,0,255}));
  connect(and2.y, truDel.u) annotation (Line(points={{-118,120},{-50,120},{-50,-60},
          {38,-60}}, color={255,0,255}));
  connect(truDel.y, and7.u1)
    annotation (Line(points={{62,-60},{118,-60}}, color={255,0,255}));
  connect(and5.y, and7.u2) annotation (Line(points={{142,-100},{150,-100},{150,
          -80},{100,-80},{100,-68},{118,-68}}, color={255,0,255}));
  connect(and7.y, yMinBypRes)
    annotation (Line(points={{142,-60},{180,-60}}, color={255,0,255}));
  connect(and3.y, and6.u1)
    annotation (Line(points={{-18,0},{-2,0}}, color={255,0,255}));
  connect(and6.y, tim.u)
    annotation (Line(points={{22,0},{38,0}}, color={255,0,255}));
  connect(and6.y, lat.u) annotation (Line(points={{22,0},{30,0},{30,80},{78,80}},
        color={255,0,255}));
  connect(edg.y, lat1.u) annotation (Line(points={{142,0},{150,0},{150,-40},{70,
          -40},{70,-120},{78,-120}}, color={255,0,255}));
  connect(VChiWat_flow, relFlo.u1) annotation (Line(points={{-180,10},{-150,10},
          {-150,6},{-142,6}}, color={0,0,127}));
  connect(relFlo.y, achSet.u)
    annotation (Line(points={{-118,0},{-102,0}}, color={0,0,127}));
  connect(nonZerCon.y, nonZer.u2) annotation (Line(points={{-118,-90},{-110,-90},
          {-110,-76},{-102,-76}}, color={0,0,127}));
  connect(VMinChiWat_setpoint, nonZer.u1) annotation (Line(points={{-180,-50},{-110,
          -50},{-110,-64},{-102,-64}}, color={0,0,127}));
  connect(nonZer.y, relFlo.u2) annotation (Line(points={{-78,-70},{-70,-70},{-70,
          -32},{-150,-32},{-150,-6},{-142,-6}}, color={0,0,127}));
  connect(achSet.y, and3.u2) annotation (Line(points={{-78,0},{-70,0},{-70,-8},{
          -42,-8}}, color={255,0,255}));
annotation (
  defaultComponentName="minBypRes",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{50,8},{98,-8}},
          textColor={255,0,255},
          textString="yMinBypRes"),
        Text(
          extent={{-98,8},{-50,-6}},
          textColor={0,0,127},
          textString="VChiWat_flow"),
        Text(
          extent={{-98,-32},{-30,-48}},
          textColor={0,0,127},
          textString="VMinChiWat_setpoint"),
        Text(
          extent={{-98,46},{-66,36}},
          textColor={255,0,255},
          textString="uStaPro"),
      Text(
        extent={{-100,100},{100,-100}},
        textColor={0,0,0},
        textString="S"),
        Text(
          extent={{-98,88},{-52,76}},
          textColor={255,0,255},
          textString="uUpsDevSta"),
        Text(
          extent={{-96,-72},{-54,-86}},
          textColor={255,0,255},
          textString="uSetChaPro")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-160},{160,160}})),
  Documentation(info="<html>
<p>
Block that generates minimum bypass flow reset status when there is 
a stage-change command.
This development is based on ASHRAE Guideline 36-2021, section 5.20.4.16, item b.
</p>
<p>
When there is a stage-change command (<code>uStaPro</code> = true) and the upstream
device has finished its adjustment process (<code>uUpsDevSta</code> = true), 
like in the stage-up process the operating chillers have reduced the demand, 
check if the minimum chilled water flow rate <code>VChiWat_flow</code> has achieved 
its new setpoint <code>VMinChiWat_setpoint</code>. 
After new setpoint is achieved, wait for 1 minute (<code>aftByPasSetTim</code>) to 
allow loop to be stabilized. It will then set <code>yMinBypRes</code> to true.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 17, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ResetMinBypass;
