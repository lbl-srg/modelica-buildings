within Buildings.Templates.HeatingPlants.HotWater.Components.Controls;
block Guideline36Plugin
  "Placeholder class to prepare G36 controller integration"

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
      enable = speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.temperature));

  parameter Boolean have_varSecPum = false
    "True: Variable-speed secondary pumps;
    False: Fixed-speed secondary pumps"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Integer nIgnReq(
    final min=0) = 0
    "Number of hot-water requests to be ignored before enabling boiler plant loop"
    annotation(Dialog(tab="Plant enable/disable parameters"));

  parameter Integer nSchRow(
    final min=1) = 4
    "Number of rows to be created for plant schedule table"
    annotation(Dialog(tab="Plant enable/disable parameters"));

  parameter Integer nBoi
    "Number of boilers"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer boiTyp[nBoi]={
    Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.BoilerTypes.condensingBoiler,
    Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.BoilerTypes.nonCondensingBoiler}
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
      enable= speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.temperature));

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

  parameter Real schTab[nSchRow,2] = [0,1;6,1;18,1;24,1]
    "Table defining schedule for enabling plant"
    annotation(Dialog(tab="Plant enable/disable parameters"));

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

  parameter Real boiDesCap[nBoi]
    "Design boiler capacities vector"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real boiFirMin[nBoi]
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

  parameter Real minFloSet[nBoi]
    "Design minimum hot water flow through each boiler"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real maxFloSet[nBoi]
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
    "Plant design hot water flow rate through  primary loop"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Real boiDesFlo[nBoi](
    each final min=1e-6,
    each final unit="m3/s",
    each displayUnit="m3/s")
    "Vector of design flowrates for all boilers in plant"
    annotation (Dialog(group="Boiler plant configuration parameters"));

  parameter Real maxLocDpPri(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6) = 5*6894.75
    "Maximum primary loop local differential pressure setpoint"
    annotation (Dialog(tab="Primary pump control parameters", group="DP-based speed regulation",
      enable = speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.localDP
      or speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.remoteDP));

  parameter Real minLocDpPri(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6) = 5*6894.75
    "Minimum primary loop local differential pressure setpoint"
    annotation (Dialog(tab="Primary pump control parameters",
      group="DP-based speed regulation",
      enable = speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.localDP
      or speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.remoteDP));

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
      enable = speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real samPer_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 120
    "Sample period of component"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real triAmo_priPum(
    final unit="1",
    displayUnit="1") = -0.02
    "Trim amount"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real resAmo_priPum(
    final unit="1",
    displayUnit="1") = 0.03
    "Respond amount"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real maxRes_priPum(
    final unit="1",
    displayUnit="1") = 0.06
    "Maximum response per time interval"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real twoReqLimLow_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1.2
    "Lower limit of hysteresis loop sending two requests"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real twoReqLimHig_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 2
    "Higher limit of hysteresis loop sending two requests"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real oneReqLimLow_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.2
    "Lower limit of hysteresis loop sending one request"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real oneReqLimHig_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Higher limit of hysteresis loop sending one request"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.temperature));

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
      enable = speConTypSec == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.localDP));

  parameter Real minLocDpSec(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6) = 5*6894.75
    "Minimum hot water loop local differential pressure setpoint in secondary loop"
    annotation (Dialog(tab="Secondary pump control parameters",
      group="DP-based speed regulation",
      enable = speConTypSec == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.localDP));

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

  parameter Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes
    speConTypPri = Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.remoteDP
    "Primary pump speed regulation method"
    annotation (Dialog(group="Boiler plant configuration parameters", enable=have_varPriPum));

  parameter Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.SecondaryPumpSpeedControlTypes
    speConTypSec = Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.SecondaryPumpSpeedControlTypes.remoteDP
    "Secondary pump speed regulation method"
    annotation (Dialog(group="Boiler plant configuration parameters", enable=have_varSecPum));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiAva[nBoi]
    "Boiler availability status signal"
    annotation (Placement(transformation(extent={{-440,70},{-400,110}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoi[nBoi]
    "Boiler status vector from plant"
    annotation (Placement(transformation(extent={{-440,-360},{-400,-320}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPriPum[nPumPri]
    "Primary pump proven on signal from plant"
    annotation (Placement(transformation(extent={{-440,-400},{-400,-360}}),
      iconTransformation(extent={{-140,-220},{-100,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSecPum[nPumSec] if not have_priOnl
    "Secondary pump proven on signal"
    annotation (Placement(transformation(extent={{-440,-440},{-400,-400}}),
      iconTransformation(extent={{-140,-250},{-100,-210}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput plaReq
    "Plant requests"
    annotation (Placement(transformation(extent={{-440,350},{-400,390}}),
      iconTransformation(extent={{-140,270},{-100,310}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TSupResReq
    "Hot water supply temperature reset requests"
    annotation (Placement(transformation(extent={{-440,380},{-400,420}}),
      iconTransformation(extent={{-140,300},{-100,340}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-440,310},{-400,350}}),
      iconTransformation(extent={{-140,240},{-100,280}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupPri(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-440,270},{-400,310}}),
      iconTransformation(extent={{-140,210},{-100,250}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRetPri(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured hot water primary return temperature"
    annotation (Placement(transformation(extent={{-440,230},{-400,270}}),
      iconTransformation(extent={{-140,180},{-100,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatPri_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot water primary circuit flowrate"
    annotation (Placement(transformation(extent={{-440,190},{-400,230}}),
      iconTransformation(extent={{-140,150},{-100,190}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatPri_rem[nSenPri](
    final unit=fill("Pa", nSenPri),
    displayUnit=fill("Pa", nSenPri),
    final quantity=fill("PressureDifference", nSenPri)) if have_varPriPum and (have_remDPRegPri or have_locDPRegPri)
    "Measured differential pressure between hot water supply and return in primary circuit"
    annotation (Placement(transformation(extent={{-440,110},{-400,150}}),
        iconTransformation(extent={{-140,90},{-100,130}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRetSec(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not have_priOnl
    "Measured hot water secondary return temperature"
    annotation (Placement(transformation(extent={{-440,150},{-400,190}}),
      iconTransformation(extent={{-140,120},{-100,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatSec_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") if not have_priOnl and have_secFloSen
    "Measured hot water secondary circuit flowrate"
    annotation (Placement(transformation(extent={{-440,-70},{-400,-30}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatDec_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") if not have_priOnl and have_varPriPum
     and have_floRegPri and not have_secFloSen
    "Measured hot water flowrate through decoupler leg"
    annotation (Placement(transformation(extent={{-440,-110},{-400,-70}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSec(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not have_priOnl and
    have_varPriPum and have_temRegPri and have_priSecTemSen
    "Measured hot water supply temperature in secondary circuit"
    annotation (Placement(transformation(extent={{-440,-150},{-400,-110}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupBoi[nBoi](
    final unit=fill("K", nBoi),
    displayUnit=fill("degC", nBoi),
    final quantity=fill("ThermodynamicTemperature", nBoi)) if not have_priOnl
     and have_varPriPum and have_temRegPri and not have_priSecTemSen
    "Measured hot water supply temperature at boiler outlets"
    annotation (Placement(transformation(extent={{-440,-190},{-400,-150}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatSec_rem[nSenSec](
    final unit=fill("Pa", nSenSec),
    displayUnit=fill("Pa", nSenSec),
    final quantity=fill("PressureDifference", nSenSec)) if not
    have_priOnl and have_varSecPum and (have_remDPRegSec or have_locDPRegSec)
    "Measured differential pressure between hot water supply and return in secondary circuit"
    annotation (Placement(transformation(extent={{-440,-230},{-400,-190}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatPri_loc(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") if have_varPriPum and have_locDPRegPri
    "Measured differential pressure between hot water supply and return in primary circuit"
    annotation (Placement(transformation(extent={{-440,-270},{-400,-230}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatSec_loc(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") if not have_priOnl and
    have_varSecPum and have_locDPRegSec
    "Measured differential pressure between hot water supply and return in secondary circuit"
    annotation (Placement(transformation(extent={{-440,-310},{-400,-270}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotWatIsoVal[nBoi](
    final unit=fill("1",nBoi),
    displayUnit=fill("1",nBoi)) if have_heaPriPum
    "Measured boiler isolation valve position signals from plant"
    annotation (Placement(transformation(extent={{-440,-480},{-400,-440}}),
      iconTransformation(extent={{-140,-280},{-100,-240}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBypValPos(
    final unit="1",
    displayUnit="1") if have_priOnl
    "Measured bypass valve position signal from plant"
    annotation (Placement(transformation(extent={{-440,-520},{-400,-480}}),
      iconTransformation(extent={{-140,-310},{-100,-270}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPriPumSpe[nPumPri](
    final unit=fill("1",nBoi),
    displayUnit=fill("1",nBoi)) if not have_priOnl
    "Measured primary pump speed signal from plant"
    annotation (Placement(transformation(extent={{-440,-560},{-400,-520}}),
      iconTransformation(extent={{-140,-340},{-100,-300}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoi[nBoi]
    "Boiler status vector"
    annotation (Placement(transformation(extent={{400,200},{440,240}}),
      iconTransformation(extent={{100,80},{140,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPriPum[nPumPri]
    "Primary pump enable status vector"
    annotation (Placement(transformation(extent={{400,-130},{440,-90}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySecPum[nPumSec] if not have_priOnl
    "Secondary pump enable status vector"
    annotation (Placement(transformation(extent={{400,-340},{440,-300}}),
      iconTransformation(extent={{100,-160},{140,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{400,300},{440,340}}),
      iconTransformation(extent={{100,160},{140,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TPlaHotWatSupSet
    "Plant hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{400,240},{440,280}}),
      iconTransformation(extent={{100,120},{140,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatIsoVal[nBoi](
    final unit=fill("1",nBoi),
    displayUnit=fill("1",nBoi)) if have_heaPriPum
    "Boiler hot water isolation valve position vector"
    annotation (Placement(transformation(extent={{400,120},{440,160}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPriPumSpe(
    final unit="1",
    displayUnit="1") if have_varPriPum
    "Primary pump speed"
    annotation (Placement(transformation(extent={{400,-170},{440,-130}}),
      iconTransformation(extent={{100,-120},{140,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBypValPos(
    final unit="1",
    displayUnit="1") if have_priOnl
    "Bypass valve position"
    annotation (Placement(transformation(extent={{400,-30},{440,10}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySecPumSpe(
    final unit="1",
    displayUnit="1") if not have_priOnl and have_varSecPum
    "Secondary pump speed vector"
    annotation (Placement(transformation(extent={{400,-390},{440,-350}}),
      iconTransformation(extent={{100,-200},{140,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TBoiHotWatSupSet[nBoi]
    "Boiler hot water supply temperature setpoint vector"
    annotation (Placement(transformation(extent={{400,170},{440,210}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Boi[nBoi](
    each table=[0,0; 1,1; 2,0],
    each timeScale=1000,
    each period=2000) "Boiler Enable signal"
    annotation (Placement(transformation(extent={{280,210},{300,230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSup(k=
        TPlaHotWatSetMax) "HW supply temperature set point"
    annotation (Placement(transformation(extent={{280,250},{300,270}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(final nout=nBoi)
    "Replicate signal"
    annotation (Placement(transformation(extent={{360,180},{380,200}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Pla(
    table=[0,0; 1,1; 2,0],
    timeScale=1000,
    period=2000) "Plant Enable signal"
    annotation (Placement(transformation(extent={{280,310},{300,330}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nBoi]
    annotation (Placement(transformation(extent={{340,130},{360,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zero(k=0) "Constant"
    annotation (Placement(transformation(extent={{340,-20},{360,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumPri[nPumPri](
    each table=[0,0; 1,1; 2,0],
    each timeScale=1000,
    each period=2000) "Primary pump Enable signal"
    annotation (Placement(transformation(extent={{280,-120},{300,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(k=1) "Constant"
    annotation (Placement(transformation(extent={{340,-160},{360,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumSec[nPumSec](
    each table=[0,0; 1,1; 2,0],
    each timeScale=1000,
    each period=2000) "Secondary pump Enable signal"
    annotation (Placement(transformation(extent={{280,-330},{300,-310}})));
protected
  parameter Boolean have_remDPRegPri = (speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.remoteDP)
    "Boolean flag for primary pump speed control with remote differential pressure";

  parameter Boolean have_locDPRegPri = (speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.localDP)
    "Boolean flag for primary pump speed control with local differential pressure";

  parameter Boolean have_temRegPri = (speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.temperature)
    "Boolean flag for primary pump speed control with temperature readings";

  parameter Boolean have_floRegPri = (speConTypPri == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.flowrate)
    "Boolean flag for primary pump speed control with flowrate readings";

  parameter Boolean have_remDPRegSec = (speConTypSec == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.SecondaryPumpSpeedControlTypes.remoteDP)
    "Boolean flag for secondary pump speed control with remote differential pressure";

  parameter Boolean have_locDPRegSec = (speConTypSec == Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.SecondaryPumpSpeedControlTypes.localDP)
    "Boolean flag for secondary pump speed control with local differential pressure";

  parameter Integer staInd[nSta]={i for i in 1:nSta}
    "Staging indices starting at 1";

  parameter Integer priPumInd[nPumPri]={i for i in 1:nPumPri}
    "Vector of primary pump indices up to total number of primary pumps";

  parameter Integer secPumInd[nPumSec]={i for i in 1:nPumSec}
    "Vector of secondary pump indices up to total number of secondary pumps";

equation

  connect(y1Boi.y[1], yBoi)
    annotation (Line(points={{302,220},{420,220}}, color={255,0,255}));
  connect(THeaWatSup.y, rep.u) annotation (Line(points={{302,260},{340,260},{
          340,190},{358,190}}, color={0,0,127}));
  connect(rep.y, TBoiHotWatSupSet) annotation (Line(points={{382,190},{420,190}},
                                color={0,0,127}));
  connect(y1Pla.y[1], yPla) annotation (Line(points={{302,320},{420,320}},
                      color={255,0,255}));
  connect(y1Boi.y[1], booToRea.u) annotation (Line(points={{302,220},{320,220},{
          320,140},{338,140}}, color={255,0,255}));
  connect(booToRea.y, yHotWatIsoVal)
    annotation (Line(points={{362,140},{420,140}}, color={0,0,127}));
  connect(zero.y, yBypValPos)
    annotation (Line(points={{362,-10},{420,-10}}, color={0,0,127}));
  connect(y1PumPri.y[1], yPriPum)
    annotation (Line(points={{302,-110},{420,-110}}, color={255,0,255}));
  connect(one.y, yPriPumSpe)
    annotation (Line(points={{362,-150},{420,-150}}, color={0,0,127}));
  connect(one.y, ySecPumSpe) annotation (Line(points={{362,-150},{380,-150},{380,
          -370},{420,-370}}, color={0,0,127}));
  connect(y1PumSec.y[1], ySecPum) annotation (Line(points={{302,-320},{351,-320},
          {351,-320},{420,-320}}, color={255,0,255}));
  connect(THeaWatSup.y, TPlaHotWatSupSet)
    annotation (Line(points={{302,260},{420,260}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-400,-600},{400,600}})), Icon(
        coordinateSystem(extent={{-100,-340},{100,340}})),
    Documentation(info="<html>
<p>
FIXME: This class is for temporary use only.
It aims at providing the outside connectors and parameters of the
G36 controller while the comments at

are being addressed.
</p>
</html>"));
end Guideline36Plugin;
