within Buildings.Examples;
model ChillerDXHeatingEconomizer
  "HVAC system model with a dry cooling coil, air-cooled chiller, electric heating coil, variable speed fan, and mixing box with economizer control."
  replaceable package MediumAir =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component of type air"
      annotation (choicesAllMatching = true);
  replaceable package MediumWater =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component of type water"
      annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.MassFlowRate designAirFlow "Design airflow rate of system";
  parameter Modelica.SIunits.MassFlowRate minAirFlow "Minimum airflow rate of system";
  parameter Modelica.SIunits.DimensionlessRatio minOAFra "Minimum outdoor air fraction of system";
  parameter Modelica.SIunits.Temperature supplyAirTempSet "Cooling supply air temperature setpoint";
  parameter Modelica.SIunits.Temperature chwsTempSet "Chilled water supply temperature setpoint";
  parameter Modelica.SIunits.Power designHeatingCapacity "Design heating capacity of heating coil";
  parameter Real designHeatingEfficiency "Design heating efficiency of the heating coil";
  parameter Modelica.SIunits.Power designCoolingCapacity "Design heating capacity of cooling coil";
  parameter Real sensitivityGainHeat = 2 "[K] Gain sensitivity on heating controller";
  parameter Real sensitivityGainCool = 2 "[K] Gain sensitivity on cooling controller";
  parameter Real sensitivityGainEco = 0.25 "[K] Gain sensitivity on economizer controller";
  Modelica.Blocks.Interfaces.RealInput Tmea "Zone temperature measurement"
                                         annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,0})));
  Modelica.Fluid.Interfaces.FluidPorts_b supplyAir(redeclare package Medium =
        MediumAir)
                "Supply air port"
    annotation (Placement(transformation(extent={{190,-20},{210,60}}),
        iconTransformation(extent={{190,-20},{210,60}})));
  Modelica.Fluid.Interfaces.FluidPorts_b returnAir[1](redeclare package Medium
      = MediumAir) "Return air port"
    annotation (Placement(transformation(extent={{190,-140},{210,-60}}),
        iconTransformation(extent={{190,-140},{210,-60}})));
  Modelica.Blocks.Interfaces.RealInput TheatSetpoint
    "Zone heating setpoint temperature"  annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-220,140})));
  Modelica.Blocks.Interfaces.RealInput TcoolSetpoint
    "Zone cooling setpoint temperature"  annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-220,80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      supplyAirTemp(
                m_flow_nominal=designAirFlow,
    allowFlowReversal=false,
    tau=0,
    redeclare package Medium = MediumAir) "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{128,38},{148,58}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heatCoil(
    m_flow_nominal=designAirFlow,
    Q_flow_nominal=designHeatingCapacity,
    u(start=0),
    dp_nominal=0,
    allowFlowReversal=false,
    tau=90,
    redeclare package Medium = MediumAir)
            "Air heating coil"
    annotation (Placement(transformation(extent={{52,38},{72,58}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-190,148},{-150,188}}), iconTransformation(
          extent={{-180,160},{-160,180}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow supplyFan(
    m_flow_nominal=designAirFlow,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=875,
    per(use_powerCharacteristic=false),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    use_inputFilter=false,
    redeclare package Medium = MediumAir) "Supply fan"
    annotation (Placement(transformation(extent={{-32,38},{-12,58}})));
  SOEPDemo.HVACSystems.Controllers.HeatingCooling control(
    designAirFlow=designAirFlow,
    minAirFlow=minAirFlow,
    sensitivityGainHeat=sensitivityGainHeat,
    sensitivityGainCool=sensitivityGainCool) "Heating and cooling control"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Fluid.FixedResistances.PressureDrop totalRes(
    m_flow_nominal=designAirFlow,
    dp_nominal=500,
    allowFlowReversal=false,
    redeclare package Medium = MediumAir)
    annotation (Placement(transformation(extent={{-2,38},{18,58}})));
  Modelica.Blocks.Interfaces.RealOutput fanPower
    "Electrical power consumed by the supply fan"
    annotation (Placement(transformation(extent={{200,130},{220,150}}),
        iconTransformation(extent={{200,130},{220,150}})));
  Modelica.Blocks.Interfaces.RealOutput heatPower
    "Electrical power consumed by the heating equipment" annotation (Placement(
        transformation(extent={{200,110},{220,130}}), iconTransformation(extent=
           {{200,110},{220,130}})));
  Modelica.Blocks.Interfaces.RealOutput coolPower
    "Electrical power consumed by the cooling equipment" annotation (Placement(
        transformation(extent={{200,90},{220,110}}), iconTransformation(extent={
            {200,90},{220,110}})));
  Modelica.Blocks.Math.Gain eff(k=1/designHeatingEfficiency)
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Buildings.Fluid.Sensors.MassFlowRate returnAirFlow(
                allowFlowReversal=false, redeclare package Medium = MediumAir)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-66,-6})));
  Buildings.Fluid.Sensors.MassFlowRate exhaustAirFlow(
                allowFlowReversal=false, redeclare package Medium = MediumAir)
    annotation (Placement(transformation(extent={{-20,-110},{-40,-90}})));
  Buildings.Fluid.Sensors.MassFlowRate oaAirFlow(
                allowFlowReversal=false, redeclare package Medium = MediumAir)
    annotation (Placement(transformation(extent={{-100,38},{-80,58}})));
  Buildings.Fluid.Sources.Outside out(
                nPorts=3, redeclare package Medium = MediumAir)
    annotation (Placement(transformation(extent={{-140,36},{-120,56}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort mixedAirTemp(
    m_flow_nominal=designAirFlow,
    allowFlowReversal=false,
    tau=0,
    redeclare package Medium = MediumAir)
            "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-60,38},{-40,58}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort freezeStat(
    m_flow_nominal=designAirFlow,
    allowFlowReversal=false,
    tau=0,
    redeclare package Medium = MediumAir)
            "Temperature sensor to detect freezing conditions"
    annotation (Placement(transformation(extent={{24,38},{44,58}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource idealSourceExhaust(
    control_m_flow=true,
    allowFlowReversal=false,
    m_flow_small=1e-4,
    redeclare package Medium = MediumAir)
    annotation (Placement(transformation(extent={{40,-110},{20,-90}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource idealSourceRelief(
    control_m_flow=true,
    allowFlowReversal=false,
    m_flow_small=1E-4,
    redeclare package Medium = MediumAir)
    annotation (Placement(transformation(extent={{-80,-110},{-100,-90}})));
  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU coolCoil(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    dp1_nominal=0,
    dp2_nominal=0,
    m2_flow_nominal=designAirFlow,
    Q_flow_nominal=designCoolingCapacity,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=m_flow_chws,
    T_a1_nominal=279.15,
    T_a2_nominal=298.15)
    annotation (Placement(transformation(extent={{110,52},{90,32}})));

  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    redeclare package Medium = MediumWater,
    m_flow_nominal=m_flow_chws,
    dpValve_nominal=12000,
    dpFixed_nominal={0,0},
    use_inputFilter=true,
    tau=10,
    riseTime=300)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={80,-20})));
  Buildings.Fluid.Sources.MassFlowSource_T cwSou(
    redeclare package Medium = MediumAir,
    nPorts=1,
    use_T_in=true,
    m_flow=m_flow_cas)
                   annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={138,-148})));
  Buildings.Fluid.Sensors.TemperatureTwoPort chwsTemp(
    allowFlowReversal=false,
    tau=0,
    redeclare package Medium = MediumWater,
    m_flow_nominal=m_flow_chws)
    "Chilled water supply temperature sensor" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={120,-40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort chwrTemp(
    allowFlowReversal=false,
    tau=0,
    redeclare package Medium = MediumWater,
    m_flow_nominal=m_flow_chws)
    "Chilled water return temperature sensor" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={80,-50})));
  Buildings.Fluid.Sensors.MassFlowRate chwsFlow(allowFlowReversal=false,
      redeclare package Medium = MediumWater) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={120,0})));
  Modelica.Blocks.Sources.Constant supplyAirTempSetConst(k=supplyAirTempSet)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.Continuous.LimPID conP(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=0,
    yMin=-1,
    k=4e-1)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
  Modelica.Blocks.Math.Product product annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={32,6})));
  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{48,0},{60,12}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow chwPump(
    use_inputFilter=false,
    allowFlowReversal=false,
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_chws,
    addPowerToMedium=false,
    per(
      hydraulicEfficiency(eta={1}),
      motorEfficiency(eta={0.9}),
      motorCooledByFluid=false),
    dp_nominal=12000)                                         annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={120,-86})));
  Buildings.Fluid.Chillers.ElectricEIR chillerAirCooled(
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumWater,
    m2_flow_nominal=m_flow_chws,
    dp1_nominal=0,
    m1_flow_nominal=m_flow_cas,
    dp2_nominal=0,
    per(
      capFunT={1.0433811,0.0407077,0.0004506,-0.0041514,-8.86e-5,-0.0003467},
      PLRMax=1.2,
      EIRFunT={0.5961915,-0.0099496,0.0007888,0.0004506,0.0004875,-0.0007623},
      EIRFunPLR={1.6853121,-0.9993443,0.3140322},
      COP_nominal=COP_nominal,
      QEva_flow_nominal=-designCoolingCapacity,
      mEva_flow_nominal=m_flow_chws,
      mCon_flow_nominal=m_flow_cas,
      TEvaLvg_nominal=chwsTempSet,
      PLRMinUnl=0.1,
      PLRMin=0.1,
      etaMotor=1,
      TEvaLvgMin=274.15,
      TEvaLvgMax=293.15,
      TConEnt_nominal=302.55,
      TConEntMin=274.15,
      TConEntMax=323.15)) "Air cooled chiller"
    annotation (Placement(transformation(extent={{110,-132},{90,-152}})));
  Modelica.Blocks.Sources.Constant chwsTempSetConst(k=chwsTempSet)
    annotation (Placement(transformation(extent={{160,-126},{140,-106}})));
  Modelica.Blocks.Sources.Constant chwsMassFlowConst(k=m_flow_chws)
    annotation (Placement(transformation(extent={{160,-80},{140,-60}})));
  Modelica.Blocks.Interfaces.RealOutput pumpPower
    "Electrical power consumed by the pumps"
    annotation (Placement(transformation(extent={{200,70},{220,90}})));
  Modelica.Blocks.Sources.BooleanConstant on
    annotation (Placement(transformation(extent={{198,-150},{178,-130}})));
