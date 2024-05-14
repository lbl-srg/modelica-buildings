within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block ResetMinBypass
  "Sequence for minimum chilled water flow setpoint reset"

  parameter Real aftByPasSetTim(
    final unit="s",
    final quantity="Time") = 60
    "Time after setpoint achieved";
  parameter Real relFloDif=0.05
    "Relative error to the setpoint for checking if it has achieved flow rate setpoint"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before reset minimum flow setpoint"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Indicate if there is stage change"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput yChaSet
    "True: it is in the setpoint change process"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinChiWat_setpoint(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Minimum chiller water flow setpoint"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMinBypRes
    "True: minimum chilled water flow bypass setpoint has been resetted successfully"
    annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=1 - 1.5*relFloDif,
    final uHigh=1 - relFloDif)
    "Check if chiller water flow rate is greater than the minimum flow setpoint"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{120,110},{140,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=aftByPasSetTim)
    "Check if it has been over threshold time after new setpoint achieved"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div
    "Flow rate error divided by its setpoint"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=1e-6)
    "Add a small positive to avoid zero output"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg2
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs "Absolute value"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract floDif
    "Checkout the flow rate difference"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Logical and"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not notChaSet
    "Not in the setpoint changing process"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

equation
  connect(uUpsDevSta, and2.u1)
    annotation (Line(points={{-180,120},{-82,120}}, color={255,0,255}));
  connect(chaPro, and2.u2)
    annotation (Line(points={{-180,80},{-140,80},{-140,112},{-82,112}},
      color={255,0,255}));
  connect(and2.y, and1.u1)
    annotation (Line(points={{-58,120},{118,120}},
      color={255,0,255}));
  connect(chaPro, not1.u)
    annotation (Line(points={{-180,80},{-140,80},{-140,60},{-122,60}},
      color={255,0,255}));
  connect(lat.y, and1.u2)
    annotation (Line(points={{102,80},{108,80},{108,112},{118,112}},
      color={255,0,255}));
  connect(VMinChiWat_setpoint, addPar.u)
    annotation (Line(points={{-180,-120},{-142,-120}}, color={0,0,127}));
  connect(div.y, hys.u)
    annotation (Line(points={{-78,-100},{-62,-100}}, color={0,0,127}));
  connect(not1.y, edg1.u)
    annotation (Line(points={{-98,60},{-82,60}}, color={255,0,255}));
  connect(edg1.y, lat.clr)
    annotation (Line(points={{-58,60},{70,60},{70,74},{78,74}},
      color={255,0,255}));
  connect(and3.y, tim.u)
    annotation (Line(points={{22,-60},{38,-60}},  color={255,0,255}));
  connect(addPar.y, div.u2)
    annotation (Line(points={{-118,-120},{-110,-120},{-110,-106},{-102,-106}},
      color={0,0,127}));
  connect(and3.y, edg2.u)
    annotation (Line(points={{22,-60},{30,-60},{30,80},{38,80}},
      color={255,0,255}));
  connect(edg2.y, lat.u)
    annotation (Line(points={{62,80},{78,80}}, color={255,0,255}));
  connect(VChiWat_flow, floDif.u1)
    annotation (Line(points={{-180,-60},{-140,-60},{-140,-54},{-122,-54}}, color={0,0,127}));
  connect(floDif.y, abs.u)
    annotation (Line(points={{-98,-60},{-82,-60}}, color={0,0,127}));
  connect(hys.y, not2.u)
    annotation (Line(points={{-38,-100},{-22,-100}}, color={255,0,255}));
  connect(and2.y, and3.u1)
    annotation (Line(points={{-58,120},{-10,120},{-10,-60},{-2,-60}},
      color={255,0,255}));
  connect(VMinChiWat_setpoint, floDif.u2) annotation (Line(points={{-180,-120},{
          -150,-120},{-150,-66},{-122,-66}}, color={0,0,127}));
  connect(tim.passed, and4.u2)
    annotation (Line(points={{62,-68},{118,-68}}, color={255,0,255}));
  connect(and4.y, yMinBypRes)
    annotation (Line(points={{142,-60},{180,-60}}, color={255,0,255}));
  connect(hys.y, and3.u2) annotation (Line(points={{-38,-100},{-30,-100},{-30,-68},
          {-2,-68}}, color={255,0,255}));
  connect(VChiWat_flow, div.u1) annotation (Line(points={{-180,-60},{-140,-60},{
          -140,-94},{-102,-94}}, color={0,0,127}));
  connect(and1.y, and5.u2) annotation (Line(points={{142,120},{150,120},{150,40},
          {80,40},{80,-8},{98,-8}}, color={255,0,255}));
  connect(and5.y, and4.u1) annotation (Line(points={{122,0},{140,0},{140,-40},{100,
          -40},{100,-60},{118,-60}}, color={255,0,255}));
  connect(yChaSet, notChaSet.u)
    annotation (Line(points={{-180,0},{-122,0}}, color={255,0,255}));
  connect(notChaSet.y, and5.u1)
    annotation (Line(points={{-98,0},{98,0}}, color={255,0,255}));
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
          extent={{-98,-32},{-50,-46}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{-98,-72},{-30,-88}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinChiWat_setpoint"),
        Text(
          extent={{-98,46},{-66,36}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="chaPro"),
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
          extent={{-96,6},{-60,-6}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChaSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-160},{160,160}})),
  Documentation(info="<html>
<p>
Block that generates minimum bypass flow reset status when there is 
stage-change command.
This development is based on ASHRAE RP-1711 Advanced Sequences of Operation for 
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft on March 23, 2020),
section 5.2.4.16, item 2.
</p>
<p>
When there is stage-change command (<code>chaPro</code> = true) and the upstream
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
