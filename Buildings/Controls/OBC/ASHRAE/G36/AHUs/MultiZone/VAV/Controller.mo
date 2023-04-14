within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV;
block Controller "Multizone VAV air handling unit controller"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard eneStd
    "Energy standard, ASHRAE 90.1 or Title 24";
  parameter Types.VentilationStandard venStd
    "Ventilation standard, ASHRAE 62.1 or Title 24";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified
    "ASHRAE climate zone"
    annotation (Dialog(enable=eneStd==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Not_Specified
    "California Title 24 climate zone"
    annotation (Dialog(enable=eneStd==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24));
  parameter Boolean have_frePro=true
    "True: enable freeze protection";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat freSta=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Type of freeze stat"
    annotation (Dialog(enable=have_frePro));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection minOADes=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
    "Type of outdoor air section"
    annotation (Dialog(group="Economizer design"));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.BarometricRelief
    "Type of building pressure control system"
    annotation (Dialog(group="Economizer design"));
  parameter Boolean have_ahuRelFan=true
    "True: relief fan is part of AHU; False: the relief fans group that may associate multiple AHUs"
    annotation (Dialog(group="Economizer design",
                       enable=buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer ecoHigLimCon=
    Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb
    "Economizer high limit control device"
    annotation (Dialog(group="Economizer design"));
  parameter Boolean have_hotWatCoi=true
    "True: the AHU has hot water heating coil"
    annotation (Dialog(group="System and building parameters"));
  parameter Boolean have_eleHeaCoi=false
    "True: the AHU has electric heating coil"
    annotation (Dialog(group="System and building parameters"));
  parameter Boolean have_perZonRehBox=false
    "Check if there is any VAV-reheat boxes on perimeter zones"
    annotation (Dialog(group="System and building parameters"));

  parameter Real VUncDesOutAir_flow(unit="m3/s")=0
    "Uncorrected design outdoor airflow rate, including diversity where applicable. It can be determined using the 62MZCalc spreadsheet from ASHRAE 62.1 User's Manual"
    annotation (Dialog(group="Minimum outdoor air setpoint",
                       enable=venStd==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));
  parameter Real VDesTotOutAir_flow(unit="m3/s")=0
    "Design total outdoor airflow rate. It can be determined using the 62MZCalc spreadsheet from ASHRAE 62.1 User's Manual"
    annotation (Dialog(group="Minimum outdoor air setpoint",
                       enable=venStd==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));
  parameter Real VAbsOutAir_flow(unit="m3/s")=0
    "Design outdoor airflow rate when all zones with CO2 sensors or occupancy sensors are unpopulated. Needed when complying with Title 24 requirements"
    annotation (Dialog(group="Minimum outdoor air setpoint",
                       enable=venStd==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24));
  parameter Real VDesOutAir_flow(unit="m3/s")=0
    "Design minimum outdoor airflow rate with the areas served by the system are occupied at their design population, including diversity where applicable. Needed when complying with Title 24 requirements"
    annotation (Dialog(group="Minimum outdoor air setpoint",
                       enable=venStd==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24));
  // ----------- parameters for fan speed control  -----------
  parameter Real pIniSet(
    unit="Pa",
    displayUnit="Pa")=120
    "Initial pressure setpoint for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pMinSet(
    unit="Pa",
    displayUnit="Pa")=25
    "Minimum pressure setpoint for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pMaxSet(
    unit="Pa",
    displayUnit="Pa")=1000
    "Duct design maximum static pressure. It is the Max_DSP shown in Section 3.2.1.1 of Guideline 36"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pDelTim(unit="s")=600
    "Delay time after which trim and respond is activated"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pSamplePeriod(unit="s")=120
    "Sample period"
    annotation (Dialog(tab="Fan speed",group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Integer pNumIgnReq=2
    "Number of ignored requests"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pTriAmo(
    unit="Pa",
    displayUnit="Pa")=-12.0
    "Trim amount"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pResAmo(
    unit="Pa",
    displayUnit="Pa")=15
    "Respond amount (must be opposite in to trim amount)"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pMaxRes(
    unit="Pa",
    displayUnit="Pa")=32
    "Maximum response per time interval (same sign as respond amount)"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController fanSpeCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Supply fan speed PID controller"
    annotation (Dialog(tab="Fan speed", group="PID controller"));
  parameter Real kFanSpe(unit="1")=0.1
    "Gain of supply fan speed PID controller"
    annotation (Dialog(tab="Fan speed", group="PID controller"));
  parameter Real TiFanSpe(unit="s")=60
    "Time constant of integrator block for supply fan speed PID controller"
    annotation (Dialog(tab="Fan speed", group="PID controller",
      enable=fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdFanSpe(unit="s")=0.1
    "Time constant of derivative block for supply fan speed PID controller"
    annotation (Dialog(tab="Fan speed", group="PID controller",
      enable=fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  final parameter Real supFanSpe_max=1
    "Maximum allowed supply fan speed"
    annotation (Dialog(tab="Fan speed", group="PID controller"));
  parameter Real supFanSpe_min=0.1
    "Lowest allowed supply fan speed if fan is on"
    annotation (Dialog(tab="Fan speed", group="PID controller"));

  // ----------- parameters for supply air temperature control  -----------
  parameter Real TSupCoo_min(
    unit="K",
    displayUnit="degC")=285.15
    "Lowest cooling supply air temperature setpoint when the outdoor air temperature is at the higher value of the reset range and above"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TSupCoo_max(
    unit="K",
    displayUnit="degC")=291.15
    "Highest cooling supply air temperature setpoint. It is typically 18 degC (65 degF)
    in mild and dry climates, 16 degC (60 degF) or lower in humid climates"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TOut_min(
    unit="K",
    displayUnit="degC")=289.15
    "Lower value of the outdoor air temperature reset range. Typically value is 16 degC (60 degF)"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TOut_max(
    unit="K",
    displayUnit="degC")=294.15
    "Higher value of the outdoor air temperature reset range. Typically value is 21 degC (70 degF)"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TSupWarUpSetBac(
    unit="K",
    displayUnit="degC")=308.15
    "Supply temperature in warm up and set back mode"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real delTimSupTem(unit="s")=600
    "Delay timer"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real samPerSupTem(unit="s")=120
    "Sample period of component"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Integer ignReqSupTem=2
    "Number of ignorable requests for TrimResponse logic"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real triAmoSupTem(
    unit="K",
    displayUnit="K")=0.1
    "Trim amount"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real resAmoSupTem(
    unit="K",
    displayUnit="K")=-0.2
    "Response amount"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real maxResSupTem(
    unit="K",
    displayUnit="K")=-0.6
    "Maximum response per time interval"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));

  // ----------- parameters for heating and cooling coil control  -----------
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController valCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for coil valves control"
    annotation (Dialog(tab="Coils", group="Valves PID controller"));
  parameter Real kVal(unit="1")=0.05
    "Gain of controller for valve control"
    annotation (Dialog(tab="Coils", group="Valves PID controller"));
  parameter Real TiVal(unit="s")=600
    "Time constant of integrator block for valve control"
    annotation (Dialog(tab="Coils", group="Valves PID controller",
      enable=valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdVal(unit="s")=0.1
    "Time constant of derivative block for valve control"
    annotation (Dialog(tab="Coils", group="Valves PID controller",
      enable=valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real uHeaCoi_max=-0.25
    "Upper limit of controller signal when heating coil is off. Require -1 < uHea_max < uCoo_min < 1."
    annotation (Dialog(tab="Coils", group="Limits"));
  parameter Real uCooCoi_min=0.25
    "Lower limit of controller signal when cooling coil is off. Require -1 < uHea_max < uCoo_min < 1."
    annotation (Dialog(tab="Coils", group="Limits"));

  // ----------- parameters for economizer control  -----------
  // Limits
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController minOAConTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of minimum outdoor air controller"
    annotation (Dialog(tab="Economizer", group="Limits, separated with AFMS",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
           or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper));
  parameter Real kMinOA(unit="1")=0.03
    "Gain of controller"
    annotation (Dialog(tab="Economizer", group="Limits, separated with AFMS",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
           or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper));
  parameter Real TiMinOA(unit="s")=120
    "Time constant of integrator block"
    annotation (Dialog(tab="Economizer", group="Limits, separated with AFMS",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
           or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper)
           and (minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdMinOA(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Economizer", group="Limits, separated with AFMS",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
           or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper)
           and (minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Boolean have_CO2Sen=false
    "True: some zones have CO2 sensor"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
           and venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24)));
  parameter Real dpAbsMinOutDam=5
    "Absolute minimum pressure difference across the minimum outdoor air damper. It provides the absolute minimum outdoor airflow"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=(venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
           and minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure)));
  parameter Real dpDesMinOutDam(unit="Pa")=20
    "Design minimum pressure difference across the minimum outdoor air damper. It provides the design minimum outdoor airflow"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController dpConTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of differential pressure setpoint controller"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure));
  parameter Real kDp(unit="1")=1
    "Gain of controller"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure));
  parameter Real TiDp(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure)
           and (dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDp(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure)
           and (dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real uRetDam_min(unit="1")=0.5
    "Loop signal value to start decreasing the maximum return air damper position"
    annotation (Dialog(tab="Economizer", group="Limits, Common",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper));
  // Enable
  parameter Real delTOutHis(
    unit="K",
    displayUnit="K")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation (Dialog(tab="Economizer", group="Enable"));
  parameter Real delEntHis(unit="J/kg")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation (Dialog(tab="Economizer", group="Enable",
                       enable=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
                           or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb));
  parameter Real retDamFulOpeTim(unit="s")=180
    "Time period to keep return air damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations"
    annotation (Dialog(tab="Economizer", group="Enable"));
  parameter Real disDel(unit="s")=15
    "Short time delay before closing the outdoor air damper at disable to avoid pressure fluctuations"
    annotation (Dialog(tab="Economizer", group="Enable"));
  // Commissioning
  parameter Real retDamPhy_max(unit="1")=1.0
    "Physically fixed maximum position of the return air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits"));
  parameter Real retDamPhy_min(unit="1")=0.0
    "Physically fixed minimum position of the return air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits"));
  parameter Real outDamPhy_max(unit="1")=1.0
    "Physically fixed maximum position of the outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits"));
  parameter Real outDamPhy_min(unit="1")=0.0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits"));
  parameter Real minOutDamPhy_max(unit="1")=1.0
    "Physically fixed maximum position of the minimum outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow));
  parameter Real minOutDamPhy_min(unit="1")=0.0
    "Physically fixed minimum position of the minimum outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow));
  parameter Real uHeaMax(unit="1")=-0.25
    "Lower limit of controller input when outdoor damper opens (see diagram)"
    annotation (Dialog(tab="Economizer", group="Commissioning, modulation"));
  parameter Real uCooMin(unit="1")=+0.25
    "Upper limit of controller input when return damper is closed (see diagram)"
    annotation (Dialog(tab="Economizer", group="Commissioning, modulation"));

  // ----------- parameters for freeze protection -----------
  parameter Integer minHotWatReq=2
    "Minimum heating hot-water plant request to active the heating plant"
    annotation (Dialog(tab="Freeze protection", enable=have_frePro));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController freProHeaCoiCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Freeze protection heating coil controller"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller",
                       enable=have_frePro));
  parameter Real kFrePro(unit="1")=0.05
    "Gain of coil controller"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller",
                       enable=have_frePro));
  parameter Real TiFrePro(unit="s")=120
    "Time constant of integrator block"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller",
      enable=have_frePro and
             (freProHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
              or freProHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdFrePro(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller",
      enable=have_frePro and
             (freProHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
              or freProHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real yMaxFrePro=1
    "Upper limit of output"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller",
                       enable=have_frePro));
  parameter Real yMinFrePro=0
    "Lower limit of output"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller",
                       enable=have_frePro));

  // ----------- Building pressure control parameters -----------
  parameter Real dpBuiSet(
    unit="Pa",
    displayUnit="Pa")=12
    "Building static pressure difference relative to ambient (positive to pressurize the building)"
    annotation (Dialog(tab="Pressure control",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
             or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
             or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));
  parameter Real kRelDam(unit="1")=0.5
    "Gain, applied to building pressure control error normalized with dpBuiSet"
    annotation (Dialog(tab="Pressure control", group="Relief damper",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper));
