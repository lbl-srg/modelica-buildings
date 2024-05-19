within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences;
block ResetMinBypass
    "Sequence for minimum hot water flow setpoint reset"

  parameter Real delEna(
    final unit="s",
    final quantity="Time",
    displayUnit="s") = 60
    "Enable delay after setpoint achieved";

  parameter Real relFloDif(
    final unit="1",
    displayUnit="1")=0.05
    "Relative error to the setpoint for checking if it has achieved flow rate setpoint"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Reset status of upstream device before resetting minimum flow setpoint"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Continuous signal indicating if stage change is in process"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWat_flow(
    final min=0,
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot water flow rate"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinHotWatSet_flow(
    final min=0,
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum hot water flow setpoint"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMinBypRes
    "True: minimum hot water flow bypass setpoint has been reset successfully"
    annotation (Placement(transformation(extent={{160,60},{200,100}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=-relFloDif,
    final uHigh=0)
    "Check if boiler water flow rate is different from its setpoint"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd and1(
    final nin=3)
    "Logical and"
    annotation (Placement(transformation(extent={{120,70},{140,90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=delEna)
    "Time after achieving setpoint"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical and"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));

  Buildings.Controls.OBC.CDL.Reals.Divide div
    "Flow rate error divided by its setpoint"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=1e-6)
    "Add a small positive to avoid zero output"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg2
    "Rising edge"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Find difference between measured flowrate and minimum flow setpoint"
    annotation (Placement(transformation(extent={{-148,-30},{-128,-10}})));

equation
  connect(uUpsDevSta, and2.u1)
    annotation (Line(points={{-180,80},{-82,80}}, color={255,0,255}));

  connect(chaPro, and2.u2)
    annotation (Line(points={{-180,40},{-140,40},{-140,72},{-82,72}},
      color={255,0,255}));

  connect(and1.y,yMinBypRes)
    annotation (Line(points={{142,80},{180,80}}, color={255,0,255}));

  connect(chaPro, not1.u)
    annotation (Line(points={{-180,40},{-140,40},{-140,20},{-122,20}},
      color={255,0,255}));

  connect(VMinHotWatSet_flow, addPar.u)
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

  connect(and2.y, and3.u1)
    annotation (Line(points={{-58,80},{-10,80},{-10,-20},{-2,-20}},
      color={255,0,255}));

  connect(sub2.u1, VHotWat_flow) annotation (Line(points={{-150,-14},{-154,-14},
          {-154,-20},{-180,-20}}, color={0,0,127}));

  connect(sub2.u2, VMinHotWatSet_flow) annotation (Line(points={{-150,-26},{-154,
          -26},{-154,-80},{-180,-80}}, color={0,0,127}));

  connect(hys.y, and3.u2) annotation (Line(points={{-38,-60},{-10,-60},{-10,-28},
          {-2,-28}}, color={255,0,255}));
  connect(sub2.y, div.u1) annotation (Line(points={{-126,-20},{-110,-20},{-110,-54},
          {-102,-54}}, color={0,0,127}));
  connect(and2.y, and1.u[1]) annotation (Line(points={{-58,80},{32,80},{32,
          84.6667},{118,84.6667}},
                          color={255,0,255}));
  connect(lat.y, and1.u[2]) annotation (Line(points={{102,40},{112,40},{112,80},
          {118,80}}, color={255,0,255}));
  connect(tim.passed, and1.u[3]) annotation (Line(points={{62,-28},{114,-28},{
          114,72},{118,72},{118,75.3333}},
                                       color={255,0,255}));
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
          textString="VHotWat_flow"),
        Text(
          extent={{-98,-72},{-30,-88}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinHotWat_setpoint"),
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
This development is based on RP-1711, March 2020 draft, sections 5.3.3.11 and
5.3.3.12, subsection 1.a.
</p>
<p>
When a stage-change command is received (<code>chaPro</code> = true) and the upstream
device has finished its adjustment process (<code>uUpsDevSta</code> = true),
check if the minimum hot water flow rate <code>VHotWat_flow</code> has achieved 
its new set point <code>VMinHotWat_setpoint</code>. 
After new setpoint is achieved, wait for 1 minute (<code>byPasSetTim</code>) to 
allow loop to stabilize. It will then set <code>yMinBypRes</code> to true.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 07, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end ResetMinBypass;
