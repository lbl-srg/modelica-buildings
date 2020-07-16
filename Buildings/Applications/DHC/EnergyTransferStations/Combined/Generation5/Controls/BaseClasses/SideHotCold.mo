within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses;
partial block SideHotCold
  "Base control block for hor or cold side"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nSouAmb
    "Number of ambient sources to control"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.TemperatureDifference dTHys = 2
    "Temperature hysteresis (full width, absolute value)";
  parameter Modelica.SIunits.TemperatureDifference dTDea = 0
    "Temperature dead band (absolute value)";
  parameter Boolean reverseActing = false
    "Set to true for control output increasing with decreasing measurement value";

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.P
    "Type of controller"
    annotation(choices(
      choice=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
      choice=Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real k[nSouAmb](each min=0) = fill(1, nSouAmb)
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti[nSouAmb](
    each min=Buildings.Controls.OBC.CDL.Constants.small) = fill(0.5, nSouAmb)
    "Time constant of integrator block"
    annotation (Dialog(enable=
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna
    "Heating or cooling mode enabled signal"
    annotation (Placement(
      transformation(extent={{-220,160},{-180,200}}), iconTransformation(
        extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput yDemOpp
    "Tank demand signal from opposite side"
    annotation (Placement(
      transformation(extent={{-220,120},{-180,160}}), iconTransformation(
        extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature set-point (heating or chilled water)"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTop(
    final unit="K",
    displayUnit="degC") "Temperature at top of tank"
    annotation (Placement(transformation(extent={{-220,-100},{-180,-60}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBot(
    final unit="K",
    displayUnit="degC") "Temperature at bottom of tank"
    annotation (Placement(transformation(extent={{-220,-160},{-180,-120}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoAmb(final unit="1")
    "Ambient loop isolation valve control signal"
    annotation (Placement(
      transformation(extent={{180,-140},{220,-100}}),
      iconTransformation(
        extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAmb[nSouAmb](each final
      unit="1") "Control signal for ambient sources" annotation (Placement(
        transformation(extent={{180,-100},{220,-60}}),
                                                     iconTransformation(extent={
            {100,-30},{140,10}})));

  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Modelica.StateGraph.InitialStep noDemand(nIn=2)
    "State if no heat or heat rejection is required"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Modelica.StateGraph.TransitionWithSignal t1(enableTimer=true, waitTime=60)
    "Transition to enabled"
    annotation (Placement(transformation(extent={{50,130},{70,150}})));
  Modelica.StateGraph.StepWithSignal dem
    "Heating or cooling demand from the tank"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Modelica.StateGraph.TransitionWithSignal t2(enableTimer=true, waitTime=300)
    "Transition to disabled"
    annotation (Placement(transformation(extent={{110,130},{130,150}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual enaHeaCoo
    "Threshold comparison for enabling heating or cooling system"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual disHeaCoo
    "Threshold comparison for disabling heating or cooling system"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDem
    "Tank in heating or cooling demand" annotation (Placement(transformation(
          extent={{180,80},{220,120}}), iconTransformation(extent={{100,40},{140,
            80}})));
  LimPlaySequence conPlaSeq(
    have_enaSig=true,
    final nCon=nSouAmb,
    yThr=0.9,
    final hys=dTHys,
    final dea=dTDea,
    final yMin=0,
    final yMax=1,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final reverseActing=reverseActing)
    annotation (Placement(transformation(extent={{-70,-130},{-50,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(threshold=
        Modelica.Constants.eps) "At least one signal is non zero"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert DO to AO signal"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback errEna "Error for enabling"
    annotation (Placement(transformation(extent={{-98,30},{-78,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback errDis "Disabling error"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Product proEna
    "Opposite if reverse acting"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Product proDis
    "Opposite if reverse acting"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant revAct(
    final k= reverseActing) "Output true in case of reverse acting"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(
    final realTrue=-1,
    final realFalse=1) "Output -1 if reverse acting, else 1"
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{150,90},{170,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax(nin=nSouAmb)
    "Maximum of control signals for ambient sources"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uMod "Rejection mode"
    annotation (Placement(transformation(extent={{-220,120},{-180,160}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput e(each final unit="1")
    "Error" annotation (Placement(transformation(extent={{180,-20},{220,20}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{-90,-170},{-70,-150}})));
initial equation
  assert(dTHys >= 0, "In " + getInstanceName() +
    ": dTHys (" + String(dTHys) + ") must be an absolute value.");
  assert(dTDea >= 0, "In " + getInstanceName() +
    ": dTDea (" + String(dTDea) + ") must be an absolute value.");
equation
  connect(t1.outPort,dem. inPort[1])
    annotation (Line(points={{61.5,140},{79,140}},   color={0,0,0}));
  connect(dem.outPort[1], t2.inPort)
    annotation (Line(points={{100.5,140},{116,140}},color={0,0,0}));
  connect(enaHeaCoo.y, t1.condition) annotation (Line(points={{52,40},{60,40},{
          60,128}},
                 color={255,0,255}));
  connect(disHeaCoo.y, t2.condition)
    annotation (Line(points={{52,0},{120,0},{120,128}}, color={255,0,255}));
  connect(greThr.y, booToRea.u) annotation (Line(points={{102,-120},{118,-120}},
                     color={255,0,255}));
  connect(booToRea.y, yIsoAmb) annotation (Line(points={{142,-120},{200,-120}},
                           color={0,0,127}));
  connect(TSet, errEna.u1) annotation (Line(points={{-200,40},{-100,40}},
                          color={0,0,127}));
  connect(TSet, errDis.u1) annotation (Line(points={{-200,40},{-160,40},{-160,0},
          {-72,0}},    color={0,0,127}));
  connect(zer.y, disHeaCoo.u1) annotation (Line(points={{2,-40},{20,-40},{20,0},
          {28,0}}, color={0,0,127}));
  connect(zer.y, enaHeaCoo.u2) annotation (Line(points={{2,-40},{20,-40},{20,32},
          {28,32}}, color={0,0,127}));
  connect(proEna.y, enaHeaCoo.u1)
    annotation (Line(points={{2,40},{28,40}},    color={0,0,127}));
  connect(proDis.y, disHeaCoo.u2) annotation (Line(points={{2,0},{12,0},{12,-8},
          {28,-8}}, color={0,0,127}));
  connect(revAct.y, booToRea1.u)
    annotation (Line(points={{-78,80},{-72,80}}, color={255,0,255}));
  connect(errEna.y, proEna.u2) annotation (Line(points={{-76,40},{-30,40},{-30,
          34},{-22,34}},
                     color={0,0,127}));
  connect(errDis.y, proDis.u2) annotation (Line(points={{-48,0},{-30,0},{-30,-6},
          {-22,-6}}, color={0,0,127}));
  connect(booToRea1.y, proDis.u1) annotation (Line(points={{-48,80},{-40,80},{
          -40,6},{-22,6}},
                       color={0,0,127}));
  connect(booToRea1.y, proEna.u1) annotation (Line(points={{-48,80},{-40,80},{
          -40,46},{-22,46}},
                         color={0,0,127}));
  connect(noDemand.outPort[1], t1.inPort)
    annotation (Line(points={{20.5,140},{56,140}},  color={0,0,0}));
  connect(t2.outPort, noDemand.inPort[1]) annotation (Line(points={{121.5,140},{
          132,140},{132,160},{-10,160},{-10,140.5},{-1,140.5}},
        color={0,0,0}));
  connect(and2.y, yDem)
    annotation (Line(points={{172,100},{200,100}}, color={255,0,255}));
  connect(dem.active, and2.u2)
    annotation (Line(points={{90,129},{90,92},{148,92}}, color={255,0,255}));
  connect(uEna, and2.u1) annotation (Line(points={{-200,180},{140,180},{140,100},
          {148,100}}, color={255,0,255}));
  connect(TSet, conPlaSeq.u_s) annotation (Line(points={{-200,40},{-160,40},{
          -160,-120},{-72,-120}},
                              color={0,0,127}));
  connect(mulMax.y, greThr.u)
    annotation (Line(points={{62,-120},{78,-120}}, color={0,0,127}));
  connect(uMod, swi.u2) annotation (Line(points={{-200,140},{-140,140},{-140,
          -160},{-92,-160}}, color={255,0,255}));
  connect(TSet, swi.u3) annotation (Line(points={{-200,40},{-160,40},{-160,-168},
          {-92,-168}}, color={0,0,127}));
  connect(swi.y, conPlaSeq.u_m) annotation (Line(points={{-68,-160},{-60,-160},
          {-60,-132}}, color={0,0,127}));
  connect(conPlaSeq.y, mulMax.u)
    annotation (Line(points={{-48,-120},{38,-120}}, color={0,0,127}));
  connect(conPlaSeq.y, yAmb) annotation (Line(points={{-48,-120},{0,-120},{0,
          -80},{200,-80}}, color={0,0,127}));
  connect(proDis.y, e) annotation (Line(points={{2,0},{12,0},{12,-20},{160,-20},
          {160,0},{200,0}}, color={0,0,127}));
  connect(uMod, conPlaSeq.uEna) annotation (Line(points={{-200,140},{-200,
          140.714},{-140,140.714},{-140,-140},{-64,-140},{-64,-132}}, color={
          255,0,255}));
   annotation (
       Diagram(coordinateSystem(extent={{-180,-200},{180,200}})),
Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This block serves as the base controller for the hot (or cold) side of the ETS.
It provides the following control signals.
</p>
<ul>
<li>
Tank in demand <code>yHeaCoo</code><br/>
The tank is in heating (resp. cooling) demand if
<ul>
<li>
there is an actual heating (resp. cooling) demand yielded by the building
automation system, and
</li>
<li>
the temperature measured at the top (resp. bottom) of the tank is below
(resp. above) the set point for more than 60 s.
</li>
</ul>
The tank demand transitions back to false when the maximum (resp. minimum) temperature
between the top and the bottom of the tank is above (resp. below) the set point
for more than 120 s (which indicates that the tank is fully loaded).
</li>
<li>
Control signal for ambient sources <code>y</code><br/>
The systems serving as ambient sources are
<ul>
<li>
enabled if the demand signal from the other tank is true, and
</li>
<li>
controlled in sequence with an instance of
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPlaySequence\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPlaySequence</a>
limiting the increase (resp. decrease) in the temperature measured at the bottom
(resp. top) of the tank as illustrated on the figure below for the hot side.
</li>
</ul>
<li>
Control signal for ambient loop isolation valve <code>yIsoAmb</code><br/>
The valve is commanded to be fully open whenever the maximum of the
ambient source control signals is not zero.
</li>
</ul>
<p>
<img alt=\"Sequence chart for hot side\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/Combined/Generation5/Controls/BaseClasses/HotColdSide.png\"/>
</p>
</html>"));
end SideHotCold;