//   parameter Real kRelFan(unit="1")=1
//     "Gain, normalized using dpBuiSet"
//     annotation (Dialog(tab="Pressure control", group="Relief fans",
//       enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));
//   parameter Real minSpeRelFan(unit="1")=0.1
//     "Minimum relief fan speed"
//     annotation (Dialog(tab="Pressure control", group="Relief fans",
//       enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));
  parameter Real difFloSet(unit="m3/s")=0.1
    "Airflow differential between supply air and return air fans required to maintain building pressure at desired pressure"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController retFanCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for return fan"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
             or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));
  parameter Real kRetFan(unit="1")=1
    "Gain, normalized using dpBuiSet"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
             or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));
  parameter Real TiRetFan(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
              or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
         and (retFanCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
              or retFanCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdRetFan(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
              or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
         and (retFanCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
              or retFanCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  final parameter Real retFanSpe_max=1
    "Maximum return fan speed"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
              or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)));
  parameter Real retFanSpe_min=0.1
    "Minimum return fan speed"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
              or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)));

  parameter Real p_rel_RetFan_min(
    unit="Pa",
    displayUnit="Pa")=2.4
    "Minimum return fan discharge static pressure difference setpoint"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));
  parameter Real p_rel_RetFan_max(
    unit="Pa",
    displayUnit="Pa")=40
    "Maximum return fan discharge static pressure difference setpoint"
    annotation (Dialog(tab="Pressure control", group="Return fan",
        enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));
  parameter Real relFanSpe_min(
    final min=0,
    final max=1)= 0.1
    "Relief fan minimum speed"
    annotation (Dialog(tab="Pressure control", group="Relief fan",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan and have_ahuRelFan));
  parameter Real kRelFan(unit="1")=1
    "Gain of relief fan controller, normalized using dpBuiSet"
    annotation (Dialog(tab="Pressure control", group="Relief fan",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan and have_ahuRelFan));

  // ----------- Advanced parameters -----------
  parameter Real Thys=0.25 "Hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));
  parameter Real posHys=0.01
    "Hysteresis for checking valve position difference"
    annotation (Dialog(tab="Advanced"));
  parameter Real hys = 0.005
    "Hysteresis for checking the relief fan controller output value"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uAhuOpeMod
    "Operation mode for AHU operation"
    annotation (Placement(transformation(extent={{-400,540},{-360,580}}),
        iconTransformation(extent={{-240,410},{-200,450}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{-400,500},{-360,540}}),
        iconTransformation(extent={{-240,390},{-200,430}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpDuc(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-400,460},{-360,500}}),
        iconTransformation(extent={{-240,360},{-200,400}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-400,430},{-360,470}}),
        iconTransformation(extent={{-240,340},{-200,380}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{-400,400},{-360,440}}),
        iconTransformation(extent={{-240,310},{-200,350}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-400,360},{-360,400}}),
        iconTransformation(extent={{-240,290},{-200,330}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-400,320},{-360,360}}),
        iconTransformation(extent={{-240,260},{-200,300}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumAdjPopBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Sum of the adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{-400,256},{-360,296}}),
        iconTransformation(extent={{-240,230},{-200,270}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumAdjAreBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Sum of the adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{-400,226},{-360,266}}),
        iconTransformation(extent={{-240,210},{-200,250}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumZonPri_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Sum of the zone primary airflow rates for all zones in all zone groups that are in occupied mode"
    annotation (Placement(transformation(extent={{-400,196},{-360,236}}),
        iconTransformation(extent={{-240,180},{-200,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutAirFra_max(
    final min=0,
    final unit="1")
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Maximum zone outdoor air fraction, equals to the maximum of primary outdoor air fraction of all zones"
    annotation (Placement(transformation(extent={{-400,166},{-360,206}}),
        iconTransformation(extent={{-240,150},{-200,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumZonAbsMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Sum of the zone absolute minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-400,138},{-360,178}}),
        iconTransformation(extent={{-240,110},{-200,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumZonDesMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Sum of the zone design minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-400,106},{-360,146}}),
        iconTransformation(extent={{-240,90},{-200,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VAirOut_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    if (minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
     or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper)
    "Measured outdoor air volumetric flow rate"
    annotation (Placement(transformation(extent={{-400,76},{-360,116}}),
        iconTransformation(extent={{-240,50},{-200,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCO2Loo_max(
    final unit="1")
    if (have_CO2Sen and venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24)
    "Maximum zone CO2 control loop output"
    annotation (Placement(transformation(extent={{-400,-40},{-360,0}}),
        iconTransformation(extent={{-240,-40},{-200,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpMinOutDam(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
    "Measured pressure difference across the minimum outdoor air damper"
    annotation (Placement(transformation(extent={{-400,-70},{-360,-30}}),
        iconTransformation(extent={{-240,-70},{-200,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb
    "Used only for fixed plus differential dry bulb temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-400,-100},{-360,-60}}),
        iconTransformation(extent={{-240,-100},{-200,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hAirOut(
    final unit="J/kg",
    final quantity="SpecificEnergy")
    if (ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
     or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb)
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-400,-130},{-360,-90}}),
        iconTransformation(extent={{-240,-120},{-200,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hAirRet(
    final unit="J/kg",
    final quantity="SpecificEnergy")
    if (eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
     and ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb)
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-400,-160},{-360,-120}}),
        iconTransformation(extent={{-240,-140},{-200,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1FreSta if freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS
    "Freeze protection stat signal. The stat is normally close (the input is normally true), when enabling freeze protection, the input becomes false"
    annotation (Placement(transformation(extent={{-400,-190},{-360,-150}}),
        iconTransformation(extent={{-240,-180},{-200,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SofSwiRes
    if (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
     or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
    "Freeze protection reset signal from software switch"
    annotation (Placement(transformation(extent={{-400,-230},{-360,-190}}),
        iconTransformation(extent={{-240,-220},{-200,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1RelFan if buiPreCon ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
     and not have_ahuRelFan "Relief fan status"
    annotation (Placement(transformation(extent={{-400,-260},{-360,-220}}),
        iconTransformation(extent={{-240,-250},{-200,-210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirMix(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_hotWatCoi
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-400,-330},{-360,-290}}),
        iconTransformation(extent={{-240,-300},{-200,-260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpBui(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Measured building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-400,-364},{-360,-324}}),
        iconTransformation(extent={{-240,-330},{-200,-290}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VAirSup_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
    "Measured AHU supply airflow rate"
    annotation (Placement(transformation(extent={{-400,-400},{-360,-360}}),
        iconTransformation(extent={{-240,-360},{-200,-320}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VAirRet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
    "Measured AHU return airflow rate"
    annotation (Placement(transformation(extent={{-400,-460},{-360,-420}}),
        iconTransformation(extent={{-240,-380},{-200,-340}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi_actual(
    final min=0,
    final max=1,
    final unit="1")
    "Actual cooling coil valve position"
    annotation (Placement(transformation(extent={{-400,-530},{-360,-490}}),
        iconTransformation(extent={{-240,-430},{-200,-390}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi_actual(
    final min=0,
    final max=1,
    final unit="1") if have_hotWatCoi
    "Actual heating coil valve position"
    annotation (Placement(transformation(extent={{-400,-580},{-360,-540}}),
        iconTransformation(extent={{-240,-450},{-200,-410}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "AHU supply air temperature setpoint"
    annotation (Placement(transformation(extent={{360,480},{400,520}}),
        iconTransformation(extent={{200,320},{240,360}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VEffAirOut_flow_min(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Effective minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{360,230},{400,270}}),
        iconTransformation(extent={{200,210},{240,250}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinOutDam(
    final min=0,
    final max=1,
    final unit="1")
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
    "Minimum outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{360,140},{400,180}}),
        iconTransformation(extent={{200,170},{240,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1MinOutDam
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
    "Minimum outdoor air damper command on"
    annotation (Placement(transformation(extent={{360,110},{400,150}}),
        iconTransformation(extent={{200,140},{240,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDam(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper commanded position"
    annotation (Placement(transformation(extent={{360,70},{400,110}}),
        iconTransformation(extent={{200,110},{240,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelDam(
    final min=0,
    final max=1,
    final unit="1") if not ((buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
     and not have_ahuRelFan) or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.BarometricRelief)
    "Relief air damper commanded position"
    annotation (Placement(transformation(extent={{360,40},{400,80}}),
        iconTransformation(extent={{200,80},{240,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam(
    final min=0,
    final max=1,
    final unit="1") "Economizer outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{360,10},{400,50}}),
        iconTransformation(extent={{200,50},{240,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1EneCHWPum
 if have_frePro
    "Commanded on to energize chilled water pump"
    annotation (Placement(transformation(extent={{360,-30},{400,10}}),
        iconTransformation(extent={{200,20},{240,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1SupFan
    "Supply fan command on"
    annotation (Placement(transformation(extent={{360,-60},{400,-20}}),
        iconTransformation(extent={{200,-20},{240,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFan(
    final min=0,
    final max=1,
    final unit="1") "Air handler supply fan commanded speed"
    annotation (Placement(transformation(extent={{360,-90},{400,-50}}),
        iconTransformation(extent={{200,-42},{240,-2}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RetFan
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded on"
    annotation (Placement(transformation(extent={{360,-120},{400,-80}}),
        iconTransformation(extent={{200,-70},{240,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFan(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded speed"
    annotation (Placement(transformation(extent={{360,-152},{400,-112}}),
        iconTransformation(extent={{200,-90},{240,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RelFan
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded on"
    annotation (Placement(transformation(extent={{360,-180},{400,-140}}),
        iconTransformation(extent={{200,-120},{240,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFan(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded speed"
    annotation (Placement(transformation(extent={{360,-210},{400,-170}}),
        iconTransformation(extent={{200,-140},{240,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil valve commanded position"
    annotation (Placement(transformation(extent={{360,-250},{400,-210}}),
        iconTransformation(extent={{200,-170},{240,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1")
    if have_hotWatCoi "Heating coil valve commanded position"
    annotation (Placement(transformation(extent={{360,-280},{400,-240}}),
        iconTransformation(extent={{200,-200},{240,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAla if have_frePro
    "Alarm level"
    annotation (Placement(transformation(extent={{360,-310},{400,-270}}),
        iconTransformation(extent={{200,-220},{240,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDpBui(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
     and have_ahuRelFan) or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{360,-400},{400,-360}}),
        iconTransformation(extent={{200,-250},{240,-210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpDisSet(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp
    "Return fan discharge static pressure setpoint"
    annotation (Placement(transformation(extent={{360,-440},{400,-400}}),
        iconTransformation(extent={{200,-290},{240,-250}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiWatResReq
    "Chilled water reset request"
    annotation (Placement(transformation(extent={{360,-480},{400,-440}}),
        iconTransformation(extent={{200,-330},{240,-290}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiPlaReq
    "Chiller plant request"
    annotation (Placement(transformation(extent={{360,-510},{400,-470}}),
        iconTransformation(extent={{200,-370},{240,-330}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatResReq if have_hotWatCoi
    "Hot water reset request"
    annotation (Placement(transformation(extent={{360,-560},{400,-520}}),
        iconTransformation(extent={{200,-410},{240,-370}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq if have_hotWatCoi
    "Hot water plant request"
    annotation (Placement(transformation(extent={{360,-590},{400,-550}}),
        iconTransformation(extent={{200,-450},{240,-410}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold freProMod
    "Check if it is in freeze protection mode"
    annotation (Placement(transformation(extent={{180,-570},{200,-550}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi if have_hotWatCoi
    "Hot water plant request"
    annotation (Placement(transformation(extent={{300,-580},{320,-560}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.FreezeProtection frePro(
    final have_frePro=have_frePro,
    final buiPreCon=buiPreCon,
    final minOADes=minOADes,
    final freSta=freSta,
    final have_hotWatCoi=have_hotWatCoi,
    final minHotWatReq=minHotWatReq,
    final heaCoiCon=freProHeaCoiCon,
    final k=kFrePro,
    final Ti=TiFrePro,
    final Td=TdFrePro,
    final yMax=yMaxFrePro,
    final yMin=yMinFrePro,
    final Thys=Thys) "Freeze protection"
    annotation (Placement(transformation(extent={{180,-220},{200,-180}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests plaReq(
    final have_hotWatCoi=have_hotWatCoi,
    final Thys=Thys,
    final posHys=posHys) "Plant requests"
    annotation (Placement(transformation(extent={{-20,-540},{0,-520}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller ecoCon(
    final minOADes=minOADes,
    final buiPreCon=buiPreCon,
    final eneStd=eneStd,
    final ecoHigLimCon=ecoHigLimCon,
    final ashCliZon=ashCliZon,
    final tit24CliZon=tit24CliZon,
    final minSpe=supFanSpe_min,
    final minOAConTyp=minOAConTyp,
    final kMinOA=kMinOA,
    final TiMinOA=TiMinOA,
    final TdMinOA=TdMinOA,
    final venStd=venStd,
    final dpDesMinOutDam=dpDesMinOutDam,
    final dpConTyp=dpConTyp,
    final kDp=kDp,
    final TiDp=TiDp,
    final TdDp=TdDp,
    final uRetDam_min=uRetDam_min,
    final retDamPhy_max=retDamPhy_max,
    final retDamPhy_min=retDamPhy_min,
    final outDamPhy_max=outDamPhy_max,
    final outDamPhy_min=outDamPhy_min,
    final minOutDamPhy_max=minOutDamPhy_max,
    final minOutDamPhy_min=minOutDamPhy_min,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamFulOpeTim=retDamFulOpeTim,
    final disDel=disDel,
    final uHeaMax=uHeaMax,
    final uCooMin=uCooMin,
    final uOutDamMax=(uHeaMax + uCooMin)/2,
    final uRetDamMin=(uHeaMax + uCooMin)/2,
    final have_CO2Sen=have_CO2Sen,
    final dpAbsMinOutDam=dpAbsMinOutDam) "Economizer controller"
    annotation (Placement(transformation(extent={{62,-60},{82,-20}})));
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
    annotation (Placement(transformation(extent={{-220,500},{-200,520}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplySignals supSig(
    final have_heaCoi=have_hotWatCoi or have_eleHeaCoi,
    final controllerType=valCon,
    final kTSup=kVal,
    final TiTSup=TiVal,
    final TdTSup=TdVal,
    final uHea_max=uHeaCoi_max,
    final uCoo_min=uCooCoi_min) "Heating and cooling valve position"
    annotation (Placement(transformation(extent={{-80,400},{-60,420}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature conTSupSet(
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
    annotation (Placement(transformation(extent={{-160,440},{-140,460}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.AHU ashOutAirSet(
    final minOADes=minOADes,
    final VUncDesOutAir_flow=VUncDesOutAir_flow,
    final VDesTotOutAir_flow=VDesTotOutAir_flow)
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Minimum outdoor airflow setpoint, when complying with ASHRAE 62.1 requirements"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefDamper relDam(
    final dpBuiSet=dpBuiSet,
    final k=kRelDam)
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
    "Relief damper control for AHUs using actuated dampers without fan"
    annotation (Placement(transformation(extent={{-160,-360},{-140,-340}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanDirectPressure retFanDpCon(
    final dpBuiSet=dpBuiSet,
    final p_rel_RetFan_min=p_rel_RetFan_min,
    final p_rel_RetFan_max=p_rel_RetFan_max,
    final disSpe_min=retFanSpe_min,
    final disSpe_max=retFanSpe_max,
    final conTyp=retFanCon,
    final k=kRetFan,
    final Ti=TiRetFan,
    final Td=TdRetFan)
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp
    "Return fan control with direct building pressure control, using the minimum outdoor air damper"
    annotation (Placement(transformation(extent={{-160,-480},{-140,-460}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanAirflowTracking retFanAirTra(
    final difFloSet=difFloSet,
    final conTyp=retFanCon,
    final k=kRetFan,
    final Ti=TiRetFan,
    final Td=TdRetFan,
    final maxSpe=retFanSpe_max,
    final minSpe=retFanSpe_min)
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
    "Return fan control for AHUs using return fan with airflow tracking"
    annotation (Placement(transformation(extent={{-160,-410},{-140,-390}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24.AHU tit24OutAirSet(
    final minOADes=minOADes,
    final have_CO2Sen=have_CO2Sen,
    final VAbsOutAir_flow=VAbsOutAir_flow,
    final VDesOutAir_flow=VDesOutAir_flow)
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Minimum outdoor airflow setpoint, when complying with Title 24 requirements"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefFan relFanCon(
    final relFanSpe_min=relFanSpe_min,
    final dpBuiSet=dpBuiSet,
    final k=kRelFan,
    final hys=hys)
    if have_ahuRelFan and buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Control of relief fan when it is part of AHU"
    annotation (Placement(transformation(extent={{0,-270},{20,-250}})));

equation
  connect(conSupFan.uZonPreResReq, uZonPreResReq) annotation (Line(points={{-222,
          507},{-300,507},{-300,520},{-380,520}},      color={255,127,0}));
  connect(dpDuc, conSupFan.dpDuc) annotation (Line(points={{-380,480},{-300,480},
          {-300,502},{-222,502}}, color={0,0,127}));
  connect(conTSupSet.TOut, TOut) annotation (Line(points={{-162,457},{-320,457},
          {-320,450},{-380,450}}, color={0,0,127}));
  connect(conTSupSet.uZonTemResReq, uZonTemResReq) annotation (Line(points={{-162,
          453},{-310,453},{-310,420},{-380,420}},      color={255,127,0}));
  connect(u1SupFan, conTSupSet.u1SupFan) annotation (Line(points={{-380,380},{-300,
          380},{-300,447},{-162,447}}, color={255,0,255}));
  connect(u1SupFan, supSig.u1SupFan) annotation (Line(points={{-380,380},{-300,380},
          {-300,416},{-82,416}}, color={255,0,255}));
  connect(conTSupSet.TAirSupSet, supSig.TAirSupSet) annotation (Line(points={{-138,
          450},{-120,450},{-120,410},{-82,410}}, color={0,0,127}));
  connect(supSig.TAirSup, TAirSup) annotation (Line(points={{-82,404},{-290,404},
          {-290,340},{-380,340}}, color={0,0,127}));
  connect(uOutAirFra_max, ashOutAirSet.uOutAirFra_max) annotation (Line(points={{-380,
          186},{-82,186}},                             color={0,0,127}));
  connect(plaReq.yChiWatResReq, yChiWatResReq) annotation (Line(points={{2,-522},
          {330,-522},{330,-460},{380,-460}},       color={255,127,0}));
  connect(plaReq.yChiPlaReq, yChiPlaReq) annotation (Line(points={{2,-527},{340,
          -527},{340,-490},{380,-490}},     color={255,127,0}));
  connect(plaReq.yHotWatResReq, yHotWatResReq) annotation (Line(points={{2,-533},
          {340,-533},{340,-540},{380,-540}},       color={255,127,0}));
  connect(plaReq.uCooCoi_actual, uCooCoi_actual) annotation (Line(points={{-22,-533},
          {-320,-533},{-320,-510},{-380,-510}}, color={0,0,127}));
  connect(uHeaCoi_actual, plaReq.uHeaCoi_actual) annotation (Line(points={{-380,
          -560},{-320,-560},{-320,-538},{-22,-538}}, color={0,0,127}));
  connect(ashOutAirSet.effOutAir_normalized, ecoCon.VOutMinSet_flow_normalized)
    annotation (Line(points={{-58,187},{40,187},{40,-21},{60,-21}}, color={0,0,127}));
  connect(ecoCon.dpMinOutDam, dpMinOutDam) annotation (Line(points={{60,-38},{
          22,-38},{22,-50},{-380,-50}}, color={0,0,127}));
  connect(supSig.uTSup, ecoCon.uTSup) annotation (Line(points={{-58,416},{-32,
          416},{-32,-41},{60,-41}}, color={0,0,127}));
  connect(TOut, ecoCon.TOut) annotation (Line(points={{-380,450},{-320,450},{
          -320,-44},{60,-44}}, color={0,0,127}));
  connect(TAirRet, ecoCon.TAirRet) annotation (Line(points={{-380,-80},{28,-80},
          {28,-46},{60,-46}}, color={0,0,127}));
  connect(ecoCon.hAirOut, hAirOut) annotation (Line(points={{60,-49},{34,-49},{
          34,-110},{-380,-110}}, color={0,0,127}));
  connect(hAirRet, ecoCon.hAirRet) annotation (Line(points={{-380,-140},{40,
          -140},{40,-51},{60,-51}}, color={0,0,127}));
  connect(u1SupFan, ecoCon.u1SupFan) annotation (Line(points={{-380,380},{-300,
          380},{-300,-54},{60,-54}}, color={255,0,255}));
  connect(ecoCon.yOutDam_min, frePro.uOutDamPosMin) annotation (Line(points={{84,-21},
          {128,-21},{128,-181},{178,-181}},      color={0,0,127}));
  connect(TAirSup, frePro.TAirSup) annotation (Line(points={{-380,340},{-290,340},
          {-290,-195},{178,-195}}, color={0,0,127}));
  connect(frePro.u1FreSta, u1FreSta) annotation (Line(points={{178,-198},{92,
          -198},{92,-170},{-380,-170}}, color={255,0,255}));
  connect(frePro.u1SofSwiRes, u1SofSwiRes) annotation (Line(points={{178,-200},
          {92,-200},{92,-210},{-380,-210}},  color={255,0,255}));
  connect(frePro.TAirMix, TAirMix) annotation (Line(points={{178,-219},{144,-219},
          {144,-310},{-380,-310}}, color={0,0,127}));
  connect(ashOutAirSet.VEffAirOut_flow_min, VEffAirOut_flow_min) annotation (
      Line(points={{-58,193},{250,193},{250,250},{380,250}}, color={0,0,127}));
  connect(ecoCon.yRelDam, yRelDam) annotation (Line(points={{84,-46},{200,-46},
          {200,60},{380,60}}, color={0,0,127}));
  connect(frePro.yFreProSta, ecoCon.uFreProSta) annotation (Line(points={{202,-215},
          {220,-215},{220,-80},{46,-80},{46,-59},{60,-59}},     color={255,127,0}));
  connect(ecoCon.yOutDam, frePro.uOutDam) annotation (Line(points={{84,-52},{136,
          -52},{136,-183},{178,-183}}, color={0,0,127}));
  connect(ecoCon.yRetDam, frePro.uRetDam) annotation (Line(points={{84,-34},{144,
          -34},{144,-193},{178,-193}}, color={0,0,127}));
  connect(supSig.yHeaCoi, frePro.uHeaCoi) annotation (Line(points={{-58,410},{160,
          410},{160,-186},{178,-186}}, color={0,0,127}));
  connect(conSupFan.ySupFan, frePro.uSupFan) annotation (Line(points={{-198,510},
          {-114,510},{-114,-205},{178,-205}}, color={0,0,127}));
  connect(supSig.yCooCoi, frePro.uCooCoi) annotation (Line(points={{-58,404},{152,
          404},{152,-217},{178,-217}}, color={0,0,127}));
  connect(frePro.y1EneCHWPum, y1EneCHWPum) annotation (Line(points={{202,-181},{
          280,-181},{280,-10},{380,-10}}, color={255,0,255}));
  connect(frePro.yRetDam, yRetDam) annotation (Line(points={{202,-185},{250,-185},
          {250,90},{380,90}}, color={0,0,127}));
  connect(frePro.yOutDam, yOutDam) annotation (Line(points={{202,-187},{270,-187},
          {270,30},{380,30}}, color={0,0,127}));
  connect(ecoCon.yMinOutDam, frePro.uMinOutDam) annotation (Line(points={{84,-27},
          {116,-27},{116,-189},{178,-189}}, color={0,0,127}));
  connect(frePro.yMinOutDam, yMinOutDam) annotation (Line(points={{202,-190},{230,
          -190},{230,160},{380,160}}, color={0,0,127}));
  connect(frePro.ySupFan, ySupFan) annotation (Line(points={{202,-197},{300,-197},
          {300,-70},{380,-70}},   color={0,0,127}));
  connect(frePro.yRetFan, yRetFan) annotation (Line(points={{202,-202},{320,-202},
          {320,-132},{380,-132}}, color={0,0,127}));
  connect(frePro.yCooCoi, yCooCoi) annotation (Line(points={{202,-210},{310,-210},
          {310,-230},{380,-230}}, color={0,0,127}));
  connect(frePro.yHeaCoi, yHeaCoi) annotation (Line(points={{202,-212},{300,-212},
          {300,-260},{380,-260}}, color={0,0,127}));
  connect(intSwi.y, yHotWatPlaReq)
    annotation (Line(points={{322,-570},{380,-570}}, color={255,127,0}));
  connect(plaReq.yHotWatPlaReq, intSwi.u3) annotation (Line(points={{2,-538},{160,
          -538},{160,-578},{298,-578}}, color={255,127,0}));
  connect(freProMod.y, intSwi.u2) annotation (Line(points={{202,-560},{220,-560},
          {220,-570},{298,-570}}, color={255,0,255}));
  connect(frePro.yRelFan, yRelFan) annotation (Line(points={{202,-207},{340,-207},
          {340,-190},{380,-190}}, color={0,0,127}));
  connect(relDam.dpBui, dpBui)
    annotation (Line(points={{-162,-344},{-380,-344}}, color={0,0,127}));
  connect(relDam.yRelDam, yRelDam) annotation (Line(points={{-138,-350},{260,
          -350},{260,60},{380,60}}, color={0,0,127}));
  connect(retFanAirTra.VAirSup_flow, VAirSup_flow) annotation (Line(points={{-162,
          -394},{-320,-394},{-320,-380},{-380,-380}}, color={0,0,127}));
  connect(retFanAirTra.VAirRet_flow, VAirRet_flow) annotation (Line(points={{-162,
          -400},{-320,-400},{-320,-440},{-380,-440}}, color={0,0,127}));
  connect(dpBui, retFanDpCon.dpBui) annotation (Line(points={{-380,-344},{-280,-344},
          {-280,-464},{-162,-464}}, color={0,0,127}));
  connect(retFanDpCon.yDpBui, yDpBui) annotation (Line(points={{-138,-462},{160,
          -462},{160,-380},{380,-380}},                color={0,0,127}));
  connect(retFanDpCon.dpDisSet, dpDisSet) annotation (Line(points={{-138,-472},{
          310,-472},{310,-420},{380,-420}}, color={0,0,127}));
  connect(u1SupFan, relDam.u1SupFan) annotation (Line(points={{-380,380},{-300,
          380},{-300,-356},{-162,-356}}, color={255,0,255}));
  connect(u1SupFan, retFanAirTra.u1SupFan) annotation (Line(points={{-380,380},{
          -300,380},{-300,-406},{-162,-406}}, color={255,0,255}));
  connect(u1SupFan, retFanDpCon.u1SupFan) annotation (Line(points={{-380,380},{-300,
          380},{-300,-476},{-162,-476}}, color={255,0,255}));
  connect(TAirSup, plaReq.TAirSup) annotation (Line(points={{-380,340},{-290,340},
          {-290,-522},{-22,-522}}, color={0,0,127}));
  connect(conTSupSet.TAirSupSet, plaReq.TAirSupSet) annotation (Line(points={{-138,
          450},{-120,450},{-120,-527},{-22,-527}}, color={0,0,127}));
  connect(frePro.yHotWatPlaReq, intSwi.u1) annotation (Line(points={{202,-217},{
          230,-217},{230,-562},{298,-562}}, color={255,127,0}));
  connect(retFanAirTra.yRetFan, frePro.uRetFan) annotation (Line(points={{-138,-400},
          {128,-400},{128,-210},{178,-210}},       color={0,0,127}));
  connect(retFanDpCon.yRetFan, frePro.uRetFan) annotation (Line(points={{-138,-477},
          {128,-477},{128,-210},{178,-210}}, color={0,0,127}));
  connect(frePro.yAla, yAla) annotation (Line(points={{202,-219},{292,-219},{292,
          -290},{380,-290}}, color={255,127,0}));
  connect(conTSupSet.TAirSupSet, TAirSupSet) annotation (Line(points={{-138,450},
          {120,450},{120,500},{380,500}}, color={0,0,127}));
  connect(tit24OutAirSet.effAbsOutAir_normalized, ecoCon.effAbsOutAir_normalized)
    annotation (Line(points={{-58,154},{28,154},{28,-31},{60,-31}}, color={0,0,127}));
  connect(tit24OutAirSet.effDesOutAir_normalized, ecoCon.effDesOutAir_normalized)
    annotation (Line(points={{-58,146},{22,146},{22,-33},{60,-33}}, color={0,0,127}));
  connect(uCO2Loo_max, ecoCon.uCO2Loo_max) annotation (Line(points={{-380,-20},
          {-132,-20},{-132,-35},{60,-35}},color={0,0,127}));
  connect(uCO2Loo_max, tit24OutAirSet.uCO2Loo_max) annotation (Line(points={{-380,
          -20},{-132,-20},{-132,147},{-82,147}}, color={0,0,127}));
  connect(tit24OutAirSet.effOutAir_normalized, ecoCon.VOutMinSet_flow_normalized)
    annotation (Line(points={{-58,144},{40,144},{40,-21},{60,-21}}, color={0,0,127}));
  connect(VAirOut_flow, tit24OutAirSet.VAirOut_flow) annotation (Line(points={{-380,96},
          {-126,96},{-126,142},{-82,142}},     color={0,0,127}));
  connect(VAirOut_flow, ashOutAirSet.VAirOut_flow) annotation (Line(points={{-380,96},
          {-126,96},{-126,182},{-82,182}},     color={0,0,127}));
  connect(ashOutAirSet.outAir_normalized, ecoCon.VOut_flow_normalized)
    annotation (Line(points={{-58,182},{34,182},{34,-23},{60,-23}}, color={0,0,127}));
  connect(tit24OutAirSet.outAir_normalized, ecoCon.VOut_flow_normalized)
    annotation (Line(points={{-58,141},{34,141},{34,-23},{60,-23}}, color={0,0,127}));
  connect(VSumZonDesMin_flow, tit24OutAirSet.VSumZonDesMin_flow) annotation (
      Line(points={{-380,126},{-138,126},{-138,153},{-82,153}}, color={0,0,127}));
  connect(VSumZonAbsMin_flow, tit24OutAirSet.VSumZonAbsMin_flow)
    annotation (Line(points={{-380,158},{-82,158}}, color={0,0,127}));
  connect(VSumZonPri_flow, ashOutAirSet.VSumZonPri_flow) annotation (Line(
        points={{-380,216},{-138,216},{-138,190},{-82,190}}, color={0,0,127}));
  connect(VSumAdjAreBreZon_flow, ashOutAirSet.VSumAdjAreBreZon_flow)
    annotation (Line(points={{-380,246},{-132,246},{-132,194},{-82,194}}, color=
         {0,0,127}));
  connect(VSumAdjPopBreZon_flow, ashOutAirSet.VSumAdjPopBreZon_flow)
    annotation (Line(points={{-380,276},{-126,276},{-126,198},{-82,198}}, color=
         {0,0,127}));
  connect(uAhuOpeMod, conSupFan.uOpeMod) annotation (Line(points={{-380,560},{-240,
          560},{-240,518},{-222,518}}, color={255,127,0}));
  connect(uAhuOpeMod, conTSupSet.uOpeMod) annotation (Line(points={{-380,560},{-240,
          560},{-240,443},{-162,443}}, color={255,127,0}));
  connect(uAhuOpeMod, ecoCon.uOpeMod) annotation (Line(points={{-380,560},{-240,
          560},{-240,-57},{60,-57}}, color={255,127,0}));
  connect(ecoCon.y1MinOutDam, frePro.u1MinOutDam) annotation (Line(points={{84,-29},
          {108,-29},{108,-191},{178,-191}},      color={255,0,255}));
  connect(frePro.y1MinOutDam, y1MinOutDam) annotation (Line(points={{202,-192},{
          240,-192},{240,130},{380,130}}, color={255,0,255}));
  connect(retFanDpCon.yRelDam, yRelDam) annotation (Line(points={{-138,-468},{168,
          -468},{168,60},{380,60}},     color={0,0,127}));
  connect(u1RelFan, frePro.u1RelFan) annotation (Line(points={{-380,-240},{112,
          -240},{112,-212},{178,-212}}, color={255,0,255}));
  connect(retFanAirTra.y1RetFan, frePro.u1RetFan) annotation (Line(points={{-138,
          -409},{120,-409},{120,-208},{178,-208}}, color={255,0,255}));
  connect(retFanDpCon.y1RetFan, frePro.u1RetFan) annotation (Line(points={{-138,
          -479},{120,-479},{120,-208},{178,-208}}, color={255,0,255}));
  connect(frePro.y1RelFan, y1RelFan) annotation (Line(points={{202,-205},{330,-205},
          {330,-160},{380,-160}}, color={255,0,255}));
  connect(frePro.yFreProSta, freProMod.u) annotation (Line(points={{202,-215},{220,
          -215},{220,-500},{170,-500},{170,-560},{178,-560}}, color={255,127,0}));
  connect(conSupFan.y1SupFan, frePro.u1SupFan) annotation (Line(points={{-198,
          517},{100,517},{100,-203},{178,-203}}, color={255,0,255}));
  connect(frePro.y1SupFan, y1SupFan) annotation (Line(points={{202,-195},{290,-195},
          {290,-40},{380,-40}}, color={255,0,255}));
  connect(frePro.y1RetFan, y1RetFan) annotation (Line(points={{202,-200},{310,-200},
          {310,-100},{380,-100}}, color={255,0,255}));
  connect(ecoCon.yEnaMinOut, retFanDpCon.u1MinOutAirDam) annotation (Line(
        points={{84,-23},{122,-23},{122,-160},{-180,-160},{-180,-470},{-162,
          -470}}, color={255,0,255}));
  connect(dpBui, relFanCon.dpBui) annotation (Line(points={{-380,-344},{-280,
          -344},{-280,-257},{-2,-257}}, color={0,0,127}));
  connect(u1SupFan, relFanCon.u1SupFan) annotation (Line(points={{-380,380},{
          -300,380},{-300,-263},{-2,-263}}, color={255,0,255}));
  connect(relFanCon.yDpBui, yDpBui) annotation (Line(points={{22,-252},{160,
          -252},{160,-380},{380,-380}}, color={0,0,127}));
  connect(relFanCon.yRelFan, frePro.uRelFan) annotation (Line(points={{22,-263},
          {136,-263},{136,-214},{178,-214}}, color={0,0,127}));
  connect(relFanCon.y1RelFan, frePro.u1RelFan) annotation (Line(points={{22,
          -268},{112,-268},{112,-212},{178,-212}}, color={255,0,255}));
  connect(relFanCon.yDam, yRelDam) annotation (Line(points={{22,-257},{210,-257},
          {210,60},{380,60}}, color={0,0,127}));
  connect(conSupFan.ySupFan, ecoCon.uSupFan) annotation (Line(points={{-198,510},
          {-114,510},{-114,-28},{60,-28}}, color={0,0,127}));
annotation (
  defaultComponentName="mulAHUCon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-440},{200,440}}),
    graphics={
      Rectangle(extent={{200,440},{-200,-440}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
       Text(extent={{-200,520},{200,440}},
          textString="%name",
          textColor={0,0,255}),
       Text(
          extent={{-196,242},{-74,218}},
          textColor={0,0,0},
          textString="VSumAdjAreBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
       Text(extent={{-194,288},{-156,272}},
          textColor={0,0,0},
          textString="TAirSup"),
       Text(extent={{-198,366},{-164,350}},
          textColor={0,0,0},
          textString="TOut"),
       Text(extent={{-200,390},{-160,374}},
          textColor={0,0,0},
          textString="dpDuc"),
       Text(
          extent={{-196,208},{-114,192}},
          textColor={0,0,0},
          textString="VSumZonPri_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
       Text(
          extent={{-194,138},{-66,120}},
          textColor={0,0,0},
          textString="VSumZonAbsMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24),
       Text(
          extent={{-194,116},{-64,98}},
          textColor={0,0,0},
          textString="VSumZonDesMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24),
       Text(
          extent={{-196,180},{-114,164}},
          textColor={0,0,0},
          textString="uOutAirFra_max",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
       Text(
          extent={{-194,78},{-124,58}},
          textColor={0,0,0},
          textString="VAirOut_flow",
          visible=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
     or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper)),
       Text(
          extent={{-198,-40},{-116,-58}},
          textColor={0,0,0},
          textString="dpMinOutDam",
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure),
       Text(
          extent={{-196,-70},{-160,-90}},
          textColor={0,0,0},
          textString="TAirRet",
          visible=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb),
       Text(
          extent={{-196,-90},{-160,-108}},
          textColor={0,0,0},
          textString="hAirOut",
          visible=(ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
               or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb)),
       Text(
          extent={{-196,-110},{-160,-128}},
          textColor={0,0,0},
          visible=(eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
               and ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb),
          textString="hAirRet"),
       Text(
          extent={{-198,-270},{-158,-288}},
          textColor={0,0,0},
          textString="TAirMix",
          visible=have_hotWatCoi),
       Text(extent={{-196,-398},{-112,-420}},
          textColor={0,0,0},
          textString="uCooCoi_actual"),
       Text(extent={{-196,-420},{-112,-440}},
          textColor={0,0,0},
          textString="uHeaCoi_actual",
          visible=have_hotWatCoi),
       Text(extent={{142,-168},{200,-188}},
          textColor={0,0,0},
          textString="yHeaCoi",
          visible=have_hotWatCoi),
       Text(extent={{142,-140},{200,-160}},
          textColor={0,0,0},
          textString="yCooCoi"),
       Text(extent={{142,-108},{204,-128}},
          textColor={0,0,0},
          textString="yRelFan",
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan),
       Text(
          extent={{144,-58},{200,-78}},
          textColor={0,0,0},
          textString="yRetFan",
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
                   or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)),
       Text(extent={{140,-6},{198,-28}},
          textColor={0,0,0},
          textString="ySupFan"),
       Text(extent={{142,82},{202,64}},
          textColor={0,0,0},
          textString="yOutDam"),
       Text(
          extent={{142,112},{202,94}},
          textColor={0,0,0},
          textString="yRelDam",
          visible=not ((buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
               and not have_ahuRelFan) or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.BarometricRelief)),
       Text(extent={{140,142},{202,124}},
          textColor={0,0,0},
          textString="yRetDam"),
       Text(
          extent={{118,200},{200,182}},
          textColor={0,0,0},
          textString="yMinOutDam",
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow),
       Text(extent={{86,244},{198,222}},
          textColor={0,0,0},
          textString="VEffAirOut_flow_min"),
       Text(extent={{-196,440},{-128,420}},
          textColor={255,127,0},
          textString="uAhuOpeMod"),
       Text(extent={{-196,422},{-114,398}},
          textColor={255,127,0},
          textString="uZonPreResReq"),
       Text(extent={{-194,340},{-106,320}},
          textColor={255,127,0},
          textString="uZonTemResReq"),
       Text(extent={{106,-298},{194,-318}},
          textColor={255,127,0},
          textString="yChiWatResReq"),
       Text(extent={{124,-338},{202,-356}},
          textColor={255,127,0},
          textString="yChiPlaReq"),
       Text(extent={{108,-378},{196,-398}},
          textColor={255,127,0},
          textString="yHotWatResReq",
          visible=have_hotWatCoi),
       Text(extent={{108,-418},{196,-438}},
          textColor={255,127,0},
          textString="yHotWatPlaReq",
          visible=have_hotWatCoi),
       Text(
          extent={{118,172},{196,152}},
          textColor={255,0,255},
          textString="y1MinOutDam",
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure),
       Text(extent={{132,12},{200,-8}},
          textColor={255,0,255},
          textString="y1SupFan"),
       Text(extent={{-198,320},{-130,300}},
          textColor={255,0,255},
          textString="u1SupFan"),
       Text(
          extent={{-196,-148},{-142,-168}},
          textColor={255,0,255},
          textString="u1FreSta",
          visible=freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS),
       Text(
          extent={{-196,-188},{-122,-208}},
          textColor={255,0,255},
          textString="u1SofSwiRes",
          visible=(freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
               or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)),
       Text(
          extent={{112,50},{200,32}},
          textColor={255,0,255},
          textString="y1EneCHWPum",
          visible=have_frePro),
       Text(
          extent={{-202,-300},{-158,-318}},
          textColor={0,0,0},
          textString="dpBui",
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)),
       Text(
          extent={{-196,-352},{-136,-368}},
          textColor={0,0,0},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir,
          textString="VAirRet_flow"),
       Text(
          extent={{-196,-332},{-136,-348}},
          textColor={0,0,0},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir,
          textString="VAirSup_flow"),
       Text(
          extent={{150,-218},{204,-236}},
          textColor={0,0,0},
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
               and have_ahuRelFan) or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp,
          textString="yDpBui"),
       Text(
          extent={{138,-260},{200,-278}},
          textColor={0,0,0},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp,
          textString="dpDisSet"),
       Text(
          extent={{166,-190},{196,-208}},
          textColor={255,127,0},
          textString="yAla",
          visible=have_frePro),
       Text(extent={{142,352},{198,334}},
          textColor={0,0,0},
          textString="TAirSupSet"),
       Text(
          extent={{-196,262},{-74,238}},
          textColor={0,0,0},
          textString="VSumAdjPopBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
       Text(
          extent={{-196,-10},{-136,-30}},
          textColor={0,0,0},
          visible=(have_CO2Sen and venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24),
          textString="uCO2Loo_max"),
       Text(
          extent={{134,-36},{202,-56}},
          textColor={255,0,255},
          textString="y1RetFan",
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
                or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)),
       Text(
          extent={{134,-86},{202,-106}},
          textColor={255,0,255},
          textString="y1RelFan",
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan),
       Text(
          extent={{-198,-218},{-130,-238}},
          textColor={255,0,255},
          textString="u1RelFan",
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
               and not have_ahuRelFan)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-360,-600},{360,600}})),
  Documentation(info="<html>
<p>
Block that is applied for multizone VAV AHU control. It outputs the supply fan status
and the operation speed, outdoor and return air damper position, supply air
temperature setpoint and the valve position of the cooling and heating coils.
It is implemented according to the Section 5.16 of ASHRAE Guideline 36, May 2020.
</p>
<p>
The sequence consists of eight types of subsequences.
</p>
<h4>Supply fan speed control</h4>
<p>
The fan speed control is implemented according to Section 5.16.1. It outputs
the boolean signal <code>y1SupFan</code> to turn on or off the supply fan.
In addition, based on the pressure reset request <code>uZonPreResReq</code>
from the VAV zones controller, the
sequence resets the duct pressure setpoint, and uses this setpoint
to modulate the fan speed <code>ySupFanSpe</code> using a PI controller.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyFan</a>
for more detailed description.
</p>
<h4>Minimum outdoor airflow setting</h4>
<p>
According to current occupany, supply operation status <code>ySupFan</code>,
zone temperatures and the discharge air temperature, the sequence computes the
minimum outdoor airflow rate setpoint, which is used as input for the economizer control.
More detailed information can be found in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow</a>.
</p>
<h4>Economizer control</h4>
<p>
The block outputs outdoor and return air damper position, <code>yOutDamPos</code> and
<code>yRetDamPos</code>. First, it computes the position limits to satisfy the minimum
outdoor airflow requirement. Second, it determines the availability of the economizer based
on the outdoor condition. The dampers are modulated to track the supply air temperature
loop signal, which is calculated from the sequence below, subject to the minimum outdoor airflow
requirement and economizer availability.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller</a>
for more detailed description.
</p>
<h4>Supply air temperature setpoint</h4>
<p>
Based on the Section 5.16.2, the sequence first sets the maximum supply air temperature
based on reset requests collected from each zone <code>uZonTemResReq</code>. The
outdoor temperature <code>TOut</code> and operation mode <code>uOpeMod</code> are used
along with the maximum supply air temperature, for computing the supply air temperature
setpoint. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature</a>
for more detailed description.
</p>
<h4>Coil valve control</h4>
<p>
The subsequence retrieves supply air temperature setpoint from previous sequence.
Along with the measured supply air temperature and the supply fan status, it
generates coil valve positions. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplySignals\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplySignals</a>
for more detailed description.
</p>
<h4>Freeze protection</h4>
<p>
Based on the Section 5.16.12, the sequence enables freeze protection if the
measured supply air temperature belows certain thresholds. There are three
protection stages. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.FreezeProtection\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.FreezeProtection</a>
for more detailed description.
</p>
<h4>Building pressure control</h4>
<p>
By selecting different building pressure control designs, which includes using actuated
relief damper without fan, using actuated relief dampers with relief fan, using
return fan with direct building pressure control, or using return fan with airflow
tracking control, the sequences controls relief fans, relief dampers and return fans.
See belows sequences for more detailed description:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefDamper\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefDamper</a>
</li>
<li> Relief fan control
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefFan</a> is not
included in the AHU controller. This sequence controls all the relief fans that are
serving one common space, which may include multiple air handling units.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanAirflowTracking\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanAirflowTracking</a>
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanDirectPressure\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanDirectPressure</a>
</li>
</ul>
<h4>Plant request</h4>
<p>
According to the Section 5.16.16, the sequence send out heating or cooling plant requests
if the supply air temperature is below or above threshold value, or the heating or
cooling valves have been widely open for certain times. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests</a>
for more detailed description.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 1, 2023, by Michael Wetter:<br/>
Changed constants from <code>0</code> to <code>0.0</code> and <code>1</code> to <code>1.0</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/3267#issuecomment-1450587671\">#3267</a>.
</li>
<li>
December 15, 2022, by Jianjun Hu:<br/>
Removed input connectors <code>uRelFan</code> and <code>uSupFanSpe_actual</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">issue 3139</a>.
</li>
<li>
December 20, 2021, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
