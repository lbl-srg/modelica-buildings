within Buildings.DHC.ETS.Combined;
model HeatRecoveryHeatPump
  "An ETS model with a heat recovery heat pump producing CHW, HHW, and DHW"
  extends Buildings.DHC.ETS.BaseClasses.PartialETS(
    final typ=Buildings.DHC.Types.DistrictSystemType.CombinedGeneration5,
    final have_heaWat=true,
    final have_chiWat=true,
    final have_pum=true,
    final have_eleCoo=true,
    final have_fan=false,
    final have_eleHea=false,
    final have_weaBus=true "Set to true as this determines whether the composite ets and building has a weather bus",
    nPorts_bHeaWat=1,
    nPorts_aHeaWat=1,
    nPorts_bChiWat=1,
    nPorts_aChiWat=1);

  parameter Buildings.DHC.ETS.Types.ConnectionConfiguration conCon=
      Buildings.DHC.ETS.Types.ConnectionConfiguration.Pump
    "District connection configuration" annotation (Evaluate=true);
  parameter Integer nSysHea = 1
    "Number of heating systems"
    annotation (Evaluate=true);
  parameter Integer nSysCoo=nSysHea
    "Number of cooling systems"
    annotation (Evaluate=true);
  parameter Integer nSouAmb=1
    "Number of ambient sources"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpValIso_nominal(displayUnit=
        "Pa") = 2E3 "Nominal pressure drop of ambient circuit isolation valves"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp1Hex_nominal(displayUnit=
        "Pa") "Nominal pressure drop across heat exchanger on district side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.PressureDifference dp2Hex_nominal(displayUnit=
        "Pa") "Nominal pressure drop across heat exchanger on building side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.HeatFlowRate QHex_flow_nominal
    "Nominal heat flow rate through heat exchanger (from district to building)"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.Temperature T_a1Hex_nominal
    "Nominal water inlet temperature on district side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.Temperature T_b1Hex_nominal
    "Nominal water outlet temperature on district side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.Temperature T_a2Hex_nominal
    "Nominal water inlet temperature on building side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.Temperature T_b2Hex_nominal
    "Nominal water outlet temperature on building side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.MassFlowRate m1Hex_flow_nominal =
    abs(QHex_flow_nominal/4200/(T_b1Hex_nominal - T_a1Hex_nominal))
    "Design mass flow rate for heat exchanger on district side";
  parameter Real spePum1HexMin(
    final unit="1",
    min=0)=0.1
    "Heat exchanger primary pump minimum speed (fractional)"
    annotation (Dialog(group="District heat exchanger",enable=not have_val1Hex));
  parameter Real spePum2HexMin(
    final unit="1",
    min=0.01)=0.1
    "Heat exchanger secondary pump minimum speed (fractional)"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.Units.SI.Volume VTanHeaWat =
   datHeaPum.PLRMin*datHeaPum.mCon_flow_nominal*5*60/1000
   "Heating water tank volume"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.Units.SI.Length hTanHeaWat=(VTanHeaWat*16/Modelica.Constants.pi)^(1/3)
  "Heating water tank height (without insulation, assuming twice the diameter)"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.Units.SI.Length dInsTanHeaWat=0.1
    "Heating water tank insulation thickness"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.Units.SI.Volume VTanChiWat =
   datHeaPum.PLRMin*datHeaPum.mEva_flow_nominal*5*60/1000
   "Chilled water tank volume"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.Units.SI.Length hTanChiWat=(VTanChiWat*16/Modelica.Constants.pi)^(1/3)
    "Chilled water tank height (without insulation, assuming twice the diameter)"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.Units.SI.Length dInsTanChiWat=0.1
    "Chilled water tank insulation thickness"
    annotation (Dialog(group="Buffer Tank"));
  parameter Integer nSegTan=3
    "Number of volume segments for tanks"
    annotation (Dialog(group="Buffer Tank"));

  parameter Modelica.Units.SI.TemperatureDifference dTOffSetHea(
    min=0.5,
    displayUnit="K") = 1
    "Temperature to be added to the set point in order to be slightly above what the heating load requires";
  parameter Modelica.Units.SI.TemperatureDifference dTOffSetCoo(
    max=-0.5,
    displayUnit="K") = -1
    "Temperature to be added to the set point in order to be slightly below what the cooling load requires";

  parameter Buildings.DHC.ETS.Combined.Data.GenericHeatPump datHeaPum
    "Heat pump performance data" annotation (
    Dialog(group="Heat recovery heat pump"),
    choicesAllMatching=true,
    Placement(transformation(extent={{60,280},{80,300}})));
  parameter Buildings.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger datDhw
    "Performance data of the domestic hot water component"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{100,280},{120,300}})));
  parameter Boolean have_WSE=false
    "Set to true in case a waterside economizer is used"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit="Pa")
     = datHeaPum.datHea.dpCon_nominal "Nominal pressure drop across condenser"
    annotation (Dialog(group="Heat recovery heat pump"));
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(displayUnit="Pa")
     = datHeaPum.datHea.dpEva_nominal "Nominal pressure drop across evaporator"
    annotation (Dialog(group="Heat recovery heat pump"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Supervisory controller"));
  parameter Real kHot(
    min=0)=0.05
    "Gain of controller on hot side"
    annotation (Dialog(group="Supervisory controller"));
  parameter Real kCol(
    min=0)=0.1
    "Gain of controller on cold side"
    annotation (Dialog(group="Supervisory controller"));
  parameter Modelica.Units.SI.Time TiHot(min=Buildings.Controls.OBC.CDL.Constants.small)
     = 300 "Time constant of integrator block on hot side" annotation (Dialog(
        group="Supervisory controller", enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time TiCol(min=Buildings.Controls.OBC.CDL.Constants.small)
     = 120 "Time constant of integrator block on cold side" annotation (Dialog(
        group="Supervisory controller", enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.Units.SI.Temperature TChiWatSupSetMax(displayUnit="degC") =
    datHeaPum.TEvaLvgMax
    "Maximum value of chilled water supply temperature set point for heat pump (used for heat pump reset)"
    annotation (Dialog(group="Supervisory controller"));
  parameter Modelica.Units.SI.Temperature THeaWatSupSetMin(displayUnit="degC") =
    datHeaPum.TConLvgMin
    "Minimum value of heating water supply temperature set point (used for heat pump reset)";

  parameter Modelica.Units.SI.PressureDifference dp1WSE_nominal(
    displayUnit="Pa") = 40E3
    "Nominal pressure drop across heat exchanger on district side"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.Units.SI.PressureDifference dp2WSE_nominal(
    displayUnit="Pa") = 40E3
    "Nominal pressure drop across heat exchanger on building side"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.Units.SI.HeatFlowRate QWSE_flow_nominal=0
    "Nominal heat flow rate through water-side economizer exchanger (<=0)"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.Units.SI.Temperature T_a1WSE_nominal=279.15
    "Nominal water inlet temperature on district side"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.Units.SI.Temperature T_b1WSE_nominal=284.15
    "Nominal water outlet temperature on district side"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.Units.SI.Temperature T_a2WSE_nominal=288.15
    "Nominal water inlet temperature on building side"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Modelica.Units.SI.Temperature T_b2WSE_nominal=281.15
    "Nominal water outlet temperature on building side"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  parameter Real y1WSEMin(unit="1")=0.05
    "Minimum pump flow rate or valve opening for temperature measurement (fractional)"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));
  final parameter Modelica.Units.SI.MassFlowRate m1WSE_flow_nominal=abs(
      QWSE_flow_nominal/4200/(T_b1WSE_nominal - T_a1WSE_nominal))
    "WSE primary mass flow rate"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));

  parameter MediumBui.Temperature TCon_start = MediumBui.T_default
    "Temperature start value on the condenser side"
    annotation(Dialog(tab = "Initialization"));
  parameter MediumBui.Temperature TEva_start = MediumBui.T_default
    "Temperature start value on the evaporator side"
    annotation(Dialog(tab = "Initialization"));

  // INPUTS and OUTPUTS
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-340,-40},{-300,0}}),iconTransformation(extent={{-380,
            -60},{-300,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-340,-100},{-300,-60}}),
                                                                         iconTransformation(extent={{-380,
            -100},{-300,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dHHeaWat_flow(final unit="W")
    "Heating water distributed energy flow rate"
    annotation (Placement(transformation(extent={{300,140},{340,180}}),
      iconTransformation(extent={{-40,-40},{40,40}},
        rotation=-90,
        origin={240,-340})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dHChiWat_flow(final unit="W")
    "Chilled water distributed energy flow rate"
    annotation (Placement(transformation(extent={{300,100},{340,140}}),
      iconTransformation(extent={{-40,-40},{40,40}},
        rotation=-90,
        origin={280,-340})));

  // COMPONENTS
  Buildings.DHC.ETS.Combined.Subsystems.HeatPumpModular heaPum(
    redeclare final package Medium = MediumBui,
    allowFlowReversal=true,
    final dpCon_nominal=dpCon_nominal,
    final dpEva_nominal=dpEva_nominal,
    final dat=datHeaPum,
    final THeaWatSupSetMin=THeaWatSupSetMin,
    final TChiWatSupSetMax=TChiWatSupSetMax,
    dTOffSetHea=dTOffSetHea,
    dTOffSetCoo=dTOffSetCoo) "Heat pump" annotation (Dialog(group="Heat recovery heat pump"),
      Placement(transformation(extent={{-10,-16},{10,4}})));

  Buildings.DHC.ETS.Combined.Subsystems.HeatExchanger hex(
    redeclare final package Medium1=MediumSer,
    redeclare final package Medium2=MediumBui,
    final allowFlowReversal1=allowFlowReversalSer,
    final allowFlowReversal2=allowFlowReversalBui,
    final conCon=conCon,
    final dp1Hex_nominal=dp1Hex_nominal,
    final dp2Hex_nominal=dp2Hex_nominal,
    final Q_flow_nominal=QHex_flow_nominal,
    final T_a1_nominal=T_a1Hex_nominal,
    final T_b1_nominal=T_b1Hex_nominal,
    final T_a2_nominal=T_a2Hex_nominal,
    final T_b2_nominal=T_b2Hex_nominal,
    final spePum1Min=spePum1HexMin,
    final spePum2Min=spePum2HexMin,
    pum2(dpMax=Modelica.Constants.inf)) "District heat exchanger"
    annotation (Placement(transformation(extent={{-12,-304},{8,-324}})));

  Buildings.DHC.ETS.Combined.Subsystems.StratifiedTankWithCommand tanChiWat(
    redeclare final package Medium = MediumBui,
    final isHotWat=false,
    final m_flow_nominal=colChiWat.mDis_flow_nominal,
    final VTan=VTanChiWat,
    final hTan=hTanChiWat,
    final dIns=dInsTanChiWat,
    final nSeg=nSegTan,
    T_start=TEva_start) "Chilled water tank"
    annotation (Placement(transformation(extent={{140,220},{120,240}})));

  Buildings.DHC.ETS.Combined.Subsystems.StratifiedTankWithCommand tanHeaWat(
    redeclare final package Medium = MediumBui,
    final isHotWat=true,
    final m_flow_nominal=colHeaWat.mDis_flow_nominal,
    final VTan=VTanHeaWat,
    final hTan=hTanHeaWat,
    final dIns=dInsTanHeaWat,
    final nSeg=nSegTan,
    T_start=TCon_start) "Heating hot water tank"
    annotation (Placement(transformation(extent={{-200,220},{-180,240}})));

  Buildings.DHC.ETS.Combined.Subsystems.DHWConsumption tanDhw(
    redeclare final package Medium = MediumBui,
    final dat=datDhw,
    final QHotWat_flow_nominal=datDhw.QHex_flow_nominal,
    dT_nominal=6,
    T_start=TCon_start) if have_hotWat "Tank for domestic hot water"
    annotation (Placement(transformation(extent={{-200,300},{-180,320}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valIsoEva(
    redeclare final package Medium = MediumBui,
    final dpValve_nominal=dpValIso_nominal,
    final m_flow_nominal=colAmbWat.mDis_flow_nominal,
    linearized=true) "Evaporator to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{70,-130},{50,-110}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valIsoCon(
    redeclare final package Medium = MediumBui,
    final dpValve_nominal=dpValIso_nominal,
    final m_flow_nominal=colAmbWat.mDis_flow_nominal,
    linearized=true) "Condenser to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-70,-130},{-50,-110}})));

  Buildings.DHC.ETS.BaseClasses.CollectorDistributor colChiWat(
    redeclare final package Medium = MediumBui,
    final nCon=1 + nSysCoo,
    mCon_flow_nominal={colAmbWat.mDis_flow_nominal, datHeaPum.mEva_flow_nominal})
    "Collector/distributor for chilled water" annotation (Placement(
        transformation(
        extent={{-20,10},{20,-10}},
        rotation=180,
        origin={108,-50})));

  Buildings.DHC.ETS.BaseClasses.CollectorDistributor colHeaWat(
    redeclare final package Medium = MediumBui,
    final nCon=1 + nSysHea,
    mCon_flow_nominal={colAmbWat.mDis_flow_nominal, datHeaPum.mCon_flow_nominal})
    "Collector/distributor for heating water" annotation (Placement(
        transformation(
        extent={{20,10},{-20,-10}},
        rotation=180,
        origin={-120,-50})));

  Buildings.DHC.ETS.BaseClasses.CollectorDistributor colAmbWat(
    redeclare final package Medium = MediumBui,
    final nCon=nSouAmb,
    mCon_flow_nominal={hex.m2_flow_nominal})
    "Collector/distributor for ambient water" annotation (Placement(
        transformation(
        extent={{20,-10},{-20,10}},
        rotation=180,
        origin={0,-104})));

  Buildings.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate dHFloHeaWat(
    redeclare final package Medium1 = MediumBui,
    final m_flow_nominal=colHeaWat.mDis_flow_nominal)
    "Variation of enthalpy flow rate"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-228,230})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTHexBuiEnt(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=m1Hex_flow_nominal,
    final allowFlowReversal=true)
    "Heat exchanger water entering temperature on building side" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,-210})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTHexBuiLvg(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=m1Hex_flow_nominal,
    final allowFlowReversal=true)
    "Heat exchanger water leaving temperature on building side" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-210})));

  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium = MediumBui,
    nPorts=1)
    "Pressure boundary condition representing expansion vessel (common to HHW and CHW)"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={118,30})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum totPPum(
    nin=if have_hotWat then 3 else 2)
    "Total pump power"
    annotation (Placement(transformation(extent={{260,-50},{280,-30}})));

  Buildings.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate dHFloChiWat(
    redeclare final package Medium1 = MediumBui,
    final m_flow_nominal=colChiWat.mDis_flow_nominal)
    "Variation of enthalpy flow rate"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={230,230})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerPHea(
    final k=0)
    "Zero power"
    annotation (Placement(transformation(extent={{260,70},{280,90}})));

  Buildings.Fluid.Actuators.Valves.ThreeWayLinear valMixHea(
    redeclare package Medium = MediumBui,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=datHeaPum.mCon_flow_nominal,
    dpValve_nominal=dpCon_nominal*0.05,
    dpFixed_nominal=dpCon_nominal*0.05*{1,1},
    linearized={true,true}) if have_hotWat
    "Three way valve selecting condenser flow from HHW or DHW return"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-100,70})));
  Buildings.Fluid.FixedResistances.Junction junDomHotWat(
    redeclare final package Medium = MediumBui,
    final dp_nominal={0,0,0},
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final tau=1,
    final m_flow_nominal=datHeaPum.mCon_flow_nominal*{1,-1,-1}) if have_hotWat
    "Junction to domestic hot water tank" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-140,70})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSupSet(final unit="K",
      displayUnit="degC") if have_hotWat
    "Domestic hot water temperature set point for supply to fixtures"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,140}),
        iconTransformation(
        extent={{-380,60},{-300,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TColWat(final unit="K",
      displayUnit="degC") if have_hotWat
    "Cold water temperature that is fed to domestic hot water preparation" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,100}), iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=0,
        origin={-340,60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QReqHotWat_flow(final unit="W")
    if have_hotWat
    "Domestic hot water load"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,60}),  iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=0,
        origin={-340,20})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dHHotWat_flow(final unit="W")
    if have_hotWat
    "Domestic hot water distributed energy flow rate" annotation (Placement(
        transformation(extent={{300,294},{340,334}}), iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=-90,
        origin={200,-340})));

  Buildings.DHC.ETS.Combined.Controls.TwoTankCoordination twoTanCoo(final
      have_hotWat=have_hotWat)
    "Controller to coordinate heat rejection vs use in space or DHW tank"
    annotation (Placement(transformation(extent={{-140,270},{-120,290}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal conDivValChi(realTrue=1,
      realFalse=0)
    "Control for diversion valve to avoid that tank is flushed when changing to district heat exchanger"
    annotation (Placement(transformation(extent={{110,140},{130,160}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear valDivCon(
    redeclare package Medium = MediumBui,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=datHeaPum.mCon_flow_nominal,
    dpValve_nominal=dpCon_nominal*0.05,
    dpFixed_nominal=dpCon_nominal*0.05*{1,1},
    linearized={true,true})
    "Diversion valve used to reject heat and not flow through the whole tank"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-152,150})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear valDivEva(
    redeclare package Medium = MediumBui,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=datHeaPum.mEva_flow_nominal,
    dpValve_nominal=dpEva_nominal*0.05,
    dpFixed_nominal=dpEva_nominal*0.05*{1,1},
    linearized={true,true})
    "Diversion valve used to reject cold and not flow through the whole tank"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={150,150})));
  Buildings.Fluid.FixedResistances.Junction junChiWat(
    redeclare final package Medium = MediumBui,
    final dp_nominal={0,0,0},
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final tau=1,
    final m_flow_nominal=datHeaPum.mCon_flow_nominal*{1,-1,-1})
    "Junction at chilled water tank" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={180,150})));
  Buildings.Fluid.FixedResistances.Junction junHeaWat(
    redeclare final package Medium = MediumBui,
    final dp_nominal={0,0,0},
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final tau=1,
    final m_flow_nominal=datHeaPum.mCon_flow_nominal*{1,-1,-1})
    "Junction at heating water tank" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-180,150})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal conAmbEva(realTrue=0,
      realFalse=1) "Control for valve for ambient loop on evaporator side"
    annotation (Placement(transformation(extent={{90,140},{70,160}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal conDivValHea(realTrue=1,
      realFalse=0)
    "Control for diversion valve to avoid that tank is flushed when changing to district heat exchanger"
    annotation (Placement(transformation(extent={{-110,140},{-130,160}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal conAmbCon(realTrue=0,
      realFalse=1) "Control for valve for ambient loop on condenser side"
    annotation (Placement(transformation(extent={{-90,140},{-70,160}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSerEnt(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal=colAmbWat.mDis_flow_nominal,
    final allowFlowReversal=allowFlowReversalSer)
    "Heat exchanger service line water entering temperature" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-210,-320})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSerLinLvg(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal=colAmbWat.mDis_flow_nominal,
    final allowFlowReversal=allowFlowReversalSer)
    "Heat exchanger service line water leaving temperature" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={248,-320})));
  Controls.EtsHex opeEtsHex "Output true to operate ETS heat exchanger"
    annotation (Placement(transformation(extent={{-72,-310},{-52,-290}})));

  Subsystems.WatersideEconomizer WSE(
    redeclare final package Medium1 = MediumSer,
    redeclare final package Medium2 = MediumBui,
    final allowFlowReversal1=allowFlowReversalSer,
    final allowFlowReversal2=allowFlowReversalBui,
    final conCon=conCon,
    final dp1Hex_nominal=dp1WSE_nominal,
    final dp2Hex_nominal=dp2WSE_nominal,
    final Q_flow_nominal=QWSE_flow_nominal,
    final T_a1_nominal=T_a1WSE_nominal,
    final T_b1_nominal=T_b1WSE_nominal,
    final T_a2_nominal=T_a2WSE_nominal,
    final T_b2_nominal=T_b2WSE_nominal,
    final y1Min=y1WSEMin) if have_WSE "Waterside economizer"
    annotation (Placement(transformation(extent={{180,220},{200,200}})));
  Buildings.DHC.ETS.BaseClasses.Junction splWSE(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal={
      hex.m1_flow_nominal + m1WSE_flow_nominal,
     -hex.m1_flow_nominal,
     -m1WSE_flow_nominal})
    "Flow splitter for WSE"
    annotation (Placement(transformation(extent={{-180,-310},{-160,-330}})));
  Buildings.DHC.ETS.BaseClasses.Junction mixWSE(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal={
      hex.m1_flow_nominal,
      -hex.m1_flow_nominal-m1WSE_flow_nominal,
      m1WSE_flow_nominal})
    "Flow mixer for WSE"
    annotation (Placement(transformation(extent={{200,-310},{220,-330}})));

protected
  parameter Boolean have_val1Hex=
    conCon ==Buildings.DHC.ETS.Types.ConnectionConfiguration.TwoWayValve
    "True in case of control valve on district side, false in case of a pump";

  Buildings.DHC.Plants.Cooling.BaseClasses.ParallelPipes parPip(
    redeclare final package Medium = MediumBui,
    m_flow_nominal=datHeaPum.mCon_flow_nominal,
    dp_nominal=0) if not have_hotWat "Parallel pipes for routing purposes"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-176,70})));

equation
  connect(totPPum.y,PPum)
    annotation (Line(points={{282,-40},{320,-40}},color={0,0,127}));
  connect(valIsoEva.port_b,colAmbWat.port_bDisSup)
    annotation (Line(points={{50,-120},{30,-120},{30,-104},{20,-104}},color={0,127,255}));
  connect(valIsoCon.port_b,colAmbWat.port_aDisSup)
    annotation (Line(points={{-50,-120},{-30,-120},{-30,-104},{-20,-104}},color={0,127,255}));
  connect(valIsoEva.port_a,colChiWat.ports_aCon[1])
    annotation (Line(points={{70,-120},{80,-120},{80,-34},{96,-34},{96,-40}},
                                                             color={0,127,255}));
  connect(valIsoCon.port_a,colHeaWat.ports_aCon[1])
    annotation (Line(points={{-70,-120},{-90,-120},{-90,-34},{-108,-34},{-108,
          -40}},                                                color={0,127,255}));
  connect(bou.ports[1], colChiWat.port_aDisSup)
    annotation (Line(points={{128,30},{150,30},{150,-50},{128,-50}},
                                                              color={0,127,255}));
  connect(colAmbWat.port_bDisRet, colHeaWat.ports_bCon[1]) annotation (Line(
        points={{-20,-98},{-146,-98},{-146,-34},{-132,-34},{-132,-40}},   color
        ={0,127,255}));
  connect(colAmbWat.port_aDisRet, colChiWat.ports_bCon[1]) annotation (Line(
        points={{20,-98},{154,-98},{154,-34},{120,-34},{120,-40}},   color={0,
          127,255}));
  connect(THeaWatSupSet, tanHeaWat.TTanSet) annotation (Line(points={{-320,-20},
          {-206,-20},{-206,239},{-201,239}},            color={0,0,127}));
  connect(senTHexBuiLvg.port_b, colAmbWat.ports_aCon[1]) annotation (Line(
        points={{-20,-200},{-20,-146},{12,-146},{12,-114}}, color={0,127,255}));
  connect(hex.port_b2, senTHexBuiLvg.port_a) annotation (Line(points={{-12,-308},
          {-20,-308},{-20,-220}}, color={0,127,255}));
  connect(hex.port_a2, senTHexBuiEnt.port_b) annotation (Line(points={{8,-308},{
          20,-308},{20,-220}},  color={0,127,255}));
  connect(senTHexBuiEnt.port_a, colAmbWat.ports_bCon[1]) annotation (Line(
        points={{20,-200},{20,-152},{-12,-152},{-12,-114}}, color={0,127,255}));
  connect(totPPum.u[1], hex.PPum) annotation (Line(points={{258,-40},{246,-40},{
          246,-100},{160,-100},{160,-314},{10,-314}},
                                 color={0,0,127}));
  connect(dHFloHeaWat.dH_flow, dHHeaWat_flow) annotation (Line(points={{-240,233},
          {-240,232},{-248,232},{-248,252},{310,252},{310,160},{320,160}},
                                 color={0,0,127}));
  connect(dHFloChiWat.dH_flow, dHChiWat_flow) annotation (Line(points={{242,227},
          {272,227},{272,120},{320,120}},           color={0,0,127}));
  connect(heaPum.port_bChiWat, colChiWat.ports_aCon[2]) annotation (Line(points={{-10,-12},
          {-20,-12},{-20,-30},{96,-30},{96,-40}},   color={0,127,255}));
  connect(colHeaWat.ports_aCon[2], heaPum.port_bHeaWat) annotation (Line(points
        ={{-108,-40},{-108,-24},{20,-24},{20,0},{10,0}}, color={0,127,255}));
  connect(heaPum.PPum, totPPum.u[2]) annotation (Line(points={{12,-8},{246,-8},{
          246,-40},{258,-40}},                    color={0,0,127}));
  connect(tanDhw.THotWatSupSet, THotWatSupSet) annotation (Line(points={{-202,310},
          {-288,310},{-288,140},{-320,140}},                            color={
          0,0,127}));
  connect(TColWat, tanDhw.TColWat) annotation (Line(points={{-320,100},{-284,100},
          {-284,306},{-202,306}},                     color={0,0,127}));
  connect(QReqHotWat_flow, tanDhw.QReqHotWat_flow) annotation (Line(points={{-320,60},
          {-260,60},{-260,314},{-202,314}},                             color={
          0,0,127}));
  connect(dHFloHeaWat.port_a1, tanHeaWat.port_loaTop) annotation (Line(points={{-218,
          236},{-200,236}},                  color={0,127,255}));
  connect(tanHeaWat.port_loaBot, dHFloHeaWat.port_b2) annotation (Line(points={{-200,
          224},{-218,224}},                  color={0,127,255}));
  connect(tanDhw.PEle, totPPum.u[3]) annotation (Line(points={{-179,306},{246,306},
          {246,-40},{258,-40}},                          color={0,0,127}));
  connect(tanDhw.charge,twoTanCoo.uDhw)  annotation (Line(points={{-178,302},{-152,
          302},{-152,284},{-142,284}}, color={255,0,255}));
  connect(tanHeaWat.charge, twoTanCoo.uHea) annotation (Line(points={{-178,227},
          {-160,227},{-160,275.8},{-142,275.8}},
                                             color={255,0,255}));
  connect(tanDhw.dHFlo, dHHotWat_flow) annotation (Line(points={{-179,314},{320,
          314}},                      color={0,0,127}));
  connect(tanDhw.port_b, valMixHea.port_3) annotation (Line(points={{-200,304},{
          -210,304},{-210,124},{-120,124},{-120,70},{-110,70}},
                                        color={0,127,255}));
  connect(tanDhw.port_a, junDomHotWat.port_3) annotation (Line(points={{-200,316},
          {-212,316},{-212,120},{-124,120},{-124,70},{-130,70}},      color={0,
          127,255}));
  connect(tanChiWat.charge, conDivValChi.u) annotation (Line(points={{118,227},{
          100,227},{100,150},{108,150}},                 color={255,0,255}));
  connect(valMixHea.port_2, colHeaWat.port_aDisSup) annotation (Line(points={{-100,60},
          {-100,20},{-150,20},{-150,-50},{-140,-50}},                   color={
          0,127,255}));
  connect(junDomHotWat.port_1, colHeaWat.port_bDisRet) annotation (Line(points={{-140,60},
          {-140,26},{-156,26},{-156,-56},{-140,-56}},            color={0,127,
          255}));
  connect(parPip.port_b2, colHeaWat.port_aDisSup) annotation (Line(points={{-170,60},
          {-170,-50},{-140,-50}},          color={0,127,255}));
  connect(valDivCon.port_1, tanHeaWat.port_genBot) annotation (Line(points={{-152,
          160},{-152,224},{-180,224}}, color={0,127,255}));
  connect(conDivValChi.y, valDivEva.y)
    annotation (Line(points={{132,150},{138,150}},
                                                 color={0,0,127}));
  connect(tanChiWat.port_loaTop, dHFloChiWat.port_b2) annotation (Line(points={{140,236},
          {160,236},{160,236},{220,236}}, color={0,127,255}));
  connect(tanChiWat.port_loaBot, dHFloChiWat.port_a1) annotation (Line(points={{140,224},
          {160,224},{160,224},{220,224}}, color={0,127,255}));
  connect(colChiWat.port_aDisSup, valDivEva.port_2) annotation (Line(points={{128,-50},
          {150,-50},{150,140}},         color={0,127,255}));
  connect(valDivEva.port_1, tanChiWat.port_genTop) annotation (Line(points={{150,160},
          {150,180},{104,180},{104,236},{120,236}},
                                         color={0,127,255}));
  connect(colChiWat.port_bDisRet, junChiWat.port_1) annotation (Line(points={{128,-56},
          {180,-56},{180,140}},         color={0,127,255}));
  connect(junChiWat.port_2, tanChiWat.port_genBot) annotation (Line(points={{180,160},
          {180,184},{110,184},{110,224},{120,224}},
                                        color={0,127,255}));
  connect(valDivEva.port_3, junChiWat.port_3)
    annotation (Line(points={{160,150},{170,150}},
                                                 color={0,127,255}));
  connect(junDomHotWat.port_2, junHeaWat.port_1) annotation (Line(points={{-140,80},
          {-140,92},{-180,92},{-180,140}},    color={0,127,255}));
  connect(junHeaWat.port_2, tanHeaWat.port_genTop) annotation (Line(points={{-180,
          160},{-180,208},{-168,208},{-168,236},{-180,236}},
                                            color={0,127,255}));
  connect(valDivCon.port_3, junHeaWat.port_3)
    annotation (Line(points={{-162,150},{-170,150}},
                                                   color={0,127,255}));
  connect(parPip.port_b1, junHeaWat.port_1) annotation (Line(points={{-182,80},{
          -182,140},{-180,140}},          color={0,127,255}));
  connect(parPip.port_a1, colHeaWat.port_bDisRet) annotation (Line(points={{-182,60},
          {-182,-56},{-140,-56}},          color={0,127,255}));
  connect(valDivCon.port_2, parPip.port_a2)
    annotation (Line(points={{-152,140},{-152,100},{-170,100},{-170,80}},
                                                   color={0,127,255}));
  connect(valMixHea.port_1, valDivCon.port_2) annotation (Line(points={{-100,80},
          {-100,100},{-152,100},{-152,140}},
                                         color={0,127,255}));
  connect(conAmbEva.u, tanChiWat.charge) annotation (Line(points={{92,150},{100,
          150},{100,227},{118,227}},                   color={255,0,255}));
  connect(valIsoEva.y, conAmbEva.y) annotation (Line(points={{60,-108},{60,150},
          {68,150}},                    color={0,0,127}));
  connect(conDivValHea.y, valDivCon.y) annotation (Line(points={{-132,150},{-140,
          150}},                    color={0,0,127}));
  connect(valIsoCon.y, conAmbCon.y) annotation (Line(points={{-60,-108},{-60,150},
          {-68,150}},                          color={0,0,127}));
  connect(twoTanCoo.y, conDivValHea.u) annotation (Line(points={{-118,280},{-100,
          280},{-100,150},{-108,150}},     color={255,0,255}));
  connect(conAmbCon.u, twoTanCoo.y) annotation (Line(points={{-92,150},{-100,150},
          {-100,280},{-118,280}},      color={255,0,255}));
  connect(twoTanCoo.yMix, valMixHea.y) annotation (Line(points={{-118,285},{-52,
          285},{-52,70},{-88,70}},                           color={0,0,127}));
  connect(port_aSerAmb, senTSerEnt.port_a)
    annotation (Line(points={{-300,-200},{-280,-200},{-280,-320},{-220,-320}},
                                                       color={0,127,255}));
  connect(senTSerLinLvg.port_b, port_bSerAmb)
    annotation (Line(points={{258,-320},{282,-320},{282,-200},{300,-200}},
                                                     color={0,127,255}));
  connect(heaPum.uHeaSpa, tanHeaWat.charge) annotation (Line(points={{-12,-2},{-24,
          -2},{-24,227},{-178,227}},     color={255,0,255}));
  connect(heaPum.uCoo, tanChiWat.charge) annotation (Line(points={{-12,-6},{-16,
          -6},{-16,227},{118,227}}, color={255,0,255}));
  connect(heaPum.THeaWatSupSet, THeaWatSupSet) annotation (Line(points={{-12,-8},
          {-40,-8},{-40,-68},{-206,-68},{-206,-20},{-320,-20}},
                                          color={0,0,127}));
  connect(heaPum.TChiWatSupSet, TChiWatSupSet) annotation (Line(points={{-12,-10},
          {-36,-10},{-36,-80},{-320,-80}},   color={0,0,127}));
  connect(opeEtsHex.yVal1, valIsoEva.y_actual) annotation (Line(points={{-74,-296},
          {-92,-296},{-92,-180},{46,-180},{46,-113},{55,-113}},       color={0,
          0,127}));
  connect(opeEtsHex.yVal2, valIsoCon.y_actual) annotation (Line(points={{-74,-304},
          {-94,-304},{-94,-178},{-44,-178},{-44,-113},{-55,-113}},
        color={0,0,127}));
  connect(heaPum.uHeaDhw, twoTanCoo.yDhw) annotation (Line(points={{-12,-4},{-20,
          -4},{-20,275},{-118,275}},                           color={255,0,255}));
  connect(tanChiWat.charge, WSE.uCoo) annotation (Line(points={{118,227},{100,227},
          {100,210},{178,210}}, color={255,0,255}));
  connect(valIsoEva.y_actual, WSE.yValIsoEva_actual) annotation (Line(points={{55,-113},
          {46,-113},{46,212},{178,212},{178,213}},       color={0,0,127}));
  connect(senTSerEnt.port_b, splWSE.port_1) annotation (Line(points={{-200,-320},
          {-180,-320}},                         color={0,127,255}));
  connect(splWSE.port_2, hex.port_a1)
    annotation (Line(points={{-160,-320},{-12,-320}}, color={0,127,255}));
  connect(senTSerLinLvg.port_a, mixWSE.port_2) annotation (Line(points={{238,-320},
          {220,-320}},                       color={0,127,255}));
  connect(mixWSE.port_1, hex.port_b1)
    annotation (Line(points={{200,-320},{8,-320}},  color={0,127,255}));
  connect(WSE.port_b1, mixWSE.port_3) annotation (Line(points={{200,204},{210,204},
          {210,-310}},                     color={0,127,255}));
  connect(WSE.port_a1, splWSE.port_3) annotation (Line(points={{180,204},{178,204},
          {178,196},{200,196},{200,-280},{-170,-280},{-170,-310}},
                                              color={0,127,255}));
  connect(WSE.port_a2, dHFloChiWat.port_b2) annotation (Line(points={{200,216},{
          210,216},{210,236},{220,236}},           color={0,127,255}));
  connect(WSE.port_b2, tanChiWat.port_loaTop) annotation (Line(points={{180,216},
          {170,216},{170,236},{140,236}}, color={0,127,255}));
  connect(heaPum.PChi, PCoo) annotation (Line(points={{12,-4},{272,-4},{272,40},
          {320,40}},              color={0,0,127}));
  connect(zerPHea.y, PHea)
    annotation (Line(points={{282,80},{320,80}}, color={0,0,127}));
  for i in 1:nPorts_bHeaWat loop
    connect(dHFloHeaWat.port_b1, ports_bHeaWat[i]) annotation (Line(points={{-238,
            236},{-252,236},{-252,260},{300,260}},
                                        color={0,127,255}));
  end for;
  for i in 1:nPorts_aHeaWat loop
    connect(dHFloHeaWat.port_a2, ports_aHeaWat[i]) annotation (Line(points={{-238,
            224},{-278,224},{-278,260},{-300,260}},
                                         color={0,127,255}));
  end for;
  for i in 1:nPorts_bChiWat loop
    connect(dHFloChiWat.port_b1, ports_bChiWat[i]) annotation (Line(points={{240,224},
            {282,224},{282,200},{300,200}},
                                       color={0,127,255}));
  end for;
  for i in 1:nPorts_aChiWat loop
    connect(ports_aChiWat[i], dHFloChiWat.port_a2) annotation (Line(points={{-300,
            200},{-274,200},{-274,256},{260,256},{260,236},{240,236}},
                                       color={0,127,255}));
  end for;
    connect(opeEtsHex.on, hex.on) annotation (Line(points={{-50,-300},{-40,-300},
          {-40,-316},{-14,-316}},   color={255,0,255}));
  connect(heaPum.port_aHeaWat, colHeaWat.ports_bCon[2])
    annotation (Line(points={{-10,0},{-132,0},{-132,-40}}, color={0,127,255}));
  connect(heaPum.port_aChiWat, colChiWat.ports_bCon[2]) annotation (Line(points
        ={{10,-12},{120,-12},{120,-40}}, color={0,127,255}));
  connect(TChiWatSupSet, tanChiWat.TTanSet) annotation (Line(points={{-320,-80},
          {-36,-80},{-36,246},{146,246},{146,239},{141,239}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(extent={{-300,-300},{300,300}}),
                   graphics={
        Rectangle(
          extent={{12,-40},{40,-12}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{18,-44},{46,-16}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,30},{-68,20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1.5,5.5},{1.5,-5.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-13.5,20.5},
          rotation=90),
        Rectangle(
          extent={{-74,76},{66,-84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,48},{-44,8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,66},{54,48}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-2},{-56,8},{-36,8},{-46,-2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-2},{-56,-14},{-36,-14},{-46,-2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,-14},{-44,-54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{34,48},{38,-54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-54},{54,-72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,20},{58,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,20},{18,-12},{54,-12},{36,20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,48},{-44,8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,66},{54,48}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-2},{-56,8},{-36,8},{-46,-2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-2},{-56,-14},{-36,-14},{-46,-2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,-14},{-44,-54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{34,48},{38,-54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-54},{54,-72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,20},{58,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,20},{18,-12},{54,-12},{36,20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{116,-46},{144,-18}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=have_WSE),
        Rectangle(
          extent={{118,-44},{146,-16}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=have_WSE),
        Rectangle(
          extent={{100,76},{240,-84}},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          visible=have_WSE),
        Rectangle(
          extent={{100,74},{240,-84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          visible=have_WSE),  Rectangle(
          extent={{100,74},{240,-86}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          visible=have_WSE),
        Rectangle(
          extent={{108,56},{120,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_WSE),
        Rectangle(
          extent={{120,56},{136,-62}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          visible=have_WSE),
        Rectangle(
          extent={{148,56},{164,-62}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          visible=have_WSE),
        Rectangle(
          extent={{136,56},{148,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_WSE),
        Rectangle(
          extent={{176,56},{192,-62}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          visible=have_WSE),
        Rectangle(
          extent={{164,56},{176,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_WSE),
        Rectangle(
          extent={{204,56},{220,-62}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          visible=have_WSE),
        Rectangle(
          extent={{192,56},{204,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_WSE),
        Rectangle(
          extent={{220,56},{232,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_WSE),
        Rectangle(extent={{-262,140},{258,-142}}, lineColor={95,95,95})}),
Documentation(info="<html>
<p>
Model of an Energy Transfer Station with heat recovery heat pump,
buffer tanks and optional domestic hot water preparation and
optional water-side economizer.
</p>
<p>
The figure below shows the schematic diagram.
The heat recovery heat pump preferentially operates
in heat recovery mode, but if heating (or cooling) demand
persists while the cold (or hot) water-side buffer tank is fully
charged, the evaporator (or condenser) temperature is reset,
the corresponding tank is decoupled to avoid flushing the tank,
and heat is exchanged with the district energy system.
</p>
<p align=\"center\">
    <img src=\"modelica://Buildings/Resources/Images/DHC/ETS/Combined/HeatRecoveryHeatPump.png\"
         alt=\"Schematic diagram of the ETS.\"
         style=\"width: 100%; height: auto;\">
<p>
The operation is as follows:
</p>
<h4>Domestic Hot Water Tank and Buffer Tanks</h4>

<p>
The chilled water and heating hot water tanks are
by default sized for five minutes and used as buffer tanks. The
DHW tank is by default sized for 24 hours of storage. Each tank
generates a signal to request charging. If the
temperature of its supply side (top for the hot tank,
bottom for the cold tank) deviates from the set point
with hysteresis, charging is enabled until the
temperature of its return side (bottom for the hot
tank, top for the cold tank) achieves the set point
with hysteresis.</p>

<p>
When the space heating or cooling tank does not
request charging, the diversion valve <code>VAL_DIV_CON</code>
or <code>VAL_DIV_EVA</code> to the respective tank is closed, and
the isolation valve <code>VAL_ISO_CON</code> or <code>VAL_ISO_EVA</code>
is opened to allow energy exchange with the district
heat exchanger. The diversion valves are necessary
because, for example, when the ETS operates cooling
only mode, rejecting heat to the ambient loop, the
condenser outputs hot water at the minimum leaving
temperature is <i>15&deg;C</i>. Without the diversion
valve, the cool water from the condenser would flush
out the energy stored in the space heating tank.
This causes energy waste. It also causes short
cycling because the tank will request charging
repeatedly as its temperature falls below the
heating set point, bring the system into a limit
cycle.</p>

<h4>Two-tank Coordination on the Condenser Side</h4>

<p>
The integration of the DHW tank is optional, as
not all buildings prepare DHW using the ETS. When
integrated, the space heating and DHW tank share the
same condenser loop. The table below
explains how the two loops are coordinated through
valve control.
</p>

<table summary=\"Tank control signals.\" style=\"margin-left: auto; margin-right: auto; border-collapse: collapse; border: 1px solid black;\">
    <caption>Control signal coordination of the DHW
        tank and the space heating tank. Depending on the
        charge signal, the control block computes the position
        y<sub>mix</sub> of the mixing valve <code>VAL_MIX</code> (position 1 is
        to the space heating tank, position 0 is to the DHW
        tank) and y<sub>div</sub> of the condenser-side diversion
        valve <code>VAL_DIV_CON</code>.</caption>
    <thead style=\"background-color: #f0f0f0;\">
        <tr>
            <th colspan=\"2\"
                style=\"text-align: center; border: 1px solid black; padding: 5px;\">
                <strong>Charge signal</strong></th>
            <th colspan=\"2\"
                style=\"text-align: center; border: 1px solid black; padding: 5px;\">
                <strong>Controller output</strong></th>
        </tr>
        <tr>
            <th style=\"text-align: left; border: 1px solid black; padding: 5px;\">DHW</th>
            <th style=\"text-align: left; border: 1px solid black; padding: 5px;\">HHW</th>
            <th style=\"text-align: left; border: 1px solid black; padding: 5px;\">y<sub>mix</sub></th>
            <th style=\"text-align: left; border: 1px solid black; padding: 5px;\">y<sub>div</sub></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td style=\"border: 1px solid black; padding: 5px;\">on</td>
            <td style=\"border: 1px solid black; padding: 5px;\">on</td>
            <td style=\"border: 1px solid black; padding: 5px;\">0.5</td>
            <td style=\"border: 1px solid black; padding: 5px;\">1</td>
        </tr>
        <tr>
            <td style=\"border: 1px solid black; padding: 5px;\">on</td>
            <td style=\"border: 1px solid black; padding: 5px;\">off</td>
            <td style=\"border: 1px solid black; padding: 5px;\">0</td>
            <td style=\"border: 1px solid black; padding: 5px;\">1</td>
        </tr>
        <tr>
            <td style=\"border: 1px solid black; padding: 5px;\">off</td>
            <td style=\"border: 1px solid black; padding: 5px;\">on</td>
            <td style=\"border: 1px solid black; padding: 5px;\">1</td>
            <td style=\"border: 1px solid black; padding: 5px;\">1</td>
        </tr>
        <tr>
            <td style=\"border: 1px solid black; padding: 5px;\">off</td>
            <td style=\"border: 1px solid black; padding: 5px;\">off</td>
            <td style=\"border: 1px solid black; padding: 5px;\">1</td>
            <td style=\"border: 1px solid black; padding: 5px;\">0</td>
        </tr>
    </tbody>
</table>

<h4>Heat Recovery Heat Pump</h4>
<p>
The heat recovery heat pump can produce heating,
cooling, or both simultaneously. The condenser pump
<code>PUM_CON</code> and the evaporator pump <code>PUM_EVA</code> are enabled
when any of the respective tanks requests charging.
The heat pump is turned on <i>30</i> seconds after
<code>PUM_CON</code> and <code>PUM_EVA</code> are running.
</p>
<p>
When on, the primary pumps are operated at constant
speed, and the condenser (resp. evaporator) mixing
valve <code>VAL_CON</code> (resp. <code>VAL_EVA</code>) are modulated with a
P controller to track the set point for the water
that leaves the heat pump, with a small offset to
open first the valve and then ramp up the compressor
speed.
</p>
<p>
The compressor speed is controlled based on the
same temperature measurement as the mixing valves.
Based on a moving average of the compressor speed
signal for heating and cooling, the heat pump control
is switched into heating or cooling dominated
operation, and the respective compressor speed
setpoint is sent to the heat pump.
</p>
<p>
If only heating (or only cooling) is requested
from the tank, then the evaporator (or condenser)
set point temperature is reset to minimize the
temperature lift across the heat pump.
</p>
<h4>District Heat Exchanger</h4>
<p>
The district heat exchanger hydraulically decouples
the buildings system and the district system. Its
primary and secondary circuits are enabled to operate
if either any of the tanks request charging, and if
an isolation valve <code>VAL_ISO_CON</code> or <code>VAL_ISO_EVA</code>
is open. When enabled, the pumps <code>PUM1_DHX</code> and
<code>PUM2_DHX</code> operate at a constant speed.
</p>
<h4>Temperature Set Points</h4>
<p>
The set points for the supply temperatures are input to this
model.
For the heating supply water, use <code>THeaWatSupSet</code>,
for the cooling supply water, use <code>TChiWatSupSet</code>.
</p>
<p>
If a domestic hot water supply is present, as declared
through the parameter <code>have_hotWat</code>,
then use <code>THotWatSupSet</code> for the set point
temperature to the end user (such as shower),
and use <code>TColWat</code> for the temperature of the cold water supply
and <code>QReqHotWat_flow</code> for the heat flow rate associated
with the hot water supply, i.e.,
<code>QReqHotWat_flow = mHotWat_flow c<sub>wat</sub> (THotWatSupSet-TColWat)</code>, where
<code>mHotWat_flow</code> is the hot water mass flow rate, and
<code>c<sub>wat</sub></code> is the specific heat capacity of water.
</p>
<h4>Domestic Hot Water Preparation</h4>
<p>
The DHW preparation is optional.
If present, a fresh water station is used.
The fresh water station allows to
store heat in the heating rather than the
domestic hot water, therefore avoiding the potential problem
of Legionella bacteria getting from the
hot water tank to the DHW circuit.
This allows to operate the storage at a lower temperature,
thereby increasing the heat pump COP.
</p>
<p>
The integration of the domestic hot water is further described in
<a href=\"modelica://Buildings.DHC.ETS.Combined.Subsystems.DHWConsumption\">
Buildings.DHC.ETS.Combined.Subsystems.DHWConsumption</a>,
which uses the fresh water station that is described and shown
with a schematic diagram at
<a href=\"modelica://Buildings.DHC.ETS.Combined.Subsystems.StorageTankWithExternalHeatExchanger\">
Buildings.DHC.ETS.Combined.Subsystems.StorageTankWithExternalHeatExchanger</a>.
</p>
<h4>Water-side economizer</h4>
<p>
The water-side economizer is optional.
Use of the water-side economizer can improve resilience during heat waves
when power consumption of the ETS need to be curtailed by switching of the chiller,
for example during a grid outage when the site operates
on emergency power.
</p>
<p>
To use the water-side economizer, if the temperature conditions are favorable,
the valves (or pumps) are activated
in order to cool the chilled water supply to the building.
This model and its operation is described in
<a href=\"modelica://Buildings.DHC.ETS.Combined.Subsystems.WatersideEconomizer\">
Buildings.DHC.ETS.Combined.Subsystems.WatersideEconomizer</a>.
and in Gautier et al. (2022).
</p>
<h4>References</h4>
<p>
Antoine Gautier, Michael Wetter and Matthias Sulzer.<br/>
<a href=\"https://doi.org/10.1016/j.apenergy.2022.119880\">
Resilient cooling through geothermal district energy system</a>.<br/>
<i>Applied Energy</i>, 325, November, 2022.
</p>

</html>", revisions="<html>
<ul>
<li>
November 14, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-300,-340},{300,340}})));
end HeatRecoveryHeatPump;
