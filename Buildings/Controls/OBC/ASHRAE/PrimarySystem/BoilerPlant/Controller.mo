within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant;
model Controller
  "Boiler plant controller"

  parameter Integer nIgnReq(
    final min=0) = 0
    "Number of hot-water requests to be ignored before enablng boiler plant loop"
    annotation(dialog(tab="Plant enable/disable parameters"));

  parameter Integer nSchRow(
    final min=1) = 4
    "Number of rows to be created for plant schedule table"
    annotation(dialog(tab="Plant enable/disable parameters"));

  parameter Real schTab[nSchRow,2] = [0,1; 6,1; 18,1; 24,1]
    "Table defining schedule for enabling plant"
    annotation(dialog(tab="Plant enable/disable parameters"));

  parameter Real TOutLoc(
    final unit="K",
    final displayUnit="K") = 300
    "Boiler lock-out temperature for outdoor air"
    annotation(dialog(tab="Plant enable/disable parameters"));

  parameter Real locDt(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 1
    "Temperature deadband for boiler lockout"
    annotation(dialog(tab="Plant enable/disable parameters", group="Advanced"));

  parameter Real plaOffThrTim(
    final unit="s",
    final displayUnit="s") = 900
    "Minimum time for which the plant has to stay off once it has been disabled"
    annotation(dialog(tab="Plant enable/disable parameters"));

  parameter Real plaOnThrTim(
    final unit="s",
    final displayUnit="s") = plaOffThrTim
    "Minimum time for which the boiler plant has to stay on once it has been enabled"
    annotation(dialog(tab="Plant enable/disable parameters"));

  parameter Real staOnReqTim(
    final unit="s",
    final displayUnit="s") = 180
    "Time-limit for receiving hot-water requests to maintain enabled plant on"
    annotation(dialog(tab="Plant enable/disable parameters"));

  parameter Boolean primaryOnly = false
    "Is the boiler plant a primary-only, condensing boiler plant?"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer nBoi = 2
    "Number of boilers"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer boiTyp[nBoi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler}
    "Boiler type"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer nSta = 3
    "Number of boiler plant stages"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer staMat[nSta, nBoi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stage as row index and boiler as column index"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real boiDesCap[nBoi](
    final unit="W",
    final displayUnit="W",
    final quantity="Power")
    "Design boiler capacities vector"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real boiFirMin[nBoi](
    final unit="1",
    final displayUnit="1")
    "Boiler minimum firing ratio"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real bMinPriPumSpeSta[nSta](
    final unit="1",
    final displayUnit="1",
    final max=1,
    final min=0) = {0,0,0}
    "Minimum primary pump speed for the boiler plant stage"
    annotation(Evaluate=true,
      Dialog(enable=not
                       (primaryOnly),
        tab="General",
        group="Boiler plant configuration parameters"));

  parameter Real delStaCha(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 600
    "Hold period for each stage change"
    annotation(Dialog(tab="Staging setpoint parameters", group="General parameters"));

  parameter Real avePer(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 300
    "Time period for the capacity requirement rolling average"
    annotation(Dialog(tab="Staging setpoint parameters", group="Capacity requirement calculation parameters"));

  parameter Real fraNonConBoi(
    final unit="1",
    final displayUnit="1") = 0.9
    "Fraction of current stage design capacity at which efficiency condition is 
    satisfied for non-condensing boilers"
    annotation(Dialog(tab="Staging setpoint parameters", group="Efficiency condition parameters"));

  parameter Real fraConBoi(
    final unit="1",
    final displayUnit="1") = 1.5
    "Fraction of higher stage design capacity at which efficiency condition is 
    satisfied for condensing boilers"
    annotation(Dialog(tab="Staging setpoint parameters", group="Efficiency condition parameters"));

  parameter Real delEffCon(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 600
    "Enable delay for heating capacity requirement condition"
    annotation(Dialog(tab="Staging setpoint parameters", group="Efficiency condition parameters"));

  parameter Real TDif(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 10
    "Required temperature difference between setpoint and measured temperature"
    annotation(Dialog(tab="Staging setpoint parameters", group="Failsafe condition parameters"));

  parameter Real delFaiCon(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 900
    "Enable delay for temperature condition"
    annotation(Dialog(tab="Staging setpoint parameters", group="Failsafe condition parameters"));

  parameter Real sigDif(
    final unit="1",
    final displayUnit="1") = 0.1
    "Signal hysteresis deadband for flowrate measurements"
    annotation (Dialog(tab="Advanced", group="Efficiency condition parameters"));

  parameter Real TDifHys(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Temperature deadband for hysteresis loop"
    annotation(Dialog(tab="Advanced", group="Failsafe condition parameters"));

  parameter Real fraMinFir(
    final unit="1",
    final displayUnit="1") = 1.1
    "Fraction of boiler minimum firing rate that required capacity needs to be
    to initiate stage-down process"
    annotation(Dialog(tab="Staging setpoint parameters", group="Staging down parameters"));

  parameter Real delMinFir(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 300
    "Delay for staging based on minimum firing rate of current stage"
    annotation(Dialog(tab="Staging setpoint parameters", group="Staging down parameters"));

  parameter Real fraDesCap(
    final unit="1",
    final displayUnit="1") = 0.8
    "Fraction of design capacity of next lower stage that heating capacity needs
    to be for staging down"
    annotation(Dialog(tab="Staging setpoint parameters", group="Staging down parameters"));

  parameter Real delDesCapNonConBoi(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 600
    "Enable delay for capacity requirement condition for non-condensing boilers"
    annotation(Dialog(tab="Staging setpoint parameters", group="Staging down parameters"));

  parameter Real delDesCapConBoi(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for capacity requirement condition for condensing boilers"
    annotation(Dialog(tab="Staging setpoint parameters", group="Staging down parameters"));

  parameter Real delBypVal(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for bypass valve condition for primary-only plants"
    annotation (
      Evaluate=true,
      Dialog(
        enable=primaryOnly,
        tab="Staging setpoint parameters",
        group="Staging down parameters"));

  parameter Real TCirDif(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 3
    "Required return water temperature difference between primary and secondary
    circuits for staging down"
    annotation (
      Evaluate=true,
      Dialog(
        enable=not
                  (primaryOnly),
        tab="Staging setpoint parameters",
        group="Staging down parameters"));

  parameter Real delTRetDif(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for measured hot water return temperature difference condition"
    annotation (
      Evaluate=true,
      Dialog(
        enable=not
                  (primaryOnly),
        tab="Staging setpoint parameters",
        group="Staging down parameters"));

  parameter Real bypValClo(
    final unit="1",
    final displayUnit="1") = 0
    "Adjustment for signal received when bypass valve is closed"
    annotation (
      Evaluate=true,
      Dialog(
        enable=primaryOnly,
        tab="Advanced",
        group="Staging down parameters"));

  parameter Real dTemp(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 0.1
    "Hysteresis deadband for measured temperatures"
    annotation (Dialog(tab="Advanced", group="Failsafe condition parameters"));

  parameter Real minFloSet[nBoi](
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1e-6,
    final max=maxFloSet) = {0.005, 0.005, 0.005}
    "Design minimum hot water flow through each boiler"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real maxFloSet[nBoi](
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate",
    final min=minFloSet) = {0.025, 0.025, 0.025}
    "Design maximum hot water flow through each boiler"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real bypSetRat(
    final unit="m3/s2",
    displayUnit="m3/s2",
    final min=0) = 0.001
    "Rate at which to reset bypass valve setpoint during stage change"
    annotation(Dialog(tab="Staging setpoint parameters", group="General parameters"));

  parameter Integer nPumPri = 2
    "Number of primary pumps in the boiler plant loop"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer nHotWatResReqIgn = 2
    "Number of hot-water supply temperature reset requests to be ignored"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real TPlaHotWatSetMax(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 353.15
    "The maximum allowed hot-water setpoint temperature for the plant"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real TConBoiHotWatSetMax(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 353.15
    "The maximum allowed hot water setpoint temperature for condensing boilers"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real TConBoiHotWatSetOff(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = -10
    "The offset for hot water setpoint temperature for condensing boilers in 
    non-condensing stage type"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Boiler plant configuration parameters"));

  parameter Real THotWatSetMinNonConBoi(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 341.48
    "The minimum allowed hot-water setpoint temperature for non-condensing boilers"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real THotWatSetMinConBoi(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 305.37
    "The minimum allowed hot-water setpoint temperature for condensing boilers"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real delTimVal(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 600
    "Delay time"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real samPerVal(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 300
    "Sample period"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real triAmoVal(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = -2
    "Setpoint trim value"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real resAmoVal(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 3
    "Setpoint respond value"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real maxResVal(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 7
    "Setpoint maximum respond value"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real holTimVal(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 600
    "Minimum setpoint hold time for stage change process"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Boiler plant configuration parameters"));

  parameter Boolean isHeadered = true
    "True: Headered hot water pumps;
     False: Dedicated hot water pumps"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real TMinSupNonConBoi(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 333.2
    "Minimum supply temperature required for non-condensing boilers"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real delProSupTemSet(
    final unit="s",
    final displayUnit="s",
    final quantity="time")=300
    "Process time-out for hot water supply temperature setpoint reset"
    annotation (Dialog(tab="Staging process parameters",group="Time and delay parameters"));

  parameter Real delEnaMinFloSet(
    final unit="s",
    final displayUnit="s",
    final quantity="time")=60
    "Enable delay after minimum flow setpoint is achieved in bypass valve"
    annotation (Dialog(tab="Staging process parameters",group="Time and delay parameters"));

  parameter Real chaHotWatIsoRat(
    final unit="1/s",
    final displayUnit="1/s") = 1/60
    "Rate at which to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(tab="Staging process parameters",group="Time and delay parameters"));

  parameter Real chaIsoValTim(
    final unit="s",
    final displayUnit="s",
    final quantity="time") = 60
    "Time to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(group="Time and delay parameters"));

  parameter Real delPreBoiEna(
    final unit="s",
    final displayUnit="s",
    final quantity="time") = 30
    "Time delay after valve and pump change process has been completed before
    starting boiler change process"
    annotation (Dialog(tab="Staging process parameters",group="Time and delay parameters"));

  parameter Real boiChaProOnTim(
    final unit="s",
    final displayUnit="s",
    final quantity="time") = 300
    "Enabled boiler operation time to indicate if it is proven on during a staging
    process where one boiler is turned on and the other is turned off"
    annotation (Dialog(tab="Staging process parameters",group="Time and delay parameters"));

  parameter Real delBoiEna(
    final unit="s",
    final displayUnit="s",
    final quantity="time") = 180
    "Time delay after boiler change process has been completed before turning off
    excess valves and pumps"
    annotation (Dialog(tab="Staging process parameters",group="Time and delay parameters"));

  parameter Real k_bypVal(
    final min=0,
    final unit="1",
    displayUnit="1") = 1
    "Gain of controller"
    annotation(Dialog(tab="Bypass valve control parameters"));

  parameter Real Ti_bypVal(
    final min=0,
    final unit="s",
    displayUnit="s",
    final quantity="time") = 0.5
    "Time constant of integrator block"
    annotation(Dialog(tab="Bypass valve control parameters"));

  parameter Real Td_bypVal(
    final min=0,
    final unit="s",
    displayUnit="s",
    final quantity="time") = 0.1
    "Time constant of derivative block"
    annotation(Dialog(tab="Bypass valve control parameters"));

  parameter Boolean variablePrimary = false
    "True: Variable-speed primary pumps;
     False: Fixed-speed primary pumps"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer nSen_remoteDp = 2
    "Total number of remote differential pressure sensors"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer numIgnReq = 0
    "Number of ignored requests"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable= speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Integer nPum_nominal(
    final max=nPumPri,
    final min=1) = nPumPri
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Real minPumSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=maxPumSpe) = 0.1
    "Minimum pump speed"
    annotation (Dialog(group="Pump parameters", enable=variablePrimary));

  parameter Real maxPumSpe(
    final unit="1",
    displayUnit="1",
    final min=minPumSpe,
    final max=1) = 1
    "Maximum pump speed"
    annotation (Dialog(group="Pump parameters", enable=variablePrimary));

  parameter Real VHotWat_flow_nominal(
    final min=1e-6,
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") = 0.5
    "Total plant design hot water flow rate"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Real boiDesFlo[nBoi](
    final min=1e-6,
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") = {0.5,0.5}
    "Vector of design flowrates for all boilers in plant"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Real maxLocDp(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6) = 5*6894.75
    "Maximum hot water loop local differential pressure setpoint"
    annotation (Dialog(tab="Pump control parameters", group="DP-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP));

  parameter Real minLocDp(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6) = 5*6894.75
    "Minimum hot water loop local differential pressure setpoint"
    annotation (Dialog(tab="Pump control parameters",
      group="DP-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP));

  parameter Real offTimThr_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 180
    "Threshold to check lead boiler off time"
    annotation (Dialog(tab="Pump control parameters", group="Pump staging parameters"));

  parameter Real timPer_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 600
    "Delay time period for enabling and disabling lag pumps"
    annotation (Dialog(tab="Pump control parameters", group="Pump staging parameters"));

  parameter Real staCon_priPum(
    final unit="1",
    displayUnit="1") = -0.03
    "Constant used in the staging equation"
    annotation (Dialog(tab="Pump control parameters", group="Pump staging parameters"));

  parameter Real relFloHys_priPum(
    final unit="1",
    displayUnit="1") = 0.01
    "Constant value used in hysteresis for checking relative flow rate"
    annotation (Dialog(tab="Pump control parameters", group="Pump staging parameters"));

  parameter Real delTim_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 900
    "Delay time"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real samPer_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 120
    "Sample period of component"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real triAmo_priPum(
    final unit="1",
    displayUnit="1") = -0.02
    "Trim amount"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real resAmo_priPum(
    final unit="1",
    displayUnit="1") = 0.03
    "Respond amount"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real maxRes_priPum(
    final unit="1",
    displayUnit="1") = 0.06
    "Maximum response per time interval"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real twoReqLimLow_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1.2
    "Lower limit of hysteresis loop sending two requests"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real twoReqLimHig_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 2
    "Higher limit of hysteresis loop sending two requests"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real oneReqLimLow_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.2
    "Lower limit of hysteresis loop sending one request"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real oneReqLimHig_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Higher limit of hysteresis loop sending one request"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real k_priPum(
    final unit="1",
    displayUnit="1",
    final min=0) = 1
    "Gain of controller"
    annotation (Dialog(tab="Pump control parameters", group="PID parameters"));

  parameter Real Ti_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Pump control parameters", group="PID parameters"));

  parameter Real Td_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Pump control parameters", group="PID parameters"));

  parameter Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes
    speedControlType_priPum = Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP
    "Speed regulation method"
    annotation (Dialog(group="Boiler plant configuration parameters", enable=variablePrimary));

  parameter Real TRetSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 333.15
    "Minimum hot water return temperature for optimal non-condensing boiler performance"
    annotation(Dialog(tab="Condensation control parameters"));

  parameter Real TRetMinAll(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 330.35
    "Minimum allowed hot water return temperature for non-condensing boiler"
    annotation(Dialog(tab="Condensation control parameters"));

  parameter Real minSecPumSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1) = 0
    "Minimum secondary pump speed"
    annotation(Dialog(tab="Condensation control parameters"));

  parameter Real minPriPumSpeSta[nSta](
    final unit=fill("1",nSta),
    displayUnit=fill("1",nSta),
    final min=fill(0,nSta),
    final max=fill(1,nSta)) = {0,0,0,0,0}
    "Vector of minimum primary pump speed for each stage"
    annotation(Dialog(tab="Condensation control parameters"));

  parameter Integer staInd[nSta]={i for i in 1:nSta}
    "Staging indices starting at 1";

  Generic.PlantEnable plaEna(
    nIgnReq=nIgnReq,
    nSchRow=nSchRow,
    schTab=schTab,
    TOutLoc=TOutLoc,
    plaOffThrTim=plaOffThrTim,
    plaOnThrTim=plaOnThrTim,
    staOnReqTim=staOnReqTim)
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Staging.SetPoints.SetpointController staSetCon(
    primaryOnly=primaryOnly,
    nBoi=nBoi,
    boiTyp=boiTyp,
    nSta=nSta,
    staMat=staMat,
    boiDesCap=boiDesCap,
    boiFirMin=boiFirMin,
    bMinPriPumSpeSta=bMinPriPumSpeSta,
    delStaCha=delStaCha,
    avePer=avePer,
    fraNonConBoi=fraNonConBoi,
    fraConBoi=fraConBoi,
    delEffCon=delEffCon,
    TDif=TDif,
    delFaiCon=delFaiCon,
    sigDif=sigDif,
    TDifHys=TDifHys,
    fraMinFir=fraMinFir,
    delMinFir=delMinFir,
    fraDesCap=fraDesCap,
    delDesCapNonConBoi=delDesCapNonConBoi,
    delDesCapConBoi=delDesCapConBoi,
    TCirDif=TCirDif,
    delTRetDif=delTRetDif,
    dTemp=dTemp)
    annotation (Placement(transformation(extent={{-100,-20},{-80,16}})));

  Staging.Processes.Up upProCon(
    primaryOnly=primaryOnly,
    isHeadered=isHeadered,
    nBoi=nBoi,
    nSta=nSta,
    TMinSupNonConBoi=TMinSupNonConBoi,
    delProSupTemSet=delProSupTemSet,
    delEnaMinFloSet=delEnaMinFloSet,
    chaIsoValTim=chaIsoValTim,
    delPreBoiEna=delPreBoiEna,
    boiChaProOnTim=boiChaProOnTim,
    delBoiEna=delBoiEna,
    sigDif=TDifHys,
    relFloDif=sigDif)
            annotation (Placement(transformation(extent={{120,76},{140,116}})));
  Staging.Processes.Down dowProCon(
    primaryOnly=primaryOnly,
    isHeadered=isHeadered,
    nBoi=nBoi,
    nSta=nSta,
    chaIsoValTim=chaIsoValTim,
    delPreBoiEna=delPreBoiEna,
    boiChaProOnTim=boiChaProOnTim,
    delBoiEna=delBoiEna)
            annotation (Placement(transformation(extent={{120,20},{140,60}})));
  Pumps.PrimaryPumps.Controller priPumCon(
    isHeadered=isHeadered,
    primaryOnly=primaryOnly,
    variablePrimary=variablePrimary,
    nPum=nPumPri,
    nBoi=nBoi,
    nSen=nSen_remoteDp,
    nPum_nominal=nPumPri,
    minPumSpe=minPumSpe,
    maxPumSpe=maxPumSpe,
    VHotWat_flow_nominal=VHotWat_flow_nominal,
    boiDesFlo=boiDesFlo,
    offTimThr=offTimThr_priPum,
    timPer=timPer_priPum,
    delBoiDis=delBoiEna,
    staCon=staCon_priPum,
    relFloHys=relFloHys_priPum,
    k=k_priPum,
    Ti=Ti_priPum,
    Td=Td_priPum,
    speedControlType=speedControlType_priPum)
    annotation (Placement(transformation(extent={{120,-168},{140,-112}})));
  BypassValve.BypassValvePosition bypValPos(nPum=nPumPri,
    k=k_bypVal,
    Ti=Ti_bypVal,
    Td=Td_bypVal)
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  SetPoints.HotWaterSupplyTemperatureReset hotWatSupTemRes(
    nPum=nPumPri,
    nSta=nSta,
    nBoi=nBoi,
    nHotWatResReqIgn=nHotWatResReqIgn,
    boiTyp=boiTyp,
    TPlaHotWatSetMax = TPlaHotWatSetMax,
    TConBoiHotWatSetMax = TConBoiHotWatSetMax,
    TConBoiHotWatSetOff=TConBoiHotWatSetOff,
    THotWatSetMinNonConBoi = THotWatSetMinNonConBoi,
    THotWatSetMinConBoi = THotWatSetMinConBoi,
    delTimVal=delTimVal,
    samPerVal=samPerVal,
    triAmoVal = triAmoVal,
    resAmoVal=resAmoVal,
    maxResVal=maxResVal,
    holTimVal=holTimVal)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  SetPoints.MinimumFlowSetpoint minBoiFloSet(
    nBoi=nBoi,
    nSta=nSta,
    staMat=staMat,
    minFloSet=minFloSet,
    maxFloSet=maxFloSet,
    bypSetRat=bypSetRat)
    annotation (Placement(transformation(extent={{112,170},{132,190}})));
  CDL.Logical.Or or2 "Logical Or"
    annotation (Placement(transformation(extent={{220,-10},{240,10}})));
  SetPoints.CondensationControl conSet(
    primaryOnly=primaryOnly,
    variablePrimary=variablePrimary,
    nSta=nSta,
    TRetSet=TRetSet,
    TRetMinAll=TRetMinAll,
    minSecPumSpe=minSecPumSpe,
    minPriPumSpeSta=minPriPumSpeSta)
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  CDL.Logical.Latch lat
    "Latch to identify if process is stage-up or stage-down"
    annotation (Placement(transformation(extent={{-56,20},{-36,40}})));
  CDL.Logical.LogicalSwitch logSwi
    annotation (Placement(transformation(extent={{-10,150},{10,170}})));
  CDL.Logical.IntegerSwitch intSwi
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  CDL.Logical.Latch lat1
    "Latch to identify if staging process is complete or not"
    annotation (Placement(transformation(extent={{-154,60},{-134,80}})));
  SetPoints.MinimumFlowSetpoint minBoiFloSet1[nSta](
    nBoi=fill(nBoi, nSta),
    nSta=fill(nSta, nSta),
    staMat=fill(staMat, nSta),
    minFloSet=fill(minFloSet, nSta),
    maxFloSet=fill(maxFloSet, nSta),
    bypSetRat=fill(bypSetRat, nSta))
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  CDL.Integers.Sources.Constant conInt[nSta](k=fill(0, nSta))
    "Constant zero Integer source"
    annotation (Placement(transformation(extent={{-170,-130},{-150,-110}})));
  CDL.Logical.Sources.Constant con[nSta](k=fill(false, nSta))
    "Constant Boolean False signal"
    annotation (Placement(transformation(extent={{-170,-160},{-150,-140}})));
  CDL.Integers.Sources.Constant conInt1[nSta](k=staInd)
    "Constant stage Integer source"
    annotation (Placement(transformation(extent={{-170,-190},{-150,-170}})));
  CDL.Integers.Sources.Constant conInt2[2](k={1,2})
    "Constant stage Integer source"
    annotation (Placement(transformation(extent={{60,-138},{80,-118}})));
  CDL.Interfaces.IntegerInput supResReq "Hot water supply reset requests"
    annotation (Placement(transformation(extent={{-240,110},{-200,150}}),
        iconTransformation(extent={{-240,80},{-200,120}})));
  CDL.Discrete.TriggeredSampler triSam
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    quantity="ThermodynamicTemperature")
                                        "Measured outdoor air temperature" annotation (
      Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-240,40},{-200,80}})));
  CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC",
    quantity="ThermodynamicTemperature")
                                        "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-240,50},{-200,90}}),
        iconTransformation(extent={{-240,0},{-200,40}})));
  CDL.Interfaces.RealInput TRet(
    final unit="K",
    displayUnit="degC",
    quantity="ThermodynamicTemperature") "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
        iconTransformation(extent={{-240,-40},{-200,0}})));
  CDL.Interfaces.RealInput VHotWat_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    quantity="VolumeFlowRate") "Measured hot water flowrate"
    annotation (Placement(transformation(extent={{-240,-10},{-200,30}}),
        iconTransformation(extent={{-240,-80},{-200,-40}})));
  CDL.Interfaces.RealInput dpHotWat_remote[nSen_remoteDp]
    "Measured differential pressure between hot water supply and return"
    annotation (Placement(transformation(extent={{-240,-70},{-200,-30}}),
        iconTransformation(extent={{-240,-120},{-200,-80}})));
  CDL.Continuous.Sources.Constant dpHotWatSet(k=maxLocDp)
    "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{80,-180},{100,-160}})));
  CDL.Interfaces.BooleanOutput yBoi[nBoi] "Boiler status vector" annotation (
      Placement(transformation(extent={{300,120},{340,160}}),
        iconTransformation(extent={{220,60},{260,100}})));
  CDL.Interfaces.BooleanOutput yPum[nPumPri] "Pump status vector" annotation (
      Placement(transformation(extent={{300,-160},{340,-120}}),
        iconTransformation(extent={{220,-60},{260,-20}})));
  CDL.Logical.LogicalSwitch logSwi1[nBoi] "Logical switch"
    annotation (Placement(transformation(extent={{170,130},{190,150}})));
  CDL.Routing.BooleanReplicator booRep(nout=nBoi) "Boolean replicator"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  CDL.Logical.Switch swi[nBoi] "Real switch"
    annotation (Placement(transformation(extent={{180,60},{200,80}})));
  CDL.Interfaces.RealOutput yHotWatIsoVal[nBoi]
    "Boiler hot water isolation valve position vector" annotation (Placement(
        transformation(extent={{300,50},{340,90}}), iconTransformation(extent={{
            220,20},{260,60}})));
  CDL.Interfaces.RealOutput yPumSpe[nPumPri] "Pump speed vector" annotation (
      Placement(transformation(extent={{300,-190},{340,-150}}),
        iconTransformation(extent={{220,-100},{260,-60}})));
  CDL.Interfaces.RealOutput yBypValPos "Bypass valve position" annotation (
      Placement(transformation(extent={{300,-50},{340,-10}}),
        iconTransformation(extent={{220,-20},{260,20}})));
  CDL.Conversions.RealToInteger reaToInt1
    annotation (Placement(transformation(extent={{-50,170},{-30,190}})));
  CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{-110,170},{-90,190}})));
  CDL.Logical.Pre pre3[nPumPri] "Logical pre block"
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));
  CDL.Logical.Pre pre4 "Logical pre block"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  CDL.Logical.Pre pre5[nBoi] "Logical pre block"
    annotation (Placement(transformation(extent={{170,170},{190,190}})));
  CDL.Logical.Pre pre6 "Logical pre block"
    annotation (Placement(transformation(extent={{40,150},{60,170}})));
  CDL.Conversions.IntegerToReal intToRea2
    annotation (Placement(transformation(extent={{20,210},{40,230}})));
  CDL.Conversions.RealToInteger reaToInt2
    annotation (Placement(transformation(extent={{80,210},{100,230}})));
  CDL.Logical.Pre pre1 "Logical pre block"
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));
  CDL.Discrete.UnitDelay uniDel(samplePeriod=1)
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  CDL.Discrete.UnitDelay uniDel1(samplePeriod=1)
    annotation (Placement(transformation(extent={{50,210},{70,230}})));
  CDL.Discrete.UnitDelay uniDel2[nBoi](samplePeriod=1)
    annotation (Placement(transformation(extent={{180,20},{200,40}})));
  CDL.Conversions.IntegerToReal intToRea3[nSta]
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  CDL.Discrete.UnitDelay uniDel3[nSta](samplePeriod=fill(1, nSta))
    annotation (Placement(transformation(extent={{-90,-190},{-70,-170}})));
  CDL.Conversions.RealToInteger reaToInt3[nSta]
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  CDL.Interfaces.BooleanInput uBoiAva[nBoi] "Boiler availability status signal"
    annotation (Placement(transformation(extent={{-240,-110},{-200,-70}}),
        iconTransformation(extent={{-240,-160},{-200,-120}})));
  Generic.PlantDisable plaDis(
    primaryOnly=primaryOnly,
    isHeadered=isHeadered,
    nBoi=nBoi,
    delBoiDis=delBoiEna)
    annotation (Placement(transformation(extent={{240,60},{260,80}})));
equation
  connect(staSetCon.yBoi, upProCon.uBoiSet) annotation (Line(points={{-78,-12},
          {86,-12},{86,96},{118,96}},color={255,0,255}));
  connect(staSetCon.yBoi, dowProCon.uBoiSet) annotation (Line(points={{-78,-12},
          {86,-12},{86,38},{118,38}}, color={255,0,255}));
  connect(staSetCon.ySta, upProCon.uStaSet) annotation (Line(points={{-78,4},{
          20,4},{20,85.0909},{118,85.0909}},
                                color={255,127,0}));
  connect(staSetCon.ySta, dowProCon.uStaSet) annotation (Line(points={{-78,4},{20,
          4},{20,26},{118,26}}, color={255,127,0}));
  connect(staSetCon.yStaTyp, upProCon.uStaTyp) annotation (Line(points={{-78,8},
          {24,8},{24,88.7273},{118,88.7273}},
                                    color={255,127,0}));
  connect(staSetCon.yChaUpEdg, upProCon.uStaUpPro) annotation (Line(points={{-78,0},
          {78,0},{78,92.3636},{118,92.3636}},
                                       color={255,0,255}));
  connect(staSetCon.yChaDowEdg, dowProCon.uStaDowPro) annotation (Line(points={{-78,-8},
          {82,-8},{82,34},{118,34}},         color={255,0,255}));
  connect(conSet.yMinBypValPos, bypValPos.uMinBypValPos) annotation (Line(
        points={{82,-94},{110,-94},{110,-46},{118,-46}}, color={0,0,127}));
  connect(staSetCon.yStaTyp, conSet.uStaTyp) annotation (Line(points={{-78,8},{24,
          8},{24,-106},{58,-106}},
                                 color={255,127,0}));
  connect(staSetCon.yChaUpEdg, lat.u) annotation (Line(points={{-78,0},{-64,0},{
          -64,30},{-58,30}}, color={255,0,255}));
  connect(staSetCon.yChaDowEdg, lat.clr) annotation (Line(points={{-78,-8},{-60,
          -8},{-60,24},{-58,24}}, color={255,0,255}));
  connect(lat.y, logSwi.u2) annotation (Line(points={{-34,30},{-30,30},{-30,160},
          {-12,160}}, color={255,0,255}));
  connect(upProCon.yOnOff, logSwi.u1) annotation (Line(points={{142,95.0909},{
          150,95.0909},{150,144},{-20,144},{-20,168},{-12,168}},
                                                    color={255,0,255}));
  connect(dowProCon.yOnOff, logSwi.u3) annotation (Line(points={{142,36},{154,36},
          {154,140},{-26,140},{-26,152},{-12,152}}, color={255,0,255}));
  connect(lat.y, intSwi.u2) annotation (Line(points={{-34,30},{-30,30},{-30,120},
          {-12,120}}, color={255,0,255}));
  connect(upProCon.yLasDisBoi, intSwi.u1) annotation (Line(points={{142,86},{
          146,86},{146,72},{-26,72},{-26,128},{-12,128}},
                                                      color={255,127,0}));
  connect(dowProCon.yLasDisBoi, intSwi.u3) annotation (Line(points={{142,26},{150,
          26},{150,68},{-20,68},{-20,112},{-12,112}}, color={255,127,0}));
  connect(lat1.y, hotWatSupTemRes.uStaCha)
    annotation (Line(points={{-132,70},{-62,70}}, color={255,0,255}));
  connect(staSetCon.yStaTyp, hotWatSupTemRes.uTyp) annotation (Line(points={{-78,8},
          {-74,8},{-74,38},{-110,38},{-110,66},{-62,66}},    color={255,127,0}));
  connect(minBoiFloSet1.VHotWatMinSet_flow, staSetCon.VMinSet_flow) annotation (
     Line(points={{-98,-140},{-92,-140},{-92,-88},{-114,-88},{-114,3},{-102,3}},
        color={0,0,127}));
  connect(conInt.y, minBoiFloSet1.uLasDisBoi) annotation (Line(points={{-148,-120},
          {-140,-120},{-140,-134},{-122,-134}},       color={255,127,0}));
  connect(con.y, minBoiFloSet1.uOnOff) annotation (Line(points={{-148,-150},{-140,
          -150},{-140,-138},{-122,-138}},      color={255,0,255}));
  connect(con.y, minBoiFloSet1.uStaChaPro) annotation (Line(points={{-148,-150},
          {-140,-150},{-140,-142},{-122,-142}}, color={255,0,255}));
  connect(conInt2.y, priPumCon.uPumLeaLag) annotation (Line(points={{82,-128},{94,
          -128},{94,-113},{118,-113}},      color={255,127,0}));
  connect(supResReq, hotWatSupTemRes.nHotWatSupResReq) annotation (Line(points={{-220,
          130},{-116,130},{-116,74},{-62,74}},        color={255,127,0}));
  connect(supResReq, plaEna.supResReq) annotation (Line(points={{-220,130},{
          -186,130},{-186,-5},{-182,-5}},
                                        color={255,127,0}));
  connect(reaToInt.u, triSam.y)
    annotation (Line(points={{-12,-40},{-18,-40}}, color={0,0,127}));
  connect(triSam.u, intToRea.y)
    annotation (Line(points={{-42,-40},{-48,-40}}, color={0,0,127}));
  connect(reaToInt.y, staSetCon.u) annotation (Line(points={{12,-40},{16,-40},{16,
          -60},{-126,-60},{-126,-15},{-102,-15}}, color={255,127,0}));
  connect(TOut, plaEna.TOut) annotation (Line(points={{-220,100},{-190,100},{
          -190,-15},{-182,-15}},
                          color={0,0,127}));
  connect(TSup, staSetCon.THotWatSup) annotation (Line(points={{-220,70},{-168,70},
          {-168,34},{-110,34},{-110,6},{-102,6}}, color={0,0,127}));
  connect(TRet, staSetCon.THotWatRet) annotation (Line(points={{-220,40},{-172,40},
          {-172,30},{-120,30},{-120,12},{-102,12}}, color={0,0,127}));
  connect(TRet, conSet.THotWatRet) annotation (Line(points={{-220,40},{-172,40},
          {-172,30},{-120,30},{-120,-94},{58,-94}}, color={0,0,127}));
  connect(VHotWat_flow, staSetCon.VHotWat_flow) annotation (Line(points={{-220,10},
          {-180,10},{-180,20},{-114,20},{-114,9},{-102,9}}, color={0,0,127}));
  connect(VHotWat_flow, upProCon.VHotWat_flow) annotation (Line(points={{-220,10},
          {-180,10},{-180,108},{114,108},{114,114.182},{118,114.182}},
                                                               color={0,0,127}));
  connect(VHotWat_flow, dowProCon.VHotWat_flow) annotation (Line(points={{-220,10},
          {-180,10},{-180,108},{114,108},{114,58},{118,58}}, color={0,0,127}));
  connect(VHotWat_flow, bypValPos.VHotWat_flow) annotation (Line(points={{-220,10},
          {-180,10},{-180,108},{114,108},{114,-38},{118,-38}}, color={0,0,127}));
  connect(VHotWat_flow, priPumCon.VHotWat_flow) annotation (Line(points={{-220,10},
          {-180,10},{-180,108},{114,108},{114,-125},{118,-125}}, color={0,0,127}));
  connect(dpHotWat_remote, priPumCon.dpHotWat_remote) annotation (Line(points={{-220,
          -50},{-180,-50},{-180,-100},{10,-100},{10,-106},{20,-106},{20,-146},{118,
          -146}},
        color={0,0,127}));
  connect(dpHotWatSet.y, priPumCon.dpHotWatSet) annotation (Line(points={{102,-170},
          {110,-170},{110,-149},{118,-149}}, color={0,0,127}));
  connect(upProCon.yBoi, logSwi1.u1) annotation (Line(points={{142,114.182},{
          166,114.182},{166,148},{168,148}},
                                color={255,0,255}));
  connect(dowProCon.yBoi, logSwi1.u3) annotation (Line(points={{142,58},{158,58},
          {158,132},{168,132}}, color={255,0,255}));
  connect(lat.y, booRep.u) annotation (Line(points={{-34,30},{-30,30},{-30,104},
          {34,104},{34,120},{38,120}}, color={255,0,255}));
  connect(booRep.y, logSwi1.u2) annotation (Line(points={{62,120},{102,120},{102,
          136},{162,136},{162,140},{168,140}}, color={255,0,255}));
  connect(upProCon.yHotWatIsoVal, swi.u1) annotation (Line(points={{142,101.455},
          {172,101.455},{172,78},{178,78}},
                                   color={0,0,127}));
  connect(dowProCon.yHotWatIsoVal, swi.u3) annotation (Line(points={{142,44},{164,
          44},{164,62},{178,62}}, color={0,0,127}));
  connect(booRep.y, swi.u2) annotation (Line(points={{62,120},{102,120},{102,136},
          {162,136},{162,70},{178,70}}, color={255,0,255}));
  connect(priPumCon.yPumSpe, yPumSpe) annotation (Line(points={{142,-154},{170,
          -154},{170,-170},{320,-170}},
                                  color={0,0,127}));
  connect(bypValPos.yBypValPos, yBypValPos) annotation (Line(points={{142,-40},
          {148,-40},{148,-30},{320,-30}},color={0,0,127}));
  connect(staSetCon.ySta, intToRea1.u) annotation (Line(points={{-78,4},{20,4},{
          20,50},{-120,50},{-120,180},{-112,180}},  color={255,127,0}));
  connect(reaToInt1.y, minBoiFloSet.uStaSet) annotation (Line(points={{-28,180},
          {90,180},{90,174},{110,174}}, color={255,127,0}));
  connect(plaEna.yPla, staSetCon.uPla) annotation (Line(points={{-158,-10},{
          -126,-10},{-126,-12},{-102,-12}}, color={255,0,255}));
  connect(bypValPos.yBypValPos, staSetCon.uBypValPos) annotation (Line(points={{
          142,-40},{148,-40},{148,-82},{-108,-82},{-108,0},{-102,0}}, color={0,0,
          127}));
  connect(staSetCon.yChaEdg, pre4.u) annotation (Line(points={{-78,-4},{-26,-4},
          {-26,30},{-22,30}}, color={255,0,255}));
  connect(pre4.y, lat1.u) annotation (Line(points={{2,30},{6,30},{6,46},{-164,46},
          {-164,70},{-156,70}},     color={255,0,255}));
  connect(pre5.y, upProCon.uBoi) annotation (Line(points={{192,180},{200,180},{
          200,200},{160,200},{160,154},{106,154},{106,99.6364},{118,99.6364}},
                                                                     color={255,
          0,255}));
  connect(pre5.y, dowProCon.uBoi) annotation (Line(points={{192,180},{200,180},{
          200,200},{160,200},{160,154},{106,154},{106,42},{118,42}},  color={
          255,0,255}));
  connect(hotWatSupTemRes.TPlaHotWatSupSet, staSetCon.THotWatSupSet)
    annotation (Line(points={{-38,74},{-34,74},{-34,58},{-106,58},{-106,15},{-102,
          15}}, color={0,0,127}));
  connect(reaToInt.y, conSet.uCurSta) annotation (Line(points={{12,-40},{16,-40},
          {16,-100},{58,-100},{58,-100}}, color={255,127,0}));
  connect(reaToInt1.y, intToRea.u) annotation (Line(points={{-28,180},{28,180},{
          28,-20},{-76,-20},{-76,-40},{-72,-40}}, color={255,127,0}));
  connect(reaToInt1.y, hotWatSupTemRes.uCurStaSet) annotation (Line(points={{-28,180},
          {28,180},{28,96},{-66,96},{-66,62},{-62,62}},      color={255,127,0}));
  connect(minBoiFloSet.VHotWatMinSet_flow, upProCon.VMinHotWatSet_flow)
    annotation (Line(points={{134,180},{140,180},{140,150},{110,150},{110,
          110.545},{118,110.545}},
                     color={0,0,127}));
  connect(minBoiFloSet.VHotWatMinSet_flow, dowProCon.VMinHotWatSet_flow)
    annotation (Line(points={{134,180},{140,180},{140,150},{110,150},{110,54},{118,
          54}}, color={0,0,127}));
  connect(minBoiFloSet.VHotWatMinSet_flow, bypValPos.VHotWatMinSet_flow)
    annotation (Line(points={{134,180},{140,180},{140,150},{110,150},{110,-34},{
          118,-34}}, color={0,0,127}));
  connect(logSwi.y, pre6.u)
    annotation (Line(points={{12,160},{38,160}}, color={255,0,255}));
  connect(pre6.y, minBoiFloSet.uOnOff) annotation (Line(points={{62,160},{94,160},
          {94,182},{110,182}}, color={255,0,255}));
  connect(intSwi.y, intToRea2.u) annotation (Line(points={{12,120},{16,120},{16,
          220},{18,220}}, color={255,127,0}));
  connect(reaToInt2.y, minBoiFloSet.uLasDisBoi) annotation (Line(points={{102,220},
          {106,220},{106,186},{110,186}}, color={255,127,0}));
  connect(upProCon.yStaChaPro, or2.u1) annotation (Line(points={{142,107.818},{
          146,107.818},{146,108},{168,108},{168,0},{218,0}},       color={255,0,
          255}));
  connect(dowProCon.yStaChaPro, or2.u2) annotation (Line(points={{142,51},{158,51},
          {158,-8},{218,-8}},                  color={255,0,255}));
  connect(pre1.y, triSam.trigger) annotation (Line(points={{92,-50},{98,-50},{98,
          -64},{-30,-64},{-30,-51.8}}, color={255,0,255}));
  connect(pre1.y, staSetCon.uStaChaProEnd) annotation (Line(points={{92,-50},{98,
          -50},{98,-64},{-99,-64},{-99,-22}}, color={255,0,255}));
  connect(pre1.y, minBoiFloSet.uStaChaPro) annotation (Line(points={{92,-50},{98,
          -50},{98,178},{110,178}}, color={255,0,255}));
  connect(pre1.y, lat1.clr) annotation (Line(points={{92,-50},{98,-50},{98,54},{
          -160,54},{-160,64},{-156,64}}, color={255,0,255}));
  connect(priPumCon.yHotWatPum, yPum)
    annotation (Line(points={{142,-140},{320,-140}}, color={255,0,255}));
  connect(reaToInt1.u, uniDel.y)
    annotation (Line(points={{-52,180},{-58,180}}, color={0,0,127}));
  connect(intToRea1.y, uniDel.u)
    annotation (Line(points={{-88,180},{-82,180}}, color={0,0,127}));
  connect(reaToInt2.u, uniDel1.y)
    annotation (Line(points={{78,220},{72,220}}, color={0,0,127}));
  connect(intToRea2.y, uniDel1.u)
    annotation (Line(points={{42,220},{48,220}}, color={0,0,127}));
  connect(uniDel2.y, priPumCon.uHotIsoVal) annotation (Line(points={{202,30},{
          210,30},{210,10},{102,10},{102,-122},{118,-122}}, color={0,0,127}));
  connect(uniDel2.y, dowProCon.uHotWatIsoVal) annotation (Line(points={{202,30},
          {210,30},{210,10},{102,10},{102,46},{118,46}}, color={0,0,127}));
  connect(uniDel2.y, upProCon.uHotWatIsoVal) annotation (Line(points={{202,30},
          {210,30},{210,10},{102,10},{102,103.273},{118,103.273}},
                                                           color={0,0,127}));
  connect(conInt1.y, intToRea3.u)
    annotation (Line(points={{-148,-180},{-122,-180}}, color={255,127,0}));
  connect(intToRea3.y, uniDel3.u)
    annotation (Line(points={{-98,-180},{-92,-180}}, color={0,0,127}));
  connect(uniDel3.y, reaToInt3.u)
    annotation (Line(points={{-68,-180},{-62,-180}}, color={0,0,127}));
  connect(reaToInt3.y, minBoiFloSet1.uStaSet) annotation (Line(points={{-38,
          -180},{-30,-180},{-30,-160},{-130,-160},{-130,-146},{-122,-146}},
        color={255,127,0}));
  connect(priPumCon.yHotWatPum, pre3.u) annotation (Line(points={{142,-140},{
          150,-140},{150,-110},{158,-110}}, color={255,0,255}));
  connect(pre3.y, bypValPos.uPumSta) annotation (Line(points={{182,-110},{190,
          -110},{190,-16},{106,-16},{106,-42},{118,-42}}, color={255,0,255}));
  connect(pre3.y, priPumCon.uHotWatPum) annotation (Line(points={{182,-110},{
          190,-110},{190,-84},{106,-84},{106,-116},{118,-116}}, color={255,0,
          255}));
  connect(pre3.y, hotWatSupTemRes.uHotWatPumSta) annotation (Line(points={{182,
          -110},{190,-110},{190,-16},{-70,-16},{-70,78},{-62,78}}, color={255,0,
          255}));
  connect(uBoiAva, staSetCon.uBoiAva) annotation (Line(points={{-220,-90},{-140,
          -90},{-140,-18},{-102,-18}}, color={255,0,255}));
  connect(plaEna.yPla, upProCon.uPlaEna) annotation (Line(points={{-158,-10},{
          -126,-10},{-126,100},{70,100},{70,81.4545},{118,81.4545}}, color={255,
          0,255}));
  connect(plaDis.yHotWatIsoVal, yHotWatIsoVal) annotation (Line(points={{262,67},
          {280,67},{280,70},{320,70}},   color={0,0,127}));
  connect(plaDis.yHotWatIsoVal, uniDel2.u) annotation (Line(points={{262,67},{280,
          67},{280,50},{174,50},{174,30},{178,30}},       color={0,0,127}));
  connect(plaDis.yBoi, yBoi) annotation (Line(points={{262,77},{280,77},{280,140},
          {320,140}},      color={255,0,255}));
  connect(plaDis.yBoi, pre5.u) annotation (Line(points={{262,77},{280,77},{280,160},
          {164,160},{164,180},{168,180}},      color={255,0,255}));
  connect(or2.y, plaDis.uStaChaProEnd) annotation (Line(points={{242,0},{250,0},
          {250,40},{220,40},{220,62},{238,62}}, color={255,0,255}));
  connect(swi.y, plaDis.uHotWatIsoVal) annotation (Line(points={{202,70},{220,70},
          {220,70},{238,70}}, color={0,0,127}));
  connect(logSwi1.y, plaDis.uBoi) annotation (Line(points={{192,140},{230,140},{
          230,74},{238,74}}, color={255,0,255}));
  connect(plaDis.yStaChaPro, pre1.u) annotation (Line(points={{262,63},{266,63},
          {266,-22},{60,-22},{60,-50},{68,-50}}, color={255,0,255}));
  connect(plaDis.yPumChaPro, priPumCon.uPumChaPro) annotation (Line(points={{262,
          73},{270,73},{270,-90},{98,-90},{98,-137},{118,-137}}, color={255,0,255}));
  connect(plaEna.yPla, plaDis.uPla) annotation (Line(points={{-158,-10},{-126,-10},
          {-126,100},{94,100},{94,124},{226,124},{226,78},{238,78}}, color={255,
          0,255}));
  connect(priPumCon.yPumChaPro, plaDis.uPumChaPro) annotation (Line(points={{142,
          -126},{214,-126},{214,66},{238,66}}, color={255,0,255}));
  connect(plaEna.yPla, priPumCon.uPlaEna) annotation (Line(points={{-158,-10},{-130,
          -10},{-130,-78},{90,-78},{90,-119},{118,-119}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{300,240}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{300,
            240}})));
end Controller;
