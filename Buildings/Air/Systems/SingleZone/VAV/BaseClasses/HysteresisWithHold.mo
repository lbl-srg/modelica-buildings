within Buildings.Air.Systems.SingleZone.VAV.BaseClasses;
model HysteresisWithHold
  extends Modelica.Blocks.Icons.Block;

  parameter Real uLow = 0.05 "if y=true and u<=uLow, switch to y=false";
  parameter Real uHigh = 0.15 "if y=false and u>=uHigh, switch to y=true";

  parameter Modelica.SIunits.Time onHolDur=15*60
    "On hold duration time";

  parameter Modelica.SIunits.Time offHolDur=15*60
    "Off hold duration time";

  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.BooleanOutput on "On signal"
    annotation (Placement(transformation(extent={{220,-10},{240,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

protected
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.StateGraph.InitialStep initialStep(nOut=2)
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.StateGraph.TransitionWithSignal toTrue1
    annotation (Placement(transformation(extent={{10,80},{30,100}})));
  Modelica.StateGraph.TransitionWithSignal toFalse1
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=uLow, uHigh=uHigh)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.StateGraph.StepWithSignal outputTrue(nIn=2)
    "State with true output signal"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.StateGraph.StepWithSignal outputFalse(nIn=2)
    "State for which the block outputs false"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.StateGraph.TransitionWithSignal toTrue "Transition to true"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.StateGraph.TransitionWithSignal toFalse "Transition to galse"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
  Modelica.Blocks.Logical.Timer timer "Timer for false output"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(
    final threshold=offHolDur)
    "Output true when timer elapsed the required time"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Logical.Timer timer1  "Timer for true output"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold1(
    final threshold=onHolDur)
    "Output true when timer elapsed the required time"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{160,-60},{180,-40}})));

initial equation
  assert(uLow < uHigh, "Require uLow < uHigh. Check parameter values.");

equation
  connect(initialStep.outPort[1], toTrue1.inPort)
    annotation (Line(points={{-19.5,90.25},{-2,90},{16,90}},  color={0,0,0}));
  connect(initialStep.outPort[2], toFalse1.inPort) annotation (Line(points={{-19.5,
          89.75},{-12,89.75},{-12,70},{-4,70}},  color={0,0,0}));
  connect(u, hysteresis.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={0,0,127}));
  connect(hysteresis.y, not1.u) annotation (Line(points={{-59,0},{-50,0},{-50,50},
          {-42,50}}, color={255,0,255}));
  connect(not1.y, toFalse1.condition)
    annotation (Line(points={{-19,50},{0,50},{0,58}}, color={255,0,255}));
  connect(hysteresis.y, toTrue1.condition) annotation (Line(points={{-59,0},{-50,
          0},{-50,32},{20,32},{20,78}}, color={255,0,255}));
  connect(toFalse1.outPort, outputFalse.inPort[1]) annotation (Line(points={{1.5,
          70},{10,70},{10,0.5},{19,0.5}}, color={0,0,0}));
  connect(outputFalse.outPort[1], toTrue.inPort)
    annotation (Line(points={{40.5,0},{48.25,0},{56,0}}, color={0,0,0}));
  connect(toTrue.outPort, outputTrue.inPort[1]) annotation (Line(points={{61.5,0},
          {70,0},{70,0.5},{79,0.5}}, color={0,0,0}));
  connect(outputTrue.outPort[1], toFalse.inPort)
    annotation (Line(points={{100.5,0},{116,0}}, color={0,0,0}));
  connect(toTrue1.outPort, outputTrue.inPort[2]) annotation (Line(points={{21.5,
          90},{46,90},{70,90},{70,-0.5},{79,-0.5}}, color={0,0,0}));
  connect(toFalse.outPort, outputFalse.inPort[2]) annotation (Line(points={{121.5,
          0},{140,0},{140,20},{12,20},{12,-0.5},{19,-0.5}}, color={0,0,0}));
  connect(timer.y, greaterEqualThreshold.u)
    annotation (Line(points={{-39,-50},{-22,-50}}, color={0,0,127}));
  connect(greaterEqualThreshold.y, and1.u1)
    annotation (Line(points={{1,-50},{18,-50}}, color={255,0,255}));
  connect(hysteresis.y, and1.u2) annotation (Line(points={{-59,0},{-50,0},{-50,-16},
          {-80,-16},{-80,-80},{10,-80},{10,-58},{18,-58}}, color={255,0,255}));
  connect(outputFalse.active, timer.u) annotation (Line(points={{30,-11},{30,-20},
          {-76,-20},{-76,-50},{-62,-50}}, color={255,0,255}));
  connect(and1.y, toTrue.condition) annotation (Line(points={{41,-50},{50,-50},{
          60,-50},{60,-12}}, color={255,0,255}));
  connect(outputTrue.active, timer1.u) annotation (Line(points={{90,-11},{90,-11},
          {90,-20},{64,-20},{64,-50},{78,-50}}, color={255,0,255}));
  connect(timer1.y, greaterEqualThreshold1.u)
    annotation (Line(points={{101,-50},{118,-50}}, color={0,0,127}));
  connect(greaterEqualThreshold1.y, and2.u1)
    annotation (Line(points={{141,-50},{158,-50}}, color={255,0,255}));
  connect(not1.y, and2.u2) annotation (Line(points={{-19,50},{-19,50},{200,50},{
          200,-80},{150,-80},{150,-58},{158,-58}}, color={255,0,255}));
  connect(and2.y, toFalse.condition) annotation (Line(points={{181,-50},{190,-50},
          {190,-24},{120,-24},{120,-12}}, color={255,0,255}));
  connect(outputTrue.active, on) annotation (Line(points={{90,-11},{90,-11},{90,
          -20},{180,-20},{180,0},{230,0}}, color={255,0,255}));
  annotation (defaultComponentName="hysWitHol",
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{220,120}})),
Icon(   graphics={
        Text(
          extent={{-66,-40},{62,-82}},
          lineColor={0,0,0},
          textString="%uLow     %uHigh"),
          Polygon(
            points={{-12,8},{0,2},{-12,-4},{-12,8}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Line(points={{-44,2},{-12,2}}),
          Line(points={{0,34},{0,-36}}),
          Line(points={{0,2},{36,2}}),
          Polygon(
            points={{36,8},{48,2},{36,-4},{36,8}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(extent={{48,18},{86,-16}}, lineColor={0,0,0}),
          Rectangle(extent={{-82,18},{-44,-16}}, lineColor={0,0,0})}),
Documentation(info="<html>
<p>
Model for a hysteresis block that optionally allows to specify a hold time. 
During the hold time, the new state is hold.
</p>
</html>", revisions="<html>
<ul>
<li>
June 26, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end HysteresisWithHold;
