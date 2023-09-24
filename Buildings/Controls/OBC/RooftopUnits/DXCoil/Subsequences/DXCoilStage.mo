within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences;
block DXCoilStage
  "Sequence for staging up and down DX coils"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nCoi(min=1)=2
  "Number of DX coils";

  parameter Real uThrCoiUp(
    final min=0,
    final max=1)=0.8
    "Threshold of coil valve position signal above which DX coil is staged up";

  parameter Real uThrCoiDow(
    final min=0,
    final max=1)=0.2
    "Threshold of coil valve position signal below which DX coil staged down";

  parameter Real dUHys=0.01
    "Coil valve position comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  parameter Real dTHys(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=0.05
    "Temperature comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  parameter Real timPerUp(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 480
    "Delay time period for staging up DX coil";

  parameter Real timPerDow(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 180
    "Delay time period for staging down DX coil";

  parameter Real timPerSetExc(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 480
    "Delay time period for staging down DX coil when minimum/maximum setpoint is exceeded";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoi[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Coil valve position"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yUp
    "Next DX coil status"
    annotation (Placement(transformation(extent={{100,-28},{140,12}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDow
    "Last DX coil status"
    annotation (Placement(transformation(extent={{100,-78},{140,-38}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uComSpe[nCoi](
    displayUnit="1")
    "Compressor speed"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nCoi)
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThrCoiUp(
    final t=uThrCoiUp,
    final h=dUHys)
    "Check if coil valve position signal is equal to or greater than threshold"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timUp(
    final t=timPerUp)
    "Check time for which stage-up conditions have been satisfied"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.And andUp
    "Reset timer when coil status changes"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha[nCoi]
    "Detect changes in DX coil status"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nCoi)
    "Check if any coil status changed"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.CDL.Logical.Not notCoiSta
    "Generate Boolean False signal when any coil status changes"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timDow(
    final t=timPerDow)
    "Check time for which stage-down conditions have been satisfied"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.CDL.Logical.And andDow
    "Reset timer when coil status changes"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThrCoiDow1[nCoi](
    final t=fill(uThrCoiDow,nCoi),
    final h=fill(dUHys, nCoi))
    "Check if coil valve position signal is less than threshold"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

equation
  connect(uCoi, greThrCoiUp.u) annotation (Line(points={{-120,0},{-52,0}},
                       color={0,0,127}));
  connect(mulOr.y, notCoiSta.u)
    annotation (Line(points={{22,50},{38,50}}, color={255,0,255}));
  connect(uDXCoi, cha.u)
    annotation (Line(points={{-120,50},{-52,50}}, color={255,0,255}));
  connect(andUp.y, timUp.u)
    annotation (Line(points={{22,0},{38,0}}, color={255,0,255}));
  connect(andDow.y, timDow.u)
    annotation (Line(points={{22,-50},{38,-50}}, color={255,0,255}));
  connect(greThrCoiUp.y, andUp.u2) annotation (Line(points={{-28,0},{-20,0},{-20,
          -8},{-2,-8}},  color={255,0,255}));
  connect(notCoiSta.y, andUp.u1) annotation (Line(points={{62,50},{70,50},{70,28},
          {-10,28},{-10,0},{-2,0}},  color={255,0,255}));
  connect(notCoiSta.y, andDow.u1) annotation (Line(points={{62,50},{70,50},{70,28},
          {-10,28},{-10,-50},{-2,-50}},  color={255,0,255}));
  connect(cha.y, mulOr.u)
    annotation (Line(points={{-28,50},{-2,50}},  color={255,0,255}));
  connect(timUp.passed, yUp) annotation (Line(points={{62,-8},{120,-8}},
                color={255,0,255}));
  connect(uComSpe, lesThrCoiDow1.u)
    annotation (Line(points={{-120,-60},{-82,-60}}, color={0,0,127}));
  connect(lesThrCoiDow1.y, mulOr1.u[1:nCoi]) annotation (Line(points={{-58,-60},
          {-42,-60}},                    color={255,0,255}));
  connect(mulOr1.y, andDow.u2) annotation (Line(points={{-18,-60},{-10,-60},{-10,
          -58},{-2,-58}},  color={255,0,255}));
  connect(timDow.passed, yDow) annotation (Line(points={{62,-58},{120,-58}},
                      color={255,0,255}));
  annotation (
    defaultComponentName="DXCoiSta",
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
            extent={{-100,6},{-64,-8}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uCoi"),
          Text(
            extent={{62,66},{104,52}},
            textColor={255,0,255},
          textString="yUp"),
          Text(
            extent={{58,-54},{100,-68}},
            textColor={255,0,255},
            textString="yDow"),
          Text(
            extent={{-92,-50},{-44,-70}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
          textString="uComSpe")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
  Documentation(info="<html>
  <p>
  This is a control module for staging DX coil operation signal. 
  The control module is operated as follows: 
  </p>
  <ul>
  <li>
  Stage up <code>yUp = true</code> when coil valve position <code>uCoi</code> exceeds 
  its threshold <code>uThrCoiUp</code> for the duration of <code>timPerUp</code>, and no changes 
  in DX coil status <code>uDXCoi</code> are detected. 
  </li>
  <li>
  Stage down <code>yDow = false</code> when <code>uCoi</code> falls below <code>uThrCoiDow</code>
  for <code>timPerDow</code>, and no changes in <code>uDXCoi</code> are detected. 
  </li>
  <li>
  Stage down <code>yDow = false</code> when temperature deviation from minimum/maximum setpoint 
  <code>TSupCoiDif</code> exceeds <code>dTHys</code> for <code>timPerSetExc</code>, 
  and no changes in <code>uDXCoi</code> are detected.
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
end DXCoilStage;
