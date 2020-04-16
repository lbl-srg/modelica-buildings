within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration;
model HeatRecoveryChiller
  "Energy transfer station model for fifth generation DHC systems with heat recovery chiller"
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
    have_pum=true,
    nPorts_bBui=2,
    nPorts_aBui=2);

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

  final parameter Modelica.SIunits.PressureDifference dp_nominal(
    displayUnit="Pa") = 1000
    "Pressure difference at nominal flow rate"
      annotation (Dialog(group="Design Parameter"));

  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=datChi.mEva_flow_nominal
    "Condenser nominal water flow rate"
    annotation (Dialog(group="EIR CHILLER system"));
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=datChi.mEva_flow_nominal
    "Evaporator nominal water flow rate"
    annotation (Dialog(group="EIR Chiller system"));
  parameter Modelica.SIunits.PressureDifference dpCon_nominal
    "Pressure difference accross the condenser"
    annotation (Dialog(group="EIR Chiller system"));
  parameter Modelica.SIunits.PressureDifference dpEva_nominal
    "Pressure difference accross the evaporator"
    annotation (Dialog(group="EIR Chiller system"));
  parameter Modelica.SIunits.Temperature TChiWatSupSetMin(
    displayUnit="degC")
    "Minimum value of chilled water supply temperature set-point";
  parameter Modelica.SIunits.Temperature TConWatEntMin(
    displayUnit="degC")
    "Minimum value of condenser water entering temperature";
  parameter Modelica.SIunits.Temperature TEvaWatEntMax(
    displayUnit="degC")
    "Maximum value of evaporator water entering temperature";


  final parameter Modelica.SIunits.Volume VTan = 5*60*mCon_flow_nominal/1000
    "Tank volume, ensure at least 5 minutes buffer flow"
    annotation (Dialog(group="Water Buffer Tank"));
  final parameter Modelica.SIunits.Length hTan = 5
    "Height of tank (without insulation)"
    annotation (Dialog(group="Water Buffer Tank"));
  final parameter Modelica.SIunits.Length dIns = 0.3
    "Thickness of insulation"
    annotation (Dialog(group="Water Buffer Tank"));
  final parameter Integer nSegTan=10
    "Number of volume segments"
    annotation (Dialog(group="Water Buffer Tank"));
  parameter Modelica.SIunits.TemperatureDifference THys
    "Temperature hysteresis"
    annotation (Dialog(group="Water Buffer Tank"));

  parameter Modelica.SIunits.TemperatureDifference dTGeo_nominal
    "Borefield deltaT (outlet - inlet) at nominal conditions"
    annotation (Dialog(group="Borefield"));
  final parameter Modelica.SIunits.MassFlowRate mGeo_flow_nominal=
    m_flow_nominal * dTChi / abs(dTGeo)
    "Borefield water mass flow rate at nominal conditions"
    annotation (Dialog(group="Borefield"));
  final parameter Modelica.SIunits.MassFlowRate mBor_flow_nominal = mGeo_flow_nominal/(nXBorHol*nYBorHol)
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

  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic datChi
    "EIR chiller performance data."
    annotation (Placement(transformation(extent={{-260,-280},{-240,-260}})));
  final parameter Fluid.Geothermal.Borefields.Data.Filling.Bentonite filDat(kFil=2.1)
    annotation (Placement(transformation(extent={{-260,-184},{-240,-164}})));
  final parameter Fluid.Geothermal.Borefields.Data.Soil.SandStone soiDat(
    kSoi=2.42,
    dSoi=1920,
    cSoi=1210)
    "Soil data"
    annotation (Placement(transformation(extent={{-260,-208},{-240,-188}})));
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
    annotation (Placement(transformation(extent={{-260,-232},{-240,-212}})));
  final parameter Fluid.Geothermal.Borefields.Data.Borefield.Template borFieDat(
    final filDat=filDat,
    final soiDat=soiDat,
    final conDat=conDat)
    "Borefield parameters"
    annotation (Placement(transformation(extent={{-260,-256},{-240,-236}})));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput modRej
    "Surplus heat or cold rejection mode"
    annotation (Placement(transformation(extent={{300,-100},{320,-80}}),
      iconTransformation(extent={{300,-200}, {380,-120}})));
  // COMPONENTS
  FifthGeneration.BaseClasses.StratifiedTank tanHeaWat(
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
    tau(displayUnit="s"))
    "Heating water buffer tank"
    annotation (Placement(transformation(extent={{158,184},{178,204}})));
  FifthGeneration.BaseClasses.StratifiedTank tanChiWat(
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
    tau(displayUnit="s"))
    "Chilled water buffer tank"
    annotation (Placement(transformation(extent={{-216,152},{-196,172}})));
  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    use_Q_flow_nominal = false,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    show_T=false,
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    dp1_nominal=dpHex_nominal,
    eps_nominal=eps_nominal,
    dp2_nominal=dpHex_nominal,
    m1_flow_nominal=mHex_flow_nominal,
    m2_flow_nominal=mHex_flow_nominal)
    "District heat exchanger"
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
      origin={74,-194})));
  //// CONTROLLERS
  FifthGeneration.Controls.Supervisory ETSCon(THys=THys)
    "ETS supervisory controller"
    annotation (Placement(transformation(extent={{-202,262},{-182,282}})));
  FifthGeneration.Controls.AmbientCircuit ambCon(dTGeo=dTGeo, dTHex=dTHex)
    "Control of the ambient circuit"
    annotation (Placement(transformation(extent={{-110,-138},{-90,-118}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiMDisHex(k=mHex_flow_nominal)
    "Gain for mass flow of heat exchanger"
    annotation (Placement(transformation(extent={{-44,-168},{-24,-148}})));
  //// SENSORS
  Fluid.Sensors.TemperatureTwoPort senTDisHX2Ent(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    tau=10,
    m_flow_nominal=mHex_flow_nominal)
    "District heat exchanger secondary water entering temperature (measured)"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={74,-154})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTTopChiWat
    "Chilled water tank top temperature"
    annotation (Placement(transformation(extent={{-228,184},{-248,204}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTBotChiWat
    "Chilled water tank bottom temperature"
    annotation (Placement(transformation(extent={{-230,110},{-250,130}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTTopHeaWat
    "Heating water tank top temperature (measured)"
    annotation (Placement(transformation(extent={{204,222},{184,242}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTBotHeaWat
    "Heating water tank bottom temperature (measured)"
    annotation (Placement(transformation(extent={{180,142},{200,162}})));
//------hydraulic header------------------------------------------------------------
 //-----------------------------Valves----------------------------------------------
  BaseClasses.SubsystemChiller chi
    annotation (Placement(transformation(extent={{-14,-14},{14,14}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(final unit="K",
      displayUnit="degC") "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-340,-40},{-300,0}}),
        iconTransformation(extent={{-382,20},{-300,102}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(final unit="K",
      displayUnit="degC")
    "Chilled water supply temperature set-point (may be reset down)"
    annotation (Placement(transformation(extent={{-340,-80},{-300,-40}}),
        iconTransformation(extent={{-382,-42},{-300,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling mode enabled signal"        annotation (Placement(transformation(
          extent={{-340,0},{-300,40}}),    iconTransformation(extent={{-382,78},
            {-300,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating mode enabled signal"        annotation (Placement(transformation(
          extent={{-340,40},{-300,80}}),   iconTransformation(extent={{-382,140},
            {-300,222}})));
  Fluid.Actuators.Valves.TwoWayLinear valConDir(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpFixed_nominal=0,
    show_T=true,
    dpValve_nominal=dpValAmb_nominal,
    riseTime=10,
    l=1e-8,
    m_flow_nominal=mCon_flow_nominal)
    "Two-way directional valve"
    annotation (Placement(transformation(extent={{124,-514},{104,-494}})));
  Fluid.Actuators.Valves.TwoWayLinear valEvaDir(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpFixed_nominal=0,
    show_T=true,
    dpValve_nominal=dpValAmb_nominal,
    riseTime=10,
    l=1e-8,
    m_flow_nominal=mEva_flow_nominal)
    "Two-way directional valve"
    annotation (Placement(transformation(extent={{-116,-514},{-96,-494}})));
  BaseClasses.Junction
           splEvaSup(m_flow_nominal=mEva_flow_nominal .* {1,-1,-1}, redeclare
      final package Medium = Medium)
    "Flow splitter"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-186,-384})));
  BaseClasses.Junction
           splAmbRet(m_flow_nominal=max(mEva_flow_nominal, mCon_flow_nominal)
         .* {1,1,-1}, redeclare final package Medium = Medium)
    "Flow splitter"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={34,-504})));
  BaseClasses.Junction
           splConSup(m_flow_nominal=mCon_flow_nominal .* {1,-1,-1}, redeclare
      final package Medium = Medium)
    "Flow splitter"
    annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={174,-384})));
  BaseClasses.Junction
           splAmbSup(m_flow_nominal=max(mEva_flow_nominal, mCon_flow_nominal)
         .* {-1,-1,1}, redeclare final package Medium = Medium)
    "Flow splitter"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-46,-564})));
  BaseClasses.Junction
           splConRet(m_flow_nominal=mCon_flow_nominal .* {1,-1,1}, redeclare
      final package Medium = Medium)
    "Flow splitter"
    annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-226,-464})));
  BaseClasses.Junction
           splEvaRet(m_flow_nominal=mEva_flow_nominal .* {1,-1,1}, redeclare
      final package Medium = Medium)
    "Flow splitter"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={214,-464})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aHeaWat(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid port for heating water return"
    annotation (Placement(transformation(extent={{244,-474},{264,-454}}),
        iconTransformation(extent={{250,-50},{270,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHeaWat(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid port for heating water supply"
    annotation (Placement(transformation(extent={{244,-394},{264,-374}}),
        iconTransformation(extent={{250,30},{270,50}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
    manChiWatSup(nPorts_a=1, nPorts_b=1) "Chilled water supply manifold"
    annotation (Placement(transformation(extent={{-110,90},{-130,110}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
    manHeaWatSup(nPorts_a=1, nPorts_b=1) "Heating water supply manifold"
    annotation (Placement(transformation(extent={{78,164},{98,184}})));
equation
  connect(senTTopHeaWat.T, ETSCon.TTanHeaTop) annotation (Line(
      points={{184,232},{84,232},{84,246},{-204,246},{-204,281},{-203,281}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(hex.port_a1, pumHexDis.port_b)
    annotation (Line(points={{186,-224},{186,-218},{182,-218},{182,-210},{74,
          -210},{74,-204}},                                    color={0,127,
          255}, thickness=0.5));
  connect(pumHexDis.port_a, senTDisHX2Ent.port_b) annotation (Line(
      points={{74,-184},{74,-164}},
      color={0,127,255},
      thickness=0.5));
  connect(ambCon.TDisHexEnt, senTDisHX2Ent.T) annotation (Line(
      points={{-111,-134},{-162,-134},{-162,-288},{90,-288},{90,-154},{63,-154}},
      color={0,0,127},
      pattern=LinePattern.Dot));

  connect(gaiMDisHex.y, pumHexDis.m_flow_in) annotation (Line(
      points={{-22,-158},{80,-158},{80,-194},{62,-194}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ETSCon.yCoo, ambCon.reqCoo) annotation (Line(
      points={{-181,263},{-166,263},{-166,-124},{-111,-124}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ambCon.reqHea, ETSCon.yHea) annotation (Line(
      points={{-111,-119},{-156,-119},{-156,281},{-181,281}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.valHea, ambCon.valHea) annotation (Line(
      points={{-177,217},{-158,217},{-158,-120},{-111,-120}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.valCoo, ambCon.valCoo) annotation (Line(
      points={{-177,215},{-160,215},{-160,-121},{-111,-121}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ambCon.rejCooFulLoa, ETSCon.yColRej) annotation (Line(
      points={{-111,-123},{-164,-123},{-164,264.8},{-181,264.8}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.yHeaRej, ambCon.rejHeaFulLoa) annotation (Line(
      points={{-181,266.8},{-162,266.8},{-162,-122},{-111,-122}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ambCon.modRej, modRej) annotation (Line(points={{-89,-128},{60,-128},
          {60,-90},{310,-90}}, color={255,127,0}));
  connect(ambCon.yDisHexPum, gaiMDisHex.u) annotation (Line(points={{-89,-136},
          {-120,-136},{-120,-158},{-46,-158}}, color={0,0,127}));
  connect(uHea, chi.uHea) annotation (Line(points={{-320,60},{-20,60},{-20,12},
          {-16,12}}, color={255,0,255}));
  connect(uCoo, chi.uCoo) annotation (Line(points={{-320,20},{-30,20},{-30,10},
          {-16,10}}, color={255,0,255}));
  connect(THeaWatSupSet, chi.THeaWatSupSet) annotation (Line(points={{-320,-20},
          {-30,-20},{-30,8},{-16,8}}, color={0,0,127}));
  connect(TChiWatSupSet, chi.TChiWatSupSet) annotation (Line(points={{-320,-60},
          {-20,-60},{-20,6},{-16,6}}, color={0,0,127}));
  connect(splEvaSup.port_2,valEvaDir. port_a) annotation (Line(points={{-186,
          -394},{-186,-504},{-116,-504}},
                                  color={0,127,255}));
  connect(valEvaDir.port_b,splAmbRet. port_1)
    annotation (Line(points={{-96,-504},{24,-504}},
                                                  color={0,127,255}));
  connect(splAmbRet.port_2,valConDir. port_b)
    annotation (Line(points={{44,-504},{104,-504}},
                                                  color={0,127,255}));
  connect(splConMix.port_2,splConSup. port_1) annotation (Line(points={{124,
          -284},{174,-284},{174,-374}},
                               color={0,127,255}));
  connect(splConSup.port_2,valConDir. port_a) annotation (Line(points={{174,
          -394},{174,-504},{124,-504}},
                                color={0,127,255}));
  connect(splAmbSup.port_2,splEvaRet. port_1) annotation (Line(points={{-36,
          -564},{214,-564},{214,-474}},
                                 color={0,127,255}));
  connect(splConRet.port_2, valConMix.port_1) annotation (Line(points={{-226,
          -454},{-226,-284},{-156,-284}},
                                  color={0,127,255}));
  connect(splAmbSup.port_1,splConRet. port_1) annotation (Line(points={{-56,
          -564},{-226,-564},{-226,-474}},
                                   color={0,127,255}));
  connect(port_bChiWat,splEvaSup. port_3)
    annotation (Line(points={{-266,-384},{-196,-384}},
                                                   color={0,127,255}));
  connect(port_aChiWat,splEvaRet. port_3) annotation (Line(points={{-266,-464},
          {-246,-464},{-246,-484},{14,-484},{14,-464},{204,-464}},
                                                        color={0,127,255}));
  connect(splConSup.port_3, port_bHeaWat)
    annotation (Line(points={{184,-384},{254,-384}}, color={0,127,255}));
  connect(port_aHeaWat, splConRet.port_3) annotation (Line(points={{254,-464},{
          234,-464},{234,-444},{-26,-444},{-26,-464},{-216,-464}}, color={0,127,
          255}));
  connect(chi.port_bChiWat, manChiWatSup.ports_a[1]) annotation (Line(points={{
          -14,2},{-40,2},{-40,100},{-114,100}}, color={0,127,255}));
  connect(manChiWatSup.ports_b[1], tanChiWat.port_a1) annotation (Line(points={
          {-126,100},{-162,100},{-162,158},{-196,158}}, color={0,127,255}));
  connect(manHeaWatSup.ports_b[1], tanHeaWat.port_a) annotation (Line(points={{
          94,174},{126,174},{126,194},{158,194}}, color={0,127,255}));
  connect(tanHeaWat.port_b1, ports_bBui[1]) annotation (Line(points={{158,198},
          {228,198},{228,240},{300,240}}, color={0,127,255}));
  connect(tanChiWat.port_b, ports_bBui[2]) annotation (Line(points={{-196,162},
          {52,162},{52,280},{300,280}}, color={0,127,255}));
  connect(ports_aBui[1], tanHeaWat.port_a1) annotation (Line(points={{-300,240},
          {220,240},{220,190},{178,190}}, color={0,127,255}));
  connect(ports_aBui[2], tanChiWat.port_a) annotation (Line(points={{-300,280},
          {-300,160},{-226,160},{-226,162},{-216,162}}, color={0,127,255}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false),
   graphics={
       Text(
          extent={{-150,146},{150,106}},
          textString="%name",
          lineColor={0,0,255})}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
                  extent={{-300,-300},{300,300}}),
                  graphics={Line(
                  points={{86,92}},
                  color={28,108,200},
                  pattern=LinePattern.Dash),
        Text(
          extent={{206,-190},{292,-236}},
          lineColor={255,0,255},
          textString="correct side 1 and 2"),
        Text(
          extent={{204,-122},{290,-168}},
          lineColor={255,0,255},
          textString="have_val
have_pum")}),
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
end HeatRecoveryChiller;
