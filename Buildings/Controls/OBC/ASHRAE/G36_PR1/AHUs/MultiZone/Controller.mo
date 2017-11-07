within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone;
block Controller "Multizone AHU controller that composes subsequences for controlling fan speed, dampers, and supply air temperature"

  parameter Modelica.SIunits.Time samplePeriod=120
    "Sample period of component, set to the same value to the trim and respond sequence";
  parameter Real uHeaMax(min=-0.9)=-0.25
    "Upper limit of controller signal when heating coil is off. Require -1 < uHeaMax < uCooMin < 1.";
  parameter Real uCooMin(max=0.9)=0.25
    "Lower limit of controller signal when cooling coil is off. Require -1 < uHeaMax < uCooMin < 1.";
  parameter Integer numZon(min=2) "Total number of served VAV boxes"
    annotation (Dialog(group="System and building parameters"));
  parameter Modelica.SIunits.Area zonAre[numZon] "Area of each zone"
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
    annotation (Dialog(group="Economizer PID controller"));
  parameter Modelica.SIunits.Time TiMinOut=120
    "Time constant of controller for minimum outdoor air intake"
    annotation (Dialog(group="Economizer PID controller"));
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
      Dialog(group="Fan speed PID controller"));
  parameter Modelica.SIunits.Time TiFanSpe=60
    "Time constant of integrator block in fan PID controller"
    annotation (Evaluate=true,
      Dialog(group="Fan speed PID controller"));
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
      Dialog(tab="MinOutAirSetting"));
  parameter Real zonDisEffCoo[numZon]=
     fill(1.0, outAirSetPoi.numZon)
    "Zone air distribution effectiveness during cooling"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting"));
  parameter Real occDen[numZon](each final unit="1/m2")=
     fill(0.05, outAirSetPoi.numZon)
    "Default number of person in unit area"
    annotation (Evaluate=true,
      Dialog(tab="MinOutAirSetting", group="Nominal conditions"));
  parameter Real outAirPerAre[numZon](each final unit = "m3/(s.m2)")=
     fill(3e-4, outAirSetPoi.numZon)
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
  parameter Modelica.SIunits.Temperature iniSetSupTem=supTemSetPoi.maxSet
    "Initial setpoint for supply temperature control" annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));
  parameter Modelica.SIunits.Temperature maxSetSupTem=supTemSetPoi.TSupMax
    "Maximum setpoint for supply temperature control" annotation (Evaluate=true,
      Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));
  parameter Modelica.SIunits.Temperature minSetSupTem=supTemSetPoi.TSupDes
    "Minimum setpoint for supply temperature control" annotation (Evaluate=true,
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
  parameter Real kPTSup=0.05
    "Gain of controller for supply air temperature signal"
    annotation (Evaluate=true,
      Dialog(group="Supply air temperature PID controller"));
  parameter Modelica.SIunits.Time TiTSup=300
    "Time constant of integrator block for supply temperature control signal"
    annotation (Evaluate=true,
      Dialog(group="Supply air temperature PID controller"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VBox_flow[numZon](
    each final unit="m3/s",
    each quantity="VolumeFlowRate",
    min=0)
    "Primary airflow rate to the ventilation zone from the air handler, including outdoor air and recirculated air"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}}),
      iconTransformation(extent={{-220,-80},{-200,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured mixed air temperature, used for freeze protection"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}}),
      iconTransformation(extent={{-220,-100},{-200,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ducStaPre(
    final unit="Pa",
    displayUnit="Pa")
    "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-180,112},{-160,132}}),
      iconTransformation(extent={{-220,-50},{-200,-30}})));
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
    annotation (Placement(transformation(extent={{-180,-22},{-160,-2}}),
      iconTransformation(extent={{-220,100},{-200,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-180,-42},{-160,-22}}),
      iconTransformation(extent={{-220,80},{-200,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-180,-54},{-160,-34}}),
      iconTransformation(extent={{-220,60},{-200,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}}),
      iconTransformation(extent={{-220,30},{-200,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Zone air temperature heating setpoint"
    annotation (Placement(transformation(extent={{-180,220},{-160,240}}),
      iconTransformation(extent={{-220,260},{-200,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured outdoor volumetric airflow rate"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}}),
      iconTransformation(extent={{-220,-30},{-200,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc[numZon] if have_occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}}),
      iconTransformation(extent={{-220,-10},{-200,10}})));
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
    annotation (Placement(transformation(extent={{-182,-190},{-162,-170}}),
      iconTransformation(extent={{-220,-240},{-200,-220}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}}),
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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin[numZon] if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-182,178},{-160,200}}),
      iconTransformation(extent={{-220,10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Setpoint for supply air temperature"
    annotation (Placement(transformation(extent={{180,70},{200,90}}),
      iconTransformation(extent={{200,-80},{220,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final min=0,
    final max=1,
    final unit="1")
    "Control signal for heating"
    annotation (Placement(transformation(extent={{180,30},{200,50}}),
      iconTransformation(extent={{200,-140},{220,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final min=0,
    final max=1,
    final unit="1") "Control signal for cooling"
    annotation (Placement(transformation(extent={{182,-14},{202,6}}),
      iconTransformation(extent={{200,-200},{220,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
    final min=0,
    final max=1,
    final unit="1") "Supply fan speed"
    annotation (Placement(transformation(extent={{180,120},{200,140}}),
      iconTransformation(extent={{200,112},{220,132}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position"
    annotation (Placement(transformation(extent={{180,-50},{200,-30}}),
      iconTransformation(extent={{200,-10},{220,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Outdoor air damper position"
    annotation (Placement(transformation(extent={{180,-160},{200,-140}}),
      iconTransformation(extent={{200,50},{220,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySupFan
    "Supply fan status, true if fan should be on"
    annotation (Placement(transformation(extent={{180,170},{200,190}}),
      iconTransformation(extent={{200,170},{220,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Average TZonSetPoiAve
    "Average of all zone set points"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
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
    final peaSysPop=peaSysPop,
    have_winSen=have_winSen)
    "Controller for minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-60,48},{-40,68}})));
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
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyTemperature
    supTemSetPoi(
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
    final maxRes=maxResSupTem) "Setpoint for supply temperature"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Controller eco(
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
    final delta=delta) "Economizer controller"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.Valve val(
    final uHeaMax=uHeaMax,
    final uCooMin=uCooMin,
    final kPTSup=kPTSup,
    final TiTSup=TiTSup) "AHU coil valve control"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(eco.yRetDamPos, yRetDamPos) annotation (Line(points={{140.625,-45},{160,
          -45},{160,-40},{190,-40}}, color={0,0,127}));
  connect(eco.yOutDamPos, yOutDamPos) annotation (Line(points={{140.625,-55},{160,
          -55},{160,-150},{190,-150}}, color={0,0,127}));
  connect(eco.uSupFan, conSupFan.ySupFan) annotation (Line(points={{119.375,-53.75},
          {-84,-53.75},{-84,137},{-99,137}}, color={255,0,255}));
  connect(conSupFan.ySupFanSpe, ySupFanSpe)
    annotation (Line(points={{-99,130},{190,130}},
      color={0,0,127}));
  connect(TOut, eco.TOut) annotation (Line(points={{-170,166},{-20,166},{-20,-41.25},
          {119.375,-41.25}}, color={0,0,127}));
  connect(eco.TOutCut, TOutCut) annotation (Line(points={{119.375,-42.5},{-34,-42.5},
          {-34,-12},{-170,-12}}, color={0,0,127}));
  connect(eco.hOut, hOut) annotation (Line(points={{119.375,-43.75},{-38,-43.75},
          {-38,-32},{-170,-32}}, color={0,0,127}));
  connect(eco.hOutCut, hOutCut) annotation (Line(points={{119.375,-45},{-54,-45},
          {-54,-44},{-170,-44}}, color={0,0,127}));
  connect(eco.VOut_flow, VOut_flow) annotation (Line(points={{119.375,-48.75},{-50,
          -48.75},{-50,-60},{-170,-60}}, color={0,0,127}));
  connect(eco.uOpeMod, uOpeMod) annotation (Line(points={{119.375,-56.25},{100,
          -56.25},{100,-100},{-170,-100}},
                                   color={255,127,0}));
  connect(eco.uZonSta, uZonSta) annotation (Line(points={{119.375,-57.5},{112,
          -57.5},{112,-58},{104,-58},{104,-120},{-170,-120}},
                                   color={255,127,0}));
  connect(eco.uFreProSta, uFreProSta) annotation (Line(points={{119.375,-58.75},
          {110,-58.75},{110,-140},{-170,-140}}, color={255,127,0}));
  connect(supTemSetPoi.TSetSup, TSetSup)
    annotation (Line(points={{21,80},{190,80}}, color={0,0,127}));
  connect(supTemSetPoi.TOut, TOut) annotation (Line(points={{-1,84},{-20,84},{-20,
          166},{-170,166}}, color={0,0,127}));
  connect(supTemSetPoi.uSupFan, conSupFan.ySupFan) annotation (Line(points={{-1,
          80},{-84,80},{-84,137},{-99,137}}, color={255,0,255}));
  connect(supTemSetPoi.uZonTemResReq, uZonTemResReq) annotation (Line(points={{-1,
          76},{-12,76},{-12,-180},{-172,-180}}, color={255,127,0}));
  connect(supTemSetPoi.uOpeMod, uOpeMod) annotation (Line(points={{-1,72},{-24,
          72},{-24,-100},{-170,-100}},
                                   color={255,127,0}));
  connect(conSupFan.uOpeMod, uOpeMod)
    annotation (Line(points={{-122,138},{-140,138},{-140,-100},{-170,-100}},
      color={255,127,0}));
  connect(conSupFan.uZonPreResReq, uZonPreResReq)
    annotation (Line(points={{-122,127},{-136,127},{-136,-160},{-170,-160}},
      color={255,127,0}));
  connect(conSupFan.ducStaPre, ducStaPre)
    annotation (Line(points={{-122,122},{-170,122}},
      color={0,0,127}));
  connect(eco.VOutMinSet_flow, outAirSetPoi.VOutMinSet_flow) annotation (Line(
        points={{119.375,-50},{-30,-50},{-30,58},{-39,58}}, color={0,0,127}));
  connect(outAirSetPoi.nOcc, nOcc)
    annotation (Line(points={{-61,66},{-116,66},{-116,100},{-170,100}},
      color={0,0,127}));
  connect(outAirSetPoi.TZon, TZon)
    annotation (Line(points={{-61,63},{-120,63},{-120,80},{-170,80}},
      color={0,0,127}));
  connect(outAirSetPoi.TDis, TDis)
    annotation (Line(points={{-61,60},{-170,60}},
      color={0,0,127}));
  connect(conSupFan.ySupFan, outAirSetPoi.uSupFan)
    annotation (Line(points={{-99,137},{-84,137},{-84,54},{-61,54}},
      color={255,0,255}));
  connect(supTemSetPoi.TSetZones, TZonSetPoiAve.y) annotation (Line(points={{-1,
          88},{-16,88},{-16,220.2},{-99,220.2}}, color={0,0,127}));
  connect(outAirSetPoi.VBox_flow, VBox_flow)
    annotation (Line(points={{-61,49},{-144,49},{-144,140},{-170,140}},
      color={0,0,127}));
  connect(conSupFan.VBox_flow, VBox_flow)
    annotation (Line(points={{-122,133},{-144,133},{-144,140},{-170,140}},
      color={0,0,127}));
  connect(conSupFan.ySupFan, ySupFan)
    annotation (Line(points={{-99,137},{120,137},{120,180},{190,180}},
      color={255,0,255}));
  connect(outAirSetPoi.uOpeMod, uOpeMod)
    annotation (Line(points={{-61,52},{-116,52},{-116,-100},{-170,-100}},
      color={255,127,0}));
  connect(TZonSetPoiAve.u2, TCooSet) annotation (Line(points={{-122,214},{-140,214},
          {-140,210},{-170,210}}, color={0,0,127}));
  connect(eco.TMix, TMix) annotation (Line(points={{119.375,-51.875},{-46,-51.875},
          {-46,-80},{-170,-80}}, color={0,0,127}));
  connect(TSup, val.TSup) annotation (Line(points={{-170,40},{-146,40},{-146,0},
          {59,0}}, color={0,0,127}));
  connect(conSupFan.ySupFan, val.uSupFan) annotation (Line(points={{-99,137},{-84,
          137},{-84,-5},{59,-5}}, color={255,0,255}));
  connect(val.uTSup, eco.uTSup) annotation (Line(points={{81,4},{100,4},{100,-46.875},
          {119.375,-46.875}}, color={0,0,127}));
  connect(val.yHea, yHea) annotation (Line(points={{81,0},{140,0},{140,40},{190,
          40}}, color={0,0,127}));
  connect(val.yCoo, yCoo)
    annotation (Line(points={{81,-4},{192,-4}}, color={0,0,127}));
  connect(outAirSetPoi.uWin, uWin)
    annotation (Line(points={{-61,56},{-80,56},{-80,189},{-171,189}},
      color={255,0,255}));
  connect(supTemSetPoi.TSetSup, val.TSetSup)
    annotation (Line(points={{21,80},{40,80},{40,5},{59,5}}, color={0,0,127}));
  connect(yOutDamPos, yOutDamPos)
    annotation (Line(points={{190,-150},{190,-150}}, color={0,0,127}));
  connect(THeaSet, TZonSetPoiAve.u1) annotation (Line(points={{-170,230},{-140,230},
          {-140,226},{-122,226}}, color={0,0,127}));
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
Block that is applied for multizone VAV AHU control. It outputs the supply fan status
and the operation speed, outdoor and return air damper position, supply air 
temperature setpoint and the valve position of the cooling and heating coils.
It is implemented according to the ASHRAE Guideline 36, PART5.N.
</p>
<p>
The sequence consists of five subsequences.
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
loop signal, which is calculated from the sequence below. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Controller</a>
for more detailed description.
</p>
<h4>d. Supply air temperature setpoint</h4>
<p>
Based on PART5.N.2, the sequence firstly set the maximum supply air temperature 
based on reset requests collected from each zone <code>uZonTemResReq</code>. The 
outdoor temperature <code>TOut</code>, operation mode <code>uOpeMod</code> are used
along with the maximum supply air temperature, for setting supply air temperature 
setpoint. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyTemperature\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyTemperature</a>
for more detailed description.
</p>
<h4>e. Coil valve control</h4>
<p>
The subsequence retrieves supply air temperature setpoint from previous sequence. 
Along with the measured supply air temperature and the supply fan status, it
generates coil valve positions. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.Valve\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.Valve</a> 
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
