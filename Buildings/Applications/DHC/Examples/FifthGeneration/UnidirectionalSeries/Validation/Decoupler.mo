within Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Validation;
model Decoupler "Validation of building and ETS connection"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water
    "Source side medium";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";
  Fluid.Movers.FlowControlled_m_flow sou1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15 + 40,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true) "Primary supply"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
  EnergyTransferStations.BaseClasses.HydraulicHeader hydHea(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    nPorts_a=2,
    nPorts_b=2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-2})));
  Fluid.Movers.FlowControlled_m_flow sou2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15 + 30,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true) "Primary supply"
    annotation (Placement(transformation(extent={{170,-30},{150,-10}})));
  Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2) "Boundary pressure" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,0})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp m1(
    height=1.1,
    duration=1000,
    startTime=0)
    "Primary flow"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T1(k=273.15 + 40)
    "Primary supply temperature"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
  Fluid.Sensors.TemperatureTwoPort senT2Sup(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Secondary supply temperature (sensed)" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,20})));
  Fluid.Sensors.TemperatureTwoPort senT1Sup(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Primary supply temperature (sensed)" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,20})));
  Fluid.Sensors.TemperatureTwoPort senT1Ret(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Primary return temperature (sensed)" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,-20})));
  Fluid.Sensors.TemperatureTwoPort senT2Ret(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Secondary return temperature (sensed)" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,-20})));
  Fluid.Sensors.MassFlowRate senMasFlo1Sup(redeclare final package Medium =
        Medium) "Primary mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Fluid.Sensors.MassFlowRate senMasFlo2Sup(redeclare final package Medium =
        Medium) "Secondary mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{110,10},{130,30}})));
  Fluid.MixingVolumes.MixingVolume vol1(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 30,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium = Medium,
    V=1,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    nPorts=2) "Volume for fluid stream"
    annotation (Placement(transformation(extent={{189,-20},{209,-40}})));
  Fluid.HeatExchangers.HeaterCooler_u coo(
    redeclare final package Medium = Medium,
    dp_nominal=1,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=-1E5) "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{80,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T3(k=273.15 + 30)
    "Primary supply temperature"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat1(
    k=0.1,
    Ti=10,
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    each yMin=0,
    reverseAction=true)
                 "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Fluid.Sensors.MassFlowRate senMasFlo1Ret(redeclare final package Medium =
        Medium) "Primary mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{-60,-30},{-80,-10}})));
  Fluid.Sensors.MassFlowRate senMasFlo2Ret(redeclare final package Medium =
        Medium) "Secondary mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{130,-30},{110,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp m3(
    height=0.5,
    duration=1000,
    offset=1,
    startTime=2000)
    "Primary flow"
    annotation (Placement(transformation(extent={{200,50},{180,70}})));
equation
  connect(m1.y, sou1.m_flow_in) annotation (Line(points={{-158,60},{-100,60},{
          -100,32}},       color={0,0,127}));
  connect(senMasFlo1Sup.port_b, senT1Sup.port_a)
    annotation (Line(points={{-60,20},{-50,20}}, color={0,127,255}));
  connect(senT2Sup.port_b, senMasFlo2Sup.port_a)
    annotation (Line(points={{50,20},{110,20}}, color={0,127,255}));
  connect(sou1.port_b, senMasFlo1Sup.port_a)
    annotation (Line(points={{-90,20},{-80,20}}, color={0,127,255}));
  connect(coo.port_b, senT2Ret.port_a)
    annotation (Line(points={{60,-20},{50,-20}}, color={0,127,255}));
  connect(T3.y, conTChiWat1.u_s)
    annotation (Line(points={{42,60},{48,60}}, color={0,0,127}));
  connect(conTChiWat1.y, coo.u) annotation (Line(points={{72,60},{100,60},{100,
          -14},{82,-14}}, color={0,0,127}));
  connect(senT2Ret.T, conTChiWat1.u_m)
    annotation (Line(points={{40,-9},{40,0},{60,0},{60,48}}, color={0,0,127}));
  connect(vol1.ports[1], sou2.port_a)
    annotation (Line(points={{197,-20},{170,-20}}, color={0,127,255}));
  connect(senMasFlo2Sup.port_b, vol1.ports[2])
    annotation (Line(points={{130,20},{201,20},{201,-20}}, color={0,127,255}));
  connect(sou2.port_b, senMasFlo2Ret.port_a)
    annotation (Line(points={{150,-20},{130,-20}}, color={0,127,255}));
  connect(senMasFlo2Ret.port_b, coo.port_a)
    annotation (Line(points={{110,-20},{80,-20}}, color={0,127,255}));
  connect(m3.y, sou2.m_flow_in)
    annotation (Line(points={{178,60},{160,60},{160,-8}}, color={0,0,127}));
  connect(bou1.ports[1], sou1.port_a) annotation (Line(points={{-120,2},{-120,
          20},{-110,20}}, color={0,127,255}));
  connect(T1.y, bou1.T_in) annotation (Line(points={{-158,-50},{-152,-50},{-152,
          4},{-142,4}}, color={0,0,127}));
  connect(senT1Ret.port_b, senMasFlo1Ret.port_a)
    annotation (Line(points={{-50,-20},{-60,-20}}, color={0,127,255}));
  connect(senMasFlo1Ret.port_b, bou1.ports[2]) annotation (Line(points={{-80,
          -20},{-120,-20},{-120,-2}}, color={0,127,255}));
  connect(senT1Sup.port_b, hydHea.ports_a[1]) annotation (Line(points={{-30,20},
          {0.45,20},{0.45,8.2}}, color={0,127,255}));
  connect(hydHea.ports_b[1], senT1Ret.port_a) annotation (Line(points={{-0.65,-12.4},
          {-0.65,-20},{-30,-20}}, color={0,127,255}));
  connect(senT2Ret.port_b, hydHea.ports_b[2]) annotation (Line(points={{30,-20},
          {20,-20},{20,-12.4},{0.85,-12.4}}, color={0,127,255}));
  connect(hydHea.ports_a[2], senT2Sup.port_a) annotation (Line(points={{-1.05,8.2},
          {20,8.2},{20,20},{30,20}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{
            220,120}})),
   experiment(
      StopTime=5000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/Examples/FifthGenUniSeries/Validation/BuildingETSConnection.mos"
        "Simulate and plot"));
end Decoupler;
