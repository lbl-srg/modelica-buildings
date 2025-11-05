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
    final have_weaBus=false,
    nPorts_aHeaWat=1,
    nPorts_bChiWat=1,
    nPorts_bHeaWat=1,
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

  parameter Buildings.DHC.ETS.Combined.Data.HeatPump datHeaPum
    "Heat pump performance data"
    annotation (
    Dialog(group="Chiller"),
    choicesAllMatching=true,
    Placement(transformation(extent={{20,220},{40,240}})));
  parameter Buildings.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger datDhw
    "Performance data of the domestic hot water component"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-40,220},{-20,240}})));
  parameter Boolean have_WSE=false
    "Set to true in case a waterside economizer is used"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Nominal pressure drop across condenser"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Nominal pressure drop across evaporator"
    annotation (Dialog(group="Chiller"));
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
  parameter Modelica.Units.SI.Temperature TChiWatSupSetMin(displayUnit="degC")
     = datHeaPum.TEvaLvgMin
    "Minimum value of chilled water supply temperature set point"
    annotation (Dialog(group="Supervisory controller"));
  parameter Modelica.Units.SI.Temperature TChiWatSupSetMax(displayUnit="degC")
     = datHeaPum.TEvaLvgMax
    "Maximum value of chilled water supply temperature set point for heat pump (used for heat pump reset)"
    annotation (Dialog(group="Supervisory controller"));
  parameter Modelica.Units.SI.Temperature THeaWatSupSetMin(displayUnit="degC")
     = datHeaPum.TConLvgMin
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
    annotation (Placement(transformation(extent={{-340,-80},{-300,-40}}),iconTransformation(extent={{-380,
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
  replaceable Buildings.DHC.ETS.Combined.Subsystems.HeatPumpModular heaPum(
    redeclare final package Medium = MediumBui,
    allowFlowReversal=true,
    final dpCon_nominal=dpCon_nominal,
    final dpEva_nominal=dpEva_nominal,
    final dat=datHeaPum,
    final THeaWatSupSetMin=THeaWatSupSetMin,
    final TChiWatSupSetMax=TChiWatSupSetMax,
    dTOffSetHea=dTOffSetHea,
    dTOffSetCoo=dTOffSetCoo) "Heat pump" annotation (Dialog(group="Chiller"),
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
    annotation (Placement(transformation(extent={{-10,-240},{10,-260}})));

  Buildings.DHC.ETS.Combined.Subsystems.StratifiedTankWithCommand tanChiWat(
    redeclare final package Medium = MediumBui,
    final isHotWat=false,
    final m_flow_nominal=colChiWat.mDis_flow_nominal,
    final VTan=VTanChiWat,
    final hTan=hTanChiWat,
    final dIns=dInsTanChiWat,
    final nSeg=nSegTan,
    T_start=TEva_start) "Chilled water tank"
    annotation (Placement(transformation(extent={{200,100},{180,120}})));

  Buildings.DHC.ETS.Combined.Subsystems.StratifiedTankWithCommand tanHeaWat(
    redeclare final package Medium = MediumBui,
    final isHotWat=true,
    final m_flow_nominal=colHeaWat.mDis_flow_nominal,
    final VTan=VTanHeaWat,
    final hTan=hTanHeaWat,
    final dIns=dInsTanHeaWat,
    final nSeg=nSegTan,
    T_start=TCon_start) "Heating hot water tank"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));

  Buildings.DHC.ETS.Combined.Subsystems.DHWConsumption tanDhw(
    redeclare final package Medium = MediumBui,
    final dat=datDhw,
    final QHotWat_flow_nominal=datDhw.QHex_flow_nominal,
    dT_nominal=6,
    T_start=TCon_start) if have_hotWat "Tank for domestic hot water"
    annotation (Placement(transformation(extent={{-200,220},{-180,240}})));

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
        origin={120,-50})));

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
        origin={0,-106})));

  Buildings.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate dHFloHeaWat(
    redeclare final package Medium1 = MediumBui,
    final m_flow_nominal=colHeaWat.mDis_flow_nominal)
    "Variation of enthalpy flow rate"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-274,170})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTHexBuiEnt(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=m1Hex_flow_nominal,
    final allowFlowReversal=true)
    "Heat exchanger water entering temperature on building side" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-210})));

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
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={190,-50})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum totPPum(
    nin=if have_hotWat then 3 else 2)
    "Total pump power"
    annotation (Placement(transformation(extent={{260,-70},{280,-50}})));

  Buildings.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate dHFloChiWat(
    redeclare final package Medium1 = MediumBui,
    final m_flow_nominal=colChiWat.mDis_flow_nominal)
    "Variation of enthalpy flow rate"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={258,130})));
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
        origin={-80,60})));
  Buildings.Fluid.FixedResistances.Junction junDomHotWat(
    redeclare final package Medium = MediumBui,
    final dp_nominal={0,0,0},
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final tau=1,
    final m_flow_nominal=datHeaPum.mCon_flow_nominal*{1,-1,-1}) if have_hotWat
    "Junction to domestic hot water tank" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-116,60})));
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
        transformation(extent={{298,280},{338,320}}), iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=-90,
        origin={200,-340})));

  Buildings.DHC.ETS.Combined.Controls.TwoTankCoordination twoTanCoo(final
      have_hotWat=have_hotWat)
    "Controller to coordinate heat rejection vs use in space or DHW tank"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal conDivValChi(realTrue=1,
      realFalse=0)
    "Control for diversion valve to avoid that tank is flushed when changing to district heat exchanger"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
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
        origin={-144,90})));
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
        origin={150,80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChiWatRet(
    redeclare package Medium = MediumBui,
    allowFlowReversal=true,
    final m_flow_nominal=datHeaPum.mCon_flow_nominal)
    "Return chilled water temperature to chiller, prior to chiller valve"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,-12})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(
    redeclare package Medium = MediumBui,
    allowFlowReversal=true,
    final m_flow_nominal=datHeaPum.mCon_flow_nominal)
    "Return heating water temperature to chiller, prior to chiller valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,0})));
  Buildings.Fluid.FixedResistances.Junction junChiWat(
    redeclare final package Medium = MediumBui,
    final dp_nominal={0,0,0},
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final tau=1,
    final m_flow_nominal=datHeaPum.mCon_flow_nominal*{1,-1,-1})
    "Junction at chilled water tank" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={176,80})));
  Buildings.Fluid.FixedResistances.Junction junHeaWat(
    redeclare final package Medium = MediumBui,
    final dp_nominal={0,0,0},
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final tau=1,
    final m_flow_nominal=datHeaPum.mCon_flow_nominal*{1,-1,-1})
    "Junction at heating water tank" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-170,90})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal conAmbEva(realTrue=0,
      realFalse=1) "Control for valve for ambient loop on evaporator side"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal conDivValHea(realTrue=1,
      realFalse=0)
    "Control for diversion valve to avoid that tank is flushed when changing to district heat exchanger"
    annotation (Placement(transformation(extent={{-90,172},{-70,192}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal conAmbCon(realTrue=0,
      realFalse=1) "Control for valve for ambient loop on condenser side"
    annotation (Placement(transformation(extent={{-90,142},{-70,162}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSerEnt(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal=colAmbWat.mDis_flow_nominal,
    final allowFlowReversal=allowFlowReversalSer)
    "Heat exchanger service line water entering temperature" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-250,-200})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSerLinLvg(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal=colAmbWat.mDis_flow_nominal,
    final allowFlowReversal=allowFlowReversalSer)
    "Heat exchanger service line water leaving temperature" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={250,-200})));
  Controls.EtsHex opeEtsHex "Output true to operate ETS heat exchanger"
    annotation (Placement(transformation(extent={{-80,-240},{-60,-220}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSpaHeaSup(
    redeclare package Medium = MediumBui,
    allowFlowReversal=true,
    final m_flow_nominal=datHeaPum.mCon_flow_nominal)
    "Supply temperature for space heating" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-188,256})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSpaCooSup(
    redeclare package Medium = MediumBui,
    allowFlowReversal=true,
    final m_flow_nominal=datHeaPum.mEva_flow_nominal)
    "Supply temperature for space cooling" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={170,190})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valTHeaSup(
    redeclare package Medium = MediumBui,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=datHeaPum.mCon_flow_nominal,
    dpValve_nominal=3000)
    "Three way valve for heating supply temperature control"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-250,220})));
  Buildings.Fluid.FixedResistances.Junction junHeaWatRet(
    redeclare final package Medium = MediumBui,
    final dp_nominal={0,0,0},
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final tau=1,
    final m_flow_nominal=datHeaPum.mCon_flow_nominal*{1,-1,-1})
    "Junction at heating water return" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-280,220})));
  Buildings.Controls.OBC.CDL.Reals.PID conPIDTHeaWatSup(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.5,
    Ti=600,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"))
    "Controller for heating water supply temperature"
    annotation (Placement(transformation(extent={{-256,264},{-236,284}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPIDTCooWatSup(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.5,
    Ti=600,
    reverseActing=false,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC")) "Controller for cooling water supply temperature"
    annotation (Placement(transformation(extent={{160,230},{180,250}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valTCooSup(
    redeclare package Medium = MediumBui,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=datHeaPum.mEva_flow_nominal,
    dpValve_nominal=3000)
    "Three way valve for cooling supply temperature control" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={220,170})));
  Buildings.Fluid.FixedResistances.Junction junCooWatRet(
    redeclare final package Medium = MediumBui,
    final dp_nominal={0,0,0},
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final tau=1,
    final m_flow_nominal=datHeaPum.mEva_flow_nominal*{1,-1,-1})
    "Junction at cooling water return" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={264,170})));

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
    annotation (Placement(transformation(extent={{220,120},{240,140}})));
  Buildings.DHC.ETS.BaseClasses.Junction splWSE(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal={
      hex.m1_flow_nominal + m1WSE_flow_nominal,
     -hex.m1_flow_nominal,
     -m1WSE_flow_nominal})
    "Flow splitter for WSE"
    annotation (Placement(transformation(extent={{-180,-266},{-160,-246}})));
  Buildings.DHC.ETS.BaseClasses.Junction mixWSE(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal={
      hex.m1_flow_nominal,
      -hex.m1_flow_nominal-m1WSE_flow_nominal,
      m1WSE_flow_nominal})
    "Flow mixer for WSE"
    annotation (Placement(transformation(extent={{180,-246},{200,-266}})));

protected
  parameter Boolean have_val1Hex=
    conCon ==Buildings.DHC.ETS.Types.ConnectionConfiguration.TwoWayValve
    "True in case of control valve on district side, false in case of a pump";
  Modelica.Blocks.Routing.RealPassThrough reaPasDhwPum if have_hotWat
    "Routing block"
    annotation (Placement(transformation(extent={{-80,230},{-60,250}})));

  Buildings.DHC.Plants.Cooling.BaseClasses.ParallelPipes parPip(
    redeclare final package Medium = MediumBui,
    m_flow_nominal=datHeaPum.mCon_flow_nominal,
    dp_nominal=0) if not have_hotWat "Parallel pipes for routing purposes"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-150,60})));

