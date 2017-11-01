within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone;
block Controller "Multizone AHU controller that composes subsequences for controlling fan speed, dampers, and supply air temperature"

  parameter Modelica.SIunits.Time samplePeriod=120
    "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";
  parameter Real uHeaMax(min=-0.9)=-0.25
    "Upper limit of controller signal when heating coil is off. Require -1 < uHeaMax < uCooMin < 1.";
  parameter Real uCooMin(max=0.9)=0.25
    "Lower limit of controller signal when cooling coil is off. Require -1 < uHeaMax < uCooMin < 1.";

  parameter Integer numZon(min=2) "Total number of served zones/VAV boxes"
    annotation (Dialog(group="System and building parameters"));
  parameter Modelica.SIunits.Area zonAre[numZon] "Area of each zone"
    annotation (Dialog(group="System and building parameters"));
  parameter Boolean have_occSen[numZon]
    "Set to true if zones have occupancy sensor"
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
  parameter Modelica.SIunits.Time delta=120
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
  parameter Real kPMinOut=0.05
    "Proportional gain of controller for minimum outdoor air intake"
    annotation (Dialog(tab="Economizer", group="Damper limits"));
  parameter Modelica.SIunits.Time TiMinOut=120
    "Time constant of controller for minimum outdoor air intake"
    annotation (Dialog(tab="Economizer", group="Damper limits"));
  parameter Real yMinDamLim=0
    "Lower limit of damper position limits control signal output"
    annotation (Evaluate=true,
      Dialog(tab="Economizer", group="Damper limits"));
  parameter Real yMaxDamLim=1
    "Upper limit of damper position limits control signal output"
    annotation (Evaluate=true,
      Dialog(tab="Economizer", group="Damper limits"));
  parameter Modelica.SIunits.Temperature TFreSet = 277.15
    "Lower limit for mixed air temperature for freeze protection"
     annotation(Evaluate=true, Dialog(tab="Economizer", group="Freeze protection"));
  parameter Real kPFre = 1
    "Proportional gain for mixed air temperature tracking for freeze protection"
     annotation(Evaluate=true, Dialog(tab="Economizer", group="Freeze protection"));
  parameter Modelica.SIunits.Time retDamFulOpeTim=180
    "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations"
    annotation (Evaluate=true, Dialog(tab="Economizer", group="Economizer delays at disable"));
  parameter Modelica.SIunits.Time disDel=15
    "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
    annotation (Evaluate=true,Dialog(tab="Economizer", group="Economizer delays at disable"));

  // ----------- parameters for fan speed control  -----------
  parameter Modelica.SIunits.PressureDifference maxDesPre(
    min=0,
    displayUnit="Pa") = 410
    "Duct design maximum static pressure"
    annotation (Evaluate=true,Dialog(tab="Fan speed"));

  parameter Modelica.SIunits.PressureDifference iniSetFanSpe(displayUnit="Pa")=60
    "Initial pressure setpoint for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Modelica.SIunits.PressureDifference minSetFanSpe(displayUnit="Pa")=25
    "Minimum pressure setpoint for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Modelica.SIunits.PressureDifference maxSetFanSpe(displayUnit="Pa")=conSupFan.maxDesPre
    "Maximum pressure setpoint for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Modelica.SIunits.Time delTimFanSpe=600
    "Delay time for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Integer numIgnReqFanSpe=2
    "Number of ignored requests for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Modelica.SIunits.PressureDifference triAmoFanSpe(displayUnit="Pa")=-12.0
    "Trim amount for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Modelica.SIunits.PressureDifference resAmoFanSpe(displayUnit="Pa")=15
    "Respond amount (must be opposite in to triAmo) for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Modelica.SIunits.PressureDifference maxResFanSpe(displayUnit="Pa")=32
    "Maximum response per time interval (same sign as resAmo) for fan speed control"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real kPFanSpe=0.5
    "Gain of fan PID controller"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="PID controller"));
  parameter Modelica.SIunits.Time TiFanSpe=60
    "Time constant of integrator block in fan PID controller"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="PID controller"));
  parameter Real yFanMax=1 "Maximum allowed fan speed"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="PID controller"));
  parameter Real yFanMin=0.1 "Lowest allowed fan speed if fan is on"
    annotation (Evaluate=true,
      Dialog(tab="Fan speed", group="PID controller"));

  // ----------- parameters for minimum outdoor airflow setting  -----------
  parameter Real zonDisEffHea[numZon]=fill(0.8, outAirSetPoi.numZon)
    "Zone air distribution effectiveness during heating"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting"));
  parameter Real zonDisEffCoo[numZon]=fill(1.0, outAirSetPoi.numZon)
    "Zone air distribution effectiveness during cooling"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting"));
  parameter Real occDen[numZon]=fill(0.05, outAirSetPoi.numZon)
    "Default number of person in unit area"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting", group="Nominal conditions"));
  parameter Real outAirPerAre[numZon]=fill(3e-4, outAirSetPoi.numZon)
    "Outdoor air rate per unit area"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate outAirPerPer[numZon]=
    fill(2.5e-3, outAirSetPoi.numZon)
    "Outdoor air rate per person"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numZon]
    "Minimum expected zone primary flow rate"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate maxSysPriFlo
    "Maximum expected system primary airflow at design stage"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting", group="Nominal conditions"));
  parameter Real desZonDisEff[numZon]=fill(1.0, outAirSetPoi.numZon)
    "Design zone air distribution effectiveness"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting", group="Nominal conditions"));
  parameter Real desZonPop[numZon]={
    outAirSetPoi.occDen[i]*outAirSetPoi.zonAre[i]
    for i in 1:outAirSetPoi.numZon}
    "Design zone population during peak occupancy"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting", group="Nominal conditions"));
  parameter Real peaSysPop=1.2*sum(
    {outAirSetPoi.occDen[iZon]*outAirSetPoi.zonAre[iZon]
    for iZon in 1:outAirSetPoi.numZon})
    "Peak system population"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting", group="Nominal conditions"));
  parameter Real uLow=-0.5
    "If zone space temperature minus supply air temperature is less than uLow,
    then it should use heating supply air distribution effectiveness"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting", group="Advanced"));
  parameter Real uHig=0.5
    "If zone space temperature minus supply air temperature is more than uHig,
    then it should use cooling supply air distribution effectiveness"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting", group="Advanced"));

  // ----------- parameters for supply air temperature control  -----------
  parameter Modelica.SIunits.Temperature TSupMin=285.15
    "Lowest cooling supply air temperature setpoint"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Modelica.SIunits.Temperature TSupMax=291.15
    "Highest cooling supply air temperature setpoint. It is typically 18 degC (65 degF) in mild and dry climates, 16 degC (60 degF) or lower in humid climates"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Modelica.SIunits.Temperature TSupDes=286.15
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
  parameter Modelica.SIunits.Temperature iniSetSupTem=conTSetSup.maxSet
    "Initial setpoint for supply temperature control"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));
  parameter Modelica.SIunits.Temperature maxSetSupTem=conTSetSup.TSupMax
    "Maximum setpoint for supply temperature control"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));
  parameter Modelica.SIunits.Temperature minSetSupTem=conTSetSup.TSupDes
    "Minimum setpoint for supply temperature control"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));
  parameter Modelica.SIunits.Time delTimSupTem=600
    "Delay timer for supply temperature control"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));
  parameter Integer ignReqSupTem=2
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
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
      Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for supply air temperature signal"
    annotation (Dialog(tab="Supply air temperature", group="PID controller"));
  parameter Real kPTSup=0.05
    "Gain of controller for supply air temperature signal"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="PID controller"));
  parameter Modelica.SIunits.Time TiTSup=300
    "Time constant of integrator block for supply temperature control signal"
    annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="PID controller"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VBox_flow[numZon](
    each final unit="m3/s",
    each quantity="VolumeFlowRate",
    min=0)
    "Primary airflow rate to the ventilation zone from the air handler, including outdoor air and recirculated air"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}}),
      iconTransformation(extent={{-220,-60},{-200,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured mixed air temperature, used for freeze protection"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}}),
      iconTransformation(extent={{-220,-100},{-200,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ducStaPre(
    final unit="Pa",
    displayUnit="Pa")
    "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-180,112},{-160,132}}),
      iconTransformation(extent={{-220,-30},{-200,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Outdoor air (OA) temperature"
    annotation (Placement(transformation(extent={{-180,156},{-160,176}}),
      iconTransformation(extent={{-220,200},{-200,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}}),
      iconTransformation(extent={{-220,100},{-200,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}}),
      iconTransformation(extent={{-220,80},{-200,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}}),
      iconTransformation(extent={{-220,60},{-200,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-180,-58},{-160,-38}}),
      iconTransformation(extent={{-220,30},{-200,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Zone air temperature heating setpoint"
    annotation (Placement(transformation(extent={{-180,218},{-160,238}}),
      iconTransformation(extent={{-220,260},{-200,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured outdoor volumetric airflow rate"
    annotation (Placement(transformation(extent={{-180,-26},{-160,-6}}),
      iconTransformation(extent={{-220,-10},{-200,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc[numZon]
    "Number of occupants"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}}),
      iconTransformation(extent={{-220,10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[numZon](
    each final unit="K",
    each final quantity="ThermodynamicTemperature")
    "Measured zone air temperature"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}}),
      iconTransformation(extent={{-220,180},{-200,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis[numZon](
    each final unit="K",
    each final quantity="ThermodynamicTemperature")
    "Discharge air temperature"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}}),
      iconTransformation(extent={{-220,140},{-200,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Zone air temperature cooling setpoint"
    annotation (Placement(transformation(extent={{-180,200},{-160,220}}),
      iconTransformation(extent={{-220,240},{-200,260}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}}),
      iconTransformation(extent={{-220,-240},{-200,-220}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}}),
      iconTransformation(extent={{-220,-260},{-200,-240}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta
    "Zone state signal"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}}),
      iconTransformation(extent={{-220,-170},{-200,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection status"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}}),
      iconTransformation(extent={{-220,-200},{-200,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}}),
      iconTransformation(extent={{-220,-140},{-200,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Setpoint for supply air temperature"
    annotation (Placement(transformation(extent={{180,-54},{200,-34}}),
      iconTransformation(extent={{200,-80},{220,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final min=0,
    final max=1,
    final unit="1")
    "Control signal for heating"
    annotation (Placement(transformation(extent={{180,-130},{200,-110}}),
      iconTransformation(extent={{200,-140},{220,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final min=0,
    final max=1,
    final unit="1") "Control signal for cooling"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}}),
      iconTransformation(extent={{200,-200},{220,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
    final min=0,
    final max=1,
    final unit="1") "Supply fan speed"
    annotation (Placement(transformation(extent={{180,100},{200,120}}),
      iconTransformation(extent={{200,112},{220,132}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position"
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
      iconTransformation(extent={{200,-10},{220,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Outdoor air damper position"
    annotation (Placement(transformation(extent={{180,50},{200,70}}),
      iconTransformation(extent={{200,50},{220,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySupFan
    "Supply fan status, true if fan should be on"
    annotation (Placement(transformation(extent={{180,170},{200,190}}),
        iconTransformation(extent={{200,170},{220,190}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.OutsideAirFlow
    outAirSetPoi(
    final zonAre=zonAre,
    final maxSysPriFlo=maxSysPriFlo,
    final minZonPriFlo=minZonPriFlo,
    final numZon=numZon,
    final have_occSen=have_occSen,
    final outAirPerAre=outAirPerAre,
    final outAirPerPer=outAirPerPer,
    final occDen=occDen,
    final zonDisEffHea=zonDisEffHea,
    final zonDisEffCoo=zonDisEffCoo,
    final desZonDisEff=desZonDisEff,
    final desZonPop=desZonPop,
    final uLow=uLow,
    final uHig=uHig,
    final peaSysPop=peaSysPop)
    "Controller for minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Controller
    conEco(
    final use_enthalpy=use_enthalpy,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamFulOpeTim=retDamFulOpeTim,
    final disDel=disDel,
    final kPMinOut=kPMinOut,
    final TiMinOut=TiMinOut,
    final retDamPhyPosMax=retDamPhyPosMax,
    final retDamPhyPosMin=retDamPhyPosMin,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final uHeaMax=uHeaMax,
    final uCooMin=uCooMin,
    final uOutDamMax=(uHeaMax + uCooMin)/2,
    final uRetDamMin=(uHeaMax + uCooMin)/2,
    final TFreSet=TFreSet,
    final kPFre=kPFre,
    final delta=delta)       "Economizer controller"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyFan
    conSupFan(
    final numZon=numZon,
    final maxDesPre=maxDesPre,
    final samplePeriod=samplePeriod,
    final have_perZonRehBox=have_perZonRehBox,
    final have_duaDucBox=have_duaDucBox,
    final have_airFloMeaSta=have_airFloMeaSta,
    final iniSet=iniSetFanSpe,
    final minSet=minSetFanSpe,
    final maxSet=maxSetFanSpe,
    final delTim=delTimFanSpe,
    final numIgnReq=numIgnReqFanSpe,
    final triAmo=triAmoFanSpe,
    final resAmo=resAmoFanSpe,
    final maxRes=maxResFanSpe,
    final k=kPFanSpe,
    final Ti=TiFanSpe,
    final yFanMax=yFanMax,
    final yFanMin=yFanMin)
    "Supply fan controller"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyTemperature
    conTSetSup(
    final samplePeriod=samplePeriod,
    final TSupMin=TSupMin,
    final TSupMax=TSupMax,
    final TSupDes=TSupDes,
    final TOutMin=TOutMin,
    final TOutMax=TOutMax,
    final iniSet=iniSetSupTem,
    final maxSet=maxSetSupTem,
    final minSet=minSetSupTem,
    final delTim=delTimSupTem,
    final ignReq=ignReqSupTem,
    final triAmo=triAmoSupTem,
    final resAmo=resAmoSupTem,
    final maxRes=maxResSupTem)
    "Setpoint for supply temperature"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Average TZonSetAve
    "Average of all zone set points"
    annotation (Placement(transformation(extent={{0,210},{20,230}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winOpe[numZon](
    each final k=false)
    "Window opening signal"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));

equation
  connect(conEco.yRetDamPos, yRetDamPos)
    annotation (Line(points={{100.625,15},{160,15},{160,0},{190,0}},
      color={0,0,127}));
  connect(conEco.yOutDamPos, yOutDamPos)
    annotation (Line(points={{100.625,5},{140,5},{140,60},{190,60}},
      color={0,0,127}));
  connect(conEco.uSupFan, conSupFan.ySupFan)
    annotation (Line(points={{79.375,6.25},{50,6.25},{50,137},{21,137}},
      color={255,0,255}));
  connect(conSupFan.ySupFanSpe, ySupFanSpe)
    annotation (Line(points={{21,130},{120,130},{120,110},{190,110}},
      color={0,0,127}));
  connect(TOut, conEco.TOut)
    annotation (Line(points={{-170,166},{-42,166},{-42,18.75},{79.375,18.75}},
      color={0,0,127}));
  connect(conEco.TOutCut, TOutCut)
    annotation (Line(points={{79.375,17.5},{-46,17.5},{-46,40},{-170,40}},
      color={0,0,127}));
  connect(conEco.hOut, hOut)
    annotation (Line(points={{79.375,16.25},{-50,16.25},{-50,20},{-170,20}},
      color={0,0,127}));
  connect(conEco.hOutCut, hOutCut)
    annotation (Line(points={{79.375,15},{-54,15},{-54,0},{-170,0}},
      color={0,0,127}));
  connect(conEco.VOut_flow, VOut_flow)
    annotation (Line(points={{79.375,11.25},{-50,11.25},{-50,-16},{-170,-16}},
      color={0,0,127}));
  connect(conEco.uOpeMod, uOpeMod)
    annotation (Line(points={{79.375,3.75},{-44,3.75},{-44,-100},{-170,-100}},
      color={255,127,0}));
  connect(conEco.uZonSta, uZonSta)
    annotation (Line(points={{79.375,2.5},{-42,2.5},{-42,-120},{-170,-120}},
      color={255,127,0}));
  connect(conEco.uFreProSta, uFreProSta)
    annotation (Line(points={{79.375,1.25},{-40,1.25},{-40,-140},{-170,-140}},
      color={255,127,0}));
  connect(conTSetSup.TSetSup, TSetSup)
    annotation (Line(points={{101,-44},{190,-44}},
      color={0,0,127}));
  connect(conTSetSup.TOut, TOut)
    annotation (Line(points={{79,-45},{-20,-45},{-20,166},{-170,166}},
      color={0,0,127}));
  connect(conTSetSup.uSupFan, conSupFan.ySupFan)
    annotation (Line(points={{79,-52},{50,-52},{50,137},{21,137}},
      color={255,0,255}));
  connect(conTSetSup.uZonTemResReq, uZonTemResReq)
    annotation (Line(points={{79,-55},{50,-55},{50,-160},{-170,-160}},
      color={255,127,0}));
  connect(conTSetSup.uOpeMod, uOpeMod)
    annotation (Line(points={{79,-58},{54,-58},{54,-100},{-170,-100}},
      color={255,127,0}));
  connect(conSupFan.uOpeMod, uOpeMod)
    annotation (Line(points={{-2,138},{-140,138},{-140,-100},{-170,-100}},
      color={255,127,0}));
  connect(conSupFan.uZonPreResReq, uZonPreResReq)
    annotation (Line(points={{-2,127},{-136,127},{-136,-180},{-170,-180}},
      color={255,127,0}));
  connect(conSupFan.ducStaPre, ducStaPre)
    annotation (Line(points={{-2,122},{-170,122}},
      color={0,0,127}));
  connect(conEco.VOutMinSet_flow, outAirSetPoi.VOutMinSet_flow)
    annotation (Line(points={{79.375,10},{40,10},{40,70},{21,70}},
      color={0,0,127}));
  connect(outAirSetPoi.nOcc, nOcc)
    annotation (Line(points={{-1,78},{-92,78},{-92,100},{-170,100}},
      color={0,0,127}));
  connect(outAirSetPoi.TZon, TZon)
    annotation (Line(points={{-1,75},{-94,75},{-94,80},{-170,80}},
      color={0,0,127}));
  connect(outAirSetPoi.TDis, TDis)
    annotation (Line(points={{-1,72},{-94,72},{-94,60},{-170,60}},
      color={0,0,127}));
  connect(conSupFan.ySupFan, outAirSetPoi.uSupFan)
    annotation (Line(points={{21,137},{50,137},{50,100},{-88,100},{-88,66},{-1,66}},
      color={255,0,255}));
  connect(winOpe.y, outAirSetPoi.uWin)
    annotation (Line(points={{-99,190},{-84,190},{-84,68},{-1,68}},
      color={255,0,255}));
  connect(conTSetSup.TSetZones, TZonSetAve.y)
    annotation (Line(points={{79,-42},{54,-42},{54,220.2},{21,220.2}},
      color={0,0,127}));
  connect(outAirSetPoi.VBox_flow, VBox_flow)
    annotation (Line(points={{-1,61},{-144,61},{-144,140},{-170,140}},
      color={0,0,127}));
  connect(conSupFan.VBox_flow, VBox_flow)
    annotation (Line(points={{-2,133},{-144,133},{-144,140},{-170,140}},
      color={0,0,127}));
  connect(conSupFan.ySupFan, ySupFan)
    annotation (Line(points={{21,137},{50,137},{50,180},{190,180}},
      color={255,0,255}));
  connect(outAirSetPoi.uOpeMod, uOpeMod)
    annotation (Line(points={{-1,64},{-88,64},{-88,-100},{-170,-100}},
      color={255,127,0}));
  connect(TZonSetAve.u2, TCooSet)
    annotation (Line(points={{-2,214},{-66,214},{-66,210},{-170,210}},
      color={0,0,127}));
  connect(TZonSetAve.u1, THeaSet)
    annotation (Line(points={{-2,226},{-14,226},{-14,228},{-170,228}},
      color={0,0,127}));
  connect(conEco.TMix, TMix)
    annotation (Line(points={{79.375,8.125},{-46,8.125},{-46,-70},{-170,-70}},
      color={0,0,127}));
  connect(TSup, conTSetSup.TSup)
    annotation (Line(points={{-170,-48},{79,-48}}, color={0,0,127}));
  connect(conTSetSup.uTSup, conEco.uTSup)
    annotation (Line(points={{101,-48},{120,-48},{120,-20},{58,-20},{58,13.125},
          {79.375,13.125}},
                        color={0,0,127}));
  connect(conTSetSup.yHea, yHea)
    annotation (Line(points={{101,-52},{160,-52},{160,-120},{190,-120}},
      color={0,0,127}));
  connect(conTSetSup.yCoo, yCoo)
    annotation (Line(points={{101,-56},{140,-56},{140,-160},{190,-160}},
      color={0,0,127}));

annotation (
    defaultComponentName="conAHU",
    Diagram(coordinateSystem(extent={{-160,-200},{180,240}}, initialScale=0.2)),
    Icon(coordinateSystem(extent={{-160,-200},{180,240}}, initialScale=0.2),
        graphics={Rectangle(
          extent={{200,280},{-200,-260}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-148,328},{152,288}},
          textString="%name",
          lineColor={0,0,255})}),
Documentation(info="<html>
<p>
Block that is applied for multizone AHU control. It outputs the supply fan status
and the operation speed, outdoor and return air damper position, supply air 
temperature setpoint and the valve position of the cooling and heating coils.
It is implemented according to the ASHRAE Guideline 36, PART5.N.
</p>
<p>
The sequence consists of four subsequences.
</p>
<h4>a. Supply fan speed control</h4>
<p>
The fan speed control is implemented according to PART5.N.1. It outputs 
<code>ySupFan</code> to turn on or off the supply fan. By receiving the pressure
reset request <code>uZonPreResReq</code> from the serving zones controller, the 
sequence resets the duct pressure setpoint so to control the fan operation speed
<code>ySupFanSpe</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyFan\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyFan</a>
for more detailed description.
</p>
<h4>b. Minimum outdoor airflow setting</h4>
<p>
According to current occupany <code>nOcc</code>, supply operation status 
<code>ySupFan</code>, each zone temperature <code>TZon</code> and the discharge 
air temperature <code>TDis</code>, the sequence decides minimum outdoor airflow rate 
setpoint, and then to be used as input for economizer control. More detailed 
information can be found in 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.OutsideAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.OutsideAirFlow</a>.
</p>
<h4>c. Economizer control</h4>
<p>
The block outputs outdoor and return air damper position, <code>yOutDamPos</code>,
<code>yRetDamPos</code>. It firstly computes the position limits to satisfy minimum 
outdoor airflow requirement, then control the availability of the economizer based 
on outdoor condition. The dampers are modulated to track the supply air temperature 
setpoint, which is calculated from the sequence below. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Controller</a>
for more detailed description.
</p>
<h4>d. Supply air temperature control</h4>
<p>
Based on PART5.N.2, the sequence firstly set the maximum supply air temperature 
based on reset requests collected from each zone <code>uZonTemResReq</code>. The 
outdoor temperature <code>TOut</code>, operation mode <code>uOpeMod</code> are used
along with the maximum supply air temperature, for setting supply air temperature 
setpoint. It then outputs cooling and heating coil valve position <code>yCoo</code>,
<code>yHea</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyTemperature\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyTemperature</a>
for more detailed description.
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
