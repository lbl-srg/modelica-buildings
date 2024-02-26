within Buildings.Templates.Plants.Controls.Utilities;
block HoldValue "Hold a value based on Boolean input signal"
  parameter Real dtHol_max(final unit="s")=0
    "Maximum hold duration";
  parameter Real y_start=0
    "Initial value of output signal";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1
    "Boolean signal that triggers fixed output value"
    annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}),   iconTransformation(
          extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Rel
    "Boolean signal that releases hold"
    annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}),  iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u "Input signal" annotation (
      Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y "Output signal" annotation (
     Placement(transformation(extent={{100,-20},{140,20}}),iconTransformation(
          extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{72,70},{92,90}})));
  Modelica.StateGraph.InitialStepWithSignal useAct(nOut=1, nIn=1)
    "Use actual value – Initial state"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.StateGraph.StepWithSignal useFix(nIn=1, nOut=1) "Use fixed value"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.StateGraph.TransitionWithSignal toFix "Transition to fixed value"
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(final t=dtHol_max) "Timer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,30})));
  Modelica.StateGraph.TransitionWithSignal toAct "Transition to actual value"
    annotation (Placement(transformation(extent={{30,60},{50,80}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Hold duration elapsed or release signal fired"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between actual and fixed value"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
equation
  connect(u, triSam.u) annotation (Line(points={{-120,-40},{-40,-40},{-40,-60},{
          -12,-60}}, color={0,0,127}));
  connect(u1, toFix.condition)
    annotation (Line(points={{-120,40},{-20,40},{-20,58}}, color={255,0,255}));
  connect(toFix.outPort, useFix.inPort[1])
    annotation (Line(points={{-18.5,70},{-1,70}}, color={0,0,0}));
  connect(useFix.active, tim.u)
    annotation (Line(points={{10,59},{10,42}}, color={255,0,255}));
  connect(useFix.outPort[1], toAct.inPort)
    annotation (Line(points={{20.5,70},{36,70}}, color={0,0,0}));
  connect(u1, triSam.trigger) annotation (Line(points={{-120,40},{-20,40},{-20,-80},
          {0,-80},{0,-72}}, color={255,0,255}));
  connect(tim.passed, or2.u1)
    annotation (Line(points={{2,18},{2,0},{8,0}}, color={255,0,255}));
  connect(u1Rel, or2.u2) annotation (Line(points={{-120,0},{-10,0},{-10,-8},{8,-8}},
        color={255,0,255}));
  connect(or2.y, toAct.condition)
    annotation (Line(points={{32,0},{40,0},{40,58}}, color={255,0,255}));
  connect(useAct.outPort[1], toFix.inPort)
    annotation (Line(points={{-39.5,70},{-24,70}}, color={0,0,0}));
  connect(toAct.outPort, useAct.inPort[1]) annotation (Line(points={{41.5,70},{52,
          70},{52,90},{-70,90},{-70,70},{-61,70}}, color={0,0,0}));
  connect(swi.y, y) annotation (Line(points={{92,0},{120,0}}, color={0,0,127}));
  connect(triSam.y, swi.u3) annotation (Line(points={{12,-60},{60,-60},{60,-8},{
          68,-8}}, color={0,0,127}));
  connect(useAct.active, swi.u2) annotation (Line(points={{-50,59},{-50,50},{60,
          50},{60,0},{68,0}}, color={255,0,255}));
  connect(u, swi.u1) annotation (Line(points={{-120,-40},{54,-40},{54,8},{68,8}},
        color={0,0,127}));
  annotation (
  DefaultComponentName="hol",
  Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HoldValue;
