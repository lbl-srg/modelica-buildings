within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses;
partial block HotColdSide "State machine enabling production and ambient source systems"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nSouAmb = 1
    "Number of ambient sources to control"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.TemperatureDifference dTHys = 1
    "Temperature hysteresis (full width, absolute value)";
  parameter Modelica.SIunits.TemperatureDifference dTDea = 1
    "Temperature dead band (absolute value)";
  parameter Boolean reverseActing = false
    "Set to true for control output increasing with decreasing measurement value";

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType[nSouAmb]=
    fill(Buildings.Controls.OBC.CDL.Types.SimpleController.P, nSouAmb)
    "Type of controller"
    annotation(choices(
      choice=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
      choice=Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real k[nSouAmb](each min=0) = fill(1, nSouAmb)
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti[nSouAmb](
    each min=Buildings.Controls.OBC.CDL.Constants.small) = fill(0.5, nSouAmb)
    "Time constant of integrator block"
    annotation (Dialog(enable=Modelica.Math.BooleanVectors.anyTrue({
      controllerType[i] == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType[i] == Buildings.Controls.OBC.CDL.Types.SimpleController.PID
      for i in 1:nSouAmb})));

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
        extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[nSouAmb](final unit="1")
    "Control output for ambient sources"
    annotation (Placement(transformation(
          extent={{180,-20},{220,20}}), iconTransformation(extent={{100,-30},{
            140,10}})));

  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Modelica.StateGraph.InitialStep noDemand(nIn=2)
    "State if no heat or heat rejection is required"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Modelica.StateGraph.TransitionWithSignal t1(enableTimer=true, waitTime=60)
    "Transition to enabled"
    annotation (Placement(transformation(extent={{50,130},{70,150}})));
  Modelica.StateGraph.StepWithSignal run
    "On/off command of heating or cooling system"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Modelica.StateGraph.TransitionWithSignal t2(enableTimer=true, waitTime=120)
    "Transition to disabled"
    annotation (Placement(transformation(extent={{110,130},{130,150}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual enaHeaCoo
    "Threshold comparison for enabling heating or cooling system"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual disHeaCoo
    "Threshold comparison for disabling heating or cooling system"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHeaCoo
    "Enabled signal for heating or cooling system"
    annotation (Placement(transformation(extent={{180,80},{220,120}}),
      iconTransformation(extent={{100,30},{140,70}})));
  LimPlaySequence conPlaSeq(
    final nCon=nSouAmb,
    final hys=fill(dTHys, nSouAmb),
    final dea=fill(dTDea, nSouAmb),
    final yMin=fill(0, nSouAmb),
    final yMax=fill(1, nSouAmb),
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final reverseActing=reverseActing)
    annotation (Placement(transformation(extent={{-90,-130},{-70,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax(nin=nSouAmb)
    "Max of control signals"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaCoo
    "Heating or cooling mode enabled signal" annotation (Placement(
        transformation(extent={{-220,160},{-180,200}}), iconTransformation(
          extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{150,90},{170,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCooHea
    "Enabled signal for antagonistic mode" annotation (Placement(transformation(
          extent={{-220,120},{-180,160}}), iconTransformation(extent={{-140,20},
            {-100,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Conversion of DI to AI"
    annotation (Placement(transformation(extent={{-170,130},{-150,150}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-140,110})));
  Buildings.Controls.OBC.CDL.Continuous.Min min1[nSouAmb]
    "Enable ambient sources only if antagonistic mode is enabled"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
initial equation
  assert(dTHys >= 0, "In " + getInstanceName() +
    ": dTHys (" + String(dTHys) + ") must be an absolute value.");
  assert(dTDea >= 0, "In " + getInstanceName() +
    ": dTDea (" + String(dTDea) + ") must be an absolute value.");
equation
  connect(t1.outPort, run.inPort[1])
    annotation (Line(points={{61.5,140},{79,140}},   color={0,0,0}));
  connect(run.outPort[1], t2.inPort)
    annotation (Line(points={{100.5,140},{116,140}},color={0,0,0}));
  connect(enaHeaCoo.y, t1.condition) annotation (Line(points={{52,40},{60,40},{
          60,128}},
                 color={255,0,255}));
  connect(disHeaCoo.y, t2.condition)
    annotation (Line(points={{52,0},{120,0},{120,128}}, color={255,0,255}));
  connect(mulMax.y, greThr.u)
    annotation (Line(points={{62,-120},{78,-120}}, color={0,0,127}));
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
  connect(and2.y, yHeaCoo)
    annotation (Line(points={{172,100},{200,100}}, color={255,0,255}));
  connect(run.active, and2.u2)
    annotation (Line(points={{90,129},{90,92},{148,92}}, color={255,0,255}));
  connect(uHeaCoo, and2.u1) annotation (Line(points={{-200,180},{140,180},{140,100},
          {148,100}}, color={255,0,255}));
  connect(TSet, conPlaSeq.u_s) annotation (Line(points={{-200,40},{-160,40},{
          -160,-120},{-92,-120}},
                              color={0,0,127}));
  connect(uCooHea, booToRea2.u)
    annotation (Line(points={{-200,140},{-172,140}}, color={255,0,255}));
  connect(booToRea2.y, reaRep.u) annotation (Line(points={{-148,140},{-140,140},
          {-140,122}}, color={0,0,127}));
  connect(conPlaSeq.y, min1.u2) annotation (Line(points={{-68,-120},{-60,-120},
          {-60,-126},{-42,-126}}, color={0,0,127}));
  connect(min1.y, mulMax.u)
    annotation (Line(points={{-18,-120},{38,-120}}, color={0,0,127}));
  connect(reaRep.y, min1.u1) annotation (Line(points={{-140,98},{-140,-100},{
          -60,-100},{-60,-114},{-42,-114}}, color={0,0,127}));
  connect(min1.y, y) annotation (Line(points={{-18,-120},{0,-120},{0,-100},{160,
          -100},{160,0},{200,0}}, color={0,0,127}));
   annotation (
 Documentation(info="<html>
<p>
Heat or cold rejection to ambient sources is only enabled if the antagonistic mode 
is enabled (which implies that the antogonistic isolation valve is closed).
</p>

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
    Diagram(coordinateSystem(extent={{-180,-200},{180,200}})));
end HotColdSide;
