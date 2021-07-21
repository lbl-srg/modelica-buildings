within Buildings.Fluid.CHPs.BaseClasses.Validation;
model CoolDown "Validate model CoolDown"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

  Buildings.Fluid.CHPs.BaseClasses.Types.Mode actMod=
    if norm.active then
      Buildings.Fluid.CHPs.BaseClasses.Types.Mode.Normal
    elseif cooDow.active then
      Buildings.Fluid.CHPs.BaseClasses.Types.Mode.CoolDown
    else
      Buildings.Fluid.CHPs.BaseClasses.Types.Mode.Off
  "Mode indicator";
  Modelica.Blocks.Sources.BooleanTable runSig(
    final startValue=true,
    table={300,600,660,690}) "Plant run signal"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Not notRun "Plant does not run"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Plant run and cool-down is optional"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cooDowOpt(
    final k=per.coolDownOptional)
    "Cool-down is optional"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

  Modelica.StateGraph.StepWithSignal cooDow(nIn=2, nOut=2) "Cool-down mode"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
protected
  Modelica.StateGraph.InitialStep norm(final nIn=2, final nOut=2)
    "Normal operation mode"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Modelica.StateGraph.TransitionWithSignal transition2 "Cool-down to off mode"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.StateGraph.TransitionWithSignal transition1
    "Normal to cool-down mode"
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Modelica.StateGraph.TransitionWithSignal transition4
    "Cool-down to normal mode"
    annotation (Placement(transformation(extent={{-30,-10},{-50,10}})));
  Modelica.StateGraph.Step off(final nIn=1, final nOut=1) "Off mode"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.StateGraph.TransitionWithSignal transition3 "Off to normal mode"
    annotation (Placement(transformation(extent={{70,40},{90,60}})));
  Modelica.StateGraph.Transition transition5(
    final condition=false,
    final waitTime=0)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Timer timer(
    final t=per.timeDelayCool)
    "Time of the plant in cool-down mode"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

equation
  connect(transition4.outPort, norm.inPort[1]) annotation (Line(points={{-41.5,0},
          {-90,0},{-90,50.5},{-81,50.5}}, color={0,0,0}));
  connect(transition1.inPort, norm.outPort[1]) annotation (Line(points={{-44,70},
          {-52,70},{-52,50.25},{-59.5,50.25}}, color={0,0,0}));
  connect(off.inPort[1], transition2.outPort) annotation (Line(points={{39,50},
          {21.5,50}}, color={0,0,0}));
  connect(off.outPort[1], transition3.inPort) annotation (Line(points={{60.5,50},
          {76,50}}, color={0,0,0}));
  connect(transition3.outPort, norm.inPort[2]) annotation (Line(points={{81.5,50},
          {90,50},{90,-20},{-90,-20},{-90,49.5},{-81,49.5}}, color={0,0,0}));
  connect(transition5.inPort, norm.outPort[2]) annotation (Line(points={{-44,30},
          {-52,30},{-52,49.75},{-59.5,49.75}},color={0,0,0}));
  connect(runSig.y, notRun.u) annotation (Line(points={{-59,-100},{-22,-100}},
          color={255,0,255}));
  connect(notRun.y, transition1.condition) annotation (Line(points={{2,-100},{40,
          -100},{40,-10},{-26,-10},{-26,52},{-40,52},{-40,58}}, color={255,0,255}));
  connect(cooDowOpt.y, and1.u1) annotation (Line(points={{-58,-60},{-22,-60}},
          color={255,0,255}));
  connect(runSig.y, and1.u2) annotation (Line(points={{-59,-100},{-40,-100},{-40,
          -68},{-22,-68}}, color={255,0,255}));
  connect(runSig.y, transition3.condition) annotation (Line(points={{-59,-100},{
          -40,-100},{-40,-40},{80,-40},{80,38}}, color={255,0,255}));
  connect(and1.y, transition4.condition) annotation (Line(points={{2,-60},{20,-60},
          {20,-30},{-40,-30},{-40,-12}}, color={255,0,255}));
  connect(cooDow.outPort[1], transition2.inPort) annotation (Line(points={{0.5,
          50.25},{8,50.25},{8,50},{16,50}}, color={0,0,0}));
  connect(cooDow.outPort[2], transition4.inPort) annotation (Line(points={{0.5,
          49.75},{10,49.75},{10,30},{-20,30},{-20,0},{-36,0}}, color={0,0,0}));
  connect(transition1.outPort, cooDow.inPort[1]) annotation (Line(points={{
          -38.5,70},{-32,70},{-32,50},{-22,50},{-22,50.5},{-21,50.5}}, color={0,
          0,0}));
  connect(transition5.outPort, cooDow.inPort[2]) annotation (Line(points={{
          -38.5,30},{-32,30},{-32,49.5},{-21,49.5}}, color={0,0,0}));
  connect(cooDow.active, timer.u)
    annotation (Line(points={{-10,39},{-10,10},{-2,10}}, color={255,0,255}));
  connect(timer.passed, transition2.condition) annotation (Line(points={{22,2},{
          40,2},{40,30},{20,30},{20,38}}, color={255,0,255}));
annotation (
  experiment(StopTime=900, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/CoolDown.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates the transitions to and from the cool-down operating mode.
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2019, by Jianjun Hu:<br/>
Refactored implementation.
</li>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end CoolDown;
