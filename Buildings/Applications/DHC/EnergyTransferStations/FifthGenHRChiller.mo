within Buildings.Applications.DHC.EnergyTransferStations;
model FifthGenHRChiller
  "Energy transfer station model for fifth generation DHC systems"
  extends DHC.EnergyTransferStations.BaseClasses.PartialETS(
    redeclare replaceable package MediumBui = Buildings.Media.Water,
    redeclare replaceable package MediumDis = Buildings.Media.Water,
    final allowFlowReversalBui=false,
    final allowFlowReversalDis=false,
    have_heaWat=true,
    have_chiWat=true,
    have_hotWat=false,
    have_eleHea=false,
    have_eleCoo=true,
    have_fan=false,
    have_weaBus=false,
    have_pum=true);


    final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
        max(mSecHea_flow_nominal,mSecCoo_flow_nominal)
    "Nominal mass flow rate";
    parameter Modelica.SIunits.MassFlowRate mSecHea_flow_nominal
      "Secondary(building side) heatng circuit nominal water flow rate";
    parameter Modelica.SIunits.MassFlowRate mSecCoo_flow_nominal
      "Secondary(building side) cooling circuit nominal water flow rate";
    parameter Modelica.SIunits.TemperatureDifference dTChi=2
      "Temperature difference between entering and leaving water of EIR chiller(+ve)";
    parameter Modelica.Fluid.Types.Dynamics fixedEnergyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
      "Formulation of energy balance for mixing volume at inlet and outlet"
      annotation (Dialog(group="Dynamics"));
    parameter Boolean show_T=true
      "= true, if actual temperature at port is computed"
      annotation (Dialog(tab="Advanced"));

    final parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa")=1000
      "Pressure difference at nominal flow rate"
        annotation (Dialog(group="Design Parameter"));

  //----------------------water to water chiller or heat pump system-----------------
    parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=datChi.mEva_flow_nominal
     "Condenser nominal water flow rate" annotation (Dialog(group="EIR CHILLER system"));
    parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=datChi.mEva_flow_nominal
     "Evaporator nominal water flow rate" annotation (Dialog(group="EIR Chiller system"));
    parameter Modelica.SIunits.PressureDifference dpCon_nominal
      "Pressure difference accross the condenser"
        annotation (Dialog(group="EIR Chiller system"));
    parameter Modelica.SIunits.PressureDifference dpEva_nominal
      "Pressure difference accross the evaporator"
        annotation (Dialog(group="EIR Chiller system"));
//---------------------------------Buffer tanks-------------------
    final parameter Modelica.SIunits.Volume VTan = 5*60*mCon_flow_nominal/1000
      "Tank volume, ensure at least 5 minutes buffer flow"
      annotation (Dialog(group="Water Buffer Tank"));
    final parameter Modelica.SIunits.Length hTan = 5
      "Height of tank (without insulation)"
      annotation (Dialog(group="Water Buffer Tank"));
    final parameter Modelica.SIunits.Length dIns = 0.3
      "Thickness of insulation"
        annotation (Dialog(group="Water Buffer Tank"));
    final parameter Integer nSegTan=10   "Number of volume segments"
        annotation (Dialog(group="Water Buffer Tank"));
    parameter Modelica.SIunits.TemperatureDifference THys
      "Temperature hysteresis"
        annotation (Dialog(group="Water Buffer Tank"));
 //----------------------------Borefield system----------------------------------
    parameter Modelica.SIunits.TemperatureDifference dTGeo
      "Temperature difference between entering and leaving water of the borefield (+ve)"
        annotation (Dialog(group="Borefield"));
    final parameter Modelica.SIunits.MassFlowRate mGeo_flow_nominal= m_flow_nominal*dTChi/dTGeo
      "Borefiled nominal water flow rate"
        annotation (Dialog(group="Borefield"));
    final parameter Modelica.SIunits.MassFlowRate mBor_flow_nominal= mGeo_flow_nominal/(nXBorHol*nYBorHol)
      "Borefiled nominal water flow rate"
        annotation (Dialog(group="Borefield"));
    parameter Modelica.SIunits.Length xBorFie
      "Borefield length"
        annotation (Dialog(group="Borefield"));
    parameter Modelica.SIunits.Length yBorFie
      "Borefield width"
        annotation (Dialog(group="Borefield"));
    final parameter Modelica.SIunits.Length dBorHol = 5
      "Distance between two boreholes"
        annotation (Dialog(group="Borefield"));
    parameter Modelica.SIunits.Pressure dpBorFie_nominal
      "Pressure losses for the entire borefield"
        annotation (Dialog(group="Borefield"));
    final parameter Integer nXBorHol = integer((xBorFie+dBorHol)/dBorHol)
      "Number of boreholes in x-direction"
        annotation(Dialog(group="Borefield"));
    final parameter Integer nYBorHol = integer((yBorFie+dBorHol)/dBorHol)
      "Number of boreholes in y-direction"
        annotation(Dialog(group="Borefield"));
    final parameter  Integer nBorHol = nXBorHol*nYBorHol
     "Number of boreholes"
        annotation(Dialog(group="Borefield"));
    parameter Modelica.SIunits.Radius rTub =  0.05
     "Outer radius of the tubes"
        annotation(Dialog(group="Borefield"));
    parameter Boolean allowFlowReversal = false
      "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
        annotation(Dialog(tab="Assumptions"), Evaluate=true);

