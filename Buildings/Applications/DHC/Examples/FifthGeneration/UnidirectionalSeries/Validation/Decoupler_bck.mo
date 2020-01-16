within Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Validation;
model Decoupler_bck "Validation of building and ETS connection"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water
    "Source side medium";
  Fluid.Movers.FlowControlled_m_flow
                                 sou1(
    redeclare package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 40,
    m_flow_nominal=decoupler.m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
              "Primary supply"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Agents.Decoupler decoupler(
    redeclare package Medium=Medium,
    m_flow_nominal=1,
    nSec=1)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Fluid.Movers.FlowControlled_m_flow
                                 sou2(
    redeclare package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 30,
    m_flow_nominal=decoupler.m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
              "Primary supply"
    annotation (Placement(transformation(extent={{170,-70},{150,-50}})));
  Fluid.Sources.Boundary_pT bou1(redeclare package Medium = Medium, nPorts=1)
    "Boundary pressure" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-100})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp m1(
    height=1.1,
    duration=1000,
    startTime=0)
    "Primary flow"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T1(k=273.15 + 40)
    "Primary supply temperature"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Fluid.Sensors.TemperatureTwoPort senT2Sup(
    redeclare final package Medium=Medium,
    m_flow_nominal=decoupler.m_flow_nominal)
    "Secondary supply temperature (sensed)" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-20})));
  Fluid.Sensors.TemperatureTwoPort senT1Sup(
    redeclare final package Medium=Medium,
    m_flow_nominal=decoupler.m_flow_nominal)
    "Primary supply temperature (sensed)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,-20})));
  Fluid.Sensors.TemperatureTwoPort senT1Ret(redeclare final package Medium =
        Medium, m_flow_nominal=decoupler.m_flow_nominal)
    "Primary return temperature (sensed)" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-60,-60})));
  Fluid.Sensors.TemperatureTwoPort senT2Ret(
    redeclare final package Medium=Medium,
    m_flow_nominal=decoupler.m_flow_nominal)
    "Secondary return temperature (sensed)" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,-60})));
  Fluid.Sensors.MassFlowRate senMasFlo1Sup(redeclare final package Medium =
        Medium) "Primary mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Fluid.Sensors.MassFlowRate senMasFlo2Sup(redeclare final package Medium =
        Medium) "Secondary mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{110,-30},{130,-10}})));
              Fluid.MixingVolumes.MixingVolume           vol(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 40,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium = Medium,
    nPorts=3,
    V=0.1,
    final mSenFac=1,
    final m_flow_nominal=decoupler.m_flow_nominal)
                           "Volume for fluid stream"
     annotation (Placement(transformation(extent={{-93,-60},{-73,-80}})));
              Fluid.MixingVolumes.MixingVolume           vol1(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 30,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium = Medium,
    V=0.1,
    final mSenFac=1,
    final m_flow_nominal=decoupler.m_flow_nominal,
    nPorts=2)              "Volume for fluid stream"
     annotation (Placement(transformation(extent={{189,-60},{209,-80}})));
  Fluid.HeatExchangers.HeaterCooler_u           heaCoo(
    redeclare final package Medium = Medium,
    dp_nominal=1,
    m_flow_nominal=decoupler.m_flow_nominal,
    Q_flow_nominal=1E5) "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{-110,-70},{-130,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat(
    k=0.1,
    Ti=10,
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    each yMin=0) "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Fluid.HeatExchangers.HeaterCooler_u coo(
    redeclare final package Medium = Medium,
    dp_nominal=1,
    m_flow_nominal=decoupler.m_flow_nominal,
    Q_flow_nominal=-1E5) "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{80,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T3(k=273.15 + 30)
    "Primary supply temperature"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat1(
    k=0.1,
    Ti=10,
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    each yMin=0,
    reverseAction=true)
                 "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  Fluid.Sensors.MassFlowRate senMasFlo1Ret(redeclare final package Medium =
        Medium) "Primary mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{-22,-70},{-42,-50}})));
  Fluid.Sensors.MassFlowRate senMasFlo2Ret(redeclare final package Medium =
        Medium) "Secondary mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{130,-70},{110,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp m3(
    height=0.5,
    duration=1000,
    offset=1,
    startTime=2000)
    "Primary flow"
    annotation (Placement(transformation(extent={{200,10},{180,30}})));
