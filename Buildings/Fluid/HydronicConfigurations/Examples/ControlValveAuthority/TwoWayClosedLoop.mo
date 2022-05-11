within Buildings.Fluid.HydronicConfigurations.Examples.ControlValveAuthority;
model TwoWayClosedLoop
  "Model illustrating the concept of the authority for two-way valves and closed loop control"
  extends Modelica.Icons.Example;

  package MediumAir = Buildings.Media.Air
    "Medium model for air";
  package MediumHeaWat = Buildings.Media.Water
    "Medium model for hot water";
  parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal = 1
    "Circuit mass flow rate at design conditions";
  parameter Modelica.Units.SI.Pressure pMin_nominal = 2E5
    "Circuit minimum pressure at design conditions";
  parameter Modelica.Units.SI.Pressure dpTot_nominal = 1E5
    "Circuit total pressure drop at design conditions";

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=
    Q_flow_nominal / (TAirLvg_nominal - TAirEnt_nominal) / 1006
    "Air mass flow rate at design conditions";
  parameter Modelica.Units.SI.Temperature TAirEnt_nominal = 273.15
    "Air entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TAirLvg_nominal = 30 + 273.15
    "Air leaving temperature at design conditions";
  parameter Modelica.Units.SI.Temperature THeaWatEnt_nominal = 60 + 273.15
    "Hot water entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature THeaWatLvg_nominal = 50 + 273.15
    "Hot water leaving temperature at design conditions";
  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=
    (THeaWatEnt_nominal - THeaWatLvg_nominal) * mHeaWat_flow_nominal * 4186
    "Coil capacity at design conditions";

  Sources.Boundary_pT sup(
    redeclare final package Medium = MediumHeaWat,
    final p=pMin_nominal + dpTot_nominal,
    T=THeaWatEnt_nominal,
    nPorts=2) "Pressure boundary condition at supply"
    annotation (Placement(transformation(extent={{-90,88},{-70,108}})));
  Sources.Boundary_pT ret(
    redeclare final package Medium = MediumHeaWat,
    final p=pMin_nominal,
    nPorts=2) "Pressure boundary condition at return"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-90})));
  Actuators.Valves.TwoWayEqualPercentage valAut100(
    redeclare final package Medium = MediumHeaWat,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final dpValve_nominal=dpTot_nominal,
    use_inputFilter=false,
    dpFixed_nominal=0) "Control valve with 100% authority"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-40,0})));
  HeatExchangers.DryCoilEffectivenessNTU coi100(
    redeclare final package Medium1 = MediumHeaWat,
    redeclare final package Medium2 = MediumAir,
    final m1_flow_nominal=mHeaWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,

    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=THeaWatEnt_nominal,
    final T_a2_nominal=TAirEnt_nominal) "Heating coil" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-14,40})));
  Sources.Boundary_pT outAir(
    redeclare final package Medium = MediumAir,
    nPorts=2)
    "Pressure boundary condition at coil outlet" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
  Sources.MassFlowSource_T souAir(
    redeclare final package Medium = MediumAir,
    final m_flow=mAir_flow_nominal,
    final T=TAirEnt_nominal,
    nPorts=1)
    "Source for entering air" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,80})));
  Controls.OBC.CDL.Continuous.Sources.TimeTable setFac(
    table=[0,0; 1,0.2; 2,0.2; 3,0.5; 4,0.5; 5,0.7; 6,0.7; 7,0.6; 8,0.6; 9,1; 10,
        1],
    timeScale=10,
    y(unit="K", displayUnit="degC"))
    "Supply air temperature set point adjustment factor"
    annotation (Placement(transformation(extent={{-190,30},{-170,50}})));
  Sensors.TemperatureTwoPort TSup100(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mAir_flow_nominal,
    T_start=TAirEnt_nominal) "Supply air temperature sensor" annotation (
      Placement(transformation(extent={{-10,-10},{10,10}}, rotation=-90)));
  Controls.OBC.CDL.Continuous.PID ctl100(
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"),
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=120,
    reverseActing=true) "Controller for supply air temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Controls.OBC.CDL.Continuous.AddParameter set(p=TAirEnt_nominal)
    annotation (Placement(transformation(extent={{-130,50},{-110,70}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter gai(k=TAirLvg_nominal -
        TAirEnt_nominal)
    annotation (Placement(transformation(extent={{-162,30},{-142,50}})));
  Controls.OBC.CDL.Continuous.PID ctl20(
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"),
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=120,
    reverseActing=true) "Controller for supply air temperature"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Actuators.Valves.TwoWayEqualPercentage valAut20(
    redeclare final package Medium = MediumHeaWat,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final dpValve_nominal=0.1*dpTot_nominal,
    use_inputFilter=false,
    dpFixed_nominal=0.9*dpTot_nominal) "Control valve with 20% authority"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={80,0})));
  Sensors.TemperatureTwoPort TSup20(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mAir_flow_nominal,
    T_start=TAirEnt_nominal) "Supply air temperature sensor" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={120,0})));
  HeatExchangers.DryCoilEffectivenessNTU coi20(
    redeclare final package Medium1 = MediumHeaWat,
    redeclare final package Medium2 = MediumAir,
    final m1_flow_nominal=mHeaWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,

    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=THeaWatEnt_nominal,
    final T_a2_nominal=TAirEnt_nominal) "Heating coil" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={106,40})));
  Sources.MassFlowSource_T souAir1(
    redeclare final package Medium = MediumAir,
    final m_flow=mAir_flow_nominal,
    final T=TAirEnt_nominal,
    nPorts=1)
    "Source for entering air" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={120,80})));
