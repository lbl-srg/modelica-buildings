within Buildings.Air.Systems.SingleZone.VAV.BaseClasses;
model HysteresisWithDelay_

protected
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{70,72},{90,92}})));
public
  Modelica.StateGraph.TransitionWithSignal toOutputTrue
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
  Modelica.StateGraph.StepWithSignal outputTrue
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Modelica.StateGraph.InitialStep initialStep
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.StateGraph.TransitionWithSignal toInitial
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=0.05, uHigh=0.15)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Logical.Timer timer
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold
      =duration)
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Modelica.Blocks.Interfaces.RealInput u "Control input" annotation (
      Placement(transformation(rotation=0, extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput on "On signal" annotation (Placement(
      transformation(rotation=0, extent={{100,-10},{120,10}})));
equation
  connect(initialStep.outPort[1], toOutputTrue.inPort)
    annotation (Line(points={{-39.5,60},{-24,60}}, color={0,0,0}));
  connect(toOutputTrue.outPort, outputTrue.inPort[1])
    annotation (Line(points={{-18.5,60},{-1,60}}, color={0,0,0}));



  connect(outputTrue.outPort[1], toInitial.inPort)
    annotation (Line(points={{20.5,60},{28.25,60},{36,60}}, color={0,0,0}));
  connect(toInitial.outPort, initialStep.inPort[1]) annotation (Line(points={{
          41.5,60},{42,60},{60,60},{60,80},{-80,80},{-80,60},{-61,60}}, color={
          0,0,0}));
  connect(hysteresis.y, toOutputTrue.condition)
    annotation (Line(points={{-39,20},{-20,20},{-20,48}}, color={255,0,255}));
  connect(outputTrue.active, timer.u) annotation (Line(points={{10,49},{10,49},
          {10,20},{18,20}}, color={255,0,255}));
  connect(timer.y, greaterEqualThreshold.u)
    annotation (Line(points={{41,20},{50,20},{58,20}}, color={0,0,127}));
  connect(greaterEqualThreshold.y, toInitial.condition) annotation (Line(points
        ={{81,20},{90,20},{90,40},{40,40},{40,48}}, color={255,0,255}));
  connect(u, hysteresis.u) annotation (Line(points={{-110,0},{-80,0},{-80,20},{
          -62,20}}, color={0,0,127}));
  connect(outputTrue.active, on) annotation (Line(points={{10,49},{10,49},{10,0},
          {110,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HysteresisWithDelay_;
