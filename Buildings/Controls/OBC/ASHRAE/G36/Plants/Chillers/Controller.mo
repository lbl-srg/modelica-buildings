within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers;
block Controller "Chiller plant controller"

  // ---- General: Chiller configuration ----
  parameter Integer nChi=2
    "Total number of chillers"
    annotation(Dialog(tab="General", group="Chillers configuration"));

  parameter Boolean have_airCoo=false
    "True: the plant has air cooled chiller"
    annotation(Dialog(tab="General", group="Chillers configuration"));

  final parameter Boolean have_priOnl=true
    "True: the primary-only plant; False: the primary-secondary plant";

  parameter Boolean have_parChi=true
    "Flag: true means that the plant has parallel chillers"
    annotation(Dialog(tab="General", group="Chillers configuration"));

  parameter Boolean have_ponyChiller=false
    "True: have pony chiller"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Boolean use_loadShed=true
    "Set to true if a load shed logic is used"
    annotation (Dialog(tab="General", group="Chillers configuration", enable=not have_priOnl));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.ChillersAndStages
    chiTyp[nChi]={Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.ChillersAndStages.PositiveDisplacement,
                  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.ChillersAndStages.VariableSpeedCentrifugal}
    "Chiller type"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Real chiDesCap[nChi](unit=fill("W", nChi))
    "Design chiller capacities vector"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Real chiMinCap[nChi](unit=fill("W", nChi))
    "Chiller minimum cycling loads vector"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Real TChiWatSupMin[nChi](
    unit=fill("K", nChi),
    each displayUnit="degC")={278.15,278.15}
    "Minimum chilled water supply temperature"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Real dTChiMinLif[nChi](unit=fill("K", nChi))=fill(12, nChi)
    "Minimum LIFT of each chiller"
    annotation (Dialog(group="Chillers configuration"));
  parameter Real dTChiMaxLif[nChi](unit=fill("K", nChi))={18,18}
    "Maximum LIFT of each chiller"
    annotation (Dialog(group="Chillers configuration"));

  parameter Boolean have_heaPreConSig=false
    "True: if there is head pressure control signal from chiller controller"
    annotation(Dialog(tab="General", group="Chillers configuration"));

  // ---- General: Waterside economizer ----

  parameter Boolean have_WSE=false
    "True if the plant has waterside economizer. When the plant has waterside economizer, the condenser water pump speed must be variable"
    annotation (Dialog(tab="General", group="Waterside economizer", enable=not have_airCoo));

  parameter Real heaExcAppDes(
    unit="K",
    displayUnit="K")=2
    "Design heat exchanger approach"
    annotation(Evaluate=true, Dialog(tab="General", group="Waterside economizer", enable=have_WSE and not have_airCoo));

  parameter Boolean have_byPasValCon=false
    "True: chilled water flow through economizer is controlled using heat exchanger bypass valve"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE and not have_airCoo));

  // ----- General: Chilled water pump ---

  parameter Integer nChiWatPum=nChi
    "Total number of primary chilled water pumps"
    annotation (Dialog(tab="General", group="Chilled water pump", enable=have_heaChiWatPum));

  parameter Boolean have_heaChiWatPum=true
    "Flag of headered chilled water pumps design: true=headered, false=dedicated"
    annotation (Dialog(tab="General", group="Chilled water pump"));

  parameter Boolean have_locSenChiWatPum=false
    "True: there is local differential pressure sensor hardwired to the plant controller"
    annotation (Dialog(tab="General", group="Chilled water pump"));

  parameter Integer nSenChiWatPum=1
    "Total number of remote differential pressure sensors"
    annotation (Dialog(tab="General", group="Chilled water pump"));

  // ---- General: Condenser water pump ----

  parameter Integer nConWatPum=nChi
    "Total number of condenser water pumps"
    annotation (Dialog(tab="General", group="Condenser water pump", enable=(not have_airCoo) and have_heaConWatPum));

  parameter Boolean have_fixSpeConWatPum = false
    "True: the plant has fixed speed condenser water pumps. When the plant has waterside economizer, it must be false"
    annotation(Dialog(tab="General", group="Condenser water pump", enable=(not have_airCoo) and not have_WSE));

  parameter Boolean have_heaConWatPum=true
    "True: headered condenser water pumps"
    annotation (Dialog(tab="General", group="Condenser water pump", enable=not have_airCoo));

  // ---- General: Chiller staging settings ----

  final parameter Integer nUniSta = if have_WSE then nChi+1 else nChi
    "Number of units to stage";

  parameter Integer totSta=6
    "Total number of plant stages, including stage zero and the stages with a WSE, if applicable"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Integer plaStaMat[totSta, nUniSta]={{0,0,0},{0,0,1},{1,0,0},{1,0,1},{1,1,0},{1,1,1}}
    "Plant staging matrix with plant stage as row index and chiller as column index (highest index for optional WSE): 0 for disabled, 1 for enabled"
    annotation (Evaluate=true, Dialog(group="Staging configuration"));

  parameter Integer staMat[nSta, nChi]={{1,0},{1,1}}
    "Chiller staging matrix with chiller stage as row index and chiller as column index"
    annotation (Evaluate=true, Dialog(group="Staging configuration"));

//   final parameter Integer nSta = 2
//     "Number of chiller stages, neither zero stage nor the stages with enabled waterside economizer is included"
//     annotation (Dialog(tab="General", group="Staging configuration"));

//   final parameter Integer staMat[nSta, nChi] = {{1,0},{1,1}}
//     "Staging matrix with chiller stage as row index and chiller as column index"
//     annotation (Dialog(tab="General", group="Staging configuration"));

//   final parameter Integer staMatTem[totSta, nUniSta] = if not have_WSE then plaStaMa
//     else {{if plaStaMat[i, end] == 0 then {plaStaMat[i,j] for j in 1:nUniSta} else {-1 for j in 1:nUniSta}} for i in 1:totSta}
//     "Staging matrix with chiller stage as row index and chiller as column index";
//
//   final parameter Integer staMat[:, nChi] = if not have_WSE then staMatTem[2:end,:]
// else if sum(staMatTem[i,:]) > 0 then

