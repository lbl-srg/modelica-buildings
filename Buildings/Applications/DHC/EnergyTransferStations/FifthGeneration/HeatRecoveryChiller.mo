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
    nPorts_aBui=2,
    nPorts_aDis=1,
    nPorts_bDis=1);

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
    "Chiller parameters"
    annotation (Placement(transformation(extent={{-294,80},{-274,100}})));
  final parameter Fluid.Geothermal.Borefields.Data.Filling.Bentonite datFil(kFil=2.1)
    "Borehole filling material characteristics"
    annotation (Placement(transformation(extent={{-294,152},{-274,172}})));
  final parameter Fluid.Geothermal.Borefields.Data.Soil.SandStone datSoi(
    kSoi=2.42,
    dSoi=1920,
    cSoi=1210) "Soil characteristics"
    annotation (Placement(transformation(extent={{-294,128},{-274,148}})));
  final parameter
    Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Template datCon(
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
    final dp_nominal=dpBorFie_nominal) "Borefield configuration parameters"
    annotation (Placement(transformation(extent={{-294,104},{-274,124}})));

  // IO CONNECTORS
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
    annotation (Placement(transformation(extent={{-220,174},{-240,194}})));
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
    annotation (Placement(transformation(extent={{240,170},{220,190}})));
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
        rotation=180,
        origin={0,-254})));
  Fluid.Movers.FlowControlled_m_flow pum2DisHex(
    redeclare final package Medium = Medium,
    m_flow_nominal=mHex_flow_nominal,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpHex_nominal,0}, V_flow={0,mHex_flow_nominal/1000})),
    use_inputFilter=true,
    riseTime=10) "District heat exchanger secondary pump" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={80,-240})));
  //// CONTROLLERS
  FifthGeneration.Controls.Supervisory conSup(THys=THys)
    "Supervisory controller"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  //// SENSORS
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTTopChiWat
    "Chilled water tank top temperature"
    annotation (Placement(transformation(extent={{220,210},{200,230}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTBotChiWat
    "Chilled water tank bottom temperature"
    annotation (Placement(transformation(extent={{220,130},{200,150}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTTopHeaWat
    "Heating water tank top temperature (measured)"
    annotation (Placement(transformation(extent={{-220,210},{-200,230}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTBotHeaWat
    "Heating water tank bottom temperature (measured)"
    annotation (Placement(transformation(extent={{-220,130},{-200,150}})));
//------hydraulic header------------------------------------------------------------
 //-----------------------------Valves----------------------------------------------
  BaseClasses.SubsystemChiller chi
    annotation (Placement(transformation(extent={{-14,-14},{14,14}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(final unit="K",
      displayUnit="degC") "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-340,0},{-300,40}}),
        iconTransformation(extent={{-382,20},{-300,102}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(final unit="K",
      displayUnit="degC")
    "Chilled water supply temperature set-point (may be reset down)"
    annotation (Placement(transformation(extent={{-340,-40},{-300,0}}),
        iconTransformation(extent={{-382,-42},{-300,40}})));
  EnergyTransferStations.BaseClasses.HydraulicHeader manChiWatSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal = datChi.mEva_flow_nominal,
    nPorts_a=2,
    nPorts_b=1) "Chilled water supply manifold"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  EnergyTransferStations.BaseClasses.HydraulicHeader manHeaWatSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal = datChi.mCon_flow_nominal,
    nPorts_a=2,
    nPorts_b=1) "Heating water supply manifold"
    annotation (Placement(transformation(extent={{-60,30},{-80,50}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
    manHeaWatRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datChi.mCon_flow_nominal,
    nPorts_b=2,
    nPorts_a=1) "Heating water return manifold"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
    manChiWatRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datChi.mEva_flow_nominal,
    nPorts_b=2,
    nPorts_a=1) "Chilled water return manifold"
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
  Fluid.Actuators.Valves.TwoWayLinear valIsoEva(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpFixed_nominal=0,
    show_T=true,
    dpValve_nominal=dpValAmb_nominal,
    riseTime=10,
    m_flow_nominal=datChi.mEva_flow_nominal)
    "Evaporator to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{110,-110},{90,-90}})));
  Fluid.Actuators.Valves.TwoWayLinear valIsoCon(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpFixed_nominal=0,
    show_T=true,
    dpValve_nominal=dpValAmb_nominal,
    riseTime=10,
    m_flow_nominal=datChi.mCon_flow_nominal)
    "Condenser to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
    manAmbWatRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=max(datChi.mEva_flow_nominal, datChi.mCon_flow_nominal),
    nPorts_a=2,
    nPorts_b=2) "Ambient water return manifold"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
    manAmbWatSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=max(datChi.mEva_flow_nominal, datChi.mCon_flow_nominal),
    nPorts_a=2,
    nPorts_b=2) "Ambient water supply manifold"
    annotation (Placement(transformation(extent={{10,-150},{-10,-130}})));

  BaseClasses.SubsystemBorefield subsystemBorefield
    annotation (Placement(transformation(extent={{-160,-190},{-140,-170}})));
  Controls.DistrictHX conDis
    annotation (Placement(transformation(extent={{-160,-230},{-140,-210}})));
equation
  connect(THeaWatSupSet, chi.THeaWatSupSet) annotation (Line(points={{-320,20},
          {-20,20},{-20,8},{-16,8}},  color={0,0,127}));
  connect(TChiWatSupSet, chi.TChiWatSupSet) annotation (Line(points={{-320,-20},
          {-20,-20},{-20,6},{-16,6}}, color={0,0,127}));
  connect(tanHeaWat.port_b1, ports_bBui[1]) annotation (Line(points={{-220,188},
          {-160,188},{-160,240},{300,240}},
                                          color={0,127,255}));
  connect(tanChiWat.port_b, ports_bBui[2]) annotation (Line(points={{220,180},{
          180,180},{180,280},{300,280}},color={0,127,255}));
  connect(ports_aBui[1], tanHeaWat.port_a1) annotation (Line(points={{-300,240},
          {-280,240},{-280,180},{-240,180}},
                                          color={0,127,255}));
  connect(ports_aBui[2], tanChiWat.port_a) annotation (Line(points={{-300,280},{
          -300,276},{280,276},{280,180},{240,180}},     color={0,127,255}));
  connect(chi.port_bChiWat, manChiWatSup.ports_a[1]) annotation (Line(points={{14,2},{
          40,2},{40,40},{66,40}},     color={0,127,255}));
  connect(chi.port_aChiWat, manChiWatRet.ports_b[1]) annotation (Line(points={{14,-2},
          {40,-2},{40,-40},{62,-40}},     color={0,127,255}));
  connect(manHeaWatRet.ports_b[1], chi.port_aHeaWat) annotation (Line(points={{-62,-40},
          {-40,-40},{-40,-2},{-14,-2}},      color={0,127,255}));
  connect(chi.port_bHeaWat, manHeaWatSup.ports_a[1]) annotation (Line(points={{-14,2},
          {-40,2},{-40,40},{-66,40}},    color={0,127,255}));
  connect(manHeaWatSup.ports_b[1], tanHeaWat.port_a) annotation (Line(points={{-76,40},
          {-160,40},{-160,184},{-220,184}},     color={0,127,255}));
  connect(tanHeaWat.port_b, manHeaWatRet.ports_a[1]) annotation (Line(points={{-240,
          184},{-260,184},{-260,-40},{-76,-40}}, color={0,127,255}));
  connect(tanChiWat.port_b1, manChiWatRet.ports_a[1]) annotation (Line(points={{
          240,184},{260,184},{260,-40},{76,-40}}, color={0,127,255}));
  connect(manChiWatSup.ports_b[1], tanChiWat.port_a1) annotation (Line(points={{76,40},
          {180,40},{180,176},{220,176}},        color={0,127,255}));
  connect(valIsoCon.port_b, manAmbWatRet.ports_b[1])
    annotation (Line(points={{-90,-100},{-8,-100}}, color={0,127,255}));
  connect(valIsoEva.port_b, manAmbWatRet.ports_a[1])
    annotation (Line(points={{90,-100},{4,-100}}, color={0,127,255}));
  connect(manChiWatSup.ports_a[2], valIsoEva.port_a) annotation (Line(points={{62,
          40},{62,0},{180,0},{180,-100},{110,-100}}, color={0,127,255}));
  connect(manHeaWatSup.ports_a[2], valIsoCon.port_a) annotation (Line(points={{-62,
          40},{-62,0},{-180,0},{-180,-100},{-110,-100}}, color={0,127,255}));
  connect(manAmbWatSup.ports_a[1], manChiWatRet.ports_b[2])
    annotation (Line(points={{4,-140},{66,-140},{66,-40}}, color={0,127,255}));
  connect(manAmbWatSup.ports_b[1], manHeaWatRet.ports_b[2]) annotation (Line(
        points={{-8,-140},{-66,-140},{-66,-40}}, color={0,127,255}));
  connect(subsystemBorefield.port_b, manAmbWatSup.ports_b[2]) annotation (Line(
        points={{-140,-180},{-4,-180},{-4,-140}}, color={0,127,255}));
  connect(manAmbWatRet.ports_b[2], subsystemBorefield.port_a) annotation (Line(
        points={{-4,-100},{-4,-120},{-180,-120},{-180,-180},{-160,-180}}, color=
         {0,127,255}));
  connect(ports_aDis[1], hex.port_a1)
    annotation (Line(points={{-300,-260},{-10,-260}}, color={0,127,255}));
  connect(hex.port_b1, ports_bDis[1])
    annotation (Line(points={{10,-260},{300,-260}}, color={0,127,255}));
  connect(pum2DisHex.port_b, hex.port_a2) annotation (Line(points={{70,-240},{20,
          -240},{20,-248},{10,-248}}, color={0,127,255}));
  connect(manAmbWatRet.ports_a[2], pum2DisHex.port_a) annotation (Line(points={{
          8,-100},{8,-120},{180,-120},{180,-240},{90,-240}}, color={0,127,255}));
  connect(hex.port_b2, manAmbWatSup.ports_a[2]) annotation (Line(points={{-10,
          -248},{-20,-248},{-20,-240},{-120,-240},{-120,-200},{8,-200},{8,-140}},
                                                                          color=
         {0,127,255}));
  connect(tanHeaWat.heaPorTop, senTTopHeaWat.port) annotation (Line(points={{
          -232,191.4},{-232,220},{-220,220}}, color={191,0,0}));
  connect(tanHeaWat.heaPorBot, senTBotHeaWat.port) annotation (Line(points={{
          -232,176.6},{-232,140},{-220,140}}, color={191,0,0}));
  connect(senTTopHeaWat.T, conSup.TTanHeaTop) annotation (Line(points={{-200,
          220},{-180,220},{-180,80},{-230,80},{-230,55},{-222,55}}, color={0,0,
          127}));
  connect(senTBotHeaWat.T, conSup.TTanHeaBot) annotation (Line(points={{-200,
          140},{-190,140},{-190,120},{-240,120},{-240,52},{-222,52}}, color={0,
          0,127}));
  connect(tanChiWat.heaPorTop, senTTopChiWat.port) annotation (Line(points={{
          228,187.4},{226,187.4},{226,220},{220,220}}, color={191,0,0}));
  connect(tanChiWat.heaPorBot, senTBotChiWat.port) annotation (Line(points={{
          228,172.6},{226,172.6},{226,140},{220,140}}, color={191,0,0}));
  connect(senTBotChiWat.T, conSup.TTanCooBot) annotation (Line(points={{200,140},
          {-172,140},{-172,72},{-226,72},{-226,43},{-222,43}}, color={0,0,127}));
  connect(senTTopChiWat.T, conSup.TTanCooTop) annotation (Line(points={{200,220},
          {-176,220},{-176,76},{-228,76},{-228,46},{-222,46}}, color={0,0,127}));
  connect(THeaWatSupSet, conSup.TSetHea) annotation (Line(points={{-320,20},{
          -236,20},{-236,58},{-222,58}}, color={0,0,127}));
  connect(TChiWatSupSet, conSup.TSetCoo) annotation (Line(points={{-320,-20},{
          -232,-20},{-232,49},{-222,49}}, color={0,0,127}));
  connect(conSup.yHea, chi.uHea) annotation (Line(points={{-198,58},{-180,58},{
          -180,12},{-16,12}}, color={255,0,255}));
  connect(conSup.yCoo, chi.uCoo) annotation (Line(points={{-198,55},{-182,55},{
          -182,10},{-16,10}}, color={255,0,255}));
  connect(conSup.yIsoEva, valIsoEva.y) annotation (Line(points={{-198,43},{-194,
          43},{-194,-80},{100,-80},{100,-88}}, color={0,0,127}));
  connect(conSup.yIsoCon, valIsoCon.y) annotation (Line(points={{-198,46},{-192,
          46},{-192,-76},{-100,-76},{-100,-88}}, color={0,0,127}));
  connect(conSup.yHeaRej, subsystemBorefield.uHeaRej) annotation (Line(points={
          {-198,52},{-186,52},{-186,-172},{-162,-172}}, color={255,0,255}));
  connect(conSup.yColRej, subsystemBorefield.uColRej) annotation (Line(points={
          {-198,49},{-188,49},{-188,-174},{-162,-174}}, color={255,0,255}));
  connect(conSup.yIsoEva, subsystemBorefield.uIsoEva) annotation (Line(points={
          {-198,43},{-194,43},{-194,-178},{-162,-178}}, color={0,0,127}));
  connect(conSup.yIsoCon, subsystemBorefield.uIsoCon) annotation (Line(points={
          {-198,46},{-192,46},{-192,-176},{-162,-176}}, color={0,0,127}));
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
