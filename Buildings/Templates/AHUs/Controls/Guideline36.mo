within Buildings.Templates.AHUs.Controls;
block Guideline36 "Guideline 36 VAV single duct controller"
  extends Buildings.Templates.BaseClasses.Controls.AHUs.SingleDuct(
    final typ=Templates.Types.ControllerAHU.Guideline36);

  parameter String namGroZon[nZon] = {
    dat.getString(varName=idTerArr[i] + ".Identification.Zone group name.value")
    for i in 1:nZon}
    "Name of group which each zone belongs to"
    annotation(Evaluate=true);

  final parameter Boolean groZonMsk[nGro, nZon] = {
    {namGroZon[gro] == namGro[zon] for zon in 1:nZon}
    for gro in 1:nGro}
    "Array of zone group masks" annotation(Evaluate=true);

  final parameter Integer nZonGro[nGro] = {
    Modelica.Math.BooleanVectors.countTrue({
      namGroZon[j] == namGro[i] for j in 1:nZon})
    for i in 1:nGro}
    "Number of zones that each group contains"
    annotation(Evaluate=true);

  /*
  *  Parameters for Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller
  */

  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time")=120
    "Sample period of component, set to the same value as the trim and respond sequence";

  final parameter Boolean have_perZonRehBox = Modelica.Math.BooleanVectors.anyTrue({
      dat.getBoolean(varName=idTerArr[i] + ".Control.Zone Perimeter zone.value")
      for i in 1:nZon})
    "Check if there is any VAV-reheat boxes on perimeter zones"
    annotation (Dialog(group="System and building parameters"));

  final parameter Boolean have_duaDucBox = Modelica.Math.BooleanVectors.anyTrue({
      Modelica.Utilities.Strings.find(
        dat.getString(varName=idTerArr[i] + ".Identification.Type.value"),
        "dual",
        caseSensitive=false) <> 0
      for i in 1:nZon})
    "Check if the AHU serves dual duct boxes"
    annotation (Dialog(group="System and building parameters"));

  outer parameter Boolean have_airFloMeaSta
    "Check if the AHU has supply airflow measuring station"
    annotation (Dialog(group="System and building parameters"));

  // ----------- Parameters for economizer control -----------
  parameter Boolean use_enthalpy=false
    "Set to true if enthalpy measurement is used in addition to temperature measurement"
    annotation (Dialog(tab="Economizer"));

  parameter Real delta(
    final unit="s",
    final quantity="Time")=5
    "Time horizon over which the outdoor air flow measurment is averaged"
    annotation (Dialog(tab="Economizer"));

  parameter Real delTOutHis(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation (Dialog(tab="Economizer"));

  parameter Real delEntHis(
    final unit="J/kg",
    final quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation (Dialog(tab="Economizer", enable=use_enthalpy));

  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper"
    annotation (Dialog(tab="Economizer", group="Damper limits"));

  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation (Dialog(tab="Economizer", group="Damper limits"));

  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Damper limits"));

  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Damper limits"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMinOut=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Economizer PID controller"));

  parameter Real kMinOut(final unit="1")=0.05
    "Gain of controller for minimum outdoor air intake"
    annotation (Dialog(group="Economizer PID controller"));

  parameter Real TiMinOut(
    final unit="s",
    final quantity="Time")=120
    "Time constant of controller for minimum outdoor air intake"
    annotation (Dialog(group="Economizer PID controller",
      enable=controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdMinOut(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for minimum outdoor air intake"
    annotation (Dialog(group="Economizer PID controller",
      enable=controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Boolean use_TMix=true
    "Set to true if mixed air temperature measurement is enabled"
     annotation(Dialog(group="Economizer freeze protection"));

  parameter Boolean use_G36FrePro=false
    "Set to true to use G36 freeze protection"
    annotation(Dialog(group="Economizer freeze protection"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeFre=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Economizer freeze protection", enable=use_TMix));

  parameter Real kFre(final unit="1/K") = 0.1
    "Gain for mixed air temperature tracking for freeze protection, used if use_TMix=true"
     annotation(Dialog(group="Economizer freeze protection", enable=use_TMix));

  parameter Real TiFre(
    final unit="s",
    final quantity="Time",
    final max=TiMinOut)=120
    "Time constant of controller for mixed air temperature tracking for freeze protection. Require TiFre <= TiMinOut"
     annotation(Dialog(group="Economizer freeze protection",
       enable=use_TMix
         and (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real TdFre(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for freeze protection"
    annotation (Dialog(group="Economizer freeze protection",
      enable=use_TMix and
          (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real TFreSet(
     final unit="K",
     final displayUnit="degC",
     final quantity="ThermodynamicTemperature")= 279.15
    "Lower limit for mixed air temperature for freeze protection, used if use_TMix=true"
     annotation(Dialog(group="Economizer freeze protection", enable=use_TMix));

  parameter Real retDamFulOpeTim(
    final unit="s",
    final quantity="Time")=180
    "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations"
    annotation (Dialog(tab="Economizer", group="Economizer delays at disable"));

  parameter Real disDel(
    final unit="s",
    final quantity="Time")=15
    "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
    annotation (Dialog(tab="Economizer", group="Economizer delays at disable"));

  // ----------- parameters for fan speed control  -----------
  parameter Real pIniSet(
    final unit="Pa",
    final displayUnit="Pa",
    final quantity="PressureDifference")=60
    "Initial pressure setpoint for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Real pMinSet(
    final unit="Pa",
    final displayUnit="Pa",
    final quantity="PressureDifference")=25
    "Minimum pressure setpoint for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Real pMaxSet(
    final unit="Pa",
    final displayUnit="Pa",
    final quantity="PressureDifference")=
    dat.getReal(varName=id + ".Control.Airflow.Duct Design Maximum Static Pressure")
    "Maximum pressure setpoint for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Real pDelTim(
    final unit="s",
    final quantity="Time")=600
    "Delay time after which trim and respond is activated"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Integer pNumIgnReq=2
    "Number of ignored requests for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Real pTriAmo(
    final unit="Pa",
    final displayUnit="Pa",
    final quantity="PressureDifference")=-12.0
    "Trim amount for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Real pResAmo(
    final unit="Pa",
    final displayUnit="Pa",
    final quantity="PressureDifference")=15
    "Respond amount (must be opposite in to triAmo) for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Real pMaxRes(
    final unit="Pa",
    final displayUnit="Pa",
    final quantity="PressureDifference")=32
    "Maximum response per time interval (same sign as resAmo) for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Fan speed PID controller"));

  parameter Real kFanSpe(final unit="1")=0.1
    "Gain of fan fan speed controller, normalized using pMaxSet"
    annotation (Dialog(group="Fan speed PID controller"));

  parameter Real TiFanSpe(
    final unit="s",
    final quantity="Time")=60
    "Time constant of integrator block for fan speed"
    annotation (Dialog(group="Fan speed PID controller",
      enable=controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdFanSpe(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for fan speed"
    annotation (Dialog(group="Fan speed PID controller",
      enable=controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real yFanMax = dat.getReal(varName=id + ".Control.Airflow.Maximum Fan Speed - Supply fan")
    "Maximum allowed fan speed"
    annotation (Dialog(group="Fan speed PID controller"));

  parameter Real yFanMin = dat.getReal(varName=id + ".Control.Airflow.Minimum Fan Speed - Supply fan")
    "Lowest allowed fan speed if fan is on"
    annotation (Dialog(group="Fan speed PID controller"));

  // ----------- parameters for minimum outdoor airflow setting  -----------
  parameter Real VPriSysMax_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=
    dat.getReal(varName=id + ".Control.Maximum expected system primary airflow at design stage")
    "Maximum expected system primary airflow at design stage"
    annotation (Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

  parameter Real peaSysPop=
    dat.getReal(varName=id + ".Control.Peak system population")
    "Peak system population"
    annotation (Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

  // ----------- parameters for supply air temperature control  -----------
  parameter Real TSupSetMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".Control.Supply air temperature.Lowest cooling set point")
    "Lowest cooling supply air temperature setpoint"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Real TSupSetMax(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".Control.Supply air temperature.Highest cooling set point")
    "Highest cooling supply air temperature setpoint. It is typically 18 degC (65 degF) in mild and dry climates, 16 degC (60 degF) or lower in humid climates"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  // FIXME: what is that?
  parameter Real TSupSetDes(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=286.15
    "Nominal supply air temperature setpoint"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Real TOutMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".Control.Supply air temperature.Lower value of OAT reset range")
    "Lower value of the outdoor air temperature reset range. Typically value is 16 degC (60 degF)"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Real TOutMax(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".Control.Supply air temperature.Higher value of OAT reset range")
    "Higher value of the outdoor air temperature reset range. Typically value is 21 degC (70 degF)"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Real iniSetSupTem(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=TSupSetMax
    "Initial setpoint for supply temperature control"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Real maxSetSupTem(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=TSupSetMax
    "Maximum setpoint for supply temperature control"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Real minSetSupTem(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=TSupSetDes
    "Minimum setpoint for supply temperature control"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Real delTimSupTem(
    final unit="s",
    final quantity="Time")=600
    "Delay timer for supply temperature control"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Integer numIgnReqSupTem=2
    "Number of ignorable requests for supply temperature control"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Real triAmoSupTem(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=0.1
    "Trim amount for supply temperature control"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Real resAmoSupTem(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=-0.2
    "Response amount for supply temperature control"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Real maxResSupTem(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=-0.6
    "Maximum response per time interval for supply temperature control"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeTSup=
      Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for supply air temperature signal"
    annotation (Dialog(group="Supply air temperature"));

  parameter Real kTSup(final unit="1/K")=0.05
    "Gain of controller for supply air temperature signal"
    annotation (Dialog(group="Supply air temperature"));

  parameter Real TiTSup(
    final unit="s",
    final quantity="Time")=600
    "Time constant of integrator block for supply air temperature control signal"
    annotation (Dialog(group="Supply air temperature",
      enable=controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdTSup(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of integrator block for supply air temperature control signal"
    annotation (Dialog(group="Supply air temperature",
      enable=controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real uHeaMax(min=-0.9)=-0.25
    "Upper limit of controller signal when heating coil is off. Require -1 < uHeaMax < uCooMin < 1."
    annotation (Dialog(group="Supply air temperature"));

  parameter Real uCooMin(max=0.9)=0.25
    "Lower limit of controller signal when cooling coil is off. Require -1 < uHeaMax < uCooMin < 1."
    annotation (Dialog(group="Supply air temperature"));

  /*
  * Parameters for Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
  */

  // Those are assumed identical for all zone groups.

  parameter Real preWarCooTim(
    final unit="s",
    final quantity="Time") = 10800
    "Maximum cool-down or warm-up time";

  parameter Real TZonFreProOn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=277.15
    "Threshold temperature to activate the freeze protection mode";

  parameter Real TZonFreProOff(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=280.15
    "Threshold temperature to end the freeze protection mode";

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU(
    final samplePeriod=samplePeriod,
    final have_perZonRehBox=have_perZonRehBox,
    final have_duaDucBox=have_duaDucBox,
    final have_airFloMeaSta=have_airFloMeaSta,
    final use_enthalpy=use_enthalpy,
    final delta=delta,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamPhyPosMax=retDamPhyPosMax,
    final retDamPhyPosMin=retDamPhyPosMin,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final controllerTypeMinOut=controllerTypeMinOut,
    final kMinOut=kMinOut,
    final TiMinOut=TiMinOut,
    final TdMinOut=TdMinOut,
    final use_TMix=use_TMix,
    final use_G36FrePro=use_G36FrePro,
    final controllerTypeFre=controllerTypeFre,
    final kFre=kFre,
    final TiFre=TiFre,
    final TdFre=TdFre,
    final TFreSet=TFreSet,
    final retDamFulOpeTim=retDamFulOpeTim,
    final disDel=disDel,
    final pIniSet=pIniSet,
    final pMinSet=pMinSet,
    final pMaxSet=pMaxSet,
    final pDelTim=pDelTim,
    final pNumIgnReq=pNumIgnReq,
    final pTriAmo=pTriAmo,
    final pResAmo=pResAmo,
    final pMaxRes=pMaxRes,
    final kFanSpe=kFanSpe,
    final TiFanSpe=TiFanSpe,
    final TdFanSpe=TdFanSpe,
    final yFanMax=yFanMax,
    final yFanMin=yFanMin,
    final VPriSysMax_flow=VPriSysMax_flow,
    final TSupSetMin=TSupSetMin,
    final TSupSetMax=TSupSetMax,
    final TSupSetDes=TSupSetDes,
    final TOutMin=TOutMin,
    final TOutMax=TOutMax,
    final iniSetSupTem=iniSetSupTem,
    final maxSetSupTem=maxSetSupTem,
    final minSetSupTem=minSetSupTem,
    final delTimSupTem=delTimSupTem,
    final numIgnReqSupTem=numIgnReqSupTem,
    final triAmoSupTem=triAmoSupTem,
    final resAmoSupTem=resAmoSupTem,
    final maxResSupTem=maxResSupTem,
    final controllerTypeTSup=controllerTypeTSup,
    final kTSup=kTSup,
    final TiTSup=TiTSup,
    final TdTSup=TdTSup,
    final uHeaMax=uHeaMax,
    final uCooMin=uCooMin)
    "AHU controller"
    annotation (Placement(transformation(extent={{-40,8},{40,152}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToSys(final numZon=nZon)
    "Sum up zone calculation output"
    annotation (Placement(transformation(extent={{20,-60},{0,-40}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus zonGroSta[nGro](
    each final numZon=nZon,
    final nZonGro=nZonGro,
    final inZon=groZonMsk)
    "Evaluate zone group status"
    annotation (Placement(transformation(extent={{-60,-180},{-80,-140}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode opeModSel[nGro](
    final numZon=nZonGro,
    each final preWarCooTim=preWarCooTim,
    each final TZonFreProOn=TZonFreProOn,
    each final TZonFreProOff=TZonFreProOff)
    "Operation mode selection for each zone group"
    annotation (Placement(transformation(extent={{-80,-134},{-60,-102}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME1(k=24 + 273.15)
    "Where is the use of the average zone set point described?"
    annotation (Placement(transformation(extent={{260,190},{240,210}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator TSupSet(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{160,-110},{180,-90}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator VDesUncOutAir_flow(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{160,94},{180,114}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator yReqOutAir(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{160,58},{180,78}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqZonTemRes(
    final k=fill(1, nZon),
    final nin=nZon)
    "Sum up signals"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqZonPreRes(
    final k=fill(1, nZon),
    final nin=nZon)
    "Sum up signals"
    annotation (Placement(transformation(extent={{-140,8},{-120,28}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME4(k=24 + 273.15)
  "To be determined determined by the control sequence based on energy standard, climate zone, and economizer high-limit-control device type"
    annotation (Placement(transformation(extent={{200,212},{180,232}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME5(k=1)
    "Various economizer configurations not handled: yDamRel (or exhaust), yDamOutMin"
    annotation (Placement(transformation(extent={{300,114},{280,134}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME6(k=1)
    "Various fan configurations not handled: yFanRet (or relief)"
    annotation (Placement(transformation(extent={{300,170},{280,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant    FIXME7(k=true)
    "Various fan configurations not handled: yFanRet (or relief)"
    annotation (Placement(transformation(extent={{260,110},{240,130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant FIXME8(k=1)
    "Convert zone group mode into AHU system mode per 5.15"
    annotation (Placement(transformation(extent={{260,-90},{240,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant  FIXME9(k=true)
    "Various economizer configurations not handled: yDamRel (or exhaust), yDamOutMin"
    annotation (Placement(transformation(extent={{300,142},{280,162}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatusDuplicator
    zonStaDup "Zone status duplicator"
    annotation (Placement(transformation(extent={{-20,-180},{-28,-140}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneGroupFilter
    zonGroFil[nGro]
    annotation (Placement(transformation(extent={{-40,-180},{-48,-140}})));
protected
    BaseClasses.Connectors.SubBusOutput busOutAHU
    "AHU output points"
    annotation (
      Placement(
        transformation(extent={{80,140},{120,180}}),
                                                   iconTransformation(extent={{-10,24},
            {10,44}})));

// DEBUG
Buildings.Controls.OBC.CDL.Logical.Sources.Constant zonOcc(k=true);
Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOcc(k=true);
Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tNexOcc(k=1);
Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uCooTim(k=1);
Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uWarTim(k=1);
Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOccHeaHig(k=true);
Buildings.Controls.OBC.CDL.Logical.Sources.Constant uHigOccCoo(k=true);
Buildings.Controls.OBC.CDL.Logical.Sources.Constant uUnoHeaHig(k=true);
Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaSetOff(k=1);
Buildings.Controls.OBC.CDL.Logical.Sources.Constant uEndSetBac(k=true);
Buildings.Controls.OBC.CDL.Logical.Sources.Constant uHigUnoCoo(k=true);
Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCooSetOff(k=1);
Buildings.Controls.OBC.CDL.Logical.Sources.Constant uEndSetUp(k=true);
Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(k=1);
Buildings.Controls.OBC.CDL.Logical.Sources.Constant uWin(k=true);

equation
  // DEBUG
  for ig in 1:nGro loop
    for izg in 1:nZonGro[ig] loop
        connect(zonOcc.y, zonGroSta[ig].zonOcc[izg]);
        connect(uOcc.y, zonGroSta[ig].uOcc[izg]);
        connect(tNexOcc.y, zonGroSta[ig].tNexOcc[izg]);
        connect(uCooTim.y, zonGroSta[ig].uCooTim[izg]);
        connect(uWarTim.y, zonGroSta[ig].uWarTim[izg]);
        connect(uOccHeaHig.y, zonGroSta[ig].uOccHeaHig[izg]);
        connect(uHigOccCoo.y, zonGroSta[ig].uHigOccCoo[izg]);
        connect(THeaSetOff.y, zonGroSta[ig].THeaSetOff[izg]);
        connect(uUnoHeaHig.y, zonGroSta[ig].uUnoHeaHig[izg]);
        connect(uEndSetBac.y, zonGroSta[ig].uEndSetBac[izg]);
        connect(TCooSetOff.y, zonGroSta[ig].TCooSetOff[izg]);
        connect(uHigUnoCoo.y, zonGroSta[ig].uHigUnoCoo[izg]);
        connect(uEndSetUp.y, zonGroSta[ig].uEndSetUp[izg]);
        connect(uWin.y, zonGroSta[ig].uWin[izg]);
        connect(TZon.y, zonGroSta[ig].TZon[izg]);
    end for;
  end for;

//   for ig in 1:nGro loop
//     for izg in 1:nZonGro[ig] loop
//       for iz in 1:nZon loop
//         if idxGroZon[iz] == ig then
//           connect(opeModSel[ig].yOpeMod, busSofTer[iz].yOpeMod);
//           connect(busSofTer[iz].uOveZon, zonGroSta[ig].zonOcc[izg]);
//           connect(busSofTer[iz].uOccSch, zonGroSta[ig].uOcc[izg]);
//           connect(busSofTer[iz].tNexOcc, zonGroSta[ig].tNexOcc[izg]);
//           connect(busSofTer[iz].yCooTim, zonGroSta[ig].uCooTim[izg]);
//           connect(busSofTer[iz].yWarTim, zonGroSta[ig].uWarTim[izg]);
//           connect(busSofTer[iz].yOccHeaHig, zonGroSta[ig].uOccHeaHig[izg]);
//           connect(busSofTer[iz].yHigOccCoo, zonGroSta[ig].uHigOccCoo[izg]);
//           connect(busSofTer[iz].THeaSetOff, zonGroSta[ig].THeaSetOff[izg]);
//           connect(busSofTer[iz].yUnoHeaHig, zonGroSta[ig].uUnoHeaHig[izg]);
//           connect(busSofTer[iz].yEndSetBac, zonGroSta[ig].uEndSetBac[izg]);
//           connect(busSofTer[iz].TCooSetOff, zonGroSta[ig].TCooSetOff[izg]);
//           connect(busSofTer[iz].yHigUnoCoo, zonGroSta[ig].uHigUnoCoo[izg]);
//           connect(busSofTer[iz].yEndSetUp, zonGroSta[ig].uEndSetUp[izg]);
//           connect(busTer[iz].inp.uWin, zonGroSta[ig].uWin[izg]);
//           connect(busTer[iz].inp.TZon, zonGroSta[ig].TZon[izg]);
//         end if;
//       end for;
//     end for;
//   end for;

  connect(conAHU.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
        points={{44,92},{200,92},{200,-48},{22,-48}},  color={0,0,127}));
  connect(zonToSys.ySumDesZonPop, conAHU.sumDesZonPop) annotation (Line(points={{-2,-41},
          {-52,-41},{-52,118},{-44,118}},                             color={0,
          0,127}));
  connect(zonToSys.VSumDesPopBreZon_flow, conAHU.VSumDesPopBreZon_flow)
    annotation (Line(points={{-2,-44},{-56,-44},{-56,112},{-44,112}},
                                                                    color={0,0,
          127}));
  connect(zonToSys.VSumDesAreBreZon_flow, conAHU.VSumDesAreBreZon_flow)
    annotation (Line(points={{-2,-47},{-60,-47},{-60,106},{-44,106}},
                color={0,0,127}));
  connect(zonToSys.yDesSysVenEff, conAHU.uDesSysVenEff) annotation (Line(points={{-2,-50},
          {-64,-50},{-64,100},{-44,100}},                          color={0,0,
          127}));
  connect(zonToSys.VSumUncOutAir_flow, conAHU.VSumUncOutAir_flow) annotation (
      Line(points={{-2,-53},{-68,-53},{-68,94},{-44,94}},
        color={0,0,127}));
  connect(zonToSys.VSumSysPriAir_flow, conAHU.VSumSysPriAir_flow) annotation (
      Line(points={{-2,-59},{-76,-59},{-76,88},{-44,88}},
        color={0,0,127}));
  connect(zonToSys.uOutAirFra_max, conAHU.uOutAirFra_max) annotation (Line(
        points={{-2,-56},{-72,-56},{-72,82},{-44,82}},                   color=
          {0,0,127}));
  connect(busAHU.inp.TSup, conAHU.TSup) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,80},{-100,80},{-100,70},{-44,70}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.inp.TOut, conAHU.TOut) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,136},{-44,136}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.inp.pSup_rel, conAHU.ducStaPre) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,130},{-44,130}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.inp.VOut_flow, conAHU.VOut_flow) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,46},{-44,46}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.inp.TMix, conAHU.TMix) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,38},{-44,38}},
      color={255,204,51},
      thickness=0.5));
  connect(zonGroSta.uGroOcc,opeModSel.uOcc) annotation (Line(points={{-82,-141},
          {-86,-141},{-86,-104},{-82,-104}}, color={255,0,255}));
  connect(zonGroSta.nexOcc,opeModSel.tNexOcc) annotation (Line(points={{-82,
          -143},{-102,-143},{-102,-106},{-82,-106}},
                                                  color={0,0,127}));
  connect(zonGroSta.yCooTim,opeModSel.maxCooDowTim) annotation (Line(points={{-82,
          -147},{-112,-147},{-112,-108},{-82,-108}},   color={0,0,127}));
  connect(zonGroSta.yWarTim,opeModSel.maxWarUpTim) annotation (Line(points={{-82,
          -149},{-108,-149},{-108,-112},{-82,-112}},
                                                  color={0,0,127}));
  connect(zonGroSta.yOccHeaHig,opeModSel.uOccHeaHig) annotation (Line(points={{-82,
          -153},{-102,-153},{-102,-114},{-82,-114}},    color={255,0,255}));
  connect(zonGroSta.yHigOccCoo,opeModSel.uHigOccCoo) annotation (Line(points={{-82,
          -155},{-102,-155},{-102,-110},{-82,-110}},    color={255,0,255}));
  connect(zonGroSta.yColZon,opeModSel.totColZon) annotation (Line(points={{-82,
          -158},{-102,-158},{-102,-118},{-82,-118}},
                                                  color={255,127,0}));
  connect(zonGroSta.ySetBac,opeModSel.uSetBac) annotation (Line(points={{-82,
          -160},{-100,-160},{-100,-120},{-82,-120}},
                                                  color={255,0,255}));
  connect(zonGroSta.yEndSetBac,opeModSel.uEndSetBac) annotation (Line(points={{-82,
          -162},{-98,-162},{-98,-122},{-82,-122}},      color={255,0,255}));
  connect(zonGroSta.TZonMax,opeModSel.TZonMax) annotation (Line(points={{-82,
          -173},{-96,-173},{-96,-124},{-82,-124}},color={0,0,127}));
  connect(zonGroSta.TZonMin,opeModSel.TZonMin) annotation (Line(points={{-82,
          -175},{-94,-175},{-94,-126},{-82,-126}},color={0,0,127}));
  connect(zonGroSta.yHotZon,opeModSel. totHotZon) annotation (Line(points={{-82,
          -165},{-90,-165},{-90,-128},{-82,-128}},color={255,127,0}));
  connect(zonGroSta.ySetUp,opeModSel. uSetUp) annotation (Line(points={{-82,
          -167},{-90,-167},{-90,-130},{-82,-130}},color={255,0,255}));
  connect(zonGroSta.yEndSetUp,opeModSel. uEndSetUp) annotation (Line(points={{-82,
          -169},{-88,-169},{-88,-132},{-82,-132}},color={255,0,255}));
  connect(zonGroSta.yOpeWin,opeModSel. uOpeWin) annotation (Line(points={{-82,
          -179},{-104,-179},{-104,-116},{-82,-116}},
                                             color={255,127,0}));
  connect(FIXME1.y, conAHU.TZonHeaSet) annotation (Line(points={{238,200},{-44,200},{-44,148}},
                                     color={0,0,127}));
  connect(FIXME1.y, conAHU.TZonCooSet) annotation (Line(points={{238,200},{-44,200},{-44,142}},
                                     color={0,0,127}));
  connect(conAHU.ySupFan, busOutAHU.yFanSup)
    annotation (Line(points={{44,140},{100,140},{100,160}},
                                                         color={255,0,255}));
  connect(conAHU.ySupFanSpe, busOutAHU.ySpeFanSup) annotation (Line(points={{44,128},{100,128},{100,160}},
                                          color={0,0,127}));
  connect(conAHU.VDesUncOutAir_flow, VDesUncOutAir_flow.u) annotation (Line(
        points={{44,104},{158,104}},                 color={0,0,127}));
  connect(conAHU.yReqOutAir, yReqOutAir.u) annotation (Line(points={{44,68},{158,68}},
                                 color={255,0,255}));
  connect(conAHU.yHea, busOutAHU.yCoiHea) annotation (Line(points={{44,56},{100,56},{100,160}},
                                color={0,0,127}));
  connect(conAHU.yCoo, busOutAHU.yCoiCoo) annotation (Line(points={{44,44},{100,44},{100,160}},
                                        color={0,0,127}));
  connect(conAHU.yRetDamPos, busOutAHU.yDamRet) annotation (Line(points={{44,32},{100,32},{100,160}},
                                            color={0,0,127}));
  connect(conAHU.yOutDamPos, busOutAHU.yDamOut) annotation (Line(points={{44,20},{100,20},{100,160}},
                                                    color={0,0,127}));
  connect(busOutAHU, busAHU.out) annotation (Line(
      points={{100,160},{-180,160},{-180,0.1},{-200.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.sof.TSupSet, TSupSet.u) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,-100},{158,-100}},
      color={255,204,51},
      thickness=0.5));
  connect(TSupSet.y, busSofTer.TSupSet) annotation (Line(points={{22,-100},{60,
          -100},{60,-120},{90,-120}}, color={0,0,127}));
  connect(busSofTer, busTer.sof) annotation (Line(
      points={{90,-120},{200,-120},{200,0.1},{220.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(reqZonTemRes.y, conAHU.uZonTemResReq) annotation (Line(points={{-118,60},
          {-108,60},{-108,24},{-44,24}},     color={255,127,0}));
  connect(reqZonPreRes.y, conAHU.uZonPreResReq)
    annotation (Line(points={{-118,18},{-44,18}},          color={255,127,0}));
  connect(busTer.sof.yReqZonPreRes, reqZonPreRes.u) annotation (Line(
      points={{220.1,0.1},{22,0.1},{22,0},{-160,0},{-160,18},{-142,18}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.yReqZonTemRes, reqZonTemRes.u) annotation (Line(
      points={{220.1,0.1},{-160,0.1},{-160,60},{-142,60}},
      color={255,204,51},
      thickness=0.5));

  connect(FIXME4.y, conAHU.TOutCut) annotation (Line(points={{178,222},{178,218},{-56,218},{-56,64},{-44,64}},
                              color={0,0,127}));
  connect(busAHU.inp.hOut, conAHU.hOut) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,80},{-100,80},{-100,58},{-44,58}},
      color={255,204,51},
      thickness=0.5));
  connect(FIXME4.y, conAHU.hOutCut) annotation (Line(points={{178,222},{178,226},{-50,226},{-50,52},{-44,52}},
                              color={0,0,127}));
 connect(FIXME9.y, busOutAHU.yDamRel) annotation (Line(points={{278,152},{166,152},{166,160},{100,160}},
                                                                                  color={0,0,127}));
  // connect(FIXME5.y, busOutAHU.yDamOutMin) annotation (Line(points={{238,60},{90,60}}, color={0,0,127}));
  connect(FIXME7.y, busOutAHU.yFanRet) annotation (Line(points={{238,120},{100,120},{100,160}},
                             color={255,0,255}));
  connect(FIXME6.y, busOutAHU.ySpeFanRet) annotation (Line(points={{278,180},{166,180},{166,160},{100,160}},
                                 color={0,0,127}));
  connect(FIXME8.y, conAHU.uOpeMod) annotation (Line(points={{238,-80},{-48,-80},
          {-48,30},{-44,30}}, color={255,127,0}));
  connect(TSupSet.y, busTer.sof.TSupSet)
    annotation (Line(points={{182,-100},{200,-100},{200,0.1},{220.1,0.1}}, color={0,0,127}));
  connect(yReqOutAir.y, busTer.sof.yReqOutAir)
    annotation (Line(points={{182,68},{200,68},{200,0.1},{220.1,0.1}}, color={255,0,255}));
  connect(VDesUncOutAir_flow.y, busTer.sof.VDesUncOutAir_flow)
    annotation (Line(points={{182,104},{200,104},{200,0.1},{220.1,0.1}}, color={0,0,127}));
  connect(zonToSys.uDesZonPeaOcc, busTer.sof.yDesZonPeaOcc)
    annotation (Line(points={{22,-42},{200,-42},{200,0.1},{220.1,0.1}}, color={0,0,127}));
  connect(zonToSys.VDesPopBreZon_flow, busTer.sof.VDesPopBreZon_flow)
    annotation (Line(points={{22,-44},{200,-44},{200,0.1},{220.1,0.1}}, color={0,0,127}));
  connect(zonToSys.VDesAreBreZon_flow, busTer.sof.VDesAreBreZon_flow)
    annotation (Line(points={{22,-46},{200,-46},{200,0.1},{220.1,0.1}}, color={0,0,127}));
  connect(zonToSys.uDesPriOutAirFra, busTer.sof.yDesPriOutAirFra)
    annotation (Line(points={{22,-52},{200,-52},{200,0.1},{220.1,0.1}}, color={0,0,127}));
  connect(zonToSys.VUncOutAir_flow, busTer.sof.VUncOutAir_flow)
    annotation (Line(points={{22,-54},{200,-54},{200,0.1},{220.1,0.1}}, color={0,0,127}));
  connect(zonToSys.uPriOutAirFra, busTer.sof.yPriOutAirFra)
    annotation (Line(points={{22,-56},{200,-56},{200,0.1},{220.1,0.1}}, color={0,0,127}));
  connect(zonToSys.VPriAir_flow, busTer.sof.VPriAir_flow)
    annotation (Line(points={{22,-58},{200,-58},{200,0.1},{220.1,0.1}}, color={0,0,127}));
  connect(conAHU.TSupSet, busAHU.sof.TSupSet)
    annotation (Line(points={{44,116},{60,116},{60,0.1},{-200.1,0.1}}, color={0,0,127}));
  connect(opeModSel.yOpeMod, busSofTer.yOpeMod) annotation (Line(points={{-58,
          -118},{-40,-118},{-40,-120},{90,-120}},
                  color={255,127,0}));
  connect(zonSta.yCooTim, zonStaDup.uCooTim) annotation (Line(points={{-2,-153},
          {-2,-154},{-10,-154},{-10,-149},{-18,-149}}, color={0,0,127}));
  connect(zonSta.yOccHeaHig, zonStaDup.uOccHeaHig) annotation (Line(points={{-2,-160},
          {-10,-160},{-10,-155},{-18,-155}},       color={255,0,255}));
  connect(zonSta.yHigOccCoo, zonStaDup.uHigOccCoo) annotation (Line(points={{-2,-165},
          {-2,-166},{-10,-166},{-10,-157},{-18,-157}},       color={255,0,255}));
  connect(zonSta.THeaSetOff, zonStaDup.THeaSetOff) annotation (Line(points={{-2,-168},
          {-10,-168},{-10,-163},{-18,-163}},       color={0,0,127}));
  connect(zonSta.yUnoHeaHig, zonStaDup.uUnoHeaHig) annotation (Line(points={{-2,-170},
          {-8,-170},{-8,-161},{-18,-161}},       color={255,0,255}));
  connect(zonSta.yEndSetBac, zonStaDup.uEndSetBac) annotation (Line(points={{-2,-172},
          {-8,-172},{-8,-165},{-18,-165}},       color={255,0,255}));
  connect(zonSta.TCooSetOff, zonStaDup.TCooSetOff) annotation (Line(points={{-2,-175},
          {-2,-174},{-10,-174},{-10,-172},{-18,-172},{-18,-171}},       color={0,
          0,127}));
  connect(zonSta.yHigUnoCoo, zonStaDup.uHigUnoCoo) annotation (Line(points={{-2,-177},
          {-2,-169},{-18,-169}},       color={255,0,255}));
  connect(zonSta.yEndSetUp, zonStaDup.uEndSetUp) annotation (Line(points={{-2,-179},
          {-2,-178},{-8,-178},{-8,-173},{-18,-173}}, color={255,0,255}));
  connect(zonSta.yWarTim, zonStaDup.uWarTim) annotation (Line(points={{-2,-155},
          {-2,-156},{-8,-156},{-8,-151},{-18,-151}}, color={0,0,127}));
  connect(busSofTer.tNexOcc, zonStaDup.tNexOcc) annotation (Line(
      points={{90,-120},{-8,-120},{-8,-145},{-18,-145}},
      color={255,204,51},
      thickness=0.5));
  connect(busSofTer.uOccSch, zonStaDup.uOcc) annotation (Line(
      points={{90,-120},{-8,-120},{-8,-143},{-18,-143}},
      color={255,204,51},
      thickness=0.5));
  connect(busSofTer.uOveZon, zonStaDup.zonOcc) annotation (Line(
      points={{90,-120},{-8,-120},{-8,-141},{-18,-141}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.TZon, zonStaDup.TZon) annotation (Line(
      points={{220.1,0.1},{206,0.1},{206,-186},{-12,-186},{-12,-177},{-18,-177}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.uWin, zonStaDup.uWin) annotation (Line(
      points={{220.1,0.1},{206,0.1},{206,-186},{-12,-186},{-12,-180},{-18,-180},
          {-18,-179}},
      color={255,204,51},
      thickness=0.5));
  connect(zonStaDup.yzonOcc, zonGroFil.zonOcc)
    annotation (Line(points={{-30,-141},{-38,-141}}, color={255,0,255}));
  connect(zonStaDup.yOcc, zonGroFil.uOcc)
    annotation (Line(points={{-30,-143},{-38,-143}}, color={255,0,255}));
  connect(zonStaDup.ytNexOcc, zonGroFil.tNexOcc)
    annotation (Line(points={{-30,-145},{-38,-145}}, color={0,0,127}));
  connect(zonStaDup.yCooTim, zonGroFil.uCooTim)
    annotation (Line(points={{-30,-149},{-38,-149}}, color={0,0,127}));
  connect(zonStaDup.yWarTim, zonGroFil.uWarTim)
    annotation (Line(points={{-30,-151},{-38,-151}}, color={0,0,127}));
  connect(zonStaDup.yOccHeaHig, zonGroFil.uOccHeaHig)
    annotation (Line(points={{-30,-155},{-38,-155}}, color={255,0,255}));
  connect(zonStaDup.yHigOccCoo, zonGroFil.uHigOccCoo)
    annotation (Line(points={{-30,-157},{-38,-157}}, color={255,0,255}));
  connect(zonStaDup.yUnoHeaHig, zonGroFil.uUnoHeaHig)
    annotation (Line(points={{-30,-161},{-38,-161}}, color={255,0,255}));
  connect(zonStaDup.yTHeaSetOff, zonGroFil.THeaSetOff)
    annotation (Line(points={{-30,-163},{-38,-163}}, color={0,0,127}));
  connect(zonStaDup.yEndSetBac, zonGroFil.uEndSetBac)
    annotation (Line(points={{-30,-165},{-38,-165}}, color={255,0,255}));
  connect(zonStaDup.yHigUnoCoo, zonGroFil.uHigUnoCoo)
    annotation (Line(points={{-30,-169},{-38,-169}}, color={255,0,255}));
  connect(zonStaDup.yTCooSetOff, zonGroFil.TCooSetOff)
    annotation (Line(points={{-30,-171},{-38,-171}}, color={0,0,127}));
  connect(zonStaDup.yEndSetUp, zonGroFil.uEndSetUp)
    annotation (Line(points={{-30,-173},{-38,-173}}, color={255,0,255}));
  connect(zonStaDup.yTZon, zonGroFil.TZon)
    annotation (Line(points={{-30,-177},{-38,-177}}, color={0,0,127}));
  connect(zonStaDup.yWin, zonGroFil.uWin)
    annotation (Line(points={{-30,-179},{-38,-179}}, color={255,0,255}));
  connect(zonGroFil.yzonOcc, zonGroSta.zonOcc)
    annotation (Line(points={{-50,-141},{-58,-141}}, color={255,0,255}));
  connect(zonGroFil.yOcc, zonGroSta.uOcc)
    annotation (Line(points={{-50,-143},{-58,-143}}, color={255,0,255}));
  connect(zonGroFil.ytNexOcc, zonGroSta.tNexOcc)
    annotation (Line(points={{-50,-145},{-58,-145}}, color={0,0,127}));
  connect(zonGroFil.yCooTim, zonGroSta.uCooTim)
    annotation (Line(points={{-50,-149},{-58,-149}}, color={0,0,127}));
  connect(zonGroFil.yWarTim, zonGroSta.uWarTim)
    annotation (Line(points={{-50,-151},{-58,-151}}, color={0,0,127}));
  connect(zonGroFil.yOccHeaHig, zonGroSta.uOccHeaHig)
    annotation (Line(points={{-50,-155},{-58,-155}}, color={255,0,255}));
  connect(zonGroFil.yHigOccCoo, zonGroSta.uHigOccCoo)
    annotation (Line(points={{-50,-157},{-58,-157}}, color={255,0,255}));
  connect(zonGroFil.yUnoHeaHig, zonGroSta.uUnoHeaHig)
    annotation (Line(points={{-50,-161},{-58,-161}}, color={255,0,255}));
  connect(zonGroFil.yTHeaSetOff, zonGroSta.THeaSetOff)
    annotation (Line(points={{-50,-163},{-58,-163}}, color={0,0,127}));
  connect(zonGroFil.yEndSetBac, zonGroSta.uEndSetBac)
    annotation (Line(points={{-50,-165},{-58,-165}}, color={255,0,255}));
  connect(zonGroFil.yHigUnoCoo, zonGroSta.uHigUnoCoo)
    annotation (Line(points={{-50,-169},{-58,-169}}, color={255,0,255}));
  connect(zonGroFil.yTCooSetOff, zonGroSta.TCooSetOff)
    annotation (Line(points={{-50,-171},{-58,-171}}, color={0,0,127}));
  connect(zonGroFil.yEndSetUp, zonGroSta.uEndSetUp)
    annotation (Line(points={{-50,-173},{-58,-173}}, color={255,0,255}));
  connect(zonGroFil.yTZon, zonGroSta.TZon)
    annotation (Line(points={{-50,-177},{-58,-177}}, color={0,0,127}));
  connect(zonGroFil.yWin, zonGroSta.uWin) annotation (Line(points={{-50,-179},{
          -50,-180},{-58,-180},{-58,-179}},
                                        color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-12,-94},{194,-148}},
          lineColor={238,46,47},
          textString="Todo: subset indices for different Boolean values (such as have_occSen)"),
                                                               Text(
          extent={{-40,-140},{166,-194}},
          lineColor={238,46,47},
          textString="Manual edit of connect clauses between groups and zones due to lack of suitable extractor blocks")}),
    Documentation(info="<html>
<p>
WARNING: Do not use. Not configured and connected yet!
</p>
</html>"));
end Guideline36;
