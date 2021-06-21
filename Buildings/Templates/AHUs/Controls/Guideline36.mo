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
  * Parameters for Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
  */

  parameter Real VOutPerAre_flow[nZon](
    each final unit = "m3/(s.m2)") = {
      dat.getReal(varName=
        idTerArr[i] + ".Control.Zone outdoor air volume flow rate per unit area.value")
      for i in 1:nZon}
    "Outdoor air rate per unit area"
    annotation(Dialog(group="Nominal condition"));

  parameter Real VOutPerPer_flow[nZon](each unit="m3/s") = {
     dat.getReal(varName=
      idTerArr[i] + ".Control.Zone outdoor air volume flow rate per person")
     for i in 1:nZon}
    "Outdoor air rate per person"
    annotation(Dialog(group="Nominal condition"));

  parameter Real AFlo[nZon](each unit="m2") = {
     dat.getReal(varName=idTerArr[i] + ".Control.Zone floor area")
     for i in 1:nZon}
    "Floor area of each zone"
    annotation(Dialog(group="Nominal condition"));

  parameter Boolean have_occSen[nZon] = {
     dat.getBoolean(varName=idTerArr[i] + ".Control.Occupancy sensor")
     for i in 1:nZon}
    "Set to true if zones have occupancy sensor";

  parameter Boolean have_winSen[nZon] = {
     dat.getBoolean(varName=idTerArr[i] + ".Control.Window sensor")
     for i in 1:nZon}
    "Set to true if zones have window status sensor";

  parameter Real occDen[nZon](each final unit = "1/m2") = {
     dat.getReal(varName=idTerArr[i] + ".Control.Zone default number of person per unit area")
     for i in 1:nZon}
    "Default number of person per unit area";

  parameter Real zonDisEffHea[nZon](each final unit = "1") = {
     dat.getReal(varName=idTerArr[i] + ".Control.Zone air distribution effectiveness during heating")
     for i in 1:nZon}
    "Zone air distribution effectiveness during heating";

  parameter Real zonDisEffCoo[nZon](each final unit = "1") = {
     dat.getReal(varName=idTerArr[i] + ".Control.Zone air distribution effectiveness during cooling")
     for i in 1:nZon}
    "Zone air distribution effectiveness during cooling";

  // FIXME: What is that?
  parameter Real desZonDisEff[nZon](each final unit = "1") = zonDisEffCoo
    "Design zone air distribution effectiveness"
    annotation(Dialog(group="Nominal condition"));

  final parameter Real desZonPop[nZon](
    each min=0,
    each final unit = "1") = occDen .* AFlo
    "Design zone population during peak occupancy"
    annotation(Dialog(group="Nominal condition"));

  parameter Real minZonPriFlo[nZon](each unit="m3/s") = {
     dat.getReal(varName=idTerArr[i] + ".Control.Zone minimum expected primary air volume flow rate")
     for i in 1:nZon}
    "Minimum expected zone primary flow rate"
    annotation(Dialog(group="Nominal condition"));

  /*
  * Parameters for Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
  */

  parameter Real THeaSetOcc[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature") = {
      dat.getReal(varName=idTerArr[i] + ".Control.Occupied heating setpoint")
      for i in 1:nZon}
    "Occupied heating setpoint";

  parameter Real THeaSetUno[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature") = {
      dat.getReal(varName=idTerArr[i] + ".Control.Unoccupied heating setpoint")
      for i in 1:nZon}
    "Unoccupied heating setpoint";

  parameter Real TCooSetOcc[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature") = {
      dat.getReal(varName=idTerArr[i] + ".Control.Occupied cooling setpoint")
      for i in 1:nZon}
    "Occupied cooling setpoint";

  parameter Real TCooSetUno[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature") = {
      dat.getReal(varName=idTerArr[i] + ".Control.Unoccupied cooling setpoint")
      for i in 1:nZon}
    "Unoccupied cooling setpoint";

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

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone zonOutAirSet[nZon](
    final VOutPerAre_flow=VOutPerAre_flow,
    final VOutPerPer_flow=VOutPerPer_flow,
    final AFlo=AFlo,
    final have_occSen=have_occSen,
    final have_winSen=have_winSen,
    final occDen=occDen,
    final zonDisEffHea=zonDisEffHea,
    final zonDisEffCoo=zonDisEffCoo,
    final desZonDisEff=desZonDisEff,
    final desZonPop=desZonPop,
    final minZonPriFlo=minZonPriFlo)
    "Zone level calculation of the minimum outdoor airflow set point"
    annotation (Placement(transformation(extent={{150,-60},{130,-40}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToSys(final numZon=nZon)
    "Sum up zone calculation output"
    annotation (Placement(transformation(extent={{20,-60},{0,-40}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus zonSta[nZon](
    final THeaSetOcc=THeaSetOcc,
    final THeaSetUno=THeaSetUno,
    final TCooSetOcc=TCooSetOcc,
    final TCooSetUno=TCooSetUno,
    final have_winSen=have_winSen)
    "Evaluate zone temperature status"
    annotation (Placement(transformation(extent={{20,-180},{0,-152}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus zonGroSta[nGro](
    each final numZon=nZon,
    final nZonGro=nZonGro,
    final inZon=groZonMsk)
    "Evaluate zone group status"
    annotation (Placement(transformation(extent={{-54,-188},{-74,-148}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode opeModSel[nGro](
    final numZon=nZonGro,
    each final preWarCooTim=preWarCooTim,
    each final TZonFreProOn=TZonFreProOn,
    each final TZonFreProOff=TZonFreProOff)
    "Operation mode selection for each zone group"
    annotation (Placement(transformation(extent={{-74,-136},{-54,-104}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME1(k=24 + 273.15)
    "Where is the use of the average zone set point described?"
    annotation (Placement(transformation(extent={{260,170},{240,190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant FIXME2 [nZon](k=fill(1,
        nZon)) "nOcc shall be Boolean, not integer"
    annotation (Placement(transformation(extent={{260,140},{240,160}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator TSupSet(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator VDesUncOutAir_flow(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{130,78},{150,98}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator yReqOutAir(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{130,42},{150,62}})));
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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME3[nZon](
    k=fill(1800, nZon))
    "Optimal start using global outdoor air temperature not associated with any AHU"
    annotation (Placement(transformation(extent={{260,-170},{240,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME4(k=24 + 273.15)
  "To be determined determined by the control sequence based on energy standard, climate zone, and economizer high-limit-control device type"
    annotation (Placement(transformation(extent={{260,100},{240,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME5(k=1)
    "Various economizer configurations not handled: yDamRel (or exhaust), yDamOutMin"
    annotation (Placement(transformation(extent={{260,50},{240,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME6(k=1)
    "Various fan configurations not handled: yFanRet (or relief)"
    annotation (Placement(transformation(extent={{260,14},{240,34}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant    FIXME7(k=true)
    "Various fan configurations not handled: yFanRet (or relief)"
    annotation (Placement(transformation(extent={{286,10},{266,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant FIXME8(k=1)
    "Convert zone group mode into AHU system mode per 5.15"
    annotation (Placement(transformation(extent={{260,-90},{240,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant  FIXME9(k=true)
    "Various economizer configurations not handled: yDamRel (or exhaust), yDamOutMin"
    annotation (Placement(transformation(extent={{278,62},{258,82}})));
protected
    BaseClasses.Connectors.SubBusOutput busOutAHU
    "AHU output points"
    annotation (
      Placement(
        transformation(extent={{70,40},{110,80}}), iconTransformation(extent={{-10,24},
            {10,44}})));
  BaseClasses.Connectors.SubBusSoftware busSofAHU
    "AHU software points"
    annotation (
      Placement(
        transformation(extent={{70,0},{110,40}}),
        iconTransformation(extent={{-10,44}, {10,64}})));
  BaseClasses.Connectors.SubBusSoftware busSofTer[nZon]
    "Terminal unit software points"
    annotation (
      Placement(
        transformation(extent={{70,-140},{110,-100}}), iconTransformation(
          extent={{-10,64},{10,84}})));

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
//           connect(zonSta[iz].yCooTim, zonGroSta[ig].uCooTim[izg]);
//           connect(zonSta[iz].yWarTim, zonGroSta[ig].uWarTim[izg]);
//           connect(zonSta[iz].yOccHeaHig, zonGroSta[ig].uOccHeaHig[izg]);
//           connect(zonSta[iz].yHigOccCoo, zonGroSta[ig].uHigOccCoo[izg]);
//           connect(zonSta[iz].THeaSetOff, zonGroSta[ig].THeaSetOff[izg]);
//           connect(zonSta[iz].yUnoHeaHig, zonGroSta[ig].uUnoHeaHig[izg]);
//           connect(zonSta[iz].yEndSetBac, zonGroSta[ig].uEndSetBac[izg]);
//           connect(zonSta[iz].TCooSetOff, zonGroSta[ig].TCooSetOff[izg]);
//           connect(zonSta[iz].yHigUnoCoo, zonGroSta[ig].uHigUnoCoo[izg]);
//           connect(zonSta[iz].yEndSetUp, zonGroSta[ig].uEndSetUp[izg]);
//           connect(busTer[iz].inp.uWin, zonGroSta[ig].uWin[izg]);
//           connect(busTer[iz].inp.TZon, zonGroSta[ig].TZon[izg]);
//         end if;
//       end for;
//     end for;
//   end for;

  connect(zonOutAirSet.yDesZonPeaOcc, zonToSys.uDesZonPeaOcc) annotation (Line(
        points={{128,-41},{60,-41},{60,-42},{22,-42}},    color={0,0,127}));
  connect(zonOutAirSet.VDesPopBreZon_flow, zonToSys.VDesPopBreZon_flow)
    annotation (Line(points={{128,-44},{22,-44}},  color={0,0,127}));
  connect(zonOutAirSet.VDesAreBreZon_flow, zonToSys.VDesAreBreZon_flow)
    annotation (Line(points={{128,-47},{60,-47},{60,-46},{22,-46}},    color={0,
          0,127}));
  connect(zonOutAirSet.yDesPriOutAirFra, zonToSys.uDesPriOutAirFra) annotation (
     Line(points={{128,-50},{68,-50},{68,-52},{22,-52}},    color={0,0,127}));
  connect(zonOutAirSet.VUncOutAir_flow, zonToSys.VUncOutAir_flow) annotation (
      Line(points={{128,-53},{50,-53},{50,-54},{22,-54}},    color={0,0,127}));
  connect(zonOutAirSet.yPriOutAirFra, zonToSys.uPriOutAirFra)
    annotation (Line(points={{128,-56},{22,-56}},  color={0,0,127}));
  connect(zonOutAirSet.VPriAir_flow, zonToSys.VPriAir_flow) annotation (Line(
        points={{128,-59},{50,-59},{50,-58},{22,-58}},    color={0,0,127}));
  connect(conAHU.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
        points={{44,92},{120,92},{120,-48},{22,-48}},  color={0,0,127}));
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
  connect(zonGroSta.uGroOcc,opeModSel.uOcc) annotation (Line(points={{-76,-149},
          {-86,-149},{-86,-106},{-76,-106}}, color={255,0,255}));
  connect(zonGroSta.nexOcc,opeModSel.tNexOcc) annotation (Line(points={{-76,-151},
          {-102,-151},{-102,-108},{-76,-108}},    color={0,0,127}));
  connect(zonGroSta.yCooTim,opeModSel.maxCooDowTim) annotation (Line(points={{-76,
          -155},{-112,-155},{-112,-110},{-76,-110}},   color={0,0,127}));
  connect(zonGroSta.yWarTim,opeModSel.maxWarUpTim) annotation (Line(points={{-76,
          -157},{-108,-157},{-108,-114},{-76,-114}},
                                                  color={0,0,127}));
  connect(zonGroSta.yOccHeaHig,opeModSel.uOccHeaHig) annotation (Line(points={{-76,
          -161},{-102,-161},{-102,-116},{-76,-116}},    color={255,0,255}));
  connect(zonGroSta.yHigOccCoo,opeModSel.uHigOccCoo) annotation (Line(points={{-76,
          -163},{-102,-163},{-102,-112},{-76,-112}},    color={255,0,255}));
  connect(zonGroSta.yColZon,opeModSel.totColZon) annotation (Line(points={{-76,-166},
          {-102,-166},{-102,-120},{-76,-120}},    color={255,127,0}));
  connect(zonGroSta.ySetBac,opeModSel.uSetBac) annotation (Line(points={{-76,-168},
          {-100,-168},{-100,-122},{-76,-122}},    color={255,0,255}));
  connect(zonGroSta.yEndSetBac,opeModSel.uEndSetBac) annotation (Line(points={{-76,
          -170},{-98,-170},{-98,-124},{-76,-124}},      color={255,0,255}));
  connect(zonGroSta.TZonMax,opeModSel.TZonMax) annotation (Line(points={{-76,-181},
          {-96,-181},{-96,-126},{-76,-126}},      color={0,0,127}));
  connect(zonGroSta.TZonMin,opeModSel.TZonMin) annotation (Line(points={{-76,-183},
          {-94,-183},{-94,-128},{-76,-128}},      color={0,0,127}));
  connect(zonGroSta.yHotZon,opeModSel. totHotZon) annotation (Line(points={{-76,
          -173},{-90,-173},{-90,-130},{-76,-130}},color={255,127,0}));
  connect(zonGroSta.ySetUp,opeModSel. uSetUp) annotation (Line(points={{-76,-175},
          {-90,-175},{-90,-132},{-76,-132}},      color={255,0,255}));
  connect(zonGroSta.yEndSetUp,opeModSel. uEndSetUp) annotation (Line(points={{-76,
          -177},{-88,-177},{-88,-134},{-76,-134}},color={255,0,255}));
  connect(zonGroSta.yOpeWin,opeModSel. uOpeWin) annotation (Line(points={{-76,-187},
          {-104,-187},{-104,-118},{-76,-118}},
                                             color={255,127,0}));
  connect(FIXME1.y, conAHU.TZonHeaSet) annotation (Line(points={{238,180},{-60,180},
          {-60,148},{-44,148}},      color={0,0,127}));
  connect(FIXME1.y, conAHU.TZonCooSet) annotation (Line(points={{238,180},{-60,180},
          {-60,142},{-44,142}},      color={0,0,127}));
  connect(FIXME2.y, zonOutAirSet.nOcc) annotation (Line(points={{238,150},{166,
          150},{166,-41},{152,-41}}, color={255,127,0}));
  connect(conAHU.ySupFan, busOutAHU.yFanSup)
    annotation (Line(points={{44,140},{90,140},{90,60}}, color={255,0,255}));
  connect(conAHU.ySupFanSpe, busOutAHU.ySpeFanSup) annotation (Line(points={{44,
          128},{86,128},{86,60},{90,60}}, color={0,0,127}));
  connect(conAHU.TSupSet, busSofAHU.TSupSet) annotation (Line(points={{44,116},
          {76,116},{76,20},{90,20}}, color={0,0,127}));
  connect(conAHU.VDesUncOutAir_flow, VDesUncOutAir_flow.u) annotation (Line(
        points={{44,104},{86,104},{86,88},{128,88}}, color={0,0,127}));
  connect(VDesUncOutAir_flow.y, zonOutAirSet.VUncOut_flow_nominal) annotation (
      Line(points={{152,88},{184,88},{184,-59},{152,-59}}, color={0,0,127}));
  connect(conAHU.yReqOutAir, yReqOutAir.u) annotation (Line(points={{44,68},{86,
          68},{86,52},{128,52}}, color={255,0,255}));
  connect(yReqOutAir.y, zonOutAirSet.uReqOutAir) annotation (Line(points={{152,52},
          {180,52},{180,-47},{152,-47}},     color={255,0,255}));
  connect(conAHU.yHea, busOutAHU.yCoiHea) annotation (Line(points={{44,56},{60,
          56},{60,60},{90,60}}, color={0,0,127}));
  connect(conAHU.yCoo, busOutAHU.yCoiCoo) annotation (Line(points={{44,44},{64,
          44},{64,56},{90,56},{90,60}}, color={0,0,127}));
  connect(conAHU.yRetDamPos, busOutAHU.yDamRet) annotation (Line(points={{44,32},
          {68,32},{68,50},{90,50},{90,60}}, color={0,0,127}));
  connect(conAHU.yOutDamPos, busOutAHU.yDamOut) annotation (Line(points={{44,20},
          {72,20},{72,46},{94,46},{94,60},{90,60}}, color={0,0,127}));
  connect(busSofAHU, busAHU.sof) annotation (Line(
      points={{90,20},{100,20},{100,-20},{-180,-20},{-180,0.1},{-200.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(busOutAHU, busAHU.out) annotation (Line(
      points={{90,60},{100,60},{100,-20},{-180,-20},{-180,0.1},{-200.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.sof.TSupSet, TSupSet.u) annotation (Line(
      points={{-200.1,0.1},{-200.1,0},{-180,0},{-180,-100},{-2,-100}},
      color={255,204,51},
      thickness=0.5));
  connect(TSupSet.y, busSofTer.TSupSet) annotation (Line(points={{22,-100},{80,-100},
          {80,-120},{90,-120}},       color={0,0,127}));
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
  connect(busTer.inp.uWin, zonSta.uWin) annotation (Line(
      points={{220.1,0.1},{220.1,0},{200,0},{200,-170},{22,-170}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.TZon, zonSta.TZon) annotation (Line(
      points={{220.1,0.1},{200,0.1},{200,-174},{22,-174}},
      color={255,204,51},
      thickness=0.5));
  connect(FIXME3.y, zonSta.cooDowTim) annotation (Line(points={{238,-160},{40,
          -160},{40,-158},{22,-158}},
                                color={0,0,127}));
  connect(FIXME3.y, zonSta.warUpTim) annotation (Line(points={{238,-160},{40,
          -160},{40,-162},{22,-162}},
                                color={0,0,127}));

  connect(FIXME4.y, conAHU.TOutCut) annotation (Line(points={{238,110},{-80,110},
          {-80,64},{-44,64}}, color={0,0,127}));
  connect(busAHU.inp.hOut, conAHU.hOut) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,80},{-100,80},{-100,58},{-44,58}},
      color={255,204,51},
      thickness=0.5));
  connect(FIXME4.y, conAHU.hOutCut) annotation (Line(points={{238,110},{-80,110},
          {-80,52},{-44,52}}, color={0,0,127}));
  connect(busTer.inp.uWin, zonOutAirSet.uWin) annotation (Line(
      points={{220.1,0.1},{200,0.1},{200,-44},{152,-44}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.TZon, zonOutAirSet.TZon) annotation (Line(
      points={{220.1,0.1},{200,0.1},{200,-50},{152,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.TDis, zonOutAirSet.TDis) annotation (Line(
      points={{220.1,0.1},{218,0.1},{218,0},{200,0},{200,-53},{152,-53}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.VDis_flow, zonOutAirSet.VDis_flow) annotation (Line(
      points={{220.1,0.1},{200,0.1},{200,-56},{152,-56}},
      color={255,204,51},
      thickness=0.5));
 connect(FIXME9.y, busOutAHU.yDamRel) annotation (Line(points={{256,72},{174,72},{174,60},{90,60}},
                                                                                  color={0,0,127}));
  // connect(FIXME5.y, busOutAHU.yDamOutMin) annotation (Line(points={{238,60},{90,60}}, color={0,0,127}));
  connect(FIXME7.y, busOutAHU.yFanRet) annotation (Line(points={{264,20},{106,
          20},{106,60},{90,60}},
                             color={255,0,255}));
  connect(FIXME6.y, busOutAHU.ySpeFanRet) annotation (Line(points={{238,24},{110,
          24},{110,60},{90,60}}, color={0,0,127}));
  connect(FIXME8.y, conAHU.uOpeMod) annotation (Line(points={{238,-80},{-48,-80},
          {-48,30},{-44,30}}, color={255,127,0}));

  for gro in 1:nGro loop
    connect(zonSta.yCooTim, zonGroSta[gro].uCooTim) annotation (Line(points={{-2,-153},
            {-44,-153},{-44,-157},{-52,-157}}, color={0,0,127}));
    connect(zonSta.yWarTim, zonGroSta[gro].uWarTim) annotation (Line(points={{-2,-155},
            {-40,-155},{-40,-159},{-52,-159}}, color={0,0,127}));
    connect(zonSta.yOccHeaHig, zonGroSta[gro].uOccHeaHig) annotation (Line(points={{
            -2,-160},{-44,-160},{-44,-163},{-52,-163}}, color={255,0,255}));
    connect(zonSta.yHigOccCoo, zonGroSta[gro].uHigOccCoo)
      annotation (Line(points={{-2,-165},{-52,-165}}, color={255,0,255}));
    connect(zonSta.THeaSetOff, zonGroSta[gro].THeaSetOff) annotation (Line(points={{
            -2,-168},{-44,-168},{-44,-171},{-52,-171}}, color={0,0,127}));
    connect(zonSta.yUnoHeaHig, zonGroSta[gro].uUnoHeaHig) annotation (Line(points={{
            -2,-170},{-28,-170},{-28,-169},{-52,-169}}, color={255,0,255}));
    connect(zonSta.yEndSetBac, zonGroSta[gro].uEndSetBac) annotation (Line(points={{
            -2,-172},{-27,-172},{-27,-173},{-52,-173}}, color={255,0,255}));
    connect(zonSta.TCooSetOff, zonGroSta[gro].TCooSetOff) annotation (Line(points={{
            -2,-175},{-44,-175},{-44,-179},{-52,-179}}, color={0,0,127}));
    connect(zonSta.yHigUnoCoo, zonGroSta[gro].uHigUnoCoo)
      annotation (Line(points={{-2,-177},{-52,-177}}, color={255,0,255}));
    connect(zonSta.yEndSetUp, zonGroSta[gro].uEndSetUp) annotation (Line(points={{-2,
            -179},{-2,-180},{-44,-180},{-44,-181},{-52,-181}}, color={255,0,255}));
  end for;
  connect(zonGroSta[1].zonOcc, busSofTer) annotation (Line(points={{-52,-149},{-50,
          -149},{-50,-148},{-48,-148},{-48,-120},{90,-120}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(zonGroSta[1].uOcc, busSofTer) annotation (Line(points={{-52,-151},{-50,
          -151},{-50,-150},{-48,-150},{-48,-120},{90,-120}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(zonGroSta[1].tNexOcc, busSofTer) annotation (Line(points={{-52,-153},{
          -48,-153},{-48,-120},{90,-120}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(opeModSel.yOpeMod, busSofTer) annotation (Line(points={{-52,-120},{90,
          -120}}, color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busTer.inp.uWin, zonGroSta.uWin) annotation (Line(
      points={{220.1,0.1},{200,0.1},{200,-184},{-52,-184},{-52,-187}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busTer.inp.TZon, zonGroSta.TZon) annotation (Line(
      points={{220.1,0.1},{200,0.1},{200,-188},{-52,-188},{-52,-185}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{216,-12},{422,-66}},
          lineColor={238,46,47},
          textString="Todo: subset indices for different Boolean values (such as have_occSen)")}),
    Documentation(info="<html>
<p>
WARNING: Do not use. Not configured and connected yet!
</p>
</html>"));
end Guideline36;
