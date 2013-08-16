within Districts.BuildingLoads.Examples.BaseClasses;
model BatteryControl_V
  "Battery control that reduces the power fed back to the grid"
 extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter Modelica.SIunits.Power PMax "Maximum power during discharge";
  parameter Modelica.SIunits.Voltage VDis "Voltage of the distribution grid";

  Modelica.Blocks.Interfaces.RealInput SOC(final unit="1") "State of charge" annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput VMea(final unit="V") "Measured voltage"      annotation (
      Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
    "Powerflow of battery"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
        rotation=0)));

  Modelica_StateGraph2.Step voltageControl(
    nOut=3,
    use_activePort=true,
    nIn=4,
    initialStep=true) "Drain or charge battery to control voltage"
    annotation (Placement(transformation(extent={{16,90},{24,98}})));

    Modelica.Blocks.Sources.RealExpression VCon(
      y=if voltageControl.activePort
         then
         (Districts.Utilities.Math.Functions.spliceFunction(
            pos=0, neg=-1, x=VNor.y-0.925, deltax=0.025) +
         Districts.Utilities.Math.Functions.spliceFunction(
            pos=1, neg=0, x=VNor.y-1.075, deltax=0.025))
          else 0) "Voltage control"
      annotation (Placement(transformation(extent={{-52,-72},{-32,-52}})));
    Modelica.Blocks.Math.Gain gain(k=PMax)
      annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
    Modelica.Blocks.Sources.BooleanExpression isNight(y=mod(time/3600, 24) < 7
         or mod(time/3600, 24) > 20) "Outputs true during night"
      annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
  Modelica_StateGraph2.Step holdCharge(
    nOut=1,
    use_activePort=true,
    nIn=1,
    initialStep=false) "Hold charge"
    annotation (Placement(transformation(extent={{4,4},{12,12}})));
  Modelica_StateGraph2.Transition T7(
    waitTime=1,
      use_conditionPort=false,
    delayedTransition=false,
      loopCheck=true,
    condition=not isNight.y)
    annotation (Placement(transformation(extent={{4,-12},{12,-4}})));
  Modelica_StateGraph2.Transition T6(
    waitTime=1,
      use_conditionPort=false,
    delayedTransition=false,
    loopCheck=true,
    condition=SOC > 0.45 and SOC < 0.55)
    annotation (Placement(transformation(extent={{4,24},{12,32}})));
  Modelica_StateGraph2.Step nightCharge(
    nOut=2,
    use_activePort=true,
    nIn=1,
    initialStep=false) "Charge battery"
    annotation (Placement(transformation(extent={{16,38},{24,46}})));
  Modelica_StateGraph2.Transition T5(
    waitTime=1,
      use_conditionPort=false,
    condition=isNight.y,
    delayedTransition=false,
    loopCheck=false)
    annotation (Placement(transformation(extent={{16,54},{24,62}})));

    Modelica.Blocks.Math.Gain VNor(k=1/VDis) "Gain to normalize control input"
      annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(       initType=Modelica.Blocks.Types.Init.InitialState, T=60)
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
    Modelica.Blocks.Sources.RealExpression nigCha(y=if nightCharge.activePort
         then 0.5 - SOC else 0) "Night charge/discharge signal"
      annotation (Placement(transformation(extent={{-52,-88},{-32,-68}})));
  Modelica_StateGraph2.Transition T1(
    waitTime=1,
      use_conditionPort=false,
    delayedTransition=false,
    condition=SOC > 0.95,
    loopCheck=false)
    annotation (Placement(transformation(extent={{-24,56},{-16,64}})));
  Modelica_StateGraph2.Step drain(
    nOut=1,
    initialStep=false,
    use_activePort=true,
    nIn=1) "Drain battery"
    annotation (Placement(transformation(extent={{-24,136},{-16,144}})));
  Modelica_StateGraph2.Transition T2(
    waitTime=1,
      use_conditionPort=false,
    delayedTransition=false,
      loopCheck=true,
    condition=SOC < 0.8)
    annotation (Placement(transformation(extent={{-24,116},{-16,124}})));
  Modelica_StateGraph2.Transition T3(
    waitTime=1,
      use_conditionPort=false,
    delayedTransition=false,
    condition=SOC < 0.05,
    loopCheck=false)
    annotation (Placement(transformation(extent={{64,56},{72,64}})));
  Modelica_StateGraph2.Transition T4(
    waitTime=1,
      use_conditionPort=false,
    delayedTransition=false,
      loopCheck=true,
    condition=SOC > 0.2)
    annotation (Placement(transformation(extent={{64,116},{72,124}})));
  Modelica_StateGraph2.Step charge(
    nOut=1,
    initialStep=false,
    use_activePort=true,
    nIn=1) "charge battery"
    annotation (Placement(transformation(extent={{64,136},{72,144}})));
    Modelica.Blocks.Sources.RealExpression draCon(y=if drain.activePort then -1
         else 0) "Drain battery"
      annotation (Placement(transformation(extent={{-52,-54},{-32,-34}})));
    Modelica.Blocks.Sources.RealExpression chaCon(y=if charge.activePort then 1
         else 0) "Charge battery"
      annotation (Placement(transformation(extent={{-52,-36},{-32,-16}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=4)
    annotation (Placement(transformation(extent={{-6,-76},{6,-64}})));
  Modelica_StateGraph2.Transition T8(
    waitTime=1,
      use_conditionPort=false,
    delayedTransition=false,
      loopCheck=true,
    condition=not isNight.y)
    annotation (Placement(transformation(extent={{32,22},{40,30}})));
equation
    connect(T5.outPort, nightCharge.inPort[1]) annotation (Line(
        points={{20,53},{20,46}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(nightCharge.outPort[1], T6.inPort) annotation (Line(
        points={{19,37.4},{19,32},{8,32}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(T6.outPort, holdCharge.inPort[1]) annotation (Line(
        points={{8,23},{8,12}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(holdCharge.outPort[1], T7.inPort) annotation (Line(
        points={{8,3.4},{8,-4}},
        color={0,0,0},
        smooth=Smooth.None));
  connect(VMea, VNor.u)
                      annotation (Line(
      points={{-120,-60},{-82,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, firstOrder.u) annotation (Line(
      points={{41,-70},{58,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, P) annotation (Line(
      points={{81,-70},{90,-70},{90,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(voltageControl.outPort[1], T1.inPort) annotation (Line(
      points={{18.6667,89.4},{18.6667,80},{-20,80},{-20,64}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T1.outPort, drain.inPort[1]) annotation (Line(
      points={{-20,55},{-20,40},{-40,40},{-40,152},{-20,152},{-20,144}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(drain.outPort[1], T2.inPort) annotation (Line(
      points={{-20,135.4},{-20,124}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T2.outPort, voltageControl.inPort[1]) annotation (Line(
      points={{-20,115},{-20,110},{20,110},{20,104},{18.5,104},{18.5,98}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(charge.outPort[1], T4.inPort) annotation (Line(
      points={{68,135.4},{68,124}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T4.outPort, voltageControl.inPort[2]) annotation (Line(
      points={{68,115},{68,110},{19.5,110},{19.5,98}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T3.outPort, charge.inPort[1]) annotation (Line(
      points={{68,55},{68,40},{88,40},{88,152},{68,152},{68,144}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(voltageControl.outPort[2], T5.inPort) annotation (Line(
      points={{20,89.4},{20,62}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(voltageControl.outPort[3], T3.inPort) annotation (Line(
      points={{21.3333,89.4},{22,89.4},{22,80},{68,80},{68,64}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T7.outPort, voltageControl.inPort[3]) annotation (Line(
      points={{8,-13},{8,-20},{56,-20},{56,108},{20.5,108},{20.5,98}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(chaCon.y, multiSum.u[1]) annotation (Line(
      points={{-31,-26},{-20,-26},{-20,-66.85},{-6,-66.85}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(draCon.y, multiSum.u[2]) annotation (Line(
      points={{-31,-44},{-20,-44},{-20,-68.95},{-6,-68.95}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(VCon.y, multiSum.u[3]) annotation (Line(
      points={{-31,-62},{-20,-62},{-20,-71.05},{-6,-71.05}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(nigCha.y, multiSum.u[4]) annotation (Line(
      points={{-31,-78},{-18,-78},{-18,-73.15},{-6,-73.15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.y, gain.u) annotation (Line(
      points={{7.02,-70},{18,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(nightCharge.outPort[2], T8.inPort) annotation (Line(
      points={{21,37.4},{21,36},{21,32},{36,32},{36,32},{36,30},{36,30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T8.outPort, voltageControl.inPort[4]) annotation (Line(
      points={{36,21},{36,20},{50,20},{50,106},{21.5,106},{21.5,98}},
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
          textString="V")}));
end BatteryControl_V;
