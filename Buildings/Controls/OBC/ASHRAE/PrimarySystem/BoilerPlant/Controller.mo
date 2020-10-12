within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant;
model Controller
    "Boiler plant controller"

  parameter Boolean primaryOnly = false
    "Is the boiler plant a primary-only, condensing boiler plant?"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Boolean isHeadered = true
    "True: Headered hot water pumps;
     False: Dedicated hot water pumps"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Boolean variablePrimary = false
    "True: Variable-speed primary pumps;
     False: Fixed-speed primary pumps"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Boolean primarySecondaryFlowSensors=false "True: Flowrate sensors in primary and secondary loops;
     False: Flowrate sensor in decoupler";

  parameter Boolean primarySecondaryTemperatureSensors=false "True: Temperature sensors in primary and secondary loops;
     False: Temperature sensors in boiler supply and secondary loop"
     annotation (Dialog(tab="Primary pump control parameters",
       group="Temperature-based speed regulation",
       enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Integer nIgnReq(
    final min=0) = 0
    "Number of hot-water requests to be ignored before enablng boiler plant loop"
    annotation(dialog(tab="Plant enable/disable parameters"));

  parameter Integer nSchRow(
    final min=1) = 4
    "Number of rows to be created for plant schedule table"
    annotation(dialog(tab="Plant enable/disable parameters"));

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

  parameter Integer nPumPri = 2
    "Number of primary pumps in the boiler plant loop"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer nHotWatResReqIgn = 2
    "Number of hot-water supply temperature reset requests to be ignored"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Integer nSen_remoteDp = 2
    "Total number of remote differential pressure sensors"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer numIgnReq = 0
    "Number of ignored requests"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable= speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Integer nPum_nominal(
    final max=nPumPri,
    final min=1) = nPumPri
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Real schTab[nSchRow,2] = [0,1;6,1;18,1;24,1]
    "Table defining schedule for enabling plant"
    annotation(dialog(tab="Plant enable/disable parameters"));

  parameter Real TOutLoc(
    final unit="K",
    displayUnit="K") = 300
    "Boiler lock-out temperature for outdoor air"
    annotation(dialog(tab="Plant enable/disable parameters"));

  parameter Real locDt(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 1
    "Temperature deadband for boiler lockout"
    annotation(dialog(tab="Plant enable/disable parameters", group="Advanced"));

  parameter Real plaOffThrTim(
    final unit="s",
    displayUnit="s") = 900
    "Minimum time for which the plant has to stay off once it has been disabled"
    annotation(dialog(tab="Plant enable/disable parameters"));

  parameter Real plaOnThrTim(
    final unit="s",
    displayUnit="s") = plaOffThrTim
    "Minimum time for which the boiler plant has to stay on once it has been enabled"
    annotation(dialog(tab="Plant enable/disable parameters"));

  parameter Real staOnReqTim(
    final unit="s",
    displayUnit="s") = 180
    "Time-limit for receiving hot-water requests to maintain enabled plant on"
    annotation(dialog(tab="Plant enable/disable parameters"));

  parameter Real boiDesCap[nBoi](
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Design boiler capacities vector"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real boiFirMin[nBoi](
    final unit="1",
    displayUnit="1")
    "Boiler minimum firing ratio"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real bMinPriPumSpeSta[nSta](
    final unit="1",
    displayUnit="1",
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
    displayUnit="s",
    final quantity="Time") = 600
    "Hold period for each stage change"
    annotation(Dialog(tab="Staging setpoint parameters", group="General parameters"));

  parameter Real avePer(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Time period for the capacity requirement rolling average"
    annotation(Dialog(tab="Staging setpoint parameters", group="Capacity requirement calculation parameters"));

  parameter Real fraNonConBoi(
    final unit="1",
    displayUnit="1") = 0.9
    "Fraction of current stage design capacity at which efficiency condition is 
    satisfied for non-condensing boilers"
    annotation(Dialog(tab="Staging setpoint parameters", group="Efficiency condition parameters"));

  parameter Real fraConBoi(
    final unit="1",
    displayUnit="1") = 1.5
    "Fraction of higher stage design capacity at which efficiency condition is 
    satisfied for condensing boilers"
    annotation(Dialog(tab="Staging setpoint parameters", group="Efficiency condition parameters"));

  parameter Real delEffCon(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Enable delay for heating capacity requirement condition"
    annotation(Dialog(tab="Staging setpoint parameters", group="Efficiency condition parameters"));

  parameter Real TDif(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 10
    "Required temperature difference between setpoint and measured temperature"
    annotation(Dialog(tab="Staging setpoint parameters", group="Failsafe condition parameters"));

  parameter Real delFaiCon(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 900
    "Enable delay for temperature condition"
    annotation(Dialog(tab="Staging setpoint parameters", group="Failsafe condition parameters"));

  parameter Real sigDif(
    final unit="1",
    displayUnit="1") = 0.1
    "Signal hysteresis deadband for flowrate measurements"
    annotation (Dialog(tab="Advanced", group="Efficiency condition parameters"));

  parameter Real TDifHys(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Temperature deadband for hysteresis loop"
    annotation(Dialog(tab="Advanced", group="Failsafe condition parameters"));

  parameter Real fraMinFir(
    final unit="1",
    displayUnit="1") = 1.1
    "Fraction of boiler minimum firing rate that required capacity needs to be
    to initiate stage-down process"
    annotation(Dialog(tab="Staging setpoint parameters", group="Staging down parameters"));

  parameter Real delMinFir(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Delay for staging based on minimum firing rate of current stage"
    annotation(Dialog(tab="Staging setpoint parameters", group="Staging down parameters"));

  parameter Real fraDesCap(
    final unit="1",
    displayUnit="1") = 0.8
    "Fraction of design capacity of next lower stage that heating capacity needs
    to be for staging down"
    annotation(Dialog(tab="Staging setpoint parameters", group="Staging down parameters"));

  parameter Real delDesCapNonConBoi(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Enable delay for capacity requirement condition for non-condensing boilers"
    annotation(Dialog(tab="Staging setpoint parameters", group="Staging down parameters"));

  parameter Real delDesCapConBoi(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for capacity requirement condition for condensing boilers"
    annotation(Dialog(tab="Staging setpoint parameters", group="Staging down parameters"));

  parameter Real delBypVal(
    final unit="s",
    displayUnit="s",
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
    displayUnit="K",
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
    displayUnit="s",
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
    displayUnit="1") = 0
    "Adjustment for signal received when bypass valve is closed"
    annotation (
      Evaluate=true,
      Dialog(
        enable=primaryOnly,
        tab="Advanced",
        group="Staging down parameters"));

  parameter Real dTemp(
    final unit="K",
    displayUnit="K",
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

  parameter Real TPlaHotWatSetMax(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 353.15
    "The maximum allowed hot-water setpoint temperature for the plant"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real TConBoiHotWatSetMax(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 353.15
    "The maximum allowed hot water setpoint temperature for condensing boilers"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real TConBoiHotWatSetOff(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = -10
    "The offset for hot water setpoint temperature for condensing boilers in 
    non-condensing stage type"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Boiler plant configuration parameters"));

  parameter Real THotWatSetMinNonConBoi(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 341.48
    "The minimum allowed hot-water setpoint temperature for non-condensing boilers"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real THotWatSetMinConBoi(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 305.37
    "The minimum allowed hot-water setpoint temperature for condensing boilers"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real delTimVal(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Delay time"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real samPerVal(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Sample period"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real triAmoVal(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = -2
    "Setpoint trim value"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real resAmoVal(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 3
    "Setpoint respond value"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real maxResVal(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 7
    "Setpoint maximum respond value"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real holTimVal(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Minimum setpoint hold time for stage change process"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Boiler plant configuration parameters"));

  parameter Real TMinSupNonConBoi(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 333.2
    "Minimum supply temperature required for non-condensing boilers"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real delProSupTemSet(
    final unit="s",
    displayUnit="s",
    final quantity="time")=300
    "Process time-out for hot water supply temperature setpoint reset"
    annotation (Dialog(tab="Staging process parameters",group="Time and delay parameters"));

  parameter Real delEnaMinFloSet(
    final unit="s",
    displayUnit="s",
    final quantity="time")=60
    "Enable delay after minimum flow setpoint is achieved in bypass valve"
    annotation (Dialog(tab="Staging process parameters",group="Time and delay parameters"));

  parameter Real chaIsoValRat(
    final unit="1/s",
    displayUnit="1/s") = 1/60
    "Rate at which to slowly change isolation valve position, should be determined
    in the field"
    annotation (Dialog(tab="Staging process parameters",group="Time and delay parameters"));

  parameter Real chaIsoValTim(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 60
    "Time to slowly change isolation valve position from fully closed to fully open,
    should be determined in the field"
    annotation (Dialog(tab="Staging process parameters", group="Time and delay parameters"));

  parameter Real delPreBoiEna(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 30
    "Time delay after valve and pump change process has been completed before
    starting boiler change process"
    annotation (Dialog(tab="Staging process parameters",group="Time and delay parameters"));

  parameter Real boiChaProOnTim(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Enabled boiler operation time to indicate if it is proven on during a staging
    process where one boiler is turned on and the other is turned off"
    annotation (Dialog(tab="Staging process parameters",group="Time and delay parameters"));

  parameter Real delBoiEna(
    final unit="s",
    displayUnit="s",
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
    annotation (Dialog(tab="Primary pump control parameters", group="DP-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP));

  parameter Real minLocDp(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6) = 5*6894.75
    "Minimum hot water loop local differential pressure setpoint"
    annotation (Dialog(tab="Primary pump control parameters",
      group="DP-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP));

  parameter Real offTimThr_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 180
    "Threshold to check lead boiler off time"
    annotation (Dialog(tab="Primary pump control parameters", group="Pump staging parameters"));

  parameter Real timPer_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 600
    "Delay time period for enabling and disabling lag pumps"
    annotation (Dialog(tab="Primary pump control parameters", group="Pump staging parameters"));

  parameter Real staCon_priPum(
    final unit="1",
    displayUnit="1") = -0.03
    "Constant used in the staging equation"
    annotation (Dialog(tab="Primary pump control parameters", group="Pump staging parameters"));

  parameter Real relFloHys_priPum(
    final unit="1",
    displayUnit="1") = 0.01
    "Constant value used in hysteresis for checking relative flow rate"
    annotation (Dialog(tab="Primary pump control parameters", group="Pump staging parameters"));

  parameter Real delTim_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 900
    "Delay time"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real samPer_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 120
    "Sample period of component"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real triAmo_priPum(
    final unit="1",
    displayUnit="1") = -0.02
    "Trim amount"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real resAmo_priPum(
    final unit="1",
    displayUnit="1") = 0.03
    "Respond amount"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real maxRes_priPum(
    final unit="1",
    displayUnit="1") = 0.06
    "Maximum response per time interval"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real twoReqLimLow_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1.2
    "Lower limit of hysteresis loop sending two requests"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real twoReqLimHig_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 2
    "Higher limit of hysteresis loop sending two requests"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real oneReqLimLow_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.2
    "Lower limit of hysteresis loop sending one request"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real oneReqLimHig_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Higher limit of hysteresis loop sending one request"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real k_priPum(
    final unit="1",
    displayUnit="1",
    final min=0) = 1
    "Gain of controller"
    annotation (Dialog(tab="Primary pump control parameters", group="PID parameters"));

  parameter Real Ti_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Primary pump control parameters", group="PID parameters"));

  parameter Real Td_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Primary pump control parameters", group="PID parameters"));

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

    ////////////Secondary pump parameters

    parameter Boolean variableSecondary = false
    "True: Variable-speed secondary pumps;
    False: Fixed-speed secondary pumps"
    annotation (Dialog(group="Plant parameters"));

  parameter Boolean secondaryFlowSensor = true
    "True: Flow sensor in secondary loop;
    False: No flow sensor in secondary loop"
    annotation (Dialog(group="Plant parameters",
      enable=variableSecondary));

  parameter Integer nPumSec = 2
    "Total number of secondary hot water pumps"
    annotation (Dialog(group="Plant parameters"));

  parameter Integer nSenSec=2
    "Total number of remote differential pressure sensors in secondary loop"
    annotation (Dialog(group="Plant parameters"));

  parameter Integer nPumSec_nominal(
    final max=nPum,
    final min=1) = nPumSec
    "Total number of pumps that operate at design conditions in secondary loop"
    annotation (Dialog(group="Plant parameters"));

  parameter Real minPumSpeSec(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=maxPumSpe) = 0.1
    "Minimum pump speed"
    annotation (Dialog(group="Pump parameters", enable=variableSecondary));

  parameter Real maxPumSpeSec(
    final unit="1",
    displayUnit="1",
    final min=minPumSpe,
    final max=1) = 1
    "Maximum pump speed"
    annotation (Dialog(group="Pump parameters", enable=variableSecondary));

  parameter Real VHotWatSec_flow_nominal(
    final min=1e-6,
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") = 0.5
    "Secondary loop design hot water flow rate"
    annotation (Dialog(group="Plant parameters"));

  parameter Real maxLocDpSec(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6) = 5*6894.75
    "Maximum hot water loop local differential pressure setpoint in secondary loop"
    annotation (Dialog(tab="Secondary pump control parameters", group="DP-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP));

  parameter Real minLocDpSec(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6) = 5*6894.75
    "Minimum hot water loop local differential pressure setpoint in secondary loop"
    annotation (Dialog(tab="Pump control parameters",
      group="DP-based speed regulation",
      enable = speedControlType == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP));

  parameter Real offTimThr(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 180
    "Threshold to check lead boiler off time"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=variableSecondary and secondaryFlowSensor));

  parameter Real timPerSec(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 600
    "Delay time period for enabling and disabling secondary lag pumps"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=variableSecondary and secondaryFlowSensor));

  parameter Real staConSec(
    final unit="1",
    displayUnit="1") = -0.03
    "Constant used in the staging equation"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=variableSecondary and secondaryFlowSensor));

  parameter Real speLim(
    final unit="1",
    displayUnit="1") = 0.9
    "Speed limit with longer enable delay for enabling next lag pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=variableSecondary and not secondaryFlowSensor));

  parameter Real speLim1(
    final unit="1",
    displayUnit="1") = 0.99
    "Speed limit with shorter enable delay for enabling next lag pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=variableSecondary and not secondaryFlowSensor));

  parameter Real speLim2(
    final unit="1",
    displayUnit="1") = 0.4
    "Speed limit for disabling last lag pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=variableSecondary and not secondaryFlowSensor));

  parameter Real timPer1(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for enabling next lag pump at speed limit speLim"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=variableSecondary and not secondaryFlowSensor));

  parameter Real timPer2(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 60
    "Delay time period for enabling next lag pump at speed limit speLim1"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=variableSecondary and not secondaryFlowSensor));

  parameter Real timPer3(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 600
    "Delay time period for disabling last lag pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=variableSecondary and not secondaryFlowSensor));

  parameter Real k_sec(
    final unit="1",
    displayUnit="1",
    final min=0) = 1
    "Gain of controller"
    annotation (Dialog(tab="Pump control parameters",
      group="PID parameters",
      enable=variableSecondary));

  parameter Real Ti_sec(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Pump control parameters",
      group="PID parameters",
      enable=variableSecondary));

  parameter Real Td_sec(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Pump control parameters",
      group="PID parameters",
      enable=variableSecondary));

  parameter Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes
    speedControlTypeSec = Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.remoteDP
    "Speed regulation method"
    annotation (Dialog(group="Plant parameters", enable=variableSecondary));

// protected
  parameter Integer staInd[nSta]={i for i in 1:nSta}
    "Staging indices starting at 1";

  parameter Integer priPumInd[nPumPri]={i for i in 1:nPumPri}
    "Vector of primary pump indices up to total number of primary pumps";

  parameter Integer secPumInd[nPumSec]={i for i in 1:nPumSec}
    "Vector of secondary pump indices up to total number of secondary pumps";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable plaEna(
    nIgnReq=nIgnReq,
    nSchRow=nSchRow,
    schTab=schTab,
    TOutLoc=TOutLoc,
    plaOffThrTim=plaOffThrTim,
    plaOnThrTim=plaOnThrTim,
    staOnReqTim=staOnReqTim)
    "Plant enable controller"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.SetpointController staSetCon(
    primaryOnly=primaryOnly,
    nBoi=nBoi,
    boiTyp=boiTyp,
    nSta=nSta,
    staMat=staMat,
    boiDesCap=boiDesCap,
    boiFirMin=boiFirMin,
    boiMinPriPumSpeSta=minPriPumSpeSta,
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
    "Staging setpoint controller"
    annotation (Placement(transformation(extent={{-100,-20},{-80,16}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up upProCon(
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
    "Stage-up process controller"
            annotation (Placement(transformation(extent={{120,76},{140,116}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Down dowProCon(
    primaryOnly=primaryOnly,
    isHeadered=isHeadered,
    nBoi=nBoi,
    nSta=nSta,
    chaIsoValTim=chaIsoValTim,
    delPreBoiEna=delPreBoiEna,
    boiChaProOnTim=boiChaProOnTim,
    delBoiEna=delBoiEna)
    "Stage-down process controller"
            annotation (Placement(transformation(extent={{120,20},{140,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller priPumCon(
    isHeadered=false,
    primaryOnly=false,
    variablePrimary=true,
    primarySecondaryFlowSensors=primarySecondaryFlowSensors,
    primarySecondaryTemperatureSensors=primarySecondaryTemperatureSensors,
    nPum=nPumPri,
    nBoi=nBoi,
    nSen=nSenPri_remoteDp,
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
    speedControlType=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature)
    "Primary pump controller"
    annotation (Placement(transformation(extent={{120,-168},{140,-112}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.BypassValve.BypassValvePosition bypValPos(nPum=nPumPri,
    k=k_bypVal,
    Ti=Ti_bypVal,
    Td=Td_bypVal) if primaryOnly
    "Bypass valve controller"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.HotWaterSupplyTemperatureReset hotWatSupTemRes(
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
    "Hot water supply temperature setpoint reset controller"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.MinimumFlowSetPoint minBoiFloSet(
    nBoi=nBoi,
    nSta=nSta,
    staMat=staMat,
    minFloSet=minFloSet,
    maxFloSet=maxFloSet,
    bypSetRat=bypSetRat) if primaryOnly
    "Minimum flow setpoint for the primary loop"
    annotation (Placement(transformation(extent={{112,170},{132,190}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical Or"
    annotation (Placement(transformation(extent={{220,-10},{240,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.CondensationControl conSet(
    primaryOnly=primaryOnly,
    variablePrimary=variablePrimary,
    nSta=nSta,
    TRetSet=TRetSet,
    TRetMinAll=TRetMinAll,
    minSecPumSpe=minSecPumSpe,
    minPriPumSpeSta=minPriPumSpeSta)
    "Condensation control setpoint controller"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Latch to identify if process is stage-up or stage-down"
    annotation (Placement(transformation(extent={{-56,20},{-36,40}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
    "Logical switch"
    annotation (Placement(transformation(extent={{-10,150},{10,170}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi
    "Integer switch"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Latch to identify if staging process is complete or not"
    annotation (Placement(transformation(extent={{-154,60},{-134,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.MinimumFlowSetPoint minBoiFloSet1[nSta](
    nBoi=fill(nBoi, nSta),
    nSta=fill(nSta, nSta),
    staMat=fill(staMat, nSta),
    minFloSet=fill(minFloSet, nSta),
    maxFloSet=fill(maxFloSet, nSta),
    bypSetRat=fill(bypSetRat, nSta))
    "Calculate vector of minimum flow setpoints for all stages"
    annotation (Placement(transformation(extent={{-110,-342},{-90,-322}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nSta](k=fill(0, nSta))
    "Constant zero Integer source"
    annotation (Placement(transformation(extent={{-160,-322},{-140,-302}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nSta](k=fill(false, nSta))
    "Constant Boolean False signal"
    annotation (Placement(transformation(extent={{-160,-352},{-140,-332}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[nSta](k=staInd)
    "Constant stage Integer source"
    annotation (Placement(transformation(extent={{-160,-382},{-140,-362}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[nPumPri](k=
        priPumInd)           "Constant stage Integer source"
    annotation (Placement(transformation(extent={{60,-138},{80,-118}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput supResReq
    "Hot water supply reset requests"
    annotation (Placement(transformation(extent={{-240,110},{-200,150}}),
        iconTransformation(extent={{-140,190},{-100,230}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Sample stage setpoint when stage change process is complete"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Integer to Real converter"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    quantity="ThermodynamicTemperature")
                                        "Measured outdoor air temperature" annotation (
      Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-140,160},{-100,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupPri(
    final unit="K",
    displayUnit="degC",
    quantity="ThermodynamicTemperature")
    "Measured hot water supply temperature" annotation (Placement(
        transformation(extent={{-240,50},{-200,90}}), iconTransformation(extent={{-140,
            130},{-100,170}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRetPri(
    final unit="K",
    displayUnit="degC",
    quantity="ThermodynamicTemperature")
    "Measured hot water primary return temperature" annotation (Placement(
        transformation(extent={{-240,20},{-200,60}}), iconTransformation(extent={{-140,
            100},{-100,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatPri_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    quantity="VolumeFlowRate") "Measured hot water primary circuit flowrate"
    annotation (Placement(transformation(extent={{-240,-10},{-200,30}}),
        iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatPri_remote[
    nSenPri_remoteDp]
    "Measured differential pressure between hot water supply and return in primary circuit"
    annotation (Placement(transformation(extent={{-240,-70},{-200,-30}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpHotWatSet(k=
        priMaxLocDp) "Differential pressure setpoint for primary circuit"
    annotation (Placement(transformation(extent={{60,-180},{80,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoi[nBoi]
    "Boiler status vector" annotation (
      Placement(transformation(extent={{300,120},{340,160}}),
        iconTransformation(extent={{100,70},{140,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPriPum[nPumPri]
    "Primary pump enable status vector" annotation (Placement(transformation(
          extent={{300,-160},{340,-120}}), iconTransformation(extent={{100,-20},
            {140,20}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{170,130},{190,150}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi[nBoi] if isHeadered
    "Real switch"
    annotation (Placement(transformation(extent={{180,60},{200,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatIsoVal[nBoi] if
    isHeadered
    "Boiler hot water isolation valve position vector" annotation (Placement(
        transformation(extent={{300,50},{340,90}}), iconTransformation(extent={{100,40},
            {140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPriPumSpe[nPumPri] if
    variablePrimary
    "Primary pump speed vector" annotation (Placement(transformation(extent={{
            300,-190},{340,-150}}), iconTransformation(extent={{100,-50},{140,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBypValPos if primaryOnly
    "Bypass valve position" annotation (
      Placement(transformation(extent={{300,-50},{340,-10}}),
        iconTransformation(extent={{100,10},{140,50}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-50,170},{-30,190}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-110,170},{-90,190}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3[nPumPri] "Logical pre block"
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre4
    "Logical pre block"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre5[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{170,170},{190,190}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre6
    "Logical pre block"
    annotation (Placement(transformation(extent={{40,150},{60,170}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{20,210},{40,230}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{80,210},{100,230}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Logical pre block"
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(samplePeriod=1)
    "Unit delay"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel1(samplePeriod=1)
    "Unit delay"
    annotation (Placement(transformation(extent={{50,210},{70,230}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel2[nBoi](samplePeriod=1) if
    isHeadered
    "Unit delay"
    annotation (Placement(transformation(extent={{180,20},{200,40}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea3[nSta]
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-130,-382},{-110,-362}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel3[nSta](samplePeriod=fill(1, nSta))
    "Unit delay"
    annotation (Placement(transformation(extent={{-100,-382},{-80,-362}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3[nSta]
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-70,-382},{-50,-362}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiAva[nBoi]
    "Boiler availability status signal"
    annotation (Placement(transformation(extent={{-240,-110},{-200,-70}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Generic.PlantDisable plaDis(
    primaryOnly=primaryOnly,
    isHeadered=isHeadered,
    nBoi=nBoi,
    chaHotWatIsoRat=chaIsolValRat,
    delBoiDis=delBoiEna)
    annotation (Placement(transformation(extent={{240,60},{260,80}})));

  Pumps.SecondaryPumps.Controller secPumCon(variableSecondary=true,
    secondaryFlowSensor=true,
    nPum=nPumSec,
    nPumPri=nPumPri,
    nBoi=nBoi,
    nSen=nSenSec_remoteDp,
    nPum_nominal=nPum,
    speedControlType=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.remoteDP) if not
    primaryOnly
    annotation (Placement(transformation(extent={{120,-320},{140,-280}})));
  CDL.Discrete.UnitDelay uniDel4(samplePeriod=1) "Unit delay"
    annotation (Placement(transformation(extent={{180,-200},{200,-180}})));
  CDL.Interfaces.RealInput TRetSec(
    final unit="K",
    displayUnit="degC",
    quantity="ThermodynamicTemperature")
    "Measured hot water secondary return temperature" annotation (Placement(
        transformation(extent={{-240,-40},{-200,0}}), iconTransformation(extent={{-140,40},
            {-100,80}})));
  CDL.Logical.IntegerSwitch                        intSwi1
    "Integer switch"
    annotation (Placement(transformation(extent={{60,-220},{80,-200}})));
  CDL.Logical.MultiOr mulOr(nu=3) "Multi Or"
    annotation (Placement(transformation(extent={{30,-180},{50,-160}})));
  CDL.Logical.Pre pre2 "Logical pre block"
    annotation (Placement(transformation(extent={{200,-130},{220,-110}})));
  CDL.Interfaces.RealInput VHotWatSec_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    quantity="VolumeFlowRate") "Measured hot water secondary circuit flowrate"
    annotation (Placement(transformation(extent={{-240,-230},{-200,-190}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  CDL.Integers.Sources.Constant conInt3[nPumSec](k=secPumInd)
    "Constant stage Integer source"
    annotation (Placement(transformation(extent={{60,-280},{80,-260}})));
  CDL.Interfaces.RealInput VHotWatDec_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    quantity="VolumeFlowRate")
    "Measured hot water flowrate through decoupler leg" annotation (Placement(
        transformation(extent={{-240,-260},{-200,-220}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.RealInput TSupSec(
    final unit="K",
    displayUnit="degC",
    quantity="ThermodynamicTemperature")
    "Measured hot water supply temperature in secondary circuit" annotation (
      Placement(transformation(extent={{-240,-290},{-200,-250}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  CDL.Interfaces.RealInput TSupBoi[nBoi](
    final unit=fill("K", nBoi),
    displayUnit=fill("degC", nBoi),
    quantity=fill("ThermodynamicTemperature", nBoi))
    "Measured hot water supply temperatureat boiler outlets" annotation (
      Placement(transformation(extent={{-240,-320},{-200,-280}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));
  CDL.Interfaces.BooleanOutput ySecPum[nPumSec] if not primaryOnly
    "Secondary pump enable status vector" annotation (Placement(transformation(
          extent={{300,-320},{340,-280}}), iconTransformation(extent={{100,-80},
            {140,-40}})));
  CDL.Logical.Pre                        pre7[nPumSec] "Logical pre block"
    annotation (Placement(transformation(extent={{160,-290},{180,-270}})));
  CDL.Continuous.Sources.Constant                        dpHotWatSet1(k=
        secMaxLocDp) "Differential pressure setpoint for secondary circuit"
    annotation (Placement(transformation(extent={{60,-330},{80,-310}})));
  CDL.Interfaces.RealOutput ySecPumSpe[nPumSec] if not primaryOnly and
    variableSecondary                           "Secondary pump speed vector"
    annotation (Placement(transformation(extent={{300,-350},{340,-310}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  CDL.Interfaces.RealInput dpHotWatSec_remote[nSenSec_remoteDp]
    "Measured differential pressure between hot water supply and return in secondary circuit"
    annotation (Placement(transformation(extent={{-240,-350},{-200,-310}}),
        iconTransformation(extent={{-140,-170},{-100,-130}})));
  CDL.Interfaces.RealInput dpHotWatPri_local
    "Measured differential pressure between hot water supply and return in primary circuit"
    annotation (Placement(transformation(extent={{-240,-380},{-200,-340}}),
        iconTransformation(extent={{-140,-200},{-100,-160}})));
  CDL.Interfaces.RealInput dpHotWatSec_local
    "Measured differential pressure between hot water supply and return in secondary circuit"
    annotation (Placement(transformation(extent={{-240,-410},{-200,-370}}),
        iconTransformation(extent={{-140,-230},{-100,-190}})));

equation
  connect(staSetCon.yBoi, upProCon.uBoiSet) annotation (Line(points={{-78,-12},{
          86,-12},{86,95},{118,95}}, color={255,0,255}));

  connect(staSetCon.yBoi, dowProCon.uBoiSet) annotation (Line(points={{-78,-12},
          {86,-12},{86,38},{118,38}}, color={255,0,255}));

  connect(staSetCon.ySta, upProCon.uStaSet) annotation (Line(points={{-78,4},{20,
          4},{20,83},{118,83}}, color={255,127,0}));

  connect(staSetCon.ySta, dowProCon.uStaSet) annotation (Line(points={{-78,4},{20,
          4},{20,26},{118,26}}, color={255,127,0}));

  connect(staSetCon.yStaTyp, upProCon.uStaTyp) annotation (Line(points={{-78,8},
          {24,8},{24,87},{118,87}}, color={255,127,0}));

  connect(staSetCon.yChaUpEdg, upProCon.uStaUpPro) annotation (Line(points={{-78,0},
          {78,0},{78,91},{118,91}},    color={255,0,255}));

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

  connect(upProCon.yOnOff, logSwi.u1) annotation (Line(points={{142,96},{150,96},
          {150,144},{-20,144},{-20,168},{-12,168}}, color={255,0,255}));

  connect(dowProCon.yOnOff, logSwi.u3) annotation (Line(points={{142,40},{154,40},
          {154,140},{-26,140},{-26,152},{-12,152}}, color={255,0,255}));

  connect(lat.y, intSwi.u2) annotation (Line(points={{-34,30},{-30,30},{-30,120},
          {-12,120}}, color={255,0,255}));

  connect(upProCon.yLasDisBoi, intSwi.u1) annotation (Line(points={{142,88},{146,
          88},{146,72},{-26,72},{-26,128},{-12,128}}, color={255,127,0}));

  connect(dowProCon.yLasDisBoi, intSwi.u3) annotation (Line(points={{142,32},{150,
          32},{150,68},{-20,68},{-20,112},{-12,112}}, color={255,127,0}));

  connect(lat1.y, hotWatSupTemRes.uStaCha)
    annotation (Line(points={{-132,70},{-62,70}}, color={255,0,255}));

  connect(staSetCon.yStaTyp, hotWatSupTemRes.uTyp) annotation (Line(points={{-78,8},
          {-74,8},{-74,38},{-110,38},{-110,66},{-62,66}},    color={255,127,0}));

  connect(minBoiFloSet1.VHotWatMinSet_flow, staSetCon.VMinSet_flow) annotation (
     Line(points={{-88,-332},{-80,-332},{-80,-88},{-114,-88},{-114,3},{-102,3}},
        color={0,0,127}));

  connect(conInt.y, minBoiFloSet1.uLasDisBoi) annotation (Line(points={{-138,
          -312},{-130,-312},{-130,-326},{-112,-326}}, color={255,127,0}));

  connect(con.y, minBoiFloSet1.uOnOff) annotation (Line(points={{-138,-342},{
          -130,-342},{-130,-330},{-112,-330}}, color={255,0,255}));

  connect(con.y, minBoiFloSet1.uStaChaPro) annotation (Line(points={{-138,-342},
          {-130,-342},{-130,-334},{-112,-334}}, color={255,0,255}));

  connect(conInt2.y, priPumCon.uPumLeaLag) annotation (Line(points={{82,-128},{
          94,-128},{94,-112.933},{118,-112.933}},
                                            color={255,127,0}));

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

  connect(TSupPri, staSetCon.THotWatSup) annotation (Line(points={{-220,70},{-168,
          70},{-168,34},{-110,34},{-110,6},{-102,6}}, color={0,0,127}));

  connect(TRetPri, staSetCon.THotWatRet) annotation (Line(points={{-220,40},{-172,
          40},{-172,30},{-120,30},{-120,12},{-102,12}}, color={0,0,127}));

  connect(TRetPri, conSet.THotWatRet) annotation (Line(points={{-220,40},{-172,
          40},{-172,30},{-120,30},{-120,-94},{58,-94}}, color={0,0,127}));

  connect(VHotWatPri_flow, staSetCon.VHotWat_flow) annotation (Line(points={{-220,
          10},{-180,10},{-180,20},{-114,20},{-114,9},{-102,9}}, color={0,0,127}));

  connect(VHotWatPri_flow, upProCon.VHotWat_flow) annotation (Line(points={{-220,
          10},{-180,10},{-180,108},{114,108},{114,115},{118,115}}, color={0,0,127}));

  connect(VHotWatPri_flow, dowProCon.VHotWat_flow) annotation (Line(points={{-220,
          10},{-180,10},{-180,108},{114,108},{114,58},{118,58}}, color={0,0,127}));

  connect(VHotWatPri_flow, bypValPos.VHotWat_flow) annotation (Line(points={{-220,
          10},{-180,10},{-180,108},{114,108},{114,-38},{118,-38}}, color={0,0,127}));

  connect(VHotWatPri_flow, priPumCon.VHotWat_flow) annotation (Line(points={{-220,10},
          {-180,10},{-180,108},{114,108},{114,-124.133},{118,-124.133}},
                                                                     color={0,0,
          127}));

  connect(dpHotWatPri_remote, priPumCon.dpHotWat_remote) annotation (Line(
        points={{-220,-50},{-180,-50},{-180,-100},{8,-100},{8,-147.467},{118,
          -147.467}},            color={0,0,127}));

  connect(dpHotWatSet.y, priPumCon.dpHotWatSet) annotation (Line(points={{82,-170},
          {104,-170},{104,-150.267},{118,-150.267}},
                                             color={0,0,127}));

  connect(upProCon.yBoi, logSwi1.u1) annotation (Line(points={{142,108},{166,108},
          {166,148},{168,148}}, color={255,0,255}));

  connect(dowProCon.yBoi, logSwi1.u3) annotation (Line(points={{142,52},{158,52},
          {158,132},{168,132}}, color={255,0,255}));

  connect(lat.y, booRep.u) annotation (Line(points={{-34,30},{-30,30},{-30,104},
          {34,104},{34,120},{38,120}}, color={255,0,255}));

  connect(booRep.y, logSwi1.u2) annotation (Line(points={{62,120},{102,120},{102,
          136},{162,136},{162,140},{168,140}}, color={255,0,255}));

  connect(upProCon.yHotWatIsoVal, swi.u1) annotation (Line(points={{142,100},{172,
          100},{172,78},{178,78}}, color={0,0,127}));

  connect(dowProCon.yHotWatIsoVal, swi.u3) annotation (Line(points={{142,44},{164,
          44},{164,62},{178,62}}, color={0,0,127}));

  connect(booRep.y, swi.u2) annotation (Line(points={{62,120},{102,120},{102,136},
          {162,136},{162,70},{178,70}}, color={255,0,255}));

  connect(priPumCon.yPumSpe, yPriPumSpe) annotation (Line(points={{142,-153.067},
          {170,-153.067},{170,-170},{320,-170}},
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

  connect(pre5.y, upProCon.uBoi) annotation (Line(points={{192,180},{200,180},{200,
          200},{160,200},{160,154},{106,154},{106,99},{118,99}},     color={255,
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
    annotation (Line(points={{134,180},{140,180},{140,150},{110,150},{110,111},
          {118,111}},color={0,0,127}));

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

  connect(upProCon.yStaChaPro, or2.u1) annotation (Line(points={{142,104},{168,104},
          {168,0},{218,0}},                                        color={255,0,
          255}));

  connect(dowProCon.yStaChaPro, or2.u2) annotation (Line(points={{142,48},{158,48},
          {158,-8},{218,-8}},                  color={255,0,255}));

  connect(pre1.y, triSam.trigger) annotation (Line(points={{92,-50},{98,-50},{98,
          -64},{-30,-64},{-30,-51.8}}, color={255,0,255}));

  connect(pre1.y, staSetCon.uStaChaProEnd) annotation (Line(points={{92,-50},{98,
          -50},{98,-64},{-99,-64},{-99,-22}}, color={255,0,255}));

  connect(pre1.y, minBoiFloSet.uStaChaPro) annotation (Line(points={{92,-50},{98,
          -50},{98,178},{110,178}}, color={255,0,255}));

  connect(pre1.y, lat1.clr) annotation (Line(points={{92,-50},{98,-50},{98,54},{
          -160,54},{-160,64},{-156,64}}, color={255,0,255}));

  connect(priPumCon.yHotWatPum, yPriPum)
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
          210,30},{210,10},{102,10},{102,-121.333},{118,-121.333}},
                                                            color={0,0,127}));

  connect(uniDel2.y, dowProCon.uHotWatIsoVal) annotation (Line(points={{202,30},
          {210,30},{210,10},{102,10},{102,46},{118,46}}, color={0,0,127}));

  connect(uniDel2.y, upProCon.uHotWatIsoVal) annotation (Line(points={{202,30},{
          210,30},{210,10},{102,10},{102,103},{118,103}},  color={0,0,127}));

  connect(conInt1.y, intToRea3.u)
    annotation (Line(points={{-138,-372},{-132,-372}}, color={255,127,0}));

  connect(intToRea3.y, uniDel3.u)
    annotation (Line(points={{-108,-372},{-102,-372}},
                                                     color={0,0,127}));

  connect(uniDel3.y, reaToInt3.u)
    annotation (Line(points={{-78,-372},{-72,-372}}, color={0,0,127}));

  connect(reaToInt3.y, minBoiFloSet1.uStaSet) annotation (Line(points={{-48,
          -372},{-40,-372},{-40,-352},{-120,-352},{-120,-338},{-112,-338}},
        color={255,127,0}));

  connect(priPumCon.yHotWatPum, pre3.u) annotation (Line(points={{142,-140},{
          150,-140},{150,-110},{158,-110}}, color={255,0,255}));

  connect(pre3.y, bypValPos.uPumSta) annotation (Line(points={{182,-110},{190,
          -110},{190,-16},{106,-16},{106,-42},{118,-42}}, color={255,0,255}));

  connect(pre3.y, priPumCon.uHotWatPum) annotation (Line(points={{182,-110},{
          190,-110},{190,-84},{106,-84},{106,-115.733},{118,-115.733}},
                                                                color={255,0,
          255}));

  connect(pre3.y, hotWatSupTemRes.uHotWatPumSta) annotation (Line(points={{182,
          -110},{190,-110},{190,-16},{-70,-16},{-70,78},{-62,78}}, color={255,0,
          255}));

  connect(uBoiAva, staSetCon.uBoiAva) annotation (Line(points={{-220,-90},{-140,
          -90},{-140,-18},{-102,-18}}, color={255,0,255}));

  connect(plaEna.yPla, upProCon.uPlaEna) annotation (Line(points={{-158,-10},{-126,
          -10},{-126,100},{70,100},{70,80},{118,80}},                color={255,
          0,255}));

  connect(plaDis.yHotWatIsoVal, yHotWatIsoVal) annotation (Line(points={{262,68},
          {280,68},{280,70},{320,70}},   color={0,0,127}));

  connect(plaDis.yHotWatIsoVal, uniDel2.u) annotation (Line(points={{262,68},{280,
          68},{280,50},{174,50},{174,30},{178,30}},       color={0,0,127}));

  connect(plaDis.yBoi, yBoi) annotation (Line(points={{262,76},{280,76},{280,140},
          {320,140}},      color={255,0,255}));

  connect(plaDis.yBoi, pre5.u) annotation (Line(points={{262,76},{280,76},{280,160},
          {164,160},{164,180},{168,180}},      color={255,0,255}));

  connect(or2.y, plaDis.uStaChaProEnd) annotation (Line(points={{242,0},{250,0},
          {250,40},{220,40},{220,62},{238,62}}, color={255,0,255}));

  connect(swi.y, plaDis.uHotWatIsoVal) annotation (Line(points={{202,70},{220,70},
          {220,70},{238,70}}, color={0,0,127}));

  connect(logSwi1.y, plaDis.uBoi) annotation (Line(points={{192,140},{230,140},{
          230,74},{238,74}}, color={255,0,255}));

  connect(plaDis.yStaChaPro, pre1.u) annotation (Line(points={{262,64},{266,64},
          {266,-22},{60,-22},{60,-50},{68,-50}}, color={255,0,255}));

  connect(plaEna.yPla, plaDis.uPla) annotation (Line(points={{-158,-10},{-126,-10},
          {-126,100},{94,100},{94,124},{226,124},{226,78},{238,78}}, color={255,
          0,255}));

  connect(plaEna.yPla, priPumCon.uPlaEna) annotation (Line(points={{-158,-10},{
          -130,-10},{-130,-78},{90,-78},{90,-118.533},{118,-118.533}},
                                                          color={255,0,255}));

  connect(priPumCon.yPumSpe[1], uniDel4.u) annotation (Line(points={{142,
          -153.067},{170,-153.067},{170,-190},{178,-190}},
                                             color={0,0,127}));
  connect(uniDel4.y, staSetCon.uPumSpe) annotation (Line(points={{202,-190},{210,
          -190},{210,-228},{4,-228},{4,-106},{-122,-106},{-122,-9},{-102,-9}},
        color={0,0,127}));
  connect(hotWatSupTemRes.TPlaHotWatSupSet, upProCon.THotWatSup) annotation (
      Line(points={{-38,74},{-34,74},{-34,107},{118,107}}, color={0,0,127}));
  connect(TRetPri, staSetCon.THotWatRetPri) annotation (Line(points={{-220,40},
          {-172,40},{-172,30},{-120,30},{-120,-3},{-102,-3}}, color={0,0,127}));
  connect(TRetSec, staSetCon.THotWatRetSec) annotation (Line(points={{-220,-20},
          {-190,-20},{-190,-30},{-132,-30},{-132,-6},{-102,-6}}, color={0,0,127}));
  connect(upProCon.yNexEnaBoi, intSwi1.u1) annotation (Line(points={{142,92},{152,
          92},{152,-190},{50,-190},{50,-202},{58,-202}}, color={255,127,0}));
  connect(dowProCon.yNexEnaBoi, intSwi1.u3) annotation (Line(points={{142,36},{154,
          36},{154,-194},{52,-194},{52,-218},{58,-218}}, color={255,127,0}));
  connect(lat.y, intSwi1.u2) annotation (Line(points={{-34,30},{-30,30},{-30,12},
          {18,12},{18,-210},{58,-210}}, color={255,0,255}));
  connect(intSwi1.y, priPumCon.uNexEnaBoi) annotation (Line(points={{82,-210},{
          106,-210},{106,-138.133},{118,-138.133}},
                                        color={255,127,0}));
  connect(upProCon.yPumChaPro, mulOr.u[1]) annotation (Line(points={{142,84},{
          148,84},{148,-4},{26,-4},{26,-165.333},{28,-165.333}},
                                                             color={255,0,255}));
  connect(dowProCon.yPumChaPro, mulOr.u[2]) annotation (Line(points={{142,28},{
          144,28},{144,2},{22,2},{22,-170},{28,-170}},
                                                   color={255,0,255}));
  connect(plaDis.yPumChaPro, mulOr.u[3]) annotation (Line(points={{262,72},{270,
          72},{270,-76},{20,-76},{20,-174.667},{28,-174.667}}, color={255,0,255}));
  connect(mulOr.y, priPumCon.uPumChaPro) annotation (Line(points={{52,-170},{54,
          -170},{54,-154},{100,-154},{100,-135.333},{118,-135.333}},
                                                             color={255,0,255}));
  connect(priPumCon.yPumChaPro, pre2.u) annotation (Line(points={{142,-126.933},
          {190,-126.933},{190,-120},{198,-120}},
                                        color={255,0,255}));
  connect(pre2.y, upProCon.uPumChaPro) annotation (Line(points={{222,-120},{230,
          -120},{230,-14},{92,-14},{92,77},{118,77}}, color={255,0,255}));
  connect(pre2.y, dowProCon.uPumChaPro) annotation (Line(points={{222,-120},{230,
          -120},{230,-14},{92,-14},{92,22},{118,22}}, color={255,0,255}));
  connect(pre2.y, plaDis.uPumChaPro) annotation (Line(points={{222,-120},{230,-120},
          {230,-14},{214,-14},{214,66},{238,66}}, color={255,0,255}));
  connect(staSetCon.yChaUpEdg, priPumCon.uStaUp) annotation (Line(points={{-78,0},
          {58,0},{58,-74},{92,-74},{92,-129.733},{118,-129.733}},
                                                          color={255,0,255}));
  connect(logSwi.y, priPumCon.uOnOff) annotation (Line(points={{12,160},{12,-22},
          {56,-22},{56,-72},{96,-72},{96,-132.533},{118,-132.533}},
                                                            color={255,0,255}));
  connect(plaDis.yBoi, priPumCon.uBoiSta) annotation (Line(points={{262,76},{
          274,76},{274,-88},{112,-88},{112,-126.933},{118,-126.933}},
                                                          color={255,0,255}));
  connect(conSet.yMinPriPumSpe, priPumCon.uMinPriPumSpeCon) annotation (Line(
        points={{82,-100},{88,-100},{88,-153.067},{118,-153.067}},
                                                           color={0,0,127}));
  connect(conInt3.y, secPumCon.uPumLeaLag) annotation (Line(points={{82,-270},{
          90,-270},{90,-281.8},{118,-281.8}},
                                           color={255,127,0}));
  connect(VHotWatSec_flow, priPumCon.VHotWatSec_flow) annotation (Line(points={{-220,
          -210},{8,-210},{8,-224},{114,-224},{114,-155.867},{118,-155.867}},
        color={0,0,127}));
  connect(VHotWatDec_flow, priPumCon.VHotWatDec_flow) annotation (Line(points={{-220,
          -240},{-190,-240},{-190,-212},{6,-212},{6,-226},{116,-226},{116,
          -158.667},{118,-158.667}},
                             color={0,0,127}));
  connect(TSupPri, priPumCon.THotWatPri) annotation (Line(points={{-220,70},{
          -168,70},{-168,34},{-110,34},{-110,-84},{0,-84},{0,-186},{112,-186},{
          112,-161.467},{118,-161.467}},                      color={0,0,127}));
  connect(TSupSec, priPumCon.THotWatSec) annotation (Line(points={{-220,-270},{
          -186,-270},{-186,-214},{2,-214},{2,-230},{108,-230},{108,-164.267},{
          118,-164.267}},
                  color={0,0,127}));
  connect(TSupBoi, priPumCon.THotWatBoiSup) annotation (Line(points={{-220,-300},
          {-184,-300},{-184,-216},{0,-216},{0,-232},{110,-232},{110,-167.067},{
          118,-167.067}},
                  color={0,0,127}));
  connect(secPumCon.yHotWatPum, ySecPum)
    annotation (Line(points={{142,-300},{320,-300}}, color={255,0,255}));
  connect(secPumCon.yHotWatPum, pre7.u) annotation (Line(points={{142,-300},{
          150,-300},{150,-280},{158,-280}}, color={255,0,255}));
  connect(pre7.y, secPumCon.uHotWatPum) annotation (Line(points={{182,-280},{
          190,-280},{190,-260},{110,-260},{110,-286},{118,-286}}, color={255,0,
          255}));
  connect(supResReq, secPumCon.supResReq) annotation (Line(points={{-220,130},{
          -116,130},{-116,-110},{14,-110},{14,-294},{118,-294}}, color={255,127,
          0}));
  connect(plaEna.yPla, secPumCon.uPlaEna) annotation (Line(points={{-158,-10},{
          -130,-10},{-130,-78},{12,-78},{12,-290},{118,-290}}, color={255,0,255}));
  connect(VHotWatSec_flow, secPumCon.VHotWat_flow) annotation (Line(points={{
          -220,-210},{8,-210},{8,-298},{118,-298}}, color={0,0,127}));
  connect(conSet.yMaxSecPumSpe, secPumCon.uMaxSecPumSpeCon) annotation (Line(
        points={{82,-106},{98,-106},{98,-318},{118,-318}}, color={0,0,127}));
  connect(dpHotWatSet1.y, secPumCon.dpHotWatSet) annotation (Line(points={{82,-320},
          {86,-320},{86,-314},{118,-314}},       color={0,0,127}));
  connect(secPumCon.yPumSpe, ySecPumSpe) annotation (Line(points={{142,-310},{
          280,-310},{280,-330},{320,-330}}, color={0,0,127}));
  connect(dpHotWatSec_remote, secPumCon.dpHotWat_remote) annotation (Line(
        points={{-220,-330},{-180,-330},{-180,-286},{86,-286},{86,-310},{118,
          -310}}, color={0,0,127}));
  connect(dpHotWatPri_local, priPumCon.dpHotWat_local) annotation (Line(points={{-220,
          -360},{-178,-360},{-178,-234},{96,-234},{96,-144.667},{118,-144.667}},
                      color={0,0,127}));
  connect(dpHotWatSec_local, secPumCon.dpHotWat_local) annotation (Line(points=
          {{-220,-390},{100,-390},{100,-306},{118,-306}}, color={0,0,127}));
  connect(reaToInt2.y, priPumCon.uLasDisBoi) annotation (Line(points={{102,220},
          {208,220},{208,-72},{226,-72},{226,-212},{102,-212},{102,-141.867},{
          118,-141.867}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(extent={{-100,-220},{100,220}}),
       graphics={
        Rectangle(
          extent={{-100,-220},{100,220}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,268},{100,228}},
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
          fillPattern=FillPattern.Solid)}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-400},{300,
            240}})),
        Documentation(info="<html>
        The parameter values for valid boiler plant configurations are as follows:
    <br>
      <table summary=\"allowedConfigurations\" border=\"1\">
      <thead>
        <tr>
          <th>Boolean Parameters/Plant configurations</th>
          <th>1</th>
          <th>2</th>
          <th>3</th>
          <th>4</th>
          <th>5</th>
          <th>6</th>
          <th>7</th>
          <th>8</th>
          <th>9</th>
          <th>10</th>
          <th>11</th>
          <th>12</th>
          <th>13</th>
          <th>14</th>
          <th>15</th>
          <th>16</th>
          <th>17</th>
          <th>18</th>
          <th>19</th>
          <th>20</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>have_priOnl</td>
          <td>True</td>
          <td>True</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
        </tr>
        <tr>
          <td>have_heaPri</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
        </tr>
        <tr>
          <td>have_varPri</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>True</td>
          <td>False</td>
          <td>False</td>
          <td>False</td>
        </tr>
        <tr>
          <td>have_varSec</td>
          <td>NA</td>
          <td>NA</td>
          <td>True</td>
          <td>True</td>
          <td>False</td>
          <td>True</td>
          <td>True</td>
          <td>False</td>
          <td>True</td>
          <td>True</td>
          <td>False</td>
          <td>True</td>
          <td>True</td>
          <td>False</td>
          <td>True</td>
          <td>True</td>
          <td>False</td>
          <td>True</td>
          <td>True</td>
          <td>False</td>
        </tr>
        <tr>
          <td>speConTyp_priPum</td>
          <td>localDP</td>
          <td>remoteDP</td>
          <td>flowrate</td>
          <td>flowrate</td>
          <td>flowrate</td>
          <td>temperature</td>
          <td>temperature</td>
          <td>temperature</td>
          <td>NA</td>
          <td>NA</td>
          <td>NA</td>
          <td>flowrate</td>
          <td>flowrate</td>
          <td>flowrate</td>
          <td>temperature</td>
          <td>temperature</td>
          <td>temperature</td>
          <td>NA</td>
          <td>NA</td>
          <td>NA</td>
        </tr>
        <tr>
          <td>speConTyp_secPum</td>
          <td>NA</td>
          <td>NA</td>
          <td>localDP</td>
          <td>remoteDP</td>
          <td>NA</td>
          <td>localDP</td>
          <td>remoteDP</td>
          <td>NA</td>
          <td>localDP</td>
          <td>remoteDP</td>
          <td>NA</td>
          <td>localDP</td>
          <td>remoteDP</td>
          <td>NA</td>
          <td>localDP</td>
          <td>remoteDP</td>
          <td>NA</td>
          <td>localDP</td>
          <td>remoteDP</td>
          <td>NA</td>
        </tr>
      </tbody>
      </table>
        </html>"));
end Controller;
