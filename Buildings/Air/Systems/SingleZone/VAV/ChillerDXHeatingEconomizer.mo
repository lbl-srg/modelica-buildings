within Buildings.Air.Systems.SingleZone.VAV;
model ChillerDXHeatingEconomizer
  "HVAC system model with a dry cooling coil, air-cooled chiller, electric heating coil, variable speed fan, and mixing box with economizer control."
  replaceable package MediumA = Buildings.Media.Air "Medium model for air"
      annotation (choicesAllMatching = true);
  replaceable package MediumW = Buildings.Media.Water "Medium model for water"
      annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.DimensionlessRatio COP_nominal = 5.5
    "Nominal COP of the chiller";

  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal "Design airflow rate of system"
    annotation(Dialog(group="Air design"));
  parameter Real minAirFlo(
    min=0,
    max=1,
    unit="1") = 0.2
    "Minimum airflow rate of system"
    annotation(Dialog(group="Air design"));

  parameter Modelica.SIunits.DimensionlessRatio minOAFra "Minimum outdoor air fraction of system"
    annotation(Dialog(group="Air design"));

  parameter Modelica.SIunits.Temperature TSetSupAir "Cooling supply air temperature setpoint"
    annotation(Dialog(group="Air design"));

  parameter Modelica.SIunits.Temperature TSetSupChi "Chilled water supply temperature setpoint"
    annotation(Dialog(group="Cooling design"));

  parameter Modelica.SIunits.Power QHea_flow_nominal(min=0) "Design heating capacity of heating coil"
    annotation(Dialog(group="Heating design"));

  parameter Real etaHea_nominal(min=0, max=1, unit="1") "Design heating efficiency of the heating coil"
    annotation(Dialog(group="Heating design"));

  parameter Modelica.SIunits.Power QCoo_flow_nominal(max=0) "Design heating capacity of cooling coil"
    annotation(Dialog(group="Cooling design"));

  parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa") = 500
    "Design pressure drop of flow leg with fan"
    annotation(Dialog(group="Air design"));

  // fixme: change to kP
  parameter Real kPHea(min=Modelica.Constants.small) = 2
    "Proportional gain of heating controller"
    annotation(Dialog(group="Control gain"));
  parameter Real kPCoo(min=Modelica.Constants.small)=1
    "Gain of controller for cooling valve"
    annotation(Dialog(group="Control gain"));

  parameter Real kPFan(min=Modelica.Constants.small) = 0.5
    "Gain of controller for fan"
    annotation(Dialog(group="Control gain"));
  parameter Real kPEco(min=Modelica.Constants.small) = 4
    "Gain of controller for economizer"
    annotation(Dialog(group="Control gain"));

    // fixme: use cp
  final parameter Modelica.SIunits.MassFlowRate mChiEva_flow_nominal=
    -QCoo_flow_nominal/4184/4
    "Design chilled water supply flow";

  final parameter Modelica.SIunits.MassFlowRate mChiCon_flow_nominal=
    -QCoo_flow_nominal*(1+1/COP_nominal)/1008/10 "Design condenser air flow";

  Modelica.Blocks.Interfaces.RealInput TRoo(
    final unit="K",
    displayUnit="degC") "Zone temperature measurement"
  annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,0})));
  Modelica.Blocks.Interfaces.RealInput TSetRooHea(
    final unit="K",
    displayUnit="degC")
    "Zone heating setpoint temperature" annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-220,140})));
  Modelica.Blocks.Interfaces.RealInput TSetRooCoo(
    final unit="K",
    displayUnit="degC")
    "Zone cooling setpoint temperature" annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-220,80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSup(
    m_flow_nominal=mAir_flow_nominal,
    allowFlowReversal=false,
    tau=0,
    redeclare package Medium = MediumA) "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{128,38},{148,58}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoi(
    m_flow_nominal=mAir_flow_nominal,
    Q_flow_nominal=QHea_flow_nominal,
    u(start=0),
    dp_nominal=0,
    allowFlowReversal=false,
    tau=90,
    redeclare package Medium = MediumA,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true)
     "Air heating coil"
    annotation (Placement(transformation(extent={{52,38},{72,58}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
  annotation (Placement(
        transformation(extent={{-190,148},{-150,188}}), iconTransformation(
          extent={{-180,160},{-160,180}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow fanSup(
    m_flow_nominal=mAir_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=875,
    per(use_powerCharacteristic=false),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    use_inputFilter=false,
    redeclare package Medium = MediumA) "Supply fan"
    annotation (Placement(transformation(extent={{-32,38},{-12,58}})));
  Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerHeatingCooling conSup(
    minAirFlo = minAirFlo,
    kPHea = kPHea,
    kPFan = kPFan) "Heating coil, cooling coil and fan controller"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Buildings.Fluid.FixedResistances.PressureDrop totalRes(
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=dp_nominal,
    allowFlowReversal=false,
    redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{10,38},{30,58}})));

  Modelica.Blocks.Interfaces.RealOutput PFan(final unit="W")
    "Electrical power consumed by the supply fan"
    annotation (Placement(transformation(extent={{200,130},{220,150}}),
        iconTransformation(extent={{200,130},{220,150}})));

  Modelica.Blocks.Interfaces.RealOutput QHea_flow(final unit="W")
    "Electrical power consumed by the heating equipment" annotation (Placement(
        transformation(extent={{200,110},{220,130}}), iconTransformation(extent=
           {{200,110},{220,130}})));

  Modelica.Blocks.Interfaces.RealOutput PCoo(final unit="W")
    "Electrical power consumed by the cooling equipment" annotation (Placement(
        transformation(extent={{200,90},{220,110}}), iconTransformation(extent={
            {200,90},{220,110}})));

  Modelica.Blocks.Math.Gain eff(k=1/etaHea_nominal)
    annotation (Placement(transformation(extent={{120,90},{140,110}})));

  Buildings.Fluid.Sensors.MassFlowRate senMRetAir_flow(
    allowFlowReversal=false,
    redeclare package Medium = MediumA)
    "Return air mass flow rate sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-12})));

  Buildings.Fluid.Sensors.MassFlowRate senMExhAir_flow(
    allowFlowReversal=false,
    redeclare package Medium = MediumA)
    "Exhaust air mass flow rate"
    annotation (Placement(transformation(extent={{-20,-110},{-40,-90}})));

  Buildings.Fluid.Sensors.MassFlowRate senMOutAir_flow(
    allowFlowReversal=false,
    redeclare package Medium = MediumA)
    "Outdoor air mass flow rate sensor"
    annotation (Placement(transformation(extent={{-100,38},{-80,58}})));

  Buildings.Fluid.Sources.Outside out(
    nPorts=3,
    redeclare package Medium = MediumA)
    "Boundary conditions for outside air"
    annotation (Placement(transformation(extent={{-140,36},{-120,56}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTMixAir(
    m_flow_nominal=mAir_flow_nominal,
    allowFlowReversal=false,
    tau=0,
    redeclare package Medium = MediumA)
    "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-60,38},{-40,58}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource souMRelAir_flow(
    control_m_flow=true,
    allowFlowReversal=false,
    m_flow_small=1E-4,
    redeclare package Medium = MediumA,
    control_dp=false)
    "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-80,-110},{-100,-90}})));

  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU cooCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    dp1_nominal=0,
    dp2_nominal=0,
    m2_flow_nominal=mAir_flow_nominal,
    Q_flow_nominal=-QCoo_flow_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=mChiEva_flow_nominal,
    show_T=true,
    T_a1_nominal=279.15,
    T_a2_nominal=298.15)
    "Cooling coil"
    annotation (Placement(transformation(extent={{110,52},{90,32}})));

  Buildings.Fluid.Sources.MassFlowSource_T souChiWat(
    redeclare package Medium = MediumA,
    nPorts=1,
    use_T_in=true,
    m_flow=mChiCon_flow_nominal)
    "Mass flow source for chiller"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={138,-174})));

  Modelica.Blocks.Sources.Constant TSetSupAirConst(final k=TSetSupAir)
    "Set point for supply air temperature"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));

  Buildings.Controls.Continuous.LimPID conCooVal(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=1,
    yMin=0,
    k=kPCoo,
    reverseAction=true)
    "Cooling coil valve controller"
    annotation (Placement(transformation(extent={{28,0},{48,20}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pumChiWat(
    use_inputFilter=false,
    allowFlowReversal=false,
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=mChiEva_flow_nominal,
    addPowerToMedium=false,
    per(
      hydraulicEfficiency(eta={1}),
      motorEfficiency(eta={0.9}),
      motorCooledByFluid=false),
    dp_nominal=12000,
    inputType=Buildings.Fluid.Types.InputType.Continuous)
    "Pump for chilled water loop"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={120,-90})));

  Buildings.Fluid.Chillers.ElectricEIR chi(
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumW,
    m2_flow_nominal=mChiEva_flow_nominal,
    dp1_nominal=0,
    m1_flow_nominal=mChiCon_flow_nominal,
    per(
      capFunT={1.0433811,0.0407077,0.0004506,-0.0041514,-8.86e-5,-0.0003467},
      PLRMax=1.2,
      EIRFunT={0.5961915,-0.0099496,0.0007888,0.0004506,0.0004875,-0.0007623},
      EIRFunPLR={1.6853121,-0.9993443,0.3140322},
      COP_nominal=COP_nominal,
      QEva_flow_nominal=QCoo_flow_nominal,
      mEva_flow_nominal=mChiEva_flow_nominal,
      mCon_flow_nominal=mChiCon_flow_nominal,
      TEvaLvg_nominal=TSetSupChi,
      PLRMinUnl=0.1,
      PLRMin=0.1,
      etaMotor=1,
      TEvaLvgMin=274.15,
      TEvaLvgMax=293.15,
      TConEnt_nominal=302.55,
      TConEntMin=274.15,
      TConEntMax=323.15),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp2_nominal=12E3)
    "Air cooled chiller"
    annotation (Placement(transformation(extent={{110,-158},{90,-178}})));

  Modelica.Blocks.Sources.Constant TSetSupChiConst(final k=TSetSupChi)
    "Set point for chiller temperature"
    annotation (Placement(transformation(extent={{160,-140},{140,-120}})));

  Modelica.Blocks.Interfaces.RealOutput PPum(final unit="W")
    "Electrical power consumed by the pumps"
    annotation (Placement(transformation(extent={{200,70},{220,90}})));

  Buildings.Fluid.Sources.FixedBoundary bouPreChi(
    redeclare package Medium = MediumW, nPorts=1)
    "Pressure boundary condition for chilled water loop"
    annotation (Placement(transformation(extent={{42,-172},{62,-152}})));

  Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerEconomizer conEco(
      kPEco = kPEco) "Economizer control"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  Modelica.Blocks.Math.Product ecoPro
    "Product for computation of economizer mass flow rate"
    annotation (Placement(transformation(extent={{-40,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Constant conMinOAFra(final k=minOAFra)
    "Minimum outside air fraction"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_a supplyAir(
    redeclare final package Medium = MediumA) "Supply air"
    annotation (Placement(transformation(extent={{190,30},{210,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b returnAir(
    redeclare final package Medium = MediumA) "Return air"
    annotation (Placement(transformation(extent={{190,-50},{210,-30}})));

  Modelica.Blocks.Math.Gain gaiFan(k=mAir_flow_nominal)
    "Gain for fan mass flow rate"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));

  Modelica.Blocks.Math.BooleanToReal booleanToInteger(
    realTrue=mChiEva_flow_nominal)
    annotation (Placement(transformation(extent={{50,-100},{70,-80}})));

  BaseClasses.HysteresisWithDelay hysChiPla(
    waitTimeToOn=0,
    uLow=0,
    uHigh=1)    "Hysteresis with delay to switch on cooling"
    annotation (Placement(transformation(extent={{12,-150},{32,-130}})));

  IdealValve ideVal(
    redeclare package MediumW = MediumW,
    final mChiEva_flow_nominal = mChiEva_flow_nominal) "Ideal valve"
    annotation (Placement(transformation(rotation=0, extent={{70,0},{90,20}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTRet(
    m_flow_nominal=mAir_flow_nominal,
    allowFlowReversal=false,
    tau=0,
    redeclare package Medium = MediumA) "Return air temperature sensor"
    annotation (Placement(transformation(extent={{30,-50},{10,-30}})));
equation
  connect(TSetRooHea,conSup. TSetRooHea) annotation (Line(points={{-220,140},{-160,
          140},{-160,16},{-141,16}}, color={0,0,127}));
  connect(TSetRooCoo,conSup. TSetRooCoo) annotation (Line(points={{-220,80},{-202,
          80},{-178,80},{-178,10},{-141,10}}, color={0,0,127}));
  connect(TRoo,conSup.TRoo)  annotation (Line(points={{-220,0},{-181,0},{-181,4},
          {-141,4}},        color={0,0,127}));
  connect(fanSup.port_b, totalRes.port_a)
    annotation (Line(points={{-12,48},{10,48}},  color={0,127,255}));
  connect(fanSup.P, PFan) annotation (Line(points={{-11,57},{-6,57},
          {-6,140},{210,140}},
                             color={0,0,127}));
  connect(eff.y, QHea_flow) annotation (Line(points={{141,100},{160,100},{160,120},
          {210,120}}, color={0,0,127}));
  connect(senMOutAir_flow.port_a, out.ports[1]) annotation (Line(points={{-100,48},
          {-120,48},{-120,48.6667}},
                          color={0,127,255}));
  connect(weaBus, out.weaBus) annotation (Line(
      points={{-170,168},{-170,168},{-170,46},{-140,46},{-140,46.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(senTMixAir.port_b, fanSup.port_a)
    annotation (Line(points={{-40,48},{-40,48},{-32,48}}, color={0,127,255}));
  connect(senMOutAir_flow.port_b, senTMixAir.port_a)
    annotation (Line(points={{-80,48},{-70,48},{-60,48}}, color={0,127,255}));
  connect(senMRetAir_flow.port_b, senTMixAir.port_a)
    annotation (Line(points={{-70,-2},{-70,48},{-60,48}},color={0,127,255}));
  connect(heaCoi.Q_flow, eff.u) annotation (Line(points={{73,54},{80,54},{80,100},
          {86,100},{108,100},{118,100}},          color={0,0,127}));
  connect(conSup.yHea, heaCoi.u) annotation (Line(points={{-119,16},{-104,16},{-104,
          82},{38,82},{44,82},{44,54},{50,54}}, color={0,0,127}));
  connect(souMRelAir_flow.port_a, senMExhAir_flow.port_b)
    annotation (Line(points={{-80,-100},{-70,-100},{-60,-100},{-40,-100}},
                                                   color={0,127,255}));
  connect(souMRelAir_flow.port_b, out.ports[2]) annotation (Line(points={{-100,
          -100},{-108,-100},{-108,46},{-120,46}},     color={0,127,255}));
  connect(senMRetAir_flow.port_a, senMExhAir_flow.port_b) annotation (Line(
        points={{-70,-22},{-70,-100},{-40,-100}},
                                                color={0,127,255}));
  connect(heaCoi.port_b, cooCoi.port_a2)
    annotation (Line(points={{72,48},{90,48}}, color={0,127,255}));
  connect(cooCoi.port_b2, senTSup.port_a)
    annotation (Line(points={{110,48},{120,48},{128,48}}, color={0,127,255}));
  connect(cooCoi.port_b1, ideVal.port_1) annotation (Line(
      points={{90,36},{80,36},{80,20}},
      color={0,0,255},
      thickness=0.5));
  connect(senTSup.T, conCooVal.u_m) annotation (Line(points={{138,59},{138,70},{
          160,70},{160,-34},{38,-34},{38,-2}},         color={0,0,127}));
  connect(TSetSupAirConst.y, conCooVal.u_s)
    annotation (Line(points={{-139,-70},{-22,-70},{-22,10},{26,10}},
                                                         color={0,0,127}));
  connect(chi.port_b2, pumChiWat.port_a) annotation (Line(points={{110,-162},{120,
          -162},{120,-100}},            color={0,0,255},
      thickness=0.5));
  connect(souChiWat.ports[1], chi.port_a1) annotation (Line(points={{128,-174},
          {128,-174},{110,-174}},       color={0,127,255}));
  connect(chi.port_b1, out.ports[3]) annotation (Line(points={{90,-174},{-14,
          -174},{-112,-174},{-112,43.3333},{-120,43.3333}},      color={0,127,255}));
  connect(weaBus.TDryBul, souChiWat.T_in) annotation (Line(
      points={{-170,168},{-172,168},{-172,-200},{160,-200},{160,-170},{150,-170}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(TSetSupChiConst.y, chi.TSet) annotation (Line(points={{139,-130},{124,
          -130},{124,-165},{112,-165}},            color={0,0,127}));
  connect(pumChiWat.P, PPum) annotation (Line(points={{111,-79},{111,-52},{180,-52},
          {180,80},{210,80}},      color={0,0,127}));
  connect(chi.P, PCoo) annotation (Line(points={{89,-177},{84,-177},{84,-128},{
          98,-128},{98,-50},{178,-50},{178,100},{210,100}},
        color={0,0,127}));
  connect(PPum, PPum)
    annotation (Line(points={{210,80},{210,80}},          color={0,0,127}));
  connect(senMExhAir_flow.m_flow, ecoPro.u2) annotation (Line(points={{-30,-89},
          {-30,-56},{-38,-56}},           color={0,0,127}));
  connect(ecoPro.y, souMRelAir_flow.m_flow_in)
    annotation (Line(points={{-61,-50},{-84,-50},{-84,-92}}, color={0,0,127}));
  connect(conEco.yOutAirFra, ecoPro.u1) annotation (Line(points={{-119,-30},{
          -32,-30},{-32,-44},{-38,-44}},       color={0,0,127}));
  connect(conMinOAFra.y, conEco.minOAFra) annotation (Line(points={{-179,-40},{
          -152,-40},{-152,-30},{-141,-30}}, color={0,0,127}));
  connect(senTMixAir.T, conEco.T_mix) annotation (Line(points={{-50,59},{-50,72},
          {-152,72},{-152,-25},{-141,-25}}, color={0,0,127}));
  connect(TSetSupAirConst.y, conEco.T_mixSet) annotation (Line(points={{-139,
          -70},{-128,-70},{-128,-50},{-146,-50},{-146,-22},{-141,-22}}, color={
          0,0,127}));
  connect(weaBus.TDryBul, conEco.T_oa) annotation (Line(
      points={{-170,168},{-172,168},{-172,-34},{-141,-34}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(conSup.yHea, conEco.yHea) annotation (Line(points={{-119,16},{-104,16},
          {-104,-8},{-164,-8},{-164,-38},{-141,-38}}, color={0,0,127}));
  connect(ideVal.port_2, chi.port_a2)
    annotation (Line(points={{80,0},{80,-162},{90,-162}}, color={0,127,255}));
  connect(cooCoi.port_a1, pumChiWat.port_b) annotation (Line(points={{110,36},{120,
          36},{120,-80}},              color={0,127,255}));
  connect(cooCoi.port_a1, ideVal.port_3) annotation (Line(points={{110,36},{120,
          36},{120,10},{90,10}}, color={0,127,255}));
  connect(bouPreChi.ports[1], chi.port_a2) annotation (Line(points={{62,-162},{
          76,-162},{90,-162}}, color={0,127,255}));
  connect(totalRes.port_b, heaCoi.port_a)
    annotation (Line(points={{30,48},{52,48}}, color={0,127,255}));
  connect(senTSup.port_b, supplyAir) annotation (Line(points={{148,48},{174,48},
          {174,40},{200,40}}, color={0,127,255}));
  connect(conCooVal.y, ideVal.y)
    annotation (Line(points={{49,10},{69,10}}, color={0,0,127}));
  connect(conSup.yFan, gaiFan.u) annotation (Line(points={{-119,4},{-108,4},{-108,
          110},{-82,110}}, color={0,0,127}));
  connect(gaiFan.y, fanSup.m_flow_in)
    annotation (Line(points={{-59,110},{-22,110},{-22,60}}, color={0,0,127}));
  connect(booleanToInteger.y, pumChiWat.m_flow_in)
    annotation (Line(points={{71,-90},{108,-90}}, color={0,0,127}));
  connect(booleanToInteger.u, hysChiPla.on) annotation (Line(points={{48,-90},{40,
          -90},{40,-140},{33,-140}}, color={255,0,255}));
  connect(hysChiPla.on, chi.on) annotation (Line(points={{33,-140},{40,-140},{40,
          -188},{118,-188},{118,-171},{112,-171}}, color={255,0,255}));
protected
  model IdealValve
    replaceable package MediumW = Media.Water "Medium model for water"
        annotation (choicesAllMatching = true);
    parameter Modelica.SIunits.MassFlowRate mChiEva_flow_nominal
      "Design chilled water supply flow";
    Modelica.Fluid.Interfaces.FluidPort_a port_1(redeclare package Medium =
          MediumW) annotation (Placement(transformation(rotation=0, extent={{90,150},
              {110,170}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_2(redeclare package Medium =
          MediumW) annotation (Placement(transformation(rotation=0, extent={{90,-50},
              {110,-30}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_3(redeclare package Medium =
          MediumW) annotation (Placement(transformation(rotation=0, extent={{190,50},
              {210,70}})));
    Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) annotation (Placement(
          transformation(rotation=0, extent={{-20,50},{0,70}})));
    Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = MediumW,
        allowFlowReversal=false)
      "Mass flow rate sensor" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={100,10})));
    Fluid.Movers.BaseClasses.IdealSource preMasFlo(
      redeclare package Medium = MediumW,
      control_m_flow=true,
      control_dp=false,
      m_flow_small=mChiEva_flow_nominal*1E-5,
      show_V_flow=false,
      allowFlowReversal=false)
                        "Prescribed mass flow rate for the bypass" annotation (
        Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=180,
          origin={150,60})));
    Modelica.Blocks.Math.Product pro "Product for mass flow rate computation"
      annotation (Placement(transformation(extent={{72,64},{92,84}})));
    Modelica.Blocks.Sources.Constant one(final k=1) "Outputs one"
      annotation (Placement(transformation(extent={{10,70},{30,90}})));
    Modelica.Blocks.Math.Feedback feedback
      annotation (Placement(transformation(extent={{40,70},{60,90}})));
  equation
    connect(senMasFlo.m_flow, pro.u2) annotation (Line(points={{89,10},{74,10},{74,
            10},{60,10},{60,68},{70,68}}, color={0,0,127}));
    connect(feedback.u1, one.y)
      annotation (Line(points={{42,80},{31,80}}, color={0,0,127}));
    connect(y, feedback.u2)
      annotation (Line(points={{-10,60},{50,60},{50,72}}, color={0,0,127}));
    connect(preMasFlo.port_a, port_3)
      annotation (Line(points={{160,60},{200,60}}, color={0,127,255}));
    connect(feedback.y, pro.u1)
      annotation (Line(points={{59,80},{70,80}}, color={0,0,127}));
    connect(pro.y, preMasFlo.m_flow_in)
      annotation (Line(points={{93,74},{156,74},{156,68}}, color={0,0,127}));
    connect(port_1, senMasFlo.port_a)
      annotation (Line(points={{100,160},{100,20}}, color={0,127,255}));
    connect(senMasFlo.port_b, port_2)
      annotation (Line(points={{100,0},{100,-40}}, color={0,127,255}));
    connect(preMasFlo.port_b, senMasFlo.port_a) annotation (Line(points={{140,
            60},{100,60},{100,20}}, color={0,127,255}));
    annotation (Diagram(coordinateSystem(extent={{0,-40},{200,160}})), Icon(
          coordinateSystem(extent={{0,-40},{200,160}})));
  end IdealValve;
equation
  connect(feedback.y, hysChiPla.u)
    annotation (Line(points={{-41,-140},{11,-140}}, color={0,0,127}));
  connect(feedback.u1, TRoo) annotation (Line(points={{-58,-140},{-174,-140},{
          -174,0},{-220,0}}, color={0,0,127}));
  connect(TSetRooCoo, feedback.u2) annotation (Line(points={{-220,80},{-178,80},
          {-178,-160},{-50,-160},{-50,-148}}, color={0,0,127}));
  connect(returnAir, senTRet.port_a)
    annotation (Line(points={{200,-40},{30,-40}}, color={0,127,255}));
  connect(senTRet.port_b, senMExhAir_flow.port_a) annotation (Line(points={{10,
          -40},{0,-40},{0,-100},{-20,-100}}, color={0,127,255}));
  connect(conEco.TRet, senTRet.T) annotation (Line(points={{-141,-27.2},{-154,
          -27.2},{-154,-14},{-92,-14},{-92,-24},{20,-24},{20,-29}}, color={0,0,
          127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -220},{200,160}}),
                         graphics={
        Rectangle(
          extent={{-200,160},{-160,-160}},
          lineColor={0,0,0},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-160,160},{200,-160}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{180,40},{-160,0}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,36},{-4,22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{180,-72},{-160,-112}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,0},{-120,-72}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-48,36},{-14,2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-38,26},{-24,12}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,40},{54,0}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{102,40},{116,0}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{42,54},{52,46}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{38,56},{56,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Backward),
        Line(points={{44,56},{44,60}}, color={0,0,0}),
        Line(points={{50,56},{50,60}}, color={0,0,0}),
        Line(points={{48,40},{48,48}}, color={0,0,0}),
        Rectangle(
          extent={{-140,40},{-126,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-140,-72},{-126,-112}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,20},{7,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={-100,-37},
          rotation=90),
        Line(points={{-160,160},{-160,-160}}, color={0,0,0}),
        Line(points={{200,100},{86,100},{86,46}},   color={0,0,127}),
        Line(points={{200,118},{48,118},{48,68}}, color={0,0,127}),
        Line(points={{200,140},{-30,140},{-30,50}}, color={0,0,127}),
        Line(points={{104,0},{104,-66}}, color={0,0,255}),
        Line(points={{114,0},{114,-66}}, color={0,0,255}),
        Line(points={{104,-26},{114,-26}}, color={0,0,255}),
        Polygon(
          points={{-3,4},{-3,-4},{3,0},{-3,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={115,-24},
          rotation=-90),
        Polygon(
          points={{110,-22},{110,-30},{116,-26},{110,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4,-3},{4,-3},{0,3},{-4,-3}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={115,-28},
          rotation=0),
        Line(points={{116,-26},{122,-26}}, color={0,0,0}),
        Line(points={{122,-24},{122,-30}}, color={0,0,0}),
        Ellipse(
          extent={{96,-124},{124,-152}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{110,-124},{98,-144},{122,-144},{110,-124}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{114,-116},{114,-124}},
                                         color={0,0,255}),
        Line(points={{104,-116},{104,-124}},
                                         color={0,0,255}),
        Ellipse(
          extent={{84,-148},{110,-158}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{110,-148},{136,-158}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{108,-48},{120,-58}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{114,-48},{110,-56},{118,-56},{114,-48}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{200,80},{132,80},{132,46}},   color={0,0,127}),
        Line(points={{124,-54},{132,-54},{132,-4}}, color={0,0,127}),
        Line(points={{92,-136},{86,-136},{86,-4}},  color={0,0,127})}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-220},{200,
            160}})),
    experiment(
      StopTime=518400,
      Interval=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
      Documentation(info="<html>
<p>
This is a conventional single zone VAV HVAC system model. The system contains
a variable speed supply fan, electric heating coil, water-based cooling coil,
economizer, and air-cooled chiller. The control of the system is that of
conventional VAV heating and cooling. During cooling, the supply air
temperature is held constant while the supply air flow is modulated from
maximum to minimum according to zone load. This is done by modulating the
fan speed. During heating, the supply air flow is held at a constant minimum
while the heating coil is modulated accoding to zone load. The mass flow of
chilled water through the cooling coil is controlled by a three-way valve to
maintain the supply air temperature setpoint during cooling.
The mixing box maintains the minimum outside airflow fraction unless
conditions for economizer are met, in which case the economizer controller
adjusts the outside airflow fraction to meet a mixed air temperature setpoint.
The economizer is enabled if the outside air drybulb temperature is lower
than the return air temperature and the system is not in heating mode.
</p>
<p>
There are a number of assumptions in the model. Pressure drops through the
system are collected into a single component. The mass flow of return air
is equal to the mass flow of supply air. The mass flow of outside air and
relief air in the mixing box is ideally controlled so that the supply air is
composed of the specified outside airflow fraction, rather than having
feedback control of damper positions. The cooling coil is a dry coil model.
</p>
</html>"));
end ChillerDXHeatingEconomizer;