//---------------------------DistrictHeatExchanger----------
    final parameter Modelica.SIunits.MassFlowRate mHex_flow_nominal= m_flow_nominal*dTChi/dTHex
      "District heat exhanger nominal water flow rate"
      annotation (Dialog(group="DistrictHeatExchanger"));
    parameter Real eps_nominal=0.71
      "Heat exchanger effectiveness"
      annotation (Dialog(group="DistrictHeatExchanger"));
   final parameter  Modelica.SIunits.PressureDifference dpHex_nominal(displayUnit="Pa")=50000
      "Pressure difference across heat exchanger"
      annotation (Dialog(group="DistrictHeatExchanger"));
    parameter Modelica.SIunits.TemperatureDifference dTHex
      "Temperature difference between entering and leaving water of the district heat exchanger(+ve)"
      annotation (Dialog(group="DistrictHeatExchanger"));
 //----------------------------Performance data records-----------------------------
    parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic datChi
    "EIR chiller performance data."
      annotation (Placement(transformation(extent={{-292,-280},{-272,-260}})));
    final parameter Fluid.Geothermal.Borefields.Data.Filling.Bentonite filDat(kFil=2.1)
      annotation (Placement(transformation(extent={{-292,-184},{-272,-164}})));
    final parameter Fluid.Geothermal.Borefields.Data.Soil.SandStone soiDat(
      kSoi=2.42,
      dSoi=1920,
      cSoi=1210)
      "Soil data"
      annotation (Placement(transformation(extent={{-292,-208},{-272,-188}})));
    final parameter Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Template conDat(
      final borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
      final use_Rb=false,
      final mBor_flow_nominal=mBor_flow_nominal,
      final mBorFie_flow_nominal=mGeo_flow_nominal,
      final hBor=244,
      final dBor=1,
      final rBor=0.2,
      final rTub=rTub,
      final kTub=0.5,
      final eTub=0.002,
      final cooBor={{dBorHol*mod((i - 1), nXBorHol),dBorHol*floor((i - 1)/
                     nXBorHol)} for i in 1:nBorHol},
      final xC=0.075,
      final dp_nominal=dpBorFie_nominal)
    "Borefield configuration"
      annotation (Placement(transformation(extent={{-292,-232},{-272,-212}})));
    final parameter Fluid.Geothermal.Borefields.Data.Borefield.Template borFieDat(
       final filDat=filDat,
       final soiDat=soiDat,
       final conDat=conDat)
      "Borefield parameters"
      annotation (Placement(transformation(extent={{-292,-256},{-272,-236}})));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetCooMin(
    final unit="K",displayUnit="degC")
    "Minimum cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-320,54},{-300,74}}),
    iconTransformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMaxBorEnt(
    final unit="K",displayUnit="degC")
    "Maximum allowed enetring water temperature to the borefiled holes"
    annotation (Placement(transformation(extent={{-320,-84},{-300,-64}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMinConEnt(
    final unit="K",displayUnit="degC")
    "Minimum condenser entering water temperature"
    annotation (Placement(transformation(extent={{-320,40},{-300,60}}),
      iconTransformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMaxEvaEnt(
    final unit="K",displayUnit="degC")
    "Maximum evaporator entering water temperature"
    annotation (Placement(transformation(extent={{-320,26},{-300,46}}),
    iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetHea(
    final unit="K",displayUnit="degC")
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-340,116},{-300,156}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetCoo( final unit="K",displayUnit="degC")
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-320,68},{-300,88}}),
    iconTransformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput modRej
    "Surplus heat or cold rejection mode" annotation (Placement(transformation(
          extent={{300,-100},{320,-80}}), iconTransformation(extent={{100,60},{
            140,100}})));
  Modelica.Fluid.Interfaces.FluidPort_a heaWatRet(
    h_outflow(start=Medium.h_default, nominal=Medium.h_default),
    redeclare final package Medium = Medium,
    p(start=Medium.p_default))
    "Heating water return port"
    annotation (Placement(transformation(extent={{290,-50},{310,-30}}),
      iconTransformation(extent={{90,-50},{110,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b heaWatSup(
    h_outflow(start=Medium.h_default, nominal=Medium.h_default),
    redeclare final package Medium = Medium,
    p(start=Medium.p_default)) "Heating water supply port"
    annotation (Placement(transformation(extent={{310,30},{290,50}}),
      iconTransformation(extent={{110,-90},{90,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_a disWatSup(
    p(start=Medium.p_default),
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "District water supply port"
    annotation (Placement(transformation(extent={{290,-202},{310,-182}}),
      iconTransformation(extent={{-30,-110},{-10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b disWatRet(
    p(start=Medium.p_default),
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "District water return port"
    annotation (Placement(transformation(extent={{310,-160},{290,-140}}),
      iconTransformation(extent={{30,-110},{10,-90}})));
  // COMPONENTS
  //// TANKS
  BaseClasses.StratifiedTank tanHeaWat(
    redeclare final package Medium = Medium,
    VTan=VTan,
    hTan=hTan,
    dIns=dIns,
    nSeg=nSegTan,
    show_T=show_T,
    energyDynamics=fixedEnergyDynamics,
    m_flow_nominal=mCon_flow_nominal,
    T_start=293.15,
    TFlu_start=(20 + 273.15)*ones(nSegTan),
    tau(displayUnit="s")) "Heating water buffer tank"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  BaseClasses.StratifiedTank tanChiWat(
    redeclare final package Medium = Medium,
    VTan=VTan,
    hTan=hTan,
    dIns=dIns,
    nSeg=nSegTan,
    show_T=show_T,
    m_flow_nominal=mEva_flow_nominal,
    energyDynamics=fixedEnergyDynamics,
    T_start=288.15,
    TFlu_start=(15 + 273.15)*ones(nSegTan),
    tau(displayUnit="s")) "Chilled water buffer tank"
    annotation (Placement(transformation(extent={{-236,50},{-216,70}})));
  //// BOREFIELD
  Fluid.Movers.FlowControlled_m_flow pumBor(
    redeclare final package Medium = Medium,
    m_flow_nominal=mGeo_flow_nominal,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpBorFie_nominal,0}, V_flow={0,mGeo_flow_nominal/1000})),
    use_inputFilter=true,
    riseTime=10)
    "Pump that forces the flow rate to be set to the control signal"
     annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,  origin={-70,-150})));
  //// DISTRICT HX
  BaseClasses.WaterWaterHeatExchanger hex(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    dp1_nominal=dpHex_nominal,
    eps_nominal=eps_nominal,
    dp2_nominal=dpHex_nominal,
    m1_flow_nominal=mHex_flow_nominal,
    m2_flow_nominal=mHex_flow_nominal)
    "Heat exchanger"
     annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={192,-234})));
  Fluid.Movers.FlowControlled_m_flow pumHexDis(
    redeclare final package Medium = Medium,
    m_flow_nominal=mHex_flow_nominal,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpHex_nominal,0}, V_flow={0,mHex_flow_nominal/1000})),
    use_inputFilter=true,
    riseTime=10)
    "Pump (or valve) that forces the flow rate to be set to the control signal"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=270,
      origin={110,-110})));
  //// CONTROLLERS
  Controls.Supervisory ETSCon(THys=THys) "ETS supervisory controller"
    annotation (Placement(transformation(extent={{-198,200},{-178,220}})));
  Controls.AmbientCircuit ambCon(dTGeo=dTGeo, dTHex=dTHex)
    "Control of the ambient circuit"
    annotation (Placement(transformation(extent={{-248,-132},{-228,-112}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiMDisHex(k=mHex_flow_nominal)
    "Gain for mass flow of heat exchanger"
    annotation (Placement(transformation(extent={{40,-262},{60,-242}})));
  //// SENSORS
  Fluid.Sensors.TemperatureTwoPort TBorLvg(
    tau=0,
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mGeo_flow_nominal)
    "Borefield system leaving water temperature"
      annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-210})));
  Fluid.Sensors.TemperatureTwoPort TBorEnt(
    tau=0,
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mGeo_flow_nominal)
    "Entering water temperature to the borefield system"
    annotation (Placement(
      transformation(
      extent={{-10,10},{10,-10}},
      rotation=270,
      origin={-70,-174})));
  Fluid.Sensors.TemperatureTwoPort TDisHex(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    tau=10,
    m_flow_nominal=mHex_flow_nominal)
  "Entering water tmperature to the district heat exchanger"
   annotation (Placement(transformation(extent={{-10,10},{10,-10}},
     rotation=270, origin={110,-70})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor topCooTan
    "Chilled water tank top temperature"
    annotation (Placement(transformation(extent={{-230,90},{-250,110}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor botCooTan
    "Chilled water tank bottom temperature"
    annotation (Placement(transformation(extent={{-230,10},{-250,30}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor topHotTan
    "Heating water tank top temperature"
    annotation (Placement(transformation(extent={{214,198},{194,218}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor botHotTan
    "Heating water tank bottom temperature"
    annotation (Placement(transformation(extent={{176,-42},{196,-22}})));
//------hydraulic header------------------------------------------------------------
  Fluid.FixedResistances.Junction splBor(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final dp_nominal=200*{1,-1,-1},
    from_dp=false,
    tau=1,
    m_flow_nominal={mGeo_flow_nominal,-mGeo_flow_nominal,-mGeo_flow_nominal},
    redeclare final package Medium = Medium)
    "Flow splitter for the borefield water circuit"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-30,-170})));
 //-----------------------------Valves----------------------------------------------
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valBor(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    m_flow_nominal=mGeo_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000,
    homotopyInitialization=true)
    "Three way valve modulated to control the entering water temperature to the borefield system"
      annotation (Placement(transformation(extent={{10,-10},{-10,10}},
                                        rotation=90,
                                        origin={-70,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiBor(k=mGeo_flow_nominal)
    "Gain for mass flow rate of borefield"
      annotation (Placement(transformation(extent={{-110,-160},{-90,-140}})));
  Fluid.Geothermal.Borefields.OneUTube borFie(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    borFieDat=borFieDat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=show_T,
    dT_dz=0,
    TExt0_start=285.95)
    "Geothermal borefield"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,-202})));
equation
  connect(tanChiWat.heaPorVol[1], topCooTan.port)
    annotation (Line(points={{-226,60},{-226,100},{-230,100}},
                                                            color={191,0,0},
      pattern=LinePattern.Dash));
  connect(tanChiWat.heaPorVol[nSegTan], botCooTan.port)
    annotation (Line(points={{-226,60},{-226,20},{-230,20}},
                                     color={191,0,0},
      pattern=LinePattern.Dash));
  connect(tanHeaWat.heaPorVol[nSegTan], botHotTan.port)
    annotation (Line(points={{170,40},{170,-32},{176,-32}},color={191,0,0},
      pattern=LinePattern.Dash));
  connect(tanHeaWat.heaPorVol[1], topHotTan.port)
    annotation (Line(points={{170,40},{170,58},{214,58},{214,208}},color={191,0,0},
      pattern=LinePattern.Dash));
  connect(topHotTan.T,ETSCon. TTanHeaTop)
    annotation (Line(
      points={{194,208},{84,208},{84,246},{-204,246},{-204,219},{-199,219}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(botHotTan.T,ETSCon. TTanHeaBot)
    annotation (Line(
      points={{196,-32},{224,-32},{224,250},{-206,250},{-206,217},{-199,217}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(topCooTan.T,ETSCon. TTanCooTop)
    annotation (Line(
      points={{-250,100},{-266,100},{-266,201},{-199,201}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(botCooTan.T,ETSCon. TTanCooBot)
    annotation (Line(
      points={{-250,20},{-274,20},{-274,203},{-199,203}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(hex.port_a1, pumHexDis.port_b)
    annotation (Line(points={{186,-224},{186,-154},{110,-154},{110,-120}},
                                                               color={0,127,
          255}, thickness=0.5));
  connect(pumHexDis.port_a, TDisHex.port_b)
    annotation (Line(points={{110,-100},{110,-80}},color={0,127,255},
      thickness=0.5));
  connect(TMaxBorEnt, ambCon.TBorMaxEnt) annotation (Line(
      points={{-310,-74},{-172,-74},{-172,-127},{-249,-127}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(ambCon.TDisHexEnt, TDisHex.T) annotation (Line(
      points={{-249,-128},{-162,-128},{-162,-288},{90,-288},{90,-70},{99,-70}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(valBor.port_3, splBor.port_3) annotation (Line(
      points={{-60,-110},{-50,-110},{-50,-170},{-40,-170}},
      color={0,127,255},
      thickness=0.5));
  connect(TBorLvg.port_b, splBor.port_1)
    annotation (Line(points={{-30,-200},{-30,-180}}, color={0,127,255}));
  connect(gaiMDisHex.y, pumHexDis.m_flow_in) annotation (Line(
      points={{62,-252},{80,-252},{80,-110},{98,-110}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ETSCon.reqCoo, ambCon.reqCoo) annotation (Line(
      points={{-177,201},{-166,201},{-166,-118},{-249,-118}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ambCon.reqHea, ETSCon.reqHea) annotation (Line(
      points={{-249,-113},{-156,-113},{-156,219},{-177,219}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.valHea, ambCon.valHea) annotation (Line(
      points={{-177,217},{-158,217},{-158,-114},{-249,-114}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.valCoo, ambCon.valCoo) annotation (Line(
      points={{-177,215},{-160,215},{-160,-115},{-249,-115}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ambCon.rejCooFulLoa,ETSCon. rejColFulLoa) annotation (Line(
      points={{-249,-117},{-164,-117},{-164,202.8},{-177,202.8}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.rejHeaFulLoa, ambCon.rejHeaFulLoa) annotation (Line(
      points={{-177,204.8},{-162,204.8},{-162,-116},{-249,-116}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(valBor.port_2, pumBor.port_a) annotation (Line(points={{-70,-120},{
          -70,-140}},            color={0,127,255},
      thickness=0.5));
  connect(ambCon.modRej, modRej) annotation (Line(points={{-227,-122},{60,-122},
          {60,-90},{310,-90}}, color={255,127,0}));
  connect(pumBor.port_b, TBorEnt.port_a)
    annotation (Line(points={{-70,-160},{-70,-164}}, color={0,127,255}));
  connect(ambCon.yBorThrVal, valBor.y) annotation (Line(points={{-227,-116},{
          -94,-116},{-94,-110},{-82,-110}},
                                         color={0,0,127}));
  connect(ambCon.yDisHexPum, gaiMDisHex.u) annotation (Line(points={{-227,-130},
          {-120,-130},{-120,-252},{38,-252}},  color={0,0,127}));
  connect(tanHeaWat.port_b1,heaWatSup)  annotation (Line(points={{160,47},{160,40},
          {300,40}},                                               color={0,127,
          255}));
  connect(TBorEnt.T, ambCon.TBorEnt) annotation (Line(
      points={{-81,-174},{-154,-174},{-154,-131},{-249,-131}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TBorLvg.T, ambCon.TBorLvg) annotation (Line(
      points={{-41,-210},{-50,-210},{-50,-228},{-156,-228},{-156,-130},{-249,
          -130}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(tanHeaWat.port_a1,heaWatRet)  annotation (Line(points={{179.8,33},{288,
          33},{288,-40},{300,-40}}, color={0,127,255}));
  connect(gaiBor.u, ambCon.yBorPum) annotation (Line(points={{-112,-150},{-112,
          -126},{-227,-126}},
                         color={0,0,127}));
  connect(pumBor.m_flow_in, gaiBor.y)
    annotation (Line(points={{-82,-150},{-88,-150}}, color={0,0,127}));
  connect(TBorEnt.port_b, borFie.port_a)
    annotation (Line(points={{-70,-184},{-70,-192}}, color={0,127,255}));
  connect(borFie.port_b, TBorLvg.port_a) annotation (Line(points={{-70,-212},{-70,
          -236},{-30,-236},{-30,-220}}, color={0,127,255}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false),
   graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,60},{62,-60}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
       Text(
          extent={{-150,146},{150,106}},
          textString="%name",
          lineColor={0,0,255})}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
                  extent={{-300,-300},{300,300}}),
                  graphics={Line(
                  points={{86,92}},
                  color={28,108,200},
                  pattern=LinePattern.Dash)}),
        defaultComponentName="ets",
Documentation(info="<html>
<p>
This models represents an energy transfer station (ETS) for fifth generation 
district heating and cooling systems. 
The control logic is based on five operating modes:
</p>
<ul>
<li>
heating only,
</li>
<li>
cooling only,
</li>
<li>
simultaneous heating and cooling,
</li>
<li>
part surplus heat or cold rejection,
</li>
<li>
full surplus heat or cold rejection.
</li>
</ul>
<p align=\"center\">
<img alt=\"Image the 5th generation of district heating and cooling substation\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/SubstationModifiedLayout.png\"/>
<p>
The substation layout consists in three water circuits:
</p>
<ol>
<li>
the heating water circuit, which is connected to the building heating water
distribution system,
</li>
<li>
the chilled water circuit, which is connected to the building chilled water
distribution system,
</li>
<li>
the ambient water circuit, which is connected to the district heat exchanger 
(and optionally to the geothermal borefield).
</li>
</ol>
<h4>Heating water circuit</h4>
<p>
It satisfies the building heating requirements and consists in:
</p>
<ol>
<li>
the heating/cooling generating source, where the EIR chiller i.e. condenser heat exchanger operates to satisfy the heating setpoint
<code>TSetHea</code>.
</li>
<li>
The constant speed condenser water pump <code>pumCon</code>.
</li>
<li>
The hot buffer tank, is implemented to provide hydraulic decoupling between the primary (the ETS side) and secondary (the building side)
water circulators i.e. pumps and to eliminate the cycling of the heat generating source machine i.e EIR chiller.
</li>
<li>
Modulating mixing three way valve <code>valCon</code> to control the condenser entering water temperature.
</li>
</ol>
<h4>Chilled water circuit</h4>
<p>
It operates to satisfy the building cooling requirements and consists of
</p>
<ol>
<li>
The heating/cooling generating source, where the  EIR chiller i.e evaporator heat
exchanger operates to satisfy the cooling setpoint <code>TSetCoo</code>.
</li>
<li>
The constant speed evaporator water pump <code>pumEva</code>.
</li>
<li>
The chilled water buffer tank, is implemented obviously for the same mentioned reasons of the hot buffer tank.
</li>
<li>
Modulating mixing three way valve <code>valEva</code> to control the evaporator entering water temperature.
</li>
</ol>
<p>
For more detailed description of
</p>
<p>
The controller of heating/cooling generating source, see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ChillerController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ChillerController.</a>
</p>
<p>
The evaporator pump <code>pumEva</code> and the condenser pump <code>pumCon</code>, see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.PrimaryPumpsConstantSpeed\">
Buildings.Applications.DHC.EnergyTransferStations.Control.PrimaryPumpsConstantSpeed.</a>
</p>
<h4>Ambient water circuit</h4>
<p>
The ambient water circuit operates to maximize the system exergy by rejecting surplus i.e. heating or cooling energy
first to the borefield system and second to either or both of the borefield and the district systems.
It consists of
</p>
<ol>
<li>
The borefield component model <code>borFie</code>.
</li>
<li>
The borefield pump <code>pumBor</code>, where its mass flow rate is modulated using a reverse action PI controller.
</li>
<li>
Modulating mixing three way valve <code>valBor</code> to control the borefield entering water temperature.
</li>
<li>
The heat exchanger component model <code>hex</code>.
</li>
<li>
The heat exchanger district pump <code>pumHexDis</code>, where its mass flow rate is modulated using a reverse action PI controller.
</li>
<li>
Two on/off 2-way valves <code> valHea</code>, <code>valCoo</code>
which separates the ambient from the chilled water and heating water circuits.
</ol>
<p>
For more detailed description of the ambient circuit control concept see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.AmbientCircuitController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.AmbientCircuitController.</a>
</p>
<h4>Notes</h4>
<p>
For more detailed description of the finite state machines which transitions the ETS between
different operational modes, see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController</a> and
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
January 18, 2020, by Hagar Elarga: <br/>
First implementation
</li>
</ul>
</html>"));
end FifthGenHRChiller;