//   final parameter Integer staMat[nSta, nChi] = if not have_WSE then plaStaMat[2:end,:]
//     else {{if plaStaMat[i, end] == 0 then {plaStaMat[i,j] for j in 1:nUniSta-1} else 0} for i in 2:totSta}
//     "Staging matrix with chiller stage as row index and chiller as column index";


  final parameter Integer desChiNum[nSta+1]={if i == 0 then 0 else sum(staMat[i]) for i in 0:nSta}
    "Design number of chiller that should be ON at each chiller stage, including the zero stage"
    annotation (Dialog(tab="General", group="Staging configuration", enable=have_fixSpeConWatPum));

  final parameter Real staTmp[totSta, nUniSta]={{if plaStaMat[i, nUniSta] > 0 then (if j <= nChi
    then plaStaMat[i, j] else 0.5) else plaStaMat[i,j] for j in 1:nUniSta} for i in 1:totSta}
    "Intermediary parameter to compute staVec"
    annotation (Dialog(tab="General",group="Staging configuration"));
  final parameter Real staVec[totSta]={sum(staTmp[i]) for i in 1:totSta}
    "Plant stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Dialog(tab="General",group="Staging configuration"));

  final parameter Integer nSta = sum({(if staVec[i] > 0.5 then 1 else 0) for i in 1:totSta})
    "Number of chiller stages, neither zero stage nor the stages with enabled waterside economizer is included";

  parameter Real desConWatPumSpe[totSta](
    max=fill(1, totSta),
    min=fill(0, totSta))={0,0.5,0.75,0.6,0.75,0.9}
    "Design condenser water pump speed setpoints, according to current chiller stage and WSE status"
    annotation (Dialog(tab="General", group="Staging configuration", enable=(not have_airCoo) and (not have_fixSpeConWatPum)));

  parameter Integer desConWatPumNum[totSta]={0,1,1,2,2,2}
    "Design number of condenser water pumps that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(tab="General", group="Staging configuration", enable=not have_airCoo));

  parameter Integer towCelOnSet[totSta]={0,2,2,4,4,4}
    "Design number of tower fan cells that should be ON, according to current chiller stage and WSE status"
    annotation(Dialog(tab="General", group="Staging configuration", enable=not have_airCoo));

  // ---- General: Cooling tower ----

  parameter Integer nTowCel=4
    "Total number of cooling tower cells"
    annotation (Dialog(tab="General", group="Cooling tower", enable=not have_airCoo));

  parameter Real cooTowAppDes(
    unit="K",
    displayUnit="K")=2
    "Design cooling tower approach"
    annotation(Evaluate=true, Dialog(tab="General", group="Cooling tower", enable=not have_airCoo));

  // ---- Plant enable ----

  parameter Real TChiLocOut(
    unit="K",
    displayUnit="degC")=277.5
    "Outdoor air lockout temperature below which the chiller plant should be disabled"
    annotation(Dialog(tab="Plant enable"));

  parameter Real plaThrTim(unit="s")=900
    "Threshold time to check status of chiller plant"
    annotation(Dialog(tab="Plant enable"));

  parameter Real reqThrTim(unit="s")=180
    "Threshold time to check current chiller plant request"
    annotation(Dialog(tab="Plant enable"));

  parameter Integer ignReq = 0
    "Ignorable chiller plant requests"
    annotation(Dialog(tab="Plant enable"));

  parameter Real iniPumDel(unit="s")=5
    "Time to delay pump operation when the plant is just initiated"
    annotation(Dialog(tab="Plant enable"));

  // ---- Waterside economizer ----

  parameter Real holdPeriod(unit="s")=1200
    "WSE minimum on or off time"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Enable parameters", enable=have_WSE and not have_airCoo));

  parameter Real delDis(unit="s")=120
    "Delay disable time period"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Enable parameters", enable=have_WSE and not have_airCoo));

  parameter Real TOffsetEna(unit="K")=2
    "Temperature offset between the chilled water return upstream of WSE and the predicted WSE output"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Enable parameters", enable=have_WSE and not have_airCoo));

  parameter Real TOffsetDis(unit="K")=1
    "Temperature offset between the chilled water return upstream and downstream WSE"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Enable parameters", enable=have_WSE and not have_airCoo));

  parameter Real TOutWetDes(
    unit="K",
    displayUnit="degC")=288.15
    "Design outdoor air wet bulb temperature"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters", enable=have_WSE and not have_airCoo));

  parameter Real VHeaExcDes_flow(start=0, unit="m3/s")
    "Design heat exchanger chilled water volume flow rate"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters", enable=have_WSE and not have_airCoo));

  parameter Real step=0.02 "Tuning step"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Tuning", enable=have_WSE and not have_airCoo));

  parameter Real wseOnTimDec(unit="s")=3600
    "Economizer enable time needed to allow decrease of the tuning parameter"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Tuning", enable=have_WSE and not have_airCoo));

  parameter Real wseOnTimInc(unit="s")=1800
    "Economizer enable time needed to allow increase of the tuning parameter"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Tuning", enable=have_WSE and not have_airCoo));

  parameter Real dpDes=3E4
    "Design waterside economizer chilled water pressure drop"
    annotation (Dialog(tab="Waterside economizer", group="Valve or pump control",
        enable=have_WSE and have_byPasValCon and not have_airCoo));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController ecoValCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Waterside economizer",group="Valve or pump control",
        enable=have_WSE and have_byPasValCon and not have_airCoo));

  parameter Real kEcoVal=0.1 "Gain of controller"
    annotation (Dialog(tab="Waterside economizer",group="Valve or pump control",
        enable=have_WSE and have_byPasValCon and not have_airCoo));

  parameter Real TiEcoVal=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Waterside economizer", group="Valve or pump control",
        enable=have_WSE and have_byPasValCon and not have_airCoo
               and (ecoValCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                    or ecoValCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real TdEcoVal=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Waterside economizer",group="Valve or pump control",
      enable=have_WSE and have_byPasValCon and not have_airCoo
             and (ecoValCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                  or ecoValCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real minEcoSpe=0.1
    "Minimum economizer chilled water pump speed"
    annotation (Dialog(tab="Waterside economizer",group="Valve or pump control",
      enable=have_WSE and not have_byPasValCon and not have_airCoo));

  // ---- Head pressure ----

  parameter Real minConWatPumSpe(unit="1")=0.1
    "Minimum condenser water pump speed"
    annotation(Dialog(enable= (not have_airCoo) and not ((not have_WSE) and have_fixSpeConWatPum),
                      tab="Head pressure", group="Limits"));

  parameter Real minHeaPreValPos(unit="1")=0.1
    "Minimum head pressure control valve position"
    annotation(Dialog(enable= (not have_airCoo) and (not ((not have_WSE) and (not have_fixSpeConWatPum))),
                      tab="Head pressure", group="Limits"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHeaPre=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Head pressure", group="Loop signal", enable=(not have_airCoo) and not have_heaPreConSig));

  parameter Real kHeaPreCon=0.1
    "Gain of controller"
    annotation(Dialog(tab="Head pressure", group="Loop signal", enable=(not have_airCoo) and not have_heaPreConSig));

  parameter Real TiHeaPreCon(unit="s")=10
    "Time constant of integrator block"
    annotation(Dialog(tab="Head pressure", group="Loop signal", enable=(not have_airCoo) and not have_heaPreConSig));

  // ---- Minimum flow bypass ----

  parameter Real byPasSetTim(unit="s")=300
    "Time constant for resetting minimum bypass flow"
    annotation(Dialog(tab="Minimum flow bypass", group="Time parameters"));

  parameter Real minFloSet[nChi](unit=fill("m3/s", nChi))={0.0089,0.0089}
    "Minimum chilled water flow through each chiller"
    annotation(Dialog(tab="Minimum flow bypass", group="Flow limits"));

  parameter Real maxFloSet[nChi](unit=fill("m3/s", nChi))={0.025,0.025}
    "Maximum chilled water flow through each chiller"
    annotation(Dialog(tab="Minimum flow bypass", group="Flow limits"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMinFloByp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Minimum flow bypass", group="Controller"));

  parameter Real kMinFloBypCon=0.1
    "Gain of controller"
    annotation (Dialog(tab="Minimum flow bypass", group="Controller"));

  parameter Real TiMinFloBypCon(unit="s")=10
    "Time constant of integrator block"
    annotation (Dialog(tab="Minimum flow bypass",
    group="Controller", enable=controllerTypeMinFloByp==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                               controllerTypeMinFloByp==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdMinFloBypCon(unit="s")=0
    "Time constant of derivative block"
    annotation (Dialog(tab="Minimum flow bypass",
    group="Controller", enable=controllerTypeMinFloByp==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                               controllerTypeMinFloByp==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real yMaxFloBypCon(unit="1")=1
    "Upper limit of output"
    annotation (Dialog(tab="Minimum flow bypass", group="Controller"));

  parameter Real yMinFloBypCon(unit="1")=0.1
    "Lower limit of output"
    annotation (Dialog(tab="Minimum flow bypass", group="Controller"));

  // ---- Chilled water pumps ----

  parameter Real minChiWatPumSpe(unit="1")=0.1
    "Minimum pump speed"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Real maxChiWatPumSpe(unit="1")=1
    "Maximum pump speed"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Integer nPum_nominal(
    max=nChiWatPum,
    min=1)=nChiWatPum
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(tab="Chilled water pumps", group="Nominal conditions"));

  parameter Real VChiWat_flow_nominal(unit="m3/s")
    "Total plant design chilled water flow rate"
    annotation (Dialog(tab="Chilled water pumps", group="Nominal conditions"));

  parameter Real maxLocDp(unit="Pa")=15*6894.75
    "Maximum chilled water loop local differential pressure setpoint"
    annotation (Dialog(tab="Chilled water pumps", group="Pump speed control when there is local DP sensor", enable=have_locSenChiWatPum));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeChiWatPum=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Real kChiWatPum=0.1 "Gain of controller"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Real TiChiWatPum(unit="s")=10
    "Time constant of integrator block"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  parameter Real TdChiWatPum(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller",
                       enable=controllerTypeChiWatPum == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                              controllerTypeChiWatPum == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  // ---- Plant reset ----

  parameter Real holTim(unit="s")=900
    "Time to fix plant reset value"
    annotation(Dialog(tab="Plant Reset"));

  parameter Real iniSet(unit="1")=1
    "Initial setpoint"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond"));

  parameter Real minSet(unit="1")=0
    "Minimum plant reset value"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond"));

  parameter Real maxSet(unit="1")=1
    "Maximum plant reset value"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond"));

  parameter Real delTim(unit="s")=900
    "Delay time after which trim and respond is activated"
    annotation (Dialog(tab="Plant Reset", group="Trim and respond"));

  parameter Real samplePeriod(unit="s")=300
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

  parameter Real dpChiWatMin[nSenChiWatPum](unit=fill("Pa", nSenChiWatPum))=
    fill(34473.8, nSenChiWatPum)
    "Minimum chilled water differential pressure setpoint, the array size equals to the number of remote pressure sensor"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  parameter Real dpChiWatMax[nSenChiWatPum](unit=fill("Pa", nSenChiWatPum),
      each displayUnit="Pa")
    "Maximum chilled water differential pressure setpoint, the array size equals to the number of remote pressure sensor"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  parameter Real TPlaChiWatSupMax(
    unit="K",
    displayUnit="degC")=288.706
    "Maximum plant chilled water supply temperature, default 60 degF"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  parameter Real halSet = 0.5
    "Half plant reset value"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  // ---- Staging setpoints ----

  parameter Real avePer(unit="s")=300
    "Time period for the capacity requirement rolling average"
    annotation (Dialog(tab="Staging", group="Hold and delay"));

  parameter Real delayStaCha(unit="s")=900
    "Hold period for each stage change"
    annotation (Dialog(tab="Staging", group="Hold and delay"));

  parameter Real parLoaRatDelay(unit="s")=900
    "Enable delay for operating and staging part load ratio condition"
    annotation (Dialog(tab="Staging", group="Hold and delay"));

  parameter Real faiSafTruDelay(unit="s")=900
    "Enable delay for failsafe condition"
    annotation (Dialog(tab="Staging", group="Hold and delay"));

  parameter Real effConTruDelay(unit="s")=900
    "Enable delay for efficiency condition"
    annotation (Dialog(tab="Staging", group="Hold and delay"));

  parameter Real shortTDelay(unit="s")=600
    "Short enable delay for staging from zero to first available stage up"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Staging", group="Hold and delay"));

  parameter Real longTDelay(unit="s")=1200
    "Long enable delay for staging from zero to first available stage up"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Staging", group="Hold and delay"));

  parameter Real posDisMult(unit="1")=0.8
    "Positive displacement chiller type staging multiplier"
    annotation (Dialog(tab="Staging", group="Staging part load ratio"));

  parameter Real conSpeCenMult(unit="1")=0.9
    "Constant speed centrifugal chiller type staging multiplier"
    annotation (Dialog(tab="Staging", group="Staging part load ratio"));

  parameter Real anyOutOfScoMult(unit="1")=0.9
    "Outside of G36 recommended staging order chiller type SPLR multiplier"
    annotation(Evaluate=true, __cdl(ValueInReference=False), Dialog(tab="Staging", group="Staging part load ratio"));

  parameter Real varSpeStaMin(unit="1")=0.45
    "Minimum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen, tab="Staging", group="Staging part load ratio"));

  parameter Real varSpeStaMax(unit="1")=0.9
    "Maximum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen, tab="Staging", group="Staging part load ratio"));

  parameter Real smallTDif(unit="K")=1
    "Offset between the chilled water supply temperature and its setpoint for the long condition"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Staging", group="Value comparison"));

  parameter Real largeTDif(unit="K")=2
    "Offset between the chilled water supply temperature and its setpoint for the short condition"
    annotation(Evaluate=true, Dialog(enable=have_WSE, tab="Staging", group="Value comparison"));

  parameter Real faiSafTDif(unit="K")=1
    "Offset between the chilled water supply temperature and its setpoint for the failsafe condition"
    annotation (Dialog(tab="Staging", group="Value comparison"));

  parameter Real dpDif(
    unit="Pa",
    displayUnit="Pa")=2*6895
    "Offset between the chilled water pump diferential static pressure and its setpoint"
    annotation (Dialog(tab="Staging", group="Value comparison"));

  parameter Real TDif(unit="K")=1
    "Offset between the chilled water supply temperature and its setpoint for staging down to WSE only"
    annotation (Dialog(tab="Staging", group="Value comparison"));

  parameter Real faiSafDpDif(
    unit="Pa",
    displayUnit="Pa")=2*6895
    "Offset between the chilled water differential pressure and its setpoint"
    annotation (Dialog(tab="Staging", group="Value comparison"));

  parameter Real effConSigDif(
    max=1,
    min=0)=0.05
    "Signal hysteresis deadband"
    annotation (Dialog(tab="Staging", group="Value comparison"));

  // ---- Staging up and down process ----

  parameter Real chiDemRedFac(unit="1")=0.75
    "Demand reducing factor of current operating chillers"
    annotation (Dialog(tab="Staging", group="Up and down process", enable=have_priOnl or use_loadShed));

  parameter Real holChiDemTim(unit="s")=300
    "Maximum time to wait for the actual demand less than percentage of current load"
    annotation (Dialog(tab="Staging", group="Up and down process", enable=have_priOnl or use_loadShed));

  parameter Real aftByPasSetTim(unit="s")=60
    "Time to allow loop to stabilize after resetting minimum chilled water flow setpoint"
    annotation (Dialog(tab="Staging", group="Up and down process"));

  parameter Real waiTim(unit="s")=30
    "Waiting time after enabling next head pressure control"
    annotation (Dialog(tab="Staging", group="Up and down process"));

  parameter Real chaChiWatIsoTim(unit="s")=300
    "Time to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(tab="Staging", group="Up and down process"));

  parameter Real proOnTim(unit="s")=300
    "Threshold time to check after newly enabled chiller being operated"
    annotation (Dialog(tab="Staging", group="Up and down process", enable=have_ponyChiller));

  parameter Real thrTimEnb(unit="s")=10
    "Threshold time to enable head pressure control after condenser water pump being reset"
    annotation (Dialog(tab="Staging", group="Up and down process"));

  // ---- Cooling tower: fan speed ----

  final parameter Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.TowerSpeedControl fanSpeCon=
    Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.TowerSpeedControl.CondenserWaterReturnTemperaure
    "Tower fan speed control type"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed", enable=not have_airCoo));

  final parameter Boolean have_conWatRetCon = fanSpeCon==Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.TowerSpeedControl.CondenserWaterReturnTemperaure
    "True: the fan speed is controlled to maintain the condenser water return temperature setpoint"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed", enable=not have_airCoo));

  parameter Boolean closeCoupledPlant=false
    "True: the plant is close coupled, i.e. the pipe length from the chillers to cooling towers does not exceed approximately 100 feet"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed", enable=(not have_airCoo) and have_conWatRetCon));

  parameter Real fanSpeMin(unit="1")=0.1
    "Minimum tower fan speed"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed", enable=not have_airCoo));

  parameter Real fanSpeMax(unit="1")=1
    "Maximum tower fan speed"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed", enable=not have_airCoo));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController intOpeCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Controller in the mode when WSE and chillers are enabled"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                       enable=have_WSE and not have_airCoo));

  parameter Real kIntOpeTowFan=0.1 "Gain of controller"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                       enable=have_WSE and not have_airCoo));

  parameter Real TiIntOpeTowFan(unit="s")=10
    "Time constant of integrator block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                       enable=have_WSE and (intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                            intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
                              and not have_airCoo));

  parameter Real TdIntOpeTowFan(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                       enable=have_WSE and (intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                           intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
                              and not have_airCoo));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController chiWatConTowFan=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Controller in the mode when only WSE is enabled"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                       enable=have_WSE and not have_airCoo));

  parameter Real kWSETowFan=0.1 "Gain of controller"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                       enable=have_WSE and not have_airCoo));

  parameter Real TiWSETowFan(unit="s")=10
    "Time constant of integrator block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                        enable=have_WSE and (chiWatConTowFan==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                             chiWatConTowFan==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
                               and not have_airCoo));

  parameter Real TdWSETowFan(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed controller with WSE enabled",
                       enable=have_WSE and (chiWatConTowFan==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                            chiWatConTowFan==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
                              and not have_airCoo));

  // Fan speed control: controlling condenser return water temperature when WSE is not enabled
  parameter Real TConWatSup_nominal[nChi](
    unit=fill("K", nChi),
    each displayUnit="degC")={293.15,293.15}
    "Condenser water supply temperature (condenser entering) of each chiller"
    annotation (Evaluate=true, Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control", enable=not have_airCoo));

  parameter Real TConWatRet_nominal[nChi](
    unit=fill("K", nChi),
    each displayUnit="degC")={303.15,303.15}
    "Condenser water return temperature (condenser leaving) of each chiller"
    annotation (Evaluate=true, Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control", enable=not have_airCoo));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController couPlaCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of coupled plant controller"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                        enable=closeCoupledPlant and not have_airCoo));

  parameter Real kCouPla=1 "Gain of controller"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                        enable=closeCoupledPlant and not have_airCoo));

  parameter Real TiCouPla(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=closeCoupledPlant and (couPlaCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                      couPlaCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
                              and not have_airCoo));

  parameter Real TdCouPla(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=closeCoupledPlant and (couPlaCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                     couPlaCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
                              and not have_airCoo));

  parameter Real yCouPlaMax(unit="1")=1
    "Upper limit of output"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=closeCoupledPlant and not have_airCoo));

  parameter Real yCouPlaMin(unit="1")=0
    "Lower limit of output"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                        enable=closeCoupledPlant and not have_airCoo));

  parameter Real samplePeriodConTDiff(unit="s")=30
    "Period of sampling condenser water supply and return temperature difference"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=(not have_airCoo) and not closeCoupledPlant));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController supWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Condenser supply water temperature controller for less coupled plant"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=(not have_airCoo) and not closeCoupledPlant));

  parameter Real kSupCon=0.1 "Gain of controller"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=(not have_airCoo) and not closeCoupledPlant));

  parameter Real TiSupCon(unit="s")=10
    "Time constant of integrator block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=(not closeCoupledPlant) and (supWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                           supWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
                              and (not have_airCoo)));

  parameter Real TdSupCon(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=(not closeCoupledPlant) and (supWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                           supWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
                               and (not have_airCoo)));

  parameter Real ySupConMax=1 "Upper limit of output"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=(not have_airCoo) and not closeCoupledPlant));

  parameter Real ySupConMin=0 "Lower limit of output"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control",
                       enable=(not have_airCoo) and not closeCoupledPlant));

  parameter Real iniPlaTim(unit="s")=600
    "Time to hold return temperature at initial setpoint after plant being enabled"
    annotation (Dialog(tab="Cooling Towers", group="Advanced", enable=(not have_airCoo)));

  parameter Real ramTim(unit="s")=180
    "Time to ramp return water temperature from initial value to setpoint"
    annotation (Dialog(tab="Cooling Towers", group="Advanced", enable=(not have_airCoo)));

  parameter Real cheMinFanSpe(unit="s")=300
    "Threshold time for checking duration when tower fan equals to the minimum tower fan speed"
    annotation (Dialog(tab="Cooling Towers", group="Advanced", enable=(not have_airCoo)));

  parameter Real cheMaxTowSpe(unit="s")=300
    "Threshold time for checking duration when any enabled chiller maximum cooling speed equals to the minimum tower fan speed"
    annotation (Dialog(tab="Cooling Towers", group="Advanced", enable=(not have_airCoo)));

  parameter Real cheTowOff(unit="s")=60
    "Threshold time for checking duration when there is no enabled tower fan"
    annotation (Dialog(tab="Cooling Towers", group="Advanced", enable=(not have_airCoo)));

  // ---- Cooling tower: staging ----
  parameter Real chaTowCelIsoTim(unit="s")=300
    "Time to slowly change isolation valve"
     annotation (Dialog(tab="Cooling Towers", group="Enable isolation valve", enable=(not have_airCoo)));

  // ---- Cooling tower: Water level control ----
  parameter Real watLevMin(
    min=0,
    unit="m")=0.7
    "Minimum cooling tower water level recommended by manufacturer"
     annotation (Dialog(tab="Cooling Towers", group="Makeup water", enable=(not have_airCoo)));

  parameter Real watLevMax(unit="m")=1
    "Maximum cooling tower water level recommended by manufacturer"
    annotation (Dialog(tab="Cooling Towers", group="Makeup water", enable=(not have_airCoo)));

  // ---- Advanced ----
  parameter Real locDt(unit="K")=1
    "Offset temperature for lockout chiller"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Plant enable"));

  parameter Real hysDt(
    unit="K",
    displayUnit="K")=1
    "Deadband temperature used in hysteresis block"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Waterside economizer"));

  parameter Real dpDifHys(
    unit="Pa",
    displayUnit="Pa")=0.5*6895
    "Pressure difference hysteresis deadband"
    annotation (Dialog(tab="Advanced", group="Staging"));

  parameter Real relFloDif=0.05
    "Relative error to the setpoint for checking if it has achieved flow rate setpoint"
    annotation (Dialog(tab="Advanced", group="Staging"));

  parameter Real speChe=0.005
     "Lower threshold value to check fan or pump speed"
     annotation (Dialog(tab="Advanced", group="Cooling towers"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water request for each chiller"
    annotation (Placement(transformation(extent={{-940,620},{-900,660}}),
      iconTransformation(extent={{-140,340},{-100,380}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    if not have_airCoo
    "Condenser water request for each chiller"
    annotation (Placement(transformation(extent={{-940,590},{-900,630}}),
      iconTransformation(extent={{-140,320},{-100,360}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nChiWatPum]
    "Chilled water pump status"
    annotation(Placement(transformation(extent={{-940,554},{-900,594}}),
      iconTransformation(extent={{-140,300},{-100,340}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_local(
    final quantity="PressureDifference",
    final unit="Pa") if have_locSenChiWatPum
    "Chilled water differential static pressure from local sensor"
    annotation (Placement(transformation(extent={{-940,520},{-900,560}}),
      iconTransformation(extent={{-140,260},{-100,300}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet_local(
    final quantity="PressureDifference",
    final unit="Pa") if have_locSenChiWatPum
    "Chilled water differential static pressure setpoint from local sensor"
    annotation (Placement(transformation(extent={{-940,480},{-900,520}}),
        iconTransformation(extent={{-140,240},{-100,280}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_remote[nSenChiWatPum](
    final unit=fill("Pa", nSenChiWatPum),
    final quantity=fill("PressureDifference", nSenChiWatPum))
    "Chilled water differential static pressure from remote sensor"
    annotation(Placement(transformation(extent={{-940,450},{-900,490}}),
      iconTransformation(extent={{-140,220},{-100,260}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water volume flow rate for primary-only plant"
    annotation(Placement(transformation(extent={{-940,420},{-900,460}}),
      iconTransformation(extent={{-140,200},{-100,240}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Vector of chiller status"
    annotation(Placement(transformation(extent={{-940,380},{-900,420}}),
      iconTransformation(extent={{-140,180},{-100,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput phi(
    final unit="1") if have_WSE and not have_airCoo
    "Outdoor relative humidity"
    annotation (Placement(transformation(extent={{-940,340},{-900,380}}),
      iconTransformation(extent={{-140,140},{-100,180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRetDow(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_WSE
    "Chiller water return temperature downstream of the WSE"
    annotation(Placement(transformation(extent={{-940,300},{-900,340}}),
      iconTransformation(extent={{-140,120},{-100,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chiller water return temperature upstream of the WSE"
    annotation(Placement(transformation(extent={{-940,260},{-900,300}}),
        iconTransformation(extent={{-140,100},{-100,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet[nChi](
    final unit=fill("K", nChi),
    displayUnit=fill("degC", nChi),
    final quantity=fill("ThermodynamicTemperature", nChi)) if not have_airCoo
    "Measured condenser water return temperature (condenser leaving)"
    annotation (Placement(transformation(extent={{-940,220},{-900,260}}),
        iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured chilled water supply temperature"
    annotation(Placement(transformation(extent={{-940,190},{-900,230}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaPreCon[nChi]
    if have_heaPreConSig and not have_airCoo
    "Chiller head pressure control loop signal from chiller controller"
    annotation (Placement(transformation(extent={{-940,160},{-900,200}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat(
    final unit="Pa",
    final quantity="PressureDifference")
    if have_WSE and have_byPasValCon
    "Differential static pressure across economizer in the chilled water side"
    annotation (Placement(transformation(extent={{-940,90},{-900,130}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector"
    annotation(Placement(transformation(extent={{-940,60},{-900,100}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEcoPum
    if have_WSE and not have_byPasValCon and not have_airCoo
    "True: economizer heat exchanger pump is proven on"
    annotation (Placement(transformation(extent={{-940,30},{-900,70}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEntHex(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if have_WSE and not have_byPasValCon and not have_airCoo
    "Chilled water temperature entering economizer heat exchanger"
    annotation (Placement(transformation(extent={{-940,0},{-900,40}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    if not have_airCoo
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-940,-100},{-900,-60}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chilled water isolation valve position"
    annotation(Placement(transformation(extent={{-940,-248},{-900,-208}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TChiWatSupResReq
    "Chilled water supply temperature setpoint reset request"
    annotation (Placement(transformation(extent={{-940,-320},{-900,-280}}),
      iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput chiPlaReq
    "Number of chiller plant cooling requests"
    annotation (Placement(transformation(extent={{-940,-360},{-900,-320}}),
      iconTransformation(extent={{-140,-180},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum),
    final unit=fill("1", nConWatPum)) if not have_airCoo
    "Current condenser water pump speed"
    annotation(Placement(transformation(extent={{-940,-400},{-900,-360}}),
        iconTransformation(extent={{-140,-200},{-100,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[nConWatPum]
    if not have_airCoo
    "Condenser water pump status"
    annotation (Placement(transformation(extent={{-940,-430},{-900,-390}}),
      iconTransformation(extent={{-140,-220},{-100,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPlaSchEna
    "Plant schedule enable: true=Enable"
    annotation (Placement(transformation(extent={{-940,-500},{-900,-460}}),
        iconTransformation(extent={{-140,-240},{-100,-200}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-940,-540},{-900,-500}}),
      iconTransformation(extent={{-140,-260},{-100,-220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatTowRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if have_conWatRetCon and not have_airCoo
    "Condenser water return temperature (condenser leaving) to the cooling tower"
    annotation (Placement(transformation(extent={{-942,-648},{-902,-608}}),
        iconTransformation(extent={{-140,-310},{-100,-270}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if not closeCoupledPlant and not have_airCoo
    "Condenser water supply temperature (condenser entering)"
    annotation(Placement(transformation(extent={{-940,-680},{-900,-640}}),
      iconTransformation(extent={{-140,-330},{-100,-290}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoVal[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel)) if not have_airCoo
    "Vector of tower cells isolation valve position"
    annotation(Placement(transformation(extent={{-940,-728},{-900,-688}}),
      iconTransformation(extent={{-140,-360},{-100,-320}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput watLev(
    final unit="m") if not have_airCoo
    "Measured water level"
    annotation (Placement(transformation(extent={{-940,-760},{-900,-720}}),
      iconTransformation(extent={{-140,-380},{-100,-340}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cell proven on status: true=running tower cell"
    annotation(Placement(transformation(extent={{-940,-800},{-900,-760}}),
      iconTransformation(extent={{-140,-400},{-100,-360}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEcoConWatIsoVal if have_WSE
    "Economizer condenser water isolation valve position"
    annotation (Placement(transformation(extent={{920,760},{960,800}}),
        iconTransformation(extent={{100,370},{140,410}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yWseRetVal(
    final min=0,
    final max=1,
    final unit="1") if have_byPasValCon and have_WSE
    "WSE in-line CHW return line valve position"
    annotation (Placement(transformation(extent={{920,730},{960,770}}),
        iconTransformation(extent={{100,338},{140,378}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yWsePumOn
    if have_WSE and not have_byPasValCon
    "Heat exchanger pump command on"
    annotation (Placement(transformation(extent={{920,700},{960,740}}),
        iconTransformation(extent={{100,310},{140,350}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1WseChiWatBypVal
    if have_WSE and have_priOnl and have_parChi and not have_airCoo
    "Ecnomizer-only chiller water bypass valve commanded status"
    annotation (Placement(transformation(extent={{922,640},{962,680}}),
        iconTransformation(extent={{100,270},{140,310}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yWsePumSpe(
    final min=0,
    final unit="1",
    final max=1) if have_WSE and not have_byPasValCon and not have_airCoo
    "Heat exchanger pump speed setpoint"
    annotation (Placement(transformation(extent={{920,670},{960,710}}),
        iconTransformation(extent={{100,290},{140,330}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet[nChi](
    final unit=fill("K", nChi),
    displayUnit=fill("degC", nChi),
    final quantity=fill("ThermodynamicTemperature", nChi))
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{920,600},{960,640}}),
        iconTransformation(extent={{100,240},{140,280}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpChiWatPumSet[nSenChiWatPum](
    final quantity=fill("PressureDifference", nSenChiWatPum),
    final unit=fill("Pa", nSenChiWatPum)) if not have_locSenChiWatPum
    "Chilled water differential pressure setpoint for the remote sensors"
    annotation (Placement(transformation(extent={{920,570},{960,610}}),
        iconTransformation(extent={{100,208},{140,248}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiWatPum[nChiWatPum]
    if have_heaChiWatPum
    "Chilled water pump status setpoint"
    annotation(Placement(transformation(extent={{920,520},{960,560}}),
      iconTransformation(extent={{100,180},{140,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiPumSpe[nChiWatPum](
    final min=fill(0,nChiWatPum),
    final max=fill(1,nChiWatPum),
    final unit=fill("1",nChiWatPum)) "Chilled water pump speed setpoint"
    annotation (Placement(transformation(extent={{920,460},{960,500}}),
      iconTransformation(extent={{100,150},{140,190}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem[nChi](
    final quantity=fill("ElectricCurrent",nChi),
    final unit=fill("A", nChi)) if have_priOnl or use_loadShed
    "Chiller demand setpoint to set through BACnet or similar "
    annotation(Placement(transformation(extent={{920,400},{960,440}}),
      iconTransformation(extent={{100,120},{140,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller commanded setpoint"
    annotation(Placement(transformation(extent={{920,330},{960,370}}),
      iconTransformation(extent={{100,90},{140,130}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ConWatIsoVal[nChi] if (not
    have_airCoo) and have_heaConWatPum and (have_heaPreConSig or (not
    have_fixSpeConWatPum and not have_WSE))
    "Chiller condenser water isolation valve commanded setpoint"
    annotation (Placement(transformation(extent={{920,260},{960,300}}),
        iconTransformation(extent={{100,62},{140,102}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi)) if (not have_airCoo) and have_heaConWatPum and
    not (have_heaPreConSig or (not have_fixSpeConWatPum and not have_WSE))
    "Condenser water isolation valve position"
    annotation (Placement(transformation(extent={{920,220},{960,260}}),
      iconTransformation(extent={{100,30},{140,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpe[nConWatPum](
    final unit=fill("1", nConWatPum),
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum))
    if (not have_airCoo) and not have_fixSpeConWatPum
    "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{920,130},{960,170}}),
        iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinFloSet(
    final quantity="VolumeFlowRate",
    final unit="m3/s",
    final min=0) "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{920,100},{960,140}}),
      iconTransformation(extent={{100,-28},{140,12}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatPum[nConWatPum]
    if not have_airCoo
    "Condenser water pump commanded on"
    annotation (Placement(transformation(extent={{920,70},{960,110}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi))
    "Chiller isolation valve position setpoints"
    annotation (Placement(transformation(extent={{920,-50},{960,-10}}),
        iconTransformation(extent={{100,-120},{140,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yReaChiDemLim
    if have_priOnl or use_loadShed
    "Release chiller demand limit, normally true"
    annotation (Placement(transformation(extent={{920,-230},{960,-190}}),
        iconTransformation(extent={{100,-90},{140,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinValPosSet(
    final min=0,
    final max=1,
    final unit="1")
    "Chilled water minimum flow bypass valve position setpoint"
    annotation (Placement(transformation(extent={{920,-340},{960,-300}}),
        iconTransformation(extent={{100,-150},{140,-110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowCelIsoVal[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel)) if not have_airCoo
    "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{920,-640},{960,-600}}),
      iconTransformation(extent={{100,-200},{140,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowCel[nTowCel]
    if not have_airCoo
    "Vector of tower cells status setpoint"
    annotation(Placement(transformation(extent={{920,-680},{960,-640}}),
      iconTransformation(extent={{100,-230},{140,-190}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowFanSpe[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel)) if not have_airCoo
    "Fan speed setpoint of each cooling tower cell"
    annotation (Placement(transformation(extent={{920,-720},{960,-680}}),
      iconTransformation(extent={{100,-260},{140,-220}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMakUp if not have_airCoo
    "Makeup water valve On-Off status"
    annotation(Placement(transformation(extent={{920,-780},{960,-740}}),
      iconTransformation(extent={{100,-290},{140,-250}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Controller wseSta(
    final have_byPasValCon=have_byPasValCon,
    final have_priOnl=have_priOnl,
    final have_parChi=have_parChi,
    final nChi=nChi,
    final nSta=nSta,
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
    final wseOnTimInc=wseOnTimInc,
    final dpDes=dpDes,
    final valCon=ecoValCon,
    final k=kEcoVal,
    final Ti=TiEcoVal,
    final Td=TdEcoVal,
    final minSpe=minEcoSpe) if have_WSE and not have_airCoo
    "Waterside economizer (WSE) enable/disable status"
    annotation(Placement(transformation(extent={{-700,300},{-660,356}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.PlantEnable.Enable plaEna(
    final TChiLocOut=TChiLocOut,
    final plaThrTim=plaThrTim,
    final reqThrTim=reqThrTim,
    final ignReq=ignReq,
    final locDt=locDt) "Sequence to enable and disable plant"
    annotation (Placement(transformation(extent={{-700,-520},{-660,-480}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.HeadPressure.Controller
    heaPreCon[nChi](
    final have_fixSpeConWatPum=fill(have_fixSpeConWatPum, nChi),
    final have_heaPreConSig=fill(have_heaPreConSig, nChi),
    final have_WSE=fill(have_WSE and not have_airCoo, nChi),
    final minTowSpe=fill(fanSpeMin, nChi),
    final minConWatPumSpe=fill(minConWatPumSpe, nChi),
    final minHeaPreValPos=fill(minHeaPreValPos, nChi),
    final controllerType=fill(controllerTypeHeaPre, nChi),
    final minChiLif=dTChiMinLif,
    final k=fill(kHeaPreCon, nChi),
    final Ti=fill(TiHeaPreCon, nChi)) if not have_airCoo
    "Chiller head pressure controller"
    annotation (Placement(transformation(extent={{-520,180},{-480,220}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.MinimumFlowBypass.Controller minBypValCon(
    final nChi=nChi,
    final minFloSet=minFloSet,
    final controllerType=controllerTypeMinFloByp,
    final k=kMinFloBypCon,
    final Ti=TiMinFloBypCon,
    final Td=TdMinFloBypCon,
    final yMax=yMaxFloBypCon,
    final yMin=yMinFloBypCon)
    "Controller for chilled water minimum flow bypass valve"
    annotation (Placement(transformation(extent={{-680,-160},{-640,-120}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Controller chiWatPumCon(
    final have_heaPum=have_heaChiWatPum,
    final have_locSen=have_locSenChiWatPum,
    final have_WSE=have_WSE and not have_airCoo,
    final nChi=nChi,
    final nPum=nChiWatPum,
    final nSen=nSenChiWatPum,
    final minPumSpe=minChiWatPumSpe,
    final maxPumSpe=maxChiWatPumSpe,
    final nPum_nominal=nPum_nominal,
    final VChiWat_flow_nominal=VChiWat_flow_nominal,
    final controllerType=controllerTypeChiWatPum,
    final k=kChiWatPum,
    final Ti=TiChiWatPum,
    final Td=TdChiWatPum)
    "Sequences to control chilled water pumps in primary-only plant system"
    annotation(Placement(transformation(extent={{420,462},{480,552}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.SetPoints.ChilledWaterPlantReset chiWatPlaRes(
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
    annotation(Placement(transformation(extent={{-700,-320},{-660,-280}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.SetPoints.ChilledWaterSupply chiWatSupSet(
    final nRemDpSen=nSenChiWatPum,
    final dpChiWatMin=dpChiWatMin,
    final dpChiWatMax=dpChiWatMax,
    final TChiWatSupMin=TChiWatSupMin_Lowest,
    final TPlaChiWatSupMax=TPlaChiWatSupMax,
    final minSet=minSet,
    final maxSet=maxSet,
    final halSet=halSet)
    "Sequences to generate setpoints of chilled water supply temperature and the pump differential static pressure"
    annotation(Placement(transformation(extent={{-520,420},{-480,460}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.SetPoints.SetpointController staSetCon(
    final have_WSE=have_WSE and not have_airCoo,
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
    annotation(Placement(transformation(extent={{-260,-68},{-180,100}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Controller towCon(
    final nChi=nChi,
    final totSta=totSta,
    final nTowCel=nTowCel,
    final nConWatPum=nConWatPum,
    final fanSpeCon=fanSpeCon,
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
    final minChiLif=dTChiMinLif,
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
    final watLevMax=watLevMax) if not have_airCoo
    "Cooling tower controller"
    annotation (Placement(transformation(extent={{-260,-720},{-180,-560}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Down dowProCon(
    final nChi=nChi,
    final nConWatPum=nConWatPum,
    final totSta=totSta,
    final nChiSta=nSta + 1,
    final have_airCoo=have_airCoo,
    final have_WSE=have_WSE,
    final have_ponyChiller=have_ponyChiller,
    final have_parChi=have_parChi,
    final have_heaConWatPum=have_heaConWatPum,
    final have_fixSpeConWatPum=have_fixSpeConWatPum,
    final need_reduceChillerDemand=have_priOnl or use_loadShed,
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
    annotation(Placement(transformation(extent={{180,-300},{260,-140}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Up upProCon(
    final nChi=nChi,
    final nConWatPum=nConWatPum,
    final totSta=totSta,
    final nChiSta=nSta + 1,
    final have_airCoo=have_airCoo,
    final have_WSE=have_WSE,
    final have_ponyChiller=have_ponyChiller,
    final have_parChi=have_parChi,
    final have_heaConWatPum=have_heaConWatPum,
    final have_fixSpeConWatPum=have_fixSpeConWatPum,
    final need_reduceChillerDemand=have_priOnl or use_loadShed,
    final delayStaCha=delayStaCha,
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
    annotation(Placement(transformation(extent={{180,280},{260,440}})));

  Buildings.Controls.OBC.CDL.Reals.MultiMax mulMax(
    final nin=nTowCel) if have_WSE and not have_airCoo
    "All input values are the same"
    annotation(Placement(transformation(extent={{-60,-590},{-40,-570}})));

  Buildings.Controls.OBC.CDL.Logical.Or chaProUpDown
    "Either in staging up or in staging down process"
    annotation(Placement(transformation(extent={{380,-90},{400,-70}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Check if stage change is finished"
    annotation(Placement(transformation(extent={{480,-90},{500,-70}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nChiWatPum)
    "Check if there is any chilled water pump is enabled"
    annotation(Placement(transformation(extent={{-740,-134},{-720,-114}})));

  Buildings.Controls.OBC.CDL.Reals.MultiMax conWatPumSpe(
    final nin=nConWatPum) if not have_fixSpeConWatPum and not have_airCoo
    "Running condenser water pump speed"
    annotation (Placement(transformation(extent={{-660,-390},{-640,-370}})));

  Buildings.Controls.OBC.CDL.Logical.Or staCooTow if not have_airCoo
    "Tower stage change status: true=stage cooling tower"
    annotation (Placement(transformation(extent={{480,-130},{500,-110}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nChi) if have_WSE and not have_airCoo
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-620,240},{-600,260}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator chiWatSupTem(
    final nout=nChi) if not have_heaPreConSig and not have_airCoo
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-680,194},{-660,214}})));

  Buildings.Controls.OBC.CDL.Reals.Switch desConWatPumSpeSwi
    if not have_fixSpeConWatPum and not have_airCoo
    "Design condenser water pump speed"
    annotation (Placement(transformation(extent={{480,190},{500,210}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator desConPumSpe(
    final nout=nChi) if not have_fixSpeConWatPum and not have_airCoo
    "Replicate design condenser water pump speed"
    annotation (Placement(transformation(extent={{540,190},{560,210}})));

  Buildings.Controls.OBC.CDL.Reals.MultiMax mulMax1(
    final nin=nChi) if not have_fixSpeConWatPum and not have_airCoo
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-460,150},{-440,170}})));

  Buildings.Controls.OBC.CDL.Reals.Switch chiMinFloSet
    "Chiller water minimum flow setpoint"
    annotation (Placement(transformation(extent={{480,110},{500,130}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator uChiSwi(
    final nout=nChi)
    "In chiller stage up process"
    annotation (Placement(transformation(extent={{460,340},{480,360}})));

  Buildings.Controls.OBC.CDL.Logical.Switch chiComSta[nChi]
    "Chiller commanded status"
    annotation (Placement(transformation(extent={{640,340},{660,360}})));

  Buildings.Controls.OBC.CDL.Logical.Pre preConPumLeaSta if not have_airCoo
    "Lead condenser water pump status from previous step"
    annotation (Placement(transformation(extent={{480,-260},{500,-240}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[nChiWatPum](
    final k=chiPumLeaLag) if have_heaChiWatPum
    "Chilled water pump lead and lag index"
    annotation (Placement(transformation(extent={{360,550},{380,570}})));

  Buildings.Controls.OBC.CDL.Logical.Latch chiStaUp
    "In chiller stage up process"
    annotation (Placement(transformation(extent={{380,310},{400,330}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2 if not have_airCoo
    "Stage cooling tower"
    annotation (Placement(transformation(extent={{100,-510},{120,-490}})));

  Buildings.Controls.OBC.CDL.Logical.Switch chiHeaCon[nChi] if not have_airCoo
    "Chiller head control enabling status"
    annotation (Placement(transformation(extent={{520,270},{540,290}})));

  Buildings.Controls.OBC.CDL.Integers.Switch conWatPumNum if not have_airCoo
    "Total number of enablded condenser water pump"
    annotation (Placement(transformation(extent={{440,10},{460,30}})));

  Buildings.Controls.OBC.CDL.Logical.Switch conPumLeaSta if not have_airCoo
    "Pick the condenser water pump lead status"
    annotation (Placement(transformation(extent={{440,-260},{460,-240}})));

  Buildings.Controls.OBC.CDL.Reals.Switch chiIsoVal[nChi]
    "Chiller isolation valve position setpoint"
    annotation (Placement(transformation(extent={{540,-40},{560,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Switch chiDem[nChi]
    if have_priOnl or use_loadShed
    "Chiller demand"
    annotation (Placement(transformation(extent={{640,410},{660,430}})));

  Buildings.Controls.OBC.CDL.Logical.Switch relDem if have_priOnl or use_loadShed
    "Release chiller demand limit"
    annotation (Placement(transformation(extent={{480,-220},{500,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Pre preChaPro
    "Stage changing process status from previous step"
    annotation (Placement(transformation(extent={{440,-90},{460,-70}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator chiWatPumSpe(
    final nout=nChiWatPum) "Chilled water pump speed"
    annotation (Placement(transformation(extent={{580,450},{600,470}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChiWatPum]
    "Boolean to real"
    annotation (Placement(transformation(extent={{580,490},{600,510}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro[nChiWatPum]
    "Chilled water pump speed setpoint"
    annotation (Placement(transformation(extent={{640,470},{660,490}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro1[nConWatPum]
    if not have_fixSpeConWatPum and not have_airCoo
    "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{660,140},{680,160}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator conWatPumSpe1(
    final nout=nConWatPum) if not have_fixSpeConWatPum and not have_airCoo
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{590,140},{610,160}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nConWatPum]
    if not have_fixSpeConWatPum and not have_airCoo
    "Boolean to real"
    annotation (Placement(transformation(extent={{580,50},{600,70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3[nChi]
    if not have_airCoo
    "Boolean to real"
    annotation (Placement(transformation(extent={{580,250},{600,270}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro4[nChi] if not have_airCoo
    "Head pressure control valve position"
    annotation (Placement(transformation(extent={{660,230},{680,250}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fulOpeVal[nChi](
    final k=fill(1, nChi))
    if not have_WSE and not have_fixSpeConWatPum and not have_airCoo
    "Full open head pressure control valve"
    annotation (Placement(transformation(extent={{240,180},{260,200}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.PlantEnable.EnableDevices enaDev(
    final nSta=nSta,
    final nChiWatPum=nChiWatPum,
    final nConWatPum=nConWatPum,
    final iniPumDel=iniPumDel,
    final have_airCoo=have_airCoo)
    "Enable devices when plant is enabled"
    annotation (Placement(transformation(extent={{-540,-440},{-520,-420}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.PlantEnable.DisableChillers disChi(
    final have_airCoo=have_airCoo,
    final have_WSE=have_WSE,
    final nChi=nChi,
    final nChiWatPum=nChiWatPum,
    final nConWatPum=nConWatPum,
    final nTowCel=nTowCel,
    final have_fixSpeConWatPum=have_fixSpeConWatPum)
    "Disable devices when plant is disabled"
    annotation (Placement(transformation(extent={{740,-480},{760,-460}})));

  Buildings.Controls.OBC.CDL.Logical.And celCom[nTowCel] if not have_airCoo
    "False: disable tower cell"
    annotation (Placement(transformation(extent={{840,-670},{860,-650}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi[nTowCel] if not have_airCoo
    "Tower cell isolation valve position setpoint"
    annotation (Placement(transformation(extent={{880,-630},{900,-610}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1[nTowCel](
    final k=fill(0, nTowCel)) if not have_airCoo
    "Constant zero"
    annotation (Placement(transformation(extent={{700,-590},{720,-570}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi1[nTowCel] if not have_airCoo
    "Tower cell fan speed setpoint"
    annotation (Placement(transformation(extent={{880,-710},{900,-690}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.IdentifyStage ideSta(
    final nSta=nSta,
    final nChi=nChi,
    final staMat=staMat)
    "Identify stage index"
    annotation (Placement(transformation(extent={{-520,120},{-500,140}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep3(
    final nout=nTowCel) if not have_airCoo
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{780,-590},{800,-570}})));

  Buildings.Controls.OBC.CDL.Psychrometrics.WetBulb_TDryBulPhi wetBul
    if have_WSE and not have_airCoo
    "Wet bulb temperature"
    annotation (Placement(transformation(extent={{-860,360},{-840,380}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator supTem(
    final nout=nChi)
    "Chiller water supply setpoint temperature"
    annotation (Placement(transformation(extent={{800,610},{820,630}})));

protected

  final parameter Real Cp(
    final quantity="SpecificHeatCapacity") = 4198
    "Water specific heat capacity";
  final parameter Real rho(
    final quantity="Density") = 1000
    "Water density";

  final parameter Integer chiPumLeaLag[nChiWatPum]={i for i in 1:nChiWatPum}
    "Chiller water pump lead and lag index, {1,2,...,n}, with first one as lead pump";

  final parameter Integer conPumLeaLag[nConWatPum]={i for i in 1:nConWatPum}
    "Condenser water pump lead and lag index, {1,2,...,n}, with first one as lead pump";

  final parameter Boolean anyVsdCen = sum({
    if chiTyp[i]==Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.ChillersAndStages.VariableSpeedCentrifugal
      then 1 else 0 for i in 1:nChi}) > 0
    "Plant contains at least one variable speed centrifugal chiller";

  final parameter Boolean have_serChi = not have_parChi
    "true = series chillers plant; false = parallel chillers plant"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  final parameter Real TChiWatSupMin_Lowest(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=min(TChiWatSupMin)
    "Minimum chilled water supply temperature. This is the lowest minimum chilled water supply temperature of chillers in the plant";

  final parameter Real desCap(unit="W")=sum(chiDesCap)
    "Plant design capacity";

  Buildings.Controls.OBC.CDL.Integers.LessEqual enaConWatPum[nConWatPum]
    if not have_airCoo
    "Check if a condenser water pump should be enabled"
    annotation (Placement(transformation(extent={{540,50},{560,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conPum[nConWatPum](
    final k=conPumLeaLag) if not have_airCoo
    "Condenser water pumps lead lag order"
    annotation (Placement(transformation(extent={{480,50},{500,70}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=nConWatPum) if not have_airCoo
    "Duplicate to total number of condenser water pump"
    annotation (Placement(transformation(extent={{480,10},{500,30}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.ChillerLifts chiLif(
    final nChi=nChi,
    final minChiLif=dTChiMinLif,
    final maxChiLif=dTChiMaxLif)
    "Average lifts of the enabled chillers"
    annotation (Placement(transformation(extent={{-500,360},{-480,380}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub if have_WSE and not have_airCoo
    "Temperature difference"
    annotation (Placement(transformation(extent={{-558,-550},{-538,-530}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(final k=rho*Cp)
    if have_WSE and not have_airCoo
    "Find product of the inputs"
    annotation (Placement(transformation(extent={{-560,-630},{-540,-610}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul if have_WSE and not have_airCoo
    "Find product of the inputs"
    annotation (Placement(transformation(extent={{-460,-520},{-440,-500}})));

equation
  connect(staSetCon.uPla, plaEna.yPla) annotation(Line(points={{-268,72},{-580,72},
          {-580,-500},{-658,-500}}, color={255,0,255}));
  connect(TChiWatRetDow, wseSta.TChiWatRetDow) annotation(Line(points={{-920,320},
          {-840,320},{-840,346},{-704,346}},      color={0,0,127}));
  connect(chiWatSupSet.TChiWatSupSet, staSetCon.TChiWatSupSet) annotation(Line(
        points={{-476,428},{-380,428},{-380,48},{-268,48}},     color={0,0,127}));
  connect(TChiWatSup, staSetCon.TChiWatSup) annotation(Line(points={{-920,210},{
          -840,210},{-840,40},{-268,40}},        color={0,0,127}));
  connect(VChiWat_flow, minBypValCon.VChiWat_flow) annotation(Line(points={{-920,
          440},{-880,440},{-880,-140},{-684,-140}},    color={0,0,127}));
  connect(TChiWatRet, staSetCon.TChiWatRet) annotation(Line(points={{-920,280},{
          -860,280},{-860,-48},{-268,-48}}, color={0,0,127}));
  connect(staSetCon.TWsePre, wseSta.TWsePre) annotation(Line(points={{-268,-56},
          {-420,-56},{-420,346},{-656,346}}, color={0,0,127}));
  connect(VChiWat_flow, staSetCon.VChiWat_flow) annotation(Line(points={{-920,440},
          {-880,440},{-880,-64},{-268,-64}}, color={0,0,127}));
  connect(TChiWatSupResReq, chiWatPlaRes.TChiWatSupResReq)
    annotation (Line(points={{-920,-300},{-704,-300}}, color={255,127,0}));
  connect(chiWatPlaRes.yChiWatPlaRes, chiWatSupSet.uChiWatPlaRes) annotation (
      Line(points={{-656,-300},{-540,-300},{-540,440},{-524,440}}, color={0,0,127}));
  connect(wseSta.y, staSetCon.uWseSta) annotation(Line(points={{-656,334},{-630,
          334},{-630,96},{-268,96}}, color={255,0,255}));
  connect(wseSta.y, towCon.uWse) annotation(Line(points={{-656,334},{-630,334},{
          -630,-580},{-268,-580}}, color={255,0,255}));
  connect(plaEna.yPla, towCon.uPla) annotation(Line(points={{-658,-500},{-580,-500},
          {-580,-636},{-268,-636}}, color={255,0,255}));
  connect(wetBul.TWetBul, staSetCon.TOutWet) annotation(Line(points={{-838,370},
          {-756,370},{-756,-20},{-268,-20}}, color={0,0,127}));
  connect(mulMax.y, staSetCon.uTowFanSpeMax) annotation(Line(points={{-38,-580},
          {0,-580},{0,-360},{-780,-360},{-780,-36},{-268,-36}},
        color={0,0,127}));
  connect(staSetCon.ySta, upProCon.uStaSet) annotation(Line(points={{-172,-24},{
          -140,-24},{-140,436},{172,436}}, color={255,127,0}));
  connect(staSetCon.ySta, dowProCon.uStaSet) annotation(Line(points={{-172,-24},
          {-140,-24},{-140,-144},{172,-144}}, color={255,127,0}));
  connect(staSetCon.yChiSet, upProCon.uChiSet) annotation(Line(points={{-172,4},
          {-130,4},{-130,424},{172,424}}, color={255,0,255}));
  connect(staSetCon.yChiSet, dowProCon.uChiSet) annotation(Line(points={{-172,4},
          {-130,4},{-130,-152},{172,-152}},  color={255,0,255}));
  connect(upProCon.yStaPro, chaProUpDown.u1) annotation(Line(points={{268,436},{
          330,436},{330,-80},{378,-80}}, color={255,0,255}));
  connect(dowProCon.yStaPro, chaProUpDown.u2) annotation(Line(points={{268,-144},
          {340,-144},{340,-88},{378,-88}}, color={255,0,255}));
  connect(uChi, dowProCon.uChi) annotation(Line(points={{-920,400},{-800,400},{-800,
          -184},{172,-184}}, color={255,0,255}));
  connect(mulMax.y, wseSta.uTowFanSpeMax) annotation(Line(points={{-38,-580},{0,
          -580},{0,-360},{-780,-360},{-780,338},{-704,338}},       color={0,0,127}));
  connect(towCon.yMakUp, yMakUp) annotation(Line(points={{-172,-708},{-140,-708},
          {-140,-760},{940,-760}}, color={255,0,255}));
  connect(uChiWatPum, chiWatPlaRes.uChiWatPum) annotation(Line(points={{-920,574},
          {-790,574},{-790,-288},{-704,-288}},
        color={255,0,255}));
  connect(mulOr.y, minBypValCon.uChiWatPum) annotation(Line(points={{-718,-124},
          {-684,-124}}, color={255,0,255}));
  connect(uChiWatPum, mulOr.u) annotation(Line(points={{-920,574},{-790,574},{-790,
          -124},{-742,-124}}, color={255,0,255}));
  connect(staSetCon.yOpeParLoaRatMin, dowProCon.yOpeParLoaRatMin) annotation (
      Line(points={{-172,-52.8},{-120,-52.8},{-120,-168},{172,-168}}, color=
          {0,0,127}));
  connect(uChi, upProCon.uChi) annotation(Line(points={{-920,400},{172,400}},
          color={255,0,255}));
  connect(wseSta.y, upProCon.uWSE) annotation(Line(points={{-656,334},{-630,334},
          {-630,344},{172,344}}, color={255,0,255}));
  connect(wseSta.y, dowProCon.uWSE) annotation(Line(points={{-656,334},{-630,334},
          {-630,-272},{172,-272}},     color={255,0,255}));
  connect(dowProCon.VChiWat_flow, VChiWat_flow) annotation(Line(points={{172,-192},
          {-880,-192},{-880,440},{-920,440}},color={0,0,127}));
  connect(VChiWat_flow, chiWatPumCon.VChiWat_flow) annotation(Line(points={{-920,
          440},{-880,440},{-880,494.143},{414,494.143}}, color={0,0,127}));
  connect(dpChiWat_remote, chiWatPumCon.dpChiWat_remote) annotation(Line(
        points={{-920,470},{-770,470},{-770,471.643},{414,471.643}}, color={0,0,127}));
  connect(TChiWatSup, towCon.TChiWatSup) annotation(Line(points={{-920,210},{-840,
          210},{-840,-596},{-268,-596}},     color={0,0,127}));
  connect(chiWatSupSet.TChiWatSupSet, towCon.TChiWatSupSet) annotation(Line(
        points={{-476,428},{-380,428},{-380,-604},{-268,-604}},color={0,0,127}));
  connect(dowProCon.uChiWatIsoVal, uChiWatIsoVal) annotation(Line(points={{172,-228},
          {-920,-228}},  color={0,0,127}));
  connect(uChiWatIsoVal, upProCon.uChiWatIsoVal) annotation(Line(points={{-920,-228},
          {110,-228},{110,292},{172,292}},   color={0,0,127}));
  connect(chiWatSupSet.dpChiWatPumSet, chiWatPumCon.dpChiWatSet_remote)
    annotation (Line(points={{-476,452},{-370,452},{-370,465.214},{414,465.214}},
          color={0,0,127}));
  connect(uChiAva, staSetCon.uChiAva) annotation(Line(points={{-920,80},{-268,80}},
          color={255,0,255}));
  connect(minBypValCon.yValPos, yMinValPosSet) annotation (Line(points={{-636,-140},
          {-480,-140},{-480,-320},{940,-320}}, color={0,0,127}));
  connect(staSetCon.ySta, towCon.uChiStaSet) annotation(Line(points={{-172,-24},
          {-140,-24},{-140,-120},{-330,-120},{-330,-684},{-268,-684}},
        color={255,127,0}));
  connect(TConWatSup, towCon.TConWatSup) annotation(Line(points={{-920,-660},{-268,
          -660}}, color={0,0,127}));
  connect(watLev, towCon.watLev) annotation (Line(points={{-920,-740},{-300,-740},
          {-300,-716},{-268,-716}}, color={0,0,127}));
  connect(towCon.uIsoVal, uIsoVal) annotation(Line(points={{-268,-708},{-920,-708}},
          color={0,0,127}));
  connect(uTowSta, towCon.uTowSta) annotation (Line(points={{-920,-780},{-440,-780},
          {-440,-628},{-268,-628}}, color={255,0,255}));
  connect(uConWatPumSpe, conWatPumSpe.u) annotation (Line(points={{-920,-380},{-662,
          -380}}, color={0,0,127}));
  connect(uConWatPumSpe, towCon.uConWatPumSpe) annotation (Line(points={{-920,-380},
          {-820,-380},{-820,-652},{-268,-652}}, color={0,0,127}));
  connect(conWatPumSpe.y, dowProCon.uConWatPumSpe) annotation (Line(points={{-638,
          -380},{130,-380},{130,-288},{172,-288}}, color={0,0,127}));
  connect(conWatPumSpe.y, upProCon.uConWatPumSpe) annotation (Line(points={{-638,
          -380},{130,-380},{130,328},{172,328}},      color={0,0,127}));
  connect(wseSta.yTunPar, staSetCon.uTunPar) annotation (Line(points={{-656,340},
          {-640,340},{-640,-28},{-268,-28}}, color={0,0,127}));
  connect(TChiWatRet, wseSta.TChiWatRet) annotation (Line(points={{-920,280},{-860,
          280},{-860,350},{-704,350}}, color={0,0,127}));
  connect(upProCon.yTowStaUp, staCooTow.u1) annotation (Line(points={{268,388},{
          310,388},{310,-120},{478,-120}}, color={255,0,255}));
  connect(dowProCon.yTowStaDow, staCooTow.u2) annotation (Line(points={{268,-220},
          {380,-220},{380,-128},{478,-128}}, color={255,0,255}));
  connect(TOut, plaEna.TOut) annotation (Line(points={{-920,-520},{-830,-520},{-830,
          -508.4},{-704,-508.4}}, color={0,0,127}));
  connect(upProCon.uConWatReq, uConWatReq) annotation (Line(points={{172,352},{
          80,352},{80,610},{-920,610}}, color={255,0,255}));
  connect(upProCon.uChiWatReq, uChiWatReq) annotation (Line(points={{172,284},{
          90,284},{90,640},{-920,640}}, color={255,0,255}));
  connect(uChiWatReq, dowProCon.uChiWatReq) annotation (Line(points={{-920,640},
          {90,640},{90,-240},{172,-240}},   color={255,0,255}));
  connect(uConWatReq, dowProCon.uConWatReq) annotation (Line(points={{-920,610},
          {80,610},{80,-248},{172,-248}},   color={255,0,255}));
  connect(VChiWat_flow, upProCon.VChiWat_flow) annotation (Line(points={{-920,440},
          {-880,440},{-880,390.4},{172,390.4}}, color={0,0,127}));
  connect(wseSta.y, booRep.u) annotation (Line(points={{-656,334},{-630,334},{-630,
          250},{-622,250}}, color={255,0,255}));
  connect(booRep.y, heaPreCon.uWSE) annotation (Line(points={{-598,250},{-560,
          250},{-560,188},{-524,188}}, color={255,0,255}));
  connect(TChiWatSup, chiWatSupTem.u) annotation (Line(points={{-920,210},{-840,
          210},{-840,204},{-682,204}}, color={0,0,127}));
  connect(chiWatSupTem.y, heaPreCon.TChiWatSup) annotation (Line(points={{-658,204},
          {-524,204}}, color={0,0,127}));
  connect(upProCon.yDesConWatPumSpe, desConWatPumSpeSwi.u1) annotation (Line(
        points={{268,356},{360,356},{360,208},{478,208}}, color={0,0,127}));
  connect(dowProCon.yDesConWatPumSpe, desConWatPumSpeSwi.u3) annotation (Line(
        points={{268,-264},{360,-264},{360,192},{478,192}}, color={0,0,127}));
  connect(desConPumSpe.y, heaPreCon.desConWatPumSpe) annotation (Line(points={{
          562,200},{580,200},{580,240},{-532,240},{-532,196},{-524,196}}, color
        ={0,0,127}));
  connect(heaPreCon.uHeaPreCon, uHeaPreCon) annotation (Line(points={{-524,180},
          {-920,180}}, color={0,0,127}));
  connect(heaPreCon.yMaxTowSpeSet, towCon.uMaxSpeSet) annotation (Line(points={
          {-476,212},{-360,212},{-360,-620},{-268,-620}}, color={0,0,127}));
  connect(heaPreCon.yConWatPumSpeSet, mulMax1.u) annotation (Line(points={{-476,
          188},{-470,188},{-470,160},{-462,160}}, color={0,0,127}));
  connect(mulMax1.y, dowProCon.uConWatPumSpeSet) annotation (Line(points={{-438,
          160},{-400,160},{-400,-280},{172,-280}}, color={0,0,127}));
  connect(mulMax1.y, upProCon.uConWatPumSpeSet) annotation (Line(points={{-438,160},
          {-400,160},{-400,336},{172,336}}, color={0,0,127}));
  connect(upProCon.yChiWatMinFloSet, chiMinFloSet.u1) annotation (Line(points={{268,404},
          {350,404},{350,128},{478,128}}, color={0,0,127}));
  connect(dowProCon.yChiWatMinFloSet, chiMinFloSet.u3) annotation (Line(points={{268,
          -284},{350,-284},{350,112},{478,112}},       color={0,0,127}));
  connect(chiMinFloSet.y, minBypValCon.VChiWatSet_flow) annotation (Line(points={{502,120},
          {640,120},{640,-100},{-700,-100},{-700,-156},{-684,-156}},
        color={0,0,127}));
  connect(uChiSwi.y, chiComSta.u2)
    annotation (Line(points={{482,350},{638,350}}, color={255,0,255}));
  connect(upProCon.yChi, chiComSta.u1) annotation (Line(points={{268,292},{300,
          292},{300,380},{620,380},{620,358},{638,358}}, color={255,0,255}));
  connect(dowProCon.yChi, chiComSta.u3) annotation (Line(points={{268,-172},{
          620,-172},{620,342},{638,342}}, color={255,0,255}));
  connect(staSetCon.yCapReq, towCon.reqPlaCap) annotation (Line(points={{-172,-64},
          {-160,-64},{-160,-500},{-370,-500},{-370,-612},{-268,-612}}, color={0,0,127}));
  connect(chiStaUp.y, chiMinFloSet.u2) annotation (Line(points={{402,320},{420,320},
          {420,120},{478,120}}, color={255,0,255}));
  connect(upProCon.yStaPro, chiStaUp.u) annotation (Line(points={{268,436},{330,
          436},{330,320},{378,320}}, color={255,0,255}));
  connect(dowProCon.yStaPro, chiStaUp.clr) annotation (Line(points={{268,-144},{
          340,-144},{340,314},{378,314}},  color={255,0,255}));
  connect(VChiWat_flow, wseSta.VChiWat_flow) annotation (Line(points={{-920,440},
          {-880,440},{-880,342},{-704,342}}, color={0,0,127}));
  connect(pre2.y, towCon.uTowStaCha) annotation (Line(points={{122,-500},{180,
          -500},{180,-530},{-320,-530},{-320,-692},{-268,-692}}, color={255,0,255}));
  connect(staCooTow.y, pre2.u) annotation (Line(points={{502,-120},{590,-120},{
          590,-420},{90,-420},{90,-500},{98,-500}},    color={255,0,255}));
  connect(towCon.ySpeSet, mulMax.u) annotation (Line(points={{-172,-684},{-100,
          -684},{-100,-580},{-62,-580}}, color={0,0,127}));
  connect(chiStaUp.y, desConWatPumSpeSwi.u2) annotation (Line(points={{402,320},
          {420,320},{420,200},{478,200}}, color={255,0,255}));
  connect(chiStaUp.y, uChiSwi.u) annotation (Line(points={{402,320},{420,320},{420,
          350},{458,350}},     color={255,0,255}));
  connect(upProCon.yChiHeaCon, chiHeaCon.u1) annotation (Line(points={{268,324},
          {320,324},{320,288},{518,288}}, color={255,0,255}));
  connect(uChiSwi.y, chiHeaCon.u2) annotation (Line(points={{482,350},{510,350},
          {510,280},{518,280}}, color={255,0,255}));
  connect(dowProCon.yChiHeaCon, chiHeaCon.u3) annotation (Line(points={{268,-232},
          {320,-232},{320,272},{518,272}},       color={255,0,255}));
  connect(chiStaUp.y, conWatPumNum.u2) annotation (Line(points={{402,320},{420,320},
          {420,20},{438,20}},      color={255,0,255}));
  connect(upProCon.yConWatPumNum, conWatPumNum.u1) annotation (Line(points={{268,340},
          {370,340},{370,28},{438,28}},          color={255,127,0}));
  connect(dowProCon.yConWatPumNum, conWatPumNum.u3) annotation (Line(points={{268,
          -272},{370,-272},{370,12},{438,12}},     color={255,127,0}));
  connect(chiStaUp.y, conPumLeaSta.u2) annotation (Line(points={{402,320},{420,320},
          {420,-250},{438,-250}},      color={255,0,255}));
  connect(dowProCon.yLeaPum, conPumLeaSta.u3) annotation (Line(points={{268,-248},
          {380,-248},{380,-258},{438,-258}},       color={255,0,255}));
  connect(upProCon.yLeaPum, conPumLeaSta.u1) annotation (Line(points={{268,372},
          {290,372},{290,-242},{438,-242}}, color={255,0,255}));
  connect(conPumLeaSta.y, preConPumLeaSta.u)
    annotation (Line(points={{462,-250},{478,-250}}, color={255,0,255}));
  connect(chiMinFloSet.y, yChiWatMinFloSet)
    annotation (Line(points={{502,120},{940,120}}, color={0,0,127}));
  connect(uChiSwi.y, chiIsoVal.u2) annotation (Line(points={{482,350},{510,350},
          {510,-30},{538,-30}}, color={255,0,255}));
  connect(upProCon.yChiWatIsoVal, chiIsoVal.u1) annotation (Line(points={{268,304},
          {280,304},{280,-22},{538,-22}}, color={0,0,127}));
  connect(dowProCon.yChiWatIsoVal, chiIsoVal.u3) annotation (Line(points={{268,-204},
          {280,-204},{280,-38},{538,-38}}, color={0,0,127}));
  connect(uChiSwi.y, chiDem.u2) annotation (Line(points={{482,350},{510,350},{510,
          420},{638,420}},     color={255,0,255}));
  connect(upProCon.yChiDem, chiDem.u1) annotation (Line(points={{268,420},{430,420},
          {430,428},{638,428}},      color={0,0,127}));
  connect(dowProCon.yChiDem, chiDem.u3) annotation (Line(points={{268,-160},{430,
          -160},{430,412},{638,412}},     color={0,0,127}));
  connect(chiDem.y, yChiDem)
    annotation (Line(points={{662,420},{940,420}}, color={0,0,127}));
  connect(uConWatPum, upProCon.uConWatPum) annotation (Line(points={{-920,-410},
          {140,-410},{140,308},{172,308}}, color={255,0,255}));
  connect(uConWatPum, dowProCon.uConWatPum) annotation (Line(points={{-920,-410},
          {140,-410},{140,-296},{172,-296}}, color={255,0,255}));
  connect(desConWatPumSpeSwi.y, desConPumSpe.u)
    annotation (Line(points={{502,200},{538,200}}, color={0,0,127}));
  connect(dowProCon.yReaDemLim, relDem.u3) annotation (Line(points={{268,-188},{
          390,-188},{390,-218},{478,-218}}, color={255,0,255}));
  connect(upProCon.yStaPro, relDem.u1) annotation (Line(points={{268,436},{330,436},
          {330,-202},{478,-202}}, color={255,0,255}));
  connect(chiStaUp.y, relDem.u2) annotation (Line(points={{402,320},{420,320},{420,
          -210},{478,-210}}, color={255,0,255}));
  connect(relDem.y, yReaChiDemLim)
    annotation (Line(points={{502,-210},{940,-210}}, color={255,0,255}));
  connect(dpChiWat_local, chiWatPumCon.dpChiWat_local) annotation (Line(points={{-920,
          540},{-820,540},{-820,484.5},{414,484.5}}, color={0,0,127}));
  connect(dpChiWat_local, staSetCon.dpChiWatPum_local) annotation (Line(points={{-920,
          540},{-820,540},{-820,4},{-268,4}}, color={0,0,127}));
  connect(chiWatSupSet.dpChiWatPumSet, staSetCon.dpChiWatPumSet_remote)
    annotation (Line(points={{-476,452},{-370,452},{-370,-4},{-268,-4}}, color={
          0,0,127}));
  connect(dpChiWat_remote, staSetCon.dpChiWatPum_remote) annotation (Line(
        points={{-920,470},{-770,470},{-770,-12},{-268,-12}}, color={0,0,127}));
  connect(falEdg.u, preChaPro.y)
    annotation (Line(points={{478,-80},{462,-80}}, color={255,0,255}));
  connect(chaProUpDown.y, preChaPro.u)
    annotation (Line(points={{402,-80},{438,-80}}, color={255,0,255}));
  connect(preChaPro.y, chiWatPlaRes.chaPro) annotation (Line(points={{462,-80},{
          470,-80},{470,-330},{-720,-330},{-720,-312},{-704,-312}}, color={255,0,
          255}));
  connect(preChaPro.y, staSetCon.chaPro) annotation (Line(points={{462,-80},{470,
          -80},{470,-330},{-320,-330},{-320,88},{-268,88}}, color={255,0,255}));
  connect(uChiHeaCon, dowProCon.uChiHeaCon) annotation (Line(points={{-920,-80},
          {150,-80},{150,-216},{172,-216}}, color={255,0,255}));
  connect(uChiHeaCon, upProCon.uChiHeaCon) annotation (Line(points={{-920,-80},{
          150,-80},{150,300},{172,300}}, color={255,0,255}));
  connect(chiWatPumCon.yChiWatPum, booToRea.u) annotation (Line(points={{486,507},
          {540,507},{540,500},{578,500}}, color={255,0,255}));
  connect(chiWatPumCon.yPumSpe, chiWatPumSpe.u) annotation (Line(points={{486,
          474.857},{540,474.857},{540,460},{578,460}},
                                              color={0,0,127}));
  connect(chiWatPumCon.yChiWatPum, yChiWatPum) annotation (Line(points={{486,507},
          {540,507},{540,540},{940,540}}, color={255,0,255}));
  connect(booToRea.y, pro.u1) annotation (Line(points={{602,500},{620,500},{620,
          486},{638,486}}, color={0,0,127}));
  connect(chiWatPumSpe.y, pro.u2) annotation (Line(points={{602,460},{620,460},{
          620,474},{638,474}}, color={0,0,127}));
  connect(desConWatPumSpeSwi.y, conWatPumSpe1.u) annotation (Line(points={{502,200},
          {520,200},{520,150},{588,150}}, color={0,0,127}));
  connect(booToRea1.y, pro1.u2) annotation (Line(points={{602,60},{650,60},{650,
          144},{658,144}}, color={0,0,127}));
  connect(conWatPumSpe1.y, pro1.u1) annotation (Line(points={{612,150},{640,150},
          {640,156},{658,156}}, color={0,0,127}));
  connect(chiHeaCon.y, booToRea3.u) annotation (Line(points={{542,280},{560,280},
          {560,260},{578,260}}, color={255,0,255}));
  connect(booToRea3.y, pro4.u1) annotation (Line(points={{602,260},{640,260},{640,
          246},{658,246}}, color={0,0,127}));
  connect(heaPreCon.yHeaPreConVal, pro4.u2) annotation (Line(points={{-476,200},
          {-160,200},{-160,234},{658,234}}, color={0,0,127}));
  connect(fulOpeVal.y, pro4.u2) annotation (Line(points={{262,190},{272,190},{272,
          234},{658,234}}, color={0,0,127}));
  connect(plaEna.chiPlaReq, chiPlaReq) annotation (Line(points={{-704,-492},{-830,
          -492},{-830,-340},{-920,-340}}, color={255,127,0}));
  connect(uChi, towCon.uChi) annotation (Line(points={{-920,400},{-800,400},{-800,
          -572},{-268,-572}},      color={255,0,255}));
  connect(staSetCon.yIni, wseSta.uIni) annotation (Line(points={{-172,-16},{-150,
          -16},{-150,272},{-750,272},{-750,330},{-704,330}}, color={255,127,0}));
  connect(plaEna.yPla, wseSta.uPla) annotation (Line(points={{-658,-500},{-580,-500},
          {-580,72},{-760,72},{-760,334},{-704,334}}, color={255,0,255}));
  connect(dpChiWat, wseSta.dpChiWat) annotation (Line(points={{-920,110},{-730,110},
          {-730,322},{-704,322}}, color={0,0,127}));
  connect(uEcoPum, wseSta.uPum) annotation (Line(points={{-920,50},{-720,50},{-720,
          318},{-704,318}}, color={255,0,255}));
  connect(TEntHex, wseSta.TEntHex) annotation (Line(points={{-920,20},{-710,20},
          {-710,310},{-704,310}}, color={0,0,127}));
  connect(plaEna.yPla, enaDev.uPla) annotation (Line(points={{-658,-500},{-580,-500},
          {-580,-422},{-542,-422}}, color={255,0,255}));
  connect(staSetCon.yIni, enaDev.uIni) annotation (Line(points={{-172,-16},{-150,
          -16},{-150,-370},{-570,-370},{-570,-426},{-542,-426}}, color={255,127,0}));
  connect(staSetCon.ySta, enaDev.uChiSta) annotation (Line(points={{-172,-24},{-140,
          -24},{-140,-144},{-560,-144},{-560,-430},{-542,-430}},color={255,127,0}));
  connect(uConWatPum, enaDev.uConWatPum) annotation (Line(points={{-920,-410},{-590,
          -410},{-590,-438},{-542,-438}}, color={255,0,255}));
  connect(uChiWatPum, enaDev.uChiWatPum) annotation (Line(points={{-920,574},{-790,
          574},{-790,-434},{-542,-434}}, color={255,0,255}));
  connect(plaEna.yPla, chiWatPumCon.uPla) annotation (Line(points={{-658,-500},
          {-580,-500},{-580,542.357},{414,542.357}},color={255,0,255}));
  connect(enaDev.yLeaConPum, upProCon.uEnaPlaConPum) annotation (Line(points={{-518,
          -433},{-110,-433},{-110,364},{172,364}}, color={255,0,255}));
  connect(enaDev.yConWatIsoVal, upProCon.uEnaPlaConIso) annotation (Line(points={{-518,
          -426},{70,-426},{70,320},{172,320}},         color={255,0,255}));
  connect(enaDev.yLeaTowCel, towCon.uEnaPla) annotation (Line(points={{-518,-436},
          {-400,-436},{-400,-668},{-268,-668}}, color={255,0,255}));
  connect(wseSta.yRetVal,yWseRetVal)  annotation (Line(points={{-656,321.6},{-610,
          321.6},{-610,750},{940,750}}, color={0,0,127}));
  connect(wseSta.yPumOn, yWsePumOn) annotation (Line(points={{-656,316},{-600,316},
          {-600,720},{940,720}}, color={255,0,255}));
  connect(wseSta.yPumSpe, yWsePumSpe) annotation (Line(points={{-656,310},{-590,
          310},{-590,690},{940,690}}, color={0,0,127}));
  connect(chiComSta.y, disChi.uChi) annotation (Line(points={{662,350},{710,350},
          {710,-460},{738,-460}}, color={255,0,255}));
  connect(chiIsoVal.y, disChi.uChiWatIsoVal) annotation (Line(points={{562,-30},
          {660,-30},{660,-464},{738,-464}}, color={0,0,127}));
  connect(uChiWatReq, disChi.uChiWatReq) annotation (Line(points={{-920,640},{-810,
          640},{-810,-462},{738,-462}},      color={255,0,255}));
  connect(pro4.y, disChi.uConWatIsoVal) annotation (Line(points={{682,240},{700,
          240},{700,-468},{738,-468}}, color={0,0,127}));
  connect(disChi.yConWatIsoVal,yConWatIsoVal)  annotation (Line(points={{762,-466},
          {820,-466},{820,240},{940,240}},        color={0,0,127}));
  connect(disChi.yChiWatPumSpe, yChiPumSpe) annotation (Line(points={{762,-471},
          {830,-471},{830,480},{940,480}},  color={0,0,127}));
  connect(pro.y, disChi.uChiWatPumSpe) annotation (Line(points={{662,480},{720,480},
          {720,-472},{738,-472}},      color={0,0,127}));
  connect(pro1.y, disChi.uConWatPumSpe) annotation (Line(points={{682,150},{730,
          150},{730,-474},{738,-474}}, color={0,0,127}));
  connect(disChi.yConWatPumSpe, yConWatPumSpe) annotation (Line(points={{762,-474},
          {840,-474},{840,150},{940,150}},        color={0,0,127}));
  connect(towCon.yTowSta, celCom.u1)
    annotation (Line(points={{-172,-660},{838,-660}}, color={255,0,255}));
  connect(celCom.y, yTowCel)
    annotation (Line(points={{862,-660},{940,-660}}, color={255,0,255}));
  connect(swi.y, yTowCelIsoVal)
    annotation (Line(points={{902,-620},{940,-620}}, color={0,0,127}));
  connect(towCon.yIsoVal, swi.u1) annotation (Line(points={{-172,-620},{720,-620},
          {720,-612},{878,-612}}, color={0,0,127}));
  connect(con1.y, swi.u3) annotation (Line(points={{722,-580},{740,-580},{740,-628},
          {878,-628}}, color={0,0,127}));
  connect(swi1.y, yTowFanSpe)
    annotation (Line(points={{902,-700},{940,-700}}, color={0,0,127}));
  connect(con1.y, swi1.u3) annotation (Line(points={{722,-580},{740,-580},{740,-708},
          {878,-708}}, color={0,0,127}));
  connect(towCon.ySpeSet, swi1.u1) annotation (Line(points={{-172,-684},{-100,-684},
          {-100,-692},{878,-692}}, color={0,0,127}));
  connect(uChi, ideSta.uChi) annotation (Line(points={{-920,400},{-800,400},{-800,
          130},{-522,130}}, color={255,0,255}));
  connect(ideSta.ySta, staSetCon.uSta) annotation (Line(points={{-498,130},{-340,
          130},{-340,60},{-268,60}}, color={255,127,0}));
  connect(ideSta.ySta, towCon.uChiSta) annotation (Line(points={{-498,130},{-340,
          130},{-340,-676},{-268,-676}}, color={255,127,0}));
  connect(ideSta.ySta, dowProCon.uChiSta) annotation (Line(points={{-498,130},{-340,
          130},{-340,-204},{172,-204}}, color={255,127,0}));
  connect(ideSta.ySta, upProCon.uChiSta) annotation (Line(points={{-498,130},{-340,
          130},{-340,372},{172,372}}, color={255,127,0}));
  connect(staSetCon.ySta, wseSta.uChiSta) annotation (Line(points={{-172,-24},{-140,
          -24},{-140,280},{-740,280},{-740,326},{-704,326}}, color={255,127,0}));
  connect(chaProUpDown.y, disChi.chaPro) annotation (Line(points={{402,-80},{410,
          -80},{410,-476},{738,-476}},     color={255,0,255}));
  connect(chiComSta.y, yChi)
    annotation (Line(points={{662,350},{940,350}}, color={255,0,255}));
  connect(disChi.yTowCel, booScaRep3.u) annotation (Line(points={{762,-479},{
          770,-479},{770,-580},{778,-580}}, color={255,0,255}));
  connect(booScaRep3.y, celCom.u2) annotation (Line(points={{802,-580},{820,
          -580},{820,-668},{838,-668}}, color={255,0,255}));
  connect(booScaRep3.y, swi.u2) annotation (Line(points={{802,-580},{820,-580},
          {820,-620},{878,-620}}, color={255,0,255}));
  connect(booScaRep3.y, swi1.u2) annotation (Line(points={{802,-580},{820,-580},
          {820,-700},{878,-700}}, color={255,0,255}));
  connect(chiHeaCon.y, heaPreCon.uChiHeaCon) annotation (Line(points={{542,280},
          {560,280},{560,260},{-550,260},{-550,220},{-524,220}}, color={255,0,
          255}));
  connect(uChiWatIsoVal, chiWatPumCon.uChiWatIsoVal) annotation (Line(points={{-920,
          -228},{110,-228},{110,500.571},{414,500.571}}, color={0,0,127}));
  connect(wseSta.y, disChi.uWSE) annotation (Line(points={{-656,334},{-630,334},
          {-630,-480},{738,-480}}, color={255,0,255}));
  connect(wseSta.y, chiWatPumCon.uWse) annotation (Line(points={{-656,334},{
          -630,334},{-630,510.214},{414,510.214}}, color={255,0,255}));
  connect(staSetCon.yChiSet, upProCon.uChiConIsoVal) annotation (Line(points={{
          -172,4},{-130,4},{-130,380},{172,380}}, color={255,0,255}));
  connect(staSetCon.yChiSet, dowProCon.uChiConIsoVal) annotation (Line(points={
          {-172,4},{-130,4},{-130,-260},{172,-260}}, color={255,0,255}));
  connect(wetBul.TWetBul, wseSta.TOutWet) annotation (Line(points={{-838,370},{-756,
          370},{-756,354},{-704,354}}, color={0,0,127}));
  connect(TOut, wetBul.TDryBul) annotation (Line(points={{-920,-520},{-888,-520},
          {-888,376},{-862,376}}, color={0,0,127}));
  connect(phi, wetBul.phi) annotation (Line(points={{-920,360},{-868,360},{-868,
          364},{-862,364}}, color={0,0,127}));
  connect(conInt1.y, chiWatPumCon.uPumLeaLag) annotation (Line(points={{382,560},
          {400,560},{400,548.786},{414,548.786}}, color={255,127,0}));
  connect(uChiWatPum, chiWatPumCon.uChiWatPum) annotation (Line(points={{-920,
          574},{-790,574},{-790,535.929},{414,535.929}}, color={255,0,255}));
  connect(uChiWatIsoVal, wseSta.uChiIsoVal) annotation (Line(points={{-920,-228},
          {-764,-228},{-764,302},{-704,302}}, color={0,0,127}));
  connect(disChi.y1ChiWatIsoVal, wseSta.u1ChiIsoVal) annotation (Line(points={{762,
          -463},{800,-463},{800,-340},{-746,-340},{-746,306},{-704,306}},
        color={255,0,255}));
  connect(chiIsoVal.y, yChiWatIsoVal)
    annotation (Line(points={{562,-30},{940,-30}}, color={0,0,127}));
  connect(uConWatReq, disChi.uConWatReq) annotation (Line(points={{-920,610},{80,
          610},{80,-466},{738,-466}},    color={255,0,255}));
  connect(chaProUpDown.y, wseSta.uStaPro) annotation (Line(points={{402,-80},{410,
          -80},{410,-110},{-726,-110},{-726,314},{-704,314}}, color={255,0,255}));
  connect(chiWatSupSet.TChiWatSupSet, supTem.u) annotation (Line(points={{-476,428},
          {-380,428},{-380,620},{798,620}}, color={0,0,127}));
  connect(supTem.y, TChiWatSupSet)
    annotation (Line(points={{822,620},{940,620}}, color={0,0,127}));
  connect(wseSta.yConWatIsoVal, yEcoConWatIsoVal) annotation (Line(points={{-656,
          328},{-620,328},{-620,780},{940,780}}, color={255,0,255}));
  connect(wseSta.y1ChiWatBypVal, y1WseChiWatBypVal) annotation (Line(points={{-656,
          306},{-570,306},{-570,660},{942,660}}, color={255,0,255}));
  connect(chiHeaCon.y, disChi.u1ConWatIsoVal) annotation (Line(points={{542,280},
          {690,280},{690,-470},{738,-470}}, color={255,0,255}));
  connect(disChi.y1ConWatIsoVal, y1ConWatIsoVal) annotation (Line(points={{762,-468},
          {808,-468},{808,280},{940,280}}, color={255,0,255}));
  connect(dpChiWatSet_local, chiWatPumCon.dpChiWatSet_local) annotation (Line(
        points={{-920,500},{-872,500},{-872,478.071},{414,478.071}}, color={0,0,
          127}));
  connect(dpChiWatSet_local, staSetCon.dpChiWatPumSet_local) annotation (Line(
        points={{-920,500},{-872,500},{-872,12},{-268,12}}, color={0,0,127}));
  connect(plaEna.uPlaSchEna, uPlaSchEna) annotation (Line(points={{-704,-500},{-868,
          -500},{-868,-480},{-920,-480}}, color={255,0,255}));
  connect(conWatPumNum.y, intScaRep.u)
    annotation (Line(points={{462,20},{478,20}}, color={255,127,0}));
  connect(conPum.y, enaConWatPum.u1)
    annotation (Line(points={{502,60},{538,60}}, color={255,127,0}));
  connect(enaConWatPum.y, booToRea1.u)
    annotation (Line(points={{562,60},{578,60}}, color={255,0,255}));
  connect(intScaRep.y, enaConWatPum.u2) annotation (Line(points={{502,20},{520,
          20},{520,52},{538,52}}, color={255,127,0}));
  connect(enaConWatPum.y, disChi.uConWatPum) annotation (Line(points={{562,60},{
          570,60},{570,-478},{738,-478}}, color={255,0,255}));
  connect(disChi.yConWatPum, yConWatPum) annotation (Line(points={{762,-476},{850,
          -476},{850,90},{940,90}}, color={255,0,255}));
  connect(uChi, chiLif.uChi) annotation (Line(points={{-920,400},{-520,400},{-520,
          370},{-502,370}}, color={255,0,255}));
  connect(chiLif.yLifMax, staSetCon.uLifMax) annotation (Line(points={{-478,376},
          {-300,376},{-300,28},{-268,28}}, color={0,0,127}));
  connect(chiLif.yLifMin, staSetCon.uLifMin) annotation (Line(points={{-478,364},
          {-310,364},{-310,20},{-268,20}}, color={0,0,127}));
  connect(TChiWatRet, sub.u1) annotation (Line(points={{-920,280},{-860,280},{-860,
          -534},{-560,-534}}, color={0,0,127}));
  connect(TChiWatSup, sub.u2) annotation (Line(points={{-920,210},{-840,210},{-840,
          -546},{-560,-546}}, color={0,0,127}));
  connect(VChiWat_flow, gai.u) annotation (Line(points={{-920,440},{-880,440},{-880,
          -620},{-562,-620}}, color={0,0,127}));
  connect(sub.y, mul.u1) annotation (Line(points={{-536,-540},{-520,-540},{-520,
          -504},{-462,-504}}, color={0,0,127}));
  connect(gai.y, mul.u2) annotation (Line(points={{-538,-620},{-500,-620},{-500,
          -516},{-462,-516}}, color={0,0,127}));
  connect(mul.y, towCon.uChiLoa) annotation (Line(points={{-438,-510},{-390,-510},
          {-390,-564},{-268,-564}}, color={0,0,127}));
  connect(mul.y, upProCon.uChiLoa) annotation (Line(points={{-438,-510},{-20,-510},
          {-20,408},{172,408}}, color={0,0,127}));
  connect(mul.y, dowProCon.uChiLoa) annotation (Line(points={{-438,-510},{-20,-510},
          {-20,-176},{172,-176}}, color={0,0,127}));
  connect(chiWatSupSet.dpChiWatPumSet, dpChiWatPumSet) annotation (Line(points={
          {-476,452},{-370,452},{-370,590},{940,590}}, color={0,0,127}));
  connect(TConWatTowRet, towCon.TConWatRet) annotation (Line(points={{-922,-628},
          {-860,-628},{-860,-644},{-268,-644}}, color={0,0,127}));
  connect(TConWatRet, heaPreCon.TConWatRet) annotation (Line(points={{-920,240},
          {-650,240},{-650,212},{-524,212}}, color={0,0,127}));
annotation (
    defaultComponentName="chiPlaCon",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-400},{100,400}}),
        graphics={
        Rectangle(
          extent={{-100,-400},{100,400}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-100,440},{100,400}},
          textColor={0,0,255},
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
          extent={{-98,366},{-58,354}},
          textColor={255,0,255},
          textString="uChiWatReq"),
        Text(
          extent={{-100,326},{-56,316}},
          textColor={255,0,255},
          textString="uChiWatPum"),
        Text(
          extent={{-98,346},{-56,334}},
          textColor={255,0,255},
          textString="uConWatReq"),
        Text(
          extent={{-98,248},{-50,234}},
          textColor={0,0,127},
          textString="dpChiWat_remote"),
        Text(
          extent={{-100,228},{-58,216}},
          textColor={0,0,127},
          textString="VChiWat_flow"),
        Text(
          extent={{-98,206},{-80,194}},
          textColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{-100,166},{-68,156}},
          textColor={0,0,127},
          textString="phi",
          visible=have_WSE),
        Text(
          extent={{-98,148},{-50,134}},
          textColor={0,0,125},
          textString="TChiWatRetDow",
          visible=have_WSE),
        Text(
          extent={{-100,126},{-60,116}},
          textColor={0,0,127},
          textString="TChiWatRet"),
        Text(
          extent={{-100,108},{-60,92}},
          textColor={0,0,127},
          textString="TConWatRet"),
        Text(
          extent={{-98,86},{-58,74}},
          textColor={0,0,127},
          textString="TChiWatSup"),
        Text(
          extent={{-98,58},{-60,44}},
          textColor={0,0,127},
          textString="uHeaPreCon",
          visible=have_heaPreConSig),
        Text(
          extent={{-100,-24},{-64,-36}},
          textColor={255,0,255},
          textString="uChiAva"),
        Text(
          extent={{-98,-112},{-50,-126}},
          textColor={0,0,127},
          textString="uChiWatIsoVal"),
        Text(
          extent={{-98,-132},{-50,-146}},
          textColor={255,127,0},
          textString="TChiWatSupResReq"),
        Text(
          extent={{-98,-172},{-50,-186}},
          textColor={0,0,127},
          textString="uConWatPumSpe"),
        Text(
          extent={{-98,-192},{-50,-206}},
          textColor={255,0,255},
          textString="uConWatPum"),
        Text(
          extent={{-98,-232},{-78,-246}},
          textColor={0,0,127},
          textString="TOut"),
        Text(
          extent={{-98,-304},{-50,-318}},
          textColor={0,0,127},
          textString="TConWatSup",
          visible=not closeCoupledPlant),
        Text(
          extent={{-100,-334},{-68,-346}},
          textColor={0,0,127},
          textString="uIsoVal"),
        Text(
          extent={{-98,-352},{-68,-364}},
          textColor={0,0,127},
          textString="watLev"),
        Text(
          extent={{-98,-372},{-62,-386}},
          textColor={255,0,255},
          textString="uTowSta"),
        Text(
          extent={{48,208},{96,194}},
          textColor={255,0,255},
          textString="yChiWatPum",
          visible=have_heaChiWatPum),
        Text(
          extent={{76,118},{98,104}},
          textColor={255,0,255},
          textString="yChi"),
        Text(
          extent={{52,-32},{100,-46}},
          textColor={255,0,255},
          textString="yConWatPum"),
        Text(
          extent={{62,-202},{98,-216}},
          textColor={255,0,255},
          textString="yTowCel"),
        Text(
          extent={{64,-264},{98,-278}},
          textColor={255,0,255},
          textString="yMakUp"),
        Text(
          extent={{52,178},{100,164}},
          textColor={0,0,127},
          textString="yChiPumSpe"),
        Text(
          extent={{52,148},{100,134}},
          textColor={0,0,127},
          textString="yChiDem",
          visible=have_priOnl or use_loadShed),
        Text(
          extent={{52,58},{100,44}},
          textColor={0,0,127},
          textString="yConWatIsoVal",
          visible=(not have_airCoo) and have_heaConWatPum and not (
              have_heaPreConSig or (not have_fixSpeConWatPum and not have_WSE))),
        Text(
          extent={{52,28},{100,14}},
          textColor={0,0,127},
          textString="yConWatPumSpe"),
        Text(
          extent={{52,0},{100,-14}},
          textColor={0,0,127},
          textString="yChiWatMinFloSet"),
        Text(
          extent={{52,-92},{100,-106}},
          textColor={0,0,127},
          textString="yChiWatIsoVal"),
        Text(
          extent={{52,-122},{100,-136}},
          textColor={0,0,127},
          textString="yMinValPosSet"),
        Text(
          extent={{52,-172},{100,-186}},
          textColor={0,0,127},
          textString="yTowCelIsoVal"),
        Text(
          extent={{52,-232},{100,-246}},
          textColor={0,0,127},
          textString="yTwoFanSpe"),
        Text(
          extent={{52,-60},{100,-74}},
          textColor={255,0,255},
          textString="yReaChiDemLim",
          visible=have_priOnl or use_loadShed),
        Text(
          extent={{-98,288},{-50,274}},
          textColor={0,0,127},
          visible=have_locSenChiWatPum,
          textString="dpChiWat_local"),
        Text(
          extent={{-98,-94},{-54,-108}},
          textColor={255,0,255},
          textString="uChiHeaCon"),
        Text(
          extent={{50,90},{98,76}},
          textColor={255,0,255},
          visible=(not have_airCoo) and have_heaConWatPum and (
              have_heaPreConSig or (not have_fixSpeConWatPum and not have_WSE)),
          textString="y1ConWatIsoVal"),
        Text(
          extent={{48,268},{96,254}},
          textColor={0,0,125},
          textString="TChiWatSupSet"),
        Text(
          extent={{-98,-154},{-70,-164}},
          textColor={255,127,0},
          textString="chiPlaReq"),
        Text(
          extent={{-98,-64},{-62,-78}},
          textColor={0,0,127},
          textString="TEntHex",
          visible=have_WSE and not have_byPasValCon),
        Text(
          extent={{-98,-2},{-50,-16}},
          textColor={0,0,127},
          textString="dpChiWat",
          visible=have_WSE and have_byPasValCon),
        Text(
          extent={{-98,-44},{-62,-56}},
          textColor={255,0,255},
          textString="uEcoPum",
          visible=have_WSE and not have_byPasValCon),
        Text(
          extent={{34,398},{94,384}},
          textColor={255,0,255},
          textString="yEcoConWatIsoVal",
          visible=have_WSE),
        Text(
          extent={{46,368},{94,354}},
          textColor={0,0,125},
          textString="yWseRetVal",
          visible=have_byPasValCon and have_WSE),
        Text(
          extent={{46,318},{94,304}},
          textColor={0,0,125},
          textString="yWsePumSpe",
          visible=have_WSE and not have_byPasValCon),
        Text(
          extent={{48,338},{96,324}},
          textColor={255,0,255},
          visible=have_WSE and not have_byPasValCon,
          textString="yWsePumOn"),
        Text(
          extent={{36,296},{94,284}},
          textColor={255,0,255},
          visible=have_WSE and have_priOnl and have_parChi,
          textString="y1WseChiWatBypVal"),
        Text(
          extent={{-98,268},{-42,254}},
          textColor={0,0,127},
          visible=have_locSenChiWatPum,
          textString="dpChiWatSet_local"),
        Text(
          extent={{-98,-214},{-50,-228}},
          textColor={255,0,255},
          textString="uPlaSchEna"),
        Text(
          extent={{34,238},{96,222}},
          textColor={0,0,125},
          textString="dpChiWatPumSet",
          visible=not have_locSenChiWatPum),
        Text(
          extent={{-98,-282},{-40,-298}},
          textColor={0,0,127},
          visible=not closeCoupledPlant,
          textString="TConWatTowRet")}),
    Diagram(coordinateSystem(extent={{-900,-800},{920,800}})),
Documentation(info="<html>
<p>
The chiller plant control sequence is implemented according to ASHRAE Guideline 36-2021.
It is composed by the subsequences in this package. The applicability of some sequences
is listed in the table below. The <code>yes</code> means that the sequence is applicable
to the system type.
</p>
<table summary=\"summary\" border=\"1\"><thead>
<tr>
<th bgcolor=\"silver\">Subsequences</th>
<th bgcolor=\"silver\">Primary<br>only</th>
<th bgcolor=\"silver\">Primary<br>Secondary</th>
<th bgcolor=\"silver\">Parallel<br>chillers</th>
<th bgcolor=\"silver\">Series<br>chillers</th>
<th bgcolor=\"silver\">Headed<br>CHWP</th>
<th bgcolor=\"silver\">Dedicated<br>CHWP</th>
<th bgcolor=\"silver\">Headed<br>CWP</th>
<th bgcolor=\"silver\">Dedicated<br>CWP</th>
<th bgcolor=\"silver\">VarSpe<br>CWP</th>
<th bgcolor=\"silver\">ConSpe<br>CWP</th>
<th bgcolor=\"silver\">Water<br>cooled</th>
<th bgcolor=\"silver\">Air<br>cooled</th>
<th bgcolor=\"silver\">With<br>WSE</th>
<th bgcolor=\"silver\"></th>
</tr></thead>
<tbody>
    <tr>
      <td>Plant</br>reset</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td bgcolor=\"gray\" style=\"text-align: center; vertical-align: middle;\">not</br>implemented</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"vertical-align: middle;\">
        <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.SetPoints.ChilledWaterPlantReset\">
        Chilled water plant reset</a></br>
        and
        <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.SetPoints.ChilledWaterSupply\">
        Chilled water supply</a>
      </td>
    </tr>
    <tr>
      <td>Waterside</br>economizers</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"vertical-align: middle;\">
        <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Controller\">
        Economizer controller</a>
      </td>
    </tr>
    <tr>
      <td>Head pressure</br>control</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td bgcolor=\"gray\" style=\"text-align: center; vertical-align: middle;\">not</br>applicable</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"vertical-align: middle;\">
        <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.HeadPressure.Controller\">
        Head pressure controller</a>
      </td>
    </tr>
    <tr>
      <td>Minimum</br>flow</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td bgcolor=\"gray\" style=\"text-align: center; vertical-align: middle;\">not</br>specified</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"vertical-align: middle;\">
        <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.MinimumFlowBypass.Controller\">
        Bypass valve controller</a></br>
        and
        <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.MinimumFlowBypass.FlowSetpoint\">
        Bypass flow setpoint</a>
      </td>
    </tr>
    <tr>
    <td>Primary chilled</br>water pumps</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td bgcolor=\"gray\" style=\"text-align: center; vertical-align: middle;\">not</br>implemented</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td bgcolor=\"gray\" style=\"text-align: center; vertical-align: middle;\">not</br>implemented</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"vertical-align: middle;\">
        <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Controller\">
        Chilled water pump controller</a>
      </td>
    </tr>
    <tr>
      <td>Condenser water</br>pumps</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td bgcolor=\"gray\" style=\"text-align: center; vertical-align: middle;\">not</br>specified</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td bgcolor=\"gray\" style=\"text-align: center; vertical-align: middle;\">not</br>applicable</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"vertical-align: middle;\">
        <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.CondenserWater.Controller\">
        Condenser water pump controller</a>
      </td>
    </tr>
    <tr>
      <td>Chillers</br>staging</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td bgcolor=\"gray\" style=\"text-align: center; vertical-align: middle;\">not</br>implemented</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td bgcolor=\"gray\" style=\"text-align: center; vertical-align: middle;\">not</br>implemented</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td bgcolor=\"gray\" style=\"text-align: center; vertical-align: middle;\">not</br>implemented</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td bgcolor=\"gray\" style=\"text-align: center; vertical-align: middle;\">not</br>implemented</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"vertical-align: middle;\">
        <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Up\">
        Staging up</a></br>
        and
        <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Down\">
        Staging down</a>
      </td>
    </tr>
    <tr>
      <td>Cooling</br>towers</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"text-align: center; vertical-align: middle;\">yes</td>
      <td style=\"vertical-align: middle;\">
        <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Controller\">
        Tower controller</a>
      </td>
    </tr>
  </tbody></table>


<h4>1. Plant reset</h4>
<p>
In Guideline 36-2021, the sequences for following types of plant have been specified.
However, they have not yet been implemented in this library.
</p>
<ul>
<li>
Primary-only sytem serving a single large load, e.g. large AHU,
</li>
<li>
Primary-secondary systems where there are any coil pumps,
</li>
<li>
Plants with series chillers.
</li>
</ul>

<h4>2. Head pressure control</h4>
<p>
If there is the head pressure control signal from chiller, the sequence is not needed.
In Guideline 36-2021, it assumes:
</p>
<ul>
<li>
The plants with fixed speed condenser water pumps do not have waterside economizer.
</li>
<li>
If the plants have variable speed condenser water pumps and have waterside economizer,
the condenser water pumps are headered.
</li>
</ul>
<p>
The sequence is not applicable to the plants with air-cooled chillers.
</p>

<h4>3. Minimum chilled water flow</h4>
<p>
In Guideline 36-2021, the sequences for the following types of plants have not been specified.
</p>
<ul>
<li>
Plants with primary-secondary systems
</li>
</ul>

<h4>4. Primary chilled water (CHW) pump control</h4>
<p>
In Guideline 36-2021, the sequences for the following types of plants have been specified.
However, they have not yet been implemented in this library.
</p>
<ul>
<li>
Plants with series chiller, section 5.20.6.4 and 5.20.6.5.
</li>
<li>
Primary-secondary plants and primary-only plants where the primary pump speed is not
controlled to maintain differential pressure, section 5.20.6.13 and 5.20.6.14.
</li>
<li>
Primary-only plants and primary-secondary plants with variable speed primary pumps
that are intended to operate at a fixed speed, section 5.20.6.15.
</li>
<li>
Variable primary-variable secondary plants with primary and secondary loop flow
meters, section 5.20.6.16.
</li>
<li>
Variable primary-variable secondary plants with a flow meter in the decoupler,
section 5.20.6.17.
</li>
<li>
Variable primary-variable secondary plants without flow meters from which to
deduce decoupler flow, section 5.20.6.18.
</li>
</ul>

<h4>5. Secondary chilled water pumps control</h4>
<p>
In Guideline 36-2021, the secondary chilled water pumps controls have been specified.
However, they have not yet been implemented in this library, section 5.20.7.
</p>

<h4>6. Condenser water (CW) pumps control</h4>
<p>
For the headered condenser water pumps, the sequence assumes that all the pumps have
same size.
In Guideline 36-2021, the sequences for the following types of plants have not been specified.
</p>
<ul>
<li>
Plants with the series chiller
</li>
</ul>
<p>
The sequence is not applicable to the plants with air-cooled chillers.
</p>

<h4>7. Chiller staging control</h4>
<p>
In Guideline 36-2021, the sequences for the following types of plants have been specified.
However, they have not yet been implemented in this library.
</p>
<ul>
<li>
Water-cooled primary-only parallel chiller plants with headered CHW pumps
and dedicated CW pumps, section 5.20.4.18 and 5.20.4.19.
</li>
<li>
Water-cooled primary-only parallel chiller plants with dedicated CHW pumps
and headered CW pumps or air-cooled primary-only parallel chilled plants
with dedicated chilled water pumps, section 5.20.4.20 and 5.20.4.21.
</li>
<li>
Water-cooled primary-only parallel chiller plants with dedicated CHW pumps
and dedicated CW pumps, section 5.20.4.22 and 5.20.4.23.
</li>
<li>
Water-cooled primary-secondary parallel chiller plants with headered primary CHW
pumps and headered CW pumps or air-cooled primary-secondary parallel plants with
headered CHW pumps, section 5.20.4.24 and 5.20.4.25.
</li>
<li>
Water-cooled primary-secondary parallel chiller plants with headered primary CHW
pumps and dedicated CW pumps, section 5.20.4.26 and 5.20.4.27.
</li>
<li>
Water-cooled primary-secondary parallel chiller plants with dedicated primary CHW
pumps and headered CW pumps or air-cooled primary-secondary parallel chiller plants
with dedicated primary CHW pumps, section 5.20.4.28 and 5.20.4.29.
</li>
<li>
Water-cooled primary-secondary parallel chiller plants with dedicated primary CHW
pumps and dedicated CW pumps, section 5.20.4.30 and 5.20.4.31.
</li>
<li>
Water-cooled primary-only series chiller plants with headered CW pumps or air-cooled
primary-only series chiller plants, section 5.20.4.32 and 5.20.4.33.
</li>
<li>
Water-cooled primary-only series chiller plants with dedicated CW pumps, section
5.20.4.34 and 5.20.4.35.
</li>
</ul>

<h4>8. Cooling tower control</h4>
<p>
In the current implementation, the tower sequence assumes that the cells are enabled in
the order as it is labelled, meaning that it enables the cells as cell 1, 2, 3,
etc. Note from the Guideline 36-2021,
</p>
<ul>
<li>
The tower control sequence is applicable to the plants with dynamic load profiles,
i.e. those for which PLR may change by more than approximately 25% in any hour,
for controlling condenser water return temperature.
</li>
<li>
It is not applicable for the plants where 2-position tower bypass control valves
are needed to prevent tower freezing.
</li>
</ul>
<p>
In Guideline 36-2021, the sequences for the following types of plants have been specified.
However, they have not yet been implemented in this library.
</p>
<ul>
<li>
Plants with cooling tower fan speed control, for controling the condenser water supply
temperature, section 5.20.12.2.b.
</li>
</ul>
<p>
The sequence is not applicable to the plants with air-cooled chillers.
</p>

<h4>9. Equipment rotation</h4>
<p>
The sequence 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.EquipmentRotation.ControllerTwo\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.EquipmentRotation.ControllerTwo</a>
rotates equipment, such as chillers or pumps, to ensure equal wear and tear. It is
applicable to two identical devices or device groups.
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
