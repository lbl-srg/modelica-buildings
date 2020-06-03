within Buildings.Applications.DHC.EnergyTransferStations.Generation5.Controls.BaseClasses;
partial block HotColdSide "State machine enabling production and ambient source systems"
  extends Modelica.Blocks.Icons.Block;
  replaceable model Inequality =
    Buildings.Controls.OBC.CDL.Continuous.GreaterEqual;
  parameter Modelica.SIunits.TemperatureDifference THys
    "Temperature hysteresis (absolute value)";
  parameter Integer sigTHys = +1
    "Sign of hysteresis (+1 or -1)";
  final parameter Modelica.SIunits.TemperatureDifference THysSig = sigTHys * THys
    "Temperature hysteresis (signed value)";
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoAmb(unit="1")
    "Ambient loop isolation valve control signal" annotation (Placement(
        transformation(extent={{180,-100},{220,-60}}), iconTransformation(
          extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yRej
    "Enabled signal for full heat or cold rejection to ambient loop"
    annotation (Placement(transformation(extent={{180,0},{220,40}}), iconTransformation(
      extent={{100,20},{140,60}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-160,240},{-140,260}})));
  Modelica.StateGraph.InitialStep noDemand(nIn=2)
    "State if no heat or heat rejection is required"
    annotation (Placement(transformation(extent={{-150,130},{-130,150}})));
  Modelica.StateGraph.TransitionWithSignal t1(enableTimer=true, waitTime=60)
    annotation (Placement(transformation(extent={{-70,170},{-50,190}})));
  Modelica.StateGraph.StepWithSignal run
    "On/off command of heating or cooling system"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Modelica.StateGraph.TransitionWithSignal t2
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Modelica.StateGraph.TransitionWithSignal t3(enableTimer=false)
    annotation (Placement(transformation(extent={{-70,110},{-50,130}})));
  Modelica.StateGraph.StepWithSignal rejPar(nOut=2, nIn=2)
    "Partial rejection mode, open ambient loop isolation valves"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Modelica.StateGraph.Alternative alternative
    annotation (Placement(transformation(extent={{-110,60},{170,220}})));
  Modelica.StateGraph.TransitionWithSignal t4
    annotation (Placement(transformation(extent={{10,110},{30,130}})));
  Modelica.StateGraph.TransitionWithSignal t5(enableTimer=false)
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Modelica.StateGraph.StepWithSignal rejFul "Full rejection mode"
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
  Modelica.StateGraph.TransitionWithSignal t6
    annotation (Placement(transformation(extent={{110,90},{130,110}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TSet2Thys(
    k=1, p=2*THysSig)
    "Output TSet + 2 * THysSig"
    annotation (Placement(transformation(extent={{-130,-70},{-110,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TSet3THys(
    k=1, p=3*THysSig)
    "Output TSet + 3 * THysSig"
    annotation (Placement(transformation(extent={{-130,-210},{-110,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TSet2p5THys(
    k=1, p=2.5*THysSig)
    "Output TSet + 2.5 * THysSig"
    annotation (Placement(transformation(extent={{-130,-250},{-110,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TSet1THys(
    k=1, p=THysSig)
    "Output TSet + THysSig"
    annotation (Placement(transformation(extent={{-130,-150},{-110,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to real conversion"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Inequality enaHeaCoo
    "Threshold comparison for enabling heating or cooling system"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Inequality opeIso
    "Threshold comparison for opening ambient loop isolation valves"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Inequality enaRej
    "Threshold comparison for enabling full heat or cold rejection"
    annotation (Placement(transformation(extent={{-40,-210},{-20,-190}})));
  Inequality disRej
    "Threshold comparison for disabling full heat or cold rejection"
    annotation (Placement(transformation(extent={{-42,-250},{-22,-230}})));
  Inequality disHeaCoo
    "Threshold comparison for disabling heating or cooling system"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Inequality cloIso
    "Threshold comparison for closing ambient loop isolation valves"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHeaCoo
    "Enabled signal for heating or cooling system"
    annotation (Placement(transformation(extent={{180,140},{220,180}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAmb
    "Enabled signal for connecting ambient loop " annotation (Placement(
        transformation(extent={{180,-60},{220,-20}}), iconTransformation(extent=
           {{100,-20},{140,20}})));
initial equation
  assert(THys >= 0, "In " + getInstanceName() +
    ": THys (" + String(THys) + ") must be an absolute value.");
  assert(sigTHys == -1 or sigTHys == 1, "In " + getInstanceName() +
    ": sigTHys (" + String(sigTHys) + ") must be equal to +1 or -1.");
equation
  connect(t1.outPort, run.inPort[1])
    annotation (Line(points={{-58.5,180},{-41,180}}, color={0,0,0}));
  connect(run.outPort[1], t2.inPort)
    annotation (Line(points={{-19.5,180},{-4,180}}, color={0,0,0}));
  connect(t3.outPort, rejPar.inPort[1]) annotation (Line(points={{-58.5,120},{-58,
          120},{-58,120.5},{-41,120.5}}, color={0,0,0}));
  connect(alternative.inPort, noDemand.outPort[1]) annotation (Line(points={{-114.2,
          140},{-129.5,140}}, color={0,0,0}));
  connect(t3.inPort, alternative.split[1]) annotation (Line(points={{-64,120},{-74,
          120},{-74,140},{-80.6,140}}, color={0,0,0}));
  connect(t1.inPort, alternative.split[2]) annotation (Line(points={{-64,180},{-74,
          180},{-74,140},{-80.6,140}}, color={0,0,0}));
  connect(alternative.outPort, noDemand.inPort[1]) annotation (Line(points={{172.8,
          140},{160,140},{160,200},{-160,200},{-160,140.5},{-151,140.5}}, color={0,0,0}));
  connect(t5.outPort, rejFul.inPort[1])
    annotation (Line(points={{41.5,100},{69,100}}, color={0,0,0}));
  connect(rejFul.outPort[1], t6.inPort)
    annotation (Line(points={{90.5,100},{116,100}}, color={0,0,0}));
  connect(t2.outPort, alternative.join[1]) annotation (Line(points={{1.5,180},{60,
          180},{60,140},{140.6,140}},  color={0,0,0}));
  connect(t4.inPort, rejPar.outPort[1]) annotation (Line(points={{16,120},{-26,120},
          {-26,120.25},{-19.5,120.25}}, color={0,0,0}));
  connect(t5.inPort, rejPar.outPort[2]) annotation (Line(points={{36,100},{-10,100},
          {-10,119.75},{-19.5,119.75}}, color={0,0,0}));
  connect(rejPar.inPort[2], t6.outPort) annotation (Line(points={{-41,119.5},{-50,
          119.5},{-50,80},{132,80},{132,100},{121.5,100}}, color={0,0,0}));
  connect(t4.outPort, alternative.join[2]) annotation (Line(points={{21.5,120},{
          60,120},{60,140},{140.6,140}}, color={0,0,0}));
  connect(enaHeaCoo.y, t1.condition) annotation (Line(points={{-118,40},{-100,40},
          {-100,160},{-60,160},{-60,168}}, color={255,0,255}));
  connect(booToRea.u, or2.y) annotation (Line(points={{138,-80},{112,-80}}, color={255,0,255}));
  connect(TSet, disHeaCoo.u2) annotation (Line(points={{-200,120},{-160,120},{-160,
          -8},{-142,-8}}, color={0,0,127}));
  connect(TSet, enaHeaCoo.u1) annotation (Line(points={{-200,120},{-160,120},{-160,
          40},{-142,40}}, color={0,0,127}));
  connect(TSet2Thys.u, TSet) annotation (Line(points={{-132,-60},{-160,-60},{-160,
          120},{-200,120}}, color={0,0,127}));
  connect(TSet1THys.u, TSet) annotation (Line(points={{-132,-140},{-160,-140},{-160,
          120},{-200,120}}, color={0,0,127}));
  connect(TSet2Thys.y, opeIso.u2) annotation (Line(points={{-108,-60},{-100,-60},
          {-100,-48},{-92,-48}}, color={0,0,127}));
  connect(TSet3THys.y, enaRej.u2) annotation (Line(points={{-108,-200},{-60,-200},
          {-60,-208},{-42,-208}}, color={0,0,127}));
  connect(TSet2p5THys.y, disRej.u1)
    annotation (Line(points={{-108,-240},{-44,-240}}, color={0,0,127}));
  connect(TSet1THys.y, cloIso.u1)
    annotation (Line(points={{-108,-140},{-42,-140}}, color={0,0,127}));
  connect(or2.u2, rejPar.active) annotation (Line(points={{88,-88},{-30,-88},{
          -30,109}},
                 color={255,0,255}));
  connect(opeIso.y, t3.condition) annotation (Line(points={{-68,-40},{-60,-40},{
          -60,108}}, color={255,0,255}));
  connect(enaRej.y, t5.condition) annotation (Line(points={{-18,-200},{40,-200},
          {40,88}}, color={255,0,255}));
  connect(disRej.y, t6.condition) annotation (Line(points={{-20,-240},{120,-240},
          {120,88}}, color={255,0,255}));
  connect(disHeaCoo.y, t2.condition)
    annotation (Line(points={{-118,0},{0,0},{0,168}}, color={255,0,255}));
  connect(cloIso.y, t4.condition) annotation (Line(points={{-18,-140},{20,-140},
          {20,108}}, color={255,0,255}));
  connect(rejFul.active, or2.u1)
    annotation (Line(points={{80,89},{80,-80},{88,-80}}, color={255,0,255}));
  connect(rejFul.active, yRej)
    annotation (Line(points={{80,89},{80,20},{200,20}}, color={255,0,255}));
  connect(run.active, yHeaCoo) annotation (Line(points={{-30,169},{-30,160},{200,
          160}}, color={255,0,255}));
  connect(TSet, TSet3THys.u) annotation (Line(points={{-200,120},{-160,120},{-160,
          -200},{-132,-200}}, color={0,0,127}));
  connect(TSet, TSet2p5THys.u) annotation (Line(points={{-200,120},{-160,120},{-160,
          -240},{-132,-240}}, color={0,0,127}));
  connect(booToRea.y, yIsoAmb)
    annotation (Line(points={{162,-80},{200,-80}}, color={0,0,127}));
  connect(or2.y, yAmb) annotation (Line(points={{112,-80},{130,-80},{130,-40},{
          200,-40}}, color={255,0,255}));
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
    Diagram(coordinateSystem(extent={{-180,-280},{180,280}})));
end HotColdSide;