equation
  connect(totPPum.y,PPum)
    annotation (Line(points={{282,-60},{290,-60},{290,-40},{320,-40}},
                                                  color={0,0,127}));
  connect(valIsoEva.port_b,colAmbWat.port_bDisSup)
    annotation (Line(points={{50,-120},{30,-120},{30,-106},{20,-106}},color={0,127,255}));
  connect(valIsoCon.port_b,colAmbWat.port_aDisSup)
    annotation (Line(points={{-50,-120},{-30,-120},{-30,-106},{-20,-106}},color={0,127,255}));
  connect(valIsoEva.port_a,colChiWat.ports_aCon[1])
    annotation (Line(points={{70,-120},{90,-120},{90,-34},{106,-34},{106,-40},{
          108,-40}},                                         color={0,127,255}));
  connect(valIsoCon.port_a,colHeaWat.ports_aCon[1])
    annotation (Line(points={{-70,-120},{-90,-120},{-90,-34},{-108,-34},{-108,
          -40}},                                                color={0,127,255}));
  connect(bou.ports[1], colChiWat.port_aDisSup)
    annotation (Line(points={{180,-50},{140,-50}},            color={0,127,255}));
  connect(TChiWatSupSet, tanChiWat.TTanSet) annotation (Line(points={{-320,-60},
          {-240,-60},{-240,128},{208,128},{208,119},{201,119}},
                 color={0,0,127}));
  connect(colAmbWat.port_bDisRet, colHeaWat.ports_bCon[1]) annotation (Line(
        points={{-20,-100},{-150,-100},{-150,-34},{-132,-34},{-132,-40}}, color
        ={0,127,255}));
  connect(colAmbWat.port_aDisRet, colChiWat.ports_bCon[1]) annotation (Line(
        points={{20,-100},{154,-100},{154,-34},{132,-34},{132,-40}}, color={0,
          127,255}));
  connect(THeaWatSupSet, tanHeaWat.TTanSet) annotation (Line(points={{-320,-20},
          {-244,-20},{-244,119},{-201,119}},            color={0,0,127}));
  connect(senTHexBuiLvg.port_b, colAmbWat.ports_aCon[1]) annotation (Line(
        points={{-20,-200},{-20,-146},{12,-146},{12,-116}}, color={0,127,255}));
  connect(hex.port_b2, senTHexBuiLvg.port_a) annotation (Line(points={{-10,-244},
          {-20,-244},{-20,-220}}, color={0,127,255}));
  connect(hex.port_a2, senTHexBuiEnt.port_b) annotation (Line(points={{10,-244},
          {30,-244},{30,-220}}, color={0,127,255}));
  connect(senTHexBuiEnt.port_a, colAmbWat.ports_bCon[1]) annotation (Line(
        points={{30,-200},{30,-152},{-12,-152},{-12,-116}}, color={0,127,255}));
  connect(totPPum.u[1], hex.PPum) annotation (Line(points={{258,-60},{220,-60},
          {220,-250},{12,-250}}, color={0,0,127}));
  connect(dHFloHeaWat.dH_flow, dHHeaWat_flow) annotation (Line(points={{-271,
          182},{-271,206},{290,206},{290,160},{320,160}},
                                 color={0,0,127}));
  connect(dHFloChiWat.dH_flow, dHChiWat_flow) annotation (Line(points={{261,142},
          {261,148},{292,148},{292,120},{320,120}}, color={0,0,127}));
  connect(heaPum.port_bChiWat, colChiWat.ports_aCon[2]) annotation (Line(points
        ={{-10,-12},{-20,-12},{-20,-40},{108,-40}}, color={0,127,255}));
  connect(colHeaWat.ports_aCon[2], heaPum.port_bHeaWat) annotation (Line(points
        ={{-108,-40},{-108,-24},{20,-24},{20,0},{10,0}}, color={0,127,255}));
  connect(heaPum.PPum, totPPum.u[2]) annotation (Line(points={{12,-8},{30,-8},{30,
          -70},{246,-70},{246,-60},{258,-60}},    color={0,0,127}));
  connect(tanDhw.THotWatSupSet, THotWatSupSet) annotation (Line(points={{-202,
          238},{-228,238},{-228,140},{-320,140}},                       color={
          0,0,127}));
  connect(TColWat, tanDhw.TColWat) annotation (Line(points={{-320,100},{-224,
          100},{-224,234},{-202,234}},                color={0,0,127}));
  connect(QReqHotWat_flow, tanDhw.QReqHotWat_flow) annotation (Line(points={{-320,60},
          {-222,60},{-222,226},{-202,226}},                             color={
          0,0,127}));
  connect(dHFloHeaWat.port_a1, tanHeaWat.port_loaTop) annotation (Line(points={{-268,
          160},{-268,116},{-200,116}},       color={0,127,255}));
  connect(tanHeaWat.port_loaBot, dHFloHeaWat.port_b2) annotation (Line(points={{-200,
          104},{-280,104},{-280,160}},       color={0,127,255}));
  connect(reaPasDhwPum.y, totPPum.u[3]) annotation (Line(points={{-59,240},{-46,
          240},{-46,216},{246,216},{246,-60},{258,-60}}, color={0,0,127}));
  connect(tanDhw.charge,twoTanCoo.uDhw)  annotation (Line(points={{-178,222},{
          -152,222},{-152,184},{-142,184}},
                                       color={255,0,255}));
  connect(tanDhw.PEle, reaPasDhwPum.u) annotation (Line(points={{-179,226},{-152,
          226},{-152,240},{-82,240}}, color={0,0,127}));
  connect(tanHeaWat.charge, twoTanCoo.uHea) annotation (Line(points={{-178,107},
          {-160,107},{-160,175.8},{-142,175.8}},
                                             color={255,0,255}));
  connect(tanDhw.dHFlo, dHHotWat_flow) annotation (Line(points={{-179,234},{-170,
          234},{-170,300},{318,300}}, color={0,0,127}));
  connect(tanDhw.port_b, valMixHea.port_3) annotation (Line(points={{-180,230},
          {-96,230},{-96,60},{-90,60}}, color={0,127,255}));
  connect(tanDhw.port_a, junDomHotWat.port_3) annotation (Line(points={{-200,
          230},{-208,230},{-208,212},{-100,212},{-100,60},{-106,60}}, color={0,
          127,255}));
  connect(tanChiWat.charge, conDivValChi.u) annotation (Line(points={{178,107},
          {90,107},{90,80},{98,80}},                     color={255,0,255}));
  connect(valMixHea.port_2, colHeaWat.port_aDisSup) annotation (Line(points={{-80,50},
          {-80,24},{-144,24},{-144,-50},{-140,-50}},                    color={
          0,127,255}));
  connect(junDomHotWat.port_1, colHeaWat.port_bDisRet) annotation (Line(points=
          {{-116,50},{-116,26},{-156,26},{-156,-56},{-140,-56}}, color={0,127,
          255}));
  connect(parPip.port_b2, colHeaWat.port_aDisSup) annotation (Line(points={{-144,50},
          {-144,-50},{-140,-50}},          color={0,127,255}));
  connect(valDivCon.port_1, tanHeaWat.port_genBot) annotation (Line(points={{-144,
          100},{-144,104},{-180,104}}, color={0,127,255}));
  connect(conDivValChi.y, valDivEva.y)
    annotation (Line(points={{122,80},{138,80}}, color={0,0,127}));
  connect(tanChiWat.port_loaTop, dHFloChiWat.port_b2) annotation (Line(points={{200,116},
          {252,116},{252,120}},           color={0,127,255}));
  connect(tanChiWat.port_loaBot, dHFloChiWat.port_a1) annotation (Line(points={{200,104},
          {264,104},{264,120}},           color={0,127,255}));
  connect(colChiWat.port_aDisSup, valDivEva.port_2) annotation (Line(points={{140,-50},
          {150,-50},{150,70}},          color={0,127,255}));
  connect(valDivEva.port_1, tanChiWat.port_genTop) annotation (Line(points={{150,90},
          {150,116},{180,116}},          color={0,127,255}));
  connect(heaPum.port_aChiWat, senTChiWatRet.port_b)
    annotation (Line(points={{10,-12},{60,-12}}, color={0,127,255}));
  connect(senTChiWatRet.port_a, colChiWat.ports_bCon[2]) annotation (Line(
        points={{80,-12},{132,-12},{132,-40}}, color={0,127,255}));
  connect(senTHeaWatRet.port_a, colHeaWat.ports_bCon[2])
    annotation (Line(points={{-80,0},{-132,0},{-132,-40}}, color={0,127,255}));
  connect(senTHeaWatRet.port_b, heaPum.port_aHeaWat)
    annotation (Line(points={{-60,0},{-10,0}}, color={0,127,255}));
  connect(colChiWat.port_bDisRet, junChiWat.port_1) annotation (Line(points={{
          140,-56},{176,-56},{176,70}}, color={0,127,255}));
  connect(junChiWat.port_2, tanChiWat.port_genBot) annotation (Line(points={{
          176,90},{176,104},{180,104}}, color={0,127,255}));
  connect(valDivEva.port_3, junChiWat.port_3)
    annotation (Line(points={{160,80},{166,80}}, color={0,127,255}));
  connect(junDomHotWat.port_2, junHeaWat.port_1) annotation (Line(points={{-116,
          70},{-116,74},{-170,74},{-170,80}}, color={0,127,255}));
  connect(junHeaWat.port_2, tanHeaWat.port_genTop) annotation (Line(points={{
          -170,100},{-170,116},{-180,116}}, color={0,127,255}));
  connect(valDivCon.port_3, junHeaWat.port_3)
    annotation (Line(points={{-154,90},{-160,90}}, color={0,127,255}));
  connect(parPip.port_b1, junHeaWat.port_1) annotation (Line(points={{-156,70},
          {-156,72},{-170,72},{-170,80}}, color={0,127,255}));
  connect(parPip.port_a1, colHeaWat.port_bDisRet) annotation (Line(points={{
          -156,50},{-156,-56},{-140,-56}}, color={0,127,255}));
  connect(valDivCon.port_2, parPip.port_a2)
    annotation (Line(points={{-144,80},{-144,70}}, color={0,127,255}));
  connect(valMixHea.port_1, valDivCon.port_2) annotation (Line(points={{-80,70},
          {-80,76},{-144,76},{-144,80}}, color={0,127,255}));
  connect(conAmbEva.u, tanChiWat.charge) annotation (Line(points={{98,50},{90,
          50},{90,107},{178,107}},                     color={255,0,255}));
  connect(valIsoEva.y, conAmbEva.y) annotation (Line(points={{60,-108},{60,-88},
          {166,-88},{166,50},{122,50}}, color={0,0,127}));
  connect(conDivValHea.y, valDivCon.y) annotation (Line(points={{-68,182},{-54,
          182},{-54,90},{-132,90}}, color={0,0,127}));
  connect(valIsoCon.y, conAmbCon.y) annotation (Line(points={{-60,-108},{-60,
          -90},{-40,-90},{-40,152},{-68,152}}, color={0,0,127}));
  connect(twoTanCoo.y, conDivValHea.u) annotation (Line(points={{-118,180},{
          -106,180},{-106,182},{-92,182}}, color={255,0,255}));
  connect(conAmbCon.u, twoTanCoo.y) annotation (Line(points={{-92,152},{-106,
          152},{-106,180},{-118,180}}, color={255,0,255}));
  connect(twoTanCoo.yMix, valMixHea.y) annotation (Line(points={{-118,185},{
          -108,185},{-108,198},{-46,198},{-46,60},{-68,60}}, color={0,0,127}));
  connect(port_aSerAmb, senTSerEnt.port_a)
    annotation (Line(points={{-300,-200},{-260,-200}}, color={0,127,255}));
  connect(senTSerLinLvg.port_b, port_bSerAmb)
    annotation (Line(points={{260,-200},{300,-200}}, color={0,127,255}));
  connect(hex.yValIso_actual[1], conAmbCon.y) annotation (Line(points={{-12,
          -247.5},{-40,-247.5},{-40,152},{-68,152}},                     color=
          {0,0,127}));
  connect(hex.yValIso_actual[2], conAmbEva.y) annotation (Line(points={{-12,
          -248.5},{-40,-248.5},{-40,-140},{40,-140},{40,-88},{166,-88},{166,50},
          {122,50}}, color={0,0,127}));
  connect(heaPum.uHeaSpa, tanHeaWat.charge) annotation (Line(points={{-12,-2},{
          -20,-2},{-20,107},{-178,107}}, color={255,0,255}));
  connect(heaPum.uCoo, tanChiWat.charge) annotation (Line(points={{-12,-6},{-16,
          -6},{-16,107},{178,107}}, color={255,0,255}));
  connect(heaPum.THeaWatSupSet, THeaWatSupSet) annotation (Line(points={{-12,-8},
          {-30,-8},{-30,-20},{-320,-20}}, color={0,0,127}));
  connect(heaPum.TChiWatSupSet, TChiWatSupSet) annotation (Line(points={{-12,-10},
          {-26,-10},{-26,-24},{-240,-24},{-240,-60},{-312,-60},{-312,-56},{-310,
          -56},{-310,-60},{-320,-60}},       color={0,0,127}));
  connect(opeEtsHex.y, hex.u) annotation (Line(points={{-58,-230},{-50,-230},{
          -50,-252},{-12,-252}}, color={0,0,127}));
  connect(opeEtsHex.yVal1, valIsoEva.y_actual) annotation (Line(points={{-82,
          -234},{-92,-234},{-92,-180},{46,-180},{46,-113},{55,-113}}, color={0,
          0,127}));
  connect(opeEtsHex.yVal2, valIsoCon.y_actual) annotation (Line(points={{-82,
          -238.2},{-94,-238.2},{-94,-178},{-44,-178},{-44,-113},{-55,-113}},
        color={0,0,127}));
  connect(opeEtsHex.u1, tanChiWat.charge) annotation (Line(points={{-82,-222.2},
          {-84,-222.2},{-84,-184},{90,-184},{90,107},{178,107}}, color={255,0,
          255}));
  connect(twoTanCoo.y, opeEtsHex.u2) annotation (Line(points={{-118,180},{-106,
          180},{-106,132},{-28,132},{-28,-182},{-88,-182},{-88,-226},{-82,-226}},
        color={255,0,255}));
  connect(heaPum.uHeaDhw, twoTanCoo.yDhw) annotation (Line(points={{-12,-4},{
          -22,-4},{-22,130},{-110,130},{-110,175},{-118,175}}, color={255,0,255}));
  connect(dHFloHeaWat.port_b1, valTHeaSup.port_1) annotation (Line(points={{
          -268,180},{-268,192},{-250,192},{-250,210}}, color={0,127,255}));
  connect(valTHeaSup.port_2, senTSpaHeaSup.port_a) annotation (Line(points={{
          -250,230},{-250,256},{-198,256}}, color={0,127,255}));
  connect(junHeaWatRet.port_3, valTHeaSup.port_3)
    annotation (Line(points={{-270,220},{-260,220}}, color={0,127,255}));
  connect(conPIDTHeaWatSup.y, valTHeaSup.y) annotation (Line(points={{-234,274},
          {-230,274},{-230,220},{-238,220}}, color={0,0,127}));
  connect(conPIDTHeaWatSup.u_m, senTSpaHeaSup.T) annotation (Line(points={{-246,
          262},{-246,260},{-220,260},{-220,280},{-188,280},{-188,267}}, color={
          0,0,127}));
  connect(junHeaWatRet.port_2, dHFloHeaWat.port_a2)
    annotation (Line(points={{-280,210},{-280,180}}, color={0,127,255}));
  connect(dHFloChiWat.port_a2, valTCooSup.port_1) annotation (Line(points={{252,
          140},{252,150},{220,150},{220,160}}, color={0,127,255}));
  connect(valTCooSup.port_2, senTSpaCooSup.port_a) annotation (Line(points={{
          220,180},{220,190},{180,190}}, color={0,127,255}));
  connect(dHFloChiWat.port_b1, junCooWatRet.port_2)
    annotation (Line(points={{264,140},{264,160}}, color={0,127,255}));
  connect(senTSpaCooSup.T, conPIDTCooWatSup.u_m)
    annotation (Line(points={{170,201},{170,228}}, color={0,0,127}));
  connect(conPIDTCooWatSup.y, valTCooSup.y) annotation (Line(points={{182,240},
          {190,240},{190,170},{208,170}}, color={0,0,127}));
  connect(valTCooSup.port_3, junCooWatRet.port_3)
    annotation (Line(points={{230,170},{254,170}}, color={0,127,255}));
  connect(conPIDTCooWatSup.u_s, TChiWatSupSet) annotation (Line(points={{158,240},
          {66,240},{66,214},{-26,214},{-26,-24},{-240,-24},{-240,-60},{-320,-60}},
                      color={0,0,127}));
  connect(conPIDTHeaWatSup.u_s, THeaWatSupSet) annotation (Line(points={{-258,274},
          {-288,274},{-288,-20},{-300,-20},{-300,-20},{-320,-20}},      color={
          0,0,127}));
  connect(tanChiWat.charge, WSE.uCoo) annotation (Line(points={{178,107},{148,107},
          {148,130},{218,130}}, color={255,0,255}));
  connect(valIsoEva.y_actual, WSE.yValIsoEva_actual) annotation (Line(points={{55,
          -113},{46,-113},{46,126},{218,126},{218,127}}, color={0,0,127}));
  connect(senTSerEnt.port_b, splWSE.port_1) annotation (Line(points={{-240,-200},
          {-220,-200},{-220,-256},{-180,-256}}, color={0,127,255}));
  connect(splWSE.port_2, hex.port_a1)
    annotation (Line(points={{-160,-256},{-10,-256}}, color={0,127,255}));
  connect(senTSerLinLvg.port_a, mixWSE.port_2) annotation (Line(points={{240,-200},
          {230,-200},{230,-256},{200,-256}}, color={0,127,255}));
  connect(mixWSE.port_1, hex.port_b1)
    annotation (Line(points={{180,-256},{10,-256}}, color={0,127,255}));
  connect(WSE.port_b1, mixWSE.port_3) annotation (Line(points={{240,136},{248,136},
          {248,-76},{190,-76},{190,-246}}, color={0,127,255}));
  connect(WSE.port_a1, splWSE.port_3) annotation (Line(points={{220,136},{86,136},
          {86,-276},{-170,-276},{-170,-266}}, color={0,127,255}));
  connect(WSE.port_a2, dHFloChiWat.port_b2) annotation (Line(points={{240,124},{
          244,124},{244,116},{252,116},{252,120}}, color={0,127,255}));
  connect(WSE.port_b2, tanChiWat.port_loaTop) annotation (Line(points={{220,124},
          {216,124},{216,116},{200,116}}, color={0,127,255}));
  connect(junHeaWatRet.port_1, ports_aHeaWat[1]) annotation (Line(points={{-280,
          230},{-280,260},{-300,260}}, color={0,127,255}));
  connect(junCooWatRet.port_1, ports_bChiWat[1]) annotation (Line(points={{264,
          180},{264,200},{300,200}}, color={0,127,255}));
  connect(senTSpaHeaSup.port_b, ports_bHeaWat[1]) annotation (Line(points={{
          -178,256},{-36,256},{-36,260},{300,260}}, color={0,127,255}));
  connect(senTSpaCooSup.port_b, ports_aChiWat[1]) annotation (Line(points={{160,
          190},{-40,190},{-40,200},{-300,200}}, color={0,127,255}));
  connect(heaPum.PChi, PCoo) annotation (Line(points={{12,-4},{40,-4},{40,20},{280,
          20},{280,40},{320,40}}, color={0,0,127}));
  connect(zerPHea.y, PHea)
    annotation (Line(points={{282,80},{320,80}}, color={0,0,127}));
  annotation (Icon(graphics={
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

<table style=\"margin-left: auto; margin-right: auto; border-collapse: collapse; border: 1px solid black;\">
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
Resilient cooling through geothermal district energy system</a>.</br>
<i>Applied Energy</i>, 325, November, 2022.
</p>

</html>"));
end HeatRecoveryHeatPump;