protected
  final parameter Modelica.SIunits.DimensionlessRatio COP_nominal = 5.5 "Nominal COP of the chiller";
  final parameter Modelica.SIunits.MassFlowRate m_flow_chws = designCoolingCapacity/4184/4 "Design chilled water supply flow";
  final parameter Modelica.SIunits.MassFlowRate m_flow_cas = designCoolingCapacity*(1+1/COP_nominal)/1008/10 "Design condenser air flow";
public
  Buildings.Fluid.Sources.FixedBoundary fixedBou(redeclare package Medium =
        MediumWater, nPorts=1)
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  SOEPDemo.HVACSystems.Controllers.Economizer economizer(sensitivityGainEco=
        sensitivityGainEco) "Economizer control"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  Modelica.Blocks.Math.Product ecoProduct
    annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Constant minOAFraConst(k=minOAFra)
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
equation

  connect(supplyAirTemp.port_b, supplyAir) annotation (Line(points={{148,48},{200,
          48},{200,20}},      color={0,127,255}));
  connect(control.fanSet, supplyFan.m_flow_in) annotation (Line(points={{-119,4},
          {-98,4},{-98,80},{-22,80},{-22,60}},     color={0,0,127}));
  connect(TheatSetpoint, control.TheatSet) annotation (Line(points={{-220,
          140},{-160,140},{-160,17},{-141,17}},
                                          color={0,0,127}));
  connect(TcoolSetpoint, control.TcoolSet) annotation (Line(points={{-220,80},
          {-202,80},{-178,80},{-178,12},{-141,12}},
                                              color={0,0,127}));
  connect(Tmea, control.Tmea) annotation (Line(points={{-220,0},{-181,0},{-181,2.8},
          {-141,2.8}}, color={0,0,127}));
  connect(supplyFan.port_b, totalRes.port_a)
    annotation (Line(points={{-12,48},{-2,48}},  color={0,127,255}));
  connect(supplyFan.P, fanPower) annotation (Line(points={{-11,57},{-6,57},
          {-6,140},{210,140}},
                             color={0,0,127}));
  connect(eff.y, heatPower) annotation (Line(points={{141,100},{160,100},{160,120},
          {210,120}}, color={0,0,127}));
  connect(oaAirFlow.port_a, out.ports[1]) annotation (Line(points={{-100,48},{
          -120,48},{-120,48.6667}},
                          color={0,127,255}));
  connect(weaBus, out.weaBus) annotation (Line(
      points={{-170,168},{-170,168},{-170,46},{-140,46},{-140,46.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(mixedAirTemp.port_b, supplyFan.port_a)
    annotation (Line(points={{-40,48},{-40,48},{-32,48}}, color={0,127,255}));
  connect(oaAirFlow.port_b, mixedAirTemp.port_a)
    annotation (Line(points={{-80,48},{-70,48},{-60,48}}, color={0,127,255}));
  connect(returnAirFlow.port_b, mixedAirTemp.port_a)
    annotation (Line(points={{-66,4},{-66,48},{-60,48}}, color={0,127,255}));
  connect(totalRes.port_b, freezeStat.port_a)
    annotation (Line(points={{18,48},{24,48}}, color={0,127,255}));
  connect(heatCoil.Q_flow, eff.u) annotation (Line(points={{73,54},{80,54},{80,100},
          {86,100},{108,100},{118,100}},          color={0,0,127}));
  connect(control.heaterSet, heatCoil.u) annotation (Line(points={{-119,16},
          {-104,16},{-104,82},{38,82},{44,82},{44,54},{50,54}},
                                                        color={0,0,127}));
  connect(idealSourceExhaust.m_flow_in, supplyFan.m_flow_in) annotation (
      Line(points={{36,-92},{36,-60},{-98,-60},{-98,80},{-22,80},{-22,60}},
                color={0,0,127}));
  connect(idealSourceExhaust.port_a, returnAir[1]) annotation (Line(points={{40,-100},
          {200,-100}},                    color={0,127,255}));
  connect(idealSourceExhaust.port_b, exhaustAirFlow.port_a) annotation (
      Line(points={{20,-100},{0,-100},{-20,-100}},
                                                color={0,127,255}));
  connect(idealSourceRelief.port_a, exhaustAirFlow.port_b)
    annotation (Line(points={{-80,-100},{-70,-100},{-60,-100},{-40,-100}},
                                                   color={0,127,255}));
  connect(idealSourceRelief.port_b, out.ports[2]) annotation (Line(points={{-100,
          -100},{-108,-100},{-108,46},{-120,46}},     color={0,127,255}));
  connect(returnAirFlow.port_a, exhaustAirFlow.port_b) annotation (Line(
        points={{-66,-16},{-66,-100},{-40,-100}},
                                                color={0,127,255}));
  connect(freezeStat.port_b, heatCoil.port_a)
    annotation (Line(points={{44,48},{48,48},{52,48}}, color={0,127,255}));
  connect(chwrTemp.port_a, val.port_2)
    annotation (Line(points={{80,-40},{80,-40},{80,-30}},
                                                   color={0,0,255},
      thickness=0.5));
  connect(chwsTemp.port_b, chwsFlow.port_a)
    annotation (Line(points={{120,-30},{120,-30},{120,-10}},
                                                          color={0,0,255},
      thickness=0.5));
  connect(heatCoil.port_b, coolCoil.port_a2)
    annotation (Line(points={{72,48},{90,48}}, color={0,127,255}));
  connect(coolCoil.port_b2, supplyAirTemp.port_a)
    annotation (Line(points={{110,48},{120,48},{128,48}}, color={0,127,255}));
  connect(val.port_3, chwsFlow.port_a) annotation (Line(points={{90,-20},{
          120,-20},{120,-10}}, color={0,0,255},
      thickness=0.5));
  connect(chwsFlow.port_b, coolCoil.port_a1) annotation (Line(
      points={{120,10},{120,36},{110,36}},
      color={0,0,255},
      thickness=0.5));
  connect(coolCoil.port_b1, val.port_1) annotation (Line(
      points={{90,36},{80,36},{80,-10}},
      color={0,0,255},
      thickness=0.5));
  connect(supplyAirTemp.T, conP.u_m) annotation (Line(points={{138,59},{138,
          59},{138,70},{156,70},{156,20},{0,20},{0,12}},
                                                       color={0,0,127}));
  connect(gain.y, val.y) annotation (Line(points={{60.6,6},{64,6},{64,-20},{68,
          -20}},     color={0,0,127}));
  connect(supplyAirTempSetConst.y, conP.u_s)
    annotation (Line(points={{-19,0},{-15.5,0},{-12,0}}, color={0,0,127}));
  connect(conP.y, product.u1) annotation (Line(points={{11,0},{16,0},{16,
          1.77636e-15},{20,1.77636e-15}}, color={0,0,127}));
  connect(gain.u, product.y)
    annotation (Line(points={{46.8,6},{46.8,6},{43,6}}, color={0,0,127}));
  connect(product.u2, control.coolSignal) annotation (Line(points={{20,12},
          {-88,12},{-119,12}}, color={0,0,127}));
  connect(chillerAirCooled.port_a2, chwrTemp.port_b)
    annotation (Line(points={{90,-136},{80,-136},{80,-60}}, color={0,0,255},
      thickness=0.5));
  connect(chillerAirCooled.port_b2, chwPump.port_a) annotation (Line(points={{110,
          -136},{120,-136},{120,-96}},  color={0,0,255},
      thickness=0.5));
  connect(chwPump.port_b, chwsTemp.port_a)
    annotation (Line(points={{120,-76},{120,-76},{120,-50}}, color={0,0,255},
      thickness=0.5));
  connect(cwSou.ports[1], chillerAirCooled.port_a1) annotation (Line(points={{128,
          -148},{128,-148},{110,-148}}, color={0,127,255}));
  connect(chillerAirCooled.port_b1, out.ports[3]) annotation (Line(points={{90,-148},
          {-14,-148},{-112,-148},{-112,43.3333},{-120,43.3333}}, color={0,127,255}));
  connect(weaBus.TDryBul, cwSou.T_in) annotation (Line(
      points={{-170,168},{-170,168},{-170,-158},{160,-158},{160,-144},{150,-144}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(chwsTempSetConst.y, chillerAirCooled.TSet) annotation (Line(points={{139,
          -116},{124,-116},{124,-139},{112,-139}}, color={0,0,127}));
  connect(chwsMassFlowConst.y, chwPump.m_flow_in) annotation (Line(points={{139,-70},
          {100,-70},{100,-86},{108,-86}},          color={0,0,127}));
  connect(chwPump.P, pumpPower) annotation (Line(points={{111,-75},{111,-52},
          {180,-52},{180,80},{210,80}},
                                   color={0,0,127}));
  connect(on.y, chillerAirCooled.on) annotation (Line(points={{177,-140},{124,-140},
          {124,-145},{112,-145}}, color={255,0,255}));
  connect(chillerAirCooled.P, coolPower) annotation (Line(points={{89,-151},{84,
          -151},{84,-128},{98,-128},{98,-50},{178,-50},{178,100},{210,100}},
        color={0,0,127}));
  connect(pumpPower, pumpPower)
    annotation (Line(points={{210,80},{210,80}},          color={0,0,127}));
  connect(fixedBou.ports[1], chwrTemp.port_b) annotation (Line(
      points={{60,-130},{70,-130},{70,-136},{80,-136},{80,-60}},
      color={0,0,255},
      thickness=0.5));
  connect(exhaustAirFlow.m_flow, ecoProduct.u2) annotation (Line(points={{-30,-89},
          {-30,-89},{-30,-46},{-38,-46}}, color={0,0,127}));
  connect(ecoProduct.y, idealSourceRelief.m_flow_in)
    annotation (Line(points={{-61,-40},{-84,-40},{-84,-92}}, color={0,0,127}));
  connect(economizer.oaFra, ecoProduct.u1) annotation (Line(points={{-119,-22},{
          -78,-22},{-32,-22},{-32,-34},{-38,-34}}, color={0,0,127}));
  connect(minOAFraConst.y, economizer.minOAFra) annotation (Line(points={{-179,-40},
          {-152,-40},{-152,-30},{-141,-30}}, color={0,0,127}));
  connect(mixedAirTemp.T, economizer.T_mix) annotation (Line(points={{-50,59},{-50,
          84},{-152,84},{-152,-26},{-141,-26}}, color={0,0,127}));
  connect(supplyAirTempSetConst.y, economizer.T_mixSet) annotation (Line(points=
         {{-19,0},{-16,0},{-16,-18},{-146,-18},{-146,-22},{-141,-22}}, color={0,
          0,127}));
  connect(weaBus.TDryBul, economizer.T_oa) annotation (Line(
      points={{-170,168},{-172,168},{-172,-36},{-172,-34},{-141,-34}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(control.heaterSet, economizer.heaterSet) annotation (Line(points=
          {{-119,16},{-104,16},{-104,-8},{-164,-8},{-164,-38},{-141,-38}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},
            {200,160}}), graphics={
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
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},{200,160}})),
    experiment(
      StopTime=518400,
      Interval=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
      Documentation(info="<html>
<p>
This is a conventional single zone VAV HVAC system model.  The system contains
a variable speed supply fan, electric heating coil, water-based cooling coil, 
economizer, and air-cooled chiller.  The control of the system is that of 
conventional VAV heating and cooling.  During cooling, the supply air 
temperature is held constant while the supply air flow is modulated from 
maximum to minimum according to zone load.  This is done by modulating the 
fan speed.  During heating, the supply air flow is held at a constant minimum 
while the heating coil is modulated accoding to zone load.  The mass flow of 
chilled water through the cooling coil is controlled by a three-way valve to 
maintain the supply air temperature setpoint during cooling.  
The mixing box maintains the minimum outside airflow fraction unless 
conditions for economizer are met, in which case the economizer controller 
adjusts the outside airflow fraction to meet a mixed air temperature setpoint.  
The economizer is enabled if the outside air drybulb temperature is lower 
than the return air temperature and the system is not in heating mode.  
</p>
<p>
There are a number of assumptions in the model.  Pressure drops through the 
system are collected into a single component.  The mass flow of return air
is equal to the mass flow of supply air.  The mass flow of outside air and 
relief air in the mixing box is ideally controlled so that the supply air is 
composed of the specified outside airflow fraction, rather than having
feedback control of damper positions.  The cooling coil is a dry coil model.  
</p>
</html>"));
end ChillerDXHeatingEconomizer;
