within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV;
block Controller "Multizone AHU controller that composes subsequences for controlling fan speed, dampers, and supply air temperature"

  parameter Modelica.SIunits.Time samplePeriod=120
    "Sample period of component, set to the same value to the trim and respond sequence";

  parameter Integer numZon(min=2) "Total number of served VAV boxes"
    annotation (Dialog(group="System and building parameters"));

  parameter Modelica.SIunits.Area AFlo[numZon] "Floor area of each zone"
    annotation (Dialog(group="System and building parameters"));

  parameter Boolean have_occSen=false
    "Set to true if zones have occupancy sensor"
    annotation (Dialog(group="System and building parameters"));

  parameter Boolean have_winSen=false
    "Set to true if zones have window status sensor"
    annotation (Dialog(group="System and building parameters"));

  parameter Boolean have_perZonRehBox=true
    "Check if there is any VAV-reheat boxes on perimeter zones"
    annotation (Dialog(group="System and building parameters"));

  parameter Boolean have_duaDucBox=false
    "Check if the AHU serves dual duct boxes"
    annotation (Dialog(group="System and building parameters"));

  parameter Boolean have_airFloMeaSta=false
    "Check if the AHU has AFMS (Airflow measurement station)"
    annotation (Dialog(group="System and building parameters"));

  // ----------- Parameters for economizer control -----------
  parameter Boolean use_enthalpy=false
    "Set to true if enthalpy measurement is used in addition to temperature measurement"
    annotation (Evaluate=true,Dialog(tab="Economizer"));

  parameter Modelica.SIunits.Time delta=5
    "Time horizon over which the outdoor air flow measurment is averaged"
    annotation (Evaluate=true,Dialog(tab="Economizer"));

  parameter Modelica.SIunits.TemperatureDifference delTOutHis=1
    "Delta between the temperature hysteresis high and low limit"
    annotation (Evaluate=true, Dialog(tab="Economizer"));

  parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation (Evaluate=true, Dialog(tab="Economizer", enable=use_enthalpy));

  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper"
    annotation (Evaluate=true,
      Dialog(tab="Economizer", group="Damper limits"));

  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation (Evaluate=true,
      Dialog(tab="Economizer", group="Damper limits"));

  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper"
    annotation (Evaluate=true,
      Dialog(tab="Economizer", group="Damper limits"));

  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (Evaluate=true,
      Dialog(tab="Economizer", group="Damper limits"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMinOut=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller" annotation (Dialog(group="Economizer PID controller"));

  parameter Real kMinOut(final unit="1")=0.05
    "Gain of controller for minimum outdoor air intake"
    annotation (Dialog(group="Economizer PID controller"));

  parameter Modelica.SIunits.Time TiMinOut=1200
    "Time constant of controller for minimum outdoor air intake"
    annotation (Dialog(group="Economizer PID controller",
      enable=controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time TdMinOut=0.1
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

  parameter Modelica.SIunits.Time TiFre(max=TiMinOut)=120
    "Time constant of controller for mixed air temperature tracking for freeze protection. Require TiFre < TiMinOut"
     annotation(Dialog(group="Economizer freeze protection",
       enable=use_TMix
         and (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Modelica.SIunits.Time TdFre=0.1
    "Time constant of derivative block for freeze protection"
    annotation (Dialog(group="Economizer freeze protection",
      enable=use_TMix and
          (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Modelica.SIunits.Temperature TFreSet = 279.15
    "Lower limit for mixed air temperature for freeze protection, used if use_TMix=true"
     annotation(Dialog(group="Economizer freeze protection", enable=use_TMix));

  parameter Real yMinDamLim=0
    "Lower limit of damper position limits control signal output"
    annotation (Evaluate=true,
      Dialog(tab="Economizer", group="Damper limits"));

  parameter Real yMaxDamLim=1
    "Upper limit of damper position limits control signal output"
    annotation (Evaluate=true,
      Dialog(tab="Economizer", group="Damper limits"));

  parameter Modelica.SIunits.Time retDamFulOpeTim=180
    "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations"
    annotation (Evaluate=true, Dialog(tab="Economizer", group="Economizer delays at disable"));

  parameter Modelica.SIunits.Time disDel=15
    "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
    annotation (Evaluate=true,Dialog(tab="Economizer", group="Economizer delays at disable"));

  // ----------- parameters for fan speed control  -----------
  parameter Modelica.SIunits.PressureDifference pIniSet(displayUnit="Pa")=60
    "Initial pressure setpoint for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Modelica.SIunits.PressureDifference pMinSet(displayUnit="Pa")=25
    "Minimum pressure setpoint for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Modelica.SIunits.PressureDifference pMaxSet(displayUnit="Pa")=400
    "Maximum pressure setpoint for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Modelica.SIunits.Time pDelTim=600
    "Delay time after which trim and respond is activated"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Integer pNumIgnReq=2
    "Number of ignored requests for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Modelica.SIunits.PressureDifference pTriAmo(displayUnit="Pa")=-12.0
    "Trim amount for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Modelica.SIunits.PressureDifference pResAmo(displayUnit="Pa")=15
    "Respond amount (must be opposite in to triAmo) for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Modelica.SIunits.PressureDifference pMaxRes(displayUnit="Pa")=32
    "Maximum response per time interval (same sign as resAmo) for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Fan speed PID controller"));

  parameter Real kFanSpe(final unit="1")=0.1
    "Gain of fan fan speed controller, normalized using pMaxSet"
    annotation (Dialog(group="Fan speed PID controller"));

  parameter Modelica.SIunits.Time TiFanSpe=60
    "Time constant of integrator block for fan speed"
    annotation (Dialog(group="Fan speed PID controller",
      enable=controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time TdFanSpe=0.1
    "Time constant of derivative block for fan speed"
    annotation (Dialog(group="Fan speed PID controller",
      enable=controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real yFanMax=1 "Maximum allowed fan speed"
    annotation (Evaluate=true,
      Dialog(group="Fan speed PID controller"));

  parameter Real yFanMin=0.1 "Lowest allowed fan speed if fan is on"
    annotation (Evaluate=true,
      Dialog(group="Fan speed PID controller"));

  // ----------- parameters for minimum outdoor airflow setting  -----------
  parameter Real zonDisEffHea[numZon]=
     fill(0.8, outAirSetPoi.numZon)
    "Zone air distribution effectiveness during heating"
    annotation (Evaluate=true,
      Dialog(tab="Minimum outdoor airflow rate"));

  parameter Real zonDisEffCoo[numZon]=
     fill(1.0, outAirSetPoi.numZon)
    "Zone air distribution effectiveness during cooling"
    annotation (Evaluate=true,
      Dialog(tab="Minimum outdoor airflow rate"));

  parameter Real occDen[numZon](each final unit="1/m2")=
     fill(0.05, outAirSetPoi.numZon)
    "Default number of person in unit area"
    annotation (Evaluate=true,
      Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

  parameter Real VOutPerAre_flow[numZon](
    final unit = fill("m3/(s.m2)", outAirSetPoi.numZon))=fill(3e-4, outAirSetPoi.numZon)
    "Outdoor air rate per unit area"
    annotation (Evaluate=true,
      Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

  parameter Modelica.SIunits.VolumeFlowRate VOutPerPer_flow[numZon]=
    fill(2.5e-3, outAirSetPoi.numZon)
    "Outdoor air rate per person"
    annotation (Evaluate=true,
      Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

  parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numZon]
    "Minimum expected zone primary flow rate"
    annotation (Evaluate=true,
      Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

  parameter Modelica.SIunits.VolumeFlowRate VPriSysMax_flow
    "Maximum expected system primary airflow at design stage"
    annotation (Evaluate=true,
      Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

  parameter Real desZonDisEff[numZon]=fill(1.0, outAirSetPoi.numZon)
    "Design zone air distribution effectiveness"
    annotation (Evaluate=true,
      Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

  parameter Real desZonPop[numZon]={
    outAirSetPoi.occDen[i]*outAirSetPoi.AFlo[i]
    for i in 1:outAirSetPoi.numZon}
    "Design zone population during peak occupancy"
    annotation (Evaluate=true,
      Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

  parameter Real peaSysPop=1.2*sum(
    {outAirSetPoi.occDen[iZon]*outAirSetPoi.AFlo[iZon]
    for iZon in 1:outAirSetPoi.numZon})
    "Peak system population"
    annotation (Evaluate=true,
      Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

//  parameter Real uLow=-0.5
//    "If zone space temperature minus supply air temperature is less than uLow,
//    then it should use heating supply air distribution effectiveness"
//    annotation (Evaluate=true,
//      Dialog(tab="Minimum outdoor airflow rate", group="Advanced"));
//  parameter Real uHig=0.5
//    "If zone space temperature minus supply air temperature is more than uHig,
//    then it should use cooling supply air distribution effectiveness"
 //   annotation (Evaluate=true,
  //    Dialog(tab="Minimum outdoor airflow rate", group="Advanced"));

  // ----------- parameters for supply air temperature control  -----------
  parameter Modelica.SIunits.Temperature TSupSetMin=285.15
    "Lowest cooling supply air temperature setpoint"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Modelica.SIunits.Temperature TSupSetMax=291.15
    "Highest cooling supply air temperature setpoint. It is typically 18 degC (65 degF) in mild and dry climates, 16 degC (60 degF) or lower in humid climates"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Modelica.SIunits.Temperature TSupSetDes=286.15
    "Nominal supply air temperature setpoint"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Modelica.SIunits.Temperature TOutMin=289.15
    "Lower value of the outdoor air temperature reset range. Typically value is 16 degC (60 degF)"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Modelica.SIunits.Temperature TOutMax=294.15
    "Higher value of the outdoor air temperature reset range. Typically value is 21 degC (70 degF)"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Modelica.SIunits.Temperature iniSetSupTem=supTemSetPoi.maxSet
    "Initial setpoint for supply temperature control" annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Modelica.SIunits.Temperature maxSetSupTem=supTemSetPoi.TSupSetMax
    "Maximum setpoint for supply temperature control" annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Modelica.SIunits.Temperature minSetSupTem=supTemSetPoi.TSupSetDes
    "Minimum setpoint for supply temperature control" annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Modelica.SIunits.Time delTimSupTem=600
    "Delay timer for supply temperature control"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Integer numIgnReqSupTem=2
    "Number of ignorable requests for supply temperature control"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Modelica.SIunits.TemperatureDifference triAmoSupTem=0.1
    "Trim amount for supply temperature control"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Modelica.SIunits.TemperatureDifference resAmoSupTem=-0.2
    "Response amount for supply temperature control"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Modelica.SIunits.TemperatureDifference maxResSupTem=-0.6
    "Maximum response per time interval for supply temperature control"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeTSup=
      Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for supply air temperature signal"
    annotation (Dialog(group="Supply air temperature"));

  parameter Real kTSup(final unit="1/K")=0.05
    "Gain of controller for supply air temperature signal"
    annotation (Dialog(group="Supply air temperature"));

  parameter Modelica.SIunits.Time TiTSup=600
    "Time constant of integrator block for supply air temperature control signal"
    annotation (Dialog(group="Supply air temperature",
      enable=controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time TdTSup=0.1
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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow[numZon](
    each final unit="m3/s",
    each quantity="VolumeFlowRate",
    each min=0)
    "Primary airflow rate to the ventilation zone from the air handler, including outdoor air and recirculated air"
    annotation (Placement(transformation(extent={{-220,110},{-200,130}}),
      iconTransformation(extent={{-220,-80},{-200,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final quantity = "ThermodynamicTemperature") if use_TMix
    "Measured mixed air temperature, used for freeze protection if use_TMix=true"
    annotation (Placement(transformation(extent={{-220,-110},{-200,-90}}),
      iconTransformation(extent={{-220,-100},{-200,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput ducStaPre(
    final unit="Pa",
    displayUnit="Pa")
    "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-220,92},{-200,112}}),
      iconTransformation(extent={{-220,-50},{-200,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-220,136},{-200,156}}),
      iconTransformation(extent={{-220,200},{-200,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}}),
      iconTransformation(extent={{-220,100},{-200,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-220,-62},{-200,-42}}),
      iconTransformation(extent={{-220,80},{-200,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-220,-74},{-200,-54}}),
      iconTransformation(extent={{-220,60},{-200,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-220,0},{-200,20}}),
      iconTransformation(extent={{-220,30},{-200,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Zone air temperature heating setpoint"
    annotation (Placement(transformation(extent={{-220,200},{-200,220}}),
      iconTransformation(extent={{-220,260},{-200,280}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured outdoor volumetric airflow rate"
    annotation (Placement(transformation(extent={{-220,-90},{-200,-70}}),
      iconTransformation(extent={{-220,-30},{-200,-10}})));

  CDL.Interfaces.IntegerInput nOcc[numZon] if have_occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-220,70},{-200,90}}),
      iconTransformation(extent={{-220,-10},{-200,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[numZon](
    each final unit="K",
    each final quantity="ThermodynamicTemperature")
    "Measured zone air temperature"
    annotation (Placement(transformation(extent={{-220,50},{-200,70}}),
      iconTransformation(extent={{-220,180},{-200,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis[numZon](
    each final unit="K",
    each final quantity="ThermodynamicTemperature")
    "Discharge air temperature"
    annotation (Placement(transformation(extent={{-220,32},{-200,52}}),
      iconTransformation(extent={{-220,140},{-200,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Zone air temperature cooling setpoint"
    annotation (Placement(transformation(extent={{-220,180},{-200,200}}),
      iconTransformation(extent={{-220,240},{-200,260}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{-220,-170},{-200,-150}}),
      iconTransformation(extent={{-220,-190},{-200,-170}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{-220,-190},{-200,-170}}),
      iconTransformation(extent={{-220,-220},{-200,-200}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-220,-130},{-200,-110}}),
      iconTransformation(extent={{-220,-140},{-200,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin[numZon] if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-222,158},{-200,180}}),
      iconTransformation(extent={{-220,10},{-200,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta if
      use_G36FrePro
   "Freeze protection status, used if use_G36FrePro=true"
    annotation (Placement(transformation(extent={{-220,-210},{-200,-190}}),
      iconTransformation(extent={{-220,-260},{-200,-240}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Setpoint for supply air temperature"
    annotation (Placement(transformation(extent={{200,60},{220,80}}),
      iconTransformation(extent={{200,-110},{220,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final min=0,
    final max=1,
    final unit="1")
    "Control signal for heating"
    annotation (Placement(transformation(extent={{200,10},{220,30}}),
      iconTransformation(extent={{200,-200},{220,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final min=0,
    final max=1,
    final unit="1") "Control signal for cooling"
    annotation (Placement(transformation(extent={{200,-34},{220,-14}}),
      iconTransformation(extent={{200,-240},{220,-220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
    final min=0,
    final max=1,
    final unit="1") "Supply fan speed"
    annotation (Placement(transformation(extent={{200,100},{220,120}}),
      iconTransformation(extent={{200,180},{220,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position"
    annotation (Placement(transformation(extent={{200,-70},{220,-50}}),
      iconTransformation(extent={{200,-10},{220,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Outdoor air damper position"
    annotation (Placement(transformation(extent={{200,-180},{220,-160}}),
      iconTransformation(extent={{200,30},{220,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySupFan
    "Supply fan status, true if fan should be on"
    annotation (Placement(transformation(extent={{200,150},{220,170}}),
      iconTransformation(extent={{200,220},{220,240}})));

  Buildings.Controls.OBC.CDL.Continuous.Average TZonSetPoiAve
    "Average of all zone set points"
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow
    outAirSetPoi(
    final AFlo=AFlo,
    final VPriSysMax_flow=VPriSysMax_flow,
    final minZonPriFlo=minZonPriFlo,
    final numZon=numZon,
    final have_occSen=have_occSen,
    final VOutPerAre_flow=VOutPerAre_flow,
    final VOutPerPer_flow=VOutPerPer_flow,
    final occDen=occDen,
    final zonDisEffHea=zonDisEffHea,
    final zonDisEffCoo=zonDisEffCoo,
    final desZonDisEff=desZonDisEff,
    final desZonPop=desZonPop,
    final peaSysPop=peaSysPop,
    final have_winSen=have_winSen)
    "Controller for minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan
    supFan(
    final numZon=numZon,
    final samplePeriod=samplePeriod,
    final have_perZonRehBox=have_perZonRehBox,
    final have_duaDucBox=have_duaDucBox,
    final have_airFloMeaSta=have_airFloMeaSta,
    final iniSet=pIniSet,
    final minSet=pMinSet,
    final maxSet=pMaxSet,
    final delTim=pDelTim,
    final numIgnReq=pNumIgnReq,
    final triAmo=pTriAmo,
    final resAmo=pResAmo,
    final maxRes=pMaxRes,
    final controllerType=controllerTypeFanSpe,
    final k=kFanSpe,
    final Ti=TiFanSpe,
    final Td=TdFanSpe,
    final yFanMax=yFanMax,
    final yFanMin=yFanMin)
    "Supply fan controller"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature
    supTemSetPoi(
    final samplePeriod=samplePeriod,
    final TSupSetMin=TSupSetMin,
    final TSupSetMax=TSupSetMax,
    final TSupSetDes=TSupSetDes,
    final TOutMin=TOutMin,
    final TOutMax=TOutMax,
    final iniSet=iniSetSupTem,
    final maxSet=maxSetSupTem,
    final minSet=minSetSupTem,
    final delTim=delTimSupTem,
    final numIgnReq=numIgnReqSupTem,
    final triAmo=triAmoSupTem,
    final resAmo=resAmoSupTem,
    final maxRes=maxResSupTem) "Setpoint for supply temperature"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller eco(
    final use_enthalpy=use_enthalpy,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamFulOpeTim=retDamFulOpeTim,
    final disDel=disDel,
    final controllerTypeMinOut=controllerTypeMinOut,
    final kMinOut=kMinOut,
    final TiMinOut=TiMinOut,
    final TdMinOut=TdMinOut,
    final retDamPhyPosMax=retDamPhyPosMax,
    final retDamPhyPosMin=retDamPhyPosMin,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final uHeaMax=uHeaMax,
    final uCooMin=uCooMin,
    final uOutDamMax=(uHeaMax + uCooMin)/2,
    final uRetDamMin=(uHeaMax + uCooMin)/2,
    final TFreSet=TFreSet,
    final controllerTypeFre=controllerTypeFre,
    final kFre=kFre,
    final TiFre=TiFre,
    final TdFre=TdFre,
    final delta=delta,
    final use_TMix=use_TMix,
    final use_G36FrePro=use_G36FrePro) "Economizer controller"
    annotation (Placement(transformation(extent={{140,-80},{160,-60}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplySignals val(
    final controllerType=controllerTypeTSup,
    final kTSup=kTSup,
    final TiTSup=TiTSup,
    final TdTSup=TdTSup,
    final uHeaMax=uHeaMax,
    final uCooMin=uCooMin) "AHU coil valve control"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Division VOut_flow_normalized(
    u1(final unit="m3/s"),
    u2(final unit="m3/s"),
    y(final unit="1"))
    "Normalization of outdoor air flow intake by design minimum outdoor air intake"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(eco.yRetDamPos, yRetDamPos) annotation (Line(points={{160.625,-65},{
          180,-65},{180,-60},{210,-60}},color={0,0,127}));
  connect(eco.yOutDamPos, yOutDamPos) annotation (Line(points={{160.625,-75},{
          180,-75},{180,-170},{210,-170}},color={0,0,127}));
  connect(eco.uSupFan, supFan.ySupFan) annotation (Line(points={{139.375,
          -74.375},{-84,-74.375},{-84,117},{-139,117}},color={255,0,255}));
  connect(supFan.ySupFanSpe, ySupFanSpe)
    annotation (Line(points={{-139,110},{210,110}},
      color={0,0,127}));
  connect(TOut, eco.TOut) annotation (Line(points={{-210,146},{-60,146},{-60,
          -60.625},{139.375,-60.625}}, color={0,0,127}));
  connect(eco.TOutCut, TOutCut) annotation (Line(points={{139.375,-61.875},{-74,
          -61.875},{-74,-20},{-210,-20}},  color={0,0,127}));
  connect(eco.hOut, hOut) annotation (Line(points={{139.375,-63.125},{-80,
          -63.125},{-80,-52},{-210,-52}}, color={0,0,127}));
  connect(eco.hOutCut, hOutCut) annotation (Line(points={{139.375,-65},{-100,
          -65},{-100,-64},{-210,-64}}, color={0,0,127}));
  connect(eco.uOpeMod, uOpeMod) annotation (Line(points={{139.375,-76.875},{60,
          -76.875},{60,-120},{-210,-120}}, color={255,127,0}));
  connect(supTemSetPoi.TSupSet, TSupSet)
    annotation (Line(points={{21,70},{210,70}}, color={0,0,127}));
  connect(supTemSetPoi.TOut, TOut) annotation (Line(points={{-1,74},{-60,74},{
          -60,146},{-210,146}}, color={0,0,127}));
  connect(supTemSetPoi.uSupFan, supFan.ySupFan) annotation (Line(points={{-1,70},
          {-84,70},{-84,117},{-139,117}}, color={255,0,255}));
  connect(supTemSetPoi.uZonTemResReq, uZonTemResReq) annotation (Line(points={{-1,66},
          {-52,66},{-52,-160},{-210,-160}}, color={255,127,0}));
  connect(supTemSetPoi.uOpeMod, uOpeMod) annotation (Line(points={{-1,62},{-48,
          62},{-48,-120},{-210,-120}}, color={255,127,0}));
  connect(supFan.uOpeMod, uOpeMod)
    annotation (Line(points={{-162,118},{-180,118},{-180,-120},{-210,-120}},
      color={255,127,0}));
  connect(supFan.uZonPreResReq, uZonPreResReq)
    annotation (Line(points={{-162,107},{-176,107},{-176,-180},{-210,-180}},
      color={255,127,0}));
  connect(supFan.ducStaPre, ducStaPre)
    annotation (Line(points={{-162,102},{-210,102}},
      color={0,0,127}));
  connect(eco.VOutMinSet_flow_normalized, outAirSetPoi.VOutMinSet_flow)
    annotation (Line(points={{139.375,-70},{-4,-70},{-4,40},{-19,40}},
      color={0,0,127}));
  connect(outAirSetPoi.nOcc, nOcc)
    annotation (Line(points={{-41,48},{-128,48},{-128,80},{-210,80}},
      color={0,0,127}));
  connect(outAirSetPoi.TZon, TZon)
    annotation (Line(points={{-41,45},{-132,45},{-132,60},{-210,60}},
      color={0,0,127}));
  connect(outAirSetPoi.TDis, TDis)
    annotation (Line(points={{-41,42},{-210,42}},
      color={0,0,127}));
  connect(supFan.ySupFan, outAirSetPoi.uSupFan)
    annotation (Line(points={{-139,117},{-84,117},{-84,36},{-41,36}},
      color={255,0,255}));
  connect(supTemSetPoi.TZonSetAve, TZonSetPoiAve.y)
    annotation (Line(points={{-1,78},{-20,78},{-20,200.2},{-139,200.2}},
      color={0,0,127}));
  connect(outAirSetPoi.VDis_flow, VDis_flow)
    annotation (Line(points={{-41,31},{-184,31},{-184,120},{-210,120}},
      color={0,0,127}));
  connect(supFan.VDis_flow, VDis_flow)
    annotation (Line(points={{-162,113},{-184,113},{-184,120},{-210,120}},
      color={0,0,127}));
  connect(supFan.ySupFan, ySupFan)
    annotation (Line(points={{-139,117},{180,117},{180,160},{210,160}},
      color={255,0,255}));
  connect(outAirSetPoi.uOpeMod, uOpeMod)
    annotation (Line(points={{-41,34},{-120,34},{-120,-120},{-210,-120}},
      color={255,127,0}));
  connect(TZonSetPoiAve.u2, TZonCooSet)
    annotation (Line(points={{-162,194},{-180,194},{-180,190},{-210,190}},
      color={0,0,127}));
  connect(eco.TMix, TMix)
    annotation (Line(points={{139.375,-71.875},{-10,-71.875},{-10,-100},{-210,
          -100}}, color={0,0,127}));
  connect(TSup, val.TSup)
    annotation (Line(points={{-210,10},{79,10}},
      color={0,0,127}));
  connect(supFan.ySupFan, val.uSupFan)
    annotation (Line(points={{-139,117},{-84,117},{-84,5},{79,5}},
      color={255,0,255}));
  connect(val.uTSup, eco.uTSup)
    annotation (Line(points={{101,14},{120,14},{120,-66.875},{139.375,-66.875}},
      color={0,0,127}));
  connect(val.yHea, yHea)
    annotation (Line(points={{101,10},{180,10},{180,20},{210,20}},
      color={0,0,127}));
  connect(val.yCoo, yCoo)
    annotation (Line(points={{101,6},{180,6},{180,-24},{210,-24}},
      color={0,0,127}));
  connect(outAirSetPoi.uWin, uWin)
    annotation (Line(points={{-41,38},{-120,38},{-120,169},{-211,169}},
      color={255,0,255}));
  connect(supTemSetPoi.TSupSet, val.TSupSet)
    annotation (Line(points={{21,70},{40,70},{40,15},{79,15}},
      color={0,0,127}));
  connect(TZonHeaSet, TZonSetPoiAve.u1)
    annotation (Line(points={{-210,210},{-180,210},{-180,206},{-162,206}},
      color={0,0,127}));
  connect(eco.uFreProSta, uFreProSta)
    annotation (Line(points={{139.375,-79.375},{70,-79.375},{70,-200},{-210,
          -200}}, color={255,127,0}));
  connect(eco.VOut_flow_normalized, VOut_flow_normalized.y) annotation (Line(
        points={{139.375,-68.75},{60,-68.75},{60,-30},{41,-30}}, color={0,0,127}));
  connect(outAirSetPoi.VDesOutMin_flow_nominal, VOut_flow_normalized.u2)
    annotation (Line(points={{-19,45},{0,45},{0,-36},{18,-36}}, color={0,0,127}));
  connect(VOut_flow_normalized.u1, VOut_flow) annotation (Line(points={{18,-24},
          {-160,-24},{-160,-80},{-210,-80}}, color={0,0,127}));

annotation (defaultComponentName="conAHU",
    Diagram(coordinateSystem(extent={{-200,-240},{200,240}}, initialScale=0.2)),
    Icon(coordinateSystem(extent={{-200,-240},{200,240}}, initialScale=0.2),
        graphics={Rectangle(
          extent={{200,280},{-200,-280}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-148,328},{152,288}},
          textString="%name",
          lineColor={0,0,255})}),
Documentation(info="<html>
<p>
Block that is applied for multizone VAV AHU control. It outputs the supply fan status
and the operation speed, outdoor and return air damper position, supply air
temperature setpoint and the valve position of the cooling and heating coils.
It is implemented according to the ASHRAE Guideline 36, PART5.N.
</p>
<p>
The sequence consists of five subsequences.
</p>
<h4>Supply fan speed control</h4>
<p>
The fan speed control is implemented according to PART5.N.1. It outputs
the boolean signal <code>ySupFan</code> to turn on or off the supply fan.
In addition, based on the pressure reset request <code>uZonPreResReq</code>
from the VAV zones controller, the
sequence resets the duct pressure setpoint, and uses this setpoint
to modulate the fan speed <code>ySupFanSpe</code> using a PI controller.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan</a>
for more detailed description.
</p>
<h4>Minimum outdoor airflow setting</h4>
<p>
According to current occupany <code>nOcc</code>, supply operation status
<code>ySupFan</code>, zone temperatures <code>TZon</code> and the discharge
air temperature <code>TDis</code>, the sequence computes the minimum outdoor airflow rate
setpoint, which is used as input for the economizer control. More detailed
information can be found in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow</a>.
</p>
<h4>Economizer control</h4>
<p>
The block outputs outdoor and return air damper position, <code>yOutDamPos</code> and
<code>yRetDamPos</code>. First, it computes the position limits to satisfy the minimum
outdoor airflow requirement. Second, it determines the availability of the economizer based
on the outdoor condition. The dampers are modulated to track the supply air temperature
loop signal, which is calculated from the sequence below, subject to the minimum outdoor airflow
requirement and economizer availability. Optionally, there is also an override for freeze protection.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller</a>
for more detailed description.
</p>
<h4>Supply air temperature setpoint</h4>
<p>
Based on PART5.N.2, the sequence first sets the maximum supply air temperature
based on reset requests collected from each zone <code>uZonTemResReq</code>. The
outdoor temperature <code>TOut</code> and operation mode <code>uOpeMod</code> are used
along with the maximum supply air temperature, for computing the supply air temperature
setpoint. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature</a>
for more detailed description.
</p>
<h4>Coil valve control</h4>
<p>
The subsequence retrieves supply air temperature setpoint from previous sequence.
Along with the measured supply air temperature and the supply fan status, it
generates coil valve positions. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplySignals\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplySignals</a>
</p>
</html>",
revisions="<html>
<ul>
<li>
October 27, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
