within Buildings.Examples.Tutorial.Boiler;
model System7
  "7th part of the system model, which implements the on/off control using a state machine"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;
  replaceable package MediumW =
      Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=20000
    "Nominal heat flow rate of radiator";
  parameter Modelica.Units.SI.Temperature TRadSup_nominal=273.15 + 50
    "Radiator nominal supply water temperature";
  parameter Modelica.Units.SI.Temperature TRadRet_nominal=273.15 + 40
    "Radiator nominal return water temperature";
  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal=Q_flow_nominal/
      4200/(TRadSup_nominal - TRadRet_nominal)
    "Radiator nominal mass flow rate";

  parameter Modelica.Units.SI.Temperature TBoiSup_nominal=273.15 + 70
    "Boiler nominal supply water temperature";
  parameter Modelica.Units.SI.Temperature TBoiRet_min=273.15 + 60
    "Boiler minimum return water temperature";
  parameter Modelica.Units.SI.MassFlowRate mBoi_flow_nominal=Q_flow_nominal/
      4200/(TBoiSup_nominal - TBoiRet_min) "Boiler nominal mass flow rate";
//------------------------------------------------------------------------------//

//----------------Radiator loop: Three-way valve: mass flow rate----------------//
  parameter Modelica.Units.SI.MassFlowRate mRadVal_flow_nominal=Q_flow_nominal/
      4200/(TBoiSup_nominal - TRadRet_nominal)
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
  parameter Modelica.Units.SI.Volume V=6*10*3 "Room volume";
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=V*1.2*6/3600
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=4000
    "Internal heat gains of the room";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(C=2*V*1.2*1006)
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable timTab(
      extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
      smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
      table=[-6, 0;
              8, QRooInt_flow;
             18, 0],
      timeScale=3600) "Time table for internal heat gain"
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
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mRad_flow_nominal) "Pump for radiator"
      annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-50,-70})));

//----------------------------------------------------------------------------//
  Buildings.Fluid.FixedResistances.Junction mix(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mRadVal_flow_nominal,-mRad_flow_nominal,mRad_flow_nominal
         - mRadVal_flow_nominal},
    dp_nominal={100,-8000,6750}) "Mixer between valve and radiators"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-110})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mBoi_flow_nominal,-mRadVal_flow_nominal,-mBoi_flow_nominal},
    dp_nominal={200,-200,-50}) "Splitter of boiler loop bypass" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-190})));

  Buildings.Fluid.FixedResistances.Junction spl2(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,0,0},
    m_flow_nominal={mRad_flow_nominal,-mRadVal_flow_nominal,-mRad_flow_nominal
         + mRadVal_flow_nominal}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-110})));
  Buildings.Fluid.FixedResistances.Junction mix2(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,-200,0},
    m_flow_nominal={mRadVal_flow_nominal,-mBoi_flow_nominal,mBoi_flow_nominal})
    "Mixer" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-190})));
  Buildings.Fluid.FixedResistances.Junction spl4(
    redeclare package Medium = MediumW,
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
    nominalValuesDefineDefaultPressureCurve=true,
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

  Buildings.Fluid.Sources.Boundary_pT preSou(redeclare package Medium = MediumW,
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
  Buildings.Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mBoi_flow_nominal,-mBoi_flow_nominal,-mBoi_flow_nominal},
    dp_nominal={0,0,-200}) "Splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-230})));

