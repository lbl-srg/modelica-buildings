within Buildings.Applications.DHC.EnergyTransferStations;
model Substation
  "5th generation of district heating and cooling plant"
    package Medium = Buildings.Media.Water "Medium model";

  //------------------------------SideWalk parameters-------------------------------
    final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
        max(mSecHea_flow_nominal,mSecCoo_flow_nominal)
    "Nominal mass flow rate";
    parameter Modelica.SIunits.MassFlowRate mSecHea_flow_nominal
      "Secondary(building side) heatng circuit nominal water flow rate";
    parameter Modelica.SIunits.MassFlowRate mSecCoo_flow_nominal
      "Secondary(building side) cooling circuit nominal water flow rate";
    parameter Modelica.SIunits.TemperatureDifference dTChi=2
      "Temperature difference between entering and leaving water of EIR chiller(+ve)";

 //----------------------------------Generanl---------------------------------------
    parameter Modelica.Fluid.Types.Dynamics fixedEnergyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
      "Formulation of energy balance for mixing volume at inlet and outlet"
      annotation (Dialog(group="Dynamics"));
    parameter Boolean show_T=true
      "= true, if actual temperature at port is computed"
      annotation (Dialog(tab="Advanced"));

 //-------------------------------Design Parameters----------------------------------
    final parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa")=1000
      "Pressure difference at nominal flow rate"
        annotation (Dialog(group="Design Parameter"));
  //----------------------water to water chiller or heat pump system-----------------
    parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=datChi.mEva_flow_nominal
     "Condenser nominal water flow rate" annotation (Dialog(group="WSHP system"));
    parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=datChi.mEva_flow_nominal
     "Evaporator nominal water flow rate" annotation (Dialog(group="WSHP system"));
    parameter Modelica.SIunits.PressureDifference dpCon_nominal
      "Pressure difference accross the condenser"
        annotation (Dialog(group="WSHP system"));
    parameter Modelica.SIunits.PressureDifference dpEva_nominal
      "Pressure difference accross the evaporator"
        annotation (Dialog(group="WSHP system"));
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
 //---------------------------Inputs and outputs------------------------------------

    Modelica.Blocks.Interfaces.RealInput TSetCooMin(final unit="K",displayUnit="degC")
    "Minimum cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-320,244},{-300,264}}),
                    iconTransformation(extent={{-116,66},{-100,82}})));

    Modelica.Blocks.Interfaces.RealInput TMaxBorEnt(final unit="K",displayUnit="degC")
    "Maximum allowed enetring water temperature to the borefiled holes"
         annotation (Placement(transformation(extent={{-320,-84},{-300,-64}}),
                               iconTransformation(extent={{-116,-28},{-100,-12}})));

    Modelica.Blocks.Interfaces.RealInput TMinConEnt(final unit="K",displayUnit="degC")
      "Minimum condenser entering water temperature"
         annotation (Placement(transformation(extent={{-320,230},{-300,250}}),
                     iconTransformation(extent={{-116,50},{-100,66}})));
    Modelica.Blocks.Interfaces.RealInput TMaxEvaEnt(final unit="K",displayUnit="degC")
    "Maximum evaporator entering water temperature"
        annotation (
      Placement(transformation(extent={{-320,216},{-300,236}}), iconTransformation(extent={{-116,-4},
            {-100,12}})));

    Modelica.Blocks.Interfaces.RealInput TSetHea( final unit="K",displayUnit="degC")
     "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-320,272},{-300,292}}),
        iconTransformation(extent={{-116,80},{-100,96}})));
    Modelica.Blocks.Interfaces.RealInput TSetCoo( final unit="K",displayUnit="degC")
     "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-320,258},{-300,278}}),
        iconTransformation(extent={{-116,94},{-100,110}})));
    Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yRejHeaInd
    "Heat rejection index"      annotation (Placement(transformation(extent={{300,
            -100},{320,-80}}),
                            iconTransformation(extent={{100,-2},{128,26}})));

 //--------------------------fller system------------------------------------------
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
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium)
    "Water cooled EIR chiller."
      annotation (Placement(transformation(extent={{-30,116},{-10,136}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumCon(
    redeclare package Medium = Medium,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpCon_nominal,0}, V_flow={0,mCon_flow_nominal/1000})),
    allowFlowReversal=false,
    use_inputFilter=true,
    riseTime=10)
    "Condenser variable speed pump-primary circuit"
      annotation (Placement(transformation(extent={{0,122},{20,142}})));
   Buildings.Fluid.Movers.SpeedControlled_y pumEva(
    redeclare package Medium = Medium,
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

  //-------------------------Buffer tanks--------------------------------------------
    BaseClasses.StratifiedTank hotBufTan(
      redeclare package Medium = Medium,
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
      "Hot buffer tank"
      annotation (Placement(transformation(extent={{160,30},{180,50}})));
    BaseClasses.StratifiedTank colBufTan(
      redeclare package Medium = Medium,
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
      "Cold Buffer tank"
      annotation (Placement(transformation(extent={{-236,50},{-216,70}})));
//----------------------------Borefield system---------------------------------------
    Fluid.Movers.FlowControlled_m_flow pumBor(
      redeclare package Medium = Medium,
      m_flow_nominal=mGeo_flow_nominal,
      addPowerToMedium=false,
      show_T=show_T,
      per(pressure(dp={dpBorFie_nominal,0}, V_flow={0,mGeo_flow_nominal/1000})),
      use_inputFilter=true,
      riseTime=10)
      "Pump (or valve) that forces the flow rate to be set to the control signal"
       annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,  origin={-70,-150})));

 //---------------------------DistrictHeatExchanger----------------------------------

    BaseClasses.WaterWaterHeatExchanger hex(
      redeclare package Medium1 = Medium,
      redeclare package Medium2 = Medium,
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
          origin={110,-170})));
    Fluid.Movers.FlowControlled_m_flow pumHexDis(
      redeclare package Medium = Medium,
      m_flow_nominal=mHex_flow_nominal,
      addPowerToMedium=false,
      show_T=show_T,
      per(pressure(dp={dpHex_nominal,0}, V_flow={0,mHex_flow_nominal/1000})),
      use_inputFilter=true,
      riseTime=10)
      "Pump (or valve) that forces the flow rate to be set to the control signal"
       annotation (
        Placement(transformation(extent={{-10,10},{10,-10}},rotation=270,
                                            origin={110,-110})));
 //-----------------------------Controllers------------------------------------------

  Control.SubstationMainController ETSCon(THys=THys)
      "Overall control of the ETS cold and hot sides."
        annotation (Placement(transformation(extent={{-198,200},{-178,220}})));
  Control.ChillerController chiCon "Control of the EIR chiller model and associated three way valves"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  Control.PrimaryPumpsConstantSpeed pumPrimCon(
    mCon_flow_nominal = mCon_flow_nominal, mEva_flow_nominal=mEva_flow_nominal)
    "Control of the primary circuit pumps"
    annotation (Placement(transformation(extent={{-120,142},{-100,162}})));
  Control.AmbientCircuitController ambCon(dTGeo=dTGeo, dTHex=dTHex) "control of the ambient hydraulic circuit"
    annotation (Placement(transformation(extent={{-144,-82},{-124,-62}})));
    Buildings.Controls.OBC.CDL.Continuous.Gain gaiMDisHex(k=mHex_flow_nominal)
      "Gain for mass flow of heat exchanger"
        annotation (Placement(transformation(extent={{40,-262},{60,-242}})));

 //-----------------------------Sensors----------------------------------------------
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
      tau=30) "Evaporator leaving water temperature"
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
                                            rotation=270,
                                            origin={110,-70})));
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
      "Cold tank top temperature"
      annotation (Placement(transformation(extent={{-230,90},{-250,110}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor botCooTan
      "Cold tank bottom temperature"
      annotation (Placement(transformation(extent={{-230,10},{-250,30}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor topHotTan
      "Hot tank top temperature"
      annotation (Placement(transformation(extent={{214,198},{194,218}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor botHotTan
      "Hot tank bottom temperature"
      annotation (Placement(transformation(extent={{176,-42},{196,-22}})));

 //----------------------Fluid Interfaces and hydraluic headers----------------------
   //------Building cooling side connection------------------------------------------
    Modelica.Fluid.Interfaces.FluidPort_a chiWatRet(
    h_outflow(start=Medium.h_default, nominal=Medium.h_default),
    redeclare final package Medium = Medium,
    p(start=Medium.p_default))
      "Chilled water return from the building."
      annotation (Placement(transformation(extent={{-314,50},{-294,70}}),
        iconTransformation(extent={{-120,-60},{-100,-40}})));
    Modelica.Fluid.Interfaces.FluidPort_b chiWatSup(
    h_outflow(start=Medium.h_default, nominal=Medium.h_default),
    redeclare final package Medium = Medium,
    p(start=Medium.p_default))
      "Chilled water supply to the building"
      annotation (Placement(transformation(extent={{-294,30},{-314,50}}),
        iconTransformation(extent={{-100,-82},{-120,-62}})));

    //------Building heating side connection-----------------------------------------
    Modelica.Fluid.Interfaces.FluidPort_a hotWatRet(
      h_outflow(start=Medium.h_default, nominal=Medium.h_default),
      redeclare final package Medium = Medium,
      p(start=Medium.p_default)) "Hot water return from the building."
      annotation (
       Placement(transformation(extent={{290,30},{310,50}}), iconTransformation(
       extent={{100,-58},{120,-38}})));
    Modelica.Fluid.Interfaces.FluidPort_b hotWatSup(
    h_outflow(start=Medium.h_default, nominal=Medium.h_default),
    redeclare final package Medium = Medium,
    p(start=Medium.p_default)) "Hot water supply to the building."
    annotation (
      Placement(transformation(extent={{310,50},{290,70}}), iconTransformation(
          extent={{120,-82},{100,-62}})));

 //------Building distrcit circuit connection----------------------------------------
   Modelica.Fluid.Interfaces.FluidPort_a disWatSup(
    p(start=Medium.p_default),
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "District water supply port." annotation (Placement(transformation(extent={
            {290,-202},{310,-182}}), iconTransformation(extent={{-22,-120},{-2,
            -100}})));
   Modelica.Fluid.Interfaces.FluidPort_b disWatRet(
      p(start=Medium.p_default),
      redeclare final package Medium = Medium,
      h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "District water return port."
      annotation (Placement(transformation(extent={{310,-160},{290,-140}}),
          iconTransformation(extent={{22,-120},{2,-100}})));
//------hydraulic header------------------------------------------------------------
    BaseClasses.HydraulicHeader heaSupHed(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    nPorts_b=2,
    nPorts_a=1)
    "Heating supply water header"
      annotation (Placement(transformation(extent={{92,50},{112,70}})));
    BaseClasses.HydraulicHeader heaRetHed(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    nPorts_a=1,
    nPorts_b=2)
    "Heating return water header"
      annotation (Placement(transformation(extent={{122,30},{102,10}})));
    BaseClasses.HydraulicHeader cooRetHed(
      redeclare package Medium = Medium,
      m_flow_nominal=mEva_flow_nominal,
    show_T=true,
    allowFlowReversal=true,
      nPorts_a=2,
      nPorts_b=1)
      "Return chilled water header.  "
      annotation (Placement(transformation(extent={{-148,70},
            {-128,50}})));
    BaseClasses.HydraulicHeader cooSupHed(
      redeclare package Medium = Medium,
      m_flow_nominal=mEva_flow_nominal,
      nPorts_a=1,
      nPorts_b=2)
      "Supply chilled water header. "
      annotation (Placement(transformation(extent={{-108,10},{-128,30}})));
    BaseClasses.HydraulicHeader ambRetHed(
      redeclare package Medium = Medium,
      m_flow_nominal=mHex_flow_nominal + mGeo_flow_nominal,
      nPorts_a=2,
      nPorts_b=2)
      "ambient circuit return header"
      annotation (Placement(transformation(extent={{-30,-58},{-50,-38}})));
    BaseClasses.HydraulicHeader ambSupHed(
      redeclare package Medium = Medium,
      m_flow_nominal=mHex_flow_nominal + mGeo_flow_nominal,
      nPorts_a=2,
      nPorts_b=2)
      "Ambient circuit supply header"
      annotation (Placement(transformation(extent={{0,-120},{20,-142}})));
    Fluid.FixedResistances.Junction splBor(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final dp_nominal=200*{1,-1,-1},
    from_dp=false,
    tau=1,
    m_flow_nominal={mGeo_flow_nominal,-mGeo_flow_nominal,-mGeo_flow_nominal},
    redeclare package Medium = Medium)
    "Flow splitter for the borfield water circuit." annotation (Placement(
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
    redeclare package Medium = Medium)
    "Flow splitter for the evaporator water circuit." annotation (Placement(
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
    redeclare package Medium = Medium)
    "Flow splitter for the condenser water circuit." annotation (Placement(
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
    "Two way modulating valve."
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
      redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      from_dp=true,
      m_flow_nominal=mGeo_flow_nominal,
      l={0.01,0.01},
      dpValve_nominal=6000,
      homotopyInitialization=true)
      "Three way valve modulated to control the entering water temperature to the borefield system."
        annotation (Placement(transformation(extent={{10,-10},{-10,10}},
                                          rotation=90,
                                          origin={-70,-110})));
    Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valEva(
      redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      from_dp=true,
      m_flow_nominal=mEva_flow_nominal,
      l={0.01,0.01},
      dpValve_nominal=6000,
      homotopyInitialization=true)
      "Three way valve modulated to control the entering water temperature to the evaporator."
        annotation (Placement(transformation(extent={{10,10},{-10,-10}},
                                          rotation=270,
                                          origin={-94,78})));
    Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valCon(
      redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      from_dp=true,
      m_flow_nominal=mCon_flow_nominal,
      l={0.01,0.01},
      dpValve_nominal=6000,
      homotopyInitialization=true)
      "Three way valve modulated to control the entering water temperature to the condenser."
        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-34,52})));
    Buildings.Controls.OBC.CDL.Continuous.Gain gaiBor(k=mGeo_flow_nominal)
      "Gain for mass flow rate of borefield"
        annotation (Placement(transformation(extent={{-110,-160},{-90,-140}})));
    Fluid.Geothermal.Borefields.OneUTube borFie(
      redeclare package Medium = Medium,
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
  connect(colBufTan.heaPorVol[1], topCooTan.port)
    annotation (Line(points={{-226,60},{-226,100},{-230,100}},
                                                            color={191,0,0},
      pattern=LinePattern.Dash));
  connect(colBufTan.heaPorVol[nSegTan], botCooTan.port)
    annotation (Line(points={{-226,60},{-226,20},{-230,20}},
                                     color={191,0,0},
      pattern=LinePattern.Dash));
  connect(hotBufTan.heaPorVol[nSegTan], botHotTan.port)
    annotation (Line(points={{170,40},{170,-32},{176,-32}},color={191,0,0},
      pattern=LinePattern.Dash));
  connect(hotBufTan.heaPorVol[1], topHotTan.port)
    annotation (Line(points={{170,40},{170,58},{214,58},{214,208}},
                                                      color={191,0,0},
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
          255},
      thickness=0.5));
  connect(disWatSup, disSupTem.port_a) annotation (Line(
      points={{300,-192},{240,-192}},
      color={0,127,255},
      thickness=0.5));
  connect(disSupTem.port_b, hex.port_a2)
    annotation (Line(points={{220,-192},{116,-192},{116,-180}},
                               color={0,127,255},
      thickness=0.5));
  connect(hex.port_b2, disRetTem.port_a)
    annotation (Line(points={{116,-160},{116,-150},{220,-150}},
                                       color={238,46,47},
      thickness=0.5));
  connect(disRetTem.port_b,disWatRet)
    annotation (Line(points={{240,-150},{300,-150}}, color={238,46,47},
      thickness=0.5));
  connect(hex.port_b1, TDisHexLvg.port_a) annotation (Line(
      points={{104,-180},{104,-224},{22,-224},{22,-210}},
      color={28,108,200},
      pattern=LinePattern.DashDotDot,
      thickness=0.5));

  connect(TMinConEnt, chiCon.TMinConEnt) annotation (Line(
      points={{-310,240},{-136,240},{-136,207.2},{-121,207.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TMaxEvaEnt, chiCon.TMaxEvaEnt) annotation (Line(
      points={{-310,226},{-292,226},{-292,236},{-138,236},{-138,205.4},{-121,205.4}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(ETSCon.reqHea,pumPrimCon.reqHea)  annotation (Line(points={{-177,219},
          {-140,219},{-140,162},{-121.4,162}},              color={255,0,255},
      pattern=LinePattern.Dot));

  connect(pumHexDis.port_a, TDisHex.port_b)
    annotation (Line(points={{110,-100},{110,-80}},color={0,127,255},
      thickness=0.5));

  connect(TMaxBorEnt, ambCon.TBorMaxEnt) annotation (Line(
      points={{-310,-74},{-172,-74},{-172,-75},{-145,-75}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TDisHexLvg.T, ambCon.TDisHexLvg) annotation (Line(
      points={{11,-200},{2,-200},{2,-282},{-158,-282},{-158,-79},{-145,-79}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(ambCon.TDisHexEnt, TDisHex.T) annotation (Line(
      points={{-145,-77},{-162,-77},{-162,-288},{90,-288},{90,-70},{99,-70}},
      color={0,0,127},
      pattern=LinePattern.Dot));

  connect(TEvaLvg.port_b, cooSupHed.ports_a[1]) annotation (Line(points={{-88,20},
          {-88,20},{-108,20}},                                                                  color={0,127,
          255},
      thickness=0.5));
  connect(cooSupHed.ports_b[1], valSupCoo.port_a)
    annotation (Line(points={{-128,18},{-128,-20},{-94,-20}},           color={0,127,
          255},
      thickness=0.5));
  connect(pumEva.port_a, valEva.port_2) annotation (Line(points={{-86,130},{-94,
          130},{-94,88}},                                                                       color={238,46,
          47},
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
  connect(TDisHexLvg.port_b,ambSupHed. ports_a[1]) annotation (Line(points={{22,-190},
          {22,-168},{-8,-168},{-8,-133.2},{0,-133.2}},
                            color={0,127,255},
      thickness=0.5));

  connect(heaSupHed.ports_b[1], valSupHea.port_a)
    annotation (Line(points={{112,58},{112,38},{60,38},{60,-20},{18,-20}}, color={0,127,
          255},
      thickness=0.5));
  connect(TConEnt.port_b, valCon.port_1)
    annotation (Line(points={{-20,20},{-34,20},{-34,42}}, color={0,127,255},
      thickness=0.5));
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
  connect(splBor.port_2, ambSupHed.ports_a[2]) annotation (Line(
      points={{-30,-160},{-30,-128.8},{0,-128.8}},
      color={0,127,255},
      thickness=0.5));
  connect(pumCon.port_b, splCon.port_1)
    annotation (Line(points={{20,132},{32,132}}, color={0,127,255}));
  connect(TConLvg.port_a, splCon.port_2)
    annotation (Line(points={{58,132},{52,132}}, color={0,127,255}));
  connect(TConLvg.port_b, heaSupHed.ports_a[1])
    annotation (Line(points={{78,132},{84,132},{84,60},{92,60}},   color={238,46,
          47},
      thickness=0.5));
  connect(valCon.port_3, splCon.port_3) annotation (Line(
      points={{-24,52},{42,52},{42,122}},
      color={0,127,255},
      thickness=0.5));
  connect(valSupCoo.port_b, ambRetHed.ports_a[1])
    annotation (Line(points={{-74,-20},{-24,-20},{-24,-46},{-30,-46}},   color={0,127,
          255},
      thickness=0.5));
  connect(ambRetHed.ports_a[2], valSupHea.port_b)
    annotation (Line(points={{-30,-50},{-12,-50},{-12,-20},{-2,-20}},   color={0,127,
          255},
      thickness=0.5));
  connect(ambRetHed.ports_b[1], TDisHex.port_a) annotation (Line(points={{-50,-50},
          {-56,-50},{-56,-60},{110,-60}},                              color={0,127,
          255},
      thickness=0.5));
  connect(gaiMDisHex.y, pumHexDis.m_flow_in) annotation (Line(
      points={{62,-252},{80,-252},{80,-110},{98,-110}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TConEnt.T, chiCon.TConEnt) annotation (Line(
      points={{-10,31},{-10,40},{-126,40},{-126,200.2},{-121,200.2}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TEvaEnt.T, chiCon.TEvaEnt) annotation (Line(
      points={{-20,107},{-20,116},{-62,116},{-62,192},{-126,192},{-126,203.4},{-121,
          203.4}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(ETSCon.reqCoo,pumPrimCon.reqCoo)  annotation (Line(
      points={{-177,201},{-166,201},{-166,142.2},{-121.4,142.2}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.valHeaPos, valSupHea.y) annotation (Line(
      points={{-177,209},{-152,209},{-152,-2},{8,-2},{8,-8}},
      color={28,108,200},
      pattern=LinePattern.DashDot));
  connect(ETSCon.valCooPos, valSupCoo.y) annotation (Line(
      points={{-177,207},{-152,207},{-152,-8},{-84,-8}},
      color={28,108,200},
      pattern=LinePattern.DashDot));
  connect(ETSCon.reqCoo, ambCon.reqCoo) annotation (Line(
      points={{-177,201},{-166,201},{-166,-73},{-145,-73}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ambCon.reqHea, ETSCon.reqHea) annotation (Line(
      points={{-145,-62.2},{-156,-62.2},{-156,219},{-177,219}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.valHea, ambCon.valHea) annotation (Line(
      points={{-177,217},{-158,217},{-158,-64.4},{-145,-64.4}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.valCoo, ambCon.valCoo) annotation (Line(
      points={{-177,215},{-160,215},{-160,-66.8},{-145,-66.8}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ambCon.rejCooFulLoa,ETSCon. rejColFulLoa) annotation (Line(
      points={{-145,-71},{-164,-71},{-164,202.8},{-177,202.8}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.rejHeaFulLoa, ambCon.rejHeaFulLoa) annotation (Line(
      points={{-177,204.8},{-162,204.8},{-162,-69},{-145,-69}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(pumPrimCon.yPumCon, pumCon.y) annotation (Line(points={{-99,160},{10,
          160},{10,144}},                                                                      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(pumPrimCon.yPumEva, pumEva.y) annotation (Line(points={{-99,144},{-76,
          144},{-76,142}},                                                                       color={0,0,127},
      pattern=LinePattern.Dot));
  connect(valBor.port_2, pumBor.port_a) annotation (Line(points={{-70,-120},{
          -70,-140}},            color={0,127,255},
      thickness=0.5));
  connect(ambRetHed.ports_b[2], valBor.port_1) annotation (Line(
      points={{-50,-46},{-70,-46},{-70,-100}},
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
  connect(TSetHea, chiCon.TSetHea) annotation (Line(
      points={{-310,282},{-126,282},{-126,211},{-121,211}},
      color={238,46,47},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(TSetCoo, chiCon.TSetCoo) annotation (Line(
      points={{-310,268},{-130,268},{-130,213},{-121,213}},
      color={0,128,255},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(ETSCon.reqHea, chiCon.reqHea) annotation (Line(
      points={{-177,219},{-121.4,219}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.reqCoo, chiCon.reqCoo) annotation (Line(
      points={{-177,201},{-150,201},{-150,215.4},{-121.4,215.4}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(TSetCooMin, chiCon.TSetCooMin) annotation (Line(
      points={{-310,254},{-134,254},{-134,208.8},{-121,208.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TConLvg.T, chiCon.TConLvg) annotation (Line(
      points={{68,143},{68,194},{-124,194},{-124,201.6},{-121,201.6}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(chiCon.ychiMod, chi.on) annotation (Line(points={{-98.6,211.2},{-46,211.2},
          {-46,130},{-32,130},{-32,129}}, color={255,0,255}));
  connect(chiCon.TSetChi, chi.TSet) annotation (Line(points={{-98.6,214.6},{-42,
          214.6},{-42,123},{-32,123}}, color={0,0,127}));
  connect(TConEnt.port_a, heaRetHed.ports_b[1]) annotation (Line(points={{0,20},{
          50,20},{50,22},{102,22}},        color={0,127,255}));
  connect(chiCon.yValEva, valEva.y) annotation (Line(points={{-98.6,203.6},{-96,
          203.6},{-96,130},{-114,130},{-114,78},{-106,78}}, color={0,0,127}));
  connect(chiCon.yValCon, valCon.y) annotation (Line(points={{-98.6,206},{-52,206},
          {-52,52},{-46,52}}, color={0,0,127}));
  connect(ambCon.yModInd, yRejHeaInd) annotation (Line(points={{-123,-72},{60,-72},
          {60,-90},{310,-90}}, color={255,127,0}));
  connect(pumBor.port_b, TBorEnt.port_a)
    annotation (Line(points={{-70,-160},{-70,-164}}, color={0,127,255}));
  connect(ambCon.yBorThrVal, valBor.y) annotation (Line(points={{-123,-66.2},{-94,
          -66.2},{-94,-110},{-82,-110}}, color={0,0,127}));
  connect(ambCon.yDisHexPum, gaiMDisHex.u) annotation (Line(points={{-123,-80.8},
          {-120,-80.8},{-120,-252},{38,-252}}, color={0,0,127}));
  connect(hotBufTan.port_b, heaRetHed.ports_a[1]) annotation (Line(points={{180,40},
          {188,40},{188,10},{128,10},{128,20},{122,20}},             color={0,
          127,255}));
  connect(hotBufTan.port_b1, hotWatSup) annotation (Line(points={{160,47},{160,
          60},{300,60}},                                           color={0,127,
          255}));
  connect(cooRetHed.ports_b[1], TValEnt.port_a) annotation (Line(points={{-128,60},
          {-122,60},{-122,60},{-116,60}},         color={0,127,255}));
  connect(valEva.port_1, TValEnt.port_b) annotation (Line(points={{-94,68},{-94,
          64},{-94,60},{-96,60}}, color={0,127,255}));
  connect(TBorEnt.T, ambCon.TBorEnt) annotation (Line(
      points={{-81,-174},{-154,-174},{-154,-82.8},{-145,-82.8}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TBorLvg.T, ambCon.TBorLvg) annotation (Line(
      points={{-41,-210},{-50,-210},{-50,-228},{-156,-228},{-156,-80.8},{-145,
          -80.8}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(heaRetHed.ports_b[2], ambSupHed.ports_b[1]) annotation (Line(points={{102,18},
          {66,18},{66,-128.8},{20,-128.8}},                        color={0,127,
          255}));
  connect(ambSupHed.ports_b[2], TAmbCirLvg.port_a) annotation (Line(points={{20,
          -133.2},{20,-100},{-2,-100},{-2,-100}},          color={0,127,255}));
  connect(TAmbCirLvg.port_b, cooRetHed.ports_a[1]) annotation (Line(points={{-22,
          -100},{-40,-100},{-40,-80},{-80,-80},{-80,-40},{-148,-40},{-148,58}},
                          color={0,127,255}));
  connect(colBufTan.port_b1, cooRetHed.ports_a[2]) annotation (Line(points={{-236,67},
          {-240,67},{-240,86},{-174,86},{-174,62},{-148,62}},
        color={0,127,255}));
  connect(cooSupHed.ports_b[2], colBufTan.port_a1) annotation (Line(points={{-128,22},
          {-182,22},{-182,53},{-216.2,53}},             color={0,127,255}));
  connect(hotBufTan.port_a, heaSupHed.ports_b[2]) annotation (Line(points={{160,40},
          {134,40},{134,62},{112,62}},             color={0,127,255}));
  connect(hotBufTan.port_a1, hotWatRet) annotation (Line(points={{179.8,33},{
          288,33},{288,40},{300,40}},
                                    color={0,127,255}));
  connect(chiWatRet, colBufTan.port_a)
    annotation (Line(points={{-304,60},{-236,60}}, color={0,127,255}));
  connect(colBufTan.port_b, chiWatSup) annotation (Line(points={{-216,60},{-200,
          60},{-200,40},{-304,40}}, color={0,127,255}));
  connect(gaiBor.u, ambCon.yBorPum) annotation (Line(points={{-112,-150},{-112,-77.2},
          {-123,-77.2}}, color={0,0,127}));
  connect(pumBor.m_flow_in, gaiBor.y)
    annotation (Line(points={{-82,-150},{-88,-150}}, color={0,0,127}));
  connect(TBorEnt.port_b, borFie.port_a)
    annotation (Line(points={{-70,-184},{-70,-192}}, color={0,127,255}));
  connect(borFie.port_b, TBorLvg.port_a) annotation (Line(points={{-70,-212},{-70,
          -236},{-30,-236},{-30,-220}}, color={0,127,255}));
   annotation (Icon(coordinateSystem(preserveAspectRatio=false),
       graphics={Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,40},{64,-80}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
          Line(points={{2,78},{-68,40}}, color={27,0,55}),
          Line(points={{2,78},{68,40},{-70,40}}, color={27,0,55}),
        Polygon(
          points={{-78,40},{2,100},{82,40},{-78,40}},
          lineColor={27,0,55},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid),
       Text(
          extent={{-150,146},{150,106}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{-54,30},{-18,2}},
          lineColor={0,140,72},
          pattern=LinePattern.Dot,
          lineThickness=0.5),
        Rectangle(
          extent={{14,30},{54,4}},
          lineColor={0,140,72},
          pattern=LinePattern.Dot,
          lineThickness=0.5),
        Rectangle(
          extent={{-14,-18},{16,-76}},
          lineColor={0,140,72},
          pattern=LinePattern.Dot,
          lineThickness=0.5)}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
                  extent={{-300,-300},{300,300}}),
                  graphics={Line(
                  points={{86,92}},
                  color={28,108,200},
                  pattern=LinePattern.Dash)}),
        defaultComponentName="ETS",
 Documentation(info="<html>
<h4> Energy Transfer Station </h4>
<p>
This models describes the energy transfer station for the 5<sup>th</sup> generation of the district heating and cooling i.e.
ambient/ low temperature systems. The ETS is implemented to satisfy the building thermal requirements and storage during
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
part surplus load rejection,
</li>
<li>
full surplus load rejection.
</li>
</ul>
<p align=\"center\">
<img alt=\"Image the 5th generation of district heating and cooling substation\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/SubstationModifiedLayout.png\"/>

<p>
The substation layout consists of three water circuits categorized by the water temperature
</p>
<ol>
<li>
The hot water circuit which has a hydraulic interface with the building heating requirements.
</li>
<li>
The chilled water circuit which has a hydraulic interface with the building cooling requirements.
</li>
<li>
The ambient water circuit, it includes the borfield and the district heat exchanger systems.
</li>
</ol>

<h4> Hot water circuit</h4>
<p>
It operates to satisfy the building heating requirements and consists of
</p>
<ol>
<li>
The heating/cooling generating source, where the EIR chiller i.e. condenser heat exchanger operates to satisfy the heating setpoint
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
<h4> Chilled water circuit</h4>
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
The cold buffer tank, is implemented obviously for the same mentioned reasons of the hot buffer tank.
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

<h4> Ambient water circuit</h4>
<p>
The ambient water circuit operates to maximize the system exergy by rejecting surplus i.e. heating or cooling energy
first to the borefield system and second to either or both of the borfield and the district systems.
It consists of
</p>
<ol>
<li>
The borfield holes component model <code>borFie</code>.
</li>
<li>
The borefield pump <code>pumBor</code>, where its mass flow rate is modulated using a reverse action PI controller.
</li>
<li>
Modulating mixing three way valve <code>valBor</code> to control the borfield entering water temperature.
</li>
<li>
The heat exchanger component model <code>hex</code>.
</li>
<li>
The heat exchanger district pump <code>pumHexDis</code>, where its mass flow rate is modulated using a reverse action PI controller.
</li>
<li>
Two on/off 2-way valves <code> valHea</code>, <code>valCoo</code>
which separates the ambient from the cold and hot water circuits.
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
end Substation;
