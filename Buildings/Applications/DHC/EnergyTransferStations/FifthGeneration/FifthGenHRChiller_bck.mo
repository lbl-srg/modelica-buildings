within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration;
model FifthGenHRChiller_bck
  "Energy transfer station model for fifth generation DHC systems"
    package Medium = Buildings.Media.Water "Medium model";

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
    annotation (Placement(transformation(extent={{-320,244},{-300,264}}),
    iconTransformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMaxBorEnt(
    final unit="K",displayUnit="degC")
    "Maximum allowed enetring water temperature to the borefiled holes"
    annotation (Placement(transformation(extent={{-320,-84},{-300,-64}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMinConEnt(
    final unit="K",displayUnit="degC")
    "Minimum condenser entering water temperature"
    annotation (Placement(transformation(extent={{-320,230},{-300,250}}),
      iconTransformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMaxEvaEnt(
    final unit="K",displayUnit="degC")
    "Maximum evaporator entering water temperature"
    annotation (Placement(transformation(extent={{-320,216},{-300,236}}),
    iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetHea(
    final unit="K",displayUnit="degC")
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-320,272},{-300,292}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetCoo( final unit="K",displayUnit="degC")
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-320,258},{-300,278}}),
    iconTransformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput modRej
    "Surplus heat or cold rejection mode" annotation (Placement(transformation(
          extent={{300,-100},{320,-80}}), iconTransformation(extent={{100,60},{
            140,100}})));
  Modelica.Fluid.Interfaces.FluidPort_a chiWatRet(
    h_outflow(start=Medium.h_default, nominal=Medium.h_default),
    redeclare final package Medium = Medium,
    p(start=Medium.p_default))
    "Chilled water return port"
    annotation (Placement(transformation(extent={{-310,-50},{-290,-30}}),
      iconTransformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b chiWatSup(
    h_outflow(start=Medium.h_default, nominal=Medium.h_default),
    redeclare final package Medium = Medium,
    p(start=Medium.p_default))
    "Chilled water supply port"
    annotation (Placement(transformation(extent={{-290,30},{-310,50}}),
      iconTransformation(extent={{-90,-90},{-110,-70}})));
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
  Fluid.Chillers.ElectricEIR chi(
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    show_T=true,
    from_dp1=true,
    dp1_nominal=dpCon_nominal,
    linearizeFlowResistance1=true,
    from_dp2=true,
    dp2_nominal=dpEva_nominal,
    linearizeFlowResistance2=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=datChi,
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium)
    "Water cooled EIR chiller."
      annotation (Placement(transformation(extent={{-30,116},{-10,136}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumCon(
    redeclare final package Medium = Medium,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpCon_nominal,0}, V_flow={0,mCon_flow_nominal/1000})),
    allowFlowReversal=false,
    use_inputFilter=true,
    riseTime=10)
    "Condenser variable speed pump-primary circuit"
      annotation (Placement(transformation(extent={{0,122},{20,142}})));
   Buildings.Fluid.Movers.SpeedControlled_y pumEva(
    redeclare final package Medium = Medium,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpEva_nominal,0}, V_flow={0,mEva_flow_nominal/1000})),
    allowFlowReversal=false,
    use_inputFilter=true,
    riseTime=10)
    "Evaporator variable speed pump-primary circuit"
      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-76,130})));
  //// TANKS
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
    tau(displayUnit="s")) "Heating water buffer tank"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
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
  Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.BaseClasses.WaterWaterHeatExchanger
    hex(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    dp1_nominal=dpHex_nominal,
    eps_nominal=eps_nominal,
    dp2_nominal=dpHex_nominal,
    m1_flow_nominal=mHex_flow_nominal,
    m2_flow_nominal=mHex_flow_nominal) "Heat exchanger" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={110,-170})));
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
  FifthGeneration.Controls.Supervisory ETSCon(THys=THys)
    "ETS supervisory controller"
    annotation (Placement(transformation(extent={{-198,200},{-178,220}})));
  FifthGeneration.Controls.Chiller chiCon
    "Control of the EIR chiller model and associated three way valves"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  FifthGeneration.Controls.PrimaryPumpsConstantSpeed pumPrimCon
    "Control of the primary pumps"
    annotation (Placement(transformation(extent={{-120,142},{-100,162}})));
  Controls.Borefield ambCon(dTGeo=dTGeo, dTHex=dTHex)
    "Control of the ambient circuit"
    annotation (Placement(transformation(extent={{-144,-82},{-124,-62}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiMDisHex(k=mHex_flow_nominal)
    "Gain for mass flow of heat exchanger"
    annotation (Placement(transformation(extent={{40,-262},{60,-242}})));
  //// SENSORS
  Buildings.Fluid.Sensors.TemperatureTwoPort TConLvg(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mCon_flow_nominal,
    tau=0)
    "Condenser leaving water temperature"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={68,132})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TConEnt(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mCon_flow_nominal,
    tau=0)
    "Condenser entering water temperature"
    annotation (Placement(transformation(extent={{0,10},{-20,30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TEvaEnt(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=0)
    "Evaporator entering water temperature"
    annotation (Placement(
    transformation(
    extent={{10,10},{-10,-10}},
    rotation=180,
    origin={-20,96})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TEvaLvg(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=30)
    "Evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-68,10},{-88,30}})));
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
  Fluid.Sensors.TemperatureTwoPort TDisHexLvg(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    tau=10,
    m_flow_nominal=mHex_flow_nominal)
    "District heat exchanger leaving water temperature"
    annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={22,-200})));
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
  Fluid.Sensors.TemperatureTwoPort disRetTem(
    tau=0,
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mHex_flow_nominal)
    "District system return water temperature"
     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={230,-150})));
  Fluid.Sensors.TemperatureTwoPort disSupTem(
    tau=0,
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mHex_flow_nominal)
    "District system supply water temperature"
     annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={230,-192})));
  Fluid.Sensors.TemperatureTwoPort TDisHex(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    tau=10,
    m_flow_nominal=mHex_flow_nominal)
  "Entering water tmperature to the district heat exchanger"
   annotation (Placement(transformation(extent={{-10,10},{10,-10}},
     rotation=270, origin={110,-70})));
  Fluid.Sensors.TemperatureTwoPort TValEnt(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=0) "Evaporator entering water temperature"
     annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-106,60})));
  Fluid.Sensors.TemperatureTwoPort TAmbCirLvg(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mGeo_flow_nominal + mHex_flow_nominal,
    tau=30) "Ambient circuit leaving water temperature."
    annotation (Placement(transformation(extent={{-2,-110},{-22,-90}})));
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
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
    heaSupHed(
    redeclare final package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    nPorts_b=2,
    nPorts_a=1) "Heating supply water header"
    annotation (Placement(transformation(extent={{92,50},{112,70}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
    hydHdrHeaRet(
    redeclare final package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    nPorts_a=1,
    nPorts_b=2) "Heating water circuit return header"
    annotation (Placement(transformation(extent={{124,30},{104,10}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
    hydHdrChiRet(
    redeclare final package Medium = Medium,
    m_flow_nominal=mEva_flow_nominal,
    allowFlowReversal=true,
    nPorts_a=2,
    nPorts_b=1) "Chilled water circuit return header"
    annotation (Placement(transformation(extent={{-148,70},{-128,50}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
    hydHdrChiSup(
    redeclare final package Medium = Medium,
    m_flow_nominal=mEva_flow_nominal,
    nPorts_a=1,
    nPorts_b=2) "Chilled water circuit supply header"
    annotation (Placement(transformation(extent={{-108,10},{-128,30}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
    hydHdrAmbRet(
    redeclare final package Medium = Medium,
    m_flow_nominal=mHex_flow_nominal + mGeo_flow_nominal,
    nPorts_a=2,
    nPorts_b=2) "Ambient circuit return header"
    annotation (Placement(transformation(extent={{-30,-58},{-50,-38}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
    hydHdrAmbSup(
    redeclare final package Medium = Medium,
    m_flow_nominal=mHex_flow_nominal + mGeo_flow_nominal,
    nPorts_a=2,
    nPorts_b=2) "Ambient circuit supply header"
    annotation (Placement(transformation(extent={{0,-120},{20,-142}})));
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
  Fluid.FixedResistances.Junction splEva(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final dp_nominal=200*{1,-1,-1},
    from_dp=false,
    tau=1,
    m_flow_nominal={mEva_flow_nominal,-mEva_flow_nominal,-mEva_flow_nominal},
    redeclare final package Medium = Medium)
    "Flow splitter for the evaporator water circuit"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,78})));
  Fluid.FixedResistances.Junction splCon(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final dp_nominal=200*{1,-1,-1},
    from_dp=false,
    tau=1,
    m_flow_nominal={mCon_flow_nominal,-mCon_flow_nominal,-mCon_flow_nominal},
    redeclare final package Medium = Medium)
    "Flow splitter for the condenser water circuit"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={42,132})));
 //-----------------------------Valves----------------------------------------------
  Fluid.Actuators.Valves.TwoWayLinear valSupHea(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpFixed_nominal=0,
    show_T=true,
    dpValve_nominal=dp_nominal,
    riseTime=10,
    l=1e-8,
    m_flow_nominal=mGeo_flow_nominal + mHex_flow_nominal)
    "Two way modulating valve"
    annotation (Placement(transformation(extent={{18,-30},{-2,-10}})));
  Fluid.Actuators.Valves.TwoWayLinear valSupCoo(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpFixed_nominal=0,
    show_T=true,
    dpValve_nominal=dp_nominal,
    riseTime=10,
    l=1e-8,
    m_flow_nominal=mGeo_flow_nominal + mHex_flow_nominal)
    "Two way modulating valve"
      annotation (Placement(transformation(extent={{-94,-30},{-74,-10}})));
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
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valEva(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    m_flow_nominal=mEva_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000,
    homotopyInitialization=true)
    "Three way valve modulated to control the entering water temperature to the evaporator"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
                                        rotation=270,
                                        origin={-94,78})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valCon(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    m_flow_nominal=mCon_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000,
    homotopyInitialization=true)
    "Three way valve modulated to control the entering water temperature to the condenser"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-34,52})));
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
  connect(chi.port_b1, pumCon.port_a) annotation (Line(
      points={{-10,132},{0,132}},
      color={238,46,47},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(pumEva.port_b,TEvaEnt. port_a) annotation (Line(
      points={{-66,130},{-50,130},{-50,96},{-30,96}},
      color={238,46,47},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(TEvaEnt.port_b, chi.port_a2) annotation (Line(
      points={{-10,96},{-6,96},{-6,120},{-10,120}},
      color={238,46,47},
      pattern=LinePattern.Dash,
      thickness=0.5));
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
    annotation (Line(points={{104,-160},{104,-120},{110,-120}},color={0,127,
          255}, thickness=0.5));
  connect(disWatSup, disSupTem.port_a) annotation (Line(
      points={{300,-192},{240,-192}},
      color={0,127,255},
      thickness=0.5));
  connect(disSupTem.port_b, hex.port_a2)
    annotation (Line(points={{220,-192},{116,-192},{116,-180}},
                               color={0,127,255}, thickness=0.5));
  connect(hex.port_b2, disRetTem.port_a)
    annotation (Line(points={{116,-160},{116,-150},{220,-150}}, color={238,46,47},
      thickness=0.5));
  connect(disRetTem.port_b,disWatRet)
    annotation (Line(points={{240,-150},{300,-150}}, color={238,46,47},
      thickness=0.5));
  connect(hex.port_b1, TDisHexLvg.port_a) annotation (Line(
      points={{104,-180},{104,-224},{22,-224},{22,-210}},
      color={28,108,200},
      pattern=LinePattern.DashDotDot,
      thickness=0.5));
  connect(TMinConEnt, chiCon.TMinConWatEnt) annotation (Line(
      points={{-310,240},{-136,240},{-136,209},{-122,209}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TMaxEvaEnt, chiCon.TMaxEvaWatEnt) annotation (Line(
      points={{-310,226},{-292,226},{-292,236},{-138,236},{-138,207},{-122,207}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(ETSCon.yHea, pumPrimCon.reqHea) annotation (Line(
      points={{-177,219},{-140,219},{-140,158},{-122,158}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(pumHexDis.port_a, TDisHex.port_b)
    annotation (Line(points={{110,-100},{110,-80}},color={0,127,255},
      thickness=0.5));
  connect(TMaxBorEnt, ambCon.TBorMaxEnt) annotation (Line(
      points={{-310,-74},{-172,-74},{-172,-77},{-145,-77}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TDisHexLvg.T, ambCon.TDisHexLvg) annotation (Line(
      points={{11,-200},{2,-200},{2,-282},{-158,-282},{-158,-79},{-145,-79}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(ambCon.TDisHexEnt, TDisHex.T) annotation (Line(
      points={{-145,-78},{-162,-78},{-162,-288},{90,-288},{90,-70},{99,-70}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TEvaLvg.port_b, hydHdrChiSup.ports_a[1]) annotation (Line(
      points={{-88,20},{-88,20},{-112,20}},
      color={0,127,255},
      thickness=0.5));
  connect(hydHdrChiSup.ports_b[1], valSupCoo.port_a) annotation (Line(
      points={{-126,20},{-126,-20},{-94,-20}},
      color={0,127,255},
      thickness=0.5));
  connect(pumEva.port_a, valEva.port_2) annotation (Line(points={{-86,130},{-94,
          130},{-94,88}},color={238,46,47},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(splEva.port_3, valEva.port_3)
    annotation (Line(points={{-70,78},{-84,78}}, color={0,127,255}));
  connect(chi.port_b2, splEva.port_1) annotation (Line(
      points={{-30,120},{-60,120},{-60,88}},
      color={0,127,255},
      thickness=0.5));
  connect(splEva.port_2, TEvaLvg.port_a) annotation (Line(
      points={{-60,68},{-60,20},{-68,20}},
      color={0,127,255},
      thickness=0.5));
  connect(TDisHexLvg.port_b, hydHdrAmbSup.ports_a[1]) annotation (Line(
      points={{22,-190},{22,-168},{-8,-168},{-8,-131},{6,-131}},
      color={0,127,255},
      thickness=0.5));
  connect(heaSupHed.ports_b[1], valSupHea.port_a)
    annotation (Line(points={{110,60},{110,40},{60,40},{60,-20},{18,-20}}, color={0,127,
          255},
      thickness=0.5));
  connect(TConEnt.port_b, valCon.port_1)
    annotation (Line(points={{-20,20},{-34,20},{-34,42}}, color={0,127,255},thickness=0.5));
  connect(chi.port_a1, valCon.port_2) annotation (Line(
      points={{-30,132},{-34,132},{-34,62}},
      color={0,127,255},
      thickness=0.5));
  connect(valBor.port_3, splBor.port_3) annotation (Line(
      points={{-60,-110},{-50,-110},{-50,-170},{-40,-170}},
      color={0,127,255},
      thickness=0.5));
  connect(TBorLvg.port_b, splBor.port_1)
    annotation (Line(points={{-30,-200},{-30,-180}}, color={0,127,255}));
  connect(splBor.port_2, hydHdrAmbSup.ports_a[2]) annotation (Line(
      points={{-30,-160},{-30,-131},{2,-131}},
      color={0,127,255},
      thickness=0.5));
  connect(pumCon.port_b, splCon.port_1)
    annotation (Line(points={{20,132},{32,132}}, color={0,127,255}));
  connect(TConLvg.port_a, splCon.port_2)
    annotation (Line(points={{58,132},{52,132}}, color={0,127,255}));
  connect(TConLvg.port_b, heaSupHed.ports_a[1])
    annotation (Line(points={{78,132},{84,132},{84,60},{96,60}},color={238,46,47},
      thickness=0.5));
  connect(valCon.port_3, splCon.port_3) annotation (Line(
      points={{-24,52},{42,52},{42,122}},
      color={0,127,255},
      thickness=0.5));
  connect(valSupCoo.port_b, hydHdrAmbRet.ports_a[1]) annotation (Line(
      points={{-74,-20},{-24,-20},{-24,-48},{-36,-48}},
      color={0,127,255},
      thickness=0.5));
  connect(hydHdrAmbRet.ports_a[2], valSupHea.port_b) annotation (Line(
      points={{-32,-48},{-12,-48},{-12,-20},{-2,-20}},
      color={0,127,255},
      thickness=0.5));
  connect(hydHdrAmbRet.ports_b[1], TDisHex.port_a) annotation (Line(
      points={{-48,-48},{-56,-48},{-56,-60},{110,-60}},
      color={0,127,255},
      thickness=0.5));
  connect(gaiMDisHex.y, pumHexDis.m_flow_in) annotation (Line(
      points={{62,-252},{80,-252},{80,-110},{98,-110}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TConEnt.T, chiCon.TConWatEnt) annotation (Line(
      points={{-10,31},{-10,40},{-126,40},{-126,206},{-122,206}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TEvaEnt.T, chiCon.TEvaWatEnt) annotation (Line(
      points={{-20,107},{-20,116},{-62,116},{-62,192},{-126,192},{-126,208},{
          -122,208}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(ETSCon.yCoo, pumPrimCon.reqCoo) annotation (Line(
      points={{-177,201},{-166,201},{-166,146},{-122,146}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.yIsoCon, valSupHea.y) annotation (Line(
      points={{-177,209},{-152,209},{-152,-2},{8,-2},{8,-8}},
      color={28,108,200},
      pattern=LinePattern.DashDot));
  connect(ETSCon.yIsoEva, valSupCoo.y) annotation (Line(
      points={{-177,207},{-152,207},{-152,-8},{-84,-8}},
      color={28,108,200},
      pattern=LinePattern.DashDot));
  connect(ETSCon.yCoo, ambCon.uCoo) annotation (Line(
      points={{-177,201},{-166,201},{-166,-68},{-145,-68}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ambCon.uHea, ETSCon.yHea) annotation (Line(
      points={{-145,-63},{-156,-63},{-156,219},{-177,219}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.valHea, ambCon.uIsoCon) annotation (Line(
      points={{-177,213},{-158,213},{-158,-64},{-145,-64}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.valCoo, ambCon.uIsoEva) annotation (Line(
      points={{-177,215},{-160,215},{-160,-65},{-145,-65}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ambCon.uColRej, ETSCon.yColRej) annotation (Line(
      points={{-146,-73},{-164,-73},{-164,202.8},{-177,202.8}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.yHeaRej, ambCon.uHeaRej) annotation (Line(
      points={{-177,204.8},{-162,204.8},{-162,-70},{-146,-70}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(pumPrimCon.yPumCon, pumCon.y) annotation (Line(points={{-98,158},{10,
          158},{10,144}},                                                                      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(pumPrimCon.yPumEva, pumEva.y) annotation (Line(points={{-98,146},{-76,
          146},{-76,142}},                                                                       color={0,0,127},
      pattern=LinePattern.Dot));
  connect(valBor.port_2, pumBor.port_a) annotation (Line(points={{-70,-120},{
          -70,-140}},            color={0,127,255},
      thickness=0.5));
  connect(hydHdrAmbRet.ports_b[2], valBor.port_1) annotation (Line(
      points={{-44,-48},{-70,-48},{-70,-100}},
      color={0,127,255},
      thickness=0.5));
  connect(TSetHea, ETSCon.TSetHea) annotation (Line(
      points={{-310,282},{-214,282},{-214,215},{-199,215}},
      color={238,46,47},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(TSetCoo, ETSCon.TSetCoo) annotation (Line(
      points={{-310,268},{-228,268},{-228,205},{-199,205}},
      color={0,128,255},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(TSetHea, chiCon.TConWatLvgSet) annotation (Line(
      points={{-310,282},{-126,282},{-126,213},{-122,213}},
      color={238,46,47},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(TSetCoo, chiCon.TChiWatSupSetMax) annotation (Line(
      points={{-310,268},{-130,268},{-130,212},{-122,212}},
      color={0,128,255},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(ETSCon.yHea, chiCon.uHea) annotation (Line(
      points={{-177,219},{-150,219},{-150,218},{-122,218}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.yCoo, chiCon.uCoo) annotation (Line(
      points={{-177,201},{-150,201},{-150,216},{-122,216}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(TSetCooMin, chiCon.TMinEvaWatLvg) annotation (Line(
      points={{-310,254},{-134,254},{-134,211},{-122,211}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TConLvg.T, chiCon.TConWatLvg) annotation (Line(
      points={{68,143},{68,194},{-124,194},{-124,203},{-122,203}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chiCon.yChi, chi.on) annotation (Line(points={{-98,218},{-46,218},{-46,
          130},{-32,130},{-32,129}}, color={255,0,255}));
  connect(chiCon.TChiWatSupSet, chi.TSet) annotation (Line(points={{-98,214},{-42,
          214},{-42,123},{-32,123}}, color={0,0,127}));
  connect(TConEnt.port_a, hydHdrHeaRet.ports_b[1]) annotation (Line(points={{0,20},{
          50,20},{50,20},{106,20}},  color={0,127,255}));
  connect(chiCon.yMixEva, valEva.y) annotation (Line(points={{-98,206},{-96,206},
          {-96,130},{-114,130},{-114,78},{-106,78}},        color={0,0,127}));
  connect(chiCon.yMixCon, valCon.y) annotation (Line(points={{-98,202},{-52,202},
          {-52,52},{-46,52}}, color={0,0,127}));
  connect(ambCon.modRej, modRej) annotation (Line(points={{-123,-72},{60,-72},{
          60,-90},{310,-90}}, color={255,127,0}));
  connect(pumBor.port_b, TBorEnt.port_a)
    annotation (Line(points={{-70,-160},{-70,-164}}, color={0,127,255}));
  connect(ambCon.yMixBor, valBor.y) annotation (Line(points={{-122,-66},{-94,
          -66},{-94,-110},{-82,-110}}, color={0,0,127}));
  connect(ambCon.yDisHexPum, gaiMDisHex.u) annotation (Line(points={{-123,-80},{
          -120,-80},{-120,-252},{38,-252}},    color={0,0,127}));
  connect(tanHeaWat.port_b, hydHdrHeaRet.ports_a[1]) annotation (Line(points={{180,40},
          {188,40},{188,10},{128,10},{128,20},{120,20}},     color={0,127,255}));
  connect(tanHeaWat.port_b1,heaWatSup)  annotation (Line(points={{160,44},{160,
          40},{300,40}},                                           color={0,127,
          255}));
  connect(hydHdrChiRet.ports_b[1], TValEnt.port_a) annotation (Line(points={{-132,60},
          {-122,60},{-122,60},{-116,60}},     color={0,127,255}));
  connect(valEva.port_1, TValEnt.port_b) annotation (Line(points={{-94,68},{-94,
          64},{-94,60},{-96,60}}, color={0,127,255}));
  connect(TBorEnt.T, ambCon.TBorWatEnt) annotation (Line(
      points={{-81,-174},{-154,-174},{-154,-76},{-146,-76}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TBorLvg.T, ambCon.TBorWatLvg) annotation (Line(
      points={{-41,-210},{-50,-210},{-50,-228},{-156,-228},{-156,-79},{-146,-79}},

      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(hydHdrHeaRet.ports_b[2], hydHdrAmbSup.ports_b[1]) annotation (Line(
        points={{110,20},{66,20},{66,-131},{18,-131}},     color={0,127,255}));
  connect(hydHdrAmbSup.ports_b[2], TAmbCirLvg.port_a) annotation (Line(points={{14,-131},
          {14,-100},{-2,-100},{-2,-100}},            color={0,127,255}));
  connect(TAmbCirLvg.port_b, hydHdrChiRet.ports_a[1]) annotation (Line(points={{-22,
          -100},{-40,-100},{-40,-80},{-80,-80},{-80,-40},{-142,-40},{-142,60}},
        color={0,127,255}));
  connect(tanChiWat.port_b1, hydHdrChiRet.ports_a[2]) annotation (Line(points={{-236,64},
          {-240,64},{-240,86},{-174,86},{-174,60},{-146,60}},          color={0,
          127,255}));
  connect(hydHdrChiSup.ports_b[2], tanChiWat.port_a1) annotation (Line(points={{-122,20},
          {-182,20},{-182,56},{-216,56}},            color={0,127,255}));
  connect(tanHeaWat.port_a, heaSupHed.ports_b[2]) annotation (Line(points={{160,40},
          {134,40},{134,60},{106,60}},             color={0,127,255}));
  connect(tanHeaWat.port_a1,heaWatRet)  annotation (Line(points={{180,36},{288,
          36},{288,-40},{300,-40}}, color={0,127,255}));
  connect(chiWatRet,tanChiWat. port_a)
    annotation (Line(points={{-300,-40},{-280,-40},{-280,60},{-236,60}},
                                                   color={0,127,255}));
  connect(tanChiWat.port_b, chiWatSup) annotation (Line(points={{-216,60},{-200,
          60},{-200,40},{-300,40}}, color={0,127,255}));
  connect(gaiBor.u,ambCon.yPumBor)  annotation (Line(points={{-112,-150},{-112,
          -78.1},{-121.9,-78.1}},
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
end FifthGenHRChiller_bck;
