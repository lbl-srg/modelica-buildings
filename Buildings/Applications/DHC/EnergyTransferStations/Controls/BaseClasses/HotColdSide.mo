within Buildings.Applications.DHC.EnergyTransferStations.Controls.BaseClasses;
partial block HotColdSide "State machine"
  extends Modelica.Blocks.Icons.Block;
  replaceable model Inequality =
    Buildings.Controls.OBC.CDL.Continuous.GreaterEqual;
  parameter Modelica.SIunits.TemperatureDifference THys(min=0.1)
    "Temperature hysteresis";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Set point temperature-subscript SetCoo: cooling setpoint, SetHea: heating setpoint."
    annotation (Placement(transformation(extent={{-180,
            100},{-140,140}}), iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTop(
    final unit="K",
    displayUnit="degC")
    "Temperature at top of tank"
    annotation (Placement(transformation(extent={{
            -180,40},{-140,80}}), iconTransformation(extent={{-140,-60},{-100,
            -20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBot(
     final unit="K",
     displayUnit="degC")
    "Temperature at bottom of tank"
    annotation (Placement(transformation(extent= {{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(unit="1")
    "Control signal for directional valve"
    annotation (Placement(transformation(extent={{140,-40},{180,0}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput rejFulLoa
    "Boolean signal to switch to full load rejection mode"
    annotation (Placement(
        transformation(extent={{140,0},{180,40}}),    iconTransformation(extent={{100,20},
            {140,60}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-110,132},{-90,152}})));
  Modelica.StateGraph.InitialStep noDemand(nIn=2)
    "State if no heat or heat rejection is required"
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  Modelica.StateGraph.TransitionWithSignal t1(enableTimer=true, waitTime=60)
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Modelica.StateGraph.StepWithSignal runHP
    "State if heat pump/EIR chiller operation is required"
    annotation (Placement(transformation(extent={{10,110},{30,130}})));
  Modelica.StateGraph.TransitionWithSignal t2
    annotation (Placement(transformation(extent={{50,110},{70,130}})));
  Modelica.StateGraph.TransitionWithSignal t3(enableTimer=false)
    annotation (Placement(transformation(extent={{-14,70},{6,90}})));
  Modelica.StateGraph.StepWithSignal rejParLoaSta(nOut=2, nIn=2)
    "Reject part load status, true: open valves and reject heat to either borefield
      or district heat exchanger."
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Modelica.StateGraph.TransitionWithSignal t4
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
  Modelica.StateGraph.Alternative alternative
    annotation (Placement(transformation(extent={{-40,40},{140,160}})));
  Modelica.StateGraph.TransitionWithSignal t5(enableTimer=false)
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Modelica.StateGraph.StepWithSignal rejFulLoaSta
    "Reject full load status: true: reject heat to both the borefield and district heat exchanger."
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Modelica.StateGraph.TransitionWithSignal t6
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(k=1, p=2*THys)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(k=1, p=THys)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar3(k=1, p=0.5*THys)
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(k=1, p=THys)
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to real conversion"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Inequality greEqu
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Inequality greEqu1
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Inequality greEqu2
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Inequality greEqu3
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Inequality greEqu4
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Inequality greEqu5
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
equation
  connect(t1.outPort, runHP.inPort[1]) annotation (Line(points={{1.5,120},{9,
          120}},                                                                        color={0,0,0}));
  connect(runHP.outPort[1], t2.inPort) annotation (Line(points={{30.5,120},{56,
          120}},                                 color={0,0,0}));
  connect(t3.outPort, rejParLoaSta.inPort[1]) annotation (Line(points={{-2.5,80},
          {2,80},{2,80.5},{9,80.5}},           color={0,0,0}));
  connect(alternative.inPort, noDemand.outPort[1]) annotation (Line(points={{-42.7,
          100},{-49.5,100}},                                                                         color={0,0,0}));
  connect(t3.inPort, alternative.split[1]) annotation (Line(points={{-8,80},{
          -14,80},{-14,100},{-21.1,100}},
                                    color={0,0,0}));
  connect(t1.inPort, alternative.split[2]) annotation (Line(points={{-4,120},{
          -14,120},{-14,100},{-21.1,100}},
                                     color={0,0,0}));
  connect(alternative.outPort, noDemand.inPort[1]) annotation (Line(points={{141.8,
          100},{140,100},{140,146},{-80,146},{-80,100.5},{-71,100.5}},
                                                               color={0,0,0}));
  connect(t5.outPort, rejFulLoaSta.inPort[1]) annotation (Line(points={{61.5,60},
          {40,60},{40,72},{42,72},{42,60},{69,60}},                                        color={0,0,0}));
  connect(rejFulLoaSta.outPort[1], t6.inPort) annotation (Line(points={{90.5,60},
          {96,60}},                                                                        color={0,0,0}));
  connect(t2.outPort, alternative.join[1]) annotation (Line(points={{61.5,120},
          {116,120},{116,100},{121.1,100}},
                                       color={0,0,0}));
  connect(t4.inPort, rejParLoaSta.outPort[1]) annotation (Line(points={{76,100},
          {34,100},{34,80.25},{30.5,80.25}},
                                           color={0,0,0}));
  connect(t5.inPort, rejParLoaSta.outPort[2]) annotation (Line(points={{56,60},
          {34,60},{34,79.75},{30.5,79.75}},color={0,0,0}));
  connect(rejParLoaSta.inPort[2], t6.outPort) annotation (Line(points={{9,79.5},
          {0,79.5},{0,44},{106,44},{106,60},{101.5,60}},        color={0,0,0}));
  connect(t4.outPort, alternative.join[2]) annotation (Line(points={{81.5,100},
          {121.1,100}},            color={0,0,0}));
  connect(greEqu.y, t1.condition) annotation (Line(points={{-78,40},{-30,40},{
          -30,102},{0,102},{0,108}}, color={255,0,255}));
  connect(booToRea.u, or2.y) annotation (Line(points={{98,-20},{82,-20}},
                          color={255,0,255}));
  connect(booToRea.u,or2. y) annotation (Line(points={{98,-20},{82,-20}},
                          color={255,0,255}));
  connect(yVal, booToRea.y) annotation (Line(points={{160,-20},{122,-20}},
                     color={0,0,127}));
  connect(TSet, greEqu4.u2) annotation (Line(points={{-160,120},{-128,120},{-128,
          -108},{-62,-108}}, color={0,0,127}));
  connect(TSet, greEqu.u1) annotation (Line(points={{-160,120},{-128,120},{-128,
          40},{-102,40}}, color={0,0,127}));
  connect(addPar.u, TSet) annotation (Line(points={{-102,0},{-128,0},{-128,120},
          {-160,120}}, color={0,0,127}));
  connect(addPar1.u, TSet) annotation (Line(points={{-102,-140},{-128,-140},{-128,
          120},{-160,120}}, color={0,0,127}));
  connect(addPar.y, greEqu1.u2) annotation (Line(points={{-78,0},{-70,0},{-70,12},
          {-62,12}},                                                       color={0,0,127}));
  connect(addPar3.u, addPar.y) annotation (Line(points={{-102,-60},{-120,-60},{-120,
          -14},{-72,-14},{-72,0},{-78,0}}, color={0,0,127}));
  connect(addPar2.u, addPar.y) annotation (Line(points={{-102,-30},{-110,-30},{-110,
          -14},{-72,-14},{-72,0},{-78,0}}, color={0,0,127}));
  connect(addPar2.y, greEqu2.u2) annotation (Line(points={{-78,-30},{-70,-30},{-70,
          -28},{-62,-28}},                         color={0,0,127}));
  connect(addPar3.y, greEqu3.u1)   annotation (Line(points={{-78,-60},{-62,-60}},
                                                   color={0,0,127}));
  connect(addPar1.y, greEqu5.u1) annotation (Line(points={{-78,-140},{-62,-140}}, color={0,0,127}));
  connect(or2.u2, rejParLoaSta.active) annotation (Line(points={{58,-28},{20,
          -28},{20,69}},                                                                    color={255,0,255}));
  connect(greEqu1.y, t3.condition) annotation (Line(points={{-38,20},{-4,20},{
          -4,68}},                color={255,0,255}));
  connect(greEqu2.y, t5.condition) annotation (Line(points={{-38,-20},{-28,-20},
          {-28,0},{60,0},{60,48}},   color={255,0,255}));
  connect(greEqu3.y, t6.condition) annotation (Line(points={{-38,-60},{-20,-60},
          {-20,30},{100,30},{100,48}},
                                     color={255,0,255}));
  connect(greEqu4.y, t2.condition) annotation (Line(points={{-38,-100},{32,-100},
          {32,102},{60,102},{60,108}},                color={255,0,255}));
  connect(greEqu5.y, t4.condition) annotation (Line(points={{-38,-140},{40,-140},
          {40,80},{80,80},{80,88}}, color={255,0,255}));

   annotation (
  defaultComponentName="conHotSid",
 Documentation(info="<html>
<p>
This is a base class of the state finite state machine implemeneted in
 <a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController</a> or
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
November 25, 2019, by Hagar Elarga:<br/>
Added the info section.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-180},{140,180}})));
end HotColdSide;