equation
  connect(valAut100.port_b,ret. ports[1]) annotation (Line(points={{-40,-10},{
          -40,-80},{-79,-80}},color={0,127,255}));
  connect(sup.ports[1], coi100.port_a1)
    annotation (Line(points={{-70,97},{-20,97},{-20,50}}, color={0,127,255}));
  connect(coi100.port_b1, valAut100.port_a) annotation (Line(points={{-20,30},{
          -20,20},{-40,20},{-40,10}}, color={0,127,255}));
  connect(souAir.ports[1], coi100.port_b2) annotation (Line(points={{
          -8.88178e-16,70},{-8.88178e-16,54},{-8,54},{-8,50}}, color={0,127,255}));
  connect(coi100.port_a2, TSup100.port_a) annotation (Line(points={{-8,30},{-8,
          20},{4.44089e-16,20},{1.77636e-15,10}}, color={0,127,255}));
  connect(TSup100.port_b, outAir.ports[1]) annotation (Line(points={{
          -1.83187e-15,-10},{-1.83187e-15,-40},{1,-40},{1,-80}}, color={0,127,
          255}));
  connect(valAut100.y,ctl100. y) annotation (Line(points={{-52,2.10942e-15},{-56,
          2.10942e-15},{-56,0},{-58,0}}, color={0,0,127}));
  connect(TSup100.T, ctl100.u_m) annotation (Line(points={{11,0},{20,0},{20,-20},
          {-70,-20},{-70,-12}}, color={0,0,127}));
  connect(setFac.y[1], gai.u)
    annotation (Line(points={{-168,40},{-164,40}}, color={0,0,127}));
  connect(gai.y, set.u)
    annotation (Line(points={{-140,40},{-136,40},{-136,60},{-132,60}},
                                                   color={0,0,127}));
  connect(set.y,ctl100. u_s) annotation (Line(points={{-108,60},{-100,60},{-100,
          0},{-82,0}},
                    color={0,0,127}));
  connect(souAir1.ports[1], coi20.port_b2) annotation (Line(points={{120,70},{
          120,60},{112,60},{112,50}}, color={0,127,255}));
  connect(coi20.port_a2, TSup20.port_a) annotation (Line(points={{112,30},{112,
          20},{120,20},{120,10}}, color={0,127,255}));
  connect(TSup20.port_b, outAir.ports[2]) annotation (Line(points={{120,-10},{
          120,-80},{-1,-80}}, color={0,127,255}));
  connect(set.y, ctl20.u_s) annotation (Line(points={{-108,60},{30,60},{30,0},{
          38,0}}, color={0,0,127}));
  connect(TSup20.T, ctl20.u_m) annotation (Line(points={{131,0},{140,0},{140,
          -20},{50,-20},{50,-12}}, color={0,0,127}));
  connect(ctl20.y, valAut20.y)
    annotation (Line(points={{62,0},{68,0}}, color={0,0,127}));
  connect(valAut20.port_b, ret.ports[2]) annotation (Line(points={{80,-10},{80,
          -60},{-81,-60},{-81,-80}}, color={0,127,255}));
  connect(valAut20.port_a, coi20.port_b1) annotation (Line(points={{80,10},{80,
          20},{100,20},{100,30}}, color={0,127,255}));
  connect(sup.ports[2], coi20.port_a1)
    annotation (Line(points={{-70,99},{100,99},{100,50}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-220,-120},{220,120}})),
    experiment(
    StopTime=1000,
    Tolerance=1e-6),
    Icon(coordinateSystem(extent={{-220,-120},{220,120}})));
end TwoWayClosedLoop;
