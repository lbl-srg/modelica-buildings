within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV;
block Controller "Multizone VAV air handling unit controller"

  parameter Boolean have_heatingCoil=true
    "True: the AHU has heating coil"
    annotation (Dialog(group="System and building parameters"));
  parameter Integer nZonGro=1
    "Total number of zone group that the AHU is serving";
  parameter Boolean have_perZonRehBox=false
    "Check if there is any VAV-reheat boxes on perimeter zones"
    annotation (Dialog(group="System and building parameters"));
  parameter Boolean have_duaDucBox=false
    "Check if the AHU serves dual duct boxes"
    annotation (Dialog(group="System and building parameters"));
  parameter Boolean have_airFloMeaSta=false
    "Check if the AHU has AFMS (Airflow measurement station)"
    annotation (Dialog(group="System and building parameters"));
  parameter Boolean have_freezeStat=false
    "True: the system has a physical freeze stat"
    annotation (Dialog(group="System and building parameters"));
  parameter Real VPriSysMax_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Maximum expected system primary airflow at design stage"
    annotation (Dialog(group="Minimum outdoor air setpoint"));
  parameter Real peaSysPop "Peak system population"
    annotation (Dialog(group="Minimum outdoor air setpoint"));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns minOADes
    "Design of minimum outdoor air and economizer function"
    annotation (Dialog(group="Economizer design"));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system"
    annotation (Dialog(group="Economizer design"));
  parameter Real aveTimRan(
    final unit="s",
    final quantity="Time")=5
    "Time horizon over which the outdoor air flow measurment is averaged"
    annotation (Dialog(group="Economizer design"));

  // ----------- parameters for fan speed control  -----------
  parameter Real pIniSet(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")=120
    "Initial pressure setpoint for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pMinSet(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")=25
    "Minimum pressure setpoint for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pMaxSet(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Maximum pressure setpoint for supply fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pDelTim(
    final unit="s",
    final quantity="Time")=600
    "Delay time after which trim and respond is activated"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pSamplePeriod(
    final unit="s",
    final quantity="Time")=120
    "Sample period"
    annotation (Dialog(tab="Fan speed",group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Integer pNumIgnReq=2
    "Number of ignored requests"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pTriAmo(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")=-12.0
    "Trim amount"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pResAmo(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")=15
    "Respond amount (must be opposite in to trim amount)"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pMaxRes(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")=32
    "Maximum response per time interval (same sign as respond amount)"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController fanSpeCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Supply fan speed PID controller"
    annotation (Dialog(tab="Fan speed", group="PID controller"));
  parameter Real kFanSpe(final unit="1")=0.1
    "Gain of supply fan speed PID controller"
    annotation (Dialog(tab="Fan speed", group="PID controller"));
  parameter Real TiFanSpe(
    final unit="s",
    final quantity="Time")=60
    "Time constant of integrator block for supply fan speed PID controller"
    annotation (Dialog(tab="Fan speed", group="PID controller",
      enable=fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdFanSpe(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for supply fan speed PID controller"
    annotation (Dialog(tab="Fan speed", group="PID controller",
      enable=fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yFanMax=1
    "Maximum allowed fan speed"
    annotation (Dialog(tab="Fan speed", group="PID controller"));
  parameter Real yFanMin=0.1
    "Lowest allowed fan speed if fan is on"
    annotation (Dialog(tab="Fan speed", group="PID controller"));

  // ----------- parameters for supply air temperature control  -----------
  parameter Real TSupCooMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=285.15
    "Lowest cooling supply air temperature setpoint when the outdoor air temperature is at the higher value of the reset range and above"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TSupCooMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=291.15
    "Highest cooling supply air temperature setpoint. It is typically 18 degC (65 degF) 
    in mild and dry climates, 16 degC (60 degF) or lower in humid climates"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TOutMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=289.15
    "Lower value of the outdoor air temperature reset range. Typically value is 16 degC (60 degF)"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TOutMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=294.15
    "Higher value of the outdoor air temperature reset range. Typically value is 21 degC (70 degF)"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TSupWarUpSetBac(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=308.15
    "Supply temperature in warm up and set back mode"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real delTimSupTem(
    final unit="s",
    final quantity="Time")=600
    "Delay timer"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real samPerSupTem(
    final unit="s",
    final quantity="Time")=120
    "Sample period of component"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Integer ignReqSupTem=2
    "Number of ignorable requests for TrimResponse logic"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real triAmoSupTem(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=0.1
    "Trim amount"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real resAmoSupTem(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=-0.2
    "Response amount"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real maxResSupTem(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=-0.6
    "Maximum response per time interval"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));

  // ----------- parameters for heating and cooling coil control  -----------
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController valCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for coil valves control"
    annotation (Dialog(tab="Coils", group="Valves PID controller"));
  parameter Real kVal(final unit="1")=0.05
    "Gain of controller for valve control"
    annotation (Dialog(tab="Coils", group="Valves PID controller"));
  parameter Real TiVal(
    final unit="s",
    final quantity="Time")=600
    "Time constant of integrator block for valve control"
    annotation (Dialog(tab="Coils", group="Valves PID controller",
      enable=valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdVal(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for valve control"
    annotation (Dialog(tab="Coils", group="Valves PID controller",
      enable=valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real uHeaCoiMax=-0.25
    "Upper limit of controller signal when heating coil is off. Require -1 < uHeaMax < uCooMin < 1."
    annotation (Dialog(tab="Coils", group="Limits"));
  parameter Real uCooCoiMin=0.25
    "Lower limit of controller signal when cooling coil is off. Require -1 < uHeaMax < uCooMin < 1."
    annotation (Dialog(tab="Coils", group="Limits"));

  // ----------- parameters for economizer control  -----------
  // Limits
  parameter Real minSpe(
    final unit="1",
    final min=0,
    final max=1)
    "Minimum supply fan speed"
    annotation (Dialog(tab="Economizer", enable=have_separateAFMS or have_separateDP));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController minOAConTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Type of minimum outdoor air controller"
    annotation (Dialog(tab="Economizer", group="Limits, separated with AFMS",
      enable=have_separateAFMS or have_common));
  parameter Real kMinOA(
    final unit="1")=1
    "Gain of controller"
    annotation (Dialog(tab="Economizer", group="Limits, separated with AFMS",
      enable=have_separateAFMS or have_common));
  parameter Real TiMinOA(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Economizer", group="Limits, separated with AFMS",
      enable=(have_separateAFMS or have_common)
        and (minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdMinOA(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Economizer", group="Limits, separated with AFMS",
      enable=(have_separateAFMS or have_common)
        and (minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real dpDesOutDam_min(
    final unit="Pa",
    final quantity="PressureDifference")
    "Design pressure difference across the minimum outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=have_separateDP));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController dpConTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Type of differential pressure setpoint controller"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=have_separateDP));
  parameter Real kDp(
    final unit="1")=1
    "Gain of controller"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=have_separateDP));
  parameter Real TiDp(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=(have_separateAFMS or have_common)
        and (dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDp(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=(have_separateAFMS or have_common)
        and (dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real uMinRetDam(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Loop signal value to start decreasing the maximum return air damper position"
    annotation (Dialog(tab="Economizer", group="Limits, Common",
      enable=have_common));
  // Enable
  parameter Boolean use_enthalpy=true
    "Set to true to evaluate outdoor air enthalpy in addition to temperature"
    annotation (Dialog(tab="Economizer", group="Enable"));
  parameter Real delTOutHis(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation (Dialog(tab="Economizer", group="Enable"));
  parameter Real delEntHis(
    final unit="J/kg",
    final quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation (Dialog(tab="Economizer", group="Enable"));
  parameter Real retDamFulOpeTim(
    final unit="s",
    final quantity="Time")=180
    "Time period to keep return air damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations"
    annotation (Dialog(tab="Economizer", group="Enable"));
  parameter Real disDel(
    final unit="s",
    final quantity="Time")=15
    "Short time delay before closing the outdoor air damper at disable to avoid pressure fluctuations"
    annotation (Dialog(tab="Economizer", group="Enable"));
  // Modulation
  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time")=300
    "Sample period of component, used to limit the rate of change of the dampers (to avoid quick opening that can result in frost)"
    annotation (Dialog(tab="Economizer", group="Modulation"));
  // Commissioning
  parameter Real retDamPhyPosMax(
    final unit="1")=1
    "Physically fixed maximum position of the return air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits"));
  parameter Real retDamPhyPosMin(
    final unit="1")=0
    "Physically fixed minimum position of the return air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits"));
  parameter Real outDamPhyPosMax(
    final unit="1")=1
    "Physically fixed maximum position of the outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits"));
  parameter Real outDamPhyPosMin(
    final unit="1")=0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits"));
  parameter Real minOutDamPhyPosMax(
    final unit="1")=1
    "Physically fixed maximum position of the minimum outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits",
      enable=have_separateAFMS));
  parameter Real minOutDamPhyPosMin(
    final unit="1")=0
    "Physically fixed minimum position of the minimum outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits",
      enable=have_separateAFMS));
  parameter Real uHeaMax(
    final unit="1")=-0.25
    "Lower limit of controller input when outdoor damper opens (see diagram)"
    annotation (Dialog(tab="Economizer", group="Commissioning, modulation"));
  parameter Real uCooMin(
    final unit="1")=+0.25
    "Upper limit of controller input when return damper is closed (see diagram)"
    annotation (Dialog(tab="Economizer", group="Commissioning, modulation"));
  parameter Real uOutDamMax(
    final unit="1")=(uHeaMax + uCooMin)/2
    "Maximum loop signal for the OA damper to be fully open"
    annotation (Dialog(tab="Economizer", group="Commissioning, modulation",
      enable=have_reliefs));
  parameter Real uRetDamMin(
    final unit="1")=(uHeaMax + uCooMin)/2
    "Minimum loop signal for the RA damper to be fully open"
    annotation (Dialog(tab="Economizer", group="Commissioning, modulation",
      enable=have_reliefs));

  // ----------- parameters for freeze protection -----------
  parameter Integer minHotWatReq=2
    "Minimum heating hot-water plant request to active the heating plant"
    annotation (Dialog(tab="Freeze protection"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController freProHeaCoiCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Freeze protection heating coil controller"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller"));
  parameter Real kFrePro(
    final unit="1")=1
    "Gain of coil controller"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller"));
  parameter Real TiFrePro(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller",
      enable=freProHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or freProHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdFrePro(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller",
      enable=freProHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or freProHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMaxFrePro=1
    "Upper limit of output"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller"));
  parameter Real yMinFrePro=0
    "Lower limit of output"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller"));

  // ----------- Advanced parameters -----------
  parameter Real Thys=0.25 "Hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));
  parameter Real posHys=0.05
    "Hysteresis for checking valve position difference"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod[nZonGro]
    "Zone group operation mode"
    annotation (Placement(transformation(extent={{-400,460},{-360,500}}),
        iconTransformation(extent={{-240,370},{-200,410}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{-400,420},{-360,460}}),
        iconTransformation(extent={{-240,350},{-200,390}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ducStaPre(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-400,380},{-360,420}}),
        iconTransformation(extent={{-240,320},{-200,360}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-400,350},{-360,390}}),
        iconTransformation(extent={{-240,300},{-200,340}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{-400,320},{-360,360}}),
        iconTransformation(extent={{-240,270},{-200,310}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-400,280},{-360,320}}),
        iconTransformation(extent={{-240,250},{-200,290}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-400,240},{-360,280}}),
        iconTransformation(extent={{-240,220},{-200,260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput sumDesZonPop(
    final min=0,
    final unit="1")
    "Sum of the design population of the zones in the group"
    annotation (Placement(transformation(extent={{-400,190},{-360,230}}),
        iconTransformation(extent={{-240,190},{-200,230}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumDesPopBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the population component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-400,160},{-360,200}}),
        iconTransformation(extent={{-240,150},{-200,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumDesAreBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the area component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-400,130},{-360,170}}),
        iconTransformation(extent={{-240,130},{-200,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDesSysVenEff(
    final min=0,
    final unit="1")
    "Design system ventilation efficiency, equals to the minimum of all zones ventilation efficiency"
    annotation (Placement(transformation(extent={{-400,100},{-360,140}}),
        iconTransformation(extent={{-240,100},{-200,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumUncOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of all zones required uncorrected outdoor airflow rate"
    annotation (Placement(transformation(extent={{-400,70},{-360,110}}),
        iconTransformation(extent={{-240,70},{-200,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumSysPriAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "System primary airflow rate, equals to the sum of the measured discharged flow rate of all terminal units"
    annotation (Placement(transformation(extent={{-400,40},{-360,80}}),
        iconTransformation(extent={{-240,50},{-200,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutAirFra_max(
    final min=0,
    final unit="1")
    "Maximum zone outdoor air fraction, equals to the maximum of primary outdoor air fraction of all zones"
    annotation (Placement(transformation(extent={{-400,10},{-360,50}}),
        iconTransformation(extent={{-240,20},{-200,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") if have_separateAFMS or have_common
    "Measured outdoor volumetric airflow rate"
    annotation (Placement(transformation(extent={{-400,-20},{-360,20}}),
        iconTransformation(extent={{-240,-10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPos(
    final min=0,
    final max=1,
    final unit="1") if have_separateAFMS or have_separateDP
    "Economizer outdoor air damper position"
    annotation (Placement(transformation(extent={{-400,-60},{-360,-20}}),
        iconTransformation(extent={{-240,-40},{-200,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFanSpe(
    final min=0,
    final max=1,
    final unit="1") if have_separateAFMS or have_separateDP
    "Supply fan speed"
    annotation (Placement(transformation(extent={{-400,-90},{-360,-50}}),
        iconTransformation(extent={{-240,-70},{-200,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpMinOutDam(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") if have_separateDP
    "Measured pressure difference across the minimum outdoor air damper"
    annotation (Placement(transformation(extent={{-400,-120},{-360,-80}}),
        iconTransformation(extent={{-240,-100},{-200,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-400,-150},{-360,-110}}),
        iconTransformation(extent={{-240,-140},{-200,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-400,-180},{-360,-140}}),
        iconTransformation(extent={{-240,-160},{-200,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-400,-210},{-360,-170}}),
        iconTransformation(extent={{-240,-180},{-200,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFreSta if have_freezeStat
    "Freeze-stat signal"
    annotation (Placement(transformation(extent={{-400,-250},{-360,-210}}),
        iconTransformation(extent={{-240,-220},{-200,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFreStaRes if have_freezeStat
    "Freeze protection stat reset signal"
    annotation (Placement(transformation(extent={{-400,-290},{-360,-250}}),
        iconTransformation(extent={{-240,-240},{-200,-200}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSofSwiRes if not have_freezeStat
    "Freeze protection reset signal from software switch"
    annotation (Placement(transformation(extent={{-400,-320},{-360,-280}}),
        iconTransformation(extent={{-240,-260},{-200,-220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetFanSpe(
    final min=0,
    final max=1,
    final unit="1") if have_returns
    "Return fan speed"
    annotation (Placement(transformation(extent={{-400,-350},{-360,-310}}),
        iconTransformation(extent={{-240,-300},{-200,-260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRelFanSpe(
    final min=0,
    final max=1,
    final unit="1") if have_reliefFans
    "Relief fan speed"
    annotation (Placement(transformation(extent={{-400,-380},{-360,-340}}),
        iconTransformation(extent={{-240,-320},{-200,-280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-400,-410},{-360,-370}}),
        iconTransformation(extent={{-240,-350},{-200,-310}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling coil valve position"
    annotation (Placement(transformation(extent={{-400,-460},{-360,-420}}),
        iconTransformation(extent={{-240,-380},{-200,-340}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_heatingCoil
    "Heating coil valve position"
    annotation (Placement(transformation(extent={{-400,-490},{-360,-450}}),
        iconTransformation(extent={{-240,-400},{-200,-360}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySupFan
    "Supply fan enabling status"
    annotation (Placement(transformation(extent={{360,440},{400,480}}),
        iconTransformation(extent={{200,360},{240,400}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDesUncOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Design uncorrected minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{360,220},{400,260}}),
        iconTransformation(extent={{200,270},{240,310}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAveOutAirFraPlu
    "Average outdoor air flow fraction plus 1"
    annotation (Placement(transformation(extent={{360,190},{400,230}}),
        iconTransformation(extent={{200,240},{240,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VEffOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Effective minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{360,150},{400,190}}),
      iconTransformation(extent={{200,210},{240,250}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yReqOutAir
    "True if the AHU supply fan is on and the zone is in occupied mode"
    annotation (Placement(transformation(extent={{360,110},{400,150}}),
        iconTransformation(extent={{200,180},{240,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinOutDamPos(
    final min=0,
    final max=1,
    final unit="1") if not have_common
    "Outdoor air damper position to ensure minimum outdoor air flow"
    annotation (Placement(transformation(extent={{360,20},{400,60}}),
        iconTransformation(extent={{200,120},{240,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper position"
    annotation (Placement(transformation(extent={{360,-20},{400,20}}),
        iconTransformation(extent={{200,90},{240,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelDamPos(
    final min=0,
    final max=1,
    final unit="1")
    if have_returns and not have_directControl
    "Relief air damper position"
    annotation (Placement(transformation(extent={{360,-60},{400,-20}}),
        iconTransformation(extent={{200,60},{240,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{360,-100},{400,-60}}),
        iconTransformation(extent={{200,30},{240,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEneCHWPum
    "Energize chilled water pump"
    annotation (Placement(transformation(extent={{360,-160},{400,-120}}),
        iconTransformation(extent={{200,-20},{240,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan speed setpoint"
    annotation (Placement(transformation(extent={{360,-200},{400,-160}}),
        iconTransformation(extent={{200,-62},{240,-22}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFanSpe(
    final min=0,
    final max=1,
    final unit="1") if have_returns
    "Return fan speed setpoint"
    annotation (Placement(transformation(extent={{360,-230},{400,-190}}),
        iconTransformation(extent={{200,-90},{240,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFanSpe(
    final min=0,
    final max=1,
    final unit="1") if have_reliefFans
    "Relief fan speed setpoint"
    annotation (Placement(transformation(extent={{360,-260},{400,-220}}),
        iconTransformation(extent={{200,-120},{240,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling coil valve position"
    annotation (Placement(transformation(extent={{360,-320},{400,-280}}),
        iconTransformation(extent={{200,-170},{240,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_heatingCoil
    "Heating coil valve position"
    annotation (Placement(transformation(extent={{360,-350},{400,-310}}),
        iconTransformation(extent={{200,-200},{240,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiWatResReq
    "Chilled water reset request"
    annotation (Placement(transformation(extent={{360,-400},{400,-360}}),
        iconTransformation(extent={{200,-260},{240,-220}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiPlaReq
    "Chiller plant request"
    annotation (Placement(transformation(extent={{360,-430},{400,-390}}),
        iconTransformation(extent={{200,-300},{240,-260}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatResReq if have_heatingCoil
    "Hot water reset request"
    annotation (Placement(transformation(extent={{360,-480},{400,-440}}),
        iconTransformation(extent={{200,-340},{240,-300}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq if have_heatingCoil
    "Hot water plant request"
    annotation (Placement(transformation(extent={{360,-510},{400,-470}}),
        iconTransformation(extent={{200,-380},{240,-340}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold freProMod
    "Check if it is in freeze protection mode"
    annotation (Placement(transformation(extent={{180,-470},{200,-450}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi if have_heatingCoil
    "Hot water plant request"
    annotation (Placement(transformation(extent={{300,-500},{320,-480}})));
  Buildings.Controls.OBC.CDL.Continuous.Division VOut_flow_normalized(
    u1(final unit="m3/s"),
    u2(final unit="m3/s"),
    y(final unit="1")) if have_separateAFMS or have_common
    "Normalization of outdoor air flow intake by design minimum outdoor air intake"
    annotation (Placement(transformation(extent={{0,-16},{20,4}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.FreezeProtection frePro(
    final buiPreCon=buiPreCon,
    final minOADes=minOADes,
    final have_heatingCoil=have_heatingCoil,
    final have_freezeStat=have_freezeStat,
    final minHotWatReq=minHotWatReq,
    final heaCoiCon=freProHeaCoiCon,
    final k=kFrePro,
    final Ti=TiFrePro,
    final Td=TdFrePro,
    final yMax=yMaxFrePro,
    final yMin=yMinFrePro,
    final Thys=Thys)
    "Freeze protection"
    annotation (Placement(transformation(extent={{200,-300},{220,-260}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.PlantRequests plaReq(
    final have_heatingCoil=have_heatingCoil,
    final Thys=Thys,
    final posHys=posHys)
    "Plant requests"
    annotation (Placement(transformation(extent={{-20,-440},{0,-420}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller ecoCon(
    final minOADes=minOADes,
    final buiPreCon=buiPreCon,
    final aveTimRan=aveTimRan,
    final minSpe=minSpe,
    final minOAConTyp=minOAConTyp,
    final kMinOA=kMinOA,
    final TiMinOA=TiMinOA,
    final TdMinOA=TdMinOA,
    final dpDesOutDam_min=dpDesOutDam_min,
    final dpConTyp=dpConTyp,
    final kDp=kDp,
    final TiDp=TiDp,
    final TdDp=TdDp,
    final uMinRetDam=uMinRetDam,
    final use_enthalpy=use_enthalpy,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamFulOpeTim=retDamFulOpeTim,
    final disDel=disDel,
    final samplePeriod=samplePeriod,
    final retDamPhyPosMax=retDamPhyPosMax,
    final retDamPhyPosMin=retDamPhyPosMin,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final minOutDamPhyPosMax=minOutDamPhyPosMax,
    final minOutDamPhyPosMin=minOutDamPhyPosMin,
    final uHeaMax=uHeaMax,
    final uCooMin=uCooMin,
    final uOutDamMax=uOutDamMax,
    final uRetDamMin=uRetDamMin)
    "Economizer controller"
    annotation (Placement(transformation(extent={{80,-140},{100,-100}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyFan conSupFan(
    final have_perZonRehBox=have_perZonRehBox,
    final have_duaDucBox=have_duaDucBox,
    final have_airFloMeaSta=have_airFloMeaSta,
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
    final yFanMax=yFanMax,
    final yFanMin=yFanMin)
    "Supply fan speed setpoint"
    annotation (Placement(transformation(extent={{-220,420},{-200,440}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplySignals supSig(
    final have_heatingCoil=have_heatingCoil,
    final controllerType=valCon,
    final kTSup=kVal,
    final TiTSup=TiVal,
    final TdTSup=TdVal,
    final uHeaMax=uHeaCoiMax,
    final uCooMin=uCooCoiMin)
    "Heating and cooling valve position"
    annotation (Placement(transformation(extent={{-80,320},{-60,340}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature conTSupSet(
    final TSupCooMin=TSupCooMin,
    final TSupCooMax=TSupCooMax,
    final TOutMin=TOutMin,
    final TOutMax=TOutMax,
    final TSupWarUpSetBac=TSupWarUpSetBac,
    final delTim=delTimSupTem,
    final samplePeriod=samPerSupTem,
    final numIgnReq=ignReqSupTem,
    final triAmo=triAmoSupTem,
    final resAmo=resAmoSupTem,
    final maxRes=maxResSupTem)
    "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,360},{-140,380}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU outAirSet(
    final VPriSysMax_flow=VPriSysMax_flow,
    final peaSysPop=peaSysPop)
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(
    final nin=nZonGro)
    "Find the highest priotity operating mode"
    annotation (Placement(transformation(extent={{-300,470},{-280,490}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nZonGro]
    "Convert integer to real"
    annotation (Placement(transformation(extent={{-340,470},{-320,490}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger ahuMod
    "Air handling operating mode"
    annotation (Placement(transformation(extent={{-260,470},{-240,490}})));

protected
  parameter Boolean have_separateAFMS=
    minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
    "True: have separate minimum outdoor damper with airflow measurement";
  parameter Boolean have_separateDP=
    minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP
    "True: have separate minimum outdoor damper with differential pressure measurement";
  parameter Boolean have_common=
    minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper
    "True: have common damper";
  parameter Boolean have_returns=
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir or
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp
    "True: have return fan to control building pressure";
  parameter Boolean have_reliefs=
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper or
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "True: have relief damper or fan to control building pressure";
  parameter Boolean have_reliefFans=
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "True: have relief fan to control building pressure";
  parameter Boolean have_directControl=
    buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp
    "True: the building have direct pressure control";

equation
  connect(uOpeMod, intToRea.u)
    annotation (Line(points={{-380,480},{-342,480}}, color={255,127,0}));
  connect(intToRea.y, mulMin.u)
    annotation (Line(points={{-318,480},{-302,480}}, color={0,0,127}));
  connect(mulMin.y, ahuMod.u)
    annotation (Line(points={{-278,480},{-262,480}}, color={0,0,127}));
  connect(conSupFan.uZonPreResReq, uZonPreResReq) annotation (Line(points={{-222,
          427},{-300,427},{-300,440},{-380,440}},      color={255,127,0}));
  connect(ducStaPre, conSupFan.ducStaPre) annotation (Line(points={{-380,400},{-300,
          400},{-300,422},{-222,422}},      color={0,0,127}));
  connect(conTSupSet.TOut, TOut) annotation (Line(points={{-162,377},{-320,377},
          {-320,370},{-380,370}}, color={0,0,127}));
  connect(conTSupSet.uZonTemResReq, uZonTemResReq) annotation (Line(points={{-162,
          373},{-310,373},{-310,340},{-380,340}},      color={255,127,0}));
  connect(uSupFan, conTSupSet.uSupFan) annotation (Line(points={{-380,300},{-300,
          300},{-300,367},{-162,367}},      color={255,0,255}));
  connect(uSupFan, supSig.uSupFan) annotation (Line(points={{-380,300},{-300,300},
          {-300,336},{-82,336}},     color={255,0,255}));
  connect(conTSupSet.TSupSet, supSig.TSupSet) annotation (Line(points={{-138,370},
          {-120,370},{-120,330},{-82,330}}, color={0,0,127}));
  connect(supSig.TSup, TSup) annotation (Line(points={{-82,324},{-290,324},{-290,
          260},{-380,260}}, color={0,0,127}));
  connect(sumDesZonPop, outAirSet.sumDesZonPop) annotation (Line(points={{-380,210},
          {-160,210},{-160,119},{-82,119}}, color={0,0,127}));
  connect(VSumDesPopBreZon_flow, outAirSet.VSumDesPopBreZon_flow) annotation (
      Line(points={{-380,180},{-168,180},{-168,117},{-82,117}}, color={0,0,127}));
  connect(VSumDesAreBreZon_flow, outAirSet.VSumDesAreBreZon_flow) annotation (
      Line(points={{-380,150},{-176,150},{-176,115},{-82,115}}, color={0,0,127}));
  connect(uDesSysVenEff, outAirSet.uDesSysVenEff) annotation (Line(points={{-380,
          120},{-182,120},{-182,113},{-82,113}}, color={0,0,127}));
  connect(VSumUncOutAir_flow, outAirSet.VSumUncOutAir_flow) annotation (Line(
        points={{-380,90},{-182,90},{-182,111},{-82,111}}, color={0,0,127}));
  connect(VSumSysPriAir_flow, outAirSet.VSumSysPriAir_flow) annotation (Line(
        points={{-380,60},{-176,60},{-176,109},{-82,109}}, color={0,0,127}));
  connect(uOutAirFra_max, outAirSet.uOutAirFra_max) annotation (Line(points={{-380,30},
          {-168,30},{-168,107},{-82,107}},       color={0,0,127}));
  connect(uSupFan, outAirSet.uSupFan) annotation (Line(points={{-380,300},{-300,
          300},{-300,103},{-82,103}}, color={255,0,255}));
  connect(ahuMod.y, conSupFan.uOpeMod) annotation (Line(points={{-238,480},{-230,
          480},{-230,438},{-222,438}},      color={255,127,0}));
  connect(ahuMod.y, conTSupSet.uOpeMod) annotation (Line(points={{-238,480},{-230,
          480},{-230,363},{-162,363}},      color={255,127,0}));
  connect(ahuMod.y, outAirSet.uOpeMod) annotation (Line(points={{-238,480},{-230,
          480},{-230,101},{-82,101}},   color={255,127,0}));
  connect(conSupFan.ySupFan, ySupFan) annotation (Line(points={{-198,437},{-110,
          437},{-110,460},{380,460}},color={255,0,255}));
  connect(plaReq.yChiWatResReq, yChiWatResReq) annotation (Line(points={{2,-422},
          {280,-422},{280,-380},{380,-380}},       color={255,127,0}));
  connect(plaReq.yChiPlaReq, yChiPlaReq) annotation (Line(points={{2,-427},{292,
          -427},{292,-410},{380,-410}},     color={255,127,0}));
  connect(plaReq.yHotWatResReq, yHotWatResReq) annotation (Line(points={{2,-433},
          {292,-433},{292,-460},{380,-460}},       color={255,127,0}));
  connect(plaReq.uCooCoi, uCooCoi) annotation (Line(points={{-22,-433},{-290,-433},
          {-290,-440},{-380,-440}},       color={0,0,127}));
  connect(uHeaCoi, plaReq.uHeaCoi) annotation (Line(points={{-380,-470},{-280,-470},
          {-280,-438},{-22,-438}},      color={0,0,127}));
  connect(outAirSet.effOutAir_normalized, ecoCon.VOutMinSet_flow_normalized)
    annotation (Line(points={{-58,105},{42,105},{42,-101},{78,-101}}, color={0,0,
          127}));
  connect(VOut_flow, VOut_flow_normalized.u1)
    annotation (Line(points={{-380,0},{-2,0}}, color={0,0,127}));
  connect(outAirSet.VDesOutAir_flow, VOut_flow_normalized.u2) annotation (Line(
        points={{-58,112},{-40,112},{-40,-12},{-2,-12}}, color={0,0,127}));
  connect(VOut_flow_normalized.y, ecoCon.VOut_flow_normalized) annotation (Line(
        points={{22,-6},{34,-6},{34,-104},{78,-104}}, color={0,0,127}));
  connect(ecoCon.uOutDamPos, uOutDamPos) annotation (Line(points={{78,-107},{26,
          -107},{26,-40},{-380,-40}}, color={0,0,127}));
  connect(ecoCon.uSupFanSpe, uSupFanSpe) annotation (Line(points={{78,-110},{18,
          -110},{18,-70},{-380,-70}}, color={0,0,127}));
  connect(ecoCon.dpMinOutDam, dpMinOutDam) annotation (Line(points={{78,-113},{10,
          -113},{10,-100},{-380,-100}}, color={0,0,127}));
  connect(supSig.uTSup, ecoCon.uTSup) annotation (Line(points={{-58,336},{-32,336},
          {-32,-116},{78,-116}}, color={0,0,127}));
  connect(TOut, ecoCon.TOut) annotation (Line(points={{-380,370},{-320,370},{-320,
          -122},{78,-122}}, color={0,0,127}));
  connect(TOutCut, ecoCon.TOutCut) annotation (Line(points={{-380,-130},{28,-130},
          {28,-124},{78,-124}}, color={0,0,127}));
  connect(ecoCon.hOut, hOut) annotation (Line(points={{78,-127},{34,-127},{34,-160},
          {-380,-160}}, color={0,0,127}));
  connect(hOutCut, ecoCon.hOutCut) annotation (Line(points={{-380,-190},{40,-190},
          {40,-129},{78,-129}}, color={0,0,127}));
  connect(uSupFan, ecoCon.uSupFan) annotation (Line(points={{-380,300},{-300,300},
          {-300,-133},{78,-133}}, color={255,0,255}));
  connect(ahuMod.y, ecoCon.uOpeMod) annotation (Line(points={{-238,480},{-230,480},
          {-230,-136},{78,-136}}, color={255,127,0}));
  connect(ecoCon.yOutDamPosMin, frePro.uOutDamPosMin) annotation (Line(points={{
          102,-102},{120,-102},{120,-261},{198,-261}}, color={0,0,127}));
  connect(TSup, frePro.TSup) annotation (Line(points={{-380,260},{-290,260},{-290,
          -275},{198,-275}}, color={0,0,127}));
  connect(frePro.uFreSta, uFreSta) annotation (Line(points={{198,-278},{104,-278},
          {104,-230},{-380,-230}}, color={255,0,255}));
  connect(frePro.uFreStaRes, uFreStaRes) annotation (Line(points={{198,-281},{96,
          -281},{96,-270},{-380,-270}}, color={255,0,255}));
  connect(frePro.uSofSwiRes, uSofSwiRes) annotation (Line(points={{198,-284},{120,
          -284},{120,-300},{-380,-300}}, color={255,0,255}));
  connect(uRetFanSpe, frePro.uRetFanSpe) annotation (Line(points={{-380,-330},{128,
          -330},{128,-290},{198,-290}}, color={0,0,127}));
  connect(frePro.uRelFanSpe, uRelFanSpe) annotation (Line(points={{198,-293},{136,
          -293},{136,-360},{-380,-360}}, color={0,0,127}));
  connect(frePro.TMix, TMix) annotation (Line(points={{198,-299},{144,-299},{144,
          -390},{-380,-390}}, color={0,0,127}));
  connect(outAirSet.VDesUncOutAir_flow, VDesUncOutAir_flow) annotation (Line(
        points={{-58,118},{230,118},{230,240},{380,240}}, color={0,0,127}));
  connect(outAirSet.yAveOutAirFraPlu, yAveOutAirFraPlu) annotation (Line(points=
         {{-58,115},{240,115},{240,210},{380,210}}, color={0,0,127}));
  connect(outAirSet.VEffOutAir_flow, VEffOutAir_flow) annotation (Line(points={{
          -58,108},{250,108},{250,170},{380,170}}, color={0,0,127}));
  connect(outAirSet.yReqOutAir, yReqOutAir) annotation (Line(points={{-58,102},{
          260,102},{260,130},{380,130}}, color={255,0,255}));
  connect(ecoCon.yRelDamPos, yRelDamPos) annotation (Line(points={{102,-126},{300,
          -126},{300,-40},{380,-40}}, color={0,0,127}));
  connect(frePro.yFreProSta, ecoCon.uFreProSta) annotation (Line(points={{222,-295},
          {240,-295},{240,-160},{46,-160},{46,-139},{78,-139}}, color={255,127,0}));
  connect(ecoCon.yOutDamPos, frePro.uOutDamPos) annotation (Line(points={{102,-132},
          {128,-132},{128,-263},{198,-263}}, color={0,0,127}));
  connect(ecoCon.yRetDamPos, frePro.uRetDamPos) annotation (Line(points={{102,-114},
          {136,-114},{136,-272},{198,-272}}, color={0,0,127}));
  connect(supSig.yHea, frePro.uHeaCoi) annotation (Line(points={{-58,330},{152,330},
          {152,-266},{198,-266}}, color={0,0,127}));
  connect(conSupFan.ySupFanSpe, frePro.uSupFanSpe) annotation (Line(points={{-198,
          430},{-110,430},{-110,-287},{198,-287}}, color={0,0,127}));
  connect(supSig.yCoo, frePro.uCooCoi) annotation (Line(points={{-58,324},{144,324},
          {144,-296},{198,-296}}, color={0,0,127}));
  connect(TSup, plaReq.TSup) annotation (Line(points={{-380,260},{-290,260},{-290,
          -422},{-22,-422}}, color={0,0,127}));
  connect(conTSupSet.TSupSet, plaReq.TSupSet) annotation (Line(points={{-138,370},
          {-120,370},{-120,-427},{-22,-427}}, color={0,0,127}));
  connect(frePro.yEneCHWPum, yEneCHWPum) annotation (Line(points={{222,-261},{316,
          -261},{316,-140},{380,-140}}, color={255,0,255}));
  connect(frePro.yRetDamPos, yRetDamPos) annotation (Line(points={{222,-265},{292,
          -265},{292,0},{380,0}}, color={0,0,127}));
  connect(frePro.yOutDamPos, yOutDamPos) annotation (Line(points={{222,-269},{308,
          -269},{308,-80},{380,-80}}, color={0,0,127}));
  connect(ecoCon.yMinOutDamPos, frePro.uMinOutDamPos) annotation (Line(points={{
          102,-107},{112,-107},{112,-269},{198,-269}}, color={0,0,127}));
  connect(frePro.yMinOutDamPos, yMinOutDamPos) annotation (Line(points={{222,-273},
          {282,-273},{282,40},{380,40}}, color={0,0,127}));
  connect(frePro.ySupFanSpe, ySupFanSpe) annotation (Line(points={{222,-277},{324,
          -277},{324,-180},{380,-180}}, color={0,0,127}));
  connect(frePro.yRetFanSpe, yRetFanSpe) annotation (Line(points={{222,-281},{332,
          -281},{332,-210},{380,-210}}, color={0,0,127}));
  connect(frePro.yCooCoi, yCooCoi) annotation (Line(points={{222,-289},{340,-289},
          {340,-300},{380,-300}}, color={0,0,127}));
  connect(frePro.yHeaCoi, yHeaCoi) annotation (Line(points={{222,-292},{332,-292},
          {332,-330},{380,-330}}, color={0,0,127}));
  connect(intSwi.y, yHotWatPlaReq)
    annotation (Line(points={{322,-490},{380,-490}}, color={255,127,0}));
  connect(frePro.yHotWatPlaReq, intSwi.u1) annotation (Line(points={{222,-297},{
          232,-297},{232,-482},{298,-482}}, color={255,127,0}));
  connect(plaReq.yHotWatPlaReq, intSwi.u3) annotation (Line(points={{2,-438},{160,
          -438},{160,-498},{298,-498}}, color={255,127,0}));
  connect(frePro.yFreProSta, freProMod.u) annotation (Line(points={{222,-295},{240,
          -295},{240,-400},{170,-400},{170,-460},{178,-460}}, color={255,127,0}));
  connect(freProMod.y, intSwi.u2) annotation (Line(points={{202,-460},{220,-460},
          {220,-490},{298,-490}}, color={255,0,255}));

  connect(frePro.yRelFanSpe, yRelFanSpe) annotation (Line(points={{222,-285},{340,
          -285},{340,-240},{380,-240}}, color={0,0,127}));
annotation (
  defaultComponentName="mulAHUCon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-400},{200,400}}),
    graphics={
      Rectangle(extent={{200,400},{-200,-400}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
       Text(extent={{-200,480},{200,400}},
          textString="%name",
          lineColor={0,0,255}),
       Text(extent={{-196,182},{-74,158}},
          lineColor={0,0,0},
          textString="VSumDesPopBreZon_flow"),
       Text(extent={{-196,160},{-70,138}},
          lineColor={0,0,0},
          textString="VSumDesAreBreZon_flow"),
       Text(extent={{-194,218},{-112,202}},
          lineColor={0,0,0},
          textString="sumDesZonPop"),
       Text(extent={{-200,246},{-162,230}},
          lineColor={0,0,0},
          textString="TSup"),
       Text(extent={{-198,326},{-164,310}},
          lineColor={0,0,0},
          textString="TOut"),
       Text(extent={{-194,350},{-140,334}},
          lineColor={0,0,0},
          textString="ducStaPre"),
       Text(extent={{-196,128},{-114,112}},
          lineColor={0,0,0},
          textString="uDesSysVenEff"),
       Text(extent={{-194,98},{-88,80}},
          lineColor={0,0,0},
          textString="VSumUncOutAir_flow"),
       Text(extent={{-198,76},{-88,60}},
          lineColor={0,0,0},
          textString="VSumSysPriAir_flow"),
       Text(extent={{-194,50},{-112,34}},
          lineColor={0,0,0},
          textString="uOutAirFra_max"),
       Text(extent={{-196,18},{-138,0}},
          lineColor={0,0,0},
          textString="VOut_flow",
          visible=have_separateAFMS or have_common),
       Text(extent={{-196,-10},{-126,-30}},
          lineColor={0,0,0},
          textString="uOutDamPos",
          visible=have_separateAFMS or have_separateDP),
       Text(extent={{-198,-42},{-122,-60}},
          lineColor={0,0,0},
          textString="uSupFanSpe",
          visible=have_separateAFMS or have_separateDP),
       Text(extent={{-198,-70},{-116,-88}},
          lineColor={0,0,0},
          textString="dpMinOutDam",
          visible=have_separateDP),
       Text(extent={{-196,-110},{-148,-128}},
          lineColor={0,0,0},
          textString="TOutCut"),
       Text(extent={{-198,-130},{-162,-148}},
          lineColor={0,0,0},
          textString="hOut",
          visible=use_enthalpy),
       Text(extent={{-198,-150},{-146,-168}},
          lineColor={0,0,0},
          textString="hOutCut",
          visible=use_enthalpy),
       Text(extent={{-200,-268},{-128,-284}},
          lineColor={0,0,0},
          textString="uRetFanSpe",
          visible=have_returns),
       Text(extent={{-200,-290},{-122,-308}},
          lineColor={0,0,0},
          textString="uRelFanSpe",
          visible=have_reliefFans),
       Text(extent={{-200,-320},{-160,-338}},
          lineColor={0,0,0},
          textString="TMix"),
       Text(extent={{-198,-348},{-146,-366}},
          lineColor={0,0,0},
          textString="uCooCoi"),
       Text(extent={{-202,-370},{-140,-388}},
          lineColor={0,0,0},
          textString="uHeaCoi",
          visible=have_heatingCoil),
       Text(extent={{140,-170},{202,-188}},
          lineColor={0,0,0},
          textString="yHeaCoi",
          visible=have_heatingCoil),
       Text(extent={{138,-142},{200,-160}},
          lineColor={0,0,0},
          textString="yCooCoi"),
       Text(extent={{122,-90},{204,-106}},
          lineColor={0,0,0},
          textString="yRelFanSpe",
          visible=have_reliefFans),
       Text(extent={{120,-62},{202,-78}},
          lineColor={0,0,0},
          textString="yRetFanSpe",
          visible=have_returns),
       Text(extent={{118,-32},{200,-48}},
          lineColor={0,0,0},
          textString="ySupFanSpe"),
       Text(extent={{120,60},{202,44}},
          lineColor={0,0,0},
          textString="yOutDamPos"),
       Text(extent={{120,90},{202,74}},
          lineColor={0,0,0},
          textString="yRelDamPos",
          visible=have_returns and not have_directControl),
       Text(extent={{118,120},{202,104}},
          lineColor={0,0,0},
          textString="yRetDamPos"),
       Text(extent={{100,150},{198,132}},
          lineColor={0,0,0},
          textString="yMinOutDamPos",
          visible=not have_common),
       Text(extent={{118,238},{200,222}},
          lineColor={0,0,0},
          textString="VEffOutAir_flow"),
       Text(extent={{96,270},{200,252}},
          lineColor={0,0,0},
          textString="yAveOutAirFraPlu"),
       Text(extent={{78,302},{200,284}},
          lineColor={0,0,0},
          textString="VDesUncOutAir_flow"),
       Text(extent={{-196,400},{-148,378}},
          lineColor={255,127,0},
          textString="uOpeMod"),
       Text(extent={{-196,382},{-114,358}},
          lineColor={255,127,0},
          textString="uZonPreResReq"),
       Text(extent={{-194,300},{-106,280}},
          lineColor={255,127,0},
          textString="uZonTemResReq"),
       Text(extent={{106,-228},{194,-248}},
          lineColor={255,127,0},
          textString="yChiWatResReq"),
       Text(extent={{124,-268},{202,-286}},
          lineColor={255,127,0},
          textString="yChiPlaReq"),
       Text(extent={{108,-308},{196,-328}},
          lineColor={255,127,0},
          textString="yHotWatResReq",
          visible=have_heatingCoil),
       Text(extent={{108,-348},{196,-368}},
          lineColor={255,127,0},
          textString="yHotWatPlaReq",
          visible=have_heatingCoil),
       Text(extent={{120,210},{208,192}},
          lineColor={255,0,255},
          textString="yReqOutAir"),
       Text(extent={{136,392},{204,372}},
          lineColor={255,0,255},
          textString="ySupFan"),
       Text(extent={{-202,280},{-134,260}},
          lineColor={255,0,255},
          textString="uSupFan"),
       Text(extent={{-200,-188},{-146,-208}},
          lineColor={255,0,255},
          textString="uFreSta",
          visible=have_freezeStat),
       Text(extent={{-196,-208},{-128,-228}},
          lineColor={255,0,255},
          textString="uFreStaRes",
          visible=have_freezeStat),
       Text(extent={{-198,-228},{-124,-248}},
          lineColor={255,0,255},
          textString="uSofSwiRes",
          visible=not have_freezeStat),
       Text(extent={{112,10},{200,-8}},
          lineColor={255,0,255},
          textString="yEneCHWPum")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-360,-520},{360,520}})),
  Documentation(info="<html>
<p>
Block that is applied for multizone VAV AHU control. It outputs the supply fan status
and the operation speed, outdoor and return air damper position, supply air
temperature setpoint and the valve position of the cooling and heating coils.
It is implemented according to the Section 5.16 of ASHRAE Guideline 36, May 2020.
</p>
<p>
The sequence consists of seven subsequences.
</p>
<h4>Supply fan speed control</h4>
<p>
The fan speed control is implemented according to Section 5.16.1. It outputs
the boolean signal <code>ySupFan</code> to turn on or off the supply fan.
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
</p>
<h4>Freeze protection</h4>
<p>
Based on the Section 5.16.12, the sequence enables freeze protection if the
measured supply air temperature belows certain thresholds. There are three
protection stages. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.FreezeProtection\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.FreezeProtection</a>
</p>
<h4>Plant request</h4>
<p>
According to the Section 5.16.16, the sequence send out heating or cooling plant requests
if the supply air temperature is below or above threshold value, or the heating or
cooling valves have been widely open for certain times. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.PlantRequests\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.PlantRequests</a>
for more detailed description.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 20, 2021, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
