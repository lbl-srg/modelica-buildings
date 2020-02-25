within Buildings.Examples.ChillerPlant;
model RP1711
  "Simple closed loop model for testing primary control sequences"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=5
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=7
    "Temperature difference condenser outlet-inlet";
  parameter Modelica.SIunits.HeatFlowRate q_floEva_nominal = 742E3 "Chiller nominal capacity";
  parameter Real EER_nominal = 5.42 "Chiller EER nominal value";
  parameter Modelica.SIunits.SpecificHeatCapacity cpLiq = 4186 "Specific heat capacity of water";
  parameter Modelica.SIunits.MassFlowRate m_floCHW_nominal=q_floEva_nominal / cpLiq / dTEva_nominal
   "Nominal mass flow rate at chilled water";
  parameter Modelica.SIunits.MassFlowRate
    m_floCW_nominal=m_floCHW_nominal* (1 + 1 / EER_nominal) * dTEva_nominal / dTCon_nominal
   "Nominal mass flow rate at condenser water";
  parameter Modelica.SIunits.PressureDifference dp_nominal=500
    "Nominal pressure difference";
  parameter Modelica.SIunits.PressureDifference dpCHW_nominal=125412
    "CHW loop nominal pressure difference";
  parameter Modelica.SIunits.PressureDifference dpCW_nominal=214992
    "CW loop nominal pressure difference";

  Fluid.Movers.FlowControlled_m_flow
                                 pumCW2(
    redeclare package Medium = MediumW,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per(pressure(V_flow=m_floCW_nominal*{0.5,1.0,1.5}, dp=dpCW_nominal*{1.2,1.0,
            0.2})),
    m_flow_nominal=m_floCW_nominal,
    dp_nominal=dpCW_nominal)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={312,110})));
  Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow1(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_floCW_nominal,
    PFan_nominal=6000,
    TAirInWB_nominal(displayUnit="degC") = 283.15,
    TApp_nominal=6,
    dp_nominal=14930 + 14930 + 74650,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Cooling tower" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          origin={229,271})));
  Fluid.Actuators.Valves.TwoWayLinear valIsoCW1(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_floCW_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_inputFilter=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={88,144})));
  Fluid.Chillers.ElectricEIR chi1(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=m_floCW_nominal,
    m2_flow_nominal=m_floCHW_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_19XR_742kW_5_42COP_VSD(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{146,129},{126,149}})));
  Fluid.Actuators.Valves.TwoWayLinear valIsoCHW1(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_floCHW_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=14930 + 89580,
    y_start=1,
    use_inputFilter=false,
    from_dp=true) "Control valve for chilled water leaving from chiller"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={186,130})));
  Fluid.Sensors.TemperatureTwoPort sen_TCHWRet(redeclare package Medium =
        MediumW, m_flow_nominal=2*m_floCHW_nominal)
    "Temperature of chilled water return" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-86,-8})));
  Fluid.Sensors.TemperatureTwoPort sen_TCWLvgTow(redeclare package Medium =
        MediumW, m_flow_nominal=2*m_floCW_nominal)
    "Temperature of condenser water leaving the cooling tower" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        origin={328,235},
        rotation=180)));
  BoundaryConditions.WeatherData.ReaderTMY3           weaData(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-224,442},{-204,462}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-166,440},{-146,460}})));
  Fluid.Chillers.ElectricEIR           chi2(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=m_floCW_nominal,
    m2_flow_nominal=m_floCHW_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_19XR_742kW_5_42COP_VSD(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{148,59},{128,79}})));
  Fluid.MixingVolumes.MixingVolume volCHWLoa(nPorts=3,
    redeclare package Medium = MediumW,
    m_flow_nominal=2*m_floCHW_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    V=15) "Volume of chilled water receiving cooling load"
    annotation (Placement(transformation(extent={{56,-42},{76,-22}})));
  Fluid.Actuators.Valves.TwoWayLinear valIsoCHW2(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_floCHW_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=14930 + 89580,
    y_start=1,
    use_inputFilter=false,
    from_dp=true) "Control valve for chilled water leaving from chiller"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={196,62})));
  Fluid.HeatExchangers.CoolingTowers.YorkCalc           cooTow2(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_floCW_nominal,
    PFan_nominal=6000,
    TAirInWB_nominal(displayUnit="degC") = 283.15,
    TApp_nominal=6,
    dp_nominal=14930 + 14930 + 74650,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Cooling tower"                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={229,235})));
  Fluid.Actuators.Valves.TwoWayLinear valIsoCW2(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_floCW_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_inputFilter=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={104,74})));
  Modelica.Blocks.Sources.Constant con_valIsoCW(k=1)
    "Control singal for cooling tower fan" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-272,317})));
  Modelica.Blocks.Sources.Trapezoid load(
    rising=6*3600,
    width=3600,
    falling=5*3600,
    period=24*3600,
    startTime=7*3600,
    amplitude=0.95*2*q_floEva_nominal,
    offset=0.05*2*q_floEva_nominal)
    annotation (Placement(transformation(extent={{-656,-42},{-636,-22}})));
  HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{20,-42},{40,-22}})));
  Fluid.Sensors.TemperatureTwoPort sen_TCHWEntEva(redeclare package Medium =
        MediumW, m_flow_nominal=2*m_floCHW_nominal)
    "Temperature of chilled water entering evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,64})));
  Fluid.Sensors.TemperatureTwoPort sen_TCWLvgCon(redeclare package Medium =
        MediumW, m_flow_nominal=2*m_floCW_nominal)
    "Temperature of chilled water leaving condenser" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,144})));
  Fluid.Sensors.TemperatureTwoPort sen_TCWEntCon(redeclare package Medium =
        MediumW, m_flow_nominal=2*m_floCW_nominal)
    "Temperature of chilled water entering condenser" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={252,144})));
  CDL.Continuous.Sources.Constant set_TCHWSup(k=7)
    "Setpoint for chilled water supply temperature (C)"
    annotation (Placement(transformation(extent={{-654,410},{-634,430}})));
  Fluid.Sensors.VolumeFlowRate sen_V_floCHW(redeclare package Medium = MediumW,
      m_flow_nominal=2*m_floCHW_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-86,22})));
  UnitConversions.From_degC from_degC
    annotation (Placement(transformation(extent={{-616,410},{-596,430}})));
  Fluid.Movers.FlowControlled_m_flow pumCW1(
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per(pressure(V_flow=m_floCW_nominal*{0.5,1.0,1.5}, dp=dpCW_nominal*{1.2,1.0,
            0.2})),
    redeclare package Medium = MediumW,
    m_flow_nominal=m_floCW_nominal,
    dp_nominal=dpCW_nominal)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={312,144})));
  Modelica.Blocks.Sources.BooleanExpression pumCW1On(y=pumCW1.y_actual > 1e-4)
    annotation (Placement(transformation(extent={{-400,424},{-380,444}})));
  Modelica.Blocks.Sources.BooleanExpression pumCW2On(y=pumCW2.y_actual > 1e-4)
    annotation (Placement(transformation(extent={{-400,400},{-380,420}})));
  Modelica.Blocks.Sources.RealExpression cooTow1FanSpe(y=cooTow1.y)
    annotation (Placement(transformation(extent={{-400,378},{-380,398}})));
  Tower.Fan con_cooTowFan(
    minFanSpe=0.1,
    dTAboSet=0.55,
    TiFan=1000,
    controllerTypeFan=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    kFan=0.3)
    annotation (Placement(transformation(extent={{-282,340},{-262,360}})));
  CDL.Continuous.Sources.Constant set_dTLifChi(k=13)
    "Setpoint for chiller lift (K)"
    annotation (Placement(transformation(extent={{-654,338},{-634,358}})));
  Fluid.Movers.SpeedControlled_y pumCHW2(
    redeclare package Medium = MediumW,
    use_inputFilter=false,
    per(pressure(V_flow=m_floCHW_nominal*{0.5,1.0,1.5}, dp=dpCHW_nominal*{1.2,1.0,
            0.2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Evaporator water pump"
                         annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-62,64})));
  Fluid.Movers.SpeedControlled_y           pumCHW1(
    redeclare package Medium = MediumW,
    use_inputFilter=false,
    per(pressure(V_flow=m_floCHW_nominal*{0.5,1.0,1.5}, dp=dpCHW_nominal*{1.2,1.0,
            0.2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Evaporator water pump"
                         annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-64,104})));
  Modelica.Blocks.Sources.Constant con_pumCHW(k=1)
    "Control singal for cooling tower fan" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-270,129})));
  Fluid.Sources.Boundary_pT expCW(redeclare package Medium = MediumW, nPorts=1)
    "Expansion device on condenser water loop"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={372,110})));
  Fluid.Sources.Boundary_pT expCHW(redeclare package Medium = MediumW, nPorts=1)
    "Expansion device on chilled water loop"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={96,-10})));
  Generic.EquipmentRotationTwo equRot(stagingRuntime=86400)
    annotation (Placement(transformation(extent={{-280,196},{-260,216}})));
  Modelica.Blocks.Sources.BooleanExpression chi2On(y=chi2.on) "Chiller status"
    annotation (Placement(transformation(extent={{-580,206},{-560,226}})));
  CDL.Conversions.BooleanToInteger booToInt
    annotation (Placement(transformation(extent={{-490,234},{-470,254}})));
  CDL.Conversions.BooleanToInteger booToInt1
    annotation (Placement(transformation(extent={{-490,206},{-470,226}})));
  CDL.Logical.Sources.Constant chi1Ava(k=true) "Chiller availability "
    annotation (Placement(transformation(extent={{-656,132},{-636,152}})));
  CDL.Logical.Sources.Constant chi2Ava(k=true) "Chiller availability "
    annotation (Placement(transformation(extent={{-656,100},{-636,120}})));
  CDL.Integers.MultiSum chiStage(nin=2)
    annotation (Placement(transformation(extent={{-432,220},{-412,240}})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valTowByp(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_floCW_nominal,
    dpValve_nominal=10000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    from_dp=false,
    use_inputFilter=false) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={344,194})));
  CDL.Continuous.LimPID con_valTowByp(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=300,
    yMax=1,
    yMin=0,
    k=1,
    reverseAction=true)
    annotation (Placement(transformation(extent={{-282,268},{-262,288}})));
  CDL.Continuous.Sources.Constant set_TMinCWEntCon(k=20)
    "Setpoint for minimum entering condenser water temperature (C)"
    annotation (Placement(transformation(extent={{-654,302},{-634,322}})));
  Fluid.Sensors.TemperatureTwoPort sen_TCWEntTow(redeclare package Medium =
        MediumW, m_flow_nominal=2*m_floCW_nominal)
    "Temperature of condenser water entering the cooling tower" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={80,235},
        rotation=180)));
  UnitConversions.From_degC from_degC1
    annotation (Placement(transformation(extent={{-618,302},{-598,322}})));
  CDL.Continuous.Sources.Constant set_m_floPumCW(k=m_floCW_nominal)
    "Setpoint for condenser pump flow rate (kg/s)"
    annotation (Placement(transformation(extent={{-654,376},{-634,396}})));
  Fluid.Sensors.TemperatureTwoPort sen_TCHWSup(redeclare package Medium =
        MediumW, m_flow_nominal=2*m_floCHW_nominal)
    "Temperature of chilled water supply" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={232,62})));
  Staging.Subsequences.Change staChaPosDis(nPosDis=2, staNomCap=
        q_floEva_nominal*{1,1})
    annotation (Placement(transformation(extent={{-432,90},{-412,110}})));
  Modelica.Blocks.Sources.RealExpression dumCHWdP(y=dpCHW_nominal)
    "Dummy value (CHW pumps not controlled yet)"
    annotation (Placement(transformation(extent={{-564,68},{-544,88}})));
  Modelica.Blocks.Sources.RealExpression dumCooTowFanMax(y=1) "Dummy value"
    annotation (Placement(transformation(extent={{-564,50},{-544,70}})));
  Modelica.Blocks.Sources.BooleanExpression dumWSEOn(y=false)
    "Dummy water side economizer status"
    annotation (Placement(transformation(extent={{-564,32},{-544,52}})));
  Modelica.Blocks.Sources.RealExpression dumWSETLvg(y=273.15 + 10)
    "Dummy value"
    annotation (Placement(transformation(extent={{-564,16},{-544,36}})));
  CDL.Integers.MultiSum chiStageNew(nin=2)
    annotation (Placement(transformation(extent={{-382,150},{-362,170}})));
  CDL.Integers.GreaterEqual intGreEqu
    annotation (Placement(transformation(extent={{-328,130},{-308,150}})));
  CDL.Integers.Sources.Constant conInt(k=1)
    annotation (Placement(transformation(extent={{-382,110},{-362,130}})));
  CDL.Integers.GreaterEqual intGreEqu1
    annotation (Placement(transformation(extent={{-328,78},{-308,98}})));
  CDL.Integers.Sources.Constant conInt1(k=2)
    annotation (Placement(transformation(extent={{-382,70},{-362,90}})));
  CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=10)
    annotation (Placement(transformation(extent={{-534,206},{-514,226}})));
  Modelica.Blocks.Sources.BooleanExpression chi1On(y=chi1.on) "Chiller status"
    annotation (Placement(transformation(extent={{-580,234},{-560,254}})));
  CDL.Logical.TrueFalseHold truFalHol1(trueHoldDuration=10)
    annotation (Placement(transformation(extent={{-534,234},{-514,254}})));
  CDL.Conversions.BooleanToReal con_valIsoCHW1
    annotation (Placement(transformation(extent={{-230,184},{-210,204}})));
  CDL.Conversions.BooleanToReal con_valIsoCHW2
    annotation (Placement(transformation(extent={{-230,158},{-210,178}})));
