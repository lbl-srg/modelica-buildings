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

  // Chilled water supply

  parameter Modelica.SIunits.PressureDifference dpChiWatPumMin(
    final min=0,
    displayUnit="Pa") = 34473.8
    "Minimum chilled water pump differential static pressure, default 5 psi"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  parameter Modelica.SIunits.PressureDifference dpChiWatPumMax(
    final min=dpChiWatPumMin,
    displayUnit="Pa")
    "Maximum chilled water pump differential static pressure"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  parameter Modelica.SIunits.ThermodynamicTemperature TChiWatSupMin(
    displayUnit="K")
    "Minimum chilled water supply temperature"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  parameter Modelica.SIunits.ThermodynamicTemperature TChiWatSupMax(
    final min=TChiWatSupMin,
    displayUnit="K") = 288.706
    "Maximum chilled water supply temperature, default 60 degF"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  parameter Real halSet = 0.5
    "Half plant reset value"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  // staging setpoints

  parameter Boolean have_WSE = false
    "true = plant has a WSE, false = plant does not have WSE"
    annotation (Dialog(tab="General", group="Plant configuration"));

  parameter Boolean serChi = false
    "true = series chillers plant; false = parallel chillers plant"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Boolean anyVsdCen = false
    "Plant contains at least one variable speed centrifugal chiller"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Modelica.SIunits.Power chiDesCap[nChi]
    "Design chiller capacities vector"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Modelica.SIunits.Power chiMinCap[nChi]
    "Chiller minimum cycling loads vector"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Integer chiTyp[nChi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal}
    "Chiller type. Recommended staging order: positive displacement, variable speed centrifugal, constant speed centrifugal"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Integer nSta = 3
    "Number of chiller stages"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Integer staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stage as row index and chiller as column index"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Real avePer(
    final unit="s",
    final quantity="Time")=300
      "Time period for the capacity requirement rolling average"
    annotation (Dialog(tab="Staging", group="Hold and delay parameters"));

  parameter Real delayStaCha(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=900
      "Hold period for each stage change"
    annotation (Dialog(tab="Staging", group="Hold and delay parameters"));

  parameter Real parLoaRatDelay(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=900
      "Enable delay for operating and staging part load ratio condition"
    annotation (Dialog(tab="Staging", group="Hold and delay parameters"));

  parameter Real faiSafTruDelay(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=900
      "Enable delay for failsafe condition"
    annotation (Dialog(tab="Staging", group="Hold and delay parameters"));

  parameter Real effConTruDelay(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=900
      "Enable delay for efficiency condition"
    annotation (Dialog(tab="Staging", group="Hold and delay parameters"));

  parameter Real shortTDelay(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=600
      "Short enable delay for staging from zero to first available stage up"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Staging", group="Hold and delay parameters"));

  parameter Real longTDelay(
    final unit="s",
    final quantity="Time",
    final displayUnit="h")=1200
      "Long enable delay for staging from zero to first available stage up"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Staging", group="Hold and delay parameters"));

  parameter Real posDisMult(
    final unit = "1",
    final min = 0,
    final max = 1)=0.8
    "Positive displacement chiller type staging multiplier"
    annotation (Dialog(tab="Staging", group="Staging part load ratio parameters"));

  parameter Real conSpeCenMult(
    final unit = "1",
    final min = 0,
    final max = 1)=0.9
    "Constant speed centrifugal chiller type staging multiplier"
    annotation (Dialog(tab="Staging", group="Staging part load ratio parameters"));

  parameter Real anyOutOfScoMult(
    final unit = "1",
    final min = 0,
    final max = 1)=0.9
    "Outside of G36 recommended staging order chiller type SPLR multiplier"
    annotation(Evaluate=true, __cdl(ValueInReference=False), Dialog(tab="Staging", group="Staging part load ratio parameters"));

  parameter Real varSpeStaMin(
    final unit = "1",
    final min = 0.1,
    final max = 1)=0.45
    "Minimum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen, tab="Staging", group="Staging part load ratio parameters"));

  parameter Real varSpeStaMax(
    final unit = "1",
    final min = varSpeStaMin,
    final max = 1)=0.9
    "Maximum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen, tab="Staging", group="Staging part load ratio parameters"));

  parameter Modelica.SIunits.TemperatureDifference smallTDif = 1
    "Offset between the chilled water supply temperature and its setpoint for the long condition"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Staging", group="Value comparison parameters"));

  parameter Modelica.SIunits.TemperatureDifference largeTDif = 2
    "Offset between the chilled water supply temperature and its setpoint for the short condition"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Staging", group="Value comparison parameters"));

  parameter Modelica.SIunits.TemperatureDifference faiSafTDif = 1
    "Offset between the chilled water supply temperature and its setpoint for the failsafe condition"
    annotation (Dialog(tab="Staging", group="Value comparison parameters"));

  parameter Modelica.SIunits.PressureDifference dpDif = 2 * 6895
    "Offset between the chilled water pump diferential static pressure and its setpoint"
    annotation (Dialog(tab="Staging", group="Value comparison parameters"));

  parameter Modelica.SIunits.TemperatureDifference TDif = 1
    "Offset between the chilled water supply temperature and its setpoint for staging down to WSE only"
    annotation (Dialog(tab="Staging", group="Value comparison parameters"));

  parameter Modelica.SIunits.TemperatureDifference TDifHys = 1
    "Hysteresis deadband for temperature"
    annotation (Dialog(tab="Advanced", group="Staging"));

  parameter Modelica.SIunits.PressureDifference faiSafDpDif = 2 * 6895
    "Offset between the chilled water differential pressure and its setpoint"
    annotation (Dialog(tab="Staging", group="Value comparison parameters"));

  parameter Modelica.SIunits.PressureDifference dpDifHys = 0.5 * 6895
    "Pressure difference hysteresis deadband"
    annotation (Dialog(tab="Advanced", group="Staging"));

  parameter Real effConSigDif(
    final min=0,
    final max=1) = 0.05
    "Signal hysteresis deadband"
    annotation (Dialog(tab="Staging", group="Value comparison parameters"));

  //





  CDL.Interfaces.BooleanInput uChiIsoVal[nChi] if isHeadered
    "Chilled water isolation valve status"
    annotation(Placement(transformation(extent={{-840,480},{-800,520}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));

  CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pump status"
    annotation(Placement(transformation(extent={{-840,320},{-800,360}}),
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
    annotation(Placement(transformation(extent={{-840,-420},{-800,-380}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));

  CDL.Interfaces.RealInput TConWatSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not closeCoupledPlant
    "Condenser water supply temperature"
    annotation(Placement(transformation(extent={{-840,-280},{-800,-240}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  CDL.Interfaces.RealInput watLev1
    "Measured water level"
    annotation(Placement(transformation(extent={{-840,-780},{-800,-740}}),
      iconTransformation(extent={{-140,-210},{-100,-170}})));

  CDL.Interfaces.RealInput uIsoVal[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel))
    "Vector of tower cells isolation valve position"
    annotation(Placement(transformation(extent={{-840,-700},{-800,-660}}),
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
    annotation(Placement(transformation(extent={{800,520},{840,560}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  CDL.Interfaces.BooleanOutput yLeaCel
    "Lead tower cell status setpoint"
    annotation(Placement(transformation(extent={{800,-610},{840,-570}}),
      iconTransformation(extent={{100,90},{140,130}})));

  CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Vector of tower cells status setpoint"
    annotation(Placement(transformation(extent={{800,-680},{840,-640}}),
      iconTransformation(extent={{100,-70},{140,-30}})));

  CDL.Interfaces.BooleanOutput yMakUp
    "Makeup water valve On-Off status"
    annotation(Placement(transformation(extent={{800,-760},{840,-720}}),
      iconTransformation(extent={{100,-190},{140,-150}})));

  CDL.Interfaces.RealOutput yIsoVal[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel))
    "Cooling tower cells isolation valve position"
    annotation(Placement(transformation(extent={{800,-650},{840,-610}}),
      iconTransformation(extent={{100,30},{140,70}})));

  CDL.Interfaces.RealOutput yFanSpe[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel)) "Fan speed of each cooling tower cell"
    annotation(Placement(transformation(extent={{800,-710},{840,-670}}),
      iconTransformation(extent={{100,-130},{140,-90}})));

  CDL.Interfaces.RealOutput yValPos(
    final min=0,
    final max=1,
    final unit="1") "Chilled water minimum flow bypass valve position"
    annotation(Placement(transformation(extent={{800,-460},{840,-420}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  CDL.Interfaces.RealOutput yChiPumSpe(
    final min=0,
    final max=1,
    final unit="1") "Enabled chilled water pump speed" annotation(Placement(
        transformation(extent={{800,480},{840,520}}), iconTransformation(extent=
           {{100,-100},{140,-60}})));

  CDL.Interfaces.RealOutput yHeaPreConVal(
    final min=0,
    final max=1,
    final unit="1") if not ((not have_WSE) and not fixSpePum)
    "Head pressure control valve position"
    annotation(Placement(transformation(extent={{800,180},{840,220}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  CDL.Interfaces.RealOutput yChiDem[nChi](final quantity=
       fill("HeatFlowRate", nChi), final unit=fill("W", nChi))
    "Chiller demand setpoint to set through BACnet or similar "
    annotation(Placement(transformation(extent={{800,360},{840,400}}),
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
    annotation(Placement(transformation(extent={{-560,280},{-520,320}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable plaEna(
    final have_WSE=have_WSE,
    final schTab=schTab,
    final TChiLocOut=TChiLocOut,
    final plaThrTim=plaThrTim,
    final reqThrTim=reqThrTim,
    final ignReq=ignReq,
    final locDt=locDt)
    "Sequence to enable and disable plant"
    annotation(Placement(transformation(extent={{-560,-500},{-520,-460}})));

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
    annotation(Placement(transformation(extent={{-460,180},{-420,220}})));

  MinimumFlowBypass.Controller minBypValCon(
    final nChi=nChi,
    final minFloSet=minFloSet,
    final controllerType=controllerTypeMinFloByp,
    final k=controllerType,
    final Ti=TiMinFloBypCon,
    final Td=TdMinFloBypCon,
    final yMax=yMaxFloBypCon,
    final yMin=yMinFloBypCon)
    "Controller for chilled water minimum flow bypass valve"
    annotation (Placement(transformation(extent={{-560,-160},{-520,-120}})));

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
    annotation(Placement(transformation(extent={{320,440},{380,500}})));

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
    annotation(Placement(transformation(extent={{-560,-320},{-520,-280}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply chiWatSupSet(
    final dpChiWatPumSet=dpChiWatPumSet,
    final dpChiWatPumMax=dpChiWatPumMax,
    final TChiWatSupMin=TChiWatSupMin,
    final TChiWatSupMax=TChiWatSupMax,
    final minSet=minset,
    final maxSet=maxSet,
    final halSet=halSet)
    "Sequences to generate setpoints of chilled water supply temperature and the pump differential static pressure"
    annotation(Placement(transformation(extent={{-360,500},{-280,580}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController staSetCon(
    final have_WSE=have_WSE,
    final serChi=serChi,
    final anyVsdCen=anyVsdCen,
    final nChi=nChi,
    final chiDesCap=chiDesCap,
    final chiMinCap=chiMinCap,
    final chiTyp=chiTyp,
    final nSta=nSta,
    final staMat=staMat,
    final avePer=avePer,
    final delayStaCha=delayStaCha,
    final parLoaRatDelay=parLoaRatDelay,
    final faiSafTruDelay=faiSafTruDelay,
    final effConTruDelay=effConTruDelay,
    final shortTDelay=shortTDelay,
    final longTDelay=longTDelay,
    final conSpeCenMult=conSpeCenMult,
    final anyOutOfScoMult=anyOutOfScoMult,
    final varSpeStaMin=varSpeStaMin,
    final varSpeStaMax=varSpeStaMax,
    final smallTDif=smallTDif,
    final largeTDif=largeTDif,
    final faiSafTDif=faiSafTDif,
    final dpDif=dpDif,
    final TDif=TDif,
    final TDifHys=TDifHys,
    final faiSafDpDif=faiSafDpDif,
    final dpDifHys=dpDifHys,
    final effConSigDif=effConSigDif)
    "Calculates the chiller stage status setpoint signal"
    annotation(Placement(transformation(extent={{-160,-68},{-80,100}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Controller towCon(
    final nTowCel=nTowCel)
    annotation(Placement(transformation(extent={{-200,-720},{-120,-560}})));

  Staging.Processes.Down dowProCon
    annotation(Placement(transformation(extent={{180,-300},{260,-140}})));

  Staging.Processes.Up upProCon
    annotation(Placement(transformation(extent={{180,240},{260,400}})));

  CDL.Continuous.MultiMax mulMax(nin=nTowCel) "All input values are the same"
    annotation(Placement(transformation(extent={{-60,-560},{-40,-540}})));

  CDL.Logical.Or chaProUpDown "Either in staging up or in staging down process"
    annotation(Placement(transformation(extent={{380,130},{400,150}})));

  CDL.Discrete.TriggeredSampler staSam
    "Samples stage index after each staging process is finished"
    annotation(Placement(transformation(extent={{30,100},{50,120}})));

  CDL.Conversions.RealToInteger reaToInt1
    annotation(Placement(transformation(extent={{60,100},{80,120}})));

  CDL.Conversions.IntegerToReal intToRea
    annotation(Placement(transformation(extent={{0,100},{20,120}})));

  CDL.Logical.FallingEdge falEdg
    annotation(Placement(transformation(extent={{320,40},{340,60}})));

  CDL.Interfaces.IntegerOutput yNumCel
    "Total number of enabled cells"
    annotation(Placement(transformation(extent={{800,-560},{840,-520}}),
      iconTransformation(extent={{100,150},{140,190}})));

  CDL.Logical.MultiOr mulOr(nu=nPum)
    annotation(Placement(transformation(extent={{-640,-110},{-620,-90}})));

  CDL.Routing.RealReplicator reaRep(nout=nTowCel)
    annotation(Placement(transformation(extent={{-390,210},{-370,230}})));

  CDL.Continuous.MultiMax conWatPumSpe(nin=nConWatPum)
    "Running condenser water pump speed"
    annotation (Placement(transformation(extent={{-560,-410},{-540,-390}})));
equation
  connect(staSetCon.uPla, plaEna.yPla) annotation(Line(points={{-168,72},{-460,
          72},{-460,-480},{-518,-480}},        color={255,0,255}));
  connect(TOutWet, wseSta.TOutWet) annotation(Line(points={{-820,100},{-720,100},
          {-720,316},{-564,316}},      color={0,0,127}));
  connect(TChiWatRetDow, wseSta.TChiWatRetDow) annotation(Line(points={{-820,20},
          {-690,20},{-690,300},{-564,300}},       color={0,0,127}));
  connect(VChiWat_flow, wseSta.VChiWat_flow) annotation(Line(points={{-820,-20},
          {-760,-20},{-760,292},{-564,292}}, color={0,0,127}));
  connect(TOutWet, plaEna.TOut) annotation(Line(points={{-820,100},{-720,100},{
          -720,-488},{-564,-488},{-564,-488.4}},  color={0,0,127}));
  connect(chiWatSupResReq, plaEna.chiWatSupResReq) annotation(Line(points={{-820,
          250},{-680,250},{-680,-472},{-564,-472}},        color={255,127,0}));
  connect(chiWatSupSet.TChiWatSupSet, staSetCon.TChiWatSupSet) annotation(Line(
        points={{-272,516},{-260,516},{-260,48},{-168,48}},     color={0,0,127}));
  connect(TChiWatSup, staSetCon.TChiWatSup) annotation(Line(points={{-820,-90},
          {-710,-90},{-710,40},{-168,40}},       color={0,0,127}));
  connect(VChiWat_flow, minBypValCon.VChiWat_flow) annotation(Line(points={{-820,
          -20},{-760,-20},{-760,-140},{-564,-140}},    color={0,0,127}));
  connect(heaPreCon.TConWatRet, TChiWatRet) annotation(Line(points={{-464,212},
          {-740,212},{-740,60},{-820,60}},   color={0,0,127}));
  connect(TChiWatRet, staSetCon.TChiWatRet) annotation(Line(points={{-820,60},{
          -740,60},{-740,-48},{-168,-48}},                             color={0,
          0,127}));
  connect(staSetCon.TWsePre, wseSta.TWsePre) annotation(Line(points={{-168,-56},
          {-320,-56},{-320,300},{-518,300}},
        color={0,0,127}));
  connect(VChiWat_flow, staSetCon.VChiWat_flow) annotation(Line(points={{-820,
          -20},{-760,-20},{-760,-64},{-168,-64}},
        color={0,0,127}));
  connect(TChiWatSup, heaPreCon.TChiWatSup) annotation(Line(points={{-820,-90},
          {-710,-90},{-710,204},{-464,204}}, color={0,0,127}));
  connect(wseSta.y, heaPreCon.uWSE) annotation(Line(points={{-518,310},{-490,
          310},{-490,188},{-464,188}}, color={255,0,255}));
  connect(chiWatSupResReq, chiWatPlaRes.TChiWatSupResReq) annotation(Line(
        points={{-820,250},{-680,250},{-680,-300},{-564,-300}},   color={255,
          127,0}));
  connect(chiWatPlaRes.yChiWatPlaRes, chiWatSupSet.uChiWatPlaRes) annotation (
      Line(points={{-516,-300},{-406,-300},{-406,540},{-368,540}},
                                                                color={0,0,127}));
  connect(dpChiWatPum, staSetCon.dpChiWatPum) annotation(Line(points={{-820,
          -120},{-728,-120},{-728,0},{-168,0}},     color={0,0,127}));
  connect(chiWatSupSet.dpChiWatPumSet, staSetCon.dpChiWatPumSet) annotation (
      Line(points={{-272,564},{-240,564},{-240,-8},{-168,-8}},     color={0,0,
          127}));
  connect(uChi, towCon.uChi) annotation(Line(points={{-820,470},{-700,470},{
          -700,-572},{-208,-572}},      color={255,0,255}));
  connect(wseSta.y, staSetCon.uWseSta) annotation(Line(points={{-518,310},{-400,
          310},{-400,96},{-168,96}},            color={255,0,255}));
  connect(wseSta.y, towCon.uWse) annotation(Line(points={{-518,310},{-400,310},
          {-400,-580},{-208,-580}},     color={255,0,255}));
  connect(plaEna.yPla, towCon.uPla) annotation(Line(points={{-518,-480},{-460,
          -480},{-460,-636},{-208,-636}},     color={255,0,255}));
  connect(TOutWet, staSetCon.TOutWet) annotation(Line(points={{-820,100},{-720,
          100},{-720,-20},{-168,-20}},                 color={0,0,127}));
  connect(towCon.yFanSpe, mulMax.u[1:4]) annotation(Line(points={{-112,-684},{
          -80,-684},{-80,-550},{-62,-550}},
                                        color={0,0,127}));
  connect(mulMax.y, staSetCon.uTowFanSpeMax) annotation(Line(points={{-38,-550},
          {-20,-550},{-20,-360},{-200,-360},{-200,-36},{-168,-36}},
        color={0,0,127}));
  connect(staSetCon.ySta, upProCon.uStaSet) annotation(Line(points={{-72,-24},{
          22,-24},{22,396},{172,396}},                    color={255,127,0}));
  connect(staSetCon.ySta, dowProCon.uStaSet) annotation(Line(points={{-72,-24},
          {22,-24},{22,-147.2},{172,-147.2}},             color={255,127,0}));
  connect(staSetCon.yChiSet, upProCon.uChiSet) annotation(Line(points={{-72,4},
          {26,4},{26,384},{172,384}},
        color={255,0,255}));
  connect(staSetCon.yChiSet, dowProCon.uChiSet) annotation(Line(points={{-72,4},
          {26,4},{26,-155.2},{172,-155.2}},                 color={255,0,255}));
  connect(uChiLoa, upProCon.uChiLoa) annotation(Line(points={{-820,150},{-200,
          150},{-200,368},{172,368}},                        color={0,0,127}));
  connect(upProCon.yStaPro, chaProUpDown.u1) annotation(Line(points={{268,396},
          {340,396},{340,140},{378,140}},          color={255,0,255}));
  connect(dowProCon.yStaPro, chaProUpDown.u2) annotation(Line(points={{268,-144},
          {300,-144},{300,132},{378,132}},       color={255,0,255}));
  connect(uChi, dowProCon.uChi) annotation(Line(points={{-820,470},{-700,470},{
          -700,-188},{172,-188}},
        color={255,0,255}));
  connect(staSam.u, intToRea.y)
    annotation(Line(points={{28,110},{22,110}}, color={0,0,127}));
  connect(staSam.y, reaToInt1.u)
    annotation(Line(points={{52,110},{58,110}}, color={0,0,127}));
  connect(dowProCon.yStaPro, falEdg.u) annotation(Line(points={{268,-144},{300,
          -144},{300,50},{318,50}},     color={255,0,255}));
  connect(falEdg.y, staSam.trigger) annotation(Line(points={{342,50},{360,50},{
          360,90},{40,90},{40,98.2}},  color={255,0,255}));
  connect(staSetCon.ySta, intToRea.u) annotation(Line(points={{-72,-24},{-10,
          -24},{-10,110},{-2,110}},          color={255,127,0}));
  connect(reaToInt1.y, dowProCon.uChiSta) annotation(Line(points={{82,110},{90,
          110},{90,-208},{172,-208}},    color={255,127,0}));
  connect(reaToInt1.y, staSetCon.uSta) annotation(Line(points={{82,110},{94,110},
          {94,-120},{-220,-120},{-220,60},{-168,60}},       color={255,127,0}));
  connect(mulMax.y, wseSta.uTowFanSpeMax) annotation(Line(points={{-38,-550},{
          -20,-550},{-20,-360},{-600,-360},{-600,284},{-564,284}},
                      color={0,0,127}));
  connect(towCon.yNumCel, yNumCel) annotation(Line(points={{-112,-572},{720,
          -572},{720,-540},{820,-540}},      color={255,127,0}));
  connect(towCon.yIsoVal, yIsoVal) annotation(Line(points={{-112,-620},{720,
          -620},{720,-630},{820,-630}},      color={0,0,127}));
  connect(towCon.yFanSpe, yFanSpe) annotation(Line(points={{-112,-684},{720,
          -684},{720,-690},{820,-690}},
                      color={0,0,127}));
  connect(towCon.yLeaCel, yLeaCel) annotation(Line(points={{-112,-596},{720,
          -596},{720,-590},{820,-590}},      color={255,0,255}));
  connect(towCon.yTowSta, yTowSta) annotation(Line(points={{-112,-660},{820,
          -660}},                            color={255,0,255}));
  connect(towCon.yMakUp, yMakUp) annotation(Line(points={{-112,-708},{720,-708},
          {720,-740},{820,-740}},        color={255,0,255}));
  connect(chaProUpDown.y, chiWatPlaRes.chaPro) annotation(Line(points={{402,140},
          {420,140},{420,-340},{-580,-340},{-580,-312},{-564,-312}},      color=
         {255,0,255}));
  connect(uChiWatPum, chiWatPlaRes.uChiWatPum) annotation(Line(points={{-820,
          340},{-670,340},{-670,-288},{-564,-288}},
        color={255,0,255}));
  connect(mulOr.y, minBypValCon.uChiWatPum) annotation(Line(points={{-618,-100},
          {-580,-100},{-580,-124},{-564,-124}},
                                             color={255,0,255}));
  connect(uChiWatPum, mulOr.u) annotation(Line(points={{-820,340},{-670,340},{
          -670,-100},{-642,-100}},color={255,0,255}));
  connect(staSetCon.yOpeParLoaRatMin, dowProCon.uOpeParLoaRatMin) annotation (
      Line(points={{-72,-52},{60,-52},{60,-168},{172,-168}},             color=
          {0,0,127}));
  connect(uChi, upProCon.uChi) annotation(Line(points={{-820,470},{-700,470},{
          -700,360},{172,360}},                                        color={
          255,0,255}));
  connect(VChiWat_flow, upProCon.VChiWat_flow) annotation(Line(points={{-820,
          -20},{-760,-20},{-760,350},{-12,350},{-12,350.4},{172,350.4}},  color=
         {0,0,127}));
  connect(wseSta.y, upProCon.uWSE) annotation(Line(points={{-518,310},{-14,310},
          {-14,300},{172,300}},color={255,0,255}));
  connect(wseSta.y, dowProCon.uWSE) annotation(Line(points={{-518,310},{-14,310},
          {-14,-276},{172,-276}},          color={255,0,255}));
  connect(heaPreCon.yMaxTowSpeSet, reaRep.u)
    annotation(Line(points={{-418,212},{-412,212},{-412,220},{-392,220}},
                                                    color={0,0,127}));
  connect(reaRep.y, towCon.uMaxTowSpeSet) annotation(Line(points={{-368,220},{
          -354,220},{-354,-620},{-208,-620}},
        color={0,0,127}));
  connect(dowProCon.VChiWat_flow, VChiWat_flow) annotation(Line(points={{172,
          -196},{-760,-196},{-760,-20},{-820,-20}},
                       color={0,0,127}));
  connect(uChiWatPum, chiWatPumCon.uChiWatPum) annotation(Line(points={{-820,
          340},{-670,340},{-670,488},{314,488}},   color={255,0,255}));
  connect(uChiIsoVal, chiWatPumCon.uChiIsoVal) annotation(Line(points={{-820,
          500},{-680,500},{-680,464},{314,464}}, color={255,0,255}));
  connect(VChiWat_flow, chiWatPumCon.VChiWat_flow) annotation(Line(points={{-820,
          -20},{-760,-20},{-760,458},{314,458}},      color={0,0,127}));
  connect(dpChiWat_remote, chiWatPumCon.dpChiWat_remote) annotation(Line(
        points={{-820,-150},{-770,-150},{-770,446},{314,446}},
                                                           color={0,0,127}));
  connect(heaPreCon.yHeaPreConVal, yHeaPreConVal) annotation(Line(points={{-418,
          200},{820,200}},                                                color=
         {0,0,127}));
  connect(upProCon.yChiDem, yChiDem) annotation(Line(points={{268,380},{820,380}},
                                   color={0,0,127}));
  connect(TChiWatSup, towCon.TChiWatSup) annotation(Line(points={{-820,-90},{
          -710,-90},{-710,-596},{-208,-596}},
        color={0,0,127}));
  connect(chiWatSupSet.TChiWatSupSet, towCon.TChiWatSupSet) annotation(Line(
        points={{-272,516},{-260,516},{-260,-604},{-208,-604}},
        color={0,0,127}));
  connect(staSetCon.ySta, towCon.uChiSta) annotation(Line(points={{-72,-24},{6,
          -24},{6,-100},{-414,-100},{-414,-668},{-208,-668}},
                            color={255,127,0}));
  connect(staSetCon.ySta, upProCon.uChiSta) annotation(Line(points={{-72,-24},{
          -20,-24},{-20,328},{172,328}},                      color={255,127,0}));
  connect(staSetCon.ySta, dowProCon.uChiSta) annotation(Line(points={{-72,-24},
          {14,-24},{14,-208},{172,-208}},                    color={255,127,0}));
  connect(dowProCon.uChiLoa, uChiLoa) annotation(Line(points={{172,-176},{-8,
          -176},{-8,150},{-820,150}}, color={0,0,127}));
  connect(dowProCon.uChiWatIsoVal, uChiWatIsoVal) annotation(Line(points={{172,
          -232},{-650,-232},{-650,-200},{-820,-200}},         color={0,0,127}));
  connect(uChiWatIsoVal, upProCon.uChiWatIsoVal) annotation(Line(points={{-820,
          -200},{-650,-200},{-650,252},{172,252}},                    color={0,
          0,127}));
  connect(dowProCon.yDesConWatPumSpe, heaPreCon.desConWatPumSpe) annotation (
      Line(points={{268,-264},{320,-264},{320,-110},{-480,-110},{-480,196},{
          -464,196}},                                            color={0,0,127}));
  connect(yChiWatPum, chiWatPumCon.yChiWatPum) annotation(Line(points={{820,540},
          {420,540},{420,470},{386,470}},                          color={255,0,
          255}));
  connect(heaPreCon.yConWatPumSpeSet, dowProCon.uConWatPumSpeSet) annotation (
      Line(points={{-418,188},{-310,188},{-310,-288},{172,-288}},     color={0,
          0,127}));
  connect(heaPreCon.yConWatPumSpeSet, upProCon.uConWatPumSpeSet) annotation (
      Line(points={{-418,188},{-310,188},{-310,288},{172,288}},
        color={0,0,127}));
  connect(chiWatPumCon.yPumSpe, yChiPumSpe) annotation(Line(points={{386,446},{
          440,446},{440,500},{820,500}},  color={0,0,127}));
  connect(chiWatSupSet.dpChiWatPumSet, chiWatPumCon.dpChiWatSet) annotation (
      Line(points={{-272,564},{300,564},{300,440},{314,440}}, color={0,0,127}));
  connect(uChiAva, staSetCon.uChiAva) annotation(Line(points={{-820,440},{-660,
          440},{-660,80},{-168,80}},                   color={255,0,255}));
  connect(minBypValCon.yValPos, yValPos) annotation(Line(points={{-516,-140},{
          -380,-140},{-380,-440},{820,-440}},                       color={0,0,
          127}));
  connect(staSetCon.ySta, towCon.uChiStaSet) annotation(Line(points={{-72,-24},
          {-30,-24},{-30,-320},{-420,-320},{-420,-676},{-208,-676}},
        color={255,127,0}));
  connect(TConWatSup, towCon.TConWatSup) annotation(Line(points={{-820,-260},{
          -760,-260},{-760,-660},{-208,-660}},    color={0,0,127}));
  connect(TConWatRet, towCon.TConWatRet) annotation(Line(points={{-820,-60},{
          -780,-60},{-780,-644},{-208,-644}},    color={0,0,127}));
  connect(watLev1, towCon.watLev) annotation(Line(points={{-820,-760},{-780,
          -760},{-780,-716},{-208,-716}},   color={0,0,127}));
  connect(towCon.uIsoVal, uIsoVal) annotation(Line(points={{-208,-708},{-780,
          -708},{-780,-680},{-820,-680}},    color={0,0,127}));
  connect(uChiLoa, towCon.chiLoa) annotation(Line(points={{-820,150},{-746,150},
          {-746,-564},{-208,-564}},         color={0,0,127}));
  connect(uTowSta, towCon.uTowSta) annotation (Line(points={{-820,390},{-734,
          390},{-734,-628},{-208,-628}}, color={255,0,255}));
  connect(uConWatPumSpe, conWatPumSpe.u) annotation (Line(points={{-820,-400},{
          -562,-400}},                         color={0,0,127}));
  connect(uConWatPumSpe, towCon.uConWatPumSpe) annotation (Line(points={{-820,
          -400},{-600,-400},{-600,-652},{-208,-652}}, color={0,0,127}));
  connect(conWatPumSpe.y, dowProCon.uConWatPumSpe) annotation (Line(points={{-538,
          -400},{108,-400},{108,-296},{172,-296}},      color={0,0,127}));
  connect(conWatPumSpe.y, upProCon.uConWatPumSpe) annotation (Line(points={{-538,
          -400},{108,-400},{108,276},{172,276}},      color={0,0,127}));
  connect(wseSta.yTunPar, staSetCon.uTunPar) annotation (Line(points={{-518,290},
          {-500,290},{-500,-28},{-168,-28}},         color={0,0,127}));
  connect(TChiWatRet, wseSta.TChiWatRet) annotation (Line(points={{-820,60},{
          -740,60},{-740,308},{-564,308}}, color={0,0,127}));
  connect(chaProUpDown.y, staSetCon.chaPro) annotation (Line(points={{402,140},
          {420,140},{420,-340},{-206,-340},{-206,88},{-168,88}}, color={255,0,
          255}));
    annotation (Dialog(tab="Plant Reset", group="Time parameter"),
               Evaluate=true, Dialog(tab="Advanced", group="Tuning"),
  defaultComponentName="chiPlaCon",
  Icon(coordinateSystem(extent={{-800,-860},{800,840}}),
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
          extent={{-800,-860},{800,840}}), graphics={                 Text(
          extent={{350,192},{456,156}},
          lineColor={28,108,200},
          textString="might need a pre block"),                       Text(
          extent={{-482,-574},{-398,-594}},
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
