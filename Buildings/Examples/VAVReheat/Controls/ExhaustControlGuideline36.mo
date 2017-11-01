within Buildings.Examples.VAVReheat.Controls;
block ExhaustControlGuideline36
  "Controller for return air fan and exhaust air damper"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.PressureDifference pBuiSet = 12
    "Building static pressure difference relative to ambient (positive to pressurize the building)";
  parameter Real kP = 1
    "Proportional gain. If kP * (pMea-pBui) = 1, then damper is closed";
  parameter Real yMinFan(
    min=0.1,
    max=1,
    final unit="1") = 0.1
    "Minimum fan speed if fan is on";

  Buildings.Controls.OBC.CDL.Continuous.Limiter limExhDam(uMax=1, uMin=0)
    "Limiter for exhaust damper"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBuiPre
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yExhDam
    "Exhaust damper control signal (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{100,38},{120,58}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFan
    "Return fan control signal"
    annotation (Placement(transformation(extent={{100,-60},{120,-38}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(delta=300)
    "Average building static pressure measurement"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback feedback
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant pBui(
    final k=pBuiSet) "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=kP)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter limFan(uMax=1, uMin=yFanMin)
    "Limiter for fan control"
    annotation (Placement(transformation(extent={{28,-30},{48,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(p=1, k=0)
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Set to true to enable the fan on"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero fan control signal"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
equation
  connect(movMea.u, uBuiPre)
    annotation (Line(points={{-82,0},{-120,0}}, color={0,0,127}));
  connect(movMea.y, feedback.u1)
    annotation (Line(points={{-59,0},{-42,0}}, color={0,0,127}));
  connect(pBui.y, feedback.u2)
    annotation (Line(points={{-39,-50},{-30,-50},{-30,-12}}, color={0,0,127}));
  connect(feedback.y, gai.u)
    annotation (Line(points={{-19,0},{-10,0}}, color={0,0,127}));
  connect(gai.y, limFan.u) annotation (Line(points={{13,0},{20,0},{20,-20},{26,
          -20}},
        color={0,0,127}));
  connect(limExhDam.u, addPar.y)
    annotation (Line(points={{58,50},{51,50}}, color={0,0,127}));
  connect(addPar.u, gai.y)
    annotation (Line(points={{28,50},{20,50},{20,0},{13,0}}, color={0,0,127}));
  connect(swi.u2, uFan) annotation (Line(points={{58,-50},{16,-50},{16,60},{
          -120,60}}, color={255,0,255}));
  connect(limFan.y, swi.u1) annotation (Line(points={{49,-20},{54,-20},{54,-42},
          {58,-42}}, color={0,0,127}));
  connect(swi.u3, zer.y) annotation (Line(points={{58,-58},{40,-58},{40,-70},{
          21,-70}}, color={0,0,127}));
  connect(swi.y, yRetFan) annotation (Line(points={{81,-50},{96,-50},{96,-49},{
          110,-49}}, color={0,0,127}));
  connect(limExhDam.y, yExhDam) annotation (Line(points={{81,50},{92,50},{92,48},
          {110,48}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ExhaustControlGuideline36;