equation
  connect(valIsoCW1.port_a, chi1.port_b1) annotation (Line(
      points={{98,144},{98,145},{126,145}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(chi1.port_b2, valIsoCHW1.port_a) annotation (Line(
      points={{146,133},{176,133},{176,130}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(weaData.weaBus,weaBus)  annotation (Line(
      points={{-204,452},{-204,450},{-156,450}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cooTow1.TAir, weaBus.TWetBul) annotation (Line(
      points={{217,275},{217,445},{-156,445},{-156,450}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(chi2.port_b1, valIsoCW2.port_a)
    annotation (Line(points={{128,75},{114,75},{114,74}}, color={0,127,255}));
  connect(chi2.port_b2, valIsoCHW2.port_a) annotation (Line(points={{148,63},{
          186,63},{186,62}},      color={0,127,255}));
  connect(sen_TCHWSup.port_b, volCHWLoa.ports[1]) annotation (Line(points={{242,62},
          {242,-42},{63.3333,-42}},     color={0,127,255}));
  connect(con_valIsoCW.y, valIsoCW2.y) annotation (Line(
      points={{-261,317},{104.5,317},{104.5,86},{104,86}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(volCHWLoa.heatPort, prescribedHeatFlow.port)
    annotation (Line(points={{56,-32},{40,-32}}, color={191,0,0}));
  connect(weaBus.TWetBul, cooTow2.TAir) annotation (Line(
      points={{-156,450},{-156,445},{217,445},{217,239}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(volCHWLoa.ports[2], sen_TCHWRet.port_a) annotation (Line(points={{66,-42},
          {-86,-42},{-86,-18}}, color={0,127,255}));
  connect(sen_TCHWEntEva.port_b, chi2.port_a2)
    annotation (Line(points={{10,64},{128,64},{128,63}}, color={0,127,255}));
  connect(valIsoCW1.port_b, sen_TCWLvgCon.port_a)
    annotation (Line(points={{78,144},{50,144}}, color={0,127,255}));
  connect(sen_TCWEntCon.port_b, chi2.port_a1)
    annotation (Line(points={{242,144},{242,75},{148,75}}, color={0,127,255}));
  connect(sen_TCWEntCon.port_b, chi1.port_a1) annotation (Line(points={{242,144},
          {146,144},{146,145}}, color={0,127,255}));
  connect(cooTow2.port_b, sen_TCWLvgTow.port_a)
    annotation (Line(points={{239,235},{318,235}}, color={0,127,255}));
  connect(cooTow1.port_b, sen_TCWLvgTow.port_a) annotation (Line(points={{239,271},
          {290,271},{290,235},{318,235}}, color={0,127,255}));
  connect(sen_TCHWEntEva.port_b, chi1.port_a2) annotation (Line(points={{10,64},
          {30,64},{30,133},{126,133}}, color={0,127,255}));
  connect(con_valIsoCW.y, valIsoCW1.y) annotation (Line(
      points={{-261,317},{88,317},{88,156}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(valIsoCHW2.port_b, sen_TCHWSup.port_a)
    annotation (Line(points={{206,62},{222,62}}, color={0,127,255}));
  connect(valIsoCHW1.port_b, sen_TCHWSup.port_a) annotation (Line(points={{196,130},
          {222,130},{222,62}}, color={0,127,255}));
  connect(sen_TCHWRet.port_b, sen_V_floCHW.port_a)
    annotation (Line(points={{-86,2},{-86,12}}, color={0,127,255}));
  connect(set_TCHWSup.y, from_degC.u)
    annotation (Line(points={{-633,420},{-618,420}}, color={0,0,127}));
  connect(from_degC.y, chi1.TSet) annotation (Line(
      points={{-595,420},{172,420},{172,136},{148,136}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(from_degC.y, chi2.TSet) annotation (Line(
      points={{-595,420},{171.5,420},{171.5,66},{150,66}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(load.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-635,-32},{20,-32}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(valIsoCW2.port_b, sen_TCWLvgCon.port_a)
    annotation (Line(points={{94,74},{50,74},{50,144}}, color={0,127,255}));
  connect(pumCW1On.y, con_cooTowFan.uConWatPum[1]) annotation (Line(
      points={{-379,434},{-344,434},{-344,358},{-284,358}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(pumCW2On.y, con_cooTowFan.uConWatPum[2]) annotation (Line(
      points={{-379,410},{-344.5,410},{-344.5,358},{-284,358}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(cooTow1FanSpe.y, con_cooTowFan.uFanSpe) annotation (Line(
      points={{-379,388},{-356,388},{-356,342},{-284,342}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(set_dTLifChi.y, con_cooTowFan.dTRef) annotation (Line(
      points={{-633,348},{-460,348},{-460,354},{-284,354}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sen_TCHWSup.T, con_cooTowFan.TChiWatSup) annotation (Line(
      points={{232,51},{232,36},{-396,36},{-396,350},{-284,350}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(con_cooTowFan.yFanSpe, cooTow1.y) annotation (Line(
      points={{-261,345},{186.5,345},{186.5,279},{217,279}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(con_cooTowFan.yFanSpe, cooTow2.y) annotation (Line(
      points={{-261,345},{186.5,345},{186.5,243},{217,243}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sen_V_floCHW.port_b, pumCHW2.port_a)
    annotation (Line(points={{-86,32},{-86,64},{-72,64}}, color={0,127,255}));
  connect(sen_V_floCHW.port_b, pumCHW1.port_a) annotation (Line(points={{-86,32},
          {-86,104},{-74,104}}, color={0,127,255}));
  connect(con_pumCHW.y, pumCHW1.y) annotation (Line(
      points={{-259,129},{-64.5,129},{-64.5,116},{-64,116}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(con_pumCHW.y, pumCHW2.y) annotation (Line(
      points={{-259,129},{-59.5,129},{-59.5,76},{-62,76}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(expCHW.ports[1],volCHWLoa. ports[3]) annotation (Line(points={{96,-20},
          {96,-42},{68.6667,-42}},          color={0,127,255}));
  connect(pumCHW1.port_b, sen_TCHWEntEva.port_a) annotation (Line(points={{-54,104},
          {-30,104},{-30,64},{-10,64}}, color={0,127,255}));
  connect(pumCHW2.port_b, sen_TCHWEntEva.port_a)
    annotation (Line(points={{-52,64},{-10,64}}, color={0,127,255}));
  connect(booToInt.y, chiStage.u[1]) annotation (Line(points={{-469,244},{-454,
          244},{-454,233.5},{-434,233.5}}, color={255,127,0}));
  connect(booToInt1.y, chiStage.u[2]) annotation (Line(points={{-469,216},{-454,
          216},{-454,226.5},{-434,226.5}}, color={255,127,0}));
  connect(sen_TCWLvgTow.port_b, valTowByp.port_1) annotation (Line(points={{338,235},
          {344,235},{344,204}},      color={0,127,255}));
  connect(con_valTowByp.y, valTowByp.y) annotation (Line(
      points={{-261,278},{368,278},{368,194},{356,194}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sen_TCWEntTow.port_b, cooTow1.port_a) annotation (Line(points={{90,235},
          {156,235},{156,271},{219,271}}, color={0,127,255}));
  connect(sen_TCWEntTow.port_b, cooTow2.port_a)
    annotation (Line(points={{90,235},{219,235}}, color={0,127,255}));
  connect(sen_TCWLvgCon.port_b, sen_TCWEntTow.port_a)
    annotation (Line(points={{30,144},{30,235},{70,235}}, color={0,127,255}));
  connect(valTowByp.port_2, pumCW1.port_a) annotation (Line(points={{344,184},{
          344,144},{322,144}},
                           color={0,127,255}));
  connect(valTowByp.port_2, pumCW2.port_a) annotation (Line(points={{344,184},{
          344,110},{322,110}},
                           color={0,127,255}));
  connect(expCW.ports[1], pumCW2.port_a)
    annotation (Line(points={{362,110},{322,110}}, color={0,127,255}));
  connect(sen_TCWLvgTow.T, con_cooTowFan.TConWatRet) annotation (Line(
      points={{328,246},{328,304},{-304,304},{-304,346},{-284,346}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(set_TMinCWEntCon.y, from_degC1.u)
    annotation (Line(points={{-633,312},{-620,312}}, color={0,0,127}));
  connect(from_degC1.y, con_valTowByp.u_s)
    annotation (Line(
      points={{-597,312},{-426,312},{-426,278},{-284,278}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pumCW1.port_b, sen_TCWEntCon.port_a)
    annotation (Line(points={{302,144},{262,144}}, color={0,127,255}));
  connect(set_m_floPumCW.y, pumCW1.m_flow_in) annotation (Line(
      points={{-633,386},{312,386},{312,156}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(set_m_floPumCW.y, pumCW2.m_flow_in) annotation (Line(
      points={{-633,386},{311.5,386},{311.5,122},{312,122}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(valTowByp.port_3, sen_TCWEntTow.port_a) annotation (Line(points={{334,194},
          {30,194},{30,235},{70,235}},      color={0,127,255}));
  connect(pumCW2.port_b, sen_TCWEntCon.port_a) annotation (Line(points={{302,110},
          {282,110},{282,144},{262,144}}, color={0,127,255}));
  connect(sen_TCWEntCon.T, con_valTowByp.u_m) annotation (Line(
      points={{252,155},{252,226},{-272,226},{-272,266}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chiStage.y, staChaPosDis.uSta) annotation (Line(points={{-410.3,230},
          {-408,230},{-408,124},{-439,124},{-439,112},{-433,112}}, color={255,
          127,0}));
  connect(chi1Ava.y, staChaPosDis.uStaAva[1]) annotation (Line(
      points={{-635,142},{-518,142},{-518,110},{-433,110}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(chi2Ava.y, staChaPosDis.uStaAva[2]) annotation (Line(
      points={{-635,110},{-433,110}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(sen_TCHWRet.T, staChaPosDis.TChiWatRet) annotation (Line(
      points={{-97,-8},{-532,-8},{-532,103},{-433,103}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sen_TCHWSup.T, staChaPosDis.TChiWatSup) annotation (Line(
      points={{232,51},{232,30},{-528,30},{-528,98},{-433,98}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sen_V_floCHW.V_flow, staChaPosDis.VChiWat_flow) annotation (Line(
      points={{-97,22},{-530,22},{-530,101},{-433,101}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(dumCHWdP.y, staChaPosDis.dpChiWatPum) annotation (Line(points={{-543,78},
          {-514,78},{-514,94},{-433,94}},       color={0,0,127}));
  connect(dumCHWdP.y, staChaPosDis.dpChiWatPumSet) annotation (Line(
      points={{-543,78},{-514,78},{-514,96},{-433,96}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(dumCooTowFanMax.y, staChaPosDis.uTowFanSpeMax) annotation (Line(
      points={{-543,60},{-510,60},{-510,90},{-433,90}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(dumWSEOn.y, staChaPosDis.uWseSta) annotation (Line(
      points={{-543,42},{-522,42},{-522,108},{-433,108}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(from_degC.y, staChaPosDis.TChiWatSupSet) annotation (Line(
      points={{-595,420},{-510,420},{-510,105},{-433,105}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(dumWSETLvg.y, staChaPosDis.TWsePre) annotation (Line(
      points={{-543,26},{-512,26},{-512,92},{-433,92}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chiStage.y, chiStageNew.u[1]) annotation (Line(points={{-410.3,230},{
          -388,230},{-388,163.5},{-384,163.5}}, color={255,127,0}));
  connect(staChaPosDis.y, chiStageNew.u[2]) annotation (Line(points={{-411,100},
          {-388,100},{-388,156.5},{-384,156.5}}, color={255,127,0}));
  connect(chiStageNew.y, intGreEqu.u1) annotation (Line(points={{-360.3,160},{
          -354,160},{-354,140},{-330,140}}, color={255,127,0}));
  connect(intGreEqu.u2, conInt.y) annotation (Line(points={{-330,132},{-354,132},
          {-354,120},{-361,120}}, color={255,127,0}));
  connect(chiStageNew.y, intGreEqu1.u1) annotation (Line(points={{-360.3,160},{
          -342,160},{-342,88},{-330,88}}, color={255,127,0}));
  connect(intGreEqu1.u2, conInt1.y)
    annotation (Line(points={{-330,80},{-361,80}}, color={255,127,0}));
  connect(equRot.yDevSta[1], chi1.on) annotation (Line(points={{-259,212},{164,
          212},{164,142},{148,142}}, color={255,0,255}));
  connect(equRot.yDevSta[2], chi2.on) annotation (Line(
      points={{-259,212},{164,212},{164,72},{150,72}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(intGreEqu.y, equRot.uLeaSta) annotation (Line(points={{-307,140},{
          -306,140},{-306,212},{-282,212}}, color={255,0,255}));
  connect(intGreEqu1.y, equRot.uLagSta) annotation (Line(points={{-307,88},{
          -302,88},{-302,200},{-282,200}}, color={255,0,255}));
  connect(chi2On.y, truFalHol.u)
    annotation (Line(points={{-559,216},{-535,216}}, color={255,0,255}));
  connect(booToInt1.u, truFalHol.y)
    annotation (Line(points={{-492,216},{-513,216}}, color={255,0,255}));
  connect(chi1On.y, truFalHol1.u)
    annotation (Line(points={{-559,244},{-535,244}}, color={255,0,255}));
  connect(booToInt.u, truFalHol1.y)
    annotation (Line(points={{-492,244},{-513,244}}, color={255,0,255}));
  connect(equRot.yDevSta[1], con_valIsoCHW1.u) annotation (Line(
      points={{-259,212},{-238,212},{-238,194},{-232,194}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(equRot.yDevSta[2], con_valIsoCHW2.u) annotation (Line(
      points={{-259,212},{-244,212},{-244,168},{-232,168}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(con_valIsoCHW1.y, valIsoCHW1.y) annotation (Line(
      points={{-209,194},{186,194},{186,142}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(con_valIsoCHW2.y, valIsoCHW2.y) annotation (Line(
      points={{-209,168},{196,168},{196,74}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-680,-60},{400,480}}),  graphics={
        Text(
          extent={{-700,460},{-586,444}},
          lineColor={28,108,200},
          textString="Setpoints"),
        Text(
          extent={{-700,10},{-586,-6}},
          lineColor={28,108,200},
          textString="Loads"),
        Text(
          extent={{-578,460},{-464,444}},
          lineColor={28,108,200},
          textString="Controls"),
        Text(
          extent={{-246,-108},{-38,-92}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="TODO

WSE
Bypass valve for minimum evaporator flowrate
Sequence up/down auxiliaries
Adjust evap pump operating point")}),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Examples/ClosedLoopTestCase.mos"
        "Simulate and plot"));
end RP1711;
