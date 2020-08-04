within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block Controller "Head pressure controller"

  // Economizer controller parameters

  parameter Real holdPeriod(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=1200
    "WSE minimum on or off time"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Enable parameters"));

  parameter Real delDis(
    final unit="s",
    final quantity="Time")=120
    "Delay disable time period"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Enable parameters"));

  parameter Modelica.SIunits.TemperatureDifference TOffsetEna=2
    "Temperature offset between the chilled water return upstream of WSE and the predicted WSE output"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Enable parameters"));

  parameter Modelica.SIunits.TemperatureDifference TOffsetDis=1
    "Temperature offset between the chilled water return upstream and downstream WSE"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Enable parameters"));

  parameter Modelica.SIunits.TemperatureDifference heaExcAppDes=2
    "Design heat exchanger approach"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters"));

  parameter Modelica.SIunits.TemperatureDifference cooTowAppDes=2
    "Design cooling tower approach"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters"));

  parameter Modelica.SIunits.Temperature TOutWetDes=288.15
    "Design outdoor air wet bulb temperature"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters"));

  parameter Modelica.SIunits.VolumeFlowRate VHeaExcDes_flow=0.015
    "Desing heat exchanger chilled water volume flow rate"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters"));

  parameter Modelica.SIunits.TemperatureDifference hysDt = 1
    "Deadband temperature used in hysteresis block"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Waterside economizer"));

  parameter Real step=0.02 "Tuning step"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Tuning"));

  parameter Real wseOnTimDec(
    final unit="s",
    final quantity="Time",
    final displayUnit="h") = 3600
    "Economizer enable time needed to allow decrease of the tuning parameter"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Tuning"));

  parameter Real wseOnTimInc(
    final unit="s",
    final quantity="Time",
    final displayUnit="h") = 1800
    "Economizer enable time needed to allow increase of the tuning parameter"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Tuning"));

  // Plant enable

  parameter Real schTab[4,2] = [0,1; 6*3600,1; 19*3600,1; 24*3600,1]
    "Plant enabling schedule allowing operators to lock out the plant during off-hour"
    annotation(Dialog(group="Plant enable"));

  parameter Modelica.SIunits.Temperature TChiLocOut=277.5
    "Outdoor air lockout temperature below which the chiller plant should be disabled"
    annotation(Dialog(group="Plant enable"));

  parameter Real plaThrTim(
    final unit="s",
    final quantity="Time")=15*60
      "Threshold time to check status of chiller plant"
    annotation(Dialog(group="Plant enable"));

  parameter Real reqThrTim(
    final unit="s",
    final quantity="Time")=3*60
      "Threshold time to check current chiller plant request"
    annotation(Dialog(group="Plant enable"));

  parameter Integer ignReq = 0
    "Ignorable chiller plant requests"
    annotation(Dialog(group="Plant enable"));

  parameter Real locDt = 1
    "Offset temperature for lockout chiller"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Plant enable"));

  // Head pressure

  parameter Boolean fixSpePum = true
    "Flag indicating if the plant has fixed speed condenser water pumps"
    annotation(Dialog(group="Pumps configuration", enable=not have_WSE));

  parameter Boolean have_HeaPreConSig = false
    "Flag indicating if there is head pressure control signal from chiller controller"
    annotation(Dialog(tab="Head pressure", group="Head pressure control configuration"));

  parameter Real minTowSpe=0.1
    "Minimum cooling tower fan speed"
    annotation(Dialog(tab="Head pressure", group="Limits"));

  parameter Real minConWatPumSpe=0.1
    "Minimum condenser water pump speed"
    annotation(Dialog(enable= not ((not have_WSE) and fixSpePum), tab="Head pressure", group="Limits"));

  parameter Real minHeaPreValPos=0.1
    "Minimum head pressure control valve position"
    annotation(Dialog(enable= (not ((not have_WSE) and (not fixSpePum))), tab="Head pressure", group="Limits"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHeaPre=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation(Dialog(tab="Head pressure", group="Loop signal", enable=not have_HeaPreConSig));

  parameter Modelica.SIunits.TemperatureDifference minChiLif=10
    "Minimum allowable lift at minimum load for chiller"
    annotation(Dialog(tab="Head pressure", group="Loop signal", enable=not have_HeaPreConSig));

  parameter Real kHeaPreCon=1
    "Gain of controller"
    annotation(Dialog(tab="Head pressure", group="Loop signal", enable=not have_HeaPreConSig));

  parameter Real TiHeaPreCon(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation(Dialog(tab="Head pressure", group="Loop signal", enable=not have_HeaPreConSig));


  // Minimum flow bypass

  parameter Integer nChi
    "Total number of chillers"
    annotation(Dialog(group="Chillers configuration"));

  parameter Boolean isParallelChiller
    "Flag: true means that the plant has parallel chillers"
    annotation(Dialog(group="Chillers configuration"));

  parameter Real byPasSetTim(
    final unit="s",
    final quantity="Time")
    "Time constant for resetting minimum bypass flow"
    annotation(Dialog(tab="Minimum flow bypass"));

  parameter Modelica.SIunits.VolumeFlowRate minFloSet[nChi]
    "Minimum chilled water flow through each chiller"
    annotation(Dialog(tab="Minimum flow bypass"));

  parameter Modelica.SIunits.VolumeFlowRate maxFloSet[nChi]
    "Maximum chilled water flow through each chiller"
    annotation(Dialog(tab="Minimum flow bypass"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMinFloByp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Minimum flow bypass", group="Controller"));

  parameter Real kMinFloBypCon=1
    "Gain of controller"
    annotation (Dialog(tab="Minimum flow bypass", group="Controller"));

  parameter Real TiMinFloBypCon(
    final unit="s",
    final quantity="Time")=0.5 "Time constant of integrator block"
    annotation (Dialog(tab="Minimum flow bypass",
    group="Controller", enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                               controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdMinFloBypCon(
    final unit="s",
    final quantity="Time")=0 "Time constant of derivative block"
    annotation (Dialog(tab="Minimum flow bypass",
    group="Controller", enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                  controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real yMax=1 "Upper limit of output"
    annotation (Dialog(tab="Minimum flow bypass", group="Controller"));

  parameter Real yMin=0.1 "Lower limit of output"
    annotation (Dialog(tab="Minimum flow bypass", group="Controller"));

  // Chilled water pumps

  parameter Boolean isHeaderedChiWatPum = true
    "Flag of headered chilled water pumps design: true=headered, false=dedicated"
    annotation (Dialog(group="Pumps configuration"));

  parameter Boolean have_LocalSensorChiWatPum = false
    "Flag of local DP sensor: true=local DP sensor hardwired to controller"
    annotation (Dialog(group="Pumps configuration"));

  parameter Integer nChiWatPum = 2
    "Total number of chilled water pumps"
    annotation (Dialog(group="Pumps configuration"));

  parameter Integer nSenChiWatPum=2
    "Total number of remote differential pressure sensors"
    annotation (Dialog(group="Pumps configuration"));

  parameter Real minChiWatPumPumSpe=0.1
    "Minimum pump speed"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Real maxPChiWatPumumSpe=1
    "Maximum pump speed"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Integer nPum_nominal(
    final max=nPum,
    final min=1)=nPum
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(tab="Chilled water pumps", group="Nominal conditions"));

  parameter Real VChiWat_flow_nominal(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1e-6)=0.5
    "Total plant design chilled water flow rate"
    annotation (Dialog(tab="Chilled water pumps", group="Nominal conditions"));

  parameter Real maxLocDp(
    final unit="Pa",
    final quantity="PressureDifference")=15*6894.75
    "Maximum chilled water loop local differential pressure setpoint"
    annotation (Dialog(tab="Chilled water pumps", group="Pump speed control when there is local DP sensor", enable=have_LocalSensorChiWatPum));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeChiWatPum=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Real kChiWatPum=1 "Gain of controller"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Real TiChiWatPum(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=0.5 "Time constant of integrator block"
      annotation (Dialog(group="Speed controller"));

  parameter Real TdChiWatPum(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=0.1 "Time constant of derivative block"
      annotation (Dialog(tab="Chilled water pumps", group="Speed controller",
    enable=
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  final parameter Real minLocDp(
    final unit="Pa",
    final quantity="PressureDifference")=5*6894.75
    "Minimum chilled water loop local differential pressure setpoint"
    annotation (Dialog(tab="Chilled water pumps", group="Pump speed control when there is local DP sensor", enable=have_LocalSensor));
  final parameter Integer pumInd[nPum]={i for i in 1:nPumf}
    "Pump index, {1,2,...,n}";

  // Chilled water plant reset

  parameter Real holTim(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=900
    "Time to fix plant reset value";

  parameter Real iniSet = 0 "Initial setpoint"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond parameters"));

  parameter Real minSet = 0 "Minimum plant reset value"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond parameters"));

  parameter Real maxSet = 1 "Maximum plant reset value"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond parameters"));

  parameter Real delTim(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=900
    "Delay time after which trim and respond is activated"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond parameters"));

  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time")=300
    "Sample period time"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond parameters"));

  parameter Integer numIgnReq = 2
    "Number of ignored requests"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond parameters"));

  parameter Real triAmo = -0.02 "Trim amount"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond parameters"));

  parameter Real resAmo = 0.03
    "Respond amount (must be opposite in to triAmo)"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond parameters"));

  parameter Real maxRes = 0.07
    "Maximum response per time interval (same sign as resAmo)"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond parameters"));

  // Chilled wate supply

  // fixme note to *mg minSet and maxSet are the same


  CDL.Interfaces.BooleanInput uChiIsoVal[nChi] if isHeadered
    "Chilled water isolation valve status"
    annotation(Placement(transformation(extent={{-840,480},{-800,520}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));

  CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pump status"
    annotation(Placement(transformation(extent={{-840,330},{-800,370}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector"
    annotation(Placement(transformation(extent={{-840,420},{-800,460}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));

  CDL.Interfaces.BooleanInput uChi[nChi]
    "Vector of chiller proven on status: true=ON"
    annotation(Placement(transformation(extent={{-840,450},{-800,490}}),
      iconTransformation(extent={{-140,150},{-100,190}})));

  CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cell proven on status: true=running tower cell"
    annotation(Placement(transformation(extent={{-840,370},{-800,410}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  CDL.Interfaces.IntegerInput chiWatSupResReq
    "Number of chiller plant cooling requests"
    annotation(Placement(transformation(extent={{-840,230},{-800,270}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  CDL.Interfaces.RealInput VChiWat_flow(final quantity=
        "VolumeFlowRate", final unit="m3/s")
    "Measured chilled water volume flow rate"
    annotation(Placement(transformation(extent={{-840,-40},{-800,0}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));

  CDL.Interfaces.RealInput dpChiWat_remote[nSen](final
      unit=fill("Pa", nSen), final quantity=fill("PressureDifference", nSen))
    "Chilled water differential static pressure from remote sensor"
    annotation(Placement(transformation(extent={{-840,-170},{-800,-130}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));

  CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chilled water isolation valve position"
    annotation(Placement(transformation(extent={{-840,-220},{-800,-180}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));

  CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum),
    final unit=fill("1", nConWatPum)) "Current condenser water pump speed"
    annotation(Placement(transformation(extent={{-840,-330},{-800,-290}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));

  CDL.Interfaces.RealInput watLev
    "Measured water level"
    annotation(Placement(transformation(extent={{-590,-990},{-550,-950}}),
      iconTransformation(extent={{-140,-210},{-100,-170}})));

  CDL.Interfaces.RealInput TConWatSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not closeCoupledPlant
    "Condenser water supply temperature"
    annotation(Placement(transformation(extent={{-840,-280},{-800,-240}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  CDL.Interfaces.RealInput watLev1
    "Measured water level"
    annotation(Placement(transformation(extent={{-840,-370},{-800,-330}}),
      iconTransformation(extent={{-140,-210},{-100,-170}})));

  CDL.Interfaces.RealInput uIsoVal[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel))
    "Vector of tower cells isolation valve position"
    annotation(Placement(transformation(extent={{-840,-420},{-800,-380}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));

  CDL.Interfaces.RealInput TChiWatRetDow(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chiller water return temperature downstream of the WSE"
    annotation(Placement(transformation(extent={{-840,0},{-800,40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  CDL.Interfaces.RealInput TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chiller water return temperature upstream of the WSE"
    annotation(Placement(transformation(extent={{-840,40},{-800,80}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  CDL.Interfaces.RealInput TOutWet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Outdoor air wet bulb temperature"
    annotation(Placement(transformation(extent={{-840,80},{-800,120}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  CDL.Interfaces.RealInput dpChiWatPum(final unit="Pa",
      final quantity="PressureDifference") if not serChi
    "Chilled water pump differential static pressure"
    annotation(Placement(transformation(extent={{-840,-140},{-800,-100}}),
    iconTransformation(extent={{-140,30},{-100,70}})));

  CDL.Interfaces.RealInput uChiLoa[nChi](
    final quantity=fill("HeatFlowRate", nChi), final unit=fill("W", nChi))
    "Current chiller load"
    annotation(Placement(transformation(extent={{-840,130},{-800,170}}),
      iconTransformation(extent={{-140,100},{-100,140}})));

  CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not haveHeaPreConSig
    "Measured condenser water return temperature"
    annotation(Placement(transformation(extent={{-840,-80},{-800,-40}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not haveHeaPreConSig
    "Measured chilled water supply temperature"
    annotation(Placement(transformation(extent={{-840,-110},{-800,-70}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation(Placement(transformation(extent={{800,430},{840,470}}),
      iconTransformation(extent={{100,100},{140,140}})));

  CDL.Interfaces.BooleanOutput yChiWatPum[nPum] if
    isHeadered
    "Chilled water pump status setpoint"
    annotation(Placement(transformation(extent={{800,390},{840,430}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  CDL.Interfaces.BooleanOutput yLeaCel
    "Lead tower cell status setpoint"
    annotation(Placement(transformation(extent={{800,550},{840,590}}),
      iconTransformation(extent={{100,90},{140,130}})));

  CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Vector of tower cells status setpoint"
    annotation(Placement(transformation(extent={{800,510},{840,550}}),
      iconTransformation(extent={{100,-70},{140,-30}})));

  CDL.Interfaces.BooleanOutput yMakUp
    "Makeup water valve On-Off status"
    annotation(Placement(transformation(extent={{800,470},{840,510}}),
      iconTransformation(extent={{100,-190},{140,-150}})));

  CDL.Interfaces.RealOutput yIsoVal[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel))
    "Cooling tower cells isolation valve position"
    annotation(Placement(transformation(extent={{800,-220},{840,-180}}),
      iconTransformation(extent={{100,30},{140,70}})));

  CDL.Interfaces.RealOutput yFanSpe[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel)) "Fan speed of each cooling tower cell"
    annotation(Placement(transformation(extent={{800,-260},{840,-220}}),
      iconTransformation(extent={{100,-130},{140,-90}})));

  CDL.Interfaces.RealOutput yValPos(
    final min=0,
    final max=1,
    final unit="1") "Chilled water minimum flow bypass valve position"
    annotation(Placement(transformation(extent={{802,-462},{842,-422}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  CDL.Interfaces.RealOutput yChiPumSpe(
    final min=0,
    final max=1,
    final unit="1") "Enabled chilled water pump speed" annotation(Placement(
        transformation(extent={{800,120},{840,160}}), iconTransformation(extent=
           {{100,-100},{140,-60}})));

  CDL.Interfaces.RealOutput yHeaPreConVal(
    final min=0,
    final max=1,
    final unit="1") if not ((not have_WSE) and not fixSpePum)
    "Head pressure control valve position"
    annotation(Placement(transformation(extent={{800,-340},{840,-300}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  CDL.Interfaces.RealOutput yChiDem[nChi](final quantity=
       fill("HeatFlowRate", nChi), final unit=fill("W", nChi))
    "Chiller demand setpoint to set through BACnet or similar "
    annotation(Placement(transformation(extent={{800,-400},{840,-360}}),
      iconTransformation(extent={{100,130},{140,170}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Controller wseSta(
    final holdPeriod=holdPeriod,
    final delDis=delDis,
    final TOffsetEna=TOffsetEna,
    final TOffsetDis=TOffsetDis,
    final heaExcAppDes=heaExcAppDes,
    final cooTowAppDes=cooTowAppDes,
    final TOutWetDes=TOutWetDes,
    final VHeaExcDes_flow=VHeaExcDes_flow,
    final hysDt=hysDt,
    final step=step,
    final wseOnTimDec=wseOnTimDec,
    final wseOnTimInc=wseOnTimInc)
    "Waterside economizer (WSE) enable/disable status"
    annotation(Placement(transformation(extent={{-580,230},{-520,290}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable plaEna(
    final have_WSE=have_WSE,
    final schTab=schTab,
    final TChiLocOut=TChiLocOut,
    final plaThrTim=plaThrTim,
    final reqThrTim=reqThrTim,
    final ignReq=ignReq,
    final locDt=locDt)
    "Sequence to enable and disable plant"
    annotation(Placement(transformation(extent={{-660,-380},{-618,-338}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo equRot
    annotation(Placement(transformation(extent={{-340,648},{-300,688}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller heaPreCon(
    final fixSpePum=fixSpePum,
    final have_HeaPreConSig=false,
    final have_WSE=true,
    final minTowSpe=minTowSpe,
    final minConWatPumSpe=minConWatPumSpe,
    final minHeaPreValPos=minHeaPreValPos,
    final controllerType=controllerTypeHeaPre,
    final minChiLif=minChiLif,
    final k=kHeaPreCon,
    final Ti=TiHeaPreCon)
    "Head pressure controller"
    annotation(Placement(transformation(extent={{-480,130},{-420,190}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller minBypValCon(
    final nChi=nChi,
    final isParallelChiller=isParallelChiller,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet,
    final controllerType=controllerTypeMinFloByp,
    final k=controllerType,
    final Ti=TiMinFloBypCon,
    final Td=TdMinFloBypCon,
    final yMax=yMaxFloBypCon,
    final yMin=yMinFloBypCon)
    "Controller for chilled water minimum flow bypass valve"
    annotation(Placement(transformation(extent={{-580,-170},{-440,-30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller chiWatPumCon(
    final isHeadered=isHeaderedChiWatPum,
    final have_LocalSensor=have_LocalSensorChiWatPum,
    final nChi=nChi,
    final nPum=nChiWatPum,
    final nSen=nSenChiWatPum,
    final minPumSpe=minChiWatPumSpe,
    final maxPumSpe=maxChiWatPumSpe,
    final nPum_nominal=nPum_nominal,
    final VChiWat_flow_nominal=VChiWat_flow_nominal,
    final maxLocDp=maxLocDp,
    final controllerType=controllerTypeChiWatPum,
    final k=kChiWatPum,
    final Ti=TiChiWatPum,
    final Td=TdChiWatPum,
    final minLocDp=minLocDp)
    "Sequences to control chilled water pumps in primary-only plant system"
    annotation(Placement(transformation(extent={{322,436},{382,496}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset chiWatPlaRes(
    final nPum=nChiWatPum,
    final holTim=holTim,
    final iniSet=iniSet,
    final minSet=minset,
    final maxSet=maxSet,
    final delTim=delTim,
    final samplePeriod=samplePeriod,
    final numIgnReq=numIgnReq,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes)
    "Sequences to generate chilled water plant reset"
    annotation(Placement(transformation(extent={{-560,-320},{-480,-240}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply chiWatSupSet
    "Sequences to generate setpoints of chilled water supply temperature and the pump differential static pressure"
    annotation(Placement(transformation(extent={{-362,502},{-282,582}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController staSetCon(have_WSE=
        true)
    annotation(Placement(transformation(extent={{-156,-52},{-40,134}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Controller towCon(
    final nTowCel=nTowCel)
    annotation(Placement(transformation(extent={{-344,-670},{-216,-400}})));

  Staging.Processes.Down dowProCon
    annotation(Placement(transformation(extent={{174,-108},{250,44}})));

  Staging.Processes.Up upProCon
    annotation(Placement(transformation(extent={{164,248},{240,400}})));

  CDL.Continuous.MultiMax mulMax(nin=nTowCel) "All input values are the same"
    annotation(Placement(transformation(extent={{-180,-410},{-160,-390}})));

  CDL.Logical.Or chaProUpDown "Either in staging up or in staging down process"
    annotation(Placement(transformation(extent={{374,138},{394,158}})));

  CDL.Discrete.TriggeredSampler staSam
    "Samples stage index after each staging process is finished"
    annotation(Placement(transformation(extent={{30,100},{50,120}})));

  CDL.Conversions.RealToInteger reaToInt1
    annotation(Placement(transformation(extent={{60,100},{80,120}})));

  CDL.Conversions.IntegerToReal intToRea
    annotation(Placement(transformation(extent={{0,100},{20,120}})));

  CDL.Logical.FallingEdge falEdg
    annotation(Placement(transformation(extent={{350,18},{370,38}})));

  CDL.Interfaces.IntegerOutput yNumCel
    "Total number of enabled cells"
    annotation(Placement(transformation(extent={{800,-140},{840,-100}}),
      iconTransformation(extent={{100,150},{140,190}})));

  CDL.Logical.MultiOr mulOr(nu=nPum)
    annotation(Placement(transformation(extent={{-640,-40},{-620,-20}})));

  CDL.Routing.RealReplicator reaRep(nout=nTowCel)
    annotation(Placement(transformation(extent={{-386,168},{-366,188}})));

equation
  connect(staSetCon.uPla, plaEna.yPla) annotation(Line(points={{-167.6,116.562},
          {-380,116.562},{-380,-358},{-498,-358},{-498,-359},{-615.9,-359}},
                                               color={255,0,255}));
  connect(TOutWet, wseSta.TOutWet) annotation(Line(points={{-820,100},{-690,100},
          {-690,284},{-586,284}},      color={0,0,127}));
  connect(TChiWatRet, wseSta.TChiWatRet) annotation(Line(points={{-820,60},{-586,
          60},{-586,272}},       color={0,0,127}));
  connect(TChiWatRetDow, wseSta.TChiWatRetDow) annotation(Line(points={{-820,20},
          {-690,20},{-690,260},{-586,260}},       color={0,0,127}));
  connect(VChiWat_flow, wseSta.VChiWat_flow) annotation(Line(points={{-820,-20},
          {-660,-20},{-660,248},{-586,248}}, color={0,0,127}));
  connect(TOutWet, plaEna.TOut) annotation(Line(points={{-820,100},{-720,100},{
          -720,-366},{-664.2,-366},{-664.2,-367.82}},
                                                  color={0,0,127}));
  connect(chiWatSupResReq, plaEna.chiWatSupResReq) annotation(Line(points={{-820,
          250},{-710,250},{-710,-350.6},{-664.2,-350.6}},  color={255,127,0}));
  connect(chiWatSupSet.TChiWatSupSet, staSetCon.TChiWatSupSet) annotation(Line(
        points={{-274,518},{-260,518},{-260,140},{-220,140},{-220,81.6875},{-167.6,
          81.6875}},                                            color={0,0,127}));
  connect(TChiWatSup, staSetCon.TChiWatSup) annotation(Line(points={{-820,-90},
          {-716,-90},{-716,-84},{-612,-84},{-612,70.0625},{-167.6,70.0625}},
                                                 color={0,0,127}));
  connect(VChiWat_flow, minBypValCon.VChiWat_flow) annotation(Line(points={{-820,
          -20},{-660,-20},{-660,-51},{-594,-51}},      color={0,0,127}));
  connect(heaPreCon.TConWatRet, TChiWatRet) annotation(Line(points={{-486,178},
          {-696,178},{-696,60},{-820,60}},   color={0,0,127}));
  connect(TChiWatRet, staSetCon.TChiWatRet) annotation(Line(points={{-820,60},{
          -700,60},{-700,90},{-320,90},{-320,-57.8125},{-167.6,-57.8125}},
                                                                       color={0,
          0,127}));
  connect(staSetCon.TWsePre, wseSta.TWsePre) annotation(Line(points={{-167.6,
          -69.4375},{-360,-69.4375},{-360,212},{-460,212},{-460,260},{-517,260}},
        color={0,0,127}));
  connect(VChiWat_flow, staSetCon.VChiWat_flow) annotation(Line(points={{-820,-20},
          {-660,-20},{-660,104},{-324,104},{-324,-81.0625},{-167.6,-81.0625}},
        color={0,0,127}));
  connect(TChiWatSup, heaPreCon.TChiWatSup) annotation(Line(points={{-820,-90},
          {-680,-90},{-680,166},{-486,166}}, color={0,0,127}));
  connect(wseSta.y, heaPreCon.uWSE) annotation(Line(points={{-517,275},{-500,
          275},{-500,142},{-486,142}}, color={255,0,255}));
  connect(chiWatSupResReq, chiWatPlaRes.TChiWatSupResReq) annotation(Line(
        points={{-820,250},{-680,250},{-680,-280},{-568,-280}},   color={255,
          127,0}));
  connect(chiWatPlaRes.yChiWatPlaRes, chiWatSupSet.uChiWatPlaRes) annotation (
      Line(points={{-472,-280},{-406,-280},{-406,542},{-370,542}},
                                                                color={0,0,127}));
  connect(dpChiWatPum, staSetCon.dpChiWatPum) annotation(Line(points={{-820,-120},
          {-730,-120},{-730,12},{-448,12},{-448,11.9375},{-167.6,11.9375}},
                                                    color={0,0,127}));
  connect(chiWatSupSet.dpChiWatPumSet, staSetCon.dpChiWatPumSet) annotation (
      Line(points={{-274,566},{-240,566},{-240,76},{-204,76},{-204,0.3125},{-167.6,
          0.3125}},                                                color={0,0,
          127}));
  connect(uChi, towCon.uChi) annotation(Line(points={{-820,470},{-688,470},{-688,
          -420.25},{-356.8,-420.25}},   color={255,0,255}));
  connect(wseSta.y, staSetCon.uWseSta) annotation(Line(points={{-517,275},{-394,
          275},{-394,151.438},{-167.6,151.438}},color={255,0,255}));
  connect(wseSta.y, towCon.uWse) annotation(Line(points={{-517,275},{-396,275},
          {-396,-433.75},{-356.8,-433.75}},
                                        color={255,0,255}));
  connect(uTowSta, towCon.uTowSta) annotation(Line(points={{-820,390},{-674,390},
          {-674,-250},{-440,-250},{-440,-514.75},{-356.8,-514.75}}, color={255,
          0,255}));
  connect(plaEna.yPla, towCon.uPla) annotation(Line(points={{-615.9,-359},{-500,
          -359},{-500,-528.25},{-356.8,-528.25}},
                                              color={255,0,255}));
  connect(TOutWet, staSetCon.TOutWet) annotation(Line(points={{-820,100},{-628,
          100},{-628,74},{-212,74},{-212,-18},{-167.6,-18},{-167.6,-17.125}},
                                                       color={0,0,127}));
  connect(wseSta.yTunPar, staSetCon.uTunPar) annotation(Line(points={{-517,245},
          {-540,245},{-540,6},{-344,6},{-344,-28.75},{-167.6,-28.75}},
                                             color={0,0,127}));
  connect(towCon.yFanSpe, mulMax.u[1:4]) annotation(Line(points={{-203.2,-609.25},
          {-190,-609.25},{-190,-400},{-182,-400}},
                                        color={0,0,127}));
  connect(mulMax.y, staSetCon.uTowFanSpeMax) annotation(Line(points={{-158,
          -400},{-122,-400},{-122,-306},{-200,-306},{-200,-40.375},{-167.6,
          -40.375}},
        color={0,0,127}));
  connect(staSetCon.ySta, upProCon.uStaSet) annotation(Line(points={{-28.4,-22.9375},
          {22,-22.9375},{22,298},{58,298},{58,396.2},{156.4,396.2}},
                                                          color={255,127,0}));
  connect(staSetCon.ySta, dowProCon.uStaSet) annotation(Line(points={{-28.4,-22.9375},
          {24,-22.9375},{24,37.16},{166.4,37.16}},        color={255,127,0}));
  connect(staSetCon.yChiSet, upProCon.uChiSet) annotation(Line(points={{-28.4,17.75},
          {-2,17.75},{-2,-52},{26,-52},{26,384.8},{156.4,384.8}},
        color={255,0,255}));
  connect(staSetCon.yChiSet, dowProCon.uChiSet) annotation(Line(points={{-28.4,
          17.75},{32,17.75},{32,29.56},{166.4,29.56}},      color={255,0,255}));
  connect(uChiLoa, upProCon.uChiLoa) annotation(Line(points={{-820,150},{-200,150},
          {-200,340},{60,340},{60,369.6},{156.4,369.6}},     color={0,0,127}));
  connect(upProCon.yStaPro, chaProUpDown.u1) annotation(Line(points={{247.6,396.2},
          {334,396.2},{334,148},{372,148}},        color={255,0,255}));
  connect(dowProCon.yStaPro, chaProUpDown.u2) annotation(Line(points={{257.6,40.2},
          {334,40.2},{334,140},{372,140}},       color={255,0,255}));
  connect(chaProUpDown.y, staSetCon.chaPro) annotation(Line(points={{396,148},{
          406,148},{406,-112},{-194,-112},{-194,140},{-180,140},{-180,139.812},
          {-167.6,139.812}},
        color={255,0,255}));
  connect(uChi, dowProCon.uChi) annotation(Line(points={{-820,470},{-700,470},{
          -700,-184},{-358,-184},{-358,-150},{40,-150},{40,-1.6},{166.4,-1.6}},
        color={255,0,255}));
  connect(staSam.u, intToRea.y)
    annotation(Line(points={{28,110},{22,110}}, color={0,0,127}));
  connect(staSam.y, reaToInt1.u)
    annotation(Line(points={{52,110},{58,110}}, color={0,0,127}));
  connect(dowProCon.yStaPro, falEdg.u) annotation(Line(points={{257.6,40.2},{310,
          40.2},{310,28},{348,28}},     color={255,0,255}));
  connect(falEdg.y, staSam.trigger) annotation(Line(points={{372,28},{384,28},{
          384,86},{40,86},{40,98.2}},  color={255,0,255}));
  connect(staSetCon.ySta, intToRea.u) annotation(Line(points={{-28.4,-22.9375},
          {-10,-22.9375},{-10,110},{-2,110}},color={255,127,0}));
  connect(reaToInt1.y, dowProCon.uChiSta) annotation(Line(points={{82,110},{90,
          110},{90,-20.6},{166.4,-20.6}},color={255,127,0}));
  connect(reaToInt1.y, staSetCon.uSta) annotation(Line(points={{82,110},{82,
          -124},{-224,-124},{-224,99.125},{-167.6,99.125}}, color={255,127,0}));
  connect(mulMax.y, wseSta.uTowFanSpeMax) annotation(Line(points={{-158,-400},
          {-150,-400},{-150,-334},{-374,-334},{-374,30},{-622,30},{-622,236},{
          -586,236}}, color={0,0,127}));
  connect(towCon.yNumCel, yNumCel) annotation(Line(points={{-203.2,-420.25},{
          598,-420.25},{598,-120},{820,-120}},
                                             color={255,127,0}));
  connect(towCon.yIsoVal, yIsoVal) annotation(Line(points={{-203.2,-501.25},{
          612,-501.25},{612,-200},{820,-200}},
                                             color={0,0,127}));
  connect(towCon.yFanSpe, yFanSpe) annotation(Line(points={{-203.2,-609.25},{-192,
          -609.25},{-192,-610},{-140,-610},{-140,-680},{630,-680},{630,-240},{820,
          -240}},     color={0,0,127}));
  connect(towCon.yLeaCel, yLeaCel) annotation(Line(points={{-203.2,-460.75},{
          538,-460.75},{538,570},{820,570}}, color={255,0,255}));
  connect(towCon.yTowSta, yTowSta) annotation(Line(points={{-203.2,-568.75},{
          550,-568.75},{550,530},{820,530}}, color={255,0,255}));
  connect(towCon.yMakUp, yMakUp) annotation(Line(points={{-203.2,-649.75},{570,
          -649.75},{570,490},{820,490}}, color={255,0,255}));
  connect(chaProUpDown.y, chiWatPlaRes.chaPro) annotation(Line(points={{396,148},
          {414,148},{414,-346},{-580,-346},{-580,-304},{-568,-304}},      color=
         {255,0,255}));
  connect(uChiWatPum, chiWatPlaRes.uChiWatPum) annotation(Line(points={{-820,350},
          {-708,350},{-708,-270},{-580,-270},{-580,-256},{-568,-256}},
        color={255,0,255}));
  connect(mulOr.y, minBypValCon.uChiWatPum) annotation(Line(points={{-618,-30},
          {-604,-30},{-604,-37},{-594,-37}}, color={255,0,255}));
  connect(uChiWatPum, mulOr.u) annotation(Line(points={{-820,350},{-650,350},{-650,
          -30},{-642,-30}},       color={255,0,255}));
  connect(staSetCon.yOpeParLoaRatMin, dowProCon.uOpeParLoaRatMin) annotation (
      Line(points={{-28.4,-63.625},{60,-63.625},{60,17.4},{166.4,17.4}}, color=
          {0,0,127}));
  connect(uChi, upProCon.uChi) annotation(Line(points={{-820,470},{-652,470},{-652,
          24},{-248,24},{-248,190},{60,190},{60,362},{156.4,362}},     color={
          255,0,255}));
  connect(VChiWat_flow, upProCon.VChiWat_flow) annotation(Line(points={{-820,-20},
          {-740,-20},{-740,0},{-656,0},{-656,216},{72,216},{72,352.88},{156.4,352.88}},
                                                                          color=
         {0,0,127}));
  connect(wseSta.y, upProCon.uWSE) annotation(Line(points={{-517,275},{0,275},{
          0,305},{156.4,305}}, color={255,0,255}));
  connect(wseSta.y, dowProCon.uWSE) annotation(Line(points={{-517,275},{-14,275},
          {-14,-85.2},{166.4,-85.2}},      color={255,0,255}));
  connect(heaPreCon.yMaxTowSpeSet, reaRep.u)
    annotation(Line(points={{-417,178},{-388,178}}, color={0,0,127}));
  connect(reaRep.y, towCon.uMaxTowSpeSet) annotation(Line(points={{-364,178},{
          -354,178},{-354,-166},{-388,-166},{-388,-501.25},{-356.8,-501.25}},
        color={0,0,127}));
  connect(dowProCon.VChiWat_flow, VChiWat_flow) annotation(Line(points={{166.4,
          -9.2},{62,-9.2},{62,-90},{-334,-90},{-334,126},{-760,126},{-760,-20},{
          -820,-20}},  color={0,0,127}));
  connect(uChiWatPum, chiWatPumCon.uChiWatPum) annotation(Line(points={{-820,350},
          {-760,350},{-760,484},{316,484}},        color={255,0,255}));
  connect(uChiIsoVal, chiWatPumCon.uChiIsoVal) annotation(Line(points={{-820,500},
          {-780,500},{-780,460},{316,460}},      color={255,0,255}));
  connect(VChiWat_flow, chiWatPumCon.VChiWat_flow) annotation(Line(points={{-820,
          -20},{-754,-20},{-754,454},{316,454}},      color={0,0,127}));
  connect(dpChiWat_remote, chiWatPumCon.dpChiWat_remote) annotation(Line(
        points={{-820,-150},{-766,-150},{-766,442},{316,442}},
                                                           color={0,0,127}));
  connect(heaPreCon.yHeaPreConVal, yHeaPreConVal) annotation(Line(points={{-417,
          160},{-280,160},{-280,-136},{760,-136},{760,-320},{820,-320}},  color=
         {0,0,127}));
  connect(upProCon.yChiDem, yChiDem) annotation(Line(points={{247.6,381},{720,381},
          {720,-380},{820,-380}},  color={0,0,127}));
  connect(TChiWatSup, towCon.TChiWatSup) annotation(Line(points={{-820,-90},{-606,
          -90},{-606,112},{-398,112},{-398,-460.75},{-356.8,-460.75}},
        color={0,0,127}));
  connect(chiWatSupSet.TChiWatSupSet, towCon.TChiWatSupSet) annotation(Line(
        points={{-274,518},{-306,518},{-306,-82},{-424,-82},{-424,-474.25},{-356.8,
          -474.25}},
        color={0,0,127}));
  connect(staSetCon.ySta, towCon.uChiSta) annotation(Line(points={{-28.4,
          -22.9375},{4,-22.9375},{4,-104},{-408,-104},{-408,-582.25},{-356.8,
          -582.25}},        color={255,127,0}));
  connect(staSetCon.ySta, upProCon.uChiSta) annotation(Line(points={{-28.4,-22.9375},
          {-20,-22.9375},{-20,331.6},{156.4,331.6}},          color={255,127,0}));
  connect(staSetCon.ySta, dowProCon.uChiSta) annotation(Line(points={{-28.4,-22.9375},
          {12,-22.9375},{12,-20.6},{166.4,-20.6}},           color={255,127,0}));
  connect(dowProCon.uChiLoa, uChiLoa) annotation(Line(points={{166.4,9.8},{-8,9.8},
          {-8,150},{-820,150}},       color={0,0,127}));
  connect(dowProCon.uChiWatIsoVal, uChiWatIsoVal) annotation(Line(points={{166.4,
          -43.4},{100,-43.4},{100,-130},{-342,-130},{-342,-200},{-820,-200}},
                                                              color={0,0,127}));
  connect(uChiWatIsoVal, upProCon.uChiWatIsoVal) annotation(Line(points={{-820,
          -200},{-350,-200},{-350,212},{40,212},{40,259.4},{156.4,259.4}},
                                                                      color={0,
          0,127}));
  connect(staSetCon.yUp, minBypValCon.uStaUp) annotation(Line(points={{-28.4,
          145.625},{-28,145.625},{-28,200},{-300,200},{-300,60},{-608,60},{-608,
          -65},{-594,-65}}, color={255,0,255}));
  connect(dowProCon.yDesConWatPumSpe, heaPreCon.desConWatPumSpe) annotation (
      Line(points={{257.6,-73.8},{294,-73.8},{294,-76},{366,-76},{366,-144},{-420,
          -144},{-420,48},{-502,48},{-502,154},{-486,154}},      color={0,0,127}));
  connect(yChiWatPum, chiWatPumCon.yChiWatPum) annotation(Line(points={{820,
          410},{620,410},{620,412},{420,412},{420,466},{388,466}}, color={255,0,
          255}));
  connect(heaPreCon.yConWatPumSpeSet, dowProCon.uConWatPumSpeSet) annotation (
      Line(points={{-417,142},{-304,142},{-304,-96.6},{166.4,-96.6}}, color={0,
          0,127}));
  connect(heaPreCon.yConWatPumSpeSet, upProCon.uConWatPumSpeSet) annotation (
      Line(points={{-417,142},{-338,142},{-338,194},{120,194},{120,294},{156.4,294},
          {156.4,293.6}},
        color={0,0,127}));
  connect(chiWatPumCon.yPumSpe, yChiPumSpe) annotation(Line(points={{388,442},
          {498,442},{498,140},{820,140}}, color={0,0,127}));
  connect(chiWatSupSet.dpChiWatPumSet, chiWatPumCon.dpChiWatSet) annotation (
      Line(points={{-274,566},{300,566},{300,436},{316,436}}, color={0,0,127}));
  connect(uChiAva, staSetCon.uChiAva) annotation(Line(points={{-820,440},{-668,
          440},{-668,128.188},{-167.6,128.188}},       color={255,0,255}));
  connect(minBypValCon.yValPos, yValPos) annotation(Line(points={{-426,-100},{
          -362,-100},{-362,-258},{220,-258},{220,-442},{822,-442}}, color={0,0,
          127}));
  connect(staSetCon.yDow, minBypValCon.uStaDow) annotation(Line(points={{-28.4,
          128.188},{-6,128.188},{-6,-196},{-622,-196},{-622,-163},{-594,-163}},
        color={255,0,255}));
  connect(towCon.uConWatPumSpe, uConWatPumSpe) annotation(Line(points={{-356.8,
          -555.25},{-580.4,-555.25},{-580.4,-310},{-820,-310}}, color={0,0,127}));
  connect(staSetCon.ySta, towCon.uChiStaSet) annotation(Line(points={{-28.4,-22.9375},
          {-30,-22.9375},{-30,-326},{-420,-326},{-420,-595.75},{-356.8,-595.75}},
        color={255,127,0}));
  connect(TConWatSup, towCon.TConWatSup) annotation(Line(points={{-820,-260},{-760,
          -260},{-760,-568.75},{-356.8,-568.75}}, color={0,0,127}));
  connect(TConWatRet, towCon.TConWatRet) annotation(Line(points={{-820,-60},{-780,
          -60},{-780,-541.75},{-356.8,-541.75}}, color={0,0,127}));
  connect(watLev1, towCon.watLev) annotation(Line(points={{-820,-350},{-740,-350},
          {-740,-663.25},{-356.8,-663.25}}, color={0,0,127}));
  connect(towCon.uIsoVal, uIsoVal) annotation(Line(points={{-356.8,-649.75},{-790,
          -649.75},{-790,-400},{-820,-400}}, color={0,0,127}));
  connect(uChiLoa, towCon.chiLoa) annotation(Line(points={{-820,150},{-746,150},
          {-746,-406.75},{-356.8,-406.75}}, color={0,0,127}));
    annotation (Dialog(tab="Plant Reset", group="Time parameter"),
               Evaluate=true, Dialog(tab="Advanced", group="Tuning"),
  defaultComponentName="chiPlaCon",
  Icon(coordinateSystem(extent={{-800,-740},{800,740}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-80,60},{82,-60}},
          lineColor={28,108,200},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Polygon(
          points={{-80,60},{-14,4},{-80,-60},{-80,60}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-800,-740},{800,740}}), graphics={                 Text(
          extent={{350,192},{456,156}},
          lineColor={28,108,200},
          textString="might need a pre block"),                       Text(
          extent={{-450,-564},{-366,-584}},
          lineColor={28,108,200},
          textString="might need a pre block")}),
  Documentation(info="<html>
<p>
fixme: Controller for plants with two devices or groups of devices (chillers, towers(4 cells), CW and C pumps)
</p>
</html>",
revisions="<html>
<ul>
<li>
May 30, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
