within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block ResetMinBypass
  "Sequence for minimum chilled water flow setpoint reset"

  parameter Real aftByPasSetTim(
    final unit="s",
    final quantity="Time") = 60
    "Time after setpoint achieved";
  parameter Real relFloDif=0.01
    "Relative error to the setpoint for checking if it has achieved flow rate setpoint"
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
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinChiWat_setpoint(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum chiller water flow setpoint"
    annotation (Placement(transformation(extent={{-200,-90},{-160,-50}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSetChaPro
    "True: it is in the setpoint change process"
    annotation (Placement(transformation(extent={{-200,-130},{-160,-90}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMinBypRes
    "True: minimum chilled water flow bypass valve has been resetted successfully"
    annotation (Placement(transformation(extent={{160,-100},{200,-60}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{120,110},{140,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=aftByPasSetTim)
    "Check if it has been over threshold time after new setpoint achieved"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div
    "Flow rate error divided by its setpoint"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=1e-6)
    "Add a small positive to avoid zero output"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg2
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs "Absolute value"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract floDif
    "Checkout the flow rate difference"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not notChaSet
    "Not in the setpoint changing process"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And and6 "Logical and"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not notChaSet1
    "Not in the setpoint changing process"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Minimum flow valve should not be changed"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Check if the valve is being changed"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Edge when the valve has been resetted successfully"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg3
    "Edge when it starts changing the minimum bypass flow valve"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr(
    final t=relFloDif,
    final h=0.5*relFloDif)
    "Check if chiller water flow rate achieves the minimum flow setpoint"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

equation
  connect(uUpsDevSta, and2.u1)
    annotation (Line(points={{-180,120},{-82,120}}, color={255,0,255}));
  connect(uStaPro, and2.u2) annotation (Line(points={{-180,80},{-140,80},{-140,112},
          {-82,112}}, color={255,0,255}));
  connect(and2.y, and1.u1)
    annotation (Line(points={{-58,120},{118,120}},
      color={255,0,255}));
  connect(uStaPro, not1.u) annotation (Line(points={{-180,80},{-140,80},{-140,60},
          {-122,60}}, color={255,0,255}));
  connect(lat.y, and1.u2)
    annotation (Line(points={{102,80},{108,80},{108,112},{118,112}},
      color={255,0,255}));
  connect(VMinChiWat_setpoint, addPar.u)
    annotation (Line(points={{-180,-70},{-142,-70}}, color={0,0,127}));
  connect(not1.y, edg1.u)
    annotation (Line(points={{-98,60},{-82,60}}, color={255,0,255}));
  connect(edg1.y, lat.clr)
    annotation (Line(points={{-58,60},{70,60},{70,74},{78,74}},
      color={255,0,255}));
  connect(and3.y, tim.u)
    annotation (Line(points={{22,0},{38,0}}, color={255,0,255}));
  connect(addPar.y, div.u2)
    annotation (Line(points={{-118,-70},{-110,-70},{-110,-56},{-102,-56}},
      color={0,0,127}));
  connect(and3.y, edg2.u)
    annotation (Line(points={{22,0},{30,0},{30,80},{38,80}},
      color={255,0,255}));
  connect(edg2.y, lat.u)
    annotation (Line(points={{62,80},{78,80}}, color={255,0,255}));
  connect(VChiWat_flow, floDif.u1)
    annotation (Line(points={{-180,20},{-140,20},{-140,6},{-122,6}}, color={0,0,127}));
  connect(floDif.y, abs.u)
    annotation (Line(points={{-98,0},{-82,0}}, color={0,0,127}));
  connect(and2.y, and3.u1)
    annotation (Line(points={{-58,120},{-10,120},{-10,0},{-2,0}},
      color={255,0,255}));
  connect(VMinChiWat_setpoint, floDif.u2) annotation (Line(points={{-180,-70},{-150,
          -70},{-150,-6},{-122,-6}}, color={0,0,127}));
  connect(tim.passed, and4.u2)
    annotation (Line(points={{62,-8},{78,-8}}, color={255,0,255}));
  connect(uSetChaPro, notChaSet.u)
    annotation (Line(points={{-180,-110},{-122,-110}}, color={255,0,255}));
  connect(and2.y, and6.u1) annotation (Line(points={{-58,120},{-10,120},{-10,-80},
          {-2,-80}}, color={255,0,255}));
  connect(notChaSet.y, and6.u2) annotation (Line(points={{-98,-110},{-10,-110},{
          -10,-88},{-2,-88}}, color={255,0,255}));
  connect(and6.y, notChaSet1.u)
    annotation (Line(points={{22,-80},{38,-80}}, color={255,0,255}));
  connect(notChaSet1.y, or2.u1)
    annotation (Line(points={{62,-80},{78,-80}}, color={255,0,255}));
  connect(and1.y, and4.u1) annotation (Line(points={{142,120},{150,120},{150,40},
          {70,40},{70,0},{78,0}}, color={255,0,255}));
  connect(and4.y, edg.u)
    annotation (Line(points={{102,0},{118,0}}, color={255,0,255}));
  connect(edg.y, or2.u2) annotation (Line(points={{142,0},{150,0},{150,-40},{70,
          -40},{70,-88},{78,-88}}, color={255,0,255}));
  connect(or2.y, lat1.u)
    annotation (Line(points={{102,-80},{118,-80}}, color={255,0,255}));
  connect(edg3.y, lat1.clr) annotation (Line(points={{62,-130},{110,-130},{110,
          -86},{118,-86}},
                      color={255,0,255}));
  connect(lat1.y, yMinBypRes)
    annotation (Line(points={{142,-80},{180,-80}}, color={255,0,255}));
  connect(abs.y, div.u1) annotation (Line(points={{-58,0},{-50,0},{-50,-20},{-110,
          -20},{-110,-44},{-102,-44}}, color={0,0,127}));
  connect(div.y, lesThr.u)
    annotation (Line(points={{-78,-50},{-62,-50}}, color={0,0,127}));
  connect(lesThr.y, and3.u2) annotation (Line(points={{-38,-50},{-20,-50},{-20,-8},
          {-2,-8}}, color={255,0,255}));
  connect(uStaPro, edg3.u) annotation (Line(points={{-180,80},{-154,80},{-154,
          -130},{38,-130}}, color={255,0,255}));
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
          pattern=LinePattern.Dash,
          textString="yMinBypRes"),
        Text(
          extent={{-98,8},{-50,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{-98,-32},{-30,-48}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinChiWat_setpoint"),
        Text(
          extent={{-98,46},{-66,36}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaPro"),
      Text(
        extent={{-100,100},{100,-100}},
        textColor={0,0,0},
        textString="S"),
        Text(
          extent={{-98,88},{-52,76}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uUpsDevSta"),
        Text(
          extent={{-96,-72},{-54,-86}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uSetChaPro")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-160},{160,160}})),
  Documentation(info="<html>
<p>
Block that generates minimum bypass flow reset status when there is 
stage-change command.
This development is based on ASHRAE Guideline36-2021, section 5.20.4.16, item b.
</p>
<p>
When there is stage-change command (<code>uStaPro</code> = true) and the upstream
device has finished its adjustment process (<code>uUpsDevSta</code> = true), 
like in the stage-up process the operating chillers have reduced the demand, 
check if the minimum chilled water flow rate <code>VChiWat_flow</code> has achieved 
its new set point <code>VMinChiWat_setpoint</code>. 
After new setpoint is achieved, wait for 1 minute (<code>byPasSetTim</code>) to 
allow loop to stabilize. It will then set <code>yMinBypRes</code> to true.
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
