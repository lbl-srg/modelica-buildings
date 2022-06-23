within Buildings.Fluid.Storage.Ice.Examples;
model GlycolLoopIceTank
  "Example that tests the ice tank model for a simplified district cooling application"
  extends Modelica.Icons.Example;

  package MediumGlycol = Buildings.Media.Antifreeze.PropyleneGlycolWater (
    property_T=293.15, X_a=0.30) "Fluid medium";
  package MediumWater = Buildings.Media.Water "Fluid medium";
  package MediumAir = Buildings.Media.Air "Fluid medium";

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=6
    "Nominal mass flow rate of air through the chiller condenser coil";
  parameter Modelica.Units.SI.MassFlowRate mGly_flow_nominal=2
    "Nominal mass flow rate of glycol through the glycol circuit";

  parameter Buildings.Fluid.Storage.Ice.Data.Tank.Generic perIceTan(
    mIce_max=1/4*2846.35,
    coeCha={1.76953858E-04,0,0,0,0,0},
    dtCha=10,
    coeDisCha={5.54E-05,-1.45679E-04,9.28E-05,1.126122E-03,-1.1012E-03,3.00544E-04},
    dtDisCha=10) "Tank performance data" annotation (Placement(transformation(extent={{100,76},
            {120,96}})));

  Buildings.Fluid.Storage.Ice.Tank iceTanUnc1(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dp_nominal=10000,
    SOC_start=3/4,
    per=perIceTan) "Uncontrolled ice tank" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={6,-24})));

  Controls.OBC.CDL.Continuous.Sources.Constant chiGlyTSet(k=273.15 - 6.7)
    "Set point"
    annotation (Placement(transformation(extent={{76,44},{64,56}})));

  Chillers.ElectricEIR chiGly(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumGlycol,
    m1_flow_nominal=mCon_flow_nominal,
    m2_flow_nominal=mGly_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    per=perChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={52,-21})));

  MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    V=1,                                   nPorts=2)
                   "Heat exchanger" annotation (Placement(transformation(extent={{10,10},
            {-10,-10}},                                                                             rotation=90,origin={116,-11})));

  Actuators.Valves.TwoWayLinear val4(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={6,28})));

  Actuators.Valves.TwoWayLinear val5(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=dpValve_nominal,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve 5 for glycol loop" annotation (
      Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={26,10})));

  Actuators.Valves.TwoWayLinear val6(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=dpValve_nominal,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve 6 for glycol loop" annotation (
      Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={46,28})));

  Actuators.Valves.TwoWayLinear val7(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=dpValve_nominal,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve 7 for glycol loop" annotation (
      Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={106,28})));

  Controls.OBC.CDL.Continuous.Sources.Constant val4On(k=1)
    "Valve 4 on position"
    annotation (Placement(transformation(extent={{28,22},{16,34}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaVal5(realTrue=1, realFalse=
       0.1) "Valve 5 signal"
    annotation (Placement(transformation(extent={{-22,-82},{-10,-70}})));
  Controls.OBC.CDL.Continuous.Sources.Constant val6Off(k=0.1)
    "Valve 6 off position"
    annotation (Placement(transformation(extent={{74,22},{62,34}})));
  Controls.OBC.CDL.Continuous.Switch swiVal7 "Switch for valve 7"
    annotation (Placement(transformation(extent={{28,56},{40,68}})));
  Controls.OBC.CDL.Continuous.Sources.Constant val7Off(k=0.1)
    "Valve 7 off position"
    annotation (Placement(transformation(extent={{6,44},{18,56}})));
  Controls.OBC.CDL.Continuous.Sources.Constant val7On(k=1)
    "Valve 7 on position"
    annotation (Placement(transformation(extent={{6,80},{18,68}})));

  Movers.FlowControlled_m_flow pum1(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump 1" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={106,-52})));

  Movers.FlowControlled_m_flow pum5(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump 5" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={6,-46})));

  Movers.FlowControlled_m_flow pum6(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump 6" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={40,-52})));

  Controls.OBC.CDL.Conversions.BooleanToReal booToReaPum1(realTrue = mGly_flow_nominal, realFalse = mGly_flow_nominal/10) "Pump 1 signal"
    annotation (Placement(transformation(extent={{134,-76},{122,-64}})));
  Controls.OBC.CDL.Continuous.Sources.Constant pum5Flow(k=mGly_flow_nominal)
    "Pump 5 constant flow rate"
    annotation (Placement(transformation(extent={{-26,-52},{-14,-40}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaPum6(realTrue=
        mGly_flow_nominal, realFalse=mGly_flow_nominal/10) "Pump 6 signal"
    annotation (Placement(transformation(extent={{54,-82},{42,-70}})));

  Sensors.TemperatureTwoPort temSen4(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={6,-2})));

  Sensors.TemperatureTwoPort temSen5(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={46,8})));

  Sensors.TemperatureTwoPort temSen6(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={106,-32})));

  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "Root of the state graph"
    annotation (Placement(transformation(extent={{-98,76},{-84,90}})));
  Modelica.StateGraph.Alternative alternative
    "Split for alternative execution paths"
    annotation (Placement(transformation(extent={{-138,-50},{-52,14}})));
  Modelica.StateGraph.StepWithSignal chaIceTan(nIn=1, nOut=1)
    "Charge ice tank with glycol chiller"
    annotation (Placement(transformation(extent={{-100,-42},{-88,-30}})));
  Modelica.StateGraph.StepWithSignal disCooCall(nIn=1, nOut=1)
    "Cooling call from district"
    annotation (Placement(transformation(extent={{-100,4},{-88,-8}})));
  Modelica.StateGraph.InitialStep standby(nOut=1, nIn=1)
    "Initial Step with pump 5 on and valve 4 open"
    annotation (Placement(transformation(extent={{-152,-24},{-140,-12}})));
  Modelica.StateGraph.TransitionWithSignal T1 "Transition to turn on pump 6, glycol chiller, and open valve 5"
    annotation (Placement(transformation(extent={{-126,-46},{-106,-26}})));
  Modelica.StateGraph.TransitionWithSignal T2 "Transition to turn on pump 1 and open valve 7"
    annotation (Placement(transformation(extent={{-118,-12},{-98,8}})));
  Modelica.StateGraph.TransitionWithSignal T3 "Transition to turn off pump 1 and close valve 7"
    annotation (Placement(transformation(extent={{-90,-12},{-70,8}})));
  Modelica.StateGraph.TransitionWithSignal T4 "Transition to turn off pump 6, glycol chiller, and close valve 5"
    annotation (Placement(transformation(extent={{-82,-46},{-62,-26}})));

  Controls.OBC.CDL.Continuous.LessThreshold lesThrT4(t=TChaStop)
    "Threshold for ice tank outlet temperature"
    annotation (Placement(transformation(extent={{-14,2},{-26,14}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greThrT4(t=TChaStart)
    "Threshold for ice tank outlet temperature"
    annotation (Placement(transformation(extent={{-14,-16},{-26,-4}})));
  Controls.OBC.CDL.Continuous.LessThreshold lesThrT6(t=TDisStandby)
    "Threshold for district coil outlet temperature"
    annotation (Placement(transformation(extent={{132,-52},{144,-40}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greThrT6(t=TDisCooCall)
    "Threshold for district coil outlet temperature"
    annotation (Placement(transformation(extent={{132,-34},{144,-22}})));

equation
  connect(pum5.port_b, iceTanUnc.port_a)
    annotation (Line(points={{6,-40},{6,-34}}, color={0,127,255}));
  connect(iceTanUnc.port_b, temSen4.port_a)
    annotation (Line(points={{6,-14},{6,-8}}, color={0,127,255}));
  connect(temSen4.port_b, val4.port_a)
    annotation (Line(points={{6,4},{6,24}},        color={0,127,255}));
  connect(val4.port_b, val6.port_b) annotation (Line(points={{6,32},{6,38},{46,38},
          {46,32}},           color={0,127,255}));
  connect(val7.port_a, val6.port_b) annotation (Line(points={{106,32},{106,38},{
          46,38},{46,32}},
                         color={0,127,255}));
  connect(temSen6.port_b, pum1.port_a)
    annotation (Line(points={{106,-38},{106,-46}},
                                               color={0,127,255}));
  connect(pum6.port_b, chiGly.port_a2)
    annotation (Line(points={{40,-46},{40,-38},{46,-38},{46,-31}},
                                                   color={0,127,255}));
  connect(chiGly.port_b2, temSen5.port_a)
    annotation (Line(points={{46,-11},{46,2}},  color={0,127,255}));
  connect(temSen5.port_b, val5.port_a) annotation (Line(points={{46,14},{46,18},
          {26,18},{26,14}},      color={0,127,255}));
  connect(val6.port_a, temSen5.port_b)
    annotation (Line(points={{46,24},{46,14}},   color={0,127,255}));
  connect(pum1.port_b, pum6.port_a) annotation (Line(points={{106,-58},{106,-64},
          {40,-64},{40,-58}},  color={0,127,255}));
  connect(pum5.port_a, val5.port_b) annotation (Line(points={{6,-52},{6,-56},{26,
          -56},{26,6}},             color={0,127,255}));
  connect(pum5.port_a, pum6.port_a) annotation (Line(points={{6,-52},{6,-64},{40,
          -64},{40,-58}},            color={0,127,255}));
  connect(val6.port_b, pum6.port_a) annotation (Line(points={{46,32},{46,38},{86,
          38},{86,-64},{40,-64},{40,-58}},         color={0,127,255}));
  connect(souAir.ports[1], chiGly.port_a1)
    annotation (Line(points={{64,8},{58,8},{58,-11}}, color={0,127,255}));
  connect(chiGly.port_b1, sinAir.ports[1])
    annotation (Line(points={{58,-31},{58,-43}}, color={0,127,255}));
  connect(preSouGly.ports[1], pum6.port_a) annotation (Line(points={{82,-12},{86,
          -12},{86,-64},{40,-64},{40,-58}}, color={0,127,255}));
  connect(chiGly.TSet, chiGlyTSet.y) annotation (Line(points={{49,-9},{49,0},{56,
          0},{56,50},{62.8,50}},        color={0,0,127}));
  connect(val7.port_b, vol.ports[1])
    annotation (Line(points={{106,24},{106,-9}},
                                              color={0,127,255}));
  connect(vol.ports[2], temSen6.port_a)
    annotation (Line(points={{106,-13},{106,-26}},
                                               color={0,127,255}));
  connect(fixHeaFloDis.port, vol.heatPort)
    annotation (Line(points={{122,8},{116,8},{116,-1}}, color={191,0,0}));
  connect(booToReaPum6.y, pum6.m_flow_in) annotation (Line(points={{40.8,-76},{30,
          -76},{30,-52},{32.8,-52}}, color={0,0,127}));
  connect(chiGly.on, booToReaPum6.u) annotation (Line(points={{55,-9},{55,-4},{68,
          -4},{68,-76},{55.2,-76}}, color={255,0,255}));
  connect(lesThrT4.u, temSen4.T) annotation (Line(points={{-12.8,8},{-6,8},{-6,-2},
          {-0.6,-2}}, color={0,0,127}));
  connect(greThrT4.u, temSen4.T) annotation (Line(points={{-12.8,-10},{-6,-10},{
          -6,-2},{-0.6,-2}}, color={0,0,127}));
  connect(temSen6.T, greThrT6.u) annotation (Line(points={{112.6,-32},{126,-32},
          {126,-28},{130.8,-28}}, color={0,0,127}));
  connect(temSen6.T, lesThrT6.u) annotation (Line(points={{112.6,-32},{126,-32},
          {126,-46},{130.8,-46}}, color={0,0,127}));
  connect(chaIceTan.active, booToReaPum6.u) annotation (Line(points={{-94,-42.6},
          {-94,-86},{68,-86},{68,-76},{55.2,-76}}, color={255,0,255}));
  connect(lesThrT4.y, T4.condition) annotation (Line(points={{-27.2,8},{-42,8},{
          -42,-52},{-72,-52},{-72,-48}}, color={255,0,255}));
  connect(greThrT4.y, T1.condition) annotation (Line(points={{-27.2,-10},{-38,-10},
          {-38,-56},{-116,-56},{-116,-48}}, color={255,0,255}));
  connect(val4On.y, val4.y)
    annotation (Line(points={{14.8,28},{10.8,28}}, color={0,0,127}));
  connect(val6Off.y, val6.y)
    annotation (Line(points={{60.8,28},{50.8,28}}, color={0,0,127}));
  connect(greThrT6.y, T2.condition) annotation (Line(points={{145.2,-28},{156,-28},
          {156,-100},{-108,-100},{-108,-14}}, color={255,0,255}));
  connect(lesThrT6.y, T3.condition) annotation (Line(points={{145.2,-46},{150,-46},
          {150,-94},{-80,-94},{-80,-14}}, color={255,0,255}));
  connect(pum5Flow.y, pum5.m_flow_in)
    annotation (Line(points={{-12.8,-46},{-1.2,-46}}, color={0,0,127}));
  connect(booToReaPum1.y, pum1.m_flow_in) annotation (Line(points={{120.8,-70},{
          118,-70},{118,-52},{113.2,-52}}, color={0,0,127}));
  connect(booToReaPum1.u, swiVal7.u2) annotation (Line(points={{135.2,-70},{138,
          -70},{138,-82},{92,-82},{92,86},{-4,86},{-4,62},{26.8,62}}, color={255,
          0,255}));
  connect(val7Off.y, swiVal7.u3) annotation (Line(points={{19.2,50},{24,50},{24,
          57.2},{26.8,57.2}}, color={0,0,127}));
  connect(val7On.y, swiVal7.u1) annotation (Line(points={{19.2,74},{24,74},{24,66.8},
          {26.8,66.8}}, color={0,0,127}));
  connect(disCooCall.active, swiVal7.u2) annotation (Line(points={{-94,4.6},{-94,
          62},{26.8,62}}, color={255,0,255}));
  connect(T2.outPort, disCooCall.inPort[1])
    annotation (Line(points={{-106.5,-2},{-100.6,-2}}, color={0,0,0}));
  connect(disCooCall.outPort[1], T3.inPort)
    annotation (Line(points={{-87.7,-2},{-84,-2}}, color={0,0,0}));
  connect(standby.outPort[1], alternative.inPort) annotation (Line(points={{-139.7,
          -18},{-140,-18},{-140,-18},{-139.29,-18}}, color={0,0,0}));
  connect(T1.outPort,chaIceTan. inPort[1])
    annotation (Line(points={{-114.5,-36},{-100.6,-36}}, color={0,0,0}));
  connect(chaIceTan.outPort[1], T4.inPort)
    annotation (Line(points={{-87.7,-36},{-76,-36}}, color={0,0,0}));
  connect(alternative.outPort, standby.inPort[1]) annotation (Line(points={{-51.14,
          -18},{-46,-18},{-46,30},{-160,30},{-160,-18},{-152.6,-18}}, color={0,0,
          0}));
  connect(alternative.split[1], T1.inPort) annotation (Line(points={{-128.97,-18},
          {-126,-18},{-126,-36},{-120,-36}}, color={0,0,0}));
  connect(T4.outPort, alternative.join[1]) annotation (Line(points={{-70.5,-36},
          {-64,-36},{-64,-18},{-61.03,-18}}, color={0,0,0}));
  connect(alternative.split[2], T2.inPort) annotation (Line(points={{-128.97,-18},
          {-126,-18},{-126,-2},{-112,-2}}, color={0,0,0}));
  connect(T3.outPort, alternative.join[2]) annotation (Line(points={{-78.5,-2},{
          -64,-2},{-64,-18},{-61.03,-18}}, color={0,0,0}));
  connect(chaIceTan.active, booToReaVal5.u) annotation (Line(points={{-94,-42.6},
          {-94,-86},{-34,-86},{-34,-76},{-23.2,-76}}, color={255,0,255}));
  connect(disCooLoad.y, fixHeaFloDis.Q_flow)
    annotation (Line(points={{147.4,8},{142,8}}, color={0,0,127}));
  connect(swiVal7.y, val7.y) annotation (Line(points={{41.2,62},{100,62},{100,28},
          {101.2,28}}, color={0,0,127}));
  connect(booToReaVal5.y, val5.y) annotation (Line(points={{-8.8,-76},{20,-76},{
          20,10},{21.2,10}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=259200,
      Interval=1,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Examples/Tank.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to verify the ice tank model <a href=\"Buildings.Fluid.Storage.Ice\">Buildings.Fluid.Storage.Ice</a> through its implementation in a simplified district cooling system.
</p>
</p>
<p align=\"center\">
<img alt=\"image of ice system\" width=\"750\" src=\"modelica://Buildings/Resources/Images/Fluid/Storage/IceSystem.png\"/>
</p>
<p>
</html>", revisions="<html>
<ul>
<li>
March 1, 2022, by Dre Helmns:<br/>
Implementation of ice tank in a simplified district cooling system.<br/>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-100},{160,100}})),
    Icon(coordinateSystem(extent={{-160,-100},{160,100}})));
end GlycolLoopIceTank;
