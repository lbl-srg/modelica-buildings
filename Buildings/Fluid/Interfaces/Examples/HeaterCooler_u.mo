within Buildings.Fluid.Interfaces.Examples;
model HeaterCooler_u
  "Model that tests a heat exchanger model with reverse flow"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Water;

  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea1(
    redeclare package Medium = Medium,
    Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Heater and cooler"                                  annotation (Placement(
        transformation(extent={{-14,90},{6,110}})));
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature"
    annotation (Placement(transformation(extent={{-200,94},{-180,114}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=4,
    p(displayUnit="Pa") = 101735,
    T=293.15)             annotation (Placement(transformation(extent={{-170,90},
            {-150,110}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_11(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_12(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
    annotation (Placement(transformation(extent={{-100,134},{-80,154}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(                       redeclare
      package Medium = Medium,
    use_p_in=true,
    T=288.15,
    nPorts=4)             annotation (Placement(transformation(extent={{-168,
            132},{-148,152}})));
    Modelica.Blocks.Sources.Constant POut(k=101325)
      annotation (Placement(transformation(extent={{-200,140},{-180,160}})));
    Modelica.Blocks.Sources.Ramp u(
    height=2,
    duration=3600,
    offset=-1,
    startTime=0) "Control signal"
                 annotation (Placement(transformation(extent={{-148,174},{-128,
            194}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea2(
    redeclare package Medium = Medium,
    Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Heater and cooler"                                  annotation (Placement(
        transformation(extent={{28,134},{48,154}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(
          extent={{-50,174},{-30,194}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea3(
    redeclare package Medium = Medium,
    Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Heater and cooler"                                   annotation (Placement(
        transformation(extent={{-14,-30},{6,-10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_2(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_3(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
    annotation (Placement(transformation(extent={{-100,22},{-80,42}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea4(
    redeclare package Medium = Medium, Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Heater and cooler"                                   annotation (Placement(
        transformation(extent={{20,22},{40,42}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_4(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5) annotation (Placement(transformation(
        origin={90,32},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Buildings.Fluid.MixingVolumes.MixingVolume mix1(
                                           redeclare package Medium = Medium, V=
       0.000001,
    nPorts=2,
    m_flow_nominal=0.5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                 annotation (Placement(transformation(extent={{62,-20},{82,0}})));
  Modelica.Blocks.Math.Add che1(k2=-1)
    annotation (Placement(transformation(extent={{160,160},{180,180}})));
  Modelica.Blocks.Math.Add che2(k2=-1)
    annotation (Placement(transformation(extent={{160,116},{180,136}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea5(
    redeclare package Medium = Medium,
    Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Heater and cooler"                                  annotation (Placement(
        transformation(extent={{-10,-190},{10,-170}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_1(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
    annotation (Placement(transformation(extent={{-100,-190},{-80,-170}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_5(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea6(
    redeclare package Medium =
        Medium, Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Heater and cooler"                                  annotation (Placement(
        transformation(extent={{0,-130},{20,-110}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea7(
    redeclare package Medium = Medium,
    Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Heater and cooler"                                  annotation (Placement(
        transformation(extent={{-10,-330},{10,-310}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_6(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
    annotation (Placement(transformation(extent={{-100,-330},{-80,-310}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_7(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
    annotation (Placement(transformation(extent={{-100,-270},{-80,-250}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea8(
    redeclare package Medium = Medium, Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Heater and cooler"                                  annotation (Placement(
        transformation(extent={{0,-270},{20,-250}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_8(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5) annotation (Placement(transformation(
        origin={90,-260},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Buildings.Fluid.MixingVolumes.MixingVolume mix2(
    redeclare package Medium = Medium,
    V=0.000001,
    nPorts=2,
    m_flow_nominal=0.5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                 annotation (Placement(transformation(extent={{60,-320},{80,
            -300}})));
  Modelica.Blocks.Math.Add che9(k2=-1)
    annotation (Placement(transformation(extent={{160,-400},{180,-380}})));
  Modelica.Blocks.Math.Add che10(k2=-1)
    annotation (Placement(transformation(extent={{160,-360},{180,-340}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem2a(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{-8,136},{8,152}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem2b(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{56,136},{72,152}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem1a(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{-48,92},{-32,108}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem1b(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{22,92},{38,108}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem3a(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{-48,-28},{-32,-12}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem3b(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem4a(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{-12,22},{8,42}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem4b(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{50,22},{70,42}})));
  Modelica.Blocks.Math.Add che3(k2=-1)
    annotation (Placement(transformation(extent={{162,0},{182,20}})));
  Modelica.Blocks.Math.Add che4(k2=-1)
    annotation (Placement(transformation(extent={{162,60},{182,80}})));
  Modelica.Blocks.Math.Add che5(k2=-1)
    annotation (Placement(transformation(extent={{160,-164},{180,-144}})));
  Modelica.Blocks.Math.Add che6(k2=-1)
    annotation (Placement(transformation(extent={{162,-102},{182,-82}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem6b(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem6a(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem5b(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{20,-190},{40,-170}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem5a(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  Modelica.Blocks.Math.Add che7(k2=-1)
    annotation (Placement(transformation(extent={{160,-284},{180,-264}})));
  Modelica.Blocks.Math.Add che8(k2=-1)
    annotation (Placement(transformation(extent={{160,-240},{180,-220}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem8b(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{36,-272},{60,-248}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem8a(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{-60,-270},{-40,-250}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem7b(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{20,-330},{40,-310}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      senTem7a(redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{-60,-330},{-40,-310}})));
equation
  connect(POut.y,sin_1. p_in) annotation (Line(
      points={{-179,150},{-170,150}},
      color={0,0,127}));
  connect(TDb.y,sou_1. T_in) annotation (Line(
      points={{-179,104},{-176,104},{-172,104}},
      color={0,0,127}));
  connect(u.y, hea1.u)
                      annotation (Line(points={{-127,184},{-70,184},{-70,160},{
          -28,160},{-28,106},{-16,106}},
                     color={0,0,127}));
  connect(gain.y, hea2.u) annotation (Line(points={{-29,184},{-20,184},{-20,160},
          {20,160},{20,150},{26,150}},
                      color={0,0,127}));
  connect(u.y, gain.u) annotation (Line(points={{-127,184},{-52,184}}, color={0,
          0,127}));
  connect(u.y, hea3.u)
                      annotation (Line(points={{-127,184},{-70,184},{-70,160},{
          -28,160},{-28,-14},{-16,-14}},
                    color={0,0,127}));
  connect(gain.y, hea4.u) annotation (Line(points={{-29,184},{-20,184},{-20,60},
          {12,60},{12,38},{18,38}},
                     color={0,0,127}));
  connect(u.y, hea6.u) annotation (Line(points={{-127,184},{-70,184},{-70,160},
          {-28,160},{-28,-114},{-2,-114}},
                      color={0,0,127}));
  connect(u.y, hea8.u) annotation (Line(points={{-127,184},{-70,184},{-70,160},
          {-28,160},{-28,-226},{-28,-254},{-2,-254}},
                       color={0,0,127}));
  connect(gain.y, hea5.u) annotation (Line(points={{-29,184},{-20,184},{-20,
          -174},{-12,-174}},              color={0,0,127}));
  connect(gain.y, hea7.u) annotation (Line(points={{-29,184},{-20,184},{-20,
          -314},{-14,-314},{-12,-314}},            color={0,0,127}));
  connect(sin_1.ports[1], res_12.port_a) annotation (Line(
      points={{-148,145},{-124,145},{-124,144},{-100,144}},
      color={0,127,255}));
  connect(sin_1.ports[2], res_3.port_a) annotation (Line(
      points={{-148,143},{-124,143},{-124,32},{-100,32}},
      color={0,127,255}));
  connect(sou_1.ports[1], res_11.port_a) annotation (Line(
      points={{-150,103},{-125,103},{-125,100},{-100,100}},
      color={0,127,255}));
  connect(sou_1.ports[2], res_2.port_a) annotation (Line(
      points={{-150,101},{-128,101},{-128,-20},{-100,-20}},
      color={0,127,255}));
  connect(sin_1.ports[3], res_1.port_a) annotation (Line(
      points={{-148,141},{-128,141},{-128,-180},{-100,-180}},
      color={0,127,255}));
  connect(sin_1.ports[4], res_6.port_a) annotation (Line(
      points={{-148,139},{-128,139},{-128,-320},{-100,-320}},
      color={0,127,255}));
  connect(sou_1.ports[3], res_5.port_a) annotation (Line(
      points={{-150,99},{-124,99},{-124,-120},{-100,-120}},
      color={0,127,255}));
  connect(sou_1.ports[4], res_7.port_a) annotation (Line(
      points={{-150,97},{-124,97},{-124,-260},{-100,-260}},
      color={0,127,255}));
  connect(mix1.ports[1], res_4.port_a) annotation (Line(
      points={{70,-20},{110,-20},{110,32},{100,32}},
      color={0,127,255}));
  connect(mix2.ports[1], res_8.port_a) annotation (Line(
      points={{68,-320},{106,-320},{106,-260},{100,-260}},
      color={0,127,255}));
  connect(senTem1a.T,che1. u1) annotation (Line(
      points={{-40,108.8},{-40,122},{140,122},{140,176},{158,176}},
      color={0,0,127}));
  connect(senTem2a.T,che1. u2) annotation (Line(
      points={{1.22125e-16,152.8},{0,152.8},{0,164},{158,164}},
      color={0,0,127}));
  connect(senTem1b.T,che2. u2) annotation (Line(
      points={{30,108.8},{30,120},{158,120}},
      color={0,0,127}));
  connect(senTem2b.T,che2. u1) annotation (Line(
      points={{64,152.8},{64,160},{120,160},{120,132},{158,132}},
      color={0,0,127}));
  connect(senTem4a.T,che4. u2) annotation (Line(
      points={{-2,43},{-2,64},{160,64}},
      color={0,0,127}));
  connect(senTem3a.T,che4. u1) annotation (Line(
      points={{-40,-11.2},{-40,10},{140,10},{140,76},{160,76}},
      color={0,0,127}));
  connect(senTem4b.T,che3. u1) annotation (Line(
      points={{60,43},{60,52},{148,52},{148,16},{160,16}},
      color={0,0,127}));
  connect(senTem3b.T,che3. u2) annotation (Line(
      points={{30,-9},{30,4},{160,4}},
      color={0,0,127}));
  connect(senTem6a.T,che6. u2) annotation (Line(
      points={{-50,-109},{-50,-98},{160,-98}},
      color={0,0,127}));
  connect(senTem5a.T,che6. u1) annotation (Line(
      points={{-50,-169},{-50,-150},{140,-150},{140,-86},{160,-86}},
      color={0,0,127}));
  connect(senTem6b.T,che5. u1) annotation (Line(
      points={{50,-109},{50,-102},{150,-102},{150,-148},{158,-148}},
      color={0,0,127}));
  connect(senTem5b.T,che5. u2) annotation (Line(
      points={{30,-169},{30,-160},{158,-160}},
      color={0,0,127}));
  connect(senTem8a.T,che8. u2) annotation (Line(
      points={{-50,-249},{-50,-236},{158,-236}},
      color={0,0,127}));
  connect(senTem7a.T,che8. u1) annotation (Line(
      points={{-50,-309},{-50,-292},{140,-292},{140,-224},{158,-224}},
      color={0,0,127}));
  connect(senTem8b.T,che7. u1) annotation (Line(
      points={{48,-246.8},{48,-240},{148,-240},{148,-268},{158,-268}},
      color={0,0,127}));
  connect(senTem7b.T,che7. u2) annotation (Line(
      points={{30,-309},{30,-280},{158,-280}},
      color={0,0,127}));
  connect(senTem3a.T,che10. u1) annotation (Line(
      points={{-40,-11.2},{-40,10},{128,10},{128,-344},{158,-344}},
      color={0,0,127}));
  connect(senTem7a.T,che10. u2) annotation (Line(
      points={{-50,-309},{-50,-292},{140,-292},{140,-356},{158,-356}},
      color={0,0,127}));
  connect(senTem2b.T,che9. u1) annotation (Line(
      points={{64,152.8},{64,160},{120,160},{120,-384},{158,-384}},
      color={0,0,127}));
  connect(senTem5b.T,che9. u2) annotation (Line(
      points={{30,-169},{30,-160},{112,-160},{112,-396},{158,-396}},
      color={0,0,127}));
  connect(res_12.port_b, senTem2a.port_a) annotation (Line(
      points={{-80,144},{-8,144}},
      color={0,127,255}));
  connect(senTem2a.port_b, hea2.port_a) annotation (Line(
      points={{8,144},{28,144}},
      color={0,127,255}));
  connect(hea2.port_b, senTem2b.port_a) annotation (Line(
      points={{48,144},{56,144}},
      color={0,127,255}));
  connect(senTem2b.port_b, senTem1b.port_b) annotation (Line(
      points={{72,144},{74,144},{74,100},{38,100}},
      color={0,127,255}));
  connect(hea1.port_b, senTem1b.port_a) annotation (Line(
      points={{6,100},{22,100}},
      color={0,127,255}));
  connect(res_11.port_b, senTem1a.port_a) annotation (Line(
      points={{-80,100},{-48,100}},
      color={0,127,255}));
  connect(senTem1a.port_b, hea1.port_a) annotation (Line(
      points={{-32,100},{-14,100}},
      color={0,127,255}));
  connect(res_2.port_b, senTem3a.port_a) annotation (Line(
      points={{-80,-20},{-48,-20}},
      color={0,127,255}));
  connect(senTem3a.port_b, hea3.port_a) annotation (Line(
      points={{-32,-20},{-14,-20}},
      color={0,127,255}));
  connect(hea3.port_b, senTem3b.port_a) annotation (Line(
      points={{6,-20},{20,-20}},
      color={0,127,255}));
  connect(senTem3b.port_b, mix1.ports[2]) annotation (Line(
      points={{40,-20},{74,-20}},
      color={0,127,255}));
  connect(hea4.port_b, senTem4b.port_a) annotation (Line(
      points={{40,32},{50,32}},
      color={0,127,255}));
  connect(res_3.port_b, senTem4a.port_a) annotation (Line(
      points={{-80,32},{-12,32}},
      color={0,127,255}));
  connect(senTem4a.port_b, hea4.port_a) annotation (Line(
      points={{8,32},{20,32}},
      color={0,127,255}));
  connect(senTem4b.port_b, res_4.port_b) annotation (Line(
      points={{70,32},{80,32}},
      color={0,127,255}));
  connect(res_5.port_b, senTem6a.port_a) annotation (Line(
      points={{-80,-120},{-60,-120}},
      color={0,127,255}));
  connect(senTem6a.port_b, hea6.port_a) annotation (Line(
      points={{-40,-120},{-5.55112e-16,-120}},
      color={0,127,255}));
  connect(hea6.port_b, senTem6b.port_a) annotation (Line(
      points={{20,-120},{40,-120}},
      color={0,127,255}));
  connect(senTem6b.port_b, senTem5b.port_b) annotation (Line(
      points={{60,-120},{70,-120},{70,-180},{40,-180}},
      color={0,127,255}));
  connect(senTem5b.port_a, hea5.port_b) annotation (Line(
      points={{20,-180},{10,-180}},
      color={0,127,255}));
  connect(hea5.port_a, senTem5a.port_b) annotation (Line(
      points={{-10,-180},{-40,-180}},
      color={0,127,255}));
  connect(senTem5a.port_a, res_1.port_b) annotation (Line(
      points={{-60,-180},{-80,-180}},
      color={0,127,255}));
  connect(res_7.port_b, senTem8a.port_a) annotation (Line(
      points={{-80,-260},{-60,-260}},
      color={0,127,255}));
  connect(senTem8a.port_b, hea8.port_a) annotation (Line(
      points={{-40,-260},{-5.55112e-16,-260}},
      color={0,127,255}));
  connect(hea8.port_b, senTem8b.port_a) annotation (Line(
      points={{20,-260},{36,-260}},
      color={0,127,255}));
  connect(senTem8b.port_b, res_8.port_b) annotation (Line(
      points={{60,-260},{80,-260}},
      color={0,127,255}));
  connect(mix2.ports[2], senTem7b.port_b) annotation (Line(
      points={{72,-320},{40,-320}},
      color={0,127,255}));
  connect(senTem7b.port_a, hea7.port_b) annotation (Line(
      points={{20,-320},{10,-320}},
      color={0,127,255}));
  connect(hea7.port_a, senTem7a.port_b) annotation (Line(
      points={{-10,-320},{-40,-320}},
      color={0,127,255}));
  connect(senTem7a.port_a, res_6.port_b) annotation (Line(
      points={{-60,-320},{-80,-320}},
      color={0,127,255}));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -400},{200,240}}), graphics={Text(
          extent={{32,232},{160,190}},
          lineColor={0,0,255},
          textString="Temperature check"),             Text(
          extent={{-188,-20},{-38,-84}},
          lineColor={0,0,255},
          textString="Same system as above, but with flow reversed")}),
experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Interfaces/Examples/HeaterCooler_u.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>Model that tests the basic class that is used for the heater models.
It adds and removes heat for forward and reverse flow.
The top and bottom models should give similar results,
although the sign of the temperature difference over the components
differ because of the reverse flow.
The model computes differences in results that are expected to be
close to each other after the initial transients decayed.
All temperature sensors are configured as steady-state sensors to avoid
differences in temperature due to the dynamic response of the sensor.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 2, 2016, by Michael Wetter:<br/>
Changed assertions to blocks that compute the difference,
and added the difference to the regression results.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/564\">issue 564</a>.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Changed initialization of mass dynamics to avoid overspecified system
of equations if the medium model is incompressible.
</li>
<li>
January 24, 2013, by Michael Wetter:<br/>
Increased parameter <code>startTime</code> of the assert block
and set initial conditions to
<code>Modelica.Fluid.Types.Dynamics.FixedInitial</code>.
</li>
<li>
July 11, 2011, by Michael Wetter:<br/>
Changed model to sensors with two fluid ports.
Moved model to <code>Buildings.Fluid.Interfaces.Examples</code>.
</li>
<li>
April 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeaterCooler_u;
