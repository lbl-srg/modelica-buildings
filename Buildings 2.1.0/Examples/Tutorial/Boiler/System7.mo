within Buildings.Examples.Tutorial.Boiler;
model System7
  "7th part of the system model, which implements the on/off control using a state machine"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;
  replaceable package MediumW =
      Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 20000
    "Nominal heat flow rate of radiator";
  parameter Modelica.SIunits.Temperature TRadSup_nominal = 273.15+50
    "Radiator nominal supply water temperature";
  parameter Modelica.SIunits.Temperature TRadRet_nominal = 273.15+40
    "Radiator nominal return water temperature";
  parameter Modelica.SIunits.MassFlowRate mRad_flow_nominal=
    Q_flow_nominal/4200/(TRadSup_nominal-TRadRet_nominal)
    "Radiator nominal mass flow rate";

  parameter Modelica.SIunits.Temperature TBoiSup_nominal = 273.15+70
    "Boiler nominal supply water temperature";
  parameter Modelica.SIunits.Temperature TBoiRet_min = 273.15+60
    "Boiler minimum return water temperature";
  parameter Modelica.SIunits.MassFlowRate mBoi_flow_nominal=
    Q_flow_nominal/4200/(TBoiSup_nominal-TBoiRet_min)
    "Boiler nominal mass flow rate";
//------------------------------------------------------------------------------//

//----------------Radiator loop: Three-way valve: mass flow rate----------------//
  parameter Modelica.SIunits.MassFlowRate mRadVal_flow_nominal=
    Q_flow_nominal/4200/(TBoiSup_nominal-TRadRet_nominal)
    "Radiator nominal mass flow rate";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mA_flow_nominal,
    V=V)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal = V*6/3600
    "Nominal mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow = 4000
    "Internal heat gains of the room";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(C=2*V*1.2*1006)
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Sources.CombiTimeTable timTab(
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      table=[-6*3600, 0;
              8*3600, QRooInt_flow;
             18*3600, 0]) "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal,
    T_a_nominal=TRadSup_nominal,
    T_b_nominal=TRadRet_nominal) "Radiator"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSup(redeclare package Medium = MediumW,
      m_flow_nominal=mRad_flow_nominal) "Supply water temperature"
      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-40})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temRoo
    "Room temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-40,30})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumRad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mRad_flow_nominal) "Pump for radiator"
      annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-50,-70})));

//----------------------------------------------------------------------------//
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM mix(
    redeclare package Medium =MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mRadVal_flow_nominal,
                   -mRad_flow_nominal,
                   mRad_flow_nominal-mRadVal_flow_nominal},
    dp_nominal={100,-8000,6750}) "Mixer between valve and radiators"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-110})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mBoi_flow_nominal,
                   -mRadVal_flow_nominal,
                   -mBoi_flow_nominal},
    dp_nominal={200,-200,-50}) "Splitter of boiler loop bypass"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-190})));

  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl2(redeclare
      package Medium=MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,0,0},
    m_flow_nominal={mRad_flow_nominal,-mRadVal_flow_nominal,-mRad_flow_nominal +
        mRadVal_flow_nominal})
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-110})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM mix2(redeclare
      package Medium=MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,-200,0},
    m_flow_nominal={mRadVal_flow_nominal,-mBoi_flow_nominal,mBoi_flow_nominal}) "Mixer"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-190})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl4(redeclare
      package Medium=MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mRadVal_flow_nominal*{1,-1,-1},
    dp_nominal=200*{1,-1,-1}) "Splitter for radiator loop valve bypass"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-150})));
//----------------------------------------------------------------------------//

  Buildings.Fluid.Movers.FlowControlled_m_flow pumBoi(
      redeclare package Medium = MediumW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      m_flow_nominal=mBoi_flow_nominal) "Pump for boiler"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-280})));
//----------------------------------------------------------------------------//

  Buildings.Fluid.Boilers.BoilerPolynomial boi(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mBoi_flow_nominal,
    dp_nominal=2000,
    Q_flow_nominal=Q_flow_nominal,
    fue=Buildings.Fluid.Data.Fuels.HeatingOilLowerHeatingValue()) "Boiler"
    annotation (Placement(transformation(extent={{20,-320},{0,-300}})));
