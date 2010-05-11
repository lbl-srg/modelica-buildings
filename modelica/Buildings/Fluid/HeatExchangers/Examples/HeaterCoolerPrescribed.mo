within Buildings.Fluid.HeatExchangers.Examples;
model HeaterCoolerPrescribed
  import Buildings;

 package Medium = Buildings.Media.ConstantPropertyLiquidWater;
 //package Medium = Modelica.Media.Air.MoistAir;
 //package Medium = Modelica.Media.Air.SimpleAir;
  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hea1(
                                                         redeclare package
      Medium =
        Medium, Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200) "Heater and cooler"                  annotation (Placement(
        transformation(extent={{-54,86},{-34,106}}, rotation=0)));
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature"
    annotation (Placement(transformation(extent={{-200,94},{-180,114}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=4,
    p(displayUnit="Pa") = 101735,
    T=293.15)             annotation (Placement(transformation(extent={{-170,90},
            {-150,110}}, rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res_11(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
             annotation (Placement(transformation(extent={{-100,86},{-80,106}},
          rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res_12(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
             annotation (Placement(transformation(extent={{-100,134},{-80,154}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_1(                       redeclare
      package Medium = Medium,
    use_p_in=true,
    T=288.15,
    nPorts=4)             annotation (Placement(transformation(extent={{-168,
            132},{-148,152}}, rotation=0)));
    Modelica.Blocks.Sources.Constant POut(k=101325)
      annotation (Placement(transformation(extent={{-200,140},{-180,160}},
          rotation=0)));
    Modelica.Blocks.Sources.Ramp u(
    height=2,
    duration=1,
    offset=-1,
    startTime=0) "Control signal"
                 annotation (Placement(transformation(extent={{-148,174},{-128,
            194}}, rotation=0)));
  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hea2(
                                                 redeclare package Medium =
        Medium, Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200) "Heater and cooler"                  annotation (Placement(
        transformation(extent={{-12,134},{8,154}}, rotation=0)));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(
          extent={{-50,174},{-30,194}}, rotation=0)));
  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hea3(
                                                         redeclare package
      Medium =
        Medium, Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200) "Heater and cooler"                   annotation (Placement(
        transformation(extent={{-54,-28},{-34,-8}},rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res_2(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
             annotation (Placement(transformation(extent={{-100,-28},{-80,-8}},
          rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res_3(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
             annotation (Placement(transformation(extent={{-100,14},{-80,34}},
          rotation=0)));
  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hea4(
                                                 redeclare package Medium =
        Medium, Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200) "Heater and cooler"                   annotation (Placement(
        transformation(extent={{-12,14},{8,34}}, rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res_4(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
             annotation (Placement(transformation(
        origin={20,0},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Buildings.Fluid.MixingVolumes.MixingVolume mix1(
                                           redeclare package Medium = Medium, V=
       0.000001,
    nPorts=2)    annotation (Placement(transformation(extent={{-18,-20},{2,0}},
          rotation=0)));
  Buildings.Utilities.Diagnostics.AssertEquality ass1(startTime=0.2, threShold=
        0.05)
    annotation (Placement(transformation(extent={{160,160},{180,180}}, rotation=
           0)));
  Buildings.Utilities.Diagnostics.AssertEquality ass2(startTime=0.2, threShold=
        0.05)
    annotation (Placement(transformation(extent={{160,120},{180,140}}, rotation=
           0)));
  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hea5(
                                                         redeclare package
      Medium =
        Medium, Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200) "Heater and cooler"                  annotation (Placement(
        transformation(extent={{-54,-190},{-34,-170}},rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res_1(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
             annotation (Placement(transformation(extent={{-100,-190},{-80,-170}},
          rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res_5(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
             annotation (Placement(transformation(extent={{-100,-130},{-80,-110}},
          rotation=0)));
  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hea6(
                                                 redeclare package Medium =
        Medium, Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200) "Heater and cooler"                  annotation (Placement(
        transformation(extent={{-12,-130},{8,-110}},
                                                   rotation=0)));
  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hea7(
                                                         redeclare package
      Medium =
        Medium, Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200) "Heater and cooler"                  annotation (Placement(
        transformation(extent={{-54,-332},{-34,-312}}, rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res_6(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
             annotation (Placement(transformation(extent={{-100,-332},{-80,-312}},
          rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res_7(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
             annotation (Placement(transformation(extent={{-100,-270},{-80,-250}},
          rotation=0)));
  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hea8(
                                                 redeclare package Medium =
        Medium, Q_flow_nominal=5000,
    m_flow_nominal=0.5,
    dp_nominal=200) "Heater and cooler"                  annotation (Placement(
        transformation(extent={{-12,-270},{8,-250}}, rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res_8(
    redeclare package Medium = Medium,
    dp_nominal=5,
    m_flow_nominal=0.5)
             annotation (Placement(transformation(
        origin={20,-304},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Buildings.Fluid.MixingVolumes.MixingVolume mix2(
                                           redeclare package Medium = Medium, V=
       0.000001,
    nPorts=2)    annotation (Placement(transformation(extent={{-20,-324},{0,
            -304}}, rotation=0)));
  Buildings.Utilities.Diagnostics.AssertEquality ass9(                startTime=
        0.3, threShold=0.05)
    annotation (Placement(transformation(extent={{160,-400},{180,-380}},
          rotation=0)));
  Buildings.Utilities.Diagnostics.AssertEquality ass10(                startTime=
        0.3, threShold=0.05)
    annotation (Placement(transformation(extent={{160,-360},{180,-340}},
          rotation=0)));
  inner Modelica.Fluid.System system(m_flow_start=0)
    annotation (Placement(transformation(extent={{-180,-380},{-160,-360}})));
  Buildings.Fluid.Sensors.Temperature senTem2a(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-20,160},{-4,174}})));
  Buildings.Fluid.Sensors.Temperature senTem2b(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{0,174},{16,188}})));
  Buildings.Fluid.Sensors.Temperature senTem1a(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-60,114},{-44,128}})));
  Buildings.Fluid.Sensors.Temperature senTem1b(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,122},{-24,136}})));
  Buildings.Fluid.Sensors.Temperature senTem3a(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-60,-6},{-44,8}})));
  Buildings.Fluid.Sensors.Temperature senTem3b(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,2},{-24,16}})));
  Buildings.Fluid.Sensors.Temperature senTem4a(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-20,40},{-4,54}})));
  Buildings.Fluid.Sensors.Temperature senTem4b(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{0,60},{16,74}})));
  Buildings.Utilities.Diagnostics.AssertEquality ass3(startTime=0.2, threShold=
        0.05)
    annotation (Placement(transformation(extent={{160,0},{180,20}},    rotation=
           0)));
  Buildings.Utilities.Diagnostics.AssertEquality ass4(startTime=0.2, threShold=
        0.05)
    annotation (Placement(transformation(extent={{160,40},{180,60}},   rotation=
           0)));
  Buildings.Utilities.Diagnostics.AssertEquality ass5(startTime=0.2, threShold=
        0.05)
    annotation (Placement(transformation(extent={{160,-140},{180,-120}},
                                                                       rotation=
           0)));
  Buildings.Utilities.Diagnostics.AssertEquality ass6(startTime=0.2, threShold=
        0.05)
    annotation (Placement(transformation(extent={{160,-100},{180,-80}},rotation=
           0)));
  Buildings.Fluid.Sensors.Temperature senTem6b(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{0,-80},{16,-66}})));
  Buildings.Fluid.Sensors.Temperature senTem6a(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-20,-100},{-4,-86}})));
  Buildings.Fluid.Sensors.Temperature senTem5b(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,-154},{-24,-140}})));
  Buildings.Fluid.Sensors.Temperature senTem5a(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-60,-162},{-44,-148}})));
  Buildings.Utilities.Diagnostics.AssertEquality ass7(startTime=0.2, threShold=
        0.05)
    annotation (Placement(transformation(extent={{160,-280},{180,-260}},
                                                                       rotation=
           0)));
  Buildings.Utilities.Diagnostics.AssertEquality ass8(startTime=0.2, threShold=
        0.05)
    annotation (Placement(transformation(extent={{160,-240},{180,-220}},
                                                                       rotation=
           0)));
  Buildings.Fluid.Sensors.Temperature senTem8b(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{0,-220},{16,-206}})));
  Buildings.Fluid.Sensors.Temperature senTem8a(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-20,-240},{-4,-226}})));
  Buildings.Fluid.Sensors.Temperature senTem7b(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,-294},{-24,-280}})));
  Buildings.Fluid.Sensors.Temperature senTem7a(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-60,-302},{-44,-288}})));
