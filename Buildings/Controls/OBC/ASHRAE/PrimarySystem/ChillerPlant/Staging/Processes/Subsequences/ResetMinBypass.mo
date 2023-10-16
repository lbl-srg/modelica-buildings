within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block ResetMinBypass
  "Sequence for minimum chilled water flow setpoint reset"

  parameter Real aftByPasSetTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h") = 60
    "Time after setpoint achieved";
  parameter Real relFloDif=0.05
    "Relative error to the setpoint for checking if it has achieved flow rate setpoint"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before reset minimum flow setpoint"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Indicate if there is stage change"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinChiWat_setpoint(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Minimum chiller water flow setpoint"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMinBypRes
    "True: minimum chilled water flow bypass setpoint has been resetted successfully"
    annotation (Placement(transformation(extent={{160,-40},{200,0}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=relFloDif - 0.01,
    final uHigh=relFloDif + 0.01)
    "Check if chiller water flow rate is different from its setpoint"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{120,70},{140,90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=aftByPasSetTim)
    "Check if it has been over threshold time after new setpoint achieved"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div
    "Flow rate error divided by its setpoint"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=1e-6)
    "Add a small positive to avoid zero output"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg2
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs "Absolute value"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract floDif
    "Checkout the flow rate difference"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));

equation
  connect(uUpsDevSta, and2.u1)
    annotation (Line(points={{-180,80},{-82,80}}, color={255,0,255}));
  connect(chaPro, and2.u2)
    annotation (Line(points={{-180,40},{-140,40},{-140,72},{-82,72}},
      color={255,0,255}));
  connect(and2.y, and1.u1)
    annotation (Line(points={{-58,80},{-10,80},{-10,80},{118,80}},
      color={255,0,255}));
  connect(chaPro, not1.u)
    annotation (Line(points={{-180,40},{-140,40},{-140,20},{-122,20}},
      color={255,0,255}));
  connect(lat.y, and1.u2)
    annotation (Line(points={{102,40},{108,40},{108,72},{118,72}},
      color={255,0,255}));
  connect(VMinChiWat_setpoint, addPar.u)
    annotation (Line(points={{-180,-80},{-142,-80}}, color={0,0,127}));
  connect(div.y, hys.u)
    annotation (Line(points={{-78,-60},{-62,-60}}, color={0,0,127}));
  connect(not1.y, edg1.u)
    annotation (Line(points={{-98,20},{-82,20}}, color={255,0,255}));
  connect(edg1.y, lat.clr)
    annotation (Line(points={{-58,20},{70,20},{70,34},{78,34}},
      color={255,0,255}));
  connect(and3.y, tim.u)
    annotation (Line(points={{22,-20},{38,-20}},  color={255,0,255}));
  connect(addPar.y, div.u2)
    annotation (Line(points={{-118,-80},{-110,-80},{-110,-66},{-102,-66}},
      color={0,0,127}));
  connect(and3.y, edg2.u)
    annotation (Line(points={{22,-20},{30,-20},{30,40},{38,40}},
      color={255,0,255}));
  connect(edg2.y, lat.u)
    annotation (Line(points={{62,40},{78,40}}, color={255,0,255}));
  connect(VChiWat_flow, floDif.u1)
    annotation (Line(points={{-180,-20},{-140,-20},{-140,-14},{-122,-14}}, color={0,0,127}));
  connect(floDif.y, abs.u)
    annotation (Line(points={{-98,-20},{-82,-20}}, color={0,0,127}));
  connect(abs.y, div.u1)
    annotation (Line(points={{-58,-20},{-40,-20},{-40,-40},{-110,-40},{-110,-54},
          {-102,-54}}, color={0,0,127}));
  connect(hys.y, not2.u)
    annotation (Line(points={{-38,-60},{-22,-60}}, color={255,0,255}));
  connect(and2.y, and3.u1)
    annotation (Line(points={{-58,80},{-10,80},{-10,-20},{-2,-20}},
      color={255,0,255}));
  connect(not2.y, and3.u2)
    annotation (Line(points={{2,-60},{10,-60},{10,-40},{-10,-40},{-10,-28},
      {-2,-28}}, color={255,0,255}));
  connect(VMinChiWat_setpoint, floDif.u2) annotation (Line(points={{-180,-80},{-150,
          -80},{-150,-26},{-122,-26}}, color={0,0,127}));
  connect(and1.y, and4.u1) annotation (Line(points={{142,80},{150,80},{150,20},{
          100,20},{100,-20},{118,-20}}, color={255,0,255}));
  connect(tim.passed, and4.u2)
    annotation (Line(points={{62,-28},{118,-28}}, color={255,0,255}));
  connect(and4.y, yMinBypRes)
    annotation (Line(points={{142,-20},{180,-20}}, color={255,0,255}));
annotation (
  defaultComponentName="minBypRes",
  Icon(graphics={
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
          textString="uUpsDevSta")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-100},{160,100}})),
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
