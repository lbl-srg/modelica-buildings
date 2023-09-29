within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences;
block DXCoilEnable
  "Sequence for enabling and disabling DX coils"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nCoi(min=1)=2
    "Number of DX coils";

  parameter Real uThrCoiEna(
    final min=0,
    final max=1)=0.8
    "Threshold of coil valve position signal above which DX coil is enabled";

  parameter Real uThrCoiDis(
    final min=0,
    final max=1)=0.1
    "Threshold of coil valve position signal below which DX coil is disabled";

  parameter Real dUHys=0.01
    "Coil valve position comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  parameter Real timPerEna(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for enabling DX coil";

  parameter Real timPerDis(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for disabling DX coil";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoi[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Coil valve position"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDXCoi
    "DX coil signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThrCoi(
    final t=uThrCoiEna,
    final h=dUHys)
    "Check if coil valve position signal is equal to or greater than threshold"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timEna(
    final t=timPerEna)
    "Check time for which enable conditions are met"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Logical.Change chaDXCoi[nCoi]
    "Detect changes in DX coil status"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOrDXCoi(
    final nin=nCoi)
    "Check for changes in DX coil status"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Controls.OBC.CDL.Logical.Not notDXCoiCha
    "Generate Boolean False signal if change in status is detected"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));

  Buildings.Controls.OBC.CDL.Logical.And andEna
    "Reset timer if coil status change is detected"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThrCoi(
    final t=uThrCoiDis,
    final h=dUHys)
    "Check if coil valve position signal is less than threshold"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));

  Buildings.Controls.OBC.CDL.Logical.And andDis
    "Reset timer if coil status change is detected"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timDis(
    final t=timPerDis)
    "Check time for which disable conditions are met"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Latch latEnaDis
    "Maintain DX coil status till the conditions to change it are met"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

equation
  connect(uCoi, greThrCoi.u)
    annotation (Line(points={{-120,-60},{-80,-60},{-80,0},{-72,0}}, color={0,0,127}));
  connect(mulOrDXCoi.y, notDXCoiCha.u)
    annotation (Line(points={{2,60},{28,60}}, color={255,0,255}));
  connect(uDXCoi, chaDXCoi.u)
    annotation (Line(points={{-120,60},{-72,60}}, color={255,0,255}));
  connect(greThrCoi.y, andEna.u1)
    annotation (Line(points={{-48,0},{-22,0}}, color={255,0,255}));
  connect(notDXCoiCha.y, andEna.u2) annotation (Line(points={{52,60},{66,60},{66,30},
          {-30,30},{-30,-8},{-22,-8}}, color={255,0,255}));
  connect(andEna.y, timEna.u)
    annotation (Line(points={{2,0},{28,0}}, color={255,0,255}));
  connect(uCoi, lesThrCoi.u)
    annotation (Line(points={{-120,-60},{-72,-60}}, color={0,0,127}));
  connect(lesThrCoi.y, andDis.u1)
    annotation (Line(points={{-48,-60},{-22,-60}}, color={255,0,255}));
  connect(andDis.y, timDis.u)
    annotation (Line(points={{2,-60},{28,-60}}, color={255,0,255}));
  connect(notDXCoiCha.y, andDis.u2) annotation (Line(points={{52,60},{66,60},{66,30},
          {-30,30},{-30,-68},{-22,-68}}, color={255,0,255}));
  connect(chaDXCoi.y, mulOrDXCoi.u)
    annotation (Line(points={{-48,60},{-22,60}}, color={255,0,255}));
  connect(timEna.passed, latEnaDis.u) annotation (Line(points={{52,-8},{60,-8},
          {60,0},{68,0}}, color={255,0,255}));
  connect(timDis.passed, latEnaDis.clr) annotation (Line(points={{52,-68},{64,-68},
          {64,-6},{68,-6}}, color={255,0,255}));
  connect(latEnaDis.y, yDXCoi)
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
          Text(
            extent={{-96,68},{-50,54}},
            textColor={255,0,255},
            textString="uDXCoi"),
          Text(
            extent={{-100,-54},{-64,-68}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uCoi"),
          Text(
            extent={{52,8},{94,-6}},
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
  Enable DX coil <code>yDXCoi = true</code> when coil valve position <code>uCoi</code> 
  exceeds its threshold <code>uThrCoiEna</code> for the duration of <code>timPerEna</code>, 
  and no changes in DX coil status <code>uDXCoi</code> are detected.
  </li>
  <li>
  Disable DX coil <code>yDXCoi = false</code> when <code>uCoi</code> falls below <code>uThrCoiDis</code>
  for <code>timPerDis</code>, and no changes in <code>uDXCoi</code> are detected. 
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