equation
  connect(POut.y,sin_1. p_in) annotation (Line(
      points={{-179,150},{-170,150}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(TDb.y,sou_1. T_in) annotation (Line(
      points={{-179,104},{-176,104},{-172,104}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(res_11.port_b, hea1.port_a)
                                     annotation (Line(points={{-80,96},{-68,96},
          {-54,96}},
                 color={0,127,255}));
  connect(u.y, hea1.u)
                      annotation (Line(points={{-127,184},{-64,184},{-64,102},{
          -56,102}}, color={0,0,127}));
  connect(gain.y, hea2.u) annotation (Line(points={{-29,184},{-22,184},{-22,150},
          {-14,150}}, color={0,0,127}));
  connect(u.y, gain.u) annotation (Line(points={{-127,184},{-52,184}}, color={0,
          0,127}));
  connect(res_12.port_b, hea2.port_a) annotation (Line(points={{-80,144},{-12,
          144}}, color={0,127,255}));
  connect(res_2.port_b, hea3.port_a) annotation (Line(points={{-80,-18},{-54,
          -18}},
        color={0,127,255}));
  connect(u.y, hea3.u)
                      annotation (Line(points={{-127,184},{-64,184},{-64,-12},{
          -56,-12}},color={0,0,127}));
  connect(gain.y, hea4.u) annotation (Line(points={{-29,184},{-22,184},{-22,30},
          {-14,30}}, color={0,0,127}));
  connect(res_3.port_b, hea4.port_a) annotation (Line(points={{-80,24},{-12,24}},
        color={0,127,255}));
  connect(hea4.port_b, res_4.port_b) annotation (Line(points={{8,24},{20,24},{
          20,10}}, color={0,127,255}));
  connect(hea1.port_b, hea2.port_b) annotation (Line(points={{-34,96},{20,96},{
          20,144},{8,144}},  color={0,127,255}));
  connect(res_1.port_b, hea5.port_a) annotation (Line(points={{-80,-180},{-68,
          -180},{-54,-180}},
                  color={0,127,255}));
  connect(res_5.port_b, hea6.port_a)  annotation (Line(points={{-80,-120},{-80,
          -120},{-12,-120}},
                 color={0,127,255}));
  connect(res_6.port_b,hea7. port_a) annotation (Line(points={{-80,-322},{-80,
          -322},{-54,-322}},
                  color={0,127,255}));
  connect(res_7.port_b,hea8. port_a) annotation (Line(points={{-80,-260},{-12,
          -260}}, color={0,127,255}));
  connect(hea8.port_b,res_8. port_b) annotation (Line(points={{8,-260},{20,-260},
          {20,-294}}, color={0,127,255}));
  connect(hea5.port_b,hea6. port_b) annotation (Line(points={{-34,-180},{20,
          -180},{20,-120},{8,-120}},
                                   color={0,127,255}));
  connect(u.y, hea6.u) annotation (Line(points={{-127,184},{-70,184},{-70,-114},
          {-14,-114}},color={0,0,127}));
  connect(u.y, hea8.u) annotation (Line(points={{-127,184},{-70,184},{-70,-254},
          {-14,-254}}, color={0,0,127}));
  connect(gain.y, hea5.u) annotation (Line(points={{-29,184},{-22,184},{-22,
          -120},{-56,-120},{-56,-174}},   color={0,0,127}));
  connect(gain.y, hea7.u) annotation (Line(points={{-29,184},{-22,184},{-22,
          -280},{-56,-280},{-56,-316}},            color={0,0,127}));
  connect(sin_1.ports[1], res_12.port_a) annotation (Line(
      points={{-148,145},{-124,145},{-124,144},{-100,144}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[2], res_3.port_a) annotation (Line(
      points={{-148,143},{-124,143},{-124,24},{-100,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_1.ports[1], res_11.port_a) annotation (Line(
      points={{-150,103},{-125,103},{-125,96},{-100,96}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_1.ports[2], res_2.port_a) annotation (Line(
      points={{-150,101},{-128,101},{-128,-18},{-100,-18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[3], res_1.port_a) annotation (Line(
      points={{-148,141},{-128,141},{-128,-180},{-100,-180}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[4], res_6.port_a) annotation (Line(
      points={{-148,139},{-128,139},{-128,-322},{-100,-322}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_1.ports[3], res_5.port_a) annotation (Line(
      points={{-150,99},{-124,99},{-124,-120},{-100,-120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_1.ports[4], res_7.port_a) annotation (Line(
      points={{-150,97},{-124,97},{-124,-260},{-100,-260}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea3.port_b, mix1.ports[1]) annotation (Line(
      points={{-34,-18},{-22,-18},{-22,-20},{-10,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix1.ports[2], res_4.port_a) annotation (Line(
      points={{-6,-20},{20,-20},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea7.port_b, mix2.ports[1]) annotation (Line(
      points={{-34,-322},{-23,-322},{-23,-324},{-12,-324}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix2.ports[2], res_8.port_a) annotation (Line(
      points={{-8,-324},{20,-324},{20,-314}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea2.port_a, senTem2a.port) annotation (Line(
      points={{-12,144},{-12,160}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea2.port_b, senTem2b.port) annotation (Line(
      points={{8,144},{8,159},{8,159},{8,174}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea1.port_a, senTem1a.port) annotation (Line(
      points={{-54,96},{-54,114},{-52,114}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea1.port_b, senTem1b.port) annotation (Line(
      points={{-34,96},{-34,122},{-32,122}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem1a.T, ass1.u1) annotation (Line(
      points={{-46.4,121},{66,121},{66,176},{158,176}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem2a.T, ass1.u2) annotation (Line(
      points={{-6.4,167},{149.8,167},{149.8,164},{158,164}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem1b.T, ass2.u2) annotation (Line(
      points={{-26.4,129},{150.8,129},{150.8,124},{158,124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem2b.T, ass2.u1) annotation (Line(
      points={{13.6,181},{85.8,181},{85.8,136},{158,136}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem4a.T, ass4.u2) annotation (Line(
      points={{-6.4,47},{149.8,47},{149.8,44},{158,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem3a.T, ass4.u1) annotation (Line(
      points={{-46.4,1},{66,1},{66,56},{158,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem4b.T, ass3.u1) annotation (Line(
      points={{13.6,67},{85.8,67},{85.8,16},{158,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem3b.T, ass3.u2) annotation (Line(
      points={{-26.4,9},{150.8,9},{150.8,4},{158,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hea3.port_a, senTem3a.port) annotation (Line(
      points={{-54,-18},{-52,-18},{-52,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea3.port_b, senTem3b.port) annotation (Line(
      points={{-34,-18},{-34,2},{-32,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea4.port_a, senTem4a.port) annotation (Line(
      points={{-12,24},{-12,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea4.port_b, senTem4b.port) annotation (Line(
      points={{8,24},{8,42},{8,42},{8,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem6a.T, ass6.u2) annotation (Line(
      points={{-6.4,-93},{149.8,-93},{149.8,-96},{158,-96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem5a.T, ass6.u1) annotation (Line(
      points={{-46.4,-155},{66,-155},{66,-84},{158,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem6b.T, ass5.u1) annotation (Line(
      points={{13.6,-73},{85.8,-73},{85.8,-124},{158,-124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem5b.T, ass5.u2) annotation (Line(
      points={{-26.4,-147},{150.8,-147},{150.8,-136},{158,-136}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hea6.port_a, senTem6a.port) annotation (Line(
      points={{-12,-120},{-12,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea6.port_b, senTem6b.port) annotation (Line(
      points={{8,-120},{8,-100},{8,-100},{8,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea5.port_a, senTem5a.port) annotation (Line(
      points={{-54,-180},{-54,-162},{-52,-162}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea5.port_b, senTem5b.port) annotation (Line(
      points={{-34,-180},{-34,-154},{-32,-154}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem8a.T, ass8.u2) annotation (Line(
      points={{-6.4,-233},{149.8,-233},{149.8,-236},{158,-236}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem7a.T, ass8.u1) annotation (Line(
      points={{-46.4,-295},{66,-295},{66,-224},{158,-224}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem8b.T, ass7.u1) annotation (Line(
      points={{13.6,-213},{85.8,-213},{85.8,-264},{158,-264}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem7b.T, ass7.u2) annotation (Line(
      points={{-26.4,-287},{150.8,-287},{150.8,-276},{158,-276}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hea8.port_a, senTem8a.port) annotation (Line(
      points={{-12,-260},{-12,-240}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea8.port_b, senTem8b.port) annotation (Line(
      points={{8,-260},{8,-240},{8,-240},{8,-220}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea7.port_a, senTem7a.port) annotation (Line(
      points={{-54,-322},{-54,-302},{-52,-302}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea7.port_b, senTem7b.port) annotation (Line(
      points={{-34,-322},{-34,-294},{-32,-294}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem3a.T, ass10.u1) annotation (Line(
      points={{-46.4,1},{128,1},{128,-344},{158,-344}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem7a.T, ass10.u2) annotation (Line(
      points={{-46.4,-295},{124,-295},{124,-356},{158,-356}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem2b.T, ass9.u1) annotation (Line(
      points={{13.6,181},{120,181},{120,-384},{158,-384}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem5b.T, ass9.u2) annotation (Line(
      points={{-26.4,-147},{114,-147},{114,-396},{158,-396}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-200,
            -400},{200,240}}), graphics={Text(
          extent={{30,234},{158,192}},
          lineColor={0,0,255},
          textString="Asserts for temperture check"), Text(
          extent={{-188,-20},{-38,-84}},
          lineColor={0,0,255},
          textString="Same system as above, but with flow reversed")}),
                      Commands(file="HeaterCoolerPrescribed.mos" "run"),
Documentation(info="<html>
<p>
Model that tests the basic class that is used for the heater models.
It adds and removes heat for forward and reverse flow.
The top and bottom models should give similar results, although 
the sign of the temperature difference over the components differ
because of the reverse flow.
The model uses assert statements that will be triggered if
results that are expected to be close to each other differ by more
than a prescribed threshold.</p>
</html>",
revisions="<html>
<ul>
<li>
April 17, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end HeaterCoolerPrescribed;
