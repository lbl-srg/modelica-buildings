within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.Controls.BaseClasses;
partial block HotColdSide "State machine"
  extends Modelica.Blocks.Icons.Block;
  replaceable model Inequality =
    Buildings.Controls.OBC.CDL.Continuous.GreaterEqual;
  parameter Modelica.SIunits.TemperatureDifference THys(min=0.1)
    "Temperature hysteresis";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature set-point (heating or chilled water)"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
                               iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTop(
    final unit="K",
    displayUnit="degC")
    "Temperature at top of tank"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
                                  iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBot(
     final unit="K",
     displayUnit="degC")
    "Temperature at bottom of tank"
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIso(unit="1")
    "Ambient loop isolation valve control signal"
    annotation (Placement(transformation(extent={{180,-40},{220,0}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yRej
    "Boolean signal to switch to full load rejection mode" annotation (
      Placement(transformation(extent={{180,0},{220,40}}), iconTransformation(
          extent={{100,20},{140,60}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-160,220},{-140,240}})));
  Modelica.StateGraph.InitialStep noDemand(nIn=2)
    "State if no heat or heat rejection is required"
    annotation (Placement(transformation(extent={{-150,130},{-130,150}})));
  Modelica.StateGraph.TransitionWithSignal t1(enableTimer=true, waitTime=60)
    annotation (Placement(transformation(extent={{-70,170},{-50,190}})));
  Modelica.StateGraph.StepWithSignal run
    "On/off command of heating or chilled water production system"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Modelica.StateGraph.TransitionWithSignal t2
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Modelica.StateGraph.TransitionWithSignal t3(enableTimer=false)
    annotation (Placement(transformation(extent={{-70,110},{-50,130}})));
  Modelica.StateGraph.StepWithSignal rejPar(nOut=2, nIn=2)
    "Partial rejection mode"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Modelica.StateGraph.Alternative alternative
    annotation (Placement(transformation(extent={{-110,58},{170,220}})));
  Modelica.StateGraph.TransitionWithSignal t4
    annotation (Placement(transformation(extent={{10,110},{30,130}})));
  Modelica.StateGraph.TransitionWithSignal t5(enableTimer=false)
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Modelica.StateGraph.StepWithSignal rejFul "Full rejection mode"
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
  Modelica.StateGraph.TransitionWithSignal t6
    annotation (Placement(transformation(extent={{110,90},{130,110}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(k=1, p=2*THys)
    annotation (Placement(transformation(extent={{-132,-90},{-112,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(k=1, p=THys)
    annotation (Placement(transformation(extent={{-130,-130},{-110,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar3(k=1, p=0.5*THys)
    annotation (Placement(transformation(extent={{-130,-170},{-110,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(k=1, p=THys)
    annotation (Placement(transformation(extent={{-130,-230},{-110,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to real conversion"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Inequality greEqu
    annotation (Placement(transformation(extent={{-138,-10},{-118,10}})));
  Inequality greEqu1
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Inequality greEqu2
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
  Inequality greEqu3
    annotation (Placement(transformation(extent={{-90,-150},{-70,-130}})));
  Inequality greEqu4
    annotation (Placement(transformation(extent={{-90,-190},{-70,-170}})));
  Inequality greEqu5
    annotation (Placement(transformation(extent={{-90,-230},{-70,-210}})));
equation
  connect(t1.outPort, run.inPort[1])
    annotation (Line(points={{-58.5,180},{-41,180}}, color={0,0,0}));
  connect(run.outPort[1], t2.inPort)
    annotation (Line(points={{-19.5,180},{-4,180}}, color={0,0,0}));
  connect(t3.outPort, rejPar.inPort[1]) annotation (Line(points={{-58.5,120},{-58,
          120},{-58,120.5},{-41,120.5}}, color={0,0,0}));
  connect(alternative.inPort, noDemand.outPort[1]) annotation (Line(points={{-114.2,
          139},{-120,139},{-120,140},{-129.5,140}},                                                  color={0,0,0}));
  connect(t3.inPort, alternative.split[1]) annotation (Line(points={{-64,120},{-74,
          120},{-74,139},{-80.6,139}},
                                    color={0,0,0}));
  connect(t1.inPort, alternative.split[2]) annotation (Line(points={{-64,180},{-74,
          180},{-74,139},{-80.6,139}},
                                     color={0,0,0}));
  connect(alternative.outPort, noDemand.inPort[1]) annotation (Line(points={{172.8,
          139},{160,139},{160,200},{-160,200},{-160,140.5},{-151,140.5}},
                                                               color={0,0,0}));
  connect(t5.outPort, rejFul.inPort[1])
    annotation (Line(points={{41.5,100},{69,100}}, color={0,0,0}));
  connect(rejFul.outPort[1], t6.inPort)
    annotation (Line(points={{90.5,100},{116,100}}, color={0,0,0}));
  connect(t2.outPort, alternative.join[1]) annotation (Line(points={{1.5,180},{60,
          180},{60,139},{140.6,139}},  color={0,0,0}));
  connect(t4.inPort, rejPar.outPort[1]) annotation (Line(points={{16,120},{-26,120},
          {-26,120.25},{-19.5,120.25}}, color={0,0,0}));
  connect(t5.inPort, rejPar.outPort[2]) annotation (Line(points={{36,100},{-10,100},
          {-10,119.75},{-19.5,119.75}}, color={0,0,0}));
  connect(rejPar.inPort[2], t6.outPort) annotation (Line(points={{-41,119.5},{-50,
          119.5},{-50,80},{132,80},{132,100},{121.5,100}}, color={0,0,0}));
  connect(t4.outPort, alternative.join[2]) annotation (Line(points={{21.5,120},{
          60,120},{60,139},{140.6,139}},
                                   color={0,0,0}));
  connect(greEqu.y, t1.condition) annotation (Line(points={{-116,0},{-100,0},{-100,
          160},{-60,160},{-60,168}}, color={255,0,255}));
  connect(booToRea.u, or2.y) annotation (Line(points={{138,-20},{112,-20}},
                          color={255,0,255}));
  connect(yIso, booToRea.y) annotation (Line(points={{200,-20},{162,-20}},
                     color={0,0,127}));
  connect(TSet, greEqu4.u2) annotation (Line(points={{-200,120},{-160,120},{-160,
          -188},{-92,-188}}, color={0,0,127}));
  connect(TSet, greEqu.u1) annotation (Line(points={{-200,120},{-160,120},{-160,
          0},{-140,0}},   color={0,0,127}));
  connect(addPar.u, TSet) annotation (Line(points={{-134,-80},{-160,-80},{-160,120},
          {-200,120}}, color={0,0,127}));
  connect(addPar1.u, TSet) annotation (Line(points={{-132,-220},{-160,-220},{-160,
          120},{-200,120}}, color={0,0,127}));
  connect(addPar.y, greEqu1.u2) annotation (Line(points={{-110,-80},{-100,-80},{
          -100,-68},{-92,-68}},                                            color={0,0,127}));
  connect(addPar3.u, addPar.y) annotation (Line(points={{-132,-160},{-150,-160},
          {-150,-94},{-100,-94},{-100,-80},{-110,-80}},
                                           color={0,0,127}));
  connect(addPar2.u, addPar.y) annotation (Line(points={{-132,-120},{-140,-120},
          {-140,-94},{-100,-94},{-100,-80},{-110,-80}},
                                           color={0,0,127}));
  connect(addPar2.y, greEqu2.u2) annotation (Line(points={{-108,-120},{-100,-120},
          {-100,-108},{-92,-108}},                 color={0,0,127}));
  connect(addPar3.y, greEqu3.u1)   annotation (Line(points={{-108,-160},{-100,-160},
          {-100,-140},{-92,-140}},                 color={0,0,127}));
  connect(addPar1.y, greEqu5.u1) annotation (Line(points={{-108,-220},{-92,-220}},color={0,0,127}));
  connect(or2.u2, rejPar.active) annotation (Line(points={{88,-28},{-30,-28},{-30,
          109}}, color={255,0,255}));
  connect(greEqu1.y, t3.condition) annotation (Line(points={{-68,-60},{-60,-60},
          {-60,108}},             color={255,0,255}));
  connect(greEqu2.y, t5.condition) annotation (Line(points={{-68,-100},{40,-100},
          {40,88}},                  color={255,0,255}));
  connect(greEqu3.y, t6.condition) annotation (Line(points={{-68,-140},{120,-140},
          {120,88}},                 color={255,0,255}));
  connect(greEqu4.y, t2.condition) annotation (Line(points={{-68,-180},{0,-180},
          {0,168}},                                   color={255,0,255}));
  connect(greEqu5.y, t4.condition) annotation (Line(points={{-68,-220},{20,-220},
          {20,108}},                color={255,0,255}));

  connect(rejFul.active, or2.u1)
    annotation (Line(points={{80,89},{80,-20},{88,-20}}, color={255,0,255}));
  connect(rejFul.active, yRej)
    annotation (Line(points={{80,89},{80,20},{200,20}}, color={255,0,255}));
   annotation (
 Documentation(info="<html>


</html>", revisions="<html>
<ul>
<li>
November 25, 2019, by Hagar Elarga:<br/>
Added the info section.
</li>
<li>
March 21, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-260},{180,260}})));
end HotColdSide;
