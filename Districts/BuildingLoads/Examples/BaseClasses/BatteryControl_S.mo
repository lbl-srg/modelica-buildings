within Districts.BuildingLoads.Examples.BaseClasses;
model BatteryControl_S
  "Battery control that reduces the power fed back to the grid"
 extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter Modelica.SIunits.Power PMax=500e3 "Maximum power during discharge";

  Modelica.Blocks.Interfaces.RealInput SOC(final unit="1") "State of charge" annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput S(final unit="VA")
    "Measured apparent power"                                                       annotation (
      Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
    "Powerflow of battery"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
        rotation=0)));

  Modelica.Blocks.Continuous.LimPID PI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    yMax=1,
      yMin=-1,
      Td=0) "PI controller"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.Blocks.Sources.Constant SSet(k=0) "Set point for power with grid"
    annotation (Placement(transformation(extent={{-84,20},{-64,40}})));
  Modelica_StateGraph2.Step dischargeOnly(
      nOut=2,
      use_activePort=true,
      nIn=2,
      initialStep=false) "Allow battery to be discharged only"
    annotation (Placement(transformation(extent={{36,138},{44,146}})));
  Modelica_StateGraph2.Transition T1(
    waitTime=1,
      use_conditionPort=false,
      condition=SOC < 0.8,
      delayedTransition=false,
      loopCheck=true)
    annotation (Placement(transformation(extent={{36,118},{44,126}})));
  Modelica_StateGraph2.Step freeFloat(
      nOut=3,
      initialStep=false,
      use_activePort=true,
      nIn=2) "Drain or charge battery"
    annotation (Placement(transformation(extent={{16,98},{24,106}})));

  Modelica_StateGraph2.Transition T2(
    waitTime=1,
      use_conditionPort=false,
    condition=SOC < 0.05,
      delayedTransition=false,
      loopCheck=false)
    annotation (Placement(transformation(extent={{-4,78},{4,86}})));

  Modelica_StateGraph2.Step chargeOnly(
      nOut=2,
      use_activePort=true,
      nIn=1,
      initialStep=true) "Allow battery to be charged only"
    annotation (Placement(transformation(extent={{-4,138},{4,146}})));
  Modelica_StateGraph2.Transition T3(
    waitTime=1,
      use_conditionPort=false,
    condition=SOC > 0.95,
      delayedTransition=false,
      loopCheck=false)
    annotation (Placement(transformation(extent={{36,78},{44,86}})));
  Modelica_StateGraph2.Transition T4(
    waitTime=1,
      use_conditionPort=false,
      condition=SOC > 0.2,
      delayedTransition=false,
      loopCheck=true)
    annotation (Placement(transformation(extent={{-4,118},{4,126}})));
    Modelica.Blocks.Sources.RealExpression chaSig(y=if chargeOnly.activePort
           then max(0, PI.y) else if dischargeOnly.activePort then min(0, PI.y)
           else if nightCharge.activePort then 1 else if holdCharge.activePort
           then 0 else PI.y) "Charge signal"
      annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
    Modelica.Blocks.Math.Gain gain(k=PMax)
      annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=60, initType=Modelica.Blocks.Types.Init.InitialState)
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
    Modelica.Blocks.Sources.BooleanExpression isNight(y=mod(time/3600, 24) < 7
         or mod(time/3600, 24) > 20) "Outputs true during night"
      annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica_StateGraph2.Step holdCharge(
    nOut=1,
    use_activePort=true,
    nIn=1,
    initialStep=false) "Hold charge"
    annotation (Placement(transformation(extent={{16,4},{24,12}})));
  Modelica_StateGraph2.Transition T7(
    waitTime=1,
      use_conditionPort=false,
    delayedTransition=false,
      loopCheck=true,
      condition=isHighRate.y)
    annotation (Placement(transformation(extent={{16,-12},{24,-4}})));
  Modelica_StateGraph2.Transition T6(
    waitTime=1,
      use_conditionPort=false,
    condition=SOC > 0.95,
    delayedTransition=false,
      loopCheck=false)
    annotation (Placement(transformation(extent={{16,24},{24,32}})));
  Modelica_StateGraph2.Step nightCharge(
    nOut=1,
    use_activePort=true,
    nIn=3,
    initialStep=false) "Charge battery"
    annotation (Placement(transformation(extent={{16,38},{24,46}})));
  Modelica_StateGraph2.Transition T5(
    waitTime=1,
      use_conditionPort=false,
    condition=isNight.y,
    delayedTransition=false,
      loopCheck=true)
    annotation (Placement(transformation(extent={{16,54},{24,62}})));
  Modelica_StateGraph2.Transition T8(
    waitTime=1,
      use_conditionPort=false,
    condition=isNight.y,
    delayedTransition=false,
      loopCheck=true)
    annotation (Placement(transformation(extent={{-30,54},{-22,62}})));
  Modelica_StateGraph2.Transition T9(
    waitTime=1,
      use_conditionPort=false,
    condition=isNight.y,
    delayedTransition=false,
      loopCheck=true)
    annotation (Placement(transformation(extent={{56,54},{64,62}})));
    Modelica.Blocks.Sources.BooleanExpression isHighRate(y=mod(time/3600, 24) >
          14 and mod(time/3600, 24) < 17) "Outputs true during peak rate time"
      annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