//------------------------------------------------------------------------------------//

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTOut
    "Outdoor temperature sensor"
    annotation (Placement(transformation(extent={{-318,20},{-298,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaRad1(realTrue=mBoi_flow_nominal)
    "Boiler pump signal"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaRad2(realTrue=1)
    "Boiler on/off signal"
    annotation (Placement(transformation(extent={{-100,-340},{-80,-320}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaRad(realTrue=mRad_flow_nominal)
    "Radiator pump signal"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetBoiRet(k=TBoiRet_min)
    "Temperature setpoint for boiler return"
    annotation (Placement(transformation(extent={{120,-270},{140,-250}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPIDBoi(
    Td=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.1,
    Ti=120,
    reverseActing=false) "Controller for valve in boiler loop"
    annotation (Placement(transformation(extent={{160,-270},{180,-250}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPIDRad(
    Td=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.1,
    Ti=120) "Controller for valve in radiator loop"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Buildings.Controls.OBC.CDL.Reals.Line TSetSup
    "Setpoint for supply water temperature"
    annotation (Placement(transformation(extent={{-220,-70},{-200,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupMin(k=273.15 + 21)
    "Minimum heating supply temperature"
    annotation (Placement(transformation(extent={{-260,-100},{-240,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupMax(k=273.15 + 50)
    "Maximum heating supply temperature"
    annotation (Placement(transformation(extent={{-260,-40},{-240,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooMin(k=273.15 + 19)
    "Minimum room air temperature"
    annotation (Placement(transformation(extent={{-260,0},{-240,20}})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-380,60},{-360,80}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-320,60},{-300,80}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));

//-------------------------Step 2: State machine implementation-------------------------//
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "Root of the state graph"
    annotation (Placement(transformation(extent={{-320,-110},{-300,-90}})));
  Modelica.StateGraph.Alternative alternative
    "Split for alternative execution paths"
    annotation (Placement(transformation(extent={{-290,-210},{-154,-130}})));
  Modelica.StateGraph.InitialStepWithSignal allOff(
    nOut=1,
    nIn=1) "System off"
    annotation (Placement(transformation(extent={{-240,-160},{-220,-140}})));
  Modelica.StateGraph.TransitionWithSignal T1 "Transition to switch pumps on"
    annotation (Placement(transformation(extent={{-210,-160},{-190,-140}})));
  Modelica.StateGraph.StepWithSignal boilerOn(
    nIn=1,
    nOut=1) "Boiler is on"
    annotation (Placement(transformation(extent={{-228,-200},{-208,-180}})));
  Modelica.StateGraph.TransitionWithSignal T2 "Transition to boiler on"
    annotation (Placement(transformation(extent={{-258,-200},{-238,-180}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThrBoi(t=273.15 +
        90) "Threshold for boiler control"
    annotation (Placement(transformation(extent={{-420,-320},{-400,-300}})));
  Modelica.StateGraph.TransitionWithSignal T3(
    waitTime=10, enableTimer=true) "Transition to switch boiler off"
    annotation (Placement(transformation(extent={{-196,-200},{-176,-180}})));
  Modelica.StateGraph.TransitionWithSignal T4(
    waitTime=10, enableTimer=true) "Transition to all off"
    annotation (Placement(transformation(extent={{-270,-160},{-250,-140}})));
  Modelica.StateGraph.Step pumpsOn(nIn=1, nOut=1) "Pumps are on"
    annotation (Placement(transformation(extent={{-320,-180},{-300,-160}})));
//--------------------------------------------------------------------------------------//
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lessThreshold(t=273.15 +
        19)
    annotation (Placement(transformation(extent={{-420,-210},{-400,-190}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lessThreshold1(t=273.15
         + 16)
    annotation (Placement(transformation(extent={{-420,-240},{-400,-220}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    annotation (Placement(transformation(extent={{-380,-232},{-360,-212}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lessThreshold2(t=273.15
         + 70) "Threshold for boiler control"
    annotation (Placement(transformation(extent={{-420,-290},{-400,-270}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThrTRoo(t=273.15 +
        21) "Threshold for room temperature"
    annotation (Placement(transformation(extent={{-420,-130},{-400,-110}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThrTROut(t=273.15
         + 17) "Threshold for room temperature"
    annotation (Placement(transformation(extent={{-420,-160},{-400,-140}})));
  Controls.OBC.CDL.Logical.Or or1
    "Switch off system if outside is sufficiently warm, or room is sufficiently warm"
    annotation (Placement(transformation(extent={{-380,-152},{-360,-132}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Negate output of hysteresis"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));

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
      points={{2,80},{20,80}},
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
      points={{-78,-330},{40,-330},{40,-302},{22,-302}},
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
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, TOut.T) annotation (Line(
      points={{-310,70},{-262,70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
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
      points={{-219.5,-150},{-204,-150}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(temRoo.T, lessThreshold.u) annotation (Line(
      points={{-51,30},{-270,30},{-270,-10},{-440,-10},{-440,-200},{-422,-200}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lessThreshold1.u, senTOut.T) annotation (Line(
      points={{-422,-230},{-446,-230},{-446,10},{-297,10},{-297,30}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(lessThreshold.y, and3.u1) annotation (Line(
      points={{-398,-200},{-390,-200},{-390,-222},{-382,-222}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(lessThreshold1.y, and3.u2) annotation (Line(
      points={{-398,-230},{-382,-230}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(boi.T, lessThreshold2.u) annotation (Line(
      points={{-1,-302},{-20,-302},{-20,-348},{-432,-348},{-432,-280},{-422,-280}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.outPort, boilerOn.inPort[1]) annotation (Line(
      points={{-246.5,-190},{-229,-190}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(boi.T, greThrBoi.u) annotation (Line(
      points={{-1,-302},{-20,-302},{-20,-348},{-432,-348},{-432,-310},{-422,-310}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boilerOn.outPort[1], T3.inPort) annotation (Line(
      points={{-207.5,-190},{-190,-190}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(temRoo.T, greThrTRoo.u) annotation (Line(
      points={{-51,30},{-270,30},{-270,-10},{-440,-10},{-440,-120},{-422,-120}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(senTOut.T, greThrTROut.u) annotation (Line(
      points={{-297,30},{-297,10},{-446,10},{-446,-150},{-422,-150}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(greThrTRoo.y, or1.u1) annotation (Line(
      points={{-398,-120},{-392,-120},{-392,-142},{-382,-142}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(greThrTROut.y, or1.u2) annotation (Line(
      points={{-398,-150},{-382,-150}},
      color={255,0,255},
      smooth=Smooth.None));

  connect(not1.y, booToReaRad.u) annotation (Line(
      points={{-158,-90},{-140,-90},{-140,-70},{-122,-70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not1.y, booToReaRad1.u) annotation (Line(
      points={{-158,-90},{-140,-90},{-140,-110},{-122,-110}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(T4.outPort, allOff.inPort[1]) annotation (Line(
      points={{-258.5,-150},{-241,-150}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(conPIDRad.y, valRad.y) annotation (Line(
      points={{-158,-10},{-80,-10},{-80,-150},{-62,-150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToReaRad.y, pumRad.m_flow_in) annotation (Line(
      points={{-98,-70},{-90.5,-70},{-90.5,-70},{-62,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conPIDBoi.y, valBoi.y) annotation (Line(
      points={{182,-260},{200,-260},{200,-230},{72,-230}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToReaRad1.y, pumBoi.m_flow_in) annotation (Line(
      points={{-98,-110},{-90,-110},{-90,-280},{-62,-280}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetBoiRet.y, conPIDBoi.u_s)
    annotation (Line(points={{142,-260},{158,-260}}, color={0,0,127}));
  connect(temRet.T, conPIDBoi.u_m) annotation (Line(points={{71,-280},{120,-280},
          {170,-280},{170,-272}}, color={0,0,127}));
  connect(T1.condition, and3.y) annotation (Line(points={{-200,-162},{-200,-162},
          {-200,-222},{-358,-222}},                         color={255,0,255}));
  connect(booToReaRad2.u, boilerOn.active) annotation (Line(points={{-102,-330},
          {-102,-330},{-218,-330},{-218,-201}}, color={255,0,255}));
  connect(lessThreshold2.y, T2.condition) annotation (Line(points={{-398,-280},
          {-398,-280},{-332,-280},{-248,-280},{-248,-202}},color={255,0,255}));
  connect(T4.condition, or1.y) annotation (Line(points={{-260,-162},{-260,-162},
          {-260,-170},{-260,-216},{-338,-216},{-338,-142},{-358,-142}}, color={255,
          0,255}));
  connect(T3.condition, greThrBoi.y) annotation (Line(points={{-186,-202},{-186,
          -202},{-186,-310},{-398,-310}}, color={255,0,255}));
  connect(allOff.active, not1.u) annotation (Line(points={{-230,-161},{-230,
          -166},{-210,-166},{-210,-90},{-182,-90}},
                                              color={255,0,255}));
  connect(pumpsOn.outPort[1], alternative.inPort)
    annotation (Line(points={{-299.5,-170},{-292.04,-170}}, color={0,0,0}));
  connect(alternative.outPort, pumpsOn.inPort[1]) annotation (Line(points={{-152.64,
          -170},{-146,-170},{-146,-120},{-328,-120},{-328,-170},{-321,-170}},
        color={0,0,0}));
  connect(T4.inPort, alternative.split[1]) annotation (Line(points={{-264,-150},
          {-264,-170},{-275.72,-170}}, color={0,0,0}));
  connect(T2.inPort, alternative.split[2]) annotation (Line(points={{-252,-190},
          {-275.72,-190},{-275.72,-170}},
                                       color={0,0,0}));
  connect(T1.outPort, alternative.join[1])
    annotation (Line(points={{-198.5,-150},{-184,-150},{-184,-170},{-168.28,
          -170}},                                           color={0,0,0}));
  connect(T3.outPort, alternative.join[2])
    annotation (Line(points={{-184.5,-190},{-176,-190},{-176,-170},{-168.28,
          -170}},                                           color={0,0,0}));
  connect(TSetSup.x1,TRooMin. y) annotation (Line(points={{-222,-52},{-230,-52},
          {-230,10},{-238,10}},
                              color={0,0,127}));
  connect(TSupMax.y,TSetSup. f1) annotation (Line(points={{-238,-30},{-234,-30},
          {-234,-56},{-222,-56}}, color={0,0,127}));
  connect(TSupMin.y,TSetSup. f2) annotation (Line(points={{-238,-90},{-230,-90},
          {-230,-68},{-222,-68}}, color={0,0,127}));
  connect(TSupMin.y,TSetSup. x2) annotation (Line(points={{-238,-90},{-230,-90},
          {-230,-64},{-222,-64}}, color={0,0,127}));
  connect(TSetSup.u, temRoo.T) annotation (Line(points={{-222,-60},{-270,-60},{-270,
          30},{-51,30}}, color={0,0,127}));
  connect(conPIDRad.u_s,TSetSup. y) annotation (Line(points={{-182,-10},{-188,-10},
          {-188,-60},{-198,-60}}, color={0,0,127}));
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
<a href=\"modelica://Modelica.StateGraph\">
Modelica.StateGraph</a>.
How to use these blocks is explained in
<a href=\"modelica://Modelica.StateGraph.UsersGuide\">
Modelica.StateGraph.UsersGuide</a>.
</p>
<p>
The figure below shows the state machine.
The square icons are states, and the black bars
are transitions. The initial state is indicated by the double frame.
The transitions are enabled when their input signal is true.
The numbers to the right of the transition indicate the delay in seconds.
If a delay is present, the input needs to be true during the entire duration of the delay
for a transition to fire. The active state is rendered green.
Some states have a Boolean output signal that is used to switch
components such as the pumps and the boiler on or off.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System7StateMachine.png\" border=\"1\"/>
</p>
<p>
In our implementation, the state <code>allOff</code> is the initial state,
indicated by its double frame.
The transition <code>T1</code> is used to switch the pumps on.
Once the <code>pumpsOn</code> state is active, there are two alternate
paths. Either transition <code>T2</code> may fire, which
would switch the boiler on, or <code>T4</code> may fire, which would return
to the <code>allOff</code> state.
Hence, the boiler can only be on when the pumps are on.
From the state <code>boilerOn</code>, the only next step can be to
transition to the state <code>pumpsOn</code>.
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
April 9, 2024, by Hongxiang Fu:<br/>
Added nominal curve specification to suppress warning.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
</li>
<li>
February 15, 2022, by Michael Wetter:<br/>
Changed block downstream of <code>greThrTRoo</code> from <code>and</code> to <code>or</code> block.
This ensures that the system is off when the outdoor air or room air is sufficiently warm.
</li>
<li>
March 6, 2017, by Michael Wetter:<br/>
Added missing density to computation of air mass flow rate.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/673\">#673</a>.
</li>
<li>
April 6, 2016, by Michael Wetter:<br/>
Replaced <code>Modelica_StateGraph2</code> with <code>Modelica.StateGraph</code>.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/504\">issue 504</a>.
</li>
<li>
July 2, 2015, by Michael Wetter:<br/>
Changed control input for <code>conPIDBoi</code> and set
<code>reverseActing=false</code>
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
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-460,-360},{240,
            100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/Boiler/System7.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-07));
end System7;
