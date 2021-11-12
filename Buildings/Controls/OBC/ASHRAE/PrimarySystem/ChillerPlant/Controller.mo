within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block Controller "Chiller plant controller"

  parameter Boolean closeCoupledPlant=false
    "True: the plant is close coupled, i.e. the pipe length from the chillers to cooling towers does not exceed approximately 100 feet"
    annotation (Dialog(tab="General"));

  // ---- General: Chiller configuration ----

  parameter Integer nChi=2
    "Total number of chillers"
    annotation(Dialog(tab="General", group="Chillers configuration"));

  parameter Boolean have_parChi=true
    "Flag: true means that the plant has parallel chillers"
    annotation(Dialog(tab="General", group="Chillers configuration"));

  parameter Boolean have_ponyChiller=false
    "True: have pony chiller"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Real desCap(
    final unit="W",
    final quantity="HeatFlowRate")=1e6
    "Plant design capacity"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Integer chiTyp[nChi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal}
    "Chiller type. Recommended staging order: positive displacement, variable speed centrifugal, constant speed centrifugal"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Real chiDesCap[nChi](
    final unit=fill("W",nChi),
    final quantity=fill("HeatFlowRate", nChi))
    "Design chiller capacities vector"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Real chiMinCap[nChi](
    final unit=fill("W",nChi),
    final quantity=fill("HeatFlowRate", nChi))
    "Chiller minimum cycling loads vector"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Real TChiWatSupMin[nChi](
    final unit=fill("K", nChi),
    final quantity=fill("ThermodynamicTemperature", nChi),
    displayUnit=fill("degC", nChi))={278.15,278.15}
    "Minimum chilled water supply temperature"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Real minChiLif(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="K")=10
    "Minimum allowable lift at minimum load for chiller"
    annotation(Dialog(tab="General", group="Chillers configuration", enable=not have_heaPreConSig));

  parameter Boolean have_heaPreConSig = false
    "True: if there is head pressure control signal from chiller controller"
    annotation(Dialog(tab="General", group="Chillers configuration"));

  parameter Boolean anyVsdCen = false
    "True: the plant contains at least one variable speed centrifugal chiller"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  // ---- General: Waterside economizer ----

  parameter Boolean have_WSE=true
    "True if the plant has waterside economizer. When the plant has waterside economizer, the condenser water pump speed must be variable"
    annotation (Dialog(tab="General", group="Waterside economizer"));

  parameter Real heaExcAppDes(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="K")=2
    "Design heat exchanger approach"
    annotation(Evaluate=true, Dialog(tab="General", group="Waterside economizer", enable=have_WSE));

  // ----- General: Chilled water pump ---

  parameter Integer nChiWatPum = 2
    "Total number of chilled water pumps"
    annotation (Dialog(tab="General", group="Chilled water pump"));

  parameter Boolean have_heaChiWatPum = true
    "Flag of headered chilled water pumps design: true=headered, false=dedicated"
    annotation (Dialog(tab="General", group="Chilled water pump"));

  parameter Boolean have_locSenChiWatPum=false
    "True: there is local differential pressure sensor hardwired to the plant controller"
    annotation (Dialog(tab="General", group="Chilled water pump"));

  parameter Integer nSenChiWatPum=2
    "Total number of remote differential pressure sensors"
    annotation (Dialog(tab="General", group="Chilled water pump"));

  // ---- General: Condenser water pump ----

  parameter Integer nConWatPum=2
    "Total number of condenser water pumps"
    annotation (Dialog(tab="General", group="Condenser water pump"));

  parameter Boolean have_fixSpeConWatPum = false
    "True: the plant has fixed speed condenser water pumps. When the plant has waterside economizer, it must be false"
    annotation(Dialog(tab="General", group="Condenser water pump", enable=not have_WSE));

  parameter Boolean have_heaConWatPum=true
    "True: headered condenser water pumps"
    annotation (Dialog(tab="General", group="Condenser water pump"));

  // ---- General: Chiller staging settings ----

  parameter Integer nSta = 2
    "Number of chiller stages, neither zero stage nor the stages with enabled waterside economizer is included"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Integer totSta=6
    "Total number of plant stages, including stage zero and the stages with a WSE, if applicable"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Integer staMat[nSta, nChi] = {{1,0},{1,1}}
    "Staging matrix with chiller stage as row index and chiller as column index"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Real desChiNum[nSta+1]={0,1,2}
    "Design number of chiller that should be ON at each chiller stage, including the zero stage"
    annotation (Dialog(tab="General", group="Staging configuration", enable=have_fixSpeConWatPum));

  parameter Real staVec[totSta]={0,0.5,1,1.5,2,2.5}
    "Plant stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Real desConWatPumSpe[totSta](
    final min=fill(0, totSta),
    final max=fill(1, totSta))={0,0.5,0.75,0.6,0.75,0.9}
    "Design condenser water pump speed setpoints, according to current chiller stage and WSE status"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Real desConWatPumNum[totSta]={0,1,1,2,2,2}
    "Design number of condenser water pumps that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Real towCelOnSet[totSta]={0,2,2,4,4,4}
    "Design number of tower fan cells that should be ON, according to current chiller stage and WSE status"
    annotation(Dialog(tab="General", group="Staging configuration"));

  // ---- General: Cooling tower ----

  parameter Integer nTowCel=4
    "Total number of cooling tower cells"
    annotation (Dialog(tab="General", group="Cooling tower"));

  parameter Real cooTowAppDes(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="K")=2
    "Design cooling tower approach"
    annotation(Evaluate=true, Dialog(tab="General", group="Cooling tower"));

  // ---- Plant enable ----

  parameter Real schTab[4,2] = [0,1; 6*3600,1; 19*3600,1; 24*3600,1]
    "Plant enabling schedule allowing operators to lock out the plant during off-hour"
    annotation(Dialog(tab="Plant enable"));

  parameter Real TChiLocOut(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=277.5
    "Outdoor air lockout temperature below which the chiller plant should be disabled"
    annotation(Dialog(tab="Plant enable"));

  parameter Real plaThrTim(
    final unit="s",
    quantity="Time")=900
    "Threshold time to check status of chiller plant"
    annotation(Dialog(tab="Plant enable"));

  parameter Real reqThrTim(
    final unit="s",
    quantity="Time")=180
    "Threshold time to check current chiller plant request"
    annotation(Dialog(tab="Plant enable"));

  parameter Integer ignReq = 0
    "Ignorable chiller plant requests"
    annotation(Dialog(tab="Plant enable"));

  // ---- Waterside economizer ----

  parameter Real holdPeriod(
    final unit="s",
    final quantity="Time")=1200
    "WSE minimum on or off time"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Enable parameters"));

  parameter Real delDis(
    final unit="s",
    final quantity="Time")=120
    "Delay disable time period"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Enable parameters"));

  parameter Real TOffsetEna(
    final unit="K",
    final quantity="TemperatureDifference")=2
    "Temperature offset between the chilled water return upstream of WSE and the predicted WSE output"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Enable parameters"));

  parameter Real TOffsetDis(
    final unit="K",
    final quantity="TemperatureDifference")=1
    "Temperature offset between the chilled water return upstream and downstream WSE"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Enable parameters"));

  parameter Real TOutWetDes(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=288.15
    "Design outdoor air wet bulb temperature"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters"));

  parameter Real VHeaExcDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.015
    "Desing heat exchanger chilled water volume flow rate"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters"));

  parameter Real step=0.02 "Tuning step"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Tuning"));

  parameter Real wseOnTimDec(
    final unit="s",
    final quantity="Time")=3600
    "Economizer enable time needed to allow decrease of the tuning parameter"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Tuning"));

  parameter Real wseOnTimInc(
    final unit="s",
    final quantity="Time")=1800
    "Economizer enable time needed to allow increase of the tuning parameter"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Tuning"));

  // ---- Head pressure ----

  parameter Real minConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1")=0.1
    "Minimum condenser water pump speed"
    annotation(Dialog(enable= not ((not have_WSE) and have_fixSpeConWatPum), tab="Head pressure", group="Limits"));

  parameter Real minHeaPreValPos(
    final min=0,
    final max=1,
    final unit="1")=0.1
    "Minimum head pressure control valve position"
    annotation(Dialog(enable= (not ((not have_WSE) and (not have_fixSpeConWatPum))), tab="Head pressure", group="Limits"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHeaPre=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation(Dialog(tab="Head pressure", group="Loop signal", enable=not have_heaPreConSig));

  parameter Real kHeaPreCon=1
    "Gain of controller"
    annotation(Dialog(tab="Head pressure", group="Loop signal", enable=not have_heaPreConSig));

  parameter Real TiHeaPreCon(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation(Dialog(tab="Head pressure", group="Loop signal", enable=not have_heaPreConSig));

  // ---- Minimum flow bypass ----

  parameter Real byPasSetTim(
    final unit="s",
    final quantity="Time")=300
    "Time constant for resetting minimum bypass flow"
    annotation(Dialog(tab="Minimum flow bypass", group="Time parameters"));

  parameter Real minFloSet[nChi](
    final unit=fill("m3/s", nChi),
    final quantity=fill("VolumeFlowRate", nChi))={0.0089,0.0089}
    "Minimum chilled water flow through each chiller"
    annotation(Dialog(tab="Minimum flow bypass", group="Flow limits"));

  parameter Real maxFloSet[nChi](
    final unit=fill("m3/s", nChi),
    final quantity=fill("VolumeFlowRate", nChi))={0.025,0.025}
    "Maximum chilled water flow through each chiller"
    annotation(Dialog(tab="Minimum flow bypass", group="Flow limits"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMinFloByp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Minimum flow bypass", group="Controller"));

  parameter Real kMinFloBypCon=1
    "Gain of controller"
    annotation (Dialog(tab="Minimum flow bypass", group="Controller"));

  parameter Real TiMinFloBypCon(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Minimum flow bypass",
    group="Controller", enable=controllerTypeMinFloByp==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                               controllerTypeMinFloByp==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdMinFloBypCon(
    final unit="s",
    final quantity="Time")=0
    "Time constant of derivative block"
    annotation (Dialog(tab="Minimum flow bypass",
    group="Controller", enable=controllerTypeMinFloByp==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                               controllerTypeMinFloByp==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real yMaxFloBypCon(
    final min=0,
    final max=1,
    final unit="1")=1 "Upper limit of output"
    annotation (Dialog(tab="Minimum flow bypass", group="Controller"));

  parameter Real yMinFloBypCon(
    final min=0,
    final max=1,
    final unit="1")=0.1 "Lower limit of output"
    annotation (Dialog(tab="Minimum flow bypass", group="Controller"));

  // ---- Chilled water pumps ----

  parameter Real minChiWatPumSpe(
    final min=0,
    final max=1,
    final unit="1")=0.1
    "Minimum pump speed"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Real maxChiWatPumSpe(
    final min=0,
    final max=1,
    final unit="1")=1
    "Maximum pump speed"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Integer nPum_nominal(
    final max=nChiWatPum,
    final min=1)=nChiWatPum
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(tab="Chilled water pumps", group="Nominal conditions"));

  parameter Real VChiWat_flow_nominal(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.5
    "Total plant design chilled water flow rate"
    annotation (Dialog(tab="Chilled water pumps", group="Nominal conditions"));

  parameter Real maxLocDp(
    final unit="Pa",
    final quantity="PressureDifference")=15*6894.75
    "Maximum chilled water loop local differential pressure setpoint"
    annotation (Dialog(tab="Chilled water pumps", group="Pump speed control when there is local DP sensor", enable=have_locSenChiWatPum));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeChiWatPum=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Real kChiWatPum=1 "Gain of controller"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Real TiChiWatPum(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Real TdChiWatPum(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller",
                       enable=controllerTypeChiWatPum == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                              controllerTypeChiWatPum == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  // ---- Plant reset ----

  parameter Real holTim(
    final unit="s",
    final quantity="Time")=900
    "Time to fix plant reset value"
    annotation(Dialog(tab="Plant Reset"));

  parameter Real iniSet(
    final min=0,
    final max=1,
    final unit="1") = 0 "Initial setpoint"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond"));

  parameter Real minSet(
    final min=0,
    final max=1,
    final unit="1") = 0 "Minimum plant reset value"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond"));

  parameter Real maxSet(
    final min=0,
    final max=1,
    final unit="1") = 1 "Maximum plant reset value"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond"));

  parameter Real delTim(
    final unit="s",
    final quantity="Time")=900
    "Delay time after which trim and respond is activated"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond"));

  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time")=300
    "Sample period time"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond"));

  parameter Integer numIgnReq = 2
    "Number of ignored requests"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond"));

  parameter Real triAmo = -0.02 "Trim amount"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond"));

  parameter Real resAmo = 0.03
    "Respond amount (must be opposite in to triAmo)"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond"));

  parameter Real maxRes = 0.07
    "Maximum response per time interval (same sign as resAmo)"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond"));

  parameter Real dpChiWatPumMin(
    final unit="Pa",
    final quantity="PressureDifference",
    displayUnit="Pa")=34473.8
    "Minimum chilled water pump differential static pressure, default 5 psi"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  parameter Real dpChiWatPumMax[nSenChiWatPum](
    final unit=fill("Pa",nSenChiWatPum),
    final quantity=fill("PressureDifference",nSenChiWatPum),
    displayUnit=fill("Pa",nSenChiWatPum))
    "Maximum chilled water pump differential static pressure, the array size equals to the number of remote pressure sensor"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  parameter Real TChiWatSupMax(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=288.706
    "Maximum chilled water supply temperature, default 60 degF"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  parameter Real halSet = 0.5
    "Half plant reset value"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  // ---- Staging setpoints ----

  parameter Real avePer(
    final unit="s",
    final quantity="Time")=300
    "Time period for the capacity requirement rolling average"
    annotation (Dialog(tab="Staging", group="Hold and delay"));

  parameter Real delayStaCha(
    final unit="s",
    final quantity="Time")=900
    "Hold period for each stage change"
    annotation (Dialog(tab="Staging", group="Hold and delay"));

  parameter Real parLoaRatDelay(
    final unit="s",
    final quantity="Time")=900
    "Enable delay for operating and staging part load ratio condition"
    annotation (Dialog(tab="Staging", group="Hold and delay"));

  parameter Real faiSafTruDelay(
    final unit="s",
    final quantity="Time")=900
    "Enable delay for failsafe condition"
    annotation (Dialog(tab="Staging", group="Hold and delay"));

  parameter Real effConTruDelay(
    final unit="s",
    final quantity="Time")=900
    "Enable delay for efficiency condition"
    annotation (Dialog(tab="Staging", group="Hold and delay"));

  parameter Real shortTDelay(
    final unit="s",
    final quantity="Time")=600
    "Short enable delay for staging from zero to first available stage up"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Staging", group="Hold and delay"));

  parameter Real longTDelay(
    final unit="s",
    final quantity="Time")=1200
    "Long enable delay for staging from zero to first available stage up"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Staging", group="Hold and delay"));

  parameter Real posDisMult(
    final unit="1")=0.8
    "Positive displacement chiller type staging multiplier"
    annotation (Dialog(tab="Staging", group="Staging part load ratio"));

  parameter Real conSpeCenMult(
    final unit="1")=0.9
    "Constant speed centrifugal chiller type staging multiplier"
    annotation (Dialog(tab="Staging", group="Staging part load ratio"));

  parameter Real anyOutOfScoMult(
    final unit="1")=0.9
    "Outside of G36 recommended staging order chiller type SPLR multiplier"
    annotation(Evaluate=true, __cdl(ValueInReference=False), Dialog(tab="Staging", group="Staging part load ratio"));

  parameter Real varSpeStaMin(
    final min=0,
    final max=1,
    final unit="1")=0.45
    "Minimum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen, tab="Staging", group="Staging part load ratio"));

  parameter Real varSpeStaMax(
    final min=0,
    final max=1,
    final unit="1")=0.9
    "Maximum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen, tab="Staging", group="Staging part load ratio"));

  parameter Real smallTDif(
    final unit="K",
    final quantity="TemperatureDifference")=1
    "Offset between the chilled water supply temperature and its setpoint for the long condition"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Staging", group="Value comparison"));

  parameter Real largeTDif(
    final unit="K",
    final quantity="TemperatureDifference")=2
    "Offset between the chilled water supply temperature and its setpoint for the short condition"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Staging", group="Value comparison"));

  parameter Real faiSafTDif(
    final unit="K",
    final quantity="TemperatureDifference")=1
    "Offset between the chilled water supply temperature and its setpoint for the failsafe condition"
    annotation (Dialog(tab="Staging", group="Value comparison"));

  parameter Real dpDif(
    final unit="Pa",
    final quantity="PressureDifference",
    displayUnit="Pa")=2*6895
    "Offset between the chilled water pump diferential static pressure and its setpoint"
    annotation (Dialog(tab="Staging", group="Value comparison"));

  parameter Real TDif(
    final unit="K",
    final quantity="TemperatureDifference")=1
    "Offset between the chilled water supply temperature and its setpoint for staging down to WSE only"
    annotation (Dialog(tab="Staging", group="Value comparison"));

  parameter Real faiSafDpDif(
    final unit="Pa",
    final quantity="PressureDifference",
    displayUnit="Pa")=2*6895
    "Offset between the chilled water differential pressure and its setpoint"
    annotation (Dialog(tab="Staging", group="Value comparison"));

  parameter Real effConSigDif(
    final min=0,
    final max=1) = 0.05
    "Signal hysteresis deadband"
    annotation (Dialog(tab="Staging", group="Value comparison"));

  // ---- Staging up and down process ----

  parameter Real chiDemRedFac(
    final min=0,
    final max=1,
    final unit="1")=0.75
    "Demand reducing factor of current operating chillers"
    annotation (Dialog(tab="Staging", group="Up and down process"));

  parameter Real holChiDemTim(
    final unit="s",
    final quantity="Time")=300
    "Maximum time to wait for the actual demand less than percentage of current load"
    annotation (Dialog(tab="Staging", group="Up and down process"));

  parameter Real aftByPasSetTim(
    final unit="s",
    final quantity="Time")=60
    "Time to allow loop to stabilize after resetting minimum chilled water flow setpoint"
    annotation (Dialog(tab="Staging", group="Up and down process"));

  parameter Real waiTim(
    final unit="s",
    final quantity="Time")=30
    "Waiting time after enabling next head pressure control"
    annotation (Dialog(tab="Staging", group="Up and down process"));

  parameter Real chaChiWatIsoTim(
    final unit="s",
    final quantity="Time")=300
    "Time to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(tab="Staging", group="Up and down process"));

  parameter Real proOnTim(
    final unit="s",
    final quantity="Time")=300
    "Threshold time to check after newly enabled chiller being operated"
    annotation (Dialog(tab="Staging", group="Up and down process", enable=have_ponyChiller));

  parameter Real thrTimEnb(
    final unit="s",
    final quantity="Time")=10
    "Threshold time to enable head pressure control after condenser water pump being reset"
    annotation (Dialog(tab="Staging", group="Up and down process"));

  // ---- Cooling tower: fan speed ----

  parameter Real fanSpeMin(
    final min=0,
    final max=1,
    final unit="1")=0.1 "Minimum tower fan speed"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed"));

  parameter Real fanSpeMax(
    final min=0,
    final max=1,
    final unit="1")=1 "Maximum tower fan speed"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController intOpeCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Controller in the mode when WSE and chillers are enabled"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                       enable=have_WSE));

  parameter Real kIntOpeTowFan=1 "Gain of controller"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                       enable=have_WSE));

  parameter Real TiIntOpeTowFan(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                       enable=have_WSE and (intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                            intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real TdIntOpeTowFan(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                       enable=have_WSE and (intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                           intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController chiWatConTowFan=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Controller in the mode when only WSE is enabled"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled", enable=have_WSE));

  parameter Real kWSETowFan=1 "Gain of controller"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled", enable=have_WSE));

  parameter Real TiWSETowFan(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                        enable=have_WSE and (chiWatConTowFan==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                             chiWatConTowFan==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real TdWSETowFan(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                       enable=have_WSE and (chiWatConTowFan==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                            chiWatConTowFan==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  // Fan speed control: controlling condenser return water temperature when WSE is not enabled
  parameter Real LIFT_min[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("TemperatureDifference",nChi))={12,12}
    "Minimum LIFT of each chiller"
    annotation (Evaluate=true, Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control"));

  parameter Real TConWatSup_nominal[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("ThermodynamicTemperature",nChi),
    displayUnit=fill("degC",nChi))={293.15,293.15}
    "Condenser water supply temperature (condenser entering) of each chiller"
    annotation (Evaluate=true, Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control"));

  parameter Real TConWatRet_nominal[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("ThermodynamicTemperature",nChi),
    displayUnit=fill("degC",nChi))={303.15,303.15}
    "Condenser water return temperature (condenser leaving) of each chiller"
    annotation (Evaluate=true, Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController couPlaCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of coupled plant controller"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                        enable=closeCoupledPlant));

  parameter Real kCouPla=1 "Gain of controller"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                        enable=closeCoupledPlant));

  parameter Real TiCouPla(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=closeCoupledPlant and (couPlaCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                      couPlaCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real TdCouPla(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=closeCoupledPlant and (couPlaCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                     couPlaCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real yCouPlaMax(
    final min=0,
    final max=1,
    final unit="1")=1 "Upper limit of output"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=closeCoupledPlant));

  parameter Real yCouPlaMin(
    final min=0,
    final max=1,
    final unit="1")=0 "Lower limit of output"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                        enable=closeCoupledPlant));

  parameter Real samplePeriodConTDiff(
    final unit="s",
    final quantity="Time")=30
    "Period of sampling condenser water supply and return temperature difference"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=not closeCoupledPlant));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController supWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Condenser supply water temperature controller for less coupled plant"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=not closeCoupledPlant));

  parameter Real kSupCon=1 "Gain of controller"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=not closeCoupledPlant));

  parameter Real TiSupCon(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=not closeCoupledPlant and (supWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                         supWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real TdSupCon(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=not closeCoupledPlant and (supWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                         supWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real ySupConMax=1 "Upper limit of output"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=not closeCoupledPlant));

  parameter Real ySupConMin=0 "Lower limit of output"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=not closeCoupledPlant));

  parameter Real iniPlaTim(
    final unit="s",
    final quantity="Time")=600
    "Time to hold return temperature at initial setpoint after plant being enabled"
    annotation (Dialog(tab="Cooling Towers", group="Advanced"));

  parameter Real ramTim(
    final unit="s",
    final quantity="Time")=180
    "Time to ramp return water temperature from initial value to setpoint"
    annotation (Dialog(tab="Cooling Towers", group="Advanced"));

  parameter Real cheMinFanSpe(
    final unit="s",
    final quantity="Time")=300
    "Threshold time for checking duration when tower fan equals to the minimum tower fan speed"
    annotation (Dialog(tab="Cooling Towers", group="Advanced"));

  parameter Real cheMaxTowSpe(
    final unit="s",
    final quantity="Time")=300
    "Threshold time for checking duration when any enabled chiller maximum cooling speed equals to the minimum tower fan speed"
    annotation (Dialog(tab="Cooling Towers", group="Advanced"));

  parameter Real cheTowOff(
    final unit="s",
    final quantity="Time")=60
    "Threshold time for checking duration when there is no enabled tower fan"
    annotation (Dialog(tab="Cooling Towers", group="Advanced"));

  // ---- Cooling tower: staging ----
  parameter Real chaTowCelIsoTim(
    final unit="s",
    final quantity="Time")=300
    "Time to slowly change isolation valve"
     annotation (Dialog(tab="Cooling Towers", group="Enable isolation valve"));

  // ---- Cooling tower: Water level control ----
  parameter Real watLevMin(
    final min=0,
    final max=1,
    final unit="1")=0.7
    "Minimum cooling tower water level recommended by manufacturer"
     annotation (Dialog(tab="Cooling Towers", group="Makeup water"));

  parameter Real watLevMax(
    final min=0,
    final max=1,
    final unit="1")=1
    "Maximum cooling tower water level recommended by manufacturer"
    annotation (Dialog(tab="Cooling Towers", group="Makeup water"));

  // ---- Advanced ----
  parameter Real locDt(
    final unit="K",
    final quantity="TemperatureDifference")= 1
    "Offset temperature for lockout chiller"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Plant enable"));

  parameter Real hysDt(
    final unit="K",
    displayUnit="K")=1
    "Deadband temperature used in hysteresis block"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Waterside economizer"));

  parameter Real dpDifHys(
    final unit="Pa",
    final quantity="PressureDifference",
    displayUnit="Pa")=0.5*6895
    "Pressure difference hysteresis deadband"
    annotation (Dialog(tab="Advanced", group="Staging"));

  parameter Real relFloDif=0.05
    "Relative error to the setpoint for checking if it has achieved flow rate setpoint"
    annotation (Dialog(tab="Advanced", group="Staging"));

  parameter Real speChe=0.005
     "Lower threshold value to check fan or pump speed"
     annotation (Dialog(tab="Advanced", group="Cooling towers"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiConIsoVal[nChi]
    "Chilled condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-840,644},{-800,684}}),
      iconTransformation(extent={{-140,260},{-100,300}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water requst status for each chiller"
    annotation (Placement(transformation(extent={{-840,614},{-800,654}}),
      iconTransformation(extent={{-140,240},{-100,280}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    "Condenser water requst status for each chiller"
    annotation (Placement(transformation(extent={{-840,584},{-800,624}}),
      iconTransformation(extent={{-140,220},{-100,260}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nChiWatPum]
    "Chilled water pump status"
    annotation(Placement(transformation(extent={{-840,544},{-800,584}}),
      iconTransformation(extent={{-140,200},{-100,240}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiIsoVal[nChi] if have_heaChiWatPum
    "Chilled water isolation valve status"
    annotation(Placement(transformation(extent={{-840,520},{-800,560}}),
      iconTransformation(extent={{-140,180},{-100,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_local(
    final quantity="PressureDifference",
    final displayUnit="Pa") if have_locSenChiWatPum
    "Chilled water differential static pressure from local sensor"
    annotation (Placement(transformation(extent={{-840,490},{-800,530}}),
      iconTransformation(extent={{-140,160},{-100,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_remote[nSenChiWatPum](
    final unit=fill("Pa", nSenChiWatPum),
    final quantity=fill("PressureDifference", nSenChiWatPum))
    "Chilled water differential static pressure from remote sensor"
    annotation(Placement(transformation(extent={{-840,450},{-800,490}}),
      iconTransformation(extent={{-140,140},{-100,180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water volume flow rate"
    annotation(Placement(transformation(extent={{-840,420},{-800,460}}),
      iconTransformation(extent={{-140,120},{-100,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Vector of chiller proven on status: true=ON"
    annotation(Placement(transformation(extent={{-840,380},{-800,420}}),
      iconTransformation(extent={{-140,100},{-100,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutWet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_WSE
    "Outdoor air wet bulb temperature"
    annotation(Placement(transformation(extent={{-840,340},{-800,380}}),
      iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRetDow(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_WSE
    "Chiller water return temperature downstream of the WSE"
    annotation(Placement(transformation(extent={{-840,300},{-800,340}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chiller water return temperature upstream of the WSE"
    annotation(Placement(transformation(extent={{-840,260},{-800,300}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not have_heaPreConSig
    "Measured condenser water return temperature"
    annotation(Placement(transformation(extent={{-840,220},{-800,260}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if (not have_heaPreConSig) or have_WSE
    "Measured chilled water supply temperature"
    annotation(Placement(transformation(extent={{-840,190},{-800,230}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaPreCon[nChi] if have_heaPreConSig
    "Chiller head pressure control loop signal from chiller controller"
    annotation (Placement(transformation(extent={{-840,160},{-800,200}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa[nChi](
    final quantity=fill("ElectricCurrent",nChi),
    final unit=fill("A", nChi)) "Current chiller load, in amperage"
    annotation(Placement(transformation(extent={{-840,120},{-800,160}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector"
    annotation(Placement(transformation(extent={{-840,60},{-800,100}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chilled water isolation valve position"
    annotation(Placement(transformation(extent={{-840,-248},{-800,-208}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput chiWatSupResReq
    "Number of chiller plant cooling requests"
    annotation(Placement(transformation(extent={{-840,-320},{-800,-280}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum),
    final unit=fill("1", nConWatPum)) "Current condenser water pump speed"
    annotation(Placement(transformation(extent={{-840,-410},{-800,-370}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[nConWatPum]
    "Condenser water pump status"
    annotation (Placement(transformation(extent={{-840,-440},{-800,-400}}),
      iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-840,-500},{-800,-460}}),
      iconTransformation(extent={{-140,-180},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiCooLoa[nChi](
    final quantity=fill("HeatFlowRate",nChi),
    final unit=fill("W", nChi)) if have_WSE
                                "Current chiller cooling load"
    annotation (Placement(transformation(extent={{-840,-560},{-800,-520}}),
      iconTransformation(extent={{-140,-200},{-100,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFanSpe(
    final quantity="1",
    final min=0,
    final max=1) "Tower fan speed"
    annotation (Placement(transformation(extent={{-840,-608},{-800,-568}}),
      iconTransformation(extent={{-140,-220},{-100,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not closeCoupledPlant
    "Condenser water supply temperature"
    annotation(Placement(transformation(extent={{-840,-680},{-800,-640}}),
      iconTransformation(extent={{-140,-240},{-100,-200}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoVal[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel))
    "Vector of tower cells isolation valve position"
    annotation(Placement(transformation(extent={{-840,-728},{-800,-688}}),
      iconTransformation(extent={{-140,-260},{-100,-220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput watLev
    "Measured water level"
    annotation (Placement(transformation(extent={{-840,-760},{-800,-720}}),
      iconTransformation(extent={{-140,-280},{-100,-240}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cell proven on status: true=running tower cell"
    annotation(Placement(transformation(extent={{-840,-800},{-800,-760}}),
      iconTransformation(extent={{-140,-300},{-100,-260}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaChiWatPum
    "Lead pump status setpoint"
    annotation (Placement(transformation(extent={{800,560},{840,600}}),
        iconTransformation(extent={{100,240},{140,280}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiWatPum[nChiWatPum]
  if have_heaChiWatPum
    "Chilled water pump status setpoint"
    annotation(Placement(transformation(extent={{800,500},{840,540}}),
      iconTransformation(extent={{100,210},{140,250}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiPumSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Enabled chilled water pump speed setpoint"
    annotation(Placement(transformation(extent={{800,466},{840,506}}),
      iconTransformation(extent={{100,180},{140,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem[nChi](
    final quantity=fill("ElectricCurrent",nChi),
    final unit=fill("A", nChi))
    "Chiller demand setpoint to set through BACnet or similar "
    annotation(Placement(transformation(extent={{800,400},{840,440}}),
      iconTransformation(extent={{100,150},{140,190}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status setpoint"
    annotation(Placement(transformation(extent={{800,330},{840,370}}),
      iconTransformation(extent={{100,120},{140,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaPreConVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    if have_WSE or (not have_WSE and have_fixSpeConWatPum)
    "Head pressure control valve position"
    annotation (Placement(transformation(extent={{800,160},{840,200}}),
      iconTransformation(extent={{100,90},{140,130}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpe(
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi)) if not have_fixSpeConWatPum
    "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{800,130},{840,170}}),
        iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinFloSet(
    final quantity="VolumeFlowRate",
    final unit="m3/s",
    final min=0) "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{800,100},{840,140}}),
      iconTransformation(extent={{100,32},{140,72}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatPum[nConWatPum]
    "Status setpoint of condenser water pump"
    annotation (Placement(transformation(extent={{800,46},{840,86}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi))
    "Chiller isolation valve position setpoints"
    annotation (Placement(transformation(extent={{800,-20},{840,20}}),
        iconTransformation(extent={{100,-70},{140,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yReaChiDemLim
    "Release chiller demand limit"
    annotation (Placement(transformation(extent={{800,-230},{840,-190}}),
        iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinValPosSet(
    final min=0,
    final max=1,
    final unit="1") "Chilled water minimum flow bypass valve position setpoint"
    annotation (Placement(transformation(extent={{800,-340},{840,-300}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yNumCel
    "Total number of enabled cooling tower cells"
    annotation(Placement(transformation(extent={{800,-560},{840,-520}}),
      iconTransformation(extent={{100,-130},{140,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaCel
    "Lead tower cell status setpoint"
    annotation(Placement(transformation(extent={{800,-600},{840,-560}}),
      iconTransformation(extent={{100,-160},{140,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowCelIsoVal[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel))
    "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{800,-640},{840,-600}}),
      iconTransformation(extent={{100,-190},{140,-150}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowCel[nTowCel]
    "Vector of tower cells status setpoint"
    annotation(Placement(transformation(extent={{800,-680},{840,-640}}),
      iconTransformation(extent={{100,-220},{140,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowFanSpe[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel))
    "Fan speed setpoint of each cooling tower cell"
    annotation (Placement(transformation(extent={{800,-720},{840,-680}}),
      iconTransformation(extent={{100,-250},{140,-210}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMakUp
    "Makeup water valve On-Off status"
    annotation(Placement(transformation(extent={{800,-780},{840,-740}}),
      iconTransformation(extent={{100,-280},{140,-240}})));


  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Controller wseSta(
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
    final wseOnTimInc=wseOnTimInc) if have_WSE
    "Waterside economizer (WSE) enable/disable status"
    annotation(Placement(transformation(extent={{-600,300},{-560,340}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable plaEna(
    final have_WSE=have_WSE,
    final schTab=schTab,
    final TChiLocOut=TChiLocOut,
    final plaThrTim=plaThrTim,
    final reqThrTim=reqThrTim,
    final ignReq=ignReq,
    final locDt=locDt)
    "Sequence to enable and disable plant"
    annotation(Placement(transformation(extent={{-600,-480},{-560,-440}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller
    heaPreCon[nChi](
    final have_fixSpeConWatPum=fill(have_fixSpeConWatPum, nChi),
    final have_heaPreConSig=fill(have_heaPreConSig, nChi),
    final have_WSE=fill(have_WSE, nChi),
    final minTowSpe=fill(fanSpeMin, nChi),
    final minConWatPumSpe=fill(minConWatPumSpe, nChi),
    final minHeaPreValPos=fill(minHeaPreValPos, nChi),
    final controllerType=fill(controllerTypeHeaPre, nChi),
    final minChiLif=fill(minChiLif, nChi),
    final k=fill(kHeaPreCon, nChi),
    final Ti=fill(TiHeaPreCon, nChi)) "Chiller head pressure controller"
    annotation (Placement(transformation(extent={{-420,180},{-380,220}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller minBypValCon(
    final nChi=nChi,
    final minFloSet=minFloSet,
    final controllerType=controllerTypeMinFloByp,
    final k=kMinFloBypCon,
    final Ti=TiMinFloBypCon,
    final Td=TdMinFloBypCon,
    final yMax=yMaxFloBypCon,
    final yMin=yMinFloBypCon)
    "Controller for chilled water minimum flow bypass valve"
    annotation (Placement(transformation(extent={{-580,-160},{-540,-120}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller chiWatPumCon(
    final have_heaPum=have_heaChiWatPum,
    final have_locSen=have_locSenChiWatPum,
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
    final Td=TdChiWatPum)
    "Sequences to control chilled water pumps in primary-only plant system"
    annotation(Placement(transformation(extent={{540,480},{600,540}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset chiWatPlaRes(
    final nPum=nChiWatPum,
    final holTim=holTim,
    final iniSet=iniSet,
    final minSet=minSet,
    final maxSet=maxSet,
    final delTim=delTim,
    final samplePeriod=samplePeriod,
    final numIgnReq=numIgnReq,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes)
    "Sequences to generate chilled water plant reset"
    annotation(Placement(transformation(extent={{-600,-320},{-560,-280}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply chiWatSupSet(
    final nRemDpSen=nSenChiWatPum,
    final dpChiWatPumMin=dpChiWatPumMin,
    final dpChiWatPumMax=dpChiWatPumMax,
    final TChiWatSupMin=TChiWatSupMin_Lowest,
    final TChiWatSupMax=TChiWatSupMax,
    final minSet=minSet,
    final maxSet=maxSet,
    final halSet=halSet)
    "Sequences to generate setpoints of chilled water supply temperature and the pump differential static pressure"
    annotation(Placement(transformation(extent={{-420,420},{-380,460}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController staSetCon(
    final have_WSE=have_WSE,
    final have_serChi=have_serChi,
    final have_locSen=have_locSenChiWatPum,
    final nRemSen=nSenChiWatPum,
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
    final posDisMult=posDisMult,
    final conSpeCenMult=conSpeCenMult,
    final anyOutOfScoMult=anyOutOfScoMult,
    final varSpeStaMin=varSpeStaMin,
    final varSpeStaMax=varSpeStaMax,
    final smallTDif=smallTDif,
    final largeTDif=largeTDif,
    final faiSafTDif=faiSafTDif,
    final dpDif=dpDif,
    final TDif=TDif,
    final TDifHys=hysDt,
    final faiSafDpDif=faiSafDpDif,
    final dpDifHys=dpDifHys,
    final effConSigDif=effConSigDif)
    "Calculates the chiller stage status setpoint signal"
    annotation(Placement(transformation(extent={{-160,-68},{-80,100}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Controller towCon(
    final nChi=nChi,
    final totSta=totSta,
    final nTowCel=nTowCel,
    final nConWatPum=nConWatPum,
    final closeCoupledPlant=closeCoupledPlant,
    final have_WSE=have_WSE,
    final desCap=desCap,
    final fanSpeMin=fanSpeMin,
    final fanSpeMax=fanSpeMax,
    final chiMinCap=chiMinCap,
    final intOpeCon=intOpeCon,
    final kIntOpe=kIntOpeTowFan,
    final TiIntOpe=TiIntOpeTowFan,
    final TdIntOpe=TdIntOpeTowFan,
    final chiWatCon=chiWatConTowFan,
    final kWSE=kWSETowFan,
    final TiWSE=TiWSETowFan,
    final TdWSE=TdWSETowFan,
    final LIFT_min=LIFT_min,
    final TConWatSup_nominal=TConWatSup_nominal,
    final TConWatRet_nominal=TConWatRet_nominal,
    final TChiWatSupMin=TChiWatSupMin,
    final couPlaCon=couPlaCon,
    final kCouPla=kCouPla,
    final TiCouPla=TiCouPla,
    final TdCouPla=TdCouPla,
    final yCouPlaMax=yCouPlaMax,
    final yCouPlaMin=yCouPlaMin,
    final samplePeriod=samplePeriodConTDiff,
    final supWatCon=supWatCon,
    final kSupCon=kSupCon,
    final TiSupCon=TiSupCon,
    final TdSupCon=TdSupCon,
    final ySupConMax=ySupConMax,
    final ySupConMin=ySupConMin,
    final speChe=speChe,
    final iniPlaTim=iniPlaTim,
    final ramTim=ramTim,
    final cheMinFanSpe=cheMinFanSpe,
    final cheMaxTowSpe=cheMaxTowSpe,
    final cheTowOff=cheTowOff,
    final staVec=staVec,
    final towCelOnSet=towCelOnSet,
    final chaTowCelIsoTim=chaTowCelIsoTim,
    final watLevMin=watLevMin,
    final watLevMax=watLevMax)
    "Cooling tower controller"
    annotation(Placement(transformation(extent={{-160,-720},{-80,-560}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down dowProCon(
    final nChi=nChi,
    final nConWatPum=nConWatPum,
    final totSta=totSta,
    final nChiSta=nSta + 1,
    final have_WSE=have_WSE,
    final have_ponyChiller=have_ponyChiller,
    final have_parChi=have_parChi,
    final have_heaConWatPum=have_heaConWatPum,
    final have_fixSpeConWatPum=have_fixSpeConWatPum,
    final chiDemRedFac=chiDemRedFac,
    final holChiDemTim=holChiDemTim,
    final waiTim=waiTim,
    final proOnTim=proOnTim,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final staVec=staVec,
    final desConWatPumSpe=desConWatPumSpe,
    final desConWatPumNum=desConWatPumNum,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet,
    final aftByPasSetTim=aftByPasSetTim,
    final pumSpeChe=speChe,
    final relFloDif=relFloDif,
    final desChiNum=desChiNum)
    "Staging down process controller"
    annotation(Placement(transformation(extent={{280,-300},{360,-140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Up upProCon(
    final nChi=nChi,
    final nConWatPum=nConWatPum,
    final totSta=totSta,
    final nChiSta=nSta + 1,
    final have_WSE=have_WSE,
    final have_ponyChiller=have_ponyChiller,
    final have_parChi=have_parChi,
    final have_heaConWatPum=have_heaConWatPum,
    final have_fixSpeConWatPum=have_fixSpeConWatPum,
    final chiDemRedFac=chiDemRedFac,
    final holChiDemTim=holChiDemTim,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet,
    final aftByPasSetTim=aftByPasSetTim,
    final staVec=staVec,
    final desConWatPumSpe=desConWatPumSpe,
    final desConWatPumNum=desConWatPumNum,
    final thrTimEnb=thrTimEnb,
    final waiTim=waiTim,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final proOnTim=proOnTim,
    final pumSpeChe=speChe,
    final relFloDif=relFloDif,
    final desChiNum=desChiNum)
    "Staging up process controller"
    annotation(Placement(transformation(extent={{280,280},{360,440}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax(
    final nin=nTowCel) if have_WSE
    "All input values are the same"
    annotation(Placement(transformation(extent={{40,-562},{60,-542}})));

  Buildings.Controls.OBC.CDL.Logical.Or chaProUpDown "Either in staging up or in staging down process"
    annotation(Placement(transformation(extent={{480,-90},{500,-70}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler staSam
    "Samples stage index after each staging process is finished"
    annotation(Placement(transformation(extent={{80,-20},{100,0}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    annotation(Placement(transformation(extent={{120,-20},{140,0}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation(Placement(transformation(extent={{0,-20},{20,0}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    annotation(Placement(transformation(extent={{580,-90},{600,-70}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nChiWatPum)
    annotation(Placement(transformation(extent={{-640,-134},{-620,-114}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMax conWatPumSpe(
    final nin=nConWatPum)
    if not have_fixSpeConWatPum
    "Running condenser water pump speed"
    annotation (Placement(transformation(extent={{-560,-400},{-540,-380}})));

  Buildings.Controls.OBC.CDL.Logical.Or staCooTow
    "Tower stage change status: true=stage cooling tower"
    annotation (Placement(transformation(extent={{580,-130},{600,-110}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nChi) if have_WSE
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-480,290},{-460,310}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator conWatRetTem(
    final nout=nChi)
    if not have_heaPreConSig
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-640,230},{-620,250}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator chiWatSupTem(
    final nout=nChi)
    if not have_heaPreConSig
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-640,194},{-620,214}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch desConWatPumSpeSwi
    if not have_fixSpeConWatPum
    "Design condenser water pump speed"
    annotation (Placement(transformation(extent={{580,190},{600,210}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repDesConTem(
    final nout=nChi)
    if not have_fixSpeConWatPum
    "Replicate design condenser water temperature"
    annotation (Placement(transformation(extent={{680,190},{700,210}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(
    final nin=nChi)
    if not have_fixSpeConWatPum
    annotation (Placement(transformation(extent={{-360,150},{-340,170}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch chiMinFloSet "Chiller water minimum flow setpoint"
    annotation (Placement(transformation(extent={{580,110},{600,130}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator uChiSwi(
    final nout=nChi)
    "In chiller stage up process"
    annotation (Placement(transformation(extent={{560,340},{580,360}})));

  Buildings.Controls.OBC.CDL.Logical.Switch uChiStaPro[nChi]
    "Chiller head pressure control status"
    annotation (Placement(transformation(extent={{740,340},{760,360}})));

  Buildings.Controls.OBC.CDL.Logical.Pre heaCon[nChi]
    "Chiller head pressure control"
    annotation (Placement(transformation(extent={{660,270},{680,290}})));

  Buildings.Controls.OBC.CDL.Logical.Pre preConPumLeaSta
    "Lead condenser water pump status from previous step"
    annotation (Placement(transformation(extent={{580,-260},{600,-240}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo equRot if have_heaChiWatPum
    "Rotates two pumps or groups of pumps"
    annotation (Placement(transformation(extent={{360,560},{380,580}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[nChiWatPum](
    final k={1,2}) if have_heaChiWatPum
    "Two pumps or groups of pumps only"
    annotation (Placement(transformation(extent={{420,590},{440,610}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[nChiWatPum](
    final k={2,1}) if have_heaChiWatPum
    "Two pumps or groups of pumps only"
    annotation (Placement(transformation(extent={{420,540},{440,560}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi[2] if have_heaChiWatPum
    "Two devices or groups of devices"
    annotation (Placement(transformation(extent={{480,560},{500,580}})));

  Buildings.Controls.OBC.CDL.Logical.Xor xor[nTowCel]
    "Outputs true when input signals are not the same"
    annotation (Placement(transformation(extent={{-300,-790},{-280,-770}})));

  Buildings.Controls.OBC.CDL.Logical.Latch chiStaUp
    "In chiller stage up process"
    annotation (Placement(transformation(extent={{480,310},{500,330}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    annotation (Placement(transformation(extent={{180,-490},{200,-470}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nChiWatPum] if have_heaChiWatPum
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{680,550},{700,570}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum totChiPum(
    final nin=nChiWatPum) if have_heaChiWatPum
    "Total enabled chilled water pump"
    annotation (Placement(transformation(extent={{720,550},{740,570}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final t=1)
    "Check if more than one pump is enabled, if yes, then it means lag pump is enabled"
    annotation (Placement(transformation(extent={{680,590},{700,610}})));

  Buildings.Controls.OBC.CDL.Logical.Switch chiHeaCon[nChi]
    "Chiller head control enabling status"
    annotation (Placement(transformation(extent={{620,270},{640,290}})));

  Buildings.Controls.OBC.CDL.Integers.Switch conWatPumNum
    "Total number of enablded condenser water pump"
    annotation (Placement(transformation(extent={{540,50},{560,70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo equRot1 if have_heaChiWatPum
    "Rotates two pumps or groups of pumps"
    annotation (Placement(transformation(extent={{640,50},{660,70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch conPumLeaSta
    "Pick the condenser water pump lead status"
    annotation (Placement(transformation(extent={{540,-260},{560,-240}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr1(
    final t=1)
    "Check if more than one pump is enabled, if yes, then it means lag pump is enabled"
    annotation (Placement(transformation(extent={{580,50},{600,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch chiIsoVal[nChi]
    "Chiller isolation valve position setpoint"
    annotation (Placement(transformation(extent={{640,-10},{660,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch chiDem[nChi] "Chiller demand"
    annotation (Placement(transformation(extent={{740,410},{760,430}})));

  Buildings.Controls.OBC.CDL.Logical.Switch relDem
    "Release chiller demand limit"
    annotation (Placement(transformation(extent={{580,-220},{600,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[nTowCel]
    annotation (Placement(transformation(extent={{60,-740},{80,-720}})));

  Buildings.Controls.OBC.CDL.Logical.Pre preChaPro
    "Stage changing process status from previous step"
    annotation (Placement(transformation(extent={{540,-90},{560,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Pre leaChiPumPre
    "Lead chilled water pump status previous value"
    annotation (Placement(transformation(extent={{620,590},{640,610}})));

  Buildings.Controls.OBC.CDL.Logical.Pre leaChiWatPum[nChiWatPum]
    "Chilled water pump status previous value"
    annotation (Placement(transformation(extent={{640,550},{660,570}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(
    final samplePeriod=1)      "Zero order hold"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

protected
  final parameter Boolean have_serChi = not have_parChi
    "true = series chillers plant; false = parallel chillers plant"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  final parameter Real TChiWatSupMin_Lowest(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=min(TChiWatSupMin)
    "Minimum chilled water supply temperature. This is the lowest minimum chilled water supply temperature of chillers in the plant";

equation
  connect(staSetCon.uPla, plaEna.yPla) annotation(Line(points={{-168,72},{-480,72},
          {-480,-460},{-558,-460}},            color={255,0,255}));
  connect(TChiWatRetDow, wseSta.TChiWatRetDow) annotation(Line(points={{-820,320},
          {-604,320}},                            color={0,0,127}));
  connect(chiWatSupResReq, plaEna.chiWatSupResReq) annotation(Line(points={{-820,
          -300},{-640,-300},{-640,-452},{-604,-452}},      color={255,127,0}));
  connect(chiWatSupSet.TChiWatSupSet, staSetCon.TChiWatSupSet) annotation(Line(
        points={{-376,428},{-280,428},{-280,48},{-168,48}},     color={0,0,127}));
  connect(TChiWatSup, staSetCon.TChiWatSup) annotation(Line(points={{-820,210},
          {-740,210},{-740,40},{-168,40}},       color={0,0,127}));
  connect(VChiWat_flow, minBypValCon.VChiWat_flow) annotation(Line(points={{-820,
          440},{-780,440},{-780,-140},{-584,-140}},    color={0,0,127}));
  connect(TChiWatRet, staSetCon.TChiWatRet) annotation(Line(points={{-820,280},
          {-760,280},{-760,-48},{-168,-48}},                           color={0,
          0,127}));
  connect(staSetCon.TWsePre, wseSta.TWsePre) annotation(Line(points={{-168,-56},
          {-320,-56},{-320,320},{-556,320}},
        color={0,0,127}));
  connect(VChiWat_flow, staSetCon.VChiWat_flow) annotation(Line(points={{-820,
          440},{-780,440},{-780,-64},{-168,-64}},
        color={0,0,127}));
  connect(chiWatSupResReq, chiWatPlaRes.TChiWatSupResReq) annotation(Line(
        points={{-820,-300},{-604,-300}},                         color={255,
          127,0}));
  connect(chiWatPlaRes.yChiWatPlaRes, chiWatSupSet.uChiWatPlaRes) annotation (
      Line(points={{-556,-300},{-440,-300},{-440,440},{-424,440}}, color={0,0,127}));
  connect(uChi, towCon.uChi) annotation(Line(points={{-820,400},{-700,400},{
          -700,-572},{-168,-572}},      color={255,0,255}));
  connect(wseSta.y, staSetCon.uWseSta) annotation(Line(points={{-556,336},{-530,
          336},{-530,96},{-168,96}},            color={255,0,255}));
  connect(wseSta.y, towCon.uWse) annotation(Line(points={{-556,336},{-530,336},{
          -530,-580},{-168,-580}},      color={255,0,255}));
  connect(plaEna.yPla, towCon.uPla) annotation(Line(points={{-558,-460},{-480,-460},
          {-480,-636},{-168,-636}},           color={255,0,255}));
  connect(TOutWet, staSetCon.TOutWet) annotation(Line(points={{-820,360},{-770,
          360},{-770,-20},{-168,-20}},                 color={0,0,127}));
  connect(mulMax.y, staSetCon.uTowFanSpeMax) annotation(Line(points={{62,-552},
          {100,-552},{100,-360},{-680,-360},{-680,-36},{-168,-36}},
        color={0,0,127}));
  connect(staSetCon.ySta, upProCon.uStaSet) annotation(Line(points={{-72,-24},{-40,
          -24},{-40,436},{272,436}},                      color={255,127,0}));
  connect(staSetCon.ySta, dowProCon.uStaSet) annotation(Line(points={{-72,-24},{
          -40,-24},{-40,-144},{272,-144}},                color={255,127,0}));
  connect(staSetCon.yChiSet, upProCon.uChiSet) annotation(Line(points={{-72,4},
          {-30,4},{-30,424},{272,424}},
        color={255,0,255}));
  connect(staSetCon.yChiSet, dowProCon.uChiSet) annotation(Line(points={{-72,4},
          {-30,4},{-30,-152},{272,-152}},                   color={255,0,255}));
  connect(uChiLoa, upProCon.uChiLoa) annotation(Line(points={{-820,140},{-730,
          140},{-730,408},{272,408}},                        color={0,0,127}));
  connect(upProCon.yStaPro, chaProUpDown.u1) annotation(Line(points={{368,436},{
          430,436},{430,-80},{478,-80}},           color={255,0,255}));
  connect(dowProCon.yStaPro, chaProUpDown.u2) annotation(Line(points={{368,-144},
          {440,-144},{440,-88},{478,-88}},       color={255,0,255}));
  connect(uChi, dowProCon.uChi) annotation(Line(points={{-820,400},{-700,400},{-700,
          -184},{272,-184}},
        color={255,0,255}));
  connect(staSam.y, reaToInt1.u)
    annotation(Line(points={{102,-10},{118,-10}}, color={0,0,127}));
  connect(staSetCon.ySta, intToRea.u) annotation(Line(points={{-72,-24},{-40,-24},
          {-40,-10},{-2,-10}}, color={255,127,0}));
  connect(reaToInt1.y, dowProCon.uChiSta) annotation(Line(points={{142,-10},{160,
          -10},{160,-204},{272,-204}},   color={255,127,0}));
  connect(reaToInt1.y, staSetCon.uSta) annotation(Line(points={{142,-10},{160,
          -10},{160,-208},{-360,-208},{-360,60},{-168,60}}, color={255,127,0}));
  connect(mulMax.y, wseSta.uTowFanSpeMax) annotation(Line(points={{62,-552},{100,
          -552},{100,-360},{-680,-360},{-680,304},{-604,304}}, color={0,0,127}));
  connect(towCon.yNumCel, yNumCel) annotation(Line(points={{-72,-572},{770,-572},
          {770,-540},{820,-540}}, color={255,127,0}));
  connect(towCon.yIsoVal, yTowCelIsoVal)
    annotation (Line(points={{-72,-620},{820,-620}}, color={0,0,127}));
  connect(towCon.ySpeSet, yTowFanSpe) annotation (Line(points={{-72,-684},{0,-684},
          {0,-700},{820,-700}}, color={0,0,127}));
  connect(towCon.yLeaCel, yLeaCel) annotation(Line(points={{-72,-596},{780,-596},
          {780,-580},{820,-580}},            color={255,0,255}));
  connect(towCon.yTowSta,yTowCel)  annotation(Line(points={{-72,-660},{820,-660}},
                                             color={255,0,255}));
  connect(towCon.yMakUp, yMakUp) annotation(Line(points={{-72,-708},{-40,-708},
          {-40,-760},{820,-760}},        color={255,0,255}));
  connect(uChiWatPum, chiWatPlaRes.uChiWatPum) annotation(Line(points={{-820,564},
          {-690,564},{-690,-288},{-604,-288}},
        color={255,0,255}));
  connect(mulOr.y, minBypValCon.uChiWatPum) annotation(Line(points={{-618,-124},
          {-584,-124}},                         color={255,0,255}));
  connect(uChiWatPum, mulOr.u) annotation(Line(points={{-820,564},{-690,564},{-690,
          -124},{-642,-124}},     color={255,0,255}));
  connect(staSetCon.yOpeParLoaRatMin, dowProCon.yOpeParLoaRatMin) annotation (
      Line(points={{-72,-52.8},{-50,-52.8},{-50,-164},{272,-164}},       color=
          {0,0,127}));
  connect(uChi, upProCon.uChi) annotation(Line(points={{-820,400},{272,400}},
                          color={255,0,255}));
  connect(wseSta.y, upProCon.uWSE) annotation(Line(points={{-556,336},{-530,336},
          {-530,340},{272,340}}, color={255,0,255}));
  connect(wseSta.y, dowProCon.uWSE) annotation(Line(points={{-556,336},{-530,336},
          {-530,-272},{272,-272}},     color={255,0,255}));
  connect(dowProCon.VChiWat_flow, VChiWat_flow) annotation(Line(points={{272,-192},
          {-780,-192},{-780,440},{-820,440}},color={0,0,127}));
  connect(uChiIsoVal, chiWatPumCon.uChiIsoVal) annotation(Line(points={{-820,540},
          {-144,540},{-144,504},{534,504}}, color={255,0,255}));
  connect(VChiWat_flow, chiWatPumCon.VChiWat_flow) annotation(Line(points={{-820,
          440},{-780,440},{-780,498},{534,498}},color={0,0,127}));
  connect(dpChiWat_remote, chiWatPumCon.dpChiWat_remote) annotation(Line(
        points={{-820,470},{-670,470},{-670,486},{534,486}},  color={0,0,127}));
  connect(TChiWatSup, towCon.TChiWatSup) annotation(Line(points={{-820,210},{
          -740,210},{-740,-596},{-168,-596}},color={0,0,127}));
  connect(chiWatSupSet.TChiWatSupSet, towCon.TChiWatSupSet) annotation(Line(
        points={{-376,428},{-280,428},{-280,-604},{-168,-604}},color={0,0,127}));
  connect(dowProCon.uChiLoa, uChiLoa) annotation(Line(points={{272,-172},{-730,-172},
          {-730,140},{-820,140}},color={0,0,127}));
  connect(dowProCon.uChiWatIsoVal, uChiWatIsoVal) annotation(Line(points={{272,-228},
          {-820,-228}},                        color={0,0,127}));
  connect(uChiWatIsoVal, upProCon.uChiWatIsoVal) annotation(Line(points={{-820,-228},
          {210,-228},{210,292},{272,292}},   color={0,0,127}));
  connect(yChiWatPum, chiWatPumCon.yChiWatPum) annotation(Line(points={{820,520},
          {630,520},{630,510},{606,510}},color={255,0,
          255}));
  connect(chiWatPumCon.yPumSpe, yChiPumSpe) annotation(Line(points={{606,492},{714,
          492},{714,486},{820,486}},      color={0,0,127}));
  connect(chiWatSupSet.dpChiWatPumSet, chiWatPumCon.dpChiWatSet_remote)
    annotation (Line(points={{-376,452},{-270,452},{-270,480},{534,480}}, color=
         {0,0,127}));
  connect(uChiAva, staSetCon.uChiAva) annotation(Line(points={{-820,80},{-168,
          80}},                                        color={255,0,255}));
  connect(minBypValCon.yValPos, yMinValPosSet) annotation (Line(points={{-536,-140},
          {-380,-140},{-380,-320},{820,-320}}, color={0,0,127}));
  connect(staSetCon.ySta, towCon.uChiStaSet) annotation(Line(points={{-72,-24},{
          -40,-24},{-40,-120},{-230,-120},{-230,-676},{-168,-676}},
        color={255,127,0}));
  connect(TConWatSup, towCon.TConWatSup) annotation(Line(points={{-820,-660},{
          -168,-660}},                            color={0,0,127}));
  connect(TConWatRet, towCon.TConWatRet) annotation(Line(points={{-820,240},{
          -750,240},{-750,-644},{-168,-644}},    color={0,0,127}));
  connect(watLev, towCon.watLev) annotation (Line(points={{-820,-740},{-200,
          -740},{-200,-716},{-168,-716}},
                                    color={0,0,127}));
  connect(towCon.uIsoVal, uIsoVal) annotation(Line(points={{-168,-708},{-820,
          -708}},                            color={0,0,127}));
  connect(uTowSta, towCon.uTowSta) annotation (Line(points={{-820,-780},{-340,
          -780},{-340,-628},{-168,-628}},color={255,0,255}));
  connect(uConWatPumSpe, conWatPumSpe.u) annotation (Line(points={{-820,-390},{
          -562,-390}},                         color={0,0,127}));
  connect(uConWatPumSpe, towCon.uConWatPumSpe) annotation (Line(points={{-820,
          -390},{-720,-390},{-720,-652},{-168,-652}}, color={0,0,127}));
  connect(conWatPumSpe.y, dowProCon.uConWatPumSpe) annotation (Line(points={{-538,
          -390},{230,-390},{230,-288},{272,-288}},      color={0,0,127}));
  connect(conWatPumSpe.y, upProCon.uConWatPumSpe) annotation (Line(points={{-538,
          -390},{230,-390},{230,320},{272,320}},      color={0,0,127}));
  connect(wseSta.yTunPar, staSetCon.uTunPar) annotation (Line(points={{-556,304},
          {-540,304},{-540,-28},{-168,-28}},         color={0,0,127}));
  connect(TChiWatRet, wseSta.TChiWatRet) annotation (Line(points={{-820,280},{-760,
          280},{-760,328},{-604,328}},     color={0,0,127}));
  connect(reaToInt1.y, upProCon.uChiSta) annotation (Line(points={{142,-10},{
          160,-10},{160,368},{272,368}},
                                     color={255,127,0}));
  connect(reaToInt1.y, towCon.uChiSta) annotation (Line(points={{142,-10},{160,
          -10},{160,-208},{-240,-208},{-240,-668},{-168,-668}},
                                                           color={255,127,0}));
  connect(upProCon.yTowStaUp, staCooTow.u1) annotation (Line(points={{368,388},
          {410,388},{410,-120},{578,-120}},
                                         color={255,0,255}));
  connect(dowProCon.yTowStaDow, staCooTow.u2) annotation (Line(points={{368,
          -220},{480,-220},{480,-128},{578,-128}},
                                         color={255,0,255}));
  connect(TOut, plaEna.TOut) annotation (Line(points={{-820,-480},{-640,-480},{-640,
          -468.4},{-604,-468.4}}, color={0,0,127}));
  connect(towCon.uFanSpe, uFanSpe)
    annotation (Line(points={{-168,-588},{-820,-588}}, color={0,0,127}));
  connect(uChiConIsoVal, dowProCon.uChiConIsoVal) annotation (Line(points={{-820,
          664},{200,664},{200,-260},{272,-260}}, color={255,0,255}));
  connect(uChiConIsoVal, upProCon.uChiConIsoVal) annotation (Line(points={{-820,
          664},{200,664},{200,380},{272,380}}, color={255,0,255}));
  connect(upProCon.uConWatReq, uConWatReq) annotation (Line(points={{272,352},{180,
          352},{180,604},{-820,604}}, color={255,0,255}));
  connect(upProCon.uChiWatReq, uChiWatReq) annotation (Line(points={{272,284},{190,
          284},{190,634},{-820,634}}, color={255,0,255}));
  connect(uChiWatReq, dowProCon.uChiWatReq) annotation (Line(points={{-820,634},
          {190,634},{190,-240},{272,-240}}, color={255,0,255}));
  connect(uConWatReq, dowProCon.uConWatReq) annotation (Line(points={{-820,604},
          {180,604},{180,-248},{272,-248}}, color={255,0,255}));
  connect(VChiWat_flow, upProCon.VChiWat_flow) annotation (Line(points={{-820,
          440},{-780,440},{-780,390.4},{272,390.4}},
                                                color={0,0,127}));
  connect(heaCon.y,heaPreCon.uChiHeaCon)  annotation (Line(points={{682,280},{
          710,280},{710,260},{-460,260},{-460,220},{-424,220}}, color={255,0,
          255}));
  connect(wseSta.y, booRep.u) annotation (Line(points={{-556,336},{-530,336},{-530,
          300},{-482,300}},      color={255,0,255}));
  connect(booRep.y, heaPreCon.uWSE) annotation (Line(points={{-458,300},{-450,
          300},{-450,188},{-424,188}}, color={255,0,255}));
  connect(TConWatRet, conWatRetTem.u) annotation (Line(points={{-820,240},{-642,
          240}},                       color={0,0,127}));
  connect(conWatRetTem.y, heaPreCon.TConWatRet) annotation (Line(points={{-618,
          240},{-580,240},{-580,212},{-424,212}}, color={0,0,127}));
  connect(TChiWatSup, chiWatSupTem.u) annotation (Line(points={{-820,210},{-740,
          210},{-740,204},{-642,204}}, color={0,0,127}));
  connect(chiWatSupTem.y, heaPreCon.TChiWatSup) annotation (Line(points={{-618,
          204},{-424,204}},                       color={0,0,127}));
  connect(falEdg.y, staSam.trigger) annotation (Line(points={{602,-80},{690,-80},
          {690,-40},{90,-40},{90,-21.8}}, color={255,0,255}));
  connect(upProCon.yDesConWatPumSpe, desConWatPumSpeSwi.u1) annotation (Line(
        points={{368,356},{460,356},{460,208},{578,208}}, color={0,0,127}));
  connect(dowProCon.yDesConWatPumSpe, desConWatPumSpeSwi.u3) annotation (Line(
        points={{368,-264},{460,-264},{460,192},{578,192}}, color={0,0,127}));
  connect(repDesConTem.y, heaPreCon.desConWatPumSpe) annotation (Line(points={{702,200},
          {740,200},{740,240},{-432,240},{-432,196},{-424,196}},          color=
         {0,0,127}));
  connect(heaPreCon.uHeaPreCon, uHeaPreCon) annotation (Line(points={{-424,180},
          {-820,180}},                       color={0,0,127}));
  connect(heaPreCon.yMaxTowSpeSet, towCon.uMaxTowSpeSet) annotation (Line(
        points={{-376,212},{-260,212},{-260,-620},{-168,-620}}, color={0,0,127}));
  connect(heaPreCon.yHeaPreConVal, yHeaPreConVal) annotation (Line(points={{-376,
          200},{-60,200},{-60,180},{820,180}},      color={0,0,127}));
  connect(heaPreCon.yConWatPumSpeSet, mulMin.u) annotation (Line(points={{-376,
          188},{-370,188},{-370,160},{-362,160}}, color={0,0,127}));
  connect(mulMin.y, dowProCon.uConWatPumSpeSet) annotation (Line(points={{-338,160},
          {-300,160},{-300,-280},{272,-280}},      color={0,0,127}));
  connect(mulMin.y, upProCon.uConWatPumSpeSet) annotation (Line(points={{-338,
          160},{-300,160},{-300,328},{272,328}}, color={0,0,127}));
  connect(upProCon.yChiWatMinFloSet, chiMinFloSet.u1) annotation (Line(points={{368,404},
          {450,404},{450,128},{578,128}},           color={0,0,127}));
  connect(dowProCon.yChiWatMinFloSet, chiMinFloSet.u3) annotation (Line(points={{368,
          -296},{450,-296},{450,112},{578,112}},       color={0,0,127}));
  connect(chiMinFloSet.y, minBypValCon.VChiWatSet_flow) annotation (Line(points={{602,120},
          {700,120},{700,-100},{-600,-100},{-600,-156},{-584,-156}},
        color={0,0,127}));
  connect(heaCon.y, upProCon.uChiHeaCon) annotation (Line(points={{682,280},{
          710,280},{710,260},{220,260},{220,300},{272,300}}, color={255,0,255}));
  connect(heaCon.y, dowProCon.uChiHeaCon) annotation (Line(points={{682,280},{710,
          280},{710,260},{220,260},{220,-216},{272,-216}},     color={255,0,255}));
  connect(uChiStaPro.y, yChi) annotation (Line(points={{762,350},{820,350}},
                           color={255,0,255}));
  connect(uChiSwi.y, uChiStaPro.u2)
    annotation (Line(points={{582,350},{738,350}}, color={255,0,255}));
  connect(upProCon.yChi, uChiStaPro.u1) annotation (Line(points={{368,284},{400,
          284},{400,380},{720,380},{720,358},{738,358}}, color={255,0,255}));
  connect(dowProCon.yChi, uChiStaPro.u3) annotation (Line(points={{368,-172},{
          720,-172},{720,342},{738,342}},
                                      color={255,0,255}));
  connect(staSetCon.yCapReq, towCon.reqPlaCap) annotation (Line(points={{-72,-64},
          {-60,-64},{-60,-460},{-270,-460},{-270,-612},{-168,-612}},      color=
         {0,0,127}));
  connect(preConPumLeaSta.y, towCon.uLeaConWatPum) annotation (Line(points={{602,
          -250},{660,-250},{660,-520},{-210,-520},{-210,-692},{-168,-692}},
        color={255,0,255}));
  connect(chiWatPumCon.yLea, yLeaChiWatPum) annotation (Line(points={{606,534},
          {760,534},{760,580},{820,580}}, color={255,0,255}));
  connect(equRot.yDevRol, intSwi.u2) annotation (Line(points={{382,564},{410,
          564},{410,570},{478,570}}, color={255,0,255}));
  connect(conInt1.y, intSwi.u1) annotation (Line(points={{442,600},{460,600},{
          460,578},{478,578}}, color={255,127,0}));
  connect(conInt2.y, intSwi.u3) annotation (Line(points={{442,550},{460,550},{
          460,562},{478,562}}, color={255,127,0}));
  connect(intSwi.y, chiWatPumCon.uPumLeaLag) annotation (Line(points={{502,570},
          {520,570},{520,540},{534,540}}, color={255,127,0}));
  connect(uChiWatPum, equRot.uDevSta) annotation (Line(points={{-820,564},{358,564}},
                                      color={255,0,255}));
  connect(equRot.yDevStaSet, chiWatPumCon.uChiWatPum) annotation (Line(points={
          {382,576},{390,576},{390,528},{534,528},{534,528}}, color={255,0,255}));
  connect(uTowSta, xor.u1) annotation (Line(points={{-820,-780},{-302,-780}},
                              color={255,0,255}));
  connect(xor.y, towCon.uChaCel) annotation (Line(points={{-278,-780},{-240,
          -780},{-240,-700},{-168,-700}}, color={255,0,255}));
  connect(chiStaUp.y, chiMinFloSet.u2) annotation (Line(points={{502,320},{520,320},
          {520,120},{578,120}},      color={255,0,255}));
  connect(upProCon.yStaPro, chiStaUp.u) annotation (Line(points={{368,436},{430,
          436},{430,320},{478,320}}, color={255,0,255}));
  connect(dowProCon.yStaPro, chiStaUp.clr) annotation (Line(points={{368,-144},
          {440,-144},{440,314},{478,314}}, color={255,0,255}));

  connect(VChiWat_flow, wseSta.VChiWat_flow) annotation (Line(points={{-820,440},
          {-780,440},{-780,312},{-604,312}}, color={0,0,127}));
  connect(TOutWet, wseSta.TOutWet) annotation (Line(points={{-820,360},{-770,360},
          {-770,336},{-604,336}},      color={0,0,127}));
  connect(pre2.y, towCon.uTowStaCha) annotation (Line(points={{202,-480},{220,
          -480},{220,-500},{-220,-500},{-220,-684},{-168,-684}},
                                          color={255,0,255}));
  connect(staCooTow.y, pre2.u) annotation (Line(points={{602,-120},{690,-120},{
          690,-460},{160,-460},{160,-480},{178,-480}}, color={255,0,255}));
  connect(towCon.ySpeSet, mulMax.u) annotation (Line(points={{-72,-684},{0,-684},
          {0,-552},{38,-552}}, color={0,0,127}));
  connect(booToInt.y, totChiPum.u)
    annotation (Line(points={{702,560},{718,560}}, color={255,127,0}));
  connect(chiStaUp.y, desConWatPumSpeSwi.u2) annotation (Line(points={{502,320},
          {520,320},{520,200},{578,200}}, color={255,0,255}));
  connect(chiStaUp.y, uChiSwi.u) annotation (Line(points={{502,320},{520,320},{
          520,350},{558,350}}, color={255,0,255}));
  connect(upProCon.yChiHeaCon, chiHeaCon.u1) annotation (Line(points={{368,324},
          {420,324},{420,288},{618,288}}, color={255,0,255}));
  connect(uChiSwi.y, chiHeaCon.u2) annotation (Line(points={{582,350},{610,350},
          {610,280},{618,280}}, color={255,0,255}));
  connect(chiHeaCon.y, heaCon.u)
    annotation (Line(points={{642,280},{658,280}}, color={255,0,255}));
  connect(dowProCon.yChiHeaCon, chiHeaCon.u3) annotation (Line(points={{368,
          -232},{420,-232},{420,272},{618,272}}, color={255,0,255}));
  connect(chiStaUp.y, conWatPumNum.u2) annotation (Line(points={{502,320},{520,320},
          {520,60},{538,60}},      color={255,0,255}));
  connect(upProCon.yConWatPumNum, conWatPumNum.u1) annotation (Line(points={{368,340},
          {470,340},{470,68},{538,68}},          color={255,127,0}));
  connect(dowProCon.yConWatPumNum, conWatPumNum.u3) annotation (Line(points={{368,
          -280},{470,-280},{470,52},{538,52}},     color={255,127,0}));
  connect(chiStaUp.y, conPumLeaSta.u2) annotation (Line(points={{502,320},{520,
          320},{520,-250},{538,-250}}, color={255,0,255}));
  connect(dowProCon.yLeaPum, conPumLeaSta.u3) annotation (Line(points={{368,
          -248},{480,-248},{480,-258},{538,-258}}, color={255,0,255}));
  connect(upProCon.yLeaPum, conPumLeaSta.u1) annotation (Line(points={{368,372},
          {390,372},{390,-242},{538,-242}}, color={255,0,255}));
  connect(conPumLeaSta.y, preConPumLeaSta.u)
    annotation (Line(points={{562,-250},{578,-250}}, color={255,0,255}));
  connect(conWatPumNum.y, intGreThr1.u)
    annotation (Line(points={{562,60},{578,60}}, color={255,127,0}));
  connect(intGreThr1.y, equRot1.uLagStaSet)
    annotation (Line(points={{602,60},{638,60}}, color={255,0,255}));
  connect(preConPumLeaSta.y, equRot1.uLeaStaSet) annotation (Line(points={{602,-250},
          {620,-250},{620,66},{638,66}},       color={255,0,255}));
  connect(uConWatPum, equRot1.uDevSta) annotation (Line(points={{-820,-420},{630,
          -420},{630,54},{638,54}},     color={255,0,255}));
  connect(equRot1.yDevStaSet, yConWatPum)
    annotation (Line(points={{662,66},{820,66}}, color={255,0,255}));
  connect(desConWatPumSpeSwi.y, yConWatPumSpe) annotation (Line(points={{602,200},
          {620,200},{620,150},{820,150}},      color={0,0,127}));
  connect(chiMinFloSet.y, yChiWatMinFloSet)
    annotation (Line(points={{602,120},{820,120}}, color={0,0,127}));
  connect(uChiSwi.y, chiIsoVal.u2) annotation (Line(points={{582,350},{610,350},
          {610,0},{638,0}}, color={255,0,255}));
  connect(upProCon.yChiWatIsoVal, chiIsoVal.u1) annotation (Line(points={{368,304},
          {380,304},{380,8},{638,8}}, color={0,0,127}));
  connect(dowProCon.yChiWatIsoVal, chiIsoVal.u3) annotation (Line(points={{368,-204},
          {380,-204},{380,-8},{638,-8}}, color={0,0,127}));
  connect(chiIsoVal.y, yChiWatIsoVal)
    annotation (Line(points={{662,0},{820,0}}, color={0,0,127}));
  connect(uChiCooLoa, towCon.chiLoa) annotation (Line(points={{-820,-540},{-290,
          -540},{-290,-564},{-168,-564}}, color={0,0,127}));
  connect(uChiSwi.y, chiDem.u2) annotation (Line(points={{582,350},{610,350},{
          610,420},{738,420}}, color={255,0,255}));
  connect(upProCon.yChiDem, chiDem.u1) annotation (Line(points={{368,420},{530,
          420},{530,428},{738,428}}, color={0,0,127}));
  connect(dowProCon.yChiDem, chiDem.u3) annotation (Line(points={{368,-160},{
          530,-160},{530,412},{738,412}}, color={0,0,127}));
  connect(chiDem.y, yChiDem)
    annotation (Line(points={{762,420},{820,420}}, color={0,0,127}));
  connect(uConWatPum, upProCon.uConWatPum) annotation (Line(points={{-820,-420},
          {240,-420},{240,312},{272,312}}, color={255,0,255}));
  connect(uConWatPum, dowProCon.uConWatPum) annotation (Line(points={{-820,-420},
          {240,-420},{240,-296},{272,-296}}, color={255,0,255}));
  connect(desConWatPumSpeSwi.y, repDesConTem.u)
    annotation (Line(points={{602,200},{678,200}}, color={0,0,127}));
  connect(dowProCon.yReaDemLim, relDem.u3) annotation (Line(points={{368,-188},{
          490,-188},{490,-218},{578,-218}}, color={255,0,255}));
  connect(upProCon.yStaPro, relDem.u1) annotation (Line(points={{368,436},{430,436},
          {430,-202},{578,-202}}, color={255,0,255}));
  connect(chiStaUp.y, relDem.u2) annotation (Line(points={{502,320},{520,320},{520,
          -210},{578,-210}}, color={255,0,255}));
  connect(relDem.y, yReaChiDemLim)
    annotation (Line(points={{602,-210},{820,-210}}, color={255,0,255}));
  connect(dpChiWat_local, chiWatPumCon.dpChiWat_local) annotation (Line(points={{-820,
          510},{-720,510},{-720,492},{534,492}},       color={0,0,127}));
  connect(dpChiWat_local, staSetCon.dpChiWatPum_local) annotation (Line(points={
          {-820,510},{-720,510},{-720,4},{-168,4}}, color={0,0,127}));
  connect(chiWatPumCon.dpChiWatPumSet_local, staSetCon.dpChiWatPumSet_local)
    annotation (Line(points={{606,483},{620,483},{620,460},{-250,460},{-250,12},
          {-168,12}}, color={0,0,127}));
  connect(chiWatSupSet.dpChiWatPumSet, staSetCon.dpChiWatPumSet_remote)
    annotation (Line(points={{-376,452},{-270,452},{-270,-4},{-168,-4}}, color={
          0,0,127}));
  connect(dpChiWat_remote, staSetCon.dpChiWatPum_remote) annotation (Line(
        points={{-820,470},{-670,470},{-670,-12},{-168,-12}}, color={0,0,127}));
  connect(towCon.yTowSta, pre1.u) annotation (Line(points={{-72,-660},{-20,-660},
          {-20,-730},{58,-730}}, color={255,0,255}));
  connect(pre1.y, xor.u2) annotation (Line(points={{82,-730},{100,-730},{100,-800},
          {-320,-800},{-320,-788},{-302,-788}}, color={255,0,255}));
  connect(falEdg.u, preChaPro.y)
    annotation (Line(points={{578,-80},{562,-80}}, color={255,0,255}));
  connect(chaProUpDown.y, preChaPro.u)
    annotation (Line(points={{502,-80},{538,-80}}, color={255,0,255}));
  connect(preChaPro.y, chiWatPlaRes.chaPro) annotation (Line(points={{562,-80},{
          570,-80},{570,-330},{-620,-330},{-620,-312},{-604,-312}}, color={255,0,
          255}));
  connect(preChaPro.y, staSetCon.chaPro) annotation (Line(points={{562,-80},{570,
          -80},{570,-330},{-220,-330},{-220,88},{-168,88}}, color={255,0,255}));
  connect(staSam.u, zerOrdHol.y)
    annotation (Line(points={{78,-10},{62,-10}}, color={0,0,127}));
  connect(zerOrdHol.u, intToRea.y)
    annotation (Line(points={{38,-10},{22,-10}}, color={0,0,127}));
  connect(leaChiWatPum.y, booToInt.u)
    annotation (Line(points={{662,560},{678,560}}, color={255,0,255}));
  connect(chiWatPumCon.yChiWatPum, leaChiWatPum.u) annotation (Line(points={{606,
          510},{630,510},{630,560},{638,560}}, color={255,0,255}));
  connect(totChiPum.y, intGreThr.u) annotation (Line(points={{742,560},{750,560},
          {750,580},{670,580},{670,600},{678,600}}, color={255,127,0}));
  connect(intGreThr.y, equRot.uLagStaSet) annotation (Line(points={{702,600},{710,
          600},{710,640},{340,640},{340,570},{358,570}}, color={255,0,255}));
  connect(chiWatPumCon.yLea, leaChiPumPre.u) annotation (Line(points={{606,534},
          {610,534},{610,600},{618,600}}, color={255,0,255}));
  connect(leaChiPumPre.y, equRot.uLeaStaSet) annotation (Line(points={{642,600},
          {650,600},{650,630},{350,630},{350,576},{358,576}}, color={255,0,255}));
annotation (
    defaultComponentName="chiPlaCon",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-300},{100,300}}),
        graphics={
        Rectangle(
          extent={{-100,-300},{100,300}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-100,340},{100,300}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-50,160},{50,-162}},
          lineColor={28,108,200},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Polygon(
          points={{-50,160},{16,4},{-50,-162},{-50,160}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,288},{-50,274}},
          lineColor={255,0,255},
          textString="uChiConIsoVal"),
        Text(
          extent={{-98,266},{-58,254}},
          lineColor={255,0,255},
          textString="uChiWatReq"),
        Text(
          extent={{-100,226},{-56,216}},
          lineColor={255,0,255},
          textString="uChiWatPum"),
        Text(
          extent={{-98,246},{-56,234}},
          lineColor={255,0,255},
          textString="uConWatReq"),
        Text(
          extent={{-100,206},{-62,196}},
          lineColor={255,0,255},
          textString="uChiIsoVal",
          visible=have_heaChiWatPum),
        Text(
          extent={{-98,168},{-50,154}},
          lineColor={0,0,127},
          textString="dpChiWat_remote"),
        Text(
          extent={{-100,148},{-58,136}},
          lineColor={0,0,127},
          textString="VChiWat_flow"),
        Text(
          extent={{-98,126},{-80,114}},
          lineColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{-100,106},{-68,96}},
          lineColor={0,0,127},
          textString="TOutWet",
          visible=have_WSE),
        Text(
          extent={{-98,88},{-50,74}},
          lineColor={0,0,125},
          textString="TChiWatRetDow",
          visible=have_WSE),
        Text(
          extent={{-100,66},{-60,56}},
          lineColor={0,0,127},
          textString="TChiWatRet"),
        Text(
          extent={{-100,48},{-60,32}},
          lineColor={0,0,127},
          textString="TConWatRet",
          visible=not have_heaPreConSig),
        Text(
          extent={{-98,26},{-58,14}},
          lineColor={0,0,127},
          textString="TChiWatSup",
          visible=(not have_heaPreConSig) or have_WSE),
        Text(
          extent={{-98,8},{-60,-6}},
          lineColor={0,0,127},
          textString="uHeaPreCon",
          visible=have_heaPreConSig),
        Text(
          extent={{-98,-14},{-66,-26}},
          lineColor={0,0,127},
          textString="uChiLoa"),
        Text(
          extent={{-100,-34},{-64,-46}},
          lineColor={255,0,255},
          textString="uChiAva"),
        Text(
          extent={{-98,-72},{-50,-86}},
          lineColor={0,0,127},
          textString="uChiWatIsoVal"),
        Text(
          extent={{-98,-92},{-50,-106}},
          lineColor={255,127,0},
          textString="chiWatSupResReq"),
        Text(
          extent={{-98,-112},{-50,-126}},
          lineColor={0,0,127},
          textString="uConWatPumSpe"),
        Text(
          extent={{-98,-132},{-50,-146}},
          lineColor={255,0,255},
          textString="uConWatPum"),
        Text(
          extent={{-98,-152},{-78,-166}},
          lineColor={0,0,127},
          textString="TOut"),
        Text(
          extent={{-98,-172},{-50,-186}},
          lineColor={0,0,127},
          textString="uChiCooLoa",
          visible=have_WSE),
        Text(
          extent={{-96,-194},{-64,-206}},
          lineColor={0,0,127},
          textString="uFanSpe"),
        Text(
          extent={{-98,-214},{-50,-228}},
          lineColor={0,0,127},
          textString="TConWatSup",
          visible=not closeCoupledPlant),
        Text(
          extent={{-100,-234},{-68,-246}},
          lineColor={0,0,127},
          textString="uIsoVal"),
        Text(
          extent={{-98,-252},{-68,-264}},
          lineColor={0,0,127},
          textString="watLev"),
        Text(
          extent={{-98,-272},{-62,-286}},
          lineColor={255,0,255},
          textString="uTowSta"),
        Text(
          extent={{50,266},{98,252}},
          lineColor={255,0,255},
          textString="yLeaChiWatPum"),
        Text(
          extent={{50,238},{98,224}},
          lineColor={255,0,255},
          textString="yChiWatPum",
          visible=have_heaChiWatPum),
        Text(
          extent={{76,148},{98,134}},
          lineColor={255,0,255},
          textString="yChi"),
        Text(
          extent={{52,28},{100,14}},
          lineColor={255,0,255},
          textString="yConWatPum"),
        Text(
          extent={{60,-132},{100,-146}},
          lineColor={255,0,255},
          textString="yLeaCel"),
        Text(
          extent={{62,-192},{98,-206}},
          lineColor={255,0,255},
          textString="yTowCel"),
        Text(
          extent={{64,-254},{98,-268}},
          lineColor={255,0,255},
          textString="yMakUp"),
        Text(
          extent={{52,208},{100,194}},
          lineColor={0,0,127},
          textString="yChiPumSpe"),
        Text(
          extent={{52,178},{100,164}},
          lineColor={0,0,127},
          textString="yChiDem"),
        Text(
          extent={{52,118},{100,104}},
          lineColor={0,0,127},
          textString="yHeaPreConVal",
          visible=have_WSE or (not have_WSE and have_fixSpeConWatPum)),
        Text(
          extent={{52,88},{100,74}},
          lineColor={0,0,127},
          textString="yConWatPumSpe",
          visible=not have_fixSpeConWatPum),
        Text(
          extent={{52,60},{100,46}},
          lineColor={0,0,127},
          textString="yChiWatMinFloSet"),
        Text(
          extent={{52,-42},{100,-56}},
          lineColor={0,0,127},
          textString="yChiWatIsoVal"),
        Text(
          extent={{52,-72},{100,-86}},
          lineColor={0,0,127},
          textString="yMinValPosSet"),
        Text(
          extent={{52,-162},{100,-176}},
          lineColor={0,0,127},
          textString="yTowCelIsoVal"),
        Text(
          extent={{52,-222},{100,-236}},
          lineColor={0,0,127},
          textString="yTwoFanSpe"),
        Text(
          extent={{58,-102},{100,-116}},
          lineColor={255,127,0},
          textString="yNumCel"),
        Text(
          extent={{52,-10},{100,-24}},
          lineColor={255,0,255},
          textString="yReaChiDemLim"),
        Text(
          extent={{-98,188},{-50,174}},
          lineColor={0,0,127},
          visible=have_locSenChiWatPum,
          textString="dpChiWat_local")}),
    Diagram(coordinateSystem(extent={{-800,-840},{800,760}}), graphics={Text(
          extent={{-482,-574},{-398,-594}},
          lineColor={28,108,200},
          textString="might need a pre block")}),
Documentation(info="<html>
<p>
This is chiller plant control sequence implemented according to ASHRAE RP-1711 Advanced
Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (draft version on March 23, 2020). It is
assembled by following subsequences:
</p>
<h4>1. Plant reset</h4>
<p>
The sequences
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset</a>
and
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply</a>
are for resetting chilled water temperature setpoint and differential pressure setpoint.
They are applicable for the primary-only plants or for the primary-secondary systems
serving differential pressure controlled pumps.  
</p>
<table summary=\"summary\" border=\"1\">
<tr><th bgcolor=\"silver\">Applicable</th> </tr>
<tr><td>Primary-only systems</td></tr>
<tr><td>Primay-secondary systems serving differential pressure controlled pumps</td></tr>
<tr><th bgcolor=\"silver\">Not applicable</th> </tr>
<tr><td>Primary-only systems serving a single large load, e.g. large AHU</td></tr>
<tr><td>Primay-secondary systems where there are any coil pumps</td></tr>
<tr><td>Plants with multiple reset loops</td></tr>
<tr><td>Plants with series chiller</td></tr>
</table>

<h4>2. Head pressure control</h4>
<p>
The sequence
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller</a>
generates control signals for chiller head pressure control.
</p>
<table summary=\"summary\" border=\"1\">
<tr><th bgcolor=\"silver\">Applicable</th> </tr>
<tr><td>Plants with headered condenser water pump, fixed or variable speed</td></tr>
<tr><td>Plants with or without waterside economizer</td></tr>
<tr><th bgcolor=\"silver\">Not applicable</th> </tr>
<tr><td>Plants with air-cooling chillers</td></tr>
</table>
<p>
Note the sequence assumes:
</p>
<ul>
<li>
the plants with fixed speed condenser water pump do not have waterside economizer.
</li>
<li>
when plants have variable speed condenser water pump and have waterside economizer,
the pumps are headered.
</li>
</ul>

<h4>3. Minimum flow bypass valve control</h4>
<p>
The sequence
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller</a>
and
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint</a>
control chilled water minimum flow bypass valve.
</p>
<table summary=\"summary\" border=\"1\">
<tr><th bgcolor=\"silver\">Applicable</th> </tr>
<tr><td>Primary-only plants, with parallel or series chillers</td></tr>
<tr><th bgcolor=\"silver\">Not applicable</th> </tr>
<tr><td>Primary-secondary plants</td></tr>
</table>

<h4>4. Chilled water pump control</h4>
<p>
The sequence
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller</a>
controls chilled water pump. It is applicable for primary-only plants with parallel
chillers.
</p>
<table summary=\"summary\" border=\"1\">
<tr><th bgcolor=\"silver\">Applicable</th> </tr>
<tr><td>Primary-only plants with parallel chillers</td></tr>
<tr><th bgcolor=\"silver\">Not applicable</th> </tr>
<tr><td>Primary-only plants with series chillers</td></tr>
<tr><td>Primary-secondary plants</td></tr>
</table>

<h4>5. Chiller staging control</h4>
<p>
The sequences
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Up</a>
and
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down</a>
controls chiller staging up and down process. They are applicable for following plants:
</p>
<table summary=\"summary\" border=\"1\">
<tr><th bgcolor=\"silver\">Applicable</th> </tr>
<tr><td>water-cooled, primary-only, parallel chiller plants with headered chilled water pumps and headered condenser water pumps</td></tr>
<tr><td>air-cooled primary-only, parallel chiller plants with headered chilled water pumps</td></tr>
<tr><th bgcolor=\"silver\">Not applicable</th> </tr>
<tr><td>Primary-only plants with parallel chillers, dedicated chilled water or condenser water pumps</td></tr>
<tr><td>Primary-only plants with series chillers</td></tr>
<tr><td>Primary-secondary plants</td></tr>
</table>

<h4>6. Tower control</h4>
<p>
The sequence
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Controller</a>
controls cooling tower staging and the fans speed. It is appliable for plants with
dynamic load profiles, i.e. those for which PLR may change by more than approximately
25% in any hour, for controlling condenser water return temperature. It is not
applicable for the plants where 2-position tower bypass control valves are needed
to prevent tower freezing.
</p>

<h4>7. Equipment rotation</h4>
<p>
The sequence
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo</a>
rotates equipment, such as chillers or pumps, in order to ensure equal wear and tear.
It is applicable for <b>two identical</b> devices or device groups.
</p>

</html>", revisions="<html>
<ul>
<li>
August 30, 2021, by Jianjun Hu:<br/>
Cleaned implementation and added documentation.
</li>
<li>
May 30, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