equation
  connect(m1.y, sou1.m_flow_in) annotation (Line(points={{-158,20},{-110,20},{
          -110,-8}},       color={0,0,127}));
  connect(decoupler.ports_b2[1], senT2Sup.port_a) annotation (Line(points={{10,-35},
          {20,-35},{20,-20},{30,-20}}, color={0,127,255}));
  connect(senT1Sup.port_b, decoupler.port_a1) annotation (Line(points={{-30,-20},
          {-20,-20},{-20,-35},{-10,-35}}, color={0,127,255}));
  connect(senT2Ret.port_b, decoupler.ports_a2[1]) annotation (Line(points={{30,-60},
          {20,-60},{20,-45.2},{10,-45.2}}, color={0,127,255}));
  connect(senMasFlo1Sup.port_b, senT1Sup.port_a)
    annotation (Line(points={{-70,-20},{-50,-20}}, color={0,127,255}));
  connect(senT2Sup.port_b, senMasFlo2Sup.port_a)
    annotation (Line(points={{50,-20},{110,-20}}, color={0,127,255}));
  connect(senT1Ret.port_b, vol.ports[1])
    annotation (Line(points={{-70,-60},{-85.6667,-60}}, color={0,127,255}));
  connect(sou1.port_b, senMasFlo1Sup.port_a)
    annotation (Line(points={{-100,-20},{-90,-20}}, color={0,127,255}));
  connect(vol.ports[2], heaCoo.port_a)
    annotation (Line(points={{-83,-60},{-110,-60}}, color={0,127,255}));
  connect(heaCoo.port_b, sou1.port_a) annotation (Line(points={{-130,-60},{-140,
          -60},{-140,-20},{-120,-20}}, color={0,127,255}));
  connect(conTChiWat.u_s, T1.y)
    annotation (Line(points={{-52,20},{-58,20}}, color={0,0,127}));
  connect(senT1Sup.T, conTChiWat.u_m)
    annotation (Line(points={{-40,-9},{-40,8}}, color={0,0,127}));
  connect(conTChiWat.y, heaCoo.u) annotation (Line(points={{-28,20},{-16,20},{
          -16,-54},{-108,-54}}, color={0,0,127}));
  connect(coo.port_b, senT2Ret.port_a)
    annotation (Line(points={{60,-60},{50,-60}}, color={0,127,255}));
  connect(T3.y, conTChiWat1.u_s)
    annotation (Line(points={{42,20},{48,20}}, color={0,0,127}));
  connect(conTChiWat1.y, coo.u) annotation (Line(points={{72,20},{92,20},{92,
          -54},{82,-54}}, color={0,0,127}));
  connect(senT2Ret.T, conTChiWat1.u_m) annotation (Line(points={{40,-49},{40,
          -40},{60,-40},{60,8}}, color={0,0,127}));
  connect(bou1.ports[1], vol.ports[3]) annotation (Line(points={{-120,-100},{
          -100,-100},{-100,-60},{-80.3333,-60}}, color={0,127,255}));
  connect(vol1.ports[1], sou2.port_a)
    annotation (Line(points={{197,-60},{170,-60}}, color={0,127,255}));
  connect(senMasFlo2Sup.port_b, vol1.ports[2]) annotation (Line(points={{130,
          -20},{201,-20},{201,-60}}, color={0,127,255}));
  connect(senT1Ret.port_a, senMasFlo1Ret.port_b)
    annotation (Line(points={{-50,-60},{-42,-60}}, color={0,127,255}));
  connect(decoupler.port_b1, senMasFlo1Ret.port_a) annotation (Line(points={{
          -10,-46},{-16,-46},{-16,-60},{-22,-60}}, color={0,127,255}));
  connect(sou2.port_b, senMasFlo2Ret.port_a)
    annotation (Line(points={{150,-60},{130,-60}}, color={0,127,255}));
  connect(senMasFlo2Ret.port_b, coo.port_a)
    annotation (Line(points={{110,-60},{80,-60}}, color={0,127,255}));
  connect(m3.y, sou2.m_flow_in)
    annotation (Line(points={{178,20},{160,20},{160,-48}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{
            220,120}}),
    graphics={Text(
          extent={{-68,100},{64,74}},
          lineColor={28,108,200},
          textString="Simulation requires
Hidden.AvoidDoubleComputation=true")}),
   experiment(
      StopTime=5000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/Examples/FifthGenUniSeries/Validation/BuildingETSConnection.mos"
        "Simulate and plot"));
end Decoupler_bck;
