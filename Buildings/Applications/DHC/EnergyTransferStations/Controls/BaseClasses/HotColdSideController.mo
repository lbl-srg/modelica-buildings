within Buildings.Applications.DHC.EnergyTransferStations.Controls.BaseClasses;
partial block HotColdSideController "State machine"
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
            100},{-140,140}}), iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTop(
    final unit="K",
    displayUnit="degC")
    "Temperature at top of tank"
    annotation (Placement(transformation(extent={{
            -180,40},{-140,80}}), iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBot(
     final unit="K",
     displayUnit="degC")
    "Temperature at bottom of tank"
    annotation (Placement(transformation(extent= {{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-120,-60},{-100, -40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(unit="1")
    "Control signal for valve (0: closed, or 1: open)."
    annotation (Placement(transformation(extent={{140,-120},{180,-80}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput rejFulLoa
    "Reject full surplus load using the district heat exchanger and/or borefield systems."
    annotation (Placement(
        transformation(extent={{140,0},{180,40}}),    iconTransformation(extent=
           {{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput valSta
    "Valve status, true: valve open and part surplus load rejection to the borfield 
    system is required, false otherwise."
    annotation (Placement(transformation(extent={{140,-40},{180,0}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-130,132},{-110,152}})));
  Modelica.StateGraph.InitialStep noDemand(nIn=2)
    "State if no heat or heat rejection is required"
    annotation (Placement(transformation(extent={{-86,88},{-66,108}})));
  Modelica.StateGraph.TransitionWithSignal t1(enableTimer=true, waitTime=60)
    annotation (Placement(transformation(extent={{-34,110},{-14,130}})));
  Modelica.StateGraph.StepWithSignal runHP
    "State if heat pump/EIR chiller operation is required"
    annotation (Placement(transformation(extent={{-4,110},{16,130}})));
  Modelica.StateGraph.TransitionWithSignal t2
    annotation (Placement(transformation(extent={{34,110},{54,130}})));
  Modelica.StateGraph.TransitionWithSignal t3(enableTimer=false)
    annotation (Placement(transformation(extent={{-34,70},{-14,90}})));
  Modelica.StateGraph.StepWithSignal rejParLoaSta(nOut=2, nIn=2)
    "Reject part load status, true: open valves and reject heat to either borefield
      or district heat exchanger."
    annotation (Placement(transformation(extent={{-16,70},{4,90}})));
  Modelica.StateGraph.TransitionWithSignal t4
    annotation (Placement(transformation(extent={{38,88},{58,108}})));
  Modelica.StateGraph.Alternative alternative
    annotation (Placement(transformation(extent={{-58,42},{124,154}})));
  Modelica.StateGraph.TransitionWithSignal t5(enableTimer=false)
    annotation (Placement(transformation(extent={{26,50},{46,70}})));
  Modelica.StateGraph.StepWithSignal rejFulLoaSta
    "Reject full load status: true: reject heat to both the borefield and district heat exchanger."
    annotation (Placement(transformation(extent={{46,50},{66,70}})));
  Modelica.StateGraph.TransitionWithSignal t6
    annotation (Placement(transformation(extent={{66,50},{86,70}})));
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
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
  Inequality greEqu
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Inequality greEqu1
    annotation (Placement(transformation(extent={{-60,-2},{-40,18}})));
  Inequality greEqu2
    annotation (Placement(transformation(extent={{-60,-32},{-40,-12}})));
  Inequality greEqu3
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Inequality greEqu4
    annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));
  Inequality greEqu5
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
equation
  connect(t1.outPort, runHP.inPort[1]) annotation (Line(points={{-22.5,120},{-5,120}},  color={0,0,0}));
  connect(runHP.outPort[1], t2.inPort) annotation (Line(points={{16.5,120},{40,120}},
                                                 color={0,0,0}));
  connect(t3.outPort, rejParLoaSta.inPort[1]) annotation (Line(points={{-22.5,
          80},{-18,80},{-18,80.5},{-17,80.5}}, color={0,0,0}));
  connect(alternative.inPort, noDemand.outPort[1]) annotation (Line(points={{-60.73,98},{-65.5,98}}, color={0,0,0}));
  connect(t3.inPort, alternative.split[1]) annotation (Line(points={{-28,80},{-32,
          80},{-32,98},{-38.89,98}},color={0,0,0}));
  connect(t1.inPort, alternative.split[2]) annotation (Line(points={{-28,120},{-34,
          120},{-34,98},{-38.89,98}},color={0,0,0}));
  connect(alternative.outPort, noDemand.inPort[1]) annotation (Line(points={{125.82,
          98},{120,98},{120,146},{-100,146},{-100,98.5},{-87,98.5}},
                                                               color={0,0,0}));
  connect(t5.outPort, rejFulLoaSta.inPort[1]) annotation (Line(points={{37.5,60},{45,60}}, color={0,0,0}));
  connect(rejFulLoaSta.outPort[1], t6.inPort) annotation (Line(points={{66.5,60},{72,60}}, color={0,0,0}));
  connect(t2.outPort, alternative.join[1]) annotation (Line(points={{45.5,120},{
          96,120},{96,98},{104.89,98}},color={0,0,0}));
  connect(t4.inPort, rejParLoaSta.outPort[1]) annotation (Line(points={{44,98},
          {14,98},{14,80.25},{4.5,80.25}}, color={0,0,0}));
  connect(t5.inPort, rejParLoaSta.outPort[2]) annotation (Line(points={{32,60},
          {14,60},{14,79.75},{4.5,79.75}}, color={0,0,0}));
  connect(rejParLoaSta.inPort[2], t6.outPort) annotation (Line(points={{-17,
          79.5},{-20,79.5},{-20,40},{86,40},{86,60},{77.5,60}}, color={0,0,0}));
  connect(t4.outPort, alternative.join[2]) annotation (Line(points={{49.5,98},{104.89,
          98}},                    color={0,0,0}));
  connect(greEqu.y, t1.condition) annotation (Line(points={{-78,40},{-46,40},{-46,
          106},{-24,106},{-24,108}}, color={255,0,255}));
  connect(booToRea.u, or2.y) annotation (Line(points={{98,-100},{90,-100},{90,-20},
          {82,-20}},      color={255,0,255}));
  connect(booToRea.u,or2. y) annotation (Line(points={{98,-100},{90,-100},{90,-20},
          {82,-20}},      color={255,0,255}));
  connect(valSta, or2.y) annotation (Line(points={{160,-20},{82,-20}}, color={255,0,255}));
  connect(yVal, booToRea.y) annotation (Line(points={{160,-100},{122,-100}},
                     color={0,0,127}));
  connect(TSet, greEqu4.u2) annotation (Line(points={{-160,120},{-128,120},{-128,
          -100},{-62,-100}}, color={0,0,127}));
  connect(TSet, greEqu.u1) annotation (Line(points={{-160,120},{-128,120},{-128,
          40},{-102,40}}, color={0,0,127}));
  connect(addPar.u, TSet) annotation (Line(points={{-102,0},{-128,0},{-128,120},
          {-160,120}}, color={0,0,127}));
  connect(addPar1.u, TSet) annotation (Line(points={{-102,-140},{-128,-140},{-128,
          120},{-160,120}}, color={0,0,127}));
  connect(addPar.y, greEqu1.u2) annotation (Line(points={{-78,0},{-62,0}}, color={0,0,127}));
  connect(addPar3.u, addPar.y) annotation (Line(points={{-102,-60},{-120,-60},{-120,
          -14},{-72,-14},{-72,0},{-78,0}}, color={0,0,127}));
  connect(addPar2.u, addPar.y) annotation (Line(points={{-102,-30},{-110,-30},{-110,
          -14},{-72,-14},{-72,0},{-78,0}}, color={0,0,127}));
  connect(addPar2.y, greEqu2.u2) annotation (Line(points={{-78,-30},{-62,-30}},
                                                   color={0,0,127}));
  connect(addPar3.y, greEqu3.u1)   annotation (Line(points={{-78,-60},{-62,-60}},
                                                   color={0,0,127}));
  connect(addPar1.y, greEqu5.u1) annotation (Line(points={{-78,-140},{-62,-140}}, color={0,0,127}));
  connect(or2.u2, rejParLoaSta.active) annotation (Line(points={{58,-28},{-6,-28},
          {-6,69}},                                                                         color={255,0,255}));
  connect(greEqu1.y, t3.condition) annotation (Line(points={{-38,8},{-28,8},{-28,
          34},{-24,34},{-24,68}}, color={255,0,255}));
  connect(greEqu2.y, t5.condition) annotation (Line(points={{-38,-22},{-24,-22},
          {-24,34},{36,34},{36,48}}, color={255,0,255}));
  connect(greEqu3.y, t6.condition) annotation (Line(points={{-38,-60},{-16,-60},
          {-16,30},{76,30},{76,48}}, color={255,0,255}));
  connect(greEqu4.y, t2.condition) annotation (Line(points={{-38,-92},{-12,-92},
          {-12,26},{4,26},{4,100},{44,100},{44,108}}, color={255,0,255}));
  connect(greEqu5.y, t4.condition) annotation (Line(points={{-38,-140},{-8,-140},{-8,22},{8,
          22},{8,84},{48,84},{48,86}},
                                    color={255,0,255}));

   annotation (
  defaultComponentName="conHotSid",
  Diagram(coordinateSystem(extent={{-140,-160},{140,160}})), Icon(graphics={
        Polygon(
          points={{62,-60},{42,-48},{42,-70},{62,-60}},
          lineColor={0,0,0}),
        Polygon(
          points={{62,-60},{82,-48},{82,-70},{62,-60}},
          lineColor={0,0,0})}),
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
</html>"));
end HotColdSideController;
