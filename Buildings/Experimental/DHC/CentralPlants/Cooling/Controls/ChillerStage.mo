within Buildings.Experimental.DHC.CentralPlants.Cooling.Controls;
model ChillerStage
  "Chiller staging controller for plants with two same size chillers"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Time tWai
    "Waiting time";
  parameter Modelica.SIunits.Power QEva_nominal(
    final max=0)
    "Nominal cooling capaciaty (negative)";
  parameter Modelica.SIunits.Power criPoiLoa=0.55*QEva_nominal
    "Critical point of cooling load for switching one chiller on or off";
  parameter Modelica.SIunits.Power dQ=0.25*QEva_nominal
    "Deadband for critical point of cooling load";
  Modelica.Blocks.Interfaces.BooleanInput on
    "Enabling signal of the plant. True: chiller should be enabled"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput QLoa(
    final unit="W",
    final quantity="Power",
    final max=0)
    "Total cooling load, negative"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.BooleanOutput y[2]
    "On/off signal for the chillers - 0: off; 1: on"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.StateGraph.InitialStep off(
    nIn=1)
    "No cooling is demanded"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=-90,origin={-50,70})));
  Modelica.StateGraph.StepWithSignal oneOn(
    nOut=2,
    nIn=2)
    "Status of one chiller on"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,origin={-50,0})));
  Modelica.StateGraph.StepWithSignal twoOn
    "Status of two chillers on"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,origin={-50,-70})));
  Modelica.StateGraph.TransitionWithSignal offToOne(
    enableTimer=true,
    waitTime=tWai)
    "Condition of transition from off to one chiller on"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=90,origin={-50,40})));
  Modelica.StateGraph.TransitionWithSignal oneToTwo(
    enableTimer=true,
    waitTime=tWai)
    "Condition of transition from one chiller to two chillers"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=90,origin={-50,-40})));
  Modelica.StateGraph.TransitionWithSignal twoToOne(
    enableTimer=true,
    waitTime=tWai)
    "Condition of transion from two chillers to one chiller"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=90,origin={0,-40})));
  Modelica.StateGraph.TransitionWithSignal oneToOff(
    enableTimer=true,
    waitTime=tWai)
    "Condition of transition from one chiller to off"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=90,origin={-20,40})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "State graph root"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=1,
    final integerFalse=0)
    "Boolean to real"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1(
    final integerTrue=2,
    final integerFalse=0)
    "Boolean to real"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt
    "Calculator of chiller stage index. 0: off; 1: one chiller enabled; 2: two chillers enabled"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold chiOne
    "On signal of chiller one"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold chiTwo(
    final t=1)
    "On signal of chiller two"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold thrOneToTwo(
    final t=criPoiLoa+dQ)
    "Threshold of turning two chillers on"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold thrTwoToOne(
    final t=criPoiLoa-dQ)
    "Threshold of turning off the second chiller"
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not notOn
    "Not on"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
initial equation
  Modelica.Utilities.Streams.print(
    "Warning:\n  In "+getInstanceName()+": This model is a beta version and is not fully validated yet.");
