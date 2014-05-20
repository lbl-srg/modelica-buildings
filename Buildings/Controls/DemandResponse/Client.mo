within Buildings.Controls.DemandResponse;
model Client "Demand response client"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.Time tCycle = 24*3600 "Cycle time";
  parameter Modelica.SIunits.Time tSample=3600 "Sample period";
  final parameter Integer nSam = integer(floor((tCycle+1E-4)/tSample))
    "Number of samples in a day";

   Modelica.Blocks.Interfaces.RealInput PCon(unit="W")
    "Consumed electrical power"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.BooleanInput shed
    "Signal, true if load needs to be shed"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealOutput PPre(unit="W")
    "Predicted power consumption for current hour"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.StateGraph.InitialStep initialStep
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.StateGraph.Transition transition
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  DemandResponse.BaseClasses.BaselineComputation comBasLin(       nSam=nSam, nIn=3)
    "Compute the baseline"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.StateGraph.Transition t1 "State transition" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={70,20})));
  BaseClasses.NormalOperation nor(nOut=2) "Normal operation"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Modelica.StateGraph.TransitionWithSignal
                                 t2(enableTimer=false) "State transition"
                       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={10,20})));
  Modelica.StateGraph.TransitionWithSignal t3 "State transition"
                       annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-2,-30})));
  BaseClasses.ShedOperation she "Operation during load shedding"
    annotation (Placement(transformation(extent={{-10,-40},{-30,-20}})));
  Modelica.StateGraph.TransitionWithSignal
                                 t4(enableTimer=false) "State transition"
                       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-40,10})));
  Modelica.Blocks.Sources.SampleTrigger tri(period=tSample) "Sample trigger"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
equation
  connect(initialStep.outPort[1], transition.inPort) annotation (Line(
      points={{-59.5,70},{-34,70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(transition.outPort, comBasLin.inPort[1]) annotation (Line(
      points={{-28.5,70},{6,70},{6,50.5},{19,50.5},{19,50.6667}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t1.inPort, comBasLin.outPort[1]) annotation (Line(
      points={{70,24},{70,50},{40.5,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t1.outPort,nor. inPort[1]) annotation (Line(
      points={{70,18.5},{70,-30},{41,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(comBasLin.PCon, PCon) annotation (Line(
      points={{18,42},{-94,42},{-94,1.11022e-15},{-120,1.11022e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(comBasLin.PPre,nor. PCon) annotation (Line(
      points={{41,42},{50,42},{50,-38},{42,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(t2.outPort, comBasLin.inPort[2]) annotation (Line(
      points={{10,21.5},{10,50},{19,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t3.outPort, she.inPort[1]) annotation (Line(
      points={{-3.5,-30},{-9,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t4.inPort, she.outPort[1]) annotation (Line(
      points={{-40,6},{-40,-30},{-30.5,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t4.outPort, comBasLin.inPort[3]) annotation (Line(
      points={{-40,11.5},{-40,50},{-20,50},{-20,49.3333},{19,49.3333}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(t4.condition, tri.y) annotation (Line(
      points={{-52,10},{-66,10},{-66,20},{-69,20}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(t2.condition, tri.y) annotation (Line(
      points={{-2,20},{-69,20}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(nor.PPre, she.PCon) annotation (Line(
      points={{19,-38},{-8,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.y, PPre) annotation (Line(
      points={{61,-70},{90,-70},{90,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(nor.active, switch1.u2) annotation (Line(
      points={{30,-41},{30,-70},{38,-70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(nor.outPort[1], t2.inPort) annotation (Line(
      points={{19.5,-29.75},{10,-29.75},{10,16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(nor.outPort[2], t3.inPort) annotation (Line(
      points={{19.5,-30.25},{12,-30.25},{12,-30},{2,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(shed, t3.condition) annotation (Line(
      points={{-120,-60},{-80,-60},{-80,-10},{-2,-10},{-2,-18}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(switch1.u1, she.PCon) annotation (Line(
      points={{38,-62},{10,-62},{10,-38},{-8,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.u3, she.PPre) annotation (Line(
      points={{38,-78},{-40,-78},{-40,-38},{-31,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (                                 Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
      experiment(StopTime=7200),
    Icon(graphics={                      Text(
          extent={{-70,54},{74,-64}},
          lineColor={0,0,255},
          textString="DR")}));
end Client;