//----------------------------------------------------------------------------//

  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valRad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mRadVal_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000) "Three-way valve for radiator loop"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-150})));
//----------------------------------------------------------------------------//

  Buildings.Fluid.Sources.FixedBoundary preSou(redeclare package Medium = MediumW,
      nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{92,-320},{72,-300}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valBoi(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mBoi_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000) "Three-way valve for boiler"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-230})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temRet(redeclare package Medium =
        MediumW, m_flow_nominal=mBoi_flow_nominal) "Return water temperature"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-280})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl1(redeclare
      package Medium=MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mBoi_flow_nominal,-mBoi_flow_nominal,-mBoi_flow_nominal},
    dp_nominal={0,0,-200}) "Splitter"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-230})));

//------------------------------------------------------------------------------------//

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTOut
    "Outdoor temperature sensor"
    annotation (Placement(transformation(extent={{-318,20},{-298,40}})));
  Modelica.Blocks.Math.BooleanToReal booToReaRad1(realTrue=mBoi_flow_nominal)
    "Radiator pump signal"
    annotation (Placement(transformation(extent={{-140,-290},{-120,-270}})));
  Modelica.Blocks.Math.BooleanToReal booToReaRad2(realTrue=1)
    "Radiator pump signal"
    annotation (Placement(transformation(extent={{-100,-340},{-80,-320}})));
  Modelica.Blocks.Math.BooleanToReal booToReaRad(realTrue=mRad_flow_nominal)
    "Radiator pump signal"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Modelica.Blocks.Sources.Constant TSetBoiRet(k=TBoiRet_min)
    "Temperature setpoint for boiler return"
    annotation (Placement(transformation(extent={{120,-270},{140,-250}})));
  Buildings.Controls.Continuous.LimPID conPIDBoi(
    Td=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=120,
    reverseAction=true) "Controller for valve in boiler loop"
    annotation (Placement(transformation(extent={{160,-270},{180,-250}})));
  Controls.SetPoints.Table TSetSup(table=[273.15 + 19, 273.15 + 50;
                                          273.15 + 21, 273.15 + 21])
    "Setpoint for supply water temperature"
    annotation (Placement(transformation(extent={{-220,-20},{-200,0}})));
  Buildings.Controls.Continuous.LimPID conPIDRad(
    Td=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=120) "Controller for valve in radiator loop"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data reader"
    annotation (Placement(transformation(extent={{-380,60},{-360,80}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-320,60},{-300,80}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));

//-------------------------Step 2: State machine implementation-------------------------//
  Modelica_StateGraph2.Step allOff(
    nOut=1,
    initialStep=true,
    use_activePort=true,
    nIn=1) "System off"
    annotation (Placement(transformation(extent={{-232,-104},{-224,-96}})));
  Modelica_StateGraph2.Transition T1(use_conditionPort=true, delayedTransition=
        false)
    annotation (Placement(transformation(extent={{-232,-124},{-224,-116}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=273.15 + 19)
    annotation (Placement(transformation(extent={{-340,-80},{-320,-60}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold=273.15 + 16)
    annotation (Placement(transformation(extent={{-340,-110},{-320,-90}})));
  Modelica.Blocks.Logical.And and3
    annotation (Placement(transformation(extent={{-300,-102},{-280,-82}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold2(threshold=273.15 + 70)
    "Threshold for boiler control"
    annotation (Placement(transformation(extent={{-340,-230},{-320,-210}})));
  Modelica_StateGraph2.Step boilerOn(
    nIn=1,
    use_activePort=true,
    nOut=1) "Boiler is on"
    annotation (Placement(transformation(extent={{-224,-184},{-216,-176}})));
  Modelica_StateGraph2.Transition T2(
    use_conditionPort=true, delayedTransition=false)
    annotation (Placement(transformation(extent={{-224,-164},{-216,-156}})));
  Modelica.Blocks.Logical.GreaterThreshold greThrBoi(threshold=273.15 + 90)
    "Threshold for boiler control"
    annotation (Placement(transformation(extent={{-340,-260},{-320,-240}})));
  Modelica_StateGraph2.Transition T3(use_conditionPort=true,
    delayedTransition=true,
    waitTime=10)
    annotation (Placement(transformation(extent={{-224,-204},{-216,-196}})));
  Modelica.Blocks.Logical.GreaterThreshold greThrTRoo(threshold=273.15 + 21)
    "Threshold for room temperature"
    annotation (Placement(transformation(extent={{-340,-150},{-320,-130}})));
  Modelica.Blocks.Logical.GreaterThreshold greThrTROut(threshold=273.15 + 17)
    "Threshold for room temperature"
    annotation (Placement(transformation(extent={{-340,-180},{-320,-160}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-300,-160},{-280,-140}})));
  Modelica_StateGraph2.Transition T4(use_conditionPort=true,
    delayedTransition=true,
    waitTime=10)
    annotation (Placement(transformation(extent={{-244,-184},{-236,-176}})));
  Modelica_StateGraph2.Step pumpsOn(
    nIn=2,
    use_activePort=false,
    nOut=2) "Pumps are on"
    annotation (Placement(transformation(extent={{-232,-144},{-224,-136}})));
  Modelica.Blocks.Logical.Not not1 "Negate output of hysteresis"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
//--------------------------------------------------------------------------------------//

equation
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{40,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{40,80},{50,80},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCap.port, vol.heatPort) annotation (Line(
      points={{70,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(timTab.y[1], preHea.Q_flow) annotation (Line(
      points={{1,80},{20,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSup.port_b, rad.port_a) annotation (Line(
      points={{-50,-30},{-50,-10},{-5.55112e-16,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRoo.port, vol.heatPort) annotation (Line(
      points={{-30,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortCon, vol.heatPort) annotation (Line(
      points={{8,-2.8},{8,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortRad, vol.heatPort) annotation (Line(
      points={{12,-2.8},{12,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumRad.port_b, temSup.port_a) annotation (Line(
      points={{-50,-60},{-50,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi.port_b, pumBoi.port_a) annotation (Line(
      points={{-5.55112e-16,-310},{-50,-310},{-50,-290}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumBoi.port_b, spl1.port_1) annotation (Line(
      points={{-50,-270},{-50,-240}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl1.port_2, spl.port_1) annotation (Line(
      points={{-50,-220},{-50,-200}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_2, valRad.port_1)
                                  annotation (Line(
      points={{-50,-180},{-50,-160}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valRad.port_2, mix.port_1)
                                  annotation (Line(
      points={{-50,-140},{-50,-120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl1.port_3, valBoi.port_3)
                                    annotation (Line(
      points={{-40,-230},{50,-230}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valBoi.port_2, temRet.port_a)
                                      annotation (Line(
      points={{60,-240},{60,-270}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRet.port_b, boi.port_a) annotation (Line(
      points={{60,-290},{60,-310},{20,-310}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi.port_a, preSou.ports[1]) annotation (Line(
      points={{20,-310},{72,-310}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix2.port_2, valBoi.port_1)
                                    annotation (Line(
      points={{60,-200},{60,-220}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl4.port_2, mix2.port_1) annotation (Line(
      points={{60,-160},{60,-180}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl2.port_2, spl4.port_1) annotation (Line(
      points={{60,-120},{60,-140}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valRad.port_3, spl4.port_3)
                                   annotation (Line(
      points={{-40,-150},{50,-150}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_3, mix2.port_3) annotation (Line(
      points={{-40,-190},{50,-190}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix.port_3, spl2.port_3) annotation (Line(
      points={{-40,-110},{50,-110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix.port_2, pumRad.port_a) annotation (Line(
      points={{-50,-100},{-50,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rad.port_b, spl2.port_1) annotation (Line(
      points={{20,-10},{60,-10},{60,-100}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(booToReaRad2.y, boi.y) annotation (Line(
      points={{-79,-330},{40,-330},{40,-302},{22,-302}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temRoo.T, TSetSup.u) annotation (Line(
      points={{-50,30},{-270,30},{-270,-10},{-222,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetSup.y, conPIDRad.u_s) annotation (Line(
      points={{-199,-10},{-182,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSup.T, conPIDRad.u_m) annotation (Line(
      points={{-61,-40},{-170,-40},{-170,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-360,70},{-310,70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, TOut.T) annotation (Line(
      points={{-310,70},{-262,70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{-240,70},{-220,70},{-220,50},{20,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOut.port, senTOut.port) annotation (Line(
      points={{-240,70},{-220,70},{-220,50},{-340,50},{-340,30},{-318,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(allOff.outPort[1], T1.inPort) annotation (Line(
      points={{-228,-104.6},{-228,-116}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(temRoo.T, lessThreshold.u) annotation (Line(
      points={{-50,30},{-270,30},{-270,-10},{-390,-10},{-390,-70},{-342,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lessThreshold1.u, senTOut.T) annotation (Line(
      points={{-342,-100},{-396,-100},{-396,10},{-280,10},{-280,30},{-298,30}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(lessThreshold.y, and3.u1) annotation (Line(
      points={{-319,-70},{-310,-70},{-310,-92},{-302,-92}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(lessThreshold1.y, and3.u2) annotation (Line(
      points={{-319,-100},{-302,-100}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(T1.conditionPort, and3.y) annotation (Line(
      points={{-233,-120},{-256,-120},{-256,-92},{-279,-92}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(boi.T, lessThreshold2.u) annotation (Line(
      points={{-1,-302},{-382,-302},{-382,-220},{-342,-220}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lessThreshold2.y, T2.conditionPort) annotation (Line(
      points={{-319,-220},{-260,-220},{-260,-160},{-225,-160}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(T2.outPort, boilerOn.inPort[1]) annotation (Line(
      points={{-220,-165},{-220,-176}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(boi.T, greThrBoi.u) annotation (Line(
      points={{-1,-302},{-382,-302},{-382,-250},{-342,-250}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boilerOn.outPort[1], T3.inPort) annotation (Line(
      points={{-220,-184.6},{-220,-196}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(greThrBoi.y, T3.conditionPort) annotation (Line(
      points={{-319,-250},{-250,-250},{-250,-200},{-225,-200}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(boilerOn.activePort, booToReaRad2.u) annotation (Line(
      points={{-215.28,-180},{-160,-180},{-160,-330},{-102,-330}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(temRoo.T, greThrTRoo.u) annotation (Line(
      points={{-50,30},{-270,30},{-270,-10},{-390,-10},{-390,-140},{-342,-140}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(senTOut.T, greThrTROut.u) annotation (Line(
      points={{-298,30},{-280,30},{-280,10},{-396,10},{-396,-170},{-342,-170}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(greThrTRoo.y, and1.u1) annotation (Line(
      points={{-319,-140},{-310,-140},{-310,-150},{-302,-150}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(greThrTROut.y, and1.u2) annotation (Line(
      points={{-319,-170},{-312,-170},{-312,-158},{-302,-158}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and1.y, T4.conditionPort) annotation (Line(
      points={{-279,-150},{-272,-150},{-272,-180},{-245,-180}},
      color={255,0,255},
      smooth=Smooth.None));

  connect(T1.outPort, pumpsOn.inPort[1]) annotation (Line(
      points={{-228,-125},{-228,-136},{-229,-136}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(allOff.activePort, not1.u) annotation (Line(
      points={{-223.28,-100},{-202,-100},{-202,-70},{-182,-70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not1.y, booToReaRad.u) annotation (Line(
      points={{-159,-70},{-142,-70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not1.y, booToReaRad1.u) annotation (Line(
      points={{-159,-70},{-152,-70},{-152,-280},{-142,-280}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(T3.outPort, pumpsOn.inPort[2]) annotation (Line(
      points={{-220,-205},{-220,-220},{-200,-220},{-200,-126},{-227,-126},{-227,
          -136}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T4.outPort, allOff.inPort[1]) annotation (Line(
      points={{-240,-185},{-240,-226},{-198,-226},{-198,-80},{-228,-80},{-228,
          -96}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(pumpsOn.outPort[1], T4.inPort) annotation (Line(
      points={{-229,-144.6},{-229,-152},{-240,-152},{-240,-176}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(pumpsOn.outPort[2], T2.inPort) annotation (Line(
      points={{-227,-144.6},{-227,-152},{-220,-152},{-220,-156}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(conPIDRad.y, valRad.y) annotation (Line(
      points={{-159,-10},{-90,-10},{-90,-150},{-62,-150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToReaRad.y, pumRad.m_flow_in) annotation (Line(
      points={{-119,-70},{-90.5,-70},{-90.5,-70.2},{-62,-70.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conPIDBoi.y, valBoi.y) annotation (Line(
      points={{181,-260},{200,-260},{200,-230},{72,-230}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToReaRad1.y, pumBoi.m_flow_in) annotation (Line(
      points={{-119,-280},{-90.5,-280},{-90.5,-280.2},{-62,-280.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetBoiRet.y, conPIDBoi.u_s)
    annotation (Line(points={{141,-260},{158,-260}}, color={0,0,127}));
  connect(temRet.T, conPIDBoi.u_m) annotation (Line(points={{71,-280},{120,-280},
          {170,-280},{170,-272}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This part of the system model changes the implementation of the control in
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System6\">
Buildings.Examples.Tutorial.Boiler.System6</a>
to use a state machine to switch the pumps and the boiler on and off.
State machines provide an alternate way to implement discrete event,
reactive and hybrid systems.
The state machine that is implemented in this model is shown in
the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/stateMachine.png\" border=\"1\"/>
</p>
<p>
In the figure above, the ovals depict states, and the arrows are transitions between the states.
The transitions fire when the conditions are true.
</p>
<h4>Implementation</h4>
<p>
This model was built as follows:
</p>
<ol>
<li>
<p>
First, we copied the model
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System6\">
Buildings.Examples.Tutorial.Boiler.System6</a>
and called it
<code>Buildings.Examples.Tutorial.Boiler.System7</code>.
</p>
</li>
<li>
<p>
We implemented the state machine using blocks from the library
<a href=\"modelica://Modelica_StateGraph2\">
Modelica_StateGraph2</a>.
How to use these blocks is explained in the
user's guide of the
<a href=\"modelica://Modelica_StateGraph2\">
Modelica_StateGraph2</a>
library.
</p>
<p>
The figure below shows the state machine.
The oval icons are states, and the black bars
are transitions. The transitions are enabled when their input signal is true.
The red numbers to the right of the transition indicate the delay in seconds.
If a delay is present, the input needs to be true during the entire duration of the delay
for a transition to fire.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System7StateMachine.png\" border=\"1\"/>
</p>
<p>
In our implementation, the state <code>allOff</code> is the initial state,
indicated by its black arrow.
The transition <code>T1</code> is used to switch the pumps on.
Once the pumps are on, transition <code>T2</code> may fire, which
would switch the boiler on.
Hence, the boiler can only be on when the pumps are on.
From the state <code>boilerOn</code>, the only next step can be to
transition to the state <code>pumpsOn</code>.
Once this state has been reached (and hence the boiler is off),
the pumps can be switched off when transition <code>T4</code> fires.
Note that the transitions <code>T3</code> and <code>T4</code>
only fire when their input is true for the entire duration of <i>10</i> seconds.
Hence, the pumps and the boiler must run for at least <i>10</i> seconds
before they can be switched off.
</p>
</li>
</ol>
<!-- ============================================== -->
<p>
When simulating the model
for <i>2</i> days, or <i>172800</i> seconds, the
response shown below should be seen.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System7Temperatures1.png\" border=\"1\"/>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System7Temperatures2.png\" border=\"1\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
July 2, 2015, by Michael Wetter:<br/>
Changed control input for <code>conPIDBoi</code> and set
<code>reverseAction=true</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/436\">#436</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
March 1, 2013, by Michael Wetter:<br/>
Added nominal pressure drop for valves as
this parameter no longer has a default value.
</li>
<li>
April 13, 2012, by Michael Wetter:<br/>
Removed first order filter at boiler pump input.
</li>
<li>
January 27, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-400,-360},{240,
            100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/Boiler/System7.mos"
        "Simulate and plot"),
    experiment(StopTime=172800));
end System7;