equation
  connect(off.outPort[1],offToOne.inPort)
    annotation (Line(points={{-50,59.5},{-50,44}},color={0,0,0}));
  connect(oneToOff.outPort,off.inPort[1])
    annotation (Line(points={{-20,41.5},{-20,88},{-50,88},{-50,81}},color={0,0,0}));
  connect(oneToTwo.outPort,twoOn.inPort[1])
    annotation (Line(points={{-50,-41.5},{-50,-59}},color={0,0,0}));
  connect(twoOn.outPort[1],twoToOne.inPort)
    annotation (Line(points={{-50,-80.5},{-50,-88},{-2.22045e-16,-88},{-2.22045e-16,-44}},color={0,0,0}));
  connect(twoToOne.outPort,oneOn.inPort[2])
    annotation (Line(points={{0,-38.5},{0,16},{-49.5,16},{-49.5,11}},color={0,0,0}));
  connect(offToOne.outPort,oneOn.inPort[1])
    annotation (Line(points={{-50,38.5},{-50,24},{-50,11},{-50.5,11}},color={0,0,0}));
  connect(oneOn.outPort[2],oneToOff.inPort)
    annotation (Line(points={{-49.75,-10.5},{-49.75,-18},{-20,-18},{-20,36}},color={0,0,0}));
  connect(oneOn.outPort[1],oneToTwo.inPort)
    annotation (Line(points={{-50.25,-10.5},{-50.25,-18},{-50,-18},{-50,-36}},color={0,0,0}));
  connect(addInt.u2,booToInt1.y)
    annotation (Line(points={{58,-56},{50,-56},{50,-70},{42,-70}},color={255,127,0}));
  connect(oneOn.active,booToInt.u)
    annotation (Line(points={{-39,0},{10,0},{10,-30},{18,-30}},color={255,0,255}));
  connect(twoOn.active,booToInt1.u)
    annotation (Line(points={{-39,-70},{18,-70}},color={255,0,255}));
  connect(booToInt.y,addInt.u1)
    annotation (Line(points={{42,-30},{50,-30},{50,-44},{58,-44}},color={255,127,0}));
  connect(addInt.y,chiTwo.u)
    annotation (Line(points={{82,-50},{90,-50},{90,-30},{54,-30},{54,-10},{58,-10}},color={255,127,0}));
  connect(addInt.y,chiOne.u)
    annotation (Line(points={{82,-50},{90,-50},{90,-30},{54,-30},{54,30},{58,30}},color={255,127,0}));
  connect(chiOne.y,y[1])
    annotation (Line(points={{82,30},{90,30},{90,-5},{110,-5}},color={255,0,255}));
  connect(chiTwo.y,y[2])
    annotation (Line(points={{82,-10},{90,-10},{90,5},{110,5}},color={255,0,255}));
  connect(on,offToOne.condition)
    annotation (Line(points={{-120,40},{-62,40}},color={255,0,255}));
  connect(oneToTwo.condition,thrOneToTwo.y)
    annotation (Line(points={{-62,-40},{-68,-40}},color={255,0,255}));
  connect(QLoa,thrOneToTwo.u)
    annotation (Line(points={{-120,-40},{-92,-40}},color={0,0,127}));
  connect(QLoa,thrTwoToOne.u)
    annotation (Line(points={{-120,-40},{-96,-40},{-96,-70},{-92,-70}},color={0,0,127}));
  connect(thrTwoToOne.y,twoToOne.condition)
    annotation (Line(points={{-68,-70},{-66,-70},{-66,-56},{-20,-56},{-20,-40},{-12,-40}},color={255,0,255}));
  connect(on,notOn.u)
    annotation (Line(points={{-120,40},{-106,40},{-106,20},{-92,20}},color={255,0,255}));
  connect(notOn.y,oneToOff.condition)
    annotation (Line(points={{-68,20},{-32,20},{-32,40}},color={255,0,255}));
  annotation (
    defaultComponentName="chiStaCon",
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}),
    Documentation(
      revisions="<html>
<ul>
<li>
August 6, 2020 by Jing Wang:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>This model implements staging control logic of two chillers according to the measured total cooling load. The control logic is as follows:</p>
<ul>
<li>When the plant enabling signal <code>on</code> changes from <code>false</code> to <code>true</code>, one chiller is enabled.</li>
<li>When the total cooling load <code>QLoa</code> exceeds 80 percent (adjustable) of one chiller&apos;s nominal capacity <code>QEva_nominal</code>, a second chiller is enabled.</li>
<li>When the total cooling load <code>QLoa</code> drops below 60 percent (adjustable) of one chiller&apos;s nominal capacity <code>QEva_nominal </code>(i.e., 30 percent each chiller), the second chiller is disabled. </li>
<li>When the plant enabling signal <code>on</code> changes from <code>true</code> to <code>false</code>, the operating chiller is disabled.</li>
<li>Parameter <code>tWai</code> assures a transitional time is kept between each operation.</li>
</ul>
<p><br>It is assumed that both chillers have the same capacity of <code>QEva_nominal</code>.</p>
<p>Note: This model can be used for plants with two chillers with or without waterside econimizer (WSE). For plants with WSE, extra control logic on top of this model needs to be added.</p>
</html>"));
end ChillerStage;
