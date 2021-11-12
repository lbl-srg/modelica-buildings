within Buildings.Templates.AirHandlersFans.Components.Controls;
block Guideline36 "Guideline 36 VAV single duct controller"
  extends
    Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces.PartialSingleDuct(
      final typ=Types.Controller.Guideline36);

  // See FIXME below for those parameters.
  parameter String namGroZon[nZon] = fill(namGro[1], nZon)
    "Name of group which each zone belongs to"
    annotation(Evaluate=true);

  final parameter Boolean have_perZonRehBox = true
    "Check if there is any VAV-reheat boxes on perimeter zones"
    annotation (Dialog(group="System and building parameters"));

  /* FIXME: Evaluate function call at compile time, FE ExternData.
  
  parameter String namGroZon[nZon] = {
    dat.getString(varName=idTerArr[i] + ".Identification.Zone group name.value")
    for i in 1:nZon}
    "Name of group which each zone belongs to"
    annotation(Evaluate=true);
    
  */

  final parameter Boolean isZonInGro[nGro, nZon] = {
    {namGroZon[i] == namGro[j] for i in 1:nZon} for j in 1:nGro}
    "True if zone belongs to group"
    annotation(Evaluate=true);

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

  /* FIXME: Evaluate function call at compile time, FE ExternData
  final parameter Boolean have_perZonRehBox = Modelica.Math.BooleanVectors.anyTrue({
      dat.getBoolean(varName=idTerArr[i] + ".Control.Perimeter zone with reheat.value")
      for i in 1:nZon})
    "Check if there is any VAV-reheat boxes on perimeter zones"
    annotation (Dialog(group="System and building parameters"));
    */
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
    dat.getReal(varName=id + ".Control.Airflow.Duct Design Maximum Static Pressure.value")
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

  parameter Real yFanMax=
    dat.getReal(varName=id + ".Control.Airflow.Maximum Fan Speed - Supply fan.value")
    "Maximum allowed fan speed"
    annotation (Dialog(group="Fan speed PID controller"));

  parameter Real yFanMin=
    dat.getReal(varName=id + ".Control.Airflow.Minimum Fan Speed - Supply fan.value")
    "Lowest allowed fan speed if fan is on"
    annotation (Dialog(group="Fan speed PID controller"));

  // ----------- parameters for minimum outdoor airflow setting  -----------
  parameter Real VPriSysMax_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=
    dat.getReal(varName=id + ".Control.Ventilation.Maximum expected system primary airflow at design stage.value")
    "Maximum expected system primary airflow at design stage"
    annotation (Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

  parameter Real peaSysPop=
    dat.getReal(varName=id + ".Control.Ventilation.Peak system population.value")
    "Peak system population"
    annotation (Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

  // ----------- parameters for supply air temperature control  -----------
  parameter Real TSupSetMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".Control.Supply air temperature.Lowest cooling set point.value")
    "Lowest cooling supply air temperature setpoint"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Real TSupSetMax(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".Control.Supply air temperature.Highest cooling set point.value")
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
    dat.getReal(varName=id + ".Control.Supply air temperature.Lower value of OAT reset range.value")
    "Lower value of the outdoor air temperature reset range. Typically value is 16 degC (60 degF)"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Real TOutMax(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".Control.Supply air temperature.Higher value of OAT reset range.value")
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

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller con(
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
    final peaSysPop=peaSysPop,
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
    final uCooMin=uCooMin) "AHU controller"
    annotation (Placement(transformation(extent={{-40,8},{40,152}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToSys(final numZon=nZon)
    "Sum up zone calculation output"
    annotation (Placement(transformation(extent={{20,-60},{0,-40}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatusDuplicator repSigZon(
    final nZon=nZon,
    final nGro=nGro)
    "Replicate zone signals"
    annotation (Placement(transformation(extent={{-32,-188},{-40,-148}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus staGro[nGro](
    final numZon=fill(nZon, nGro),
    final numZonGro=nZonGro,
    final zonGroMsk=isZonInGro)
    "Evaluate zone group status"
    annotation (Placement(transformation(extent={{-54,-188},{-74,-148}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode opeModSel[nGro](
    final numZon=nZonGro,
    each final preWarCooTim=preWarCooTim,
    each final TZonFreProOn=TZonFreProOn,
    each final TZonFreProOff=TZonFreProOff)
    "Operation mode selection for each zone group"
    annotation (Placement(transformation(extent={{-74,-136},{-54,-104}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TSupSet(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{160,-30},{180,-10}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator VDesUncOutAir_flow(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{160,94},{180,114}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator yReqOutAir(
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_TSet(k=24 + 273.15)
    "Where is the use of the average zone set point described?"
    annotation (Placement(transformation(extent={{280,138},{260,158}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_TOutCut(k=24 + 273.15)
    "To be determined determined by the control sequence based on energy standard, climate zone, and economizer high-limit-control device type"
    annotation (Placement(transformation(extent={{280,178},{260,198}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_yDamRel(k=1)
    "Various economizer configurations not handled: yDamRel (or exhaust), yDamOutMin"
    annotation (Placement(transformation(extent={{280,58},{260,78}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_yFanRetRea(k=1)
    "Various fan configurations not handled: yFanRet (or relief)"
    annotation (Placement(transformation(extent={{280,98},{260,118}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_yFanRetBoo(k=true)
    "Various fan configurations not handled: yFanRet (or relief)"
    annotation (Placement(transformation(extent={{280,18},{260,38}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant FIXME_modSys(k=1)
    "Convert zone group mode into AHU system mode per 5.15"
    annotation (Placement(transformation(extent={{280,-20},{260,0}})));

equation

  /* Hardware point connection - start */
  connect(con.yHea, bus.coiHea.y);
  connect(con.yCoo, bus.coiCoo.y);
  connect(con.yRetDamPos, bus.damRet.y);
  connect(con.yOutDamPos, bus.damOut.y);

  connect(con.ySupFan, bus.fanSup.y);
  connect(con.ySupFanSpe, bus.fanSup.ySpe);
  connect(FIXME_yFanRetBoo.y, bus.fanRet.y);
  connect(FIXME_yFanRetRea.y, bus.fanRet.ySpe);
  connect(FIXME_yDamRel.y, bus.damRel.y);
  /* Hardware point connection - stop */

  /* Software point connection - start */
  connect(FIXME_TSet.y, con.TZonHeaSet);
  connect(FIXME_TSet.y, con.TZonCooSet);

  connect(FIXME_TOutCut.y, con.TOutCut);
  connect(FIXME_TOutCut.y, con.hOutCut);
  connect(FIXME_modSys.y, con.uOpeMod);

  connect(busTer.uOveZon, repSigZon.zonOcc);
  connect(busTer.uOcc, repSigZon.uOcc);
  connect(busTer.tNexOcc, repSigZon.tNexOcc);

  connect(busTer.yCooTim, repSigZon.uCooTim);
  connect(busTer.yWarTim, repSigZon.uWarTim);
  connect(busTer.yOccHeaHig, repSigZon.uOccHeaHig);
  connect(busTer.yHigOccCoo, repSigZon.uHigOccCoo);
  connect(busTer.yUnoHeaHig, repSigZon.uUnoHeaHig);
  connect(busTer.THeaSetOff, repSigZon.THeaSetOff);
  connect(busTer.yEndSetBac, repSigZon.uEndSetBac);
  connect(busTer.yHigUnoCoo, repSigZon.uHigUnoCoo);
  connect(busTer.TCooSetOff, repSigZon.TCooSetOff);
  connect(busTer.yEndSetUp, repSigZon.uEndSetUp);
  connect(busTer.TZon, repSigZon.TZon);
  connect(busTer.uWin, repSigZon.uWin);

  /* Software point connection - stop */


  connect(con.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
        points={{44,92},{200,92},{200,-48},{22,-48}}, color={0,0,127}));
  connect(zonToSys.ySumDesZonPop, con.sumDesZonPop) annotation (Line(points={{-2,
          -41},{-52,-41},{-52,118},{-44,118}}, color={0,0,127}));
  connect(zonToSys.VSumDesPopBreZon_flow, con.VSumDesPopBreZon_flow)
    annotation (Line(points={{-2,-44},{-56,-44},{-56,112},{-44,112}}, color={0,0,
          27}));
  connect(zonToSys.VSumDesAreBreZon_flow, con.VSumDesAreBreZon_flow)
    annotation (Line(points={{-2,-47},{-60,-47},{-60,106},{-44,106}}, color={0,0,
          127}));
  connect(zonToSys.yDesSysVenEff, con.uDesSysVenEff) annotation (Line(points={{-2,
          -50},{-64,-50},{-64,100},{-44,100}}, color={0,0,127}));
  connect(zonToSys.VSumUncOutAir_flow, con.VSumUncOutAir_flow) annotation (Line(
        points={{-2,-53},{-68,-53},{-68,94},{-44,94}}, color={0,0,127}));
  connect(zonToSys.VSumSysPriAir_flow, con.VSumSysPriAir_flow) annotation (Line(
        points={{-2,-59},{-76,-59},{-76,88},{-44,88}}, color={0,0,127}));
  connect(zonToSys.uOutAirFra_max, con.uOutAirFra_max) annotation (Line(points={
          {-2,-56},{-72,-56},{-72,82},{-44,82}}, color={0,0,127}));
  connect(bus.TSup, con.TSup) annotation (Line(
      points={{-200,0},{-180,0},{-180,80},{-100,80},{-100,70},{-44,70}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.TOut, con.TOut) annotation (Line(
      points={{-200,0},{-180,0},{-180,136},{-44,136}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.pSup_rel, con.ducStaPre) annotation (Line(
      points={{-200,0},{-180,0},{-180,130},{-44,130}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.VOut_flow, con.VOut_flow) annotation (Line(
      points={{-200,0},{-180,0},{-180,46},{-44,46}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.TMix, con.TMix) annotation (Line(
      points={{-200,0},{-180,0},{-180,38},{-44,38}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.hOut, con.hOut) annotation (Line(
      points={{-200,0},{-180,0},{-180,80},{-100,80},{-100,58},{-44,58}},
      color={255,204,51},
      thickness=0.5));
  connect(staGro.uGroOcc, opeModSel.uOcc) annotation (Line(points={{-76,-149},{-86,
          -149},{-86,-106},{-76,-106}}, color={255,0,255}));
  connect(staGro.nexOcc, opeModSel.tNexOcc) annotation (Line(points={{-76,-151},
          {-102,-151},{-102,-108},{-76,-108}}, color={0,0,127}));
  connect(staGro.yCooTim, opeModSel.maxCooDowTim) annotation (Line(points={{-76,
          -155},{-112,-155},{-112,-110},{-76,-110}}, color={0,0,127}));
  connect(staGro.yWarTim, opeModSel.maxWarUpTim) annotation (Line(points={{-76,-157},
          {-108,-157},{-108,-114},{-76,-114}}, color={0,0,127}));
  connect(staGro.yOccHeaHig, opeModSel.uOccHeaHig) annotation (Line(points={{-76,
          -161},{-102,-161},{-102,-116},{-76,-116}}, color={255,0,255}));
  connect(staGro.yHigOccCoo, opeModSel.uHigOccCoo) annotation (Line(points={{-76,
          -163},{-102,-163},{-102,-112},{-76,-112}}, color={255,0,255}));
  connect(staGro.yColZon, opeModSel.totColZon) annotation (Line(points={{-76,-166},
          {-102,-166},{-102,-120},{-76,-120}}, color={255,127,0}));
  connect(staGro.ySetBac, opeModSel.uSetBac) annotation (Line(points={{-76,-168},
          {-100,-168},{-100,-122},{-76,-122}}, color={255,0,255}));
  connect(staGro.yEndSetBac, opeModSel.uEndSetBac) annotation (Line(points={{-76,
          -170},{-98,-170},{-98,-124},{-76,-124}}, color={255,0,255}));
  connect(staGro.TZonMax, opeModSel.TZonMax) annotation (Line(points={{-76,-181},
          {-96,-181},{-96,-126},{-76,-126}}, color={0,0,127}));
  connect(staGro.TZonMin, opeModSel.TZonMin) annotation (Line(points={{-76,-183},
          {-94,-183},{-94,-128},{-76,-128}}, color={0,0,127}));
  connect(staGro.yHotZon, opeModSel.totHotZon) annotation (Line(points={{-76,-173},
          {-90,-173},{-90,-130},{-76,-130}}, color={255,127,0}));
  connect(staGro.ySetUp, opeModSel.uSetUp) annotation (Line(points={{-76,-175},{
          -90,-175},{-90,-132},{-76,-132}}, color={255,0,255}));
  connect(staGro.yEndSetUp, opeModSel.uEndSetUp) annotation (Line(points={{-76,-177},
          {-88,-177},{-88,-134},{-76,-134}}, color={255,0,255}));
  connect(staGro.yOpeWin, opeModSel.uOpeWin) annotation (Line(points={{-76,-187},
          {-104,-187},{-104,-118},{-76,-118}}, color={255,127,0}));
  connect(con.VDesUncOutAir_flow, VDesUncOutAir_flow.u)
    annotation (Line(points={{44,104},{158,104}}, color={0,0,127}));
  connect(con.yReqOutAir, yReqOutAir.u)
    annotation (Line(points={{44,68},{158,68}}, color={255,0,255}));
  connect(bus.TSupSet, TSupSet.u)
    annotation (Line(
      points={{-200,0},{-180,0},{-180,-20},{158,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(reqZonTemRes.y, con.uZonTemResReq) annotation (Line(points={{-118,60},
          {-108,60},{-108,24},{-44,24}}, color={255,127,0}));
  connect(reqZonPreRes.y, con.uZonPreResReq)
    annotation (Line(points={{-118,18},{-44,18}}, color={255,127,0}));
  connect(busTer.yReqZonPreRes, reqZonPreRes.u) annotation (Line(
      points={{220,0},{22,0},{22,0},{-160,0},{-160,18},{-142,18}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.yReqZonTemRes, reqZonTemRes.u) annotation (Line(
      points={{220,0},{-160,0},{-160,60},{-142,60}},
      color={255,204,51},
      thickness=0.5));

  connect(TSupSet.y, busTer.TSupSet)
    annotation (Line(points={{182,-20},{200,-20},{200,0},{220,0}},         color={0,0,127}));
  connect(yReqOutAir.y, busTer.yReqOutAir)
    annotation (Line(points={{182,68},{200,68},{200,0},{220,0}},       color={255,0,255}));
  connect(VDesUncOutAir_flow.y, busTer.VDesUncOutAir_flow)
    annotation (Line(points={{182,104},{200,104},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.uDesZonPeaOcc, busTer.yDesZonPeaOcc)
    annotation (Line(points={{22,-42},{200,-42},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.VDesPopBreZon_flow, busTer.VDesPopBreZon_flow)
    annotation (Line(points={{22,-44},{200,-44},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.VDesAreBreZon_flow, busTer.VDesAreBreZon_flow)
    annotation (Line(points={{22,-46},{200,-46},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.uDesPriOutAirFra, busTer.yDesPriOutAirFra)
    annotation (Line(points={{22,-52},{200,-52},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.VUncOutAir_flow, busTer.VUncOutAir_flow)
    annotation (Line(points={{22,-54},{200,-54},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.uPriOutAirFra, busTer.yPriOutAirFra)
    annotation (Line(points={{22,-56},{200,-56},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.VPriAir_flow, busTer.VPriAir_flow)
    annotation (Line(points={{22,-58},{200,-58},{200,0},{220,0}},       color={0,0,127}));
  connect(con.TSupSet, bus.TSupSet) annotation (Line(points={{44,116},{60,116},{
          60,0},{-200,0}}, color={0,0,127}));
  connect(repSigZon.yzonOcc, staGro.zonOcc)
    annotation (Line(points={{-42,-149},{-52,-149}}, color={255,0,255}));
  connect(repSigZon.yOcc, staGro.uOcc)
    annotation (Line(points={{-42,-151},{-52,-151}}, color={255,0,255}));
  connect(repSigZon.ytNexOcc, staGro.tNexOcc)
    annotation (Line(points={{-42,-153},{-52,-153}}, color={0,0,127}));
  connect(repSigZon.yCooTim, staGro.uCooTim)
    annotation (Line(points={{-42,-157},{-52,-157}}, color={0,0,127}));
  connect(repSigZon.yWarTim, staGro.uWarTim)
    annotation (Line(points={{-42,-159},{-52,-159}}, color={0,0,127}));
  connect(repSigZon.yOccHeaHig, staGro.uOccHeaHig)
    annotation (Line(points={{-42,-163},{-52,-163}}, color={255,0,255}));
  connect(repSigZon.yHigOccCoo, staGro.uHigOccCoo) annotation (Line(points={{-42,
          -165},{-48,-165},{-48,-165},{-52,-165}}, color={255,0,255}));
  connect(repSigZon.yUnoHeaHig, staGro.uUnoHeaHig)
    annotation (Line(points={{-42,-169},{-52,-169}}, color={255,0,255}));
  connect(repSigZon.yTHeaSetOff, staGro.THeaSetOff)
    annotation (Line(points={{-42,-171},{-52,-171}}, color={0,0,127}));
  connect(repSigZon.yEndSetBac, staGro.uEndSetBac)
    annotation (Line(points={{-42,-173},{-52,-173}}, color={255,0,255}));
  connect(repSigZon.yHigUnoCoo, staGro.uHigUnoCoo)
    annotation (Line(points={{-42,-177},{-52,-177}}, color={255,0,255}));
  connect(repSigZon.yTCooSetOff, staGro.TCooSetOff)
    annotation (Line(points={{-42,-179},{-52,-179}}, color={0,0,127}));
  connect(repSigZon.yEndSetUp, staGro.uEndSetUp)
    annotation (Line(points={{-42,-181},{-52,-181}}, color={255,0,255}));
  connect(repSigZon.yTZon, staGro.TZon)
    annotation (Line(points={{-42,-185},{-52,-185}}, color={0,0,127}));
  connect(repSigZon.yWin, staGro.uWin)
    annotation (Line(points={{-42,-187},{-52,-187}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-12,-94},{194,-148}},
          lineColor={238,46,47},
          textString="Todo: subset indices for different Boolean values (such as have_occSen)

Map for zone appartenance to group")}),
    Documentation(info="<html>
<p>
WARNING: Do not use. Not configured and connected yet!
</p>
</html>"));
end Guideline36;