equation
    connect(freeFloat.outPort[1], T2.inPort)  annotation (Line(
      points={{18.6667,97.4},{18.6667,92},{0,92},{0,86}},
      color={0,0,0},
      smooth=Smooth.None));
    connect(dischargeOnly.outPort[1], T1.inPort)
                                            annotation (Line(
      points={{39,137.4},{39,132},{40,132},{40,126}},
      color={0,0,0},
      smooth=Smooth.None));
    connect(T2.outPort, chargeOnly.inPort[1]) annotation (Line(
        points={{0,77},{0,72},{-20,72},{-20,156},{0,156},{0,146}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(T4.outPort, freeFloat.inPort[1]) annotation (Line(
        points={{0,117},{0,112},{19,112},{19,106}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(T1.outPort, freeFloat.inPort[2]) annotation (Line(
        points={{40,117},{40,112},{21,112},{21,106}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(chaSig.y, gain.u)         annotation (Line(
        points={{-19,-70},{18,-70}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(SSet.y, PI.u_s)  annotation (Line(
        points={{-63,30},{-52,30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(S, PI.u_m) annotation (Line(
        points={{-120,-60},{-40,-60},{-40,18}},
        color={0,0,127},
        smooth=Smooth.None));
  connect(firstOrder.u, gain.y) annotation (Line(
      points={{58,-70},{41,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y,P)  annotation (Line(
      points={{81,-70},{90,-70},{90,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(T5.outPort, nightCharge.inPort[1]) annotation (Line(
        points={{20,53},{20,46},{18.6667,46}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(nightCharge.outPort[1], T6.inPort) annotation (Line(
        points={{20,37.4},{20,32}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(T6.outPort, holdCharge.inPort[1]) annotation (Line(
        points={{20,23},{20,12}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(holdCharge.outPort[1], T7.inPort) annotation (Line(
        points={{20,3.4},{20,-4}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(T8.outPort, nightCharge.inPort[2]) annotation (Line(
        points={{-26,53},{-26,50},{20,50},{20,46}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(T9.outPort, nightCharge.inPort[3]) annotation (Line(
        points={{60,53},{60,50},{21.3333,50},{21.3333,46}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(chargeOnly.outPort[1], T8.inPort) annotation (Line(
        points={{-1,137.4},{-1,130},{-26,130},{-26,62}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(dischargeOnly.outPort[2], T9.inPort) annotation (Line(
        points={{41,137.4},{41,132},{60,132},{60,62}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(freeFloat.outPort[2], T5.inPort) annotation (Line(
        points={{20,97.4},{20,62}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(T7.outPort, dischargeOnly.inPort[1]) annotation (Line(
        points={{20,-13},{20,-20},{80,-20},{80,162},{39,162},{39,146}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(T3.outPort, dischargeOnly.inPort[2]) annotation (Line(
        points={{40,77},{40,72},{56,72},{56,154},{41,154},{41,146}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(chargeOnly.outPort[2], T4.inPort) annotation (Line(
        points={{1,137.4},{1,132},{0,132},{0,126}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(freeFloat.outPort[3], T3.inPort) annotation (Line(
        points={{21.3333,97.4},{21.3333,92},{40,92},{40,86}},
        color={0,0,0},
        smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,180}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false),
          graphics={
          Text(
            extent={{-94,88},{-50,58}},
            lineColor={0,0,255},
          textString="SOC"),
        Rectangle(
          extent={{-74,52},{-8,8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,52},{86,8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,28},{10,36},{10,20},{20,28}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-74,30},{-84,38},{-84,22},{-74,30}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-8,28},{12,28}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-78,30},{-96,30}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{20,-12},{86,-56}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,-34},{10,-26},{10,-42},{20,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{10,-36},{2,-36},{2,28}},
          color={0,0,0},
          smooth=Smooth.None),
          Text(
            extent={{-92,-44},{-48,-74}},
            lineColor={0,0,255},
          textString="S")}));
end BatteryControl_S;
