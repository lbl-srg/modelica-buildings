within Buildings.Examples.VAVReheat.BaseClasses;
model ASHRAE2006_RTU_wSupTemRes
  "Variable air volume flow system with terminal reheat and ASHRAE 2006 control sequence serving five thermal zones"
  extends Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC_RTU(
    yFanMin=0, amb(nPorts=3));

  parameter Real ratVMinVAV_flow[numZon](each final unit="1") = {max(1.5*
    VZonOA_flow_nominal[i]/mCooVAV_flow_nominal[i]/1.2, 0.15) for i in 1:numZon}
    "Minimum discharge air flow rate ratio";

  // -----G36 control parameters------------------
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard eneStd
    "Energy standard, ASHRAE 90.1 or Title 24";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard venStd
    "Ventilation standard, ASHRAE 62.1 or Title 24";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified
    "ASHRAE climate zone"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=eneStd==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Not_Specified
    "California Title 24 climate zone"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=eneStd==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24));
  parameter Boolean have_frePro=true
    "True: enable freeze protection"
    annotation (__cdl(ValueInReference=false));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat freStaPar=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Type of freeze stat"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=have_frePro));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection minOADes=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
    "Type of outdoor air section"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Economizer design"));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.BarometricRelief
    "Type of building pressure control system"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Economizer design"));
  parameter Boolean have_ahuRelFan=true
    "True: relief fan is part of AHU; False: the relief fans group that may associate multiple AHUs"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Economizer design",
                       enable=buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer ecoHigLimCon=
    Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb
    "Economizer high limit control device"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Economizer design"));
  parameter Boolean have_hotWatCoi=true
    "True: the AHU has hot water heating coil"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="System and building parameters"));
  parameter Boolean have_eleHeaCoi=false
    "True: the AHU has electric heating coil"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="System and building parameters"));
  parameter Boolean have_perZonRehBox=false
    "Check if there is any VAV-reheat boxes on perimeter zones"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="System and building parameters"));

  parameter Real VUncDesOutAir_flow(unit="m3/s")=0
    "Uncorrected design outdoor airflow rate, including diversity where applicable. It can be determined using the 62MZCalc spreadsheet from ASHRAE 62.1 User's Manual"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Minimum outdoor air setpoint",
                       enable=venStd==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));
  parameter Real VDesTotOutAir_flow(unit="m3/s")=0
    "Design total outdoor airflow rate. It can be determined using the 62MZCalc spreadsheet from ASHRAE 62.1 User's Manual"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Minimum outdoor air setpoint",
                       enable=venStd==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));
  parameter Real VAbsOutAir_flow(unit="m3/s")=0
    "Design outdoor airflow rate when all zones with CO2 sensors or occupancy sensors are unpopulated. Needed when complying with Title 24 requirements"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Minimum outdoor air setpoint",
                       enable=venStd==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24));
  parameter Real VDesOutAir_flow(unit="m3/s")=0
    "Design minimum outdoor airflow rate with the areas served by the system are occupied at their design population, including diversity where applicable. Needed when complying with Title 24 requirements"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Minimum outdoor air setpoint",
                       enable=venStd==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24));
  // ----------- parameters for fan speed control  -----------
  parameter Real pIniSet(
    unit="Pa",
    displayUnit="Pa")=120
    "Initial pressure setpoint for fan speed control"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pMinSet(
    unit="Pa",
    displayUnit="Pa")=50
    "Minimum pressure setpoint for fan speed control"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pMaxSet(
    unit="Pa",
    displayUnit="Pa")=410
    "Duct design maximum static pressure. It is the Max_DSP shown in Section 3.2.1.1 of Guideline 36"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pDelTim(unit="s")=600
    "Delay time after which trim and respond is activated"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pSamplePeriod(unit="s")=120
    "Sample period"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Fan speed",group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Integer pNumIgnReq=2
    "Number of ignored requests"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pTriAmo(
    unit="Pa",
    displayUnit="Pa")=-12.0
    "Trim amount"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pResAmo(
    unit="Pa",
    displayUnit="Pa")=15
    "Respond amount (must be opposite in to trim amount)"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pMaxRes(
    unit="Pa",
    displayUnit="Pa")=32
    "Maximum response per time interval (same sign as respond amount)"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController fanSpeCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Supply fan speed PID controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Fan speed", group="PID controller"));
  parameter Real kFanSpe(unit="1")=0.1
    "Gain of supply fan speed PID controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Fan speed", group="PID controller"));
  parameter Real TiFanSpe(unit="s")=60
    "Time constant of integrator block for supply fan speed PID controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Fan speed", group="PID controller",
      enable=fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdFanSpe(unit="s")=0.1
    "Time constant of derivative block for supply fan speed PID controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Fan speed", group="PID controller",
      enable=fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  final parameter Real supFanSpe_max=1
    "Maximum allowed supply fan speed"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Fan speed", group="PID controller"));
  parameter Real supFanSpe_min=0.1
    "Lowest allowed supply fan speed if fan is on"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Fan speed", group="PID controller"));

  // ----------- parameters for supply air temperature control  -----------

  parameter Real TSupCoo_min(
    unit="K",
    displayUnit="degC")=285.15
    "Lowest cooling supply air temperature setpoint when the outdoor air temperature is at the higher value of the reset range and above"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TSupCoo_max(
    unit="K",
    displayUnit="degC")=291.15
    "Highest cooling supply air temperature setpoint. It is typically 18 degC (65 degF)
    in mild and dry climates, 16 degC (60 degF) or lower in humid climates"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TOut_min(
    unit="K",
    displayUnit="degC")=289.15
    "Lower value of the outdoor air temperature reset range. Typically value is 16 degC (60 degF)"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TOut_max(
    unit="K",
    displayUnit="degC")=294.15
    "Higher value of the outdoor air temperature reset range. Typically value is 21 degC (70 degF)"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TSupWarUpSetBac(
    unit="K",
    displayUnit="degC")=308.15
    "Supply temperature in warm up and set back mode"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real delTimSupTem(unit="s")=600
    "Delay timer"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real samPerSupTem(unit="s")=120
    "Sample period of component"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Integer ignReqSupTem=2
    "Number of ignorable requests for TrimResponse logic"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real triAmoSupTem(
    unit="K",
    displayUnit="K")=0.1
    "Trim amount"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real resAmoSupTem(
    unit="K",
    displayUnit="K")=-0.2
    "Response amount"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real maxResSupTem(
    unit="K",
    displayUnit="K")=-0.6
    "Maximum response per time interval"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));

  Controls.FanVFD conFanSup(
    xSet_nominal(displayUnit="Pa") = 410,
    r_N_min=yFanMin)
    "Controller for fan"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

  Controls.ModeSelector modeSelector
    annotation (Placement(transformation(extent={{-200,-320},{-180,-300}})));

  Controls.ControlBus controlBus
    annotation (Placement(transformation(extent={{-250,-350},{-230,-330}}),
      iconTransformation(extent={{-162,-100},{-142,-80}})));

  Controls.Economizer conEco(
    have_reset=true,
    have_frePro=true,
    VOut_flow_min=Vot_flow_nominal)
           "Controller for economizer"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));

  Controls.RoomTemperatureSetpoint TSetRoo(
    final THeaOn=THeaOn,
    final THeaOff=THeaOff,
    final TCooOn=TCooOn,
    final TCooOff=TCooOff)
    annotation (Placement(transformation(extent={{-300,-380},{-280,-360}})));

  Controls.DuctStaticPressureSetpoint pSetDuc(
    nin=5,
    pMin=50)
    "Duct static pressure setpoint"
    annotation (Placement(transformation(extent={{160,-16},{180,4}})));

  Controls.RoomVAV conVAV[numZon](
    have_preIndDam=fill(false, numZon),
    ratVFloMin=ratVMinVAV_flow,
    ratVFloHea=mHeaVAV_flow_nominal ./ mCooVAV_flow_nominal,
    V_flow_nominal=mCooVAV_flow_nominal/1.2)
    "Controller for terminal unit"
    annotation (Placement(transformation(extent={{872,80},{892,100}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{-100,-250},{-80,-230}})));

  Controls.SupplyAirTemperature conTSup(k=0.05, Ti=800)
    "Supply air temperature and economizer controller"
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));

  Controls.SupplyAirTemperatureSetpoint TSupSet
    "Supply air temperature set point"
    annotation (Placement(transformation(extent={{-200,-230},{-180,-210}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMin TRooMin(
    final nin=numZon,
    u(each final unit="K",
      each displayUnit="degC"),
    y(final unit="K",
      displayUnit="degC"))
    "Minimum room temperature"
    annotation (Placement(transformation(extent={{-340,260},{-320,280}})));

  Utilities.Math.Average TRooAve(
    final nin=numZon,
    u(each final unit="K",
      each displayUnit="degC"),
    y(final unit="K",
      displayUnit="degC")) "Average room temperature"
    annotation (Placement(transformation(extent={{-340,230},{-320,250}})));

  Controls.FreezeStat freSta "Freeze stat for heating coil"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TRooHeaSet(
    final nout=numZon)
    "Replicate room temperature heating setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0, origin={490,64})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TRooCooSet(
    final nout=numZon)
    "Replicate room temperature cooling setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0, origin={490,30})));

  Buildings.Controls.OBC.RooftopUnits.Controller RTUCon(
    final nCoiHea=nCoiHea,
    final nCoiCoo=nCoiCoo,
    final uThrCoi1=0.4,
    final minComSpe=0.25,
    final dUHys=0.2)
    "Controller for rooftop units"
    annotation (Placement(transformation(extent={{1010,232},{1030,260}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nCoiCoo](
    each final realTrue=1,
    each final realFalse=0)
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{1090,246},{1110,266}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul[nCoiCoo]
    "Calculate compressor speed based on product of two inputs"
    annotation (Placement(transformation(extent={{1130,230},{1150,250}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[nCoiHea](
    each final uLow=0.5,
    each final uHigh=1)
    "Check if DXs are on"
    annotation (Placement(transformation(extent={{140,-160},{160,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1[nCoiCoo](each final
      uLow=0.5, each final uHigh=1)
    "Check if DXs are on"
    annotation (Placement(transformation(extent={{280,-150},{300,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timDXSta[nCoiHea](
    each final t=120)
    "Output DX heating coils proven on signal when status is enabled for two minutes"
    annotation (Placement(transformation(extent={{180,-160},{200,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timDXSta1[nCoiCoo](
    each final t=120)
    "Output DX cooling coils proven on signal when status is enabled for two minutes"
    annotation (Placement(transformation(extent={{318,-150},{338,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical Not"
    annotation (Placement(transformation(extent={{140,-110},{160,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{170,-110},{190,-90}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nCoiHea)
    "Logical Multi Or"
    annotation (Placement(transformation(extent={{102,-110},{122,-90}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nCoiCoo)
    "Logical Multi Or"
    annotation (Placement(transformation(extent={{280,-100},{300,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical Not"
    annotation (Placement(transformation(extent={{310,-100},{330,-80}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{340,-100},{360,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLimLev1(
    final k=0)
    "Demand limit level, assumes to be 0"
    annotation (Placement(transformation(extent={{910,250},{930,270}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nCoiHea](
    final k=1:nCoiHea)
    "Constant integer signal"
    annotation (Placement(transformation(extent={{910,280},{930,300}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nCoiCoo](
    final k=fill(true, nCoiCoo))
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{910,350},{930,370}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nCoiHea](
    final k=fill(true, nCoiHea))
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{910,320},{930,340}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[nCoiCoo](
    final k=1:nCoiCoo)
    "Constant integer signal"
    annotation (Placement(transformation(extent={{940,300},{960,320}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4
    annotation (Placement(transformation(extent={{100,34},{120,54}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    annotation (Placement(transformation(extent={{160,36},{180,56}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(p=1e-6)
    annotation (Placement(transformation(extent={{192,36},{212,56}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea5
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{520,-140},{540,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(k=0)
    annotation (Placement(transformation(extent={{548,16},{568,36}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2
    annotation (Placement(transformation(extent={{556,-126},{576,-106}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(each final uLow=50,
      each final uHigh=100)
                          "Check if DXs are on"
    annotation (Placement(transformation(extent={{480,-140},{500,-120}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature
    conTSupSetG36(
    final TSupCoo_min=TSupCoo_min,
    final TSupCoo_max=TSupCoo_max,
    final TOut_min=TOut_min,
    final TOut_max=TOut_max,
    final TSupWarUpSetBac=TSupWarUpSetBac,
    final delTim=delTimSupTem,
    final samplePeriod=samPerSupTem,
    final numIgnReq=ignReqSupTem,
    final triAmo=triAmoSupTem,
    final resAmo=resAmoSupTem,
    final maxRes=maxResSupTem) "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-190},{-180,-170}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Controller conVAV2
                                                                          [numZon](
    final venStd=fill(Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
        numZon),
    final have_winSen=fill(false, numZon),
    final have_occSen=fill(false, numZon),
    final have_CO2Sen=fill(false, numZon),
    final VAreBreZon_flow={ratOAFlo_A*AFlo[i] for i in 1:numZon},
    final VPopBreZon_flow={ratP_A*AFlo[i]*ratOAFlo_P for i in 1:numZon},
    final VMin_flow={max(1.5*VZonOA_flow_nominal[i], 0.15*mCooVAV_flow_nominal[
        i]/1.2) for i in 1:numZon},
    final VCooMax_flow=mCooVAV_flow_nominal/1.2,
    final VHeaMin_flow=fill(0, numZon),
    final VHeaMax_flow=mHeaVAV_flow_nominal/1.2,
    final VAreMin_flow=fill(0, numZon),
    final VOccMin_flow=fill(0, numZon),
    floHys=fill(0.01, numZon))
    "Reheat box control"
    annotation (Placement(transformation(extent={{812,14},{832,54}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TSupAHU(final nout=
        numZon) "Replicate AHU supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0, origin={782,-30})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TSupSetAHU(final nout=
       numZon) "Replicate AHU supply temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={780,-60})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant oveRid[numZon](final k=
        fill(0, numZon))
    "No override flow setpoint, no override damper position"
    annotation (Placement(transformation(extent={{766,10},{786,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant hotWatPla[numZon](final k=
       fill(true, numZon)) "Hot water plant status"
    annotation (Placement(transformation(extent={{770,-92},{790,-72}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant falSta[numZon](final k=
        fill(false, numZon)) "Hot water plant status"
    annotation (Placement(transformation(extent={{770,-120},{790,-100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(final
      nout=numZon)
    "Supply fan commanded on"
    annotation (Placement(transformation(extent={{770,-150},{790,-130}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum preRetReq(final nin=5)
    "Zone pressure reset request"
    annotation (Placement(transformation(extent={{852,32},{872,52}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum temResReq1(final nin=5)
    "Supply temperature reset request"
    annotation (Placement(transformation(extent={{852,2},{872,22}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyFan conSupFan(
    final have_perZonRehBox=have_perZonRehBox,
    final iniSet=pIniSet,
    final minSet=pMinSet,
    final maxSet=pMaxSet,
    final delTim=pDelTim,
    final samplePeriod=pSamplePeriod,
    final numIgnReq=pNumIgnReq,
    final triAmo=pTriAmo,
    final resAmo=pResAmo,
    final maxRes=pMaxRes,
    final controllerType=fanSpeCon,
    final k=kFanSpe,
    final Ti=TiFanSpe,
    final Td=TdFanSpe,
    final maxSpe=supFanSpe_max,
    final minSpe=supFanSpe_min) "Supply fan speed setpoint"
    annotation (Placement(transformation(extent={{-200,-140},{-180,-120}})));
  Controls.opeMod_ASHRAE2006toG36 opeMod_ASHRAE2006toG36_1
    annotation (Placement(transformation(extent={{-280,-120},{-260,-100}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(final nout=
        numZon)
    "All zones in same operation mode"
    annotation (Placement(transformation(extent={{770,-260},{790,-240}})));
  Modelica.Blocks.Routing.RealPassThrough TSupSet_pasThr
    annotation (Placement(transformation(extent={{-146,-246},{-126,-226}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul3
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(p=1e-6)
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Modelica.Blocks.Routing.RealPassThrough uFan_pasThr1
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Modelica.Blocks.Routing.RealPassThrough yVal_pasThr[numZon] "Reheat valve"
    annotation (Placement(transformation(extent={{912,80},{932,100}})));
  Modelica.Blocks.Routing.RealPassThrough yDam_pasThr[numZon] "VAV damper"
    annotation (Placement(transformation(extent={{914,50},{934,70}})));
equation
  connect(controlBus, modeSelector.cb) annotation (Line(
      points={{-240,-340},{-152,-340},{-152,-303.182},{-196.818,-303.182}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TRooAve.y, controlBus.TRooAve) annotation (Line(
      points={{-319,240},{-240,240},{-240,-340}},
      color={0,0,127}),          Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TRet.T, conEco.TRet) annotation (Line(
      points={{100,151},{100,174},{-94,174},{-94,153.333},{-81.3333,153.333}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TSetRoo.controlBus, controlBus) annotation (Line(
      points={{-288,-364},{-264,-364},{-264,-340},{-240,-340}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(dpDisSupFan.p_rel, conFanSup.u_m) annotation (Line(
      points={{397,4.44089e-16},{396,4.44089e-16},{396,0},{380,0},{380,24},{-26,
          24},{-26,-110},{10,-110},{10,-102}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(conEco.VOut_flow, VOut1.V_flow) annotation (Line(
      points={{-81.3333,142.667},{-90,142.667},{-90,80},{-80,80},{-80,-29}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(occSch.tNexOcc, controlBus.dTNexOcc) annotation (Line(
      points={{-299,-204},{-240,-204},{-240,-340}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(occSch.occupied, controlBus.occupied) annotation (Line(
      points={{-299,-216},{-240,-216},{-240,-340}},
      color={255,0,255},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TOut.y, controlBus.TOut) annotation (Line(points={{-279,180},{-240,180},
          {-240,-340}},                            color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(conEco.controlBus, controlBus) annotation (Line(points={{-70.6667,
          141.467},{-70.6667,120},{-240,120},{-240,-340}},
                                              color={255,204,51}, thickness=0.5));
  connect(or2.u2, modeSelector.yFan) annotation (Line(points={{-102,-248},{-170,
          -248},{-170,-305.455},{-179.091,-305.455}},
                                     color={255,0,255}));
  connect(VAVBox.y_actual, pSetDuc.u) annotation (Line(points={{762,40},{770,40},
          {770,86},{140,86},{140,-6},{158,-6}},     color={0,0,127}));
  connect(TSup.T, conTSup.TSup) annotation (Line(
      points={{570,-29},{570,-20},{592,-20},{592,-188},{-70,-188},{-70,-214},{
          -62,-214}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conTSup.yOA, conEco.uOATSup) annotation (Line(
      points={{-38,-220},{-28,-220},{-28,-180},{-152,-180},{-152,158.667},{
          -81.3333,158.667}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(or2.y, conTSup.uEna) annotation (Line(points={{-78,-240},{-70,-240},{
          -70,-226},{-62,-226}}, color={255,0,255}));
  connect(modeSelector.yEco, conEco.uEna) annotation (Line(points={{-179.091,
          -314.545},{-160,-314.545},{-160,100},{-73.3333,100},{-73.3333,137.333}},
        color={255,0,255}));
  connect(TMix.T, conEco.TMix) annotation (Line(points={{40,-29},{40,166},{-90,
          166},{-90,148},{-81.3333,148}},
                                     color={0,0,127}));
  connect(controlBus, TSupSet.controlBus) annotation (Line(
      points={{-240,-340},{-240,-228},{-190,-228}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(freSta.y, or2.u1) annotation (Line(points={{-38,-80},{-20,-80},{-20,-100},
          {-108,-100},{-108,-240},{-102,-240}}, color={255,0,255}));
  connect(TRooMin.y, controlBus.TRooMin) annotation (Line(points={{-318,270},{-240,
          270},{-240,-340}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TRooMin.u, TRoo) annotation (Line(points={{-342,270},{-360,270},{-360,
          320},{-400,320}}, color={0,0,127}));
  connect(TRooAve.u, TRoo) annotation (Line(points={{-342,240},{-360,240},{-360,
          320},{-400,320}}, color={0,0,127}));
  connect(freSta.u, TMix.T) annotation (Line(points={{-62,-80},{-72,-80},{-72,-60},
          {26,-60},{26,-20},{40,-20},{40,-29}}, color={0,0,127}));
  connect(TRoo, conVAV.TRoo) annotation (Line(
      points={{-400,320},{-360,320},{-360,304},{48,304},{48,96},{548,96},{548,
          87},{870,87}},
                     color={0,0,127}));
  connect(controlBus.TRooSetHea, TRooHeaSet.u) annotation (Line(
      points={{-240,-340},{-230,-340},{-230,64},{478,64}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.TRooSetCoo, TRooCooSet.u) annotation (Line(
      points={{-240,-340},{-220,-340},{-220,30},{478,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TRooHeaSet.y, conVAV.TRooHeaSet) annotation (Line(points={{502,64},{
          552,64},{552,98},{870,98}},
                                  color={0,0,127}));
  connect(TRooCooSet.y, conVAV.TRooCooSet) annotation (Line(points={{502,30},{
          544,30},{544,93},{870,93}},
                                  color={0,0,127}));
  connect(VAVBox.VSup_flow, conVAV.VDis_flow) annotation (Line(points={{762,56},
          {780,56},{780,90},{570,90},{570,82},{870,82}}, color={0,0,127}));
  connect(x_pTphi.X[1],RTUCon. XOut) annotation (Line(points={{-279,100},{-200,
          100},{-200,240.75},{1008,240.75}},
                                  color={0,0,127}));
  connect(RTUCon.TOut, TOut.y) annotation (Line(points={{1008,242.5},{-210,
          242.5},{-210,180},{-279,180}},
                            color={0,0,127}));
  connect(RTUCon.yDXCooCoi,booToRea. u) annotation (Line(points={{1032,256.5},{
          1060,256.5},{1060,256},{1088,256}},
                 color={255,0,255}));
  connect(booToRea.y,mul. u1) annotation (Line(points={{1112,256},{1120,256},{
          1120,246},{1128,246}},
                            color={0,0,127}));
  connect(RTUCon.yComSpeCoo,mul. u2) annotation (Line(points={{1032,248.333},{
          1080,248.333},{1080,234},{1128,234}},
                                         color={0,0,127}));
  connect(mul.y, CooCoi.speRat) annotation (Line(points={{1152,240},{1160,240},
          {1160,-200},{230,-200},{230,-48},{239,-48}}, color={0,0,127}));
  connect(RTUCon.yDXHeaCoi, HeaCoi.on) annotation (Line(points={{1032,251.95},{
          1052,251.95},{1052,252},{1070,252},{1070,-180},{90,-180},{90,-48},{99,
          -48}},                                              color={255,0,255}));
  connect(timDXSta1.passed,RTUCon. uDXCooCoi) annotation (Line(points={{340,
          -148},{950,-148},{950,258.833},{1008,258.833}},
                                                  color={255,0,255}));
  connect(timDXSta.passed,RTUCon. uDXHeaCoi) annotation (Line(points={{202,-158},
          {960,-158},{960,257.083},{1008,257.083}},
                                            color={255,0,255}));
  connect(hys1.y,timDXSta1. u) annotation (Line(points={{302,-140},{316,-140}},
          color={255,0,255}));
  connect(hys.y,timDXSta. u) annotation (Line(points={{162,-150},{178,-150}},
          color={255,0,255}));
  connect(CooCoi.P,hys1. u) annotation (Line(points={{261,-49},{261,-50},{270,
          -50},{270,-140},{278,-140}}, color={0,0,127}));
  connect(HeaCoi.P,hys. u) annotation (Line(points={{121,-49},{130,-49},{130,
          -150},{138,-150}}, color={0,0,127}));
  for i in 1:nCoiCoo loop
  connect(CooCoi[i].TOut, TOut.y) annotation (Line(points={{239,-43},{234,-43},
            {234,80},{-220,80},{-220,180},{-279,180}},
                                                    color={0,0,127}));
  end for;
  for i in 1:nCoiHea loop
  connect(HeaCoi[i].TOut, TOut.y) annotation (Line(points={{99,-36},{80,-36},{80,
          70},{-220,70},{-220,180},{-279,180}}, color={0,0,127}));
  connect(HeaCoi[i].phi, Phi.y) annotation (Line(points={{99,-32},{90,-32},{90,
            60},{-260,60},{-260,140},{-279,140}}, color={0,0,127}));
  end for;
  connect(RTUCon.uCooCoi, conTSup.yCoo) annotation (Line(points={{1008,246.117},
          {970,246.117},{970,-226},{-38,-226}},
                                           color={0,0,127}));
  connect(RTUCon.uHeaCoi, conTSup.yHea) annotation (Line(points={{1008,244.25},
          {980,244.25},{980,-214},{-38,-214}},
                                           color={0,0,127}));

  connect(not1.y,booToRea2. u)
    annotation (Line(points={{162,-100},{168,-100}},
                                                   color={255,0,255}));
  connect(mulOr.y, not1.u)
    annotation (Line(points={{124,-100},{138,-100}}, color={255,0,255}));
  connect(booToRea2.y, damPreInd.y) annotation (Line(points={{192,-100},{200,-100},
          {200,12},{110,12}}, color={0,0,127}));
  connect(RTUCon.yDXHeaCoi[1:nCoiHea], mulOr.u[1:nCoiHea]) annotation (Line(points={{1032,
          251.95},{1070,251.95},{1070,-180},{90,-180},{90,-100},{100,-100}},
                                                                      color={255,
          0,255}));
  connect(not2.y,booToRea3. u)
    annotation (Line(points={{332,-90},{338,-90}}, color={255,0,255}));
  connect(mulOr1.y, not2.u)
    annotation (Line(points={{302,-90},{308,-90}}, color={255,0,255}));
  connect(booToRea3.y, damPreInd1.y) annotation (Line(points={{362,-90},{374,-90},
          {374,12},{250,12}}, color={0,0,127}));
  connect(RTUCon.yDXCooCoi[1:nCoiCoo], mulOr1.u[1:nCoiCoo]) annotation (Line(points={{1032,
          256.5},{1060,256.5},{1060,-170},{260,-170},{260,-90},{278,-90}},color={255,0,255}));
  connect(RTUCon.TSupCoiHea, THeaCoi.T) annotation (Line(points={{1008,237.25},
          {140,237.25},{140,-29}},                      color={0,0,127}));
  connect(TCooCoi.T, RTUCon.TSupCoiCoo) annotation (Line(points={{280,-29},{284,
          -29},{284,-8},{990,-8},{990,236},{1008,236},{1008,235.5}},   color={0,
          0,127}));
  connect(RTUCon.uDemLimLev,demLimLev1. y) annotation (Line(points={{1008,
          248.333},{1008,248},{940,248},{940,260},{932,260}},
                                         color={255,127,0}));
  connect(RTUCon.uCooCoiAva,con1. y) annotation (Line(points={{1008,255.333},{
          1008,256},{1000,256},{1000,360},{932,360}},
                                               color={255,0,255}));
  connect(RTUCon.uHeaCoiAva,con2. y) annotation (Line(points={{1008,253.583},{
          1008,254},{992,254},{992,330},{932,330}},
                                          color={255,0,255}));
  connect(RTUCon.uCooCoiSeq,conInt1. y) annotation (Line(points={{1008,251.833},
          {980,251.833},{980,310},{962,310}},
                                        color={255,127,0}));
  connect(conInt.y, RTUCon.uHeaCoiSeq) annotation (Line(points={{932,290},{970,
          290},{970,250.083},{1008,250.083}},
                                        color={255,127,0}));
  connect(con.y, conFanSup.uFan) annotation (Line(points={{-88,-10},{-12,-10},{-12,
          -84},{-2,-84}},    color={255,0,255}));
  connect(booToRea4.y, mul1.u1) annotation (Line(points={{122,44},{150,44},{150,
          52},{158,52}}, color={0,0,127}));
  connect(mul1.y, addPar.u)
    annotation (Line(points={{182,46},{190,46}}, color={0,0,127}));
  connect(addPar.y, conFanSup.u) annotation (Line(points={{214,46},{250,46},{250,
          66},{-18,66},{-18,-90},{-2,-90}},
                             color={0,0,127}));
  connect(modeSelector.yFan, booToRea4.u) annotation (Line(points={{-179.091,
          -305.455},{-174,-305.455},{-174,-306},{-170,-306},{-170,44},{98,44}},
        color={255,0,255}));
  connect(con3.y, damPreInd2.y) annotation (Line(points={{570,26},{584,26},{584,
          0},{528,0},{528,12},{490,12}}, color={0,0,127}));
  connect(booToRea5.y, mul2.u2) annotation (Line(points={{542,-130},{542,-122},
          {554,-122}}, color={0,0,127}));
  connect(mul2.u1, RTUCon.yAuxHea) annotation (Line(points={{554,-110},{550,
          -110},{550,-94},{1032,-94},{1032,240.283}}, color={0,0,127}));
  connect(mul2.y, AuxHeaCoi.u) annotation (Line(points={{578,-116},{584,-116},{
          584,-56},{478,-56},{478,-34}}, color={0,0,127}));
  connect(hys2.y, booToRea5.u)
    annotation (Line(points={{502,-130},{518,-130}}, color={255,0,255}));
  connect(conEco.yRet, damRet.y) annotation (Line(points={{-58.6667,146.667},{
          -12,146.667},{-12,-10}}, color={0,0,127}));
  connect(conEco.yOA, damOut.y) annotation (Line(points={{-58.6667,152},{-40,
          152},{-40,20},{-20,20},{-20,-20},{-40,-20},{-40,-28}}, color={0,0,127}));
  connect(TRet.port_b, amb.ports[3]) annotation (Line(points={{90,140},{-58,140},
          {-58,-45},{-114,-45}}, color={0,127,255}));
  connect(TOut.y, conTSupSetG36.TOut) annotation (Line(points={{-279,180},{-240,
          180},{-240,-173},{-202,-173}}, color={0,0,127}));
  connect(hys2.y, conTSupSetG36.u1SupFan) annotation (Line(points={{502,-130},{510,
          -130},{510,-188},{324,-188},{324,-200},{-208,-200},{-208,-183},{-202,-183}},
        color={255,0,255}));
  connect(TRoo, conVAV2.TZon) annotation (Line(points={{-400,320},{134,320},{134,
          318},{800,318},{800,53},{810,53}}, color={0,0,127}));
  connect(TRooCooSet.y, conVAV2.TCooSet) annotation (Line(points={{502,30},{544,
          30},{544,-18},{800,-18},{800,51},{810,51}}, color={0,0,127}));
  connect(TRooHeaSet.y, conVAV2.THeaSet) annotation (Line(points={{502,64},{520,
          64},{520,4},{802,4},{802,50},{806,50},{806,49},{810,49}}, color={0,0,127}));
  connect(VAVBox.TSup, conVAV2.TDis) annotation (Line(points={{762,48},{780,48},
          {780,36},{810,36}}, color={0,0,127}));
  connect(VAVBox.VSup_flow, conVAV2.VDis_flow) annotation (Line(points={{762,56},
          {784,56},{784,34},{810,34}}, color={0,0,127}));
  connect(TSupAHU.y, conVAV2.TSup) annotation (Line(points={{794,-30},{806,-30},
          {806,32},{810,32}}, color={0,0,127}));
  connect(TSup.T, TSupAHU.u) annotation (Line(points={{570,-29},{570,-22},{760,-22},
          {760,-30},{770,-30}}, color={0,0,127}));
  connect(TSupSetAHU.y, conVAV2.TSupSet) annotation (Line(points={{792,-60},{808,
          -60},{808,30},{810,30}}, color={0,0,127}));
  connect(oveRid.y, conVAV2.oveFloSet) annotation (Line(points={{788,20},{796,20},
          {796,28},{810,28}}, color={255,127,0}));
  connect(oveRid.y, conVAV2.oveDamPos) annotation (Line(points={{788,20},{796,20},
          {796,26},{810,26}}, color={255,127,0}));
  connect(hotWatPla.y, conVAV2.u1HotPla) annotation (Line(points={{792,-82},{804,
          -82},{804,15.2},{810,15.2}}, color={255,0,255}));
  connect(falSta.y, conVAV2.uHeaOff) annotation (Line(points={{792,-110},{798,-110},
          {798,24},{810,24}}, color={255,0,255}));
  connect(booScaRep.y, conVAV2.u1Fan) annotation (Line(points={{792,-140},{804,-140},
          {804,17.2},{810,17.2}}, color={255,0,255}));
  connect(modeSelector.yFan, booScaRep.u) annotation (Line(points={{-179.091,
          -305.455},{740,-305.455},{740,-140},{768,-140}},
                                                 color={255,0,255}));
  connect(conVAV2.yZonTemResReq, temResReq1.u[1:5]) annotation (Line(points={{834,
          32},{840,32},{840,6.4},{850,6.4}}, color={255,127,0}));
  connect(conVAV2.yZonPreResReq, preRetReq.u[1:5]) annotation (Line(points={{834,
          30},{842,30},{842,36.4},{850,36.4}}, color={255,127,0}));
  connect(temResReq1.y, conTSupSetG36.uZonTemResReq) annotation (Line(points={{874,12},
          {884,12},{884,-274},{-210,-274},{-210,-177},{-202,-177}},
                  color={255,127,0}));
  connect(conSupFan.uZonPreResReq, preRetReq.y) annotation (Line(points={{-202,-133},
          {-206,-133},{-206,-154},{934,-154},{934,42},{874,42}}, color={255,127,
          0}));
  connect(conSupFan.dpDuc, dpDisSupFan.p_rel) annotation (Line(points={{-202,-138},
          {-214,-138},{-214,-160},{378,-160},{378,0},{397,0}}, color={0,0,127}));
  connect(controlBus.controlMode, opeMod_ASHRAE2006toG36_1.ASHRAE2006)
    annotation (Line(
      points={{-240,-340},{-300,-340},{-300,-110},{-282,-110}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(opeMod_ASHRAE2006toG36_1.G36, conSupFan.uOpeMod) annotation (Line(
        points={{-258,-110},{-216,-110},{-216,-122},{-202,-122}}, color={255,127,
          0}));
  connect(opeMod_ASHRAE2006toG36_1.G36, conTSupSetG36.uOpeMod) annotation (Line(
        points={{-258,-110},{-216,-110},{-216,-187},{-202,-187}}, color={255,127,
          0}));
  connect(opeMod_ASHRAE2006toG36_1.G36, intRep.u) annotation (Line(points={{-258,
          -110},{-216,-110},{-216,-290},{178,-290},{178,-250},{768,-250}},
        color={255,127,0}));
  connect(intRep.y, conVAV2.uOpeMod) annotation (Line(points={{792,-250},{896,-250},
          {896,72},{796,72},{796,42},{810,42}}, color={255,127,0}));
  connect(TSupSet_pasThr.y, conTSup.TSupSet) annotation (Line(points={{-125,-236},
          {-114,-236},{-114,-220},{-62,-220}}, color={0,0,127}));
  connect(TSupSet_pasThr.y, TSupSetAHU.u) annotation (Line(points={{-125,-236},{
          -114,-236},{-114,-320},{752,-320},{752,-60},{768,-60}}, color={0,0,127}));
  connect(TSupSet_pasThr.y, RTUCon.TSupCoiSet) annotation (Line(points={{-125,-236},
          {-114,-236},{-114,-320},{1000,-320},{1000,233.75},{1008,233.75}},
        color={0,0,127}));
  connect(pSetDuc.y, mul1.u2) annotation (Line(points={{181,-6},{190,-6},{190,24},
          {150,24},{150,40},{158,40}}, color={0,0,127}));
  connect(booToRea1.y, mul3.u1) annotation (Line(points={{-118,-110},{-100,-110},
          {-100,-124},{-82,-124}}, color={0,0,127}));
  connect(conSupFan.y1SupFan, booToRea1.u) annotation (Line(points={{-178,-123},
          {-164,-123},{-164,-110},{-142,-110}}, color={255,0,255}));
  connect(conSupFan.ySupFan, mul3.u2) annotation (Line(points={{-178,-130},{-140,
          -130},{-140,-136},{-82,-136}}, color={0,0,127}));
  connect(mul3.y, addPar1.u)
    annotation (Line(points={{-58,-130},{-42,-130}}, color={0,0,127}));
  connect(uFan_pasThr1.y, fanSup.y) annotation (Line(points={{61,-130},{240,
          -130},{240,-110},{382,-110},{382,-20},{396,-20},{396,-28}},
                                                                color={0,0,127}));
  connect(yVal_pasThr.y, VAVBox.yHea) annotation (Line(points={{933,90},{944,90},
          {944,120},{702,120},{702,46},{716,46}}, color={0,0,127}));
  connect(yDam_pasThr.y, VAVBox.yVAV) annotation (Line(points={{935,60},{948,60},
          {948,130},{680,130},{680,56},{716,56}}, color={0,0,127}));
  connect(conFanSup.y, uFan_pasThr1.u) annotation (Line(points={{21,-90},{30,
          -90},{30,-130},{38,-130}}, color={0,0,127}));
  connect(conVAV.yDam, yDam_pasThr.u) annotation (Line(points={{894,95},{894,
          76.5},{912,76.5},{912,60}}, color={0,0,127}));
  connect(conVAV.yVal, yVal_pasThr.u) annotation (Line(points={{894,85},{902,85},
          {902,90},{910,90}}, color={0,0,127}));
  connect(fanSup.P, hys2.u) annotation (Line(points={{407,-31},{420,-31},{420,
          -130},{478,-130}}, color={0,0,127}));
  connect(conTSupSetG36.TAirSupSet, TSupSet_pasThr.u) annotation (Line(points={
          {-178,-180},{-164,-180},{-164,-236},{-148,-236}}, color={0,0,127}));
  annotation (
  defaultComponentName="hvac",
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-400},{1420,
            660}})),
    Documentation(info="<html>
<p>
This model consist of an HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
The figure below shows the schematic diagram of an HVAC system that supplies 5 zones:
</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC\">
Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</a>
for a description of the HVAC system.
</p>
<p>
The control is an implementation of the control sequence
<i>VAV 2A2-21232</i> of the Sequences of Operation for
Common HVAC Systems (ASHRAE, 2006). In this control sequence, the
supply fan speed is modulated based on the duct static pressure.
The return fan controller tracks the supply fan air flow rate.
The duct static pressure set point is adjusted so that at least one
VAV damper is 90% open.
The heating coil valve, outside air damper, and cooling coil valve are
modulated in sequence to maintain the supply air temperature set point.
The economizer control provides the following functions:
freeze protection, minimum outside air requirement, and supply air cooling,
see
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Controls.Economizer\">
Buildings.Examples.VAVReheat.BaseClasses.Controls.Economizer</a>.
The controller of the terminal units tracks the room air temperature set point
based on a \"dual maximum with constant volume heating\" logic, see
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Controls.RoomVAV\">
Buildings.Examples.VAVReheat.BaseClasses.Controls.RoomVAV</a>.
</p>
<p>
There is also a finite state machine that transitions the mode of operation
of the HVAC system between the modes
<i>occupied</i>, <i>unoccupied off</i>, <i>unoccupied night set back</i>,
<i>unoccupied warm-up</i> and <i>unoccupied pre-cool</i>.
In the VAV model, all air flows are computed based on the
duct static pressure distribution and the performance curves of the fans.
Local loop control is implemented using proportional and proportional-integral
controllers, while the supervisory control is implemented
using a finite state machine.
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Guideline36\">
Buildings.Examples.VAVReheat.BaseClasses.Guideline36</a>.
</p>
<h4>References</h4>
<p>
ASHRAE.
<i>Sequences of Operation for Common HVAC Systems</i>.
ASHRAE, Atlanta, GA, 2006.
</p>
</html>", revisions="<html>
<ul>
<li>
December 20, 2021, by Michael Wetter:<br/>
Changed parameter declarations for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2829\">issue #2829</a>.
</li>
<li>
November 9, 2021, by Baptiste:<br/>
Vectorized the terminal boxes to be expanded to any number of zones.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2735\">issue #2735</a>.
</li>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed assignment of parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
September 3, 2021, by Michael Wetter:<br/>
Updated documentation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2600\">issue #2600</a>.
</li>
<li>
August 24, 2021, by Michael Wetter:<br/>
Changed model to include the hydraulic configurations of the cooling coil,
heating coil and VAV terminal box.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2594\">issue #2594</a>.
</li>
<li>
May 6, 2021, by David Blum:<br/>
Change to <code>from_dp=false</code> for exhaust air damper.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2485\">issue #2485</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class and introduced floor areas in base class
to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 16, 2021, by Michael Wetter:<br/>
Refactored model to implement the economizer dampers directly in
<code>Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</code> rather than through the
model of a mixing box. Since the version of the Guideline 36 model has no exhaust air damper,
this leads to simpler equations.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2454\">issue #2454</a>.
</li>
<li>
March 15, 2021, by David Blum:<br/>
Update documentation graphic to include relief damper.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2399\">#2399</a>.
</li>
<li>
October 27, 2020, by Antoine Gautier:<br/>
Refactored the supply air temperature control sequence.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2024\">#2024</a>.
</li>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Changed design and control parameters for outdoor air flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>.
</li>
<li>
April 20, 2020, by Jianjun Hu:<br/>
Exported actual VAV damper position as the measured input data for
defining duct static pressure setpoint.<br/>
This is
for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>.
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&deg;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{240,172},{220,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{240,172},{220,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,100},{-158,60}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,96},{-2,82}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,-12},{-158,-52}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-78,60},{-118,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-46,96},{-12,62}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,86},{-22,72}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{42,100},{56,60}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{104,100},{118,60}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-138,100},{-124,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-138,-12},{-124,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,20},{7,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={-98,23},
          rotation=90),
        Line(points={{106,60},{106,-6}}, color={0,0,255}),
        Line(points={{116,60},{116,-6}}, color={0,0,255}),
        Line(points={{106,34},{116,34}},   color={0,0,255}),
        Polygon(
          points={{-5,-4},{3,-4},{-1,4},{-5,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={107,16}),
        Ellipse(
          extent={{100,54},{112,42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{106,54},{100,48},{112,48},{106,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-5,4},{3,4},{-1,-4},{-5,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={107,24}),
        Line(points={{44,60},{44,-6}},   color={0,0,255}),
        Line(points={{54,60},{54,-6}},   color={0,0,255}),
        Line(points={{44,34},{54,34}},     color={0,0,255}),
        Polygon(
          points={{-5,-4},{3,-4},{-1,4},{-5,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={45,16}),
        Ellipse(
          extent={{38,54},{50,42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{44,54},{38,48},{50,48},{44,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-5,4},{3,4},{-1,-4},{-5,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={45,24}),
        Rectangle(
          extent={{320,172},{300,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{280,172},{260,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,172},{380,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{360,172},{340,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{240,20},{220,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{280,20},{260,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{320,20},{300,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{360,20},{340,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,20},{380,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{380,136},{400,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={390,153},
          rotation=90),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={350,153},
          rotation=90),
        Rectangle(
          extent={{340,136},{360,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{300,136},{320,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={310,153},
          rotation=90),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={270,153},
          rotation=90),
        Rectangle(
          extent={{260,136},{280,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{220,136},{240,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={230,153},
          rotation=90)}));
end ASHRAE2006_RTU_wSupTemRes;
