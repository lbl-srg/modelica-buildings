within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences;
block DXCoilEnable
  "Sequence for enabling and disabling DX coils"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nCoi=2
    "Number of DX coils";

  parameter Real uThrCooCoi2(
    final min=0,
    final max=1)=0.8
    "Threshold of cooling coil valve position signal above which DX coil is enabled";

  parameter Real uThrCooCoi3(
    final min=0,
    final max=1)=0.1
    "Threshold of cooling coil valve position signal below which DX coil is disabled";

  parameter Real dUHys=0.01
    "Small temperature difference used in comparison blocks"
    annotation(Dialog(tab="Advanced"));

  parameter Real timPer2(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for enabling DX coil";

  parameter Real timPer3(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for disabling DX coil";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoi[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling coil valve position"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDXCoi
    "DX coil signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThrCooCoi(
    final t=uThrCooCoi2,
    final h=dUHys)
    "Check if cooling coil signal is equal to or greater than threshold"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(t=timPer2)
    "Count time"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha[nCoi]
    "Detect changes in DX coil status"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nCoi)
    "Multi Or"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical And"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=uThrCooCoi3,
    final h=dUHys)
    "Check if cooling coil signal is less than threshold"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical And"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1(t=timPer3)
    "Count time"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Maintain DX coil status till the conditions to change it are met"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

equation
  connect(uCooCoi, greThrCooCoi.u)
    annotation (Line(points={{-120,-60},{-80,-60},{-80,0},{-72,0}},
                                                    color={0,0,127}));
  connect(mulOr.y, not1.u)
    annotation (Line(points={{2,60},{28,60}},      color={255,0,255}));
  connect(uDXCoi, cha.u)
    annotation (Line(points={{-120,60},{-72,60}}, color={255,0,255}));
  connect(greThrCooCoi.y, and1.u1)
    annotation (Line(points={{-48,0},{-22,0}},  color={255,0,255}));
  connect(not1.y, and1.u2) annotation (Line(points={{52,60},{66,60},{66,30},{-30,
          30},{-30,-8},{-22,-8}},
                    color={255,0,255}));
  connect(and1.y, tim.u)
    annotation (Line(points={{2,0},{28,0}},    color={255,0,255}));
  connect(uCooCoi, lesThr.u)
    annotation (Line(points={{-120,-60},{-72,-60}}, color={0,0,127}));
  connect(lesThr.y, and2.u1)
    annotation (Line(points={{-48,-60},{-22,-60}}, color={255,0,255}));
  connect(and2.y,tim1. u)
    annotation (Line(points={{2,-60},{28,-60}},  color={255,0,255}));
  connect(not1.y, and2.u2) annotation (Line(points={{52,60},{66,60},{66,30},{-30,
          30},{-30,-68},{-22,-68}}, color={255,0,255}));
  connect(cha.y, mulOr.u)
    annotation (Line(points={{-48,60},{-22,60}}, color={255,0,255}));
  connect(tim.passed, lat.u) annotation (Line(points={{52,-8},{60,-8},{60,0},{68,
          0}}, color={255,0,255}));
  connect(tim1.passed, lat.clr) annotation (Line(points={{52,-68},{64,-68},{64,-6},
          {68,-6}}, color={255,0,255}));
  connect(lat.y, yDXCoi)
    annotation (Line(points={{92,0},{120,0}}, color={255,0,255}));

  annotation (
    defaultComponentName="DXCoiEna",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
        graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,100},{100,100}},
            textColor={0,0,255}),
       Text(extent={{-96,68},{-50,54}},
          textColor={255,0,255},
          textString="uDXCoi"),
          Text(
            extent={{-94,-52},{-50,-68}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uCooCoi"),
       Text(extent={{52,8},{94,-6}},
          textColor={255,0,255},
          textString="yDXCoi")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
  <p>
  This is a control module for enabling DX coil operation signal. 
  The control module is operated as follows: 
  </p>
  <ul>
  <li>
  Enable DX coil <code>yDXCoi = true</code> when cooling coil valve position <code>uCooCoi</code> 
  exceeds its threshold <code>uThrCooCoi2</code> for the duration of <code>timPer2</code>, 
  and no changes in DX coil status <code>uDXCoi</code> are detected.
  </li>
  <li>
  Disable DX coil <code>yDXCoi = false</code> when <code>uCooCoi</code> falls below <code>uThrCooCoi3</code>
  for <code>timPer3</code>, and no changes in <code>uDXCoi</code> are detected. 
  </li>
  </ul>
  </html>", revisions="<html>
  <ul>
  <li>
  August 4, 2023, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end DXCoilEnable;
