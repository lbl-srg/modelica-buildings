within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant;
model SecondaryController "Boiler plant secondary loop controller"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType_priPum= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Primary pump control parameters", group="PID parameters"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType_bypVal= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Bypass valve control parameters"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType_secPum= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Secondary pump control parameters", group="PID parameters"));

  parameter Boolean have_priOnl = false
    "Is the boiler plant a primary-only, condensing boiler plant?"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Boolean have_heaPriPum = true
    "True: Headered primary hot water pumps;
     False: Dedicated primary hot water pumps"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Boolean have_varPriPum = false
    "True: Variable-speed primary pumps;
     False: Fixed-speed primary pumps"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Boolean have_secFloSen=false
    "True: Flowrate sensor in secondary loop;
    False: Flowrate sensor in decoupler"
    annotation(Dialog(tab="General",
      group="Boiler plant configuration parameters",
      enable = not have_priOnl));

  parameter Boolean have_priSecTemSen=false
    "True: Temperature sensors in primary and secondary loops;
    False: Temperature sensors in boiler supply and secondary loop"
    annotation (Dialog(tab="Primary pump control parameters",
      group="General parameters",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Boolean have_varSecPum = false
    "True: Variable-speed secondary pumps;
    False: Fixed-speed secondary pumps"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Integer nIgnReq(
    final min=0) = 0
    "Number of hot-water requests to be ignored before enabling boiler plant loop"
    annotation(Dialog(tab="Plant enable/disable parameters"));

  parameter Integer nBoi
    "Number of boilers"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer boiTyp[nBoi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler}
    "Boiler type"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer nSta
    "Number of boiler plant stages"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer staMat[nSta, nBoi]
    "Staging matrix with stage as row index and boiler as column index"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer nPumPri
    "Number of primary pumps in the boiler plant loop"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer nHotWatResReqIgn = 2
    "Number of hot-water supply temperature reset requests to be ignored"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Integer nSenPri
    "Total number of remote differential pressure sensors in primary loop"
    annotation(Dialog(tab="General",
      group="Boiler plant configuration parameters",
      enable = have_remDPRegPri or have_locDPRegPri));

  parameter Integer numIgnReq = 0
    "Number of ignored requests"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable= speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Integer nPumPri_nominal(
    final max=nPumPri,
    final min=1) = nPumPri
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Integer nPumSec
    "Total number of secondary hot water pumps"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Integer nSenSec
    "Total number of remote differential pressure sensors in secondary loop"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Integer nPumSec_nominal(
    final max=nPumSec) = nPumSec
    "Total number of pumps that operate at design conditions in secondary loop"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Real TOutLoc(
    final unit="K",
    displayUnit="K") = 300
    "Boiler lock-out temperature for outdoor air"
    annotation(Dialog(tab="Plant enable/disable parameters"));

  parameter Real locDt(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 1
    "Temperature deadband for boiler lockout"
    annotation(Dialog(tab="Plant enable/disable parameters", group="Advanced"));

  parameter Real plaOffThrTim(
    final unit="s",
    displayUnit="s") = 900
    "Minimum time for which the plant has to stay off once it has been disabled"
    annotation(Dialog(tab="Plant enable/disable parameters"));

  parameter Real plaOnThrTim(
    final unit="s",
    displayUnit="s") = plaOffThrTim
    "Minimum time for which the boiler plant has to stay on once it has been enabled"
    annotation(Dialog(tab="Plant enable/disable parameters"));

  parameter Real staOnReqTim(
    final unit="s",
    displayUnit="s") = 180
    "Time-limit for receiving hot-water requests to maintain enabled plant on"
    annotation(Dialog(tab="Plant enable/disable parameters"));

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
    annotation (Dialog(tab="Staging setpoint parameters", group="Advanced"));

  parameter Real TDifHys(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Temperature deadband for hysteresis loop"
    annotation (Dialog(tab="Staging setpoint parameters", group="Advanced"));

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
        enable=have_priOnl,
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
                  (have_priOnl),
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
                  (have_priOnl),
        tab="Staging setpoint parameters",
        group="Staging down parameters"));

  parameter Real bypValClo(
    final unit="1",
    displayUnit="1") = 0
    "Adjustment for signal received when bypass valve is closed"
    annotation (
      Evaluate=true,
      Dialog(
        enable=have_priOnl,
        tab="Staging setpoint parameters",
        group="Advanced"));

  parameter Real dTemp(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.1
    "Hysteresis deadband for measured temperatures"
    annotation (Dialog(tab="Staging setpoint parameters", group="Advanced"));

  parameter Real minFloSet[nBoi](
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1e-6,
    final max=maxFloSet)
    "Design minimum hot water flow through each boiler"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real maxFloSet[nBoi](
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate",
    final min=minFloSet)
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
    annotation(Dialog(tab="Supply temperature reset parameters", group="General parameters"));

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
    annotation(Dialog(tab="Supply temperature reset parameters", group="General parameters"));

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
    final quantity="time") = 1/chaIsoValRat
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

  parameter Real minPumSpePri(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=maxPumSpePri) = 0.1
    "Minimum pump speed"
    annotation (Dialog(tab="Primary pump control parameters", group="General parameters", enable=have_varPriPum));

  parameter Real maxPumSpePri(
    final unit="1",
    displayUnit="1",
    final min=minPumSpePri,
    final max=1) = 1
    "Maximum pump speed"
    annotation (Dialog(tab="Primary pump control parameters", group="General parameters", enable=have_varPriPum));

  parameter Real VHotWatPri_flow_nominal(
    final min=1e-6,
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Plant design hot water flow rate thorugh primary loop"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Real boiDesFlo[nBoi](
    final min=1e-6,
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Vector of design flowrates for all boilers in plant"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Real maxLocDpPri(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6) = 5*6894.75
    "Maximum primary loop local differential pressure setpoint"
    annotation (Dialog(tab="Primary pump control parameters", group="DP-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP
      or speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP));

  parameter Real minLocDpPri(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6) = 5*6894.75
    "Minimum primary loop local differential pressure setpoint"
    annotation (Dialog(tab="Primary pump control parameters",
      group="DP-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP
      or speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP));

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
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real samPer_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 120
    "Sample period of component"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real triAmo_priPum(
    final unit="1",
    displayUnit="1") = -0.02
    "Trim amount"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real resAmo_priPum(
    final unit="1",
    displayUnit="1") = 0.03
    "Respond amount"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real maxRes_priPum(
    final unit="1",
    displayUnit="1") = 0.06
    "Maximum response per time interval"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real twoReqLimLow_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1.2
    "Lower limit of hysteresis loop sending two requests"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real twoReqLimHig_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 2
    "Higher limit of hysteresis loop sending two requests"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real oneReqLimLow_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.2
    "Lower limit of hysteresis loop sending one request"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real oneReqLimHig_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Higher limit of hysteresis loop sending one request"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

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
    final max=fill(1,nSta))
    "Vector of minimum primary pump speed for each stage"
    annotation(Dialog(group="Boiler plant configuration parameters"));

  parameter Real minPumSpeSec(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=maxPumSpeSec) = 0.1
    "Minimum pump speed"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="General parameters",
      enable=have_varSecPum));

  parameter Real maxPumSpeSec(
    final unit="1",
    displayUnit="1",
    final min=minPumSpeSec,
    final max=1) = 1
    "Maximum pump speed"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="General parameters",
      enable=have_varSecPum));

  parameter Real VHotWatSec_flow_nominal(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") = 0.5
    "Secondary loop design hot water flow rate"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Real maxLocDpSec(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6) = 5*6894.75
    "Maximum hot water loop local differential pressure setpoint in secondary loop"
    annotation (Dialog(tab="Secondary pump control parameters", group="DP-based speed regulation",
      enable = speConTypSec == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP));

  parameter Real minLocDpSec(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6) = 5*6894.75
    "Minimum hot water loop local differential pressure setpoint in secondary loop"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="DP-based speed regulation",
      enable = speConTypSec == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP));

  parameter Real offTimThr(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 180
    "Threshold to check lead boiler off time"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and have_secFloSen));

  parameter Real timPerSec(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 600
    "Delay time period for enabling and disabling secondary lag pumps"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and have_secFloSen));

  parameter Real staConSec(
    final unit="1",
    displayUnit="1") = -0.03
    "Constant used in the staging equation"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and have_secFloSen));

  parameter Real speLim(
    final unit="1",
    displayUnit="1") = 0.9
    "Speed limit with longer enable delay for enabling next lag pump"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and not have_secFloSen));

  parameter Real speLim1(
    final unit="1",
    displayUnit="1") = 0.99
    "Speed limit with shorter enable delay for enabling next lag pump"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and not have_secFloSen));

  parameter Real speLim2(
    final unit="1",
    displayUnit="1") = 0.4
    "Speed limit for disabling last lag pump"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and not have_secFloSen));

  parameter Real timPer1(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for enabling next lag pump at speed limit speLim"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and not have_secFloSen));

  parameter Real timPer2(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 60
    "Delay time period for enabling next lag pump at speed limit speLim1"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and not have_secFloSen));

  parameter Real timPer3(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 600
    "Delay time period for disabling last lag pump"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and not have_secFloSen));

  parameter Real k_sec(
    final unit="1",
    displayUnit="1",
    final min=0) = 1
    "Gain of controller"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="PID parameters",
      enable=have_varSecPum));

  parameter Real Ti_sec(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="PID parameters",
      enable=have_varSecPum));

  parameter Real Td_sec(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="PID parameters",
      enable=have_varSecPum));

  parameter Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes
    speConTypPri = Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP
    "Primary pump speed regulation method"
    annotation (Dialog(group="Boiler plant configuration parameters", enable=have_varPriPum));

  parameter Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes
    speConTypSec = Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.remoteDP
    "Secondary pump speed regulation method"
    annotation (Dialog(group="Boiler plant configuration parameters", enable=have_varSecPum));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoi[nBoi]
    "Boiler status vector from plant"
    annotation (Placement(transformation(extent={{-440,-380},{-400,-340}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPriPum[nPumPri]
    "Primary pump proven on signal from plant"
    annotation (Placement(transformation(extent={{-440,-420},{-400,-380}}),
      iconTransformation(extent={{-140,-220},{-100,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSecPum[nPumSec] if not have_priOnl
    "Secondary pump proven on signal"
    annotation (Placement(transformation(extent={{-440,-460},{-400,-420}}),
      iconTransformation(extent={{-140,-250},{-100,-210}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatSec_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") if not have_priOnl and have_secFloSen
    "Measured hot water secondary circuit flowrate"
    annotation (Placement(transformation(extent={{-440,-90},{-400,-50}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatSec_rem[nSenSec](
    final unit=fill("Pa", nSenSec),
    displayUnit=fill("Pa", nSenSec),
    final quantity=fill("PressureDifference", nSenSec)) if not
    have_priOnl and have_varSecPum and (have_remDPRegSec or have_locDPRegSec)
    "Measured differential pressure between hot water supply and return in secondary circuit"
    annotation (Placement(transformation(extent={{-440,-250},{-400,-210}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatSec_loc(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") if not have_priOnl and
    have_varSecPum and have_locDPRegSec
    "Measured differential pressure between hot water supply and return in secondary circuit"
    annotation (Placement(transformation(extent={{-440,-330},{-400,-290}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySecPum[nPumSec] if not have_priOnl
    "Secondary pump enable status vector"
    annotation (Placement(transformation(extent={{400,-360},{440,-320}}),
      iconTransformation(extent={{100,-160},{140,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySecPumSpe(
    final unit="1",
    displayUnit="1") if not have_priOnl and have_varSecPum
    "Secondary pump speed vector"
    annotation (Placement(transformation(extent={{400,-410},{440,-370}}),
      iconTransformation(extent={{100,-200},{140,-160}})));

  CDL.Interfaces.RealInput uMaxSecPumSpeCon(final unit="1", displayUnit="1")
    if not have_priOnl
    "Maximum allowed secondary pump speed for non-condensing boilers"
    annotation (Placement(transformation(extent={{-440,-560},{-400,-520}}),
        iconTransformation(extent={{-140,-310},{-100,-270}})));
protected
  parameter Boolean have_remDPRegPri = (speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP)
    "Boolean flag for primary pump speed control with remote differential pressure";

  parameter Boolean have_locDPRegPri = (speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP)
    "Boolean flag for primary pump speed control with local differential pressure";

  parameter Boolean have_temRegPri = (speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature)
    "Boolean flag for primary pump speed control with temperature readings";

  parameter Boolean have_floRegPri = (speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.flowrate)
    "Boolean flag for primary pump speed control with flowrate readings";

  parameter Boolean have_remDPRegSec = (speConTypSec == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.remoteDP)
    "Boolean flag for secondary pump speed control with remote differential pressure";

  parameter Boolean have_locDPRegSec = (speConTypSec == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.localDP)
    "Boolean flag for secondary pump speed control with local differential pressure";

  parameter Integer staInd[nSta]={i for i in 1:nSta}
    "Staging indices starting at 1";

  parameter Integer priPumInd[nPumPri]={i for i in 1:nPumPri}
    "Vector of primary pump indices up to total number of primary pumps";

  parameter Integer secPumInd[nPumSec]={i for i in 1:nPumSec}
    "Vector of secondary pump indices up to total number of secondary pumps";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Controller secPumCon(
    final controllerType=controllerType_secPum,
    final have_varSecPum=true,
    final have_secFloSen=have_secFloSen,
    final nPum=nPumSec,
    final nPumPri=nPumPri,
    final nBoi=nBoi,
    final nSen=nSenSec,
    final nPum_nominal=nPumSec,
    final minPumSpe=minPumSpeSec,
    final maxPumSpe=maxPumSpeSec,
    final VHotWat_flow_nominal=VHotWatSec_flow_nominal,
    final maxLocDp=maxLocDpSec,
    final minLocDp=minLocDpSec,
    final offTimThr=offTimThr,
    final delBoiDis=0,
    final timPer=timPerSec,
    final staCon=staConSec,
    final speLim=speLim,
    final speLim1=speLim1,
    final speLim2=speLim2,
    final timPer1=timPer1,
    final timPer2=timPer2,
    final timPer3=timPer3,
    final k=k_sec,
    final Ti=Ti_sec,
    final Td=Td_sec,
    final speConTyp=speConTypSec) if not have_priOnl
    "Secondary pump controller"
    annotation (Placement(transformation(extent={{120,-380},{140,-340}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3[nPumSec](
    final k=secPumInd) if not have_priOnl
    "Constant stage Integer source"
    annotation (Placement(transformation(extent={{60,-290},{80,-270}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpHotWatSet1(
    final k=maxLocDpSec) if not have_priOnl
    "Differential pressure setpoint for secondary circuit"
    annotation (Placement(transformation(extent={{60,-390},{80,-370}})));

equation

  connect(conInt3.y, secPumCon.uPumLeaLag) annotation (Line(points={{82,-280},{90,
          -280},{90,-341.8},{118,-341.8}}, color={255,127,0}));
  connect(secPumCon.yHotWatPum, ySecPum)
    annotation (Line(points={{142,-360},{220,-360},{220,-340},{420,-340}},
                                                     color={255,0,255}));
  connect(VHotWatSec_flow, secPumCon.VHotWat_flow) annotation (Line(points={{-420,
          -70},{8,-70},{8,-358},{118,-358}}, color={0,0,127}));
  connect(dpHotWatSet1.y, secPumCon.dpHotWatSet) annotation (Line(points={{82,-380},
          {86,-380},{86,-374},{118,-374}}, color={0,0,127}));
  connect(dpHotWatSec_rem, secPumCon.dpHotWat_remote) annotation (Line(points={{-420,
          -230},{-190,-230},{-190,-300},{86,-300},{86,-370},{118,-370}},
        color={0,0,127}));
  connect(dpHotWatSec_loc, secPumCon.dpHotWat_local) annotation (Line(points={{-420,
          -310},{100,-310},{100,-366},{118,-366}}, color={0,0,127}));
  connect(uPriPum, secPumCon.uPriPumSta) annotation (Line(points={{-420,-400},{-28,
          -400},{-28,-362},{118,-362}}, color={255,0,255}));
  connect(uSecPum, secPumCon.uHotWatPum) annotation (Line(points={{-420,-440},{-20,
          -440},{-20,-346},{118,-346}}, color={255,0,255}));
  connect(secPumCon.yPumSpe, ySecPumSpe) annotation (Line(points={{142,-370},{
          260,-370},{260,-390},{420,-390}}, color={0,0,127}));
  connect(uMaxSecPumSpeCon, secPumCon.uMaxSecPumSpeCon) annotation (Line(points
        ={{-420,-540},{108,-540},{108,-378},{118,-378}}, color={0,0,127}));
  annotation (defaultComponentName="boiPlaCon",
    Icon(coordinateSystem(extent={{-100,-360},{100,360}}),
       graphics={
        Rectangle(
          extent={{-100,-360},{100,360}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,400},{100,360}},
          textColor={0,0,255},
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
        coordinateSystem(preserveAspectRatio=false, extent={{-400,-580},{400,440}}),
        graphics={
          Rectangle(
            extent={{34,-260},{206,-398}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Text(
            extent={{122,-386},{200,-394}},
            pattern=LinePattern.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Secondary pump controller")}),
Documentation(info="<html>
<p>
Block that controls the boiler plant components according to section 5.3 
in ASHRAE RP-1711, March 2020 draft. It consists of the following components:
</p>
<ul>
<li>
Plant enable controller: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable</a>.
</li>
<li>
Staging setpoint calculator: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.SetpointController\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.SetpointController</a>.
</li>
<li>
Stage-up process controller: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up</a>.
</li>
<li>
Stage-down process controller: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Down\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Down</a>.
</li>
<li>
Primary pump controller: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller</a>.
</li>
<li>
Secondary pump controller: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Controller</a>.
</li>
<li>
Bypass valve controller: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.BypassValve.BypassValvePosition\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.BypassValve.BypassValvePosition</a>.
</li>
<li>
Minimum flow setpoint calculator: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.MinimumFlowSetPoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.MinimumFlowSetPoint</a>.
</li>
<li>
Hot water supply temperature setpoint calculator: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.HotWaterSupplyTemperatureReset\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.HotWaterSupplyTemperatureReset</a>.
</li>
<li>
Condensation control setpoint calculator: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.CondensationControl\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.CondensationControl</a>.
</li>
<li>
Plant disable process controller: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantDisable\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantDisable</a>.
</li>
</ul>
<p>
The parameter values for valid boiler plant configurations are as follows:
</p>
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
<td>have_heaPriPum</td>
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
<td>have_varPriPum</td>
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
<td>have_varSecPum</td>
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
<td>speConTypPri</td>
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
<td>speConTypSec</td>
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
end SecondaryController;
