within Districts.BuildingLoads.Examples.BaseClasses;
model BatteryControl_S
 extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter Modelica.SIunits.Power PMax "Maximum power during discharge";

  Modelica.Blocks.Interfaces.RealInput SOC(final unit="1") "State of charge" annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
    "Powerflow of battery"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
        rotation=0)));

  Modelica_StateGraph2.Step discharge(
      nOut=2,
      initialStep=false,
      use_activePort=true,
      nIn=2) "Drain battery"
    annotation (Placement(transformation(extent={{-32,104},{-24,112}})));
  Modelica_StateGraph2.Transition T2(
    waitTime=1,
      use_conditionPort=false,
    condition=SOC < 0.05,
      delayedTransition=false,
    loopCheck=true)
    annotation (Placement(transformation(extent={{-54,80},{-46,88}})));

    Modelica.Blocks.Math.Gain gain(k=PMax)
      annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
    Modelica.Blocks.Sources.BooleanExpression nightCharge(y=mod(time/3600, 24)
         < 7 or mod(time/3600, 24) > 21)
    "Outputs true when battery should be charged"
      annotation (Placement(transformation(extent={{-90,128},{-70,148}})));
  Modelica_StateGraph2.Step holdChargeNight(
    nOut=1,
    nIn=1,
    initialStep=false,
    use_activePort=false) "Hold charge"
    annotation (Placement(transformation(extent={{-44,-8},{-36,0}})));
  Modelica_StateGraph2.Transition T7(
    waitTime=1,
      use_conditionPort=false,
    delayedTransition=false,
    loopCheck=false,
    condition=not nightCharge.y)
    annotation (Placement(transformation(extent={{-44,-24},{-36,-16}})));
  Modelica_StateGraph2.Transition T6(
    waitTime=1,
      use_conditionPort=false,
    delayedTransition=false,
    loopCheck=true,
    condition=SOC > 0.95)
    annotation (Placement(transformation(extent={{-44,12},{-36,20}})));
  Modelica_StateGraph2.Step nightReset(
    nOut=2,
    use_activePort=true,
    nIn=2,
    initialStep=true) "Night mode to reset charge"
    annotation (Placement(transformation(extent={{-32,26},{-24,34}})));
  Modelica_StateGraph2.Transition T5(
    waitTime=1,
      use_conditionPort=false,
    delayedTransition=false,
      loopCheck=true,
    condition=nightCharge.y)
    annotation (Placement(transformation(extent={{-14,80},{-6,88}})));
  Modelica_StateGraph2.Transition T8(
    waitTime=1,
      use_conditionPort=false,
    delayedTransition=false,
      loopCheck=true,
    condition=nightCharge.y)
    annotation (Placement(transformation(extent={{-54,52},{-46,60}})));
  Modelica_StateGraph2.Transition T10(
    waitTime=1,
      use_conditionPort=false,
    delayedTransition=false,
    loopCheck=false,
    condition=not nightCharge.y)
    annotation (Placement(transformation(extent={{-18,-24},{-10,-16}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=60, initType=Modelica.Blocks.Types.Init.InitialState)
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica_StateGraph2.Step holdChargeDay(
    nOut=1,
    nIn=1,
    initialStep=false,
    use_activePort=false) "Hold charge"
    annotation (Placement(transformation(extent={{-54,66},{-46,74}})));
  Modelica.Blocks.Math.MultiSwitch mulSwi(nu=2, expr={-9/13,+1}) "Multiswitch"
    annotation (Placement(transformation(extent={{30,50},{70,70}})));
equation

    connect(discharge.outPort[1], T2.inPort)  annotation (Line(
      points={{-29,103.4},{-29,90},{-50,90},{-50,88}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(nightReset.outPort[1], T6.inPort)    annotation (Line(
        points={{-29,25.4},{-29,22},{-40,22},{-40,20}},
        color={0,0,0},
        smooth=Smooth.None));
  connect(T6.outPort, holdChargeNight.inPort[1])
                                              annotation (Line(
        points={{-40,11},{-40,0}},
        color={0,0,0},
        smooth=Smooth.None));
  connect(holdChargeNight.outPort[1], T7.inPort)
                                              annotation (Line(
        points={{-40,-8.6},{-40,-16}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(discharge.outPort[2], T5.inPort) annotation (Line(
        points={{-27,103.4},{-27,90},{-10,90},{-10,88}},
        color={0,0,0},
        smooth=Smooth.None));
  connect(T7.outPort,discharge. inPort[1]) annotation (Line(
      points={{-40,-25},{-40,-30},{-62,-30},{-62,120},{-29,120},{-29,112}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(nightReset.outPort[2], T10.inPort) annotation (Line(
      points={{-27,25.4},{-26,25.4},{-26,22},{-14,22},{-14,-16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T10.outPort,discharge. inPort[2]) annotation (Line(
      points={{-14,-25},{-14,-30},{10,-30},{10,120},{-27,120},{-27,112}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(firstOrder.y, P) annotation (Line(
      points={{81,-70},{92,-70},{92,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(holdChargeDay.inPort[1], T2.outPort) annotation (Line(
      points={{-50,74},{-50,79}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(holdChargeDay.outPort[1], T8.inPort) annotation (Line(
      points={{-50,65.4},{-50,60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T8.outPort, nightReset.inPort[1]) annotation (Line(
      points={{-50,51},{-50,46},{-30,46},{-30,34},{-29,34}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T5.outPort, nightReset.inPort[2]) annotation (Line(
      points={{-10,79},{-10,46},{-26,46},{-26,34},{-27,34}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(discharge.activePort, mulSwi.u[1]) annotation (Line(
      points={{-23.28,108},{20,108},{20,61.5},{30,61.5}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(nightReset.activePort, mulSwi.u[2]) annotation (Line(
      points={{-23.28,30},{20,30},{20,58.5},{30,58.5}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(mulSwi.y, gain.u) annotation (Line(
      points={{71,60},{80,60},{80,-48},{-20,-48},{-20,-70},{-12,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, firstOrder.u) annotation (Line(
      points={{11,-70},{58,-70}},
      color={0,0,127},
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
