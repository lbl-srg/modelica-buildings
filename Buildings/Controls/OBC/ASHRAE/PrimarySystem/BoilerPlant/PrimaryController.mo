within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant;
model PrimaryController "Boiler plant primary loop controller"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType_priPum= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Primary pump control parameters", group="PID parameters"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType_bypVal= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Bypass valve control parameters"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType_secPum= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Secondary pump control parameters", group="PID parameters"));

  parameter Boolean is_mulPri
    "Is the primary loop part of a hybrid plant with multiple primary loops?"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Boolean is_PriLea = true
    "True: Lead primary loop
    False: Lag primary loop"
    annotation(Dialog(tab="General",
      group="Boiler plant configuration parameters",
      enable=is_mulPri));

  parameter Boolean have_priOnl = false
    "Is the primary loop primary-only? (Only allowed for condensing boilers)"
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

  parameter Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes
    speConTypPri = Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP
    "Primary pump speed regulation method"
    annotation (Dialog(group="Boiler plant configuration parameters", enable=have_varPriPum));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiAva[nBoi]
    "Boiler availability status signal"
    annotation (Placement(transformation(extent={{-440,28},{-400,68}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoi[nBoi]
    "Boiler status vector from plant"
    annotation (Placement(transformation(extent={{-440,-380},{-400,-340}}),
      iconTransformation(extent={{-140,-260},{-100,-220}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPriPum[nPumPri]
    "Primary pump proven on signal from plant"
    annotation (Placement(transformation(extent={{-440,-420},{-400,-380}}),
      iconTransformation(extent={{-140,-300},{-100,-260}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSchEna if not is_mulPri
     or is_PriLea
    "Signal indicating if schedule allows plant to be enabled"
    annotation (Placement(transformation(extent={{-440,400},{-400,440}}),
      iconTransformation(extent={{-140,380},{-100,420}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput plaReq if not is_mulPri
     or is_PriLea
    "Plant requests"
    annotation (Placement(transformation(extent={{-440,330},{-400,370}}),
      iconTransformation(extent={{-140,300},{-100,340}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TSupResReq
    "Hot water supply temperature reset requests"
    annotation (Placement(transformation(extent={{-440,360},{-400,400}}),
      iconTransformation(extent={{-140,340},{-100,380}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not is_mulPri or is_PriLea
    "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-440,290},{-400,330}}),
      iconTransformation(extent={{-140,260},{-100,300}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupPri(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-440,228},{-400,268}}),
      iconTransformation(extent={{-140,180},{-100,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRetPri(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured hot water primary return temperature"
    annotation (Placement(transformation(extent={{-440,188},{-400,228}}),
      iconTransformation(extent={{-140,140},{-100,180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatPri_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot water primary circuit flowrate"
    annotation (Placement(transformation(extent={{-440,148},{-400,188}}),
      iconTransformation(extent={{-140,100},{-100,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatPri_rem[nSenPri](
    final unit=fill("Pa", nSenPri),
    displayUnit=fill("Pa", nSenPri),
    final quantity=fill("PressureDifference", nSenPri)) if have_varPriPum and (have_remDPRegPri or have_locDPRegPri)
    "Measured differential pressure between hot water supply and return in primary circuit"
    annotation (Placement(transformation(extent={{-440,68},{-400,108}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRetSec(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not have_priOnl
    "Measured hot water secondary return temperature"
    annotation (Placement(transformation(extent={{-440,108},{-400,148}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatSec_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") if not have_priOnl and have_secFloSen
    "Measured hot water secondary circuit flowrate"
    annotation (Placement(transformation(extent={{-440,-90},{-400,-50}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatDec_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") if not have_priOnl and have_varPriPum
     and have_floRegPri and not have_secFloSen
    "Measured hot water flowrate through decoupler leg"
    annotation (Placement(transformation(extent={{-440,-130},{-400,-90}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSec(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not have_priOnl and
    have_varPriPum and have_temRegPri and have_priSecTemSen
    "Measured hot water supply temperature in secondary circuit"
    annotation (Placement(transformation(extent={{-440,-170},{-400,-130}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupBoi[nBoi](
    final unit=fill("K", nBoi),
    displayUnit=fill("degC", nBoi),
    final quantity=fill("ThermodynamicTemperature", nBoi)) if not have_priOnl
     and have_varPriPum and have_temRegPri and not have_priSecTemSen
    "Measured hot water supply temperatureat boiler outlets"
    annotation (Placement(transformation(extent={{-440,-210},{-400,-170}}),
      iconTransformation(extent={{-140,-180},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatPri_loc(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") if have_varPriPum and have_locDPRegPri
    "Measured differential pressure between hot water supply and return in primary circuit"
    annotation (Placement(transformation(extent={{-440,-240},{-400,-200}}),
        iconTransformation(extent={{-140,-220},{-100,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotWatIsoVal[nBoi](
    final unit=fill("1",nBoi),
    displayUnit=fill("1",nBoi)) if have_heaPriPum
    "Measured boiler isolation valve position signals from plant"
    annotation (Placement(transformation(extent={{-440,-500},{-400,-460}}),
      iconTransformation(extent={{-140,-340},{-100,-300}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBypValPos(
    final unit="1",
    displayUnit="1") if have_priOnl
    "Measured bypass valve position signal from plant"
    annotation (Placement(transformation(extent={{-440,-540},{-400,-500}}),
      iconTransformation(extent={{-140,-380},{-100,-340}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPriPumSpe[nPumPri](
    final unit=fill("1",nBoi),
    displayUnit=fill("1",nBoi)) if not have_priOnl
    "Measured primary pump speed signal from plant"
    annotation (Placement(transformation(extent={{-440,-580},{-400,-540}}),
      iconTransformation(extent={{-140,-420},{-100,-380}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoi[nBoi]
    "Boiler status vector"
    annotation (Placement(transformation(extent={{400,180},{440,220}}),
      iconTransformation(extent={{100,160},{140,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPriPum[nPumPri]
    "Primary pump enable status vector"
    annotation (Placement(transformation(extent={{400,-180},{440,-140}}),
      iconTransformation(extent={{100,-120},{140,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{400,280},{440,320}}),
      iconTransformation(extent={{100,240},{140,280}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TPlaHotWatSupSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Plant hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{400,220},{440,260}}),
      iconTransformation(extent={{100,200},{140,240}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatIsoVal[nBoi](
    final unit=fill("1",nBoi),
    displayUnit=fill("1",nBoi)) if have_heaPriPum
    "Boiler hot water isolation valve position vector"
    annotation (Placement(transformation(extent={{400,100},{440,140}}),
      iconTransformation(extent={{100,80},{140,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPriPumSpe(
    final unit="1",
    displayUnit="1") if have_varPriPum
    "Primary pump speed"
    annotation (Placement(transformation(extent={{400,-220},{440,-180}}),
      iconTransformation(extent={{100,-160},{140,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBypValPos(
    final unit="1",
    displayUnit="1") if have_priOnl
    "Bypass valve position"
    annotation (Placement(transformation(extent={{400,-50},{440,-10}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TBoiHotWatSupSet[nBoi](
    final unit=fill("K", nBoi),
    displayUnit=fill("K", nBoi),
    final quantity=fill("ThermodynamicTemperature", nBoi))
    "Boiler hot water supply temperature setpoint vector"
    annotation (Placement(transformation(extent={{400,150},{440,190}}),
      iconTransformation(extent={{100,120},{140,160}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable plaEna(
    final nIgnReq=nIgnReq,
    final TOutLoc=TOutLoc,
    final plaOffThrTim=plaOffThrTim,
    final plaOnThrTim=plaOnThrTim,
    final staOnReqTim=staOnReqTim) if not is_mulPri or is_PriLea
    "Plant enable controller"
    annotation (Placement(transformation(extent={{-340,320},{-320,340}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.SetpointController staSetCon(
    final have_priOnl=have_priOnl,
    final nBoi=nBoi,
    final boiTyp=boiTyp,
    final nSta=nSta,
    final staMat=staMat,
    final boiDesCap=boiDesCap,
    final boiFirMin=boiFirMin,
    final boiMinPriPumSpeSta=minPriPumSpeSta,
    final delStaCha=delStaCha,
    final avePer=avePer,
    final fraNonConBoi=fraNonConBoi,
    final fraConBoi=fraConBoi,
    final delEffCon=delEffCon,
    final TDif=TDif,
    final delFaiCon=delFaiCon,
    final sigDif=sigDif,
    final TDifHys=TDifHys,
    final fraMinFir=fraMinFir,
    final delMinFir=delMinFir,
    final fraDesCap=fraDesCap,
    final delDesCapNonConBoi=delDesCapNonConBoi,
    final delDesCapConBoi=delDesCapConBoi,
    final TCirDif=TCirDif,
    final delTRetDif=delTRetDif,
    final dTemp=dTemp)
    "Staging setpoint controller"
    annotation (Placement(transformation(extent={{-210,-30},{-190,22}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.MinimumFlowSetPoint minBoiFloSet(
    final nBoi=nBoi,
    final nSta=nSta,
    final staMat=staMat,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet,
    final bypSetRat=bypSetRat) if have_priOnl
    "Minimum flow setpoint for the primary loop"
    annotation (Placement(transformation(extent={{250,310},{270,330}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla if is_mulPri and not is_PriLea
    "Plant enable signal from a different primary loop"
                                                       annotation (Placement(
        transformation(extent={{-440,260},{-400,300}}),   iconTransformation(
          extent={{-140,220},{-100,260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCapMinFir(final unit="W", final quantity="Power") if
    is_mulPri and not is_PriLea
    "First stage minimum capacity of this primary loop"
                                                       annotation (Placement(
        transformation(extent={{400,-280},{440,-240}}), iconTransformation(
          extent={{100,-200},{140,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMaxSecPumSpe(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) if not have_priOnl
    "Maximum allowed secondary pump speed for preventing condensation"
    annotation (Placement(transformation(extent={{400,-100},{440,-60}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VMinSetFir_flow(final unit="m3/s", final quantity="VolumeFlowRate") if
       is_mulPri and not is_PriLea "First stage minimum flow setpoint"
    annotation (Placement(transformation(extent={{400,-320},{440,-280}}),
        iconTransformation(extent={{100,-240},{140,-200}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minFloSetVal(k=minFloSet[1])
    "Value of minimum flow setpoint for first stage"
    annotation (Placement(transformation(extent={{320,-310},{340,-290}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCapDesHig(final unit="W", final quantity="Power") if
       is_mulPri and is_PriLea
    "Design capacity of highest stage of this primary loop" annotation (
      Placement(transformation(extent={{400,-360},{440,-320}}),
        iconTransformation(extent={{100,-280},{140,-240}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaChaProEnd if is_mulPri and not is_PriLea
    "Signal indicating end of stage change process" annotation (Placement(
        transformation(extent={{400,60},{440,100}}), iconTransformation(extent={
            {100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHig if is_mulPri and is_PriLea
                                    "Current stage is highest available"
    annotation (Placement(transformation(extent={{400,20},{440,60}}),
        iconTransformation(extent={{100,0},{140,40}})));
protected
  parameter Boolean have_remDPRegPri = (speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP)
    "Boolean flag for primary pump speed control with remote differential pressure";

  parameter Boolean have_locDPRegPri = (speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP)
    "Boolean flag for primary pump speed control with local differential pressure";

  parameter Boolean have_temRegPri = (speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature)
    "Boolean flag for primary pump speed control with temperature readings";

  parameter Boolean have_floRegPri = (speConTypPri == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.flowrate)
    "Boolean flag for primary pump speed control with flowrate readings";

  parameter Integer staInd[nSta]={i for i in 1:nSta}
    "Staging indices starting at 1";

  parameter Integer priPumInd[nPumPri]={i for i in 1:nPumPri}
    "Vector of primary pump indices up to total number of primary pumps";

  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes
    "Used to break algebraic loop and sample staging setpoint signal"
    annotation (Placement(transformation(extent={{-210,360},{-190,380}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=0)
    "Constant zero signal source for integrator input"
    annotation (Placement(transformation(extent={{-280,410},{-260,430}})));

  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes1
    "Used to break algebraic loop and sample next boiler index to be enabled/disabled"
    annotation (Placement(transformation(extent={{90,370},{110,390}})));

  Buildings.Controls.OBC.CDL.Integers.Change cha1
    "Detect changes in staging setpoint signal"
    annotation (Placement(transformation(extent={{-220,320},{-200,340}})));

  Buildings.Controls.OBC.CDL.Integers.Change cha2
    "Detect changes to boiler index that is next enabled/disabled"
    annotation (Placement(transformation(extent={{76,344},{96,364}})));

  Buildings.Controls.OBC.CDL.Reals.MultiMax mulMax(
    final nin=nPumPri) if not have_priOnl
    "Identify maximum measured pump speed"
    annotation (Placement(transformation(extent={{-380,-570},{-360,-550}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha[nPumPri]
    "Detect changes in primary pump status"
    annotation (Placement(transformation(extent={{160,-430},{180,-410}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nPumPri)
    "Pass true signal when any of the pump statuses change"
    annotation (Placement(transformation(extent={{200,-430},{220,-410}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up upProCon(
    final have_priOnl=have_priOnl,
    final have_heaPriPum=have_heaPriPum,
    final nBoi=nBoi,
    final nSta=nSta,
    final TMinSupNonConBoi=TMinSupNonConBoi,
    final delProSupTemSet=delProSupTemSet,
    final delEnaMinFloSet=delEnaMinFloSet,
    final chaIsoValTim=chaIsoValTim,
    final delPreBoiEna=delPreBoiEna,
    final boiChaProOnTim=boiChaProOnTim,
    final delBoiEna=delBoiEna,
    final sigDif=TDifHys,
    final relFloDif=sigDif)
    "Stage-up process controller"
    annotation (Placement(transformation(extent={{120,76},{140,116}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Down dowProCon(
    final have_priOnl=have_priOnl,
    final have_heaPriPum=have_heaPriPum,
    final nBoi=nBoi,
    final nSta=nSta,
    final delEnaMinFloSet=delEnaMinFloSet,
    final chaIsoValTim=chaIsoValTim,
    final delPreBoiEna=delPreBoiEna,
    final boiChaProOnTim=boiChaProOnTim,
    final delBoiEna=delBoiEna,
    relFloDif=sigDif)
    "Stage-down process controller"
    annotation (Placement(transformation(extent={{120,20},{140,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Controller priPumCon(
    final controllerType=controllerType_priPum,
    final have_heaPriPum=have_heaPriPum,
    final have_priOnl=have_priOnl,
    final have_varPriPum=have_varPriPum,
    final use_priSecFloSen=have_secFloSen,
    final use_priTemSen=have_priSecTemSen,
    final nPum=nPumPri,
    final nBoi=nBoi,
    final nSen=nSenPri,
    final numIgnReq=numIgnReq,
    final nPum_nominal=nPumPri,
    final minPumSpe=minPumSpePri,
    final maxPumSpe=maxPumSpePri,
    final VHotWat_flow_nominal=VHotWatPri_flow_nominal,
    final boiDesFlo=boiDesFlo,
    final maxLocDp=maxLocDpPri,
    final minLocDp=minLocDpPri,
    final offTimThr=offTimThr_priPum,
    final timPer=timPer_priPum,
    final delBoiDis=delBoiEna,
    final staCon=staCon_priPum,
    final relFloHys=relFloHys_priPum,
    final delTim=delTim_priPum,
    final samPer=samPer_priPum,
    final triAmo=triAmo_priPum,
    final resAmo=resAmo_priPum,
    final maxRes=maxRes_priPum,
    final twoReqLimLow=twoReqLimLow_priPum,
    final twoReqLimHig=twoReqLimHig_priPum,
    final oneReqLimLow=oneReqLimLow_priPum,
    final oneReqLimHig=oneReqLimHig_priPum,
    final k=k_priPum,
    final Ti=Ti_priPum,
    final Td=Td_priPum,
    final speConTyp=speConTypPri)
    "Primary pump controller"
    annotation (Placement(transformation(extent={{120,-208},{140,-152}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.BypassValve.BypassValvePosition bypValPos(
    final nPum=nPumPri,
    final controllerType=controllerType_bypVal,
    final k=k_bypVal,
    final Ti=Ti_bypVal,
    final Td=Td_bypVal) if have_priOnl
    "Bypass valve controller"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.HotWaterSupplyTemperatureReset hotWatSupTemRes(
    final nPum=nPumPri,
    final nSta=nSta,
    final nBoi=nBoi,
    final nHotWatResReqIgn=nHotWatResReqIgn,
    final boiTyp=boiTyp,
    final TPlaHotWatSetMax = TPlaHotWatSetMax,
    final TConBoiHotWatSetMax = TConBoiHotWatSetMax,
    final TConBoiHotWatSetOff=TConBoiHotWatSetOff,
    final THotWatSetMinNonConBoi = THotWatSetMinNonConBoi,
    final THotWatSetMinConBoi = THotWatSetMinConBoi,
    final delTimVal=delTimVal,
    final samPerVal=samPerVal,
    final triAmoVal = triAmoVal,
    final resAmoVal=resAmoVal,
    final maxResVal=maxResVal,
    final holTimVal=holTimVal)
    "Hot water supply temperature setpoint reset controller"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Pass true signal at completion of stage up or stage down process"
    annotation (Placement(transformation(extent={{180,60},{200,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.CondensationControl conSet(
    final have_priOnl=have_priOnl,
    final have_varPriPum=have_varPriPum,
    final nSta=nSta,
    final TRetSet=TRetSet,
    final TRetMinAll=TRetMinAll,
    final minSecPumSpe=minSecPumSpe,
    final minPriPumSpeSta=minPriPumSpeSta)
    "Condensation control setpoint controller"
    annotation (Placement(transformation(extent={{-60,-112},{-40,-92}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Latch to identify if process is stage-up or stage-down"
    annotation (Placement(transformation(extent={{-50,350},{-30,370}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    "Switch input signal between stage-up and stage-down processes"
    annotation (Placement(transformation(extent={{22,320},{42,340}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Switch input signal between stage-up and stage-down processes"
    annotation (Placement(transformation(extent={{20,370},{40,390}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Latch to identify if staging process is complete or not"
    annotation (Placement(transformation(extent={{-188,170},{-168,190}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.MinimumFlowSetPoint minBoiFloSet1[nSta](
    final nBoi=fill(nBoi, nSta),
    final nSta=fill(nSta, nSta),
    final staMat=fill(staMat, nSta),
    final minFloSet=fill(minFloSet, nSta),
    final maxFloSet=fill(maxFloSet, nSta),
    final bypSetRat=fill(bypSetRat, nSta))
    "Calculate vector of minimum flow setpoints for all stages"
    annotation (Placement(transformation(extent={{-340,0},{-320,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nSta](
    final k=fill(0, nSta))
    "Constant zero Integer source"
    annotation (Placement(transformation(extent={{-390,20},{-370,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nSta](
    final k=fill(false, nSta))
    "Constant Boolean False signal"
    annotation (Placement(transformation(extent={{-390,-10},{-370,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[nSta](
    final k=staInd)
    "Constant stage Integer source"
    annotation (Placement(transformation(extent={{-390,-40},{-370,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[nPumPri](
    final k=priPumInd)
    "Constant stage Integer source"
    annotation (Placement(transformation(extent={{60,-138},{80,-118}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Sample stage setpoint when stage change process is complete"
    annotation (Placement(transformation(extent={{-136,-50},{-116,-30}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-108,-50},{-88,-30}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Integer to Real converter"
    annotation (Placement(transformation(extent={{-162,-50},{-142,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpHotWatSet(
    final k=maxLocDpPri) if have_priOnl
    "Differential pressure setpoint for primary circuit"
    annotation (Placement(transformation(extent={{60,-180},{80,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nBoi]
    "Switch input signal between stage-up and stage-down processes"
    annotation (Placement(transformation(extent={{180,260},{200,280}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{120,260},{140,280}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi[nBoi] if have_heaPriPum
    "Switch input signal between stage-up and stage-down processes"
    annotation (Placement(transformation(extent={{180,220},{200,240}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-180,360},{-160,380}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-240,360},{-220,380}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre4
    "Logical pre block"
    annotation (Placement(transformation(extent={{-216,170},{-196,190}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre6 if have_priOnl
    "Logical pre block to break algebraic loop"
    annotation (Placement(transformation(extent={{60,320},{80,340}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{60,370},{80,390}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{120,370},{140,390}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Logical pre block"
    annotation (Placement(transformation(extent={{300,-20},{320,0}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantDisable plaDis(
    final have_priOnl=have_priOnl,
    final have_heaPriPum=have_heaPriPum,
    final nBoi=nBoi,
    final chaHotWatIsoRat=chaIsoValRat,
    final delBoiDis=delBoiEna)
    "Plant disable process controller"
    annotation (Placement(transformation(extent={{240,60},{260,80}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1 if not have_priOnl
    "Switch input signal between stage-up and stage-down processes"
    annotation (Placement(transformation(extent={{64,280},{84,300}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1 if not have_priOnl
    "Or operator for pump stage change signal from up-staging, down-staging and plant disable process controllers"
    annotation (Placement(transformation(extent={{58,-220},{78,-200}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Ensure stage-down process is not initiated when plant is disabled"
    annotation (Placement(transformation(extent={{-28,50},{-8,70}})));

equation
  connect(staSetCon.yBoi, upProCon.uBoiSet) annotation (Line(points={{-188,-8},{
          64,-8},{64,95},{118,95}},  color={255,0,255}));
  connect(staSetCon.yBoi, dowProCon.uBoiSet) annotation (Line(points={{-188,-8},
          {86,-8},{86,38},{118,38}},  color={255,0,255}));
  connect(staSetCon.ySta, upProCon.uStaSet) annotation (Line(points={{-188,8},{20,
          8},{20,86},{118,86}}, color={255,127,0}));
  connect(staSetCon.ySta, dowProCon.uStaSet) annotation (Line(points={{-188,8},{
          20,8},{20,30},{118,30}},
                                color={255,127,0}));
  connect(staSetCon.yStaTyp, upProCon.uStaTyp) annotation (Line(points={{-188,12},
          {24,12},{24,89},{118,89}},color={255,127,0}));
  connect(staSetCon.yChaUpEdg, upProCon.uStaUpPro) annotation (Line(points={{-188,4},
          {58,4},{58,92},{118,92}},    color={255,0,255}));
  connect(conSet.yMinBypValPos, bypValPos.uMinBypValPos) annotation (Line(
        points={{-38,-98},{110,-98},{110,-46},{118,-46}},color={0,0,127}));
  connect(staSetCon.yStaTyp, conSet.uStaTyp) annotation (Line(points={{-188,12},
          {-84,12},{-84,-108},{-62,-108}},
                                 color={255,127,0}));
  connect(staSetCon.yChaUpEdg, lat.u) annotation (Line(points={{-188,4},{-64,4},
          {-64,360},{-52,360}},
                             color={255,0,255}));
  connect(staSetCon.yChaDowEdg, lat.clr) annotation (Line(points={{-188,-4},{-60,
          -4},{-60,354},{-52,354}},
                                  color={255,0,255}));
  connect(lat.y, logSwi.u2) annotation (Line(points={{-28,360},{10,360},{10,330},
          {20,330}},  color={255,0,255}));
  connect(upProCon.yOnOff, logSwi.u1) annotation (Line(points={{142,96},{150,96},
          {150,150},{0,150},{0,338},{20,338}},      color={255,0,255}));
  connect(dowProCon.yOnOff, logSwi.u3) annotation (Line(points={{142,40},{154,40},
          {154,144},{14,144},{14,322},{20,322}},    color={255,0,255}));
  connect(lat.y, intSwi.u2) annotation (Line(points={{-28,360},{10,360},{10,380},
          {18,380}},  color={255,0,255}));
  connect(upProCon.yLasDisBoi, intSwi.u1) annotation (Line(points={{142,88},{146,
          88},{146,72},{-12,72},{-12,388},{18,388}},  color={255,127,0}));
  connect(dowProCon.yLasDisBoi, intSwi.u3) annotation (Line(points={{142,32},{150,
          32},{150,68},{-6,68},{-6,372},{18,372}},    color={255,127,0}));
  connect(lat1.y, hotWatSupTemRes.uStaCha)
    annotation (Line(points={{-166,180},{-142,180}},
                                                  color={255,0,255}));
  connect(staSetCon.yStaTyp, hotWatSupTemRes.uTyp) annotation (Line(points={{-188,12},
          {-144,12},{-144,176},{-142,176}},                  color={255,127,0}));
  connect(minBoiFloSet1.VHotWatMinSet_flow, staSetCon.VMinSet_flow) annotation (
     Line(points={{-318,10},{-274,10},{-274,4},{-212,4}},
        color={0,0,127}));
  connect(conInt.y, minBoiFloSet1.uLasDisBoi) annotation (Line(points={{-368,30},
          {-360,30},{-360,16},{-342,16}},             color={255,127,0}));
  connect(con.y, minBoiFloSet1.uOnOff) annotation (Line(points={{-368,0},{-360,0},
          {-360,12},{-342,12}},                color={255,0,255}));
  connect(con.y, minBoiFloSet1.uStaChaPro) annotation (Line(points={{-368,0},{-360,
          0},{-360,8},{-342,8}},                color={255,0,255}));
  connect(conInt2.y, priPumCon.uPumLeaLag) annotation (Line(points={{82,-128},{
          86,-128},{86,-152.933},{118,-152.933}},
                                            color={255,127,0}));
  connect(plaReq, plaEna.supResReq) annotation (Line(points={{-420,350},{-360,350},
          {-360,330},{-342,330}},      color={255,127,0}));
  connect(reaToInt.u, triSam.y)
    annotation (Line(points={{-110,-40},{-114,-40}},
                                                   color={0,0,127}));
  connect(triSam.u, intToRea.y)
    annotation (Line(points={{-138,-40},{-140,-40}},
                                                   color={0,0,127}));
  connect(reaToInt.y, staSetCon.u) annotation (Line(points={{-86,-40},{-80,-40},
          {-80,-60},{-220,-60},{-220,-20},{-212,-20}},
                                                  color={255,127,0}));
  connect(TOut, plaEna.TOut) annotation (Line(points={{-420,310},{-360,310},{-360,
          324},{-342,324}},
                          color={0,0,127}));
  connect(TSupPri, staSetCon.THotWatSup) annotation (Line(points={{-420,248},{-240,
          248},{-240,8},{-212,8}},                    color={0,0,127}));
  connect(TRetPri, staSetCon.THotWatRet) annotation (Line(points={{-420,208},{-260,
          208},{-260,16},{-212,16}},                    color={0,0,127}));
  connect(TRetPri, conSet.THotWatRet) annotation (Line(points={{-420,208},{-260,
          208},{-260,-96},{-62,-96}},                   color={0,0,127}));
  connect(VHotWatPri_flow, staSetCon.VHotWat_flow) annotation (Line(points={{-420,
          168},{-270,168},{-270,12},{-212,12}},                 color={0,0,127}));
  connect(VHotWatPri_flow, upProCon.VHotWat_flow) annotation (Line(points={{-420,
          168},{-270,168},{-270,88},{114,88},{114,115},{118,115}}, color={0,0,127}));
  connect(VHotWatPri_flow, dowProCon.VHotWat_flow) annotation (Line(points={{-420,
          168},{-270,168},{-270,88},{114,88},{114,58},{118,58}}, color={0,0,127}));
  connect(VHotWatPri_flow, bypValPos.VHotWat_flow) annotation (Line(points={{-420,
          168},{-270,168},{-270,88},{114,88},{114,-38},{118,-38}}, color={0,0,127}));
  connect(VHotWatPri_flow, priPumCon.VHotWat_flow) annotation (Line(points={{-420,
          168},{-270,168},{-270,88},{114,88},{114,-164.133},{118,-164.133}},
                                                                     color={0,0,
          127}));
  connect(dpHotWatPri_rem, priPumCon.dpHotWat_remote) annotation (Line(points={{-420,88},
          {-280,88},{-280,-166},{-4,-166},{-4,-187.467},{118,-187.467}},
        color={0,0,127}));
  connect(dpHotWatSet.y, priPumCon.dpHotWatSet) annotation (Line(points={{82,-170},
          {90,-170},{90,-190.267},{118,-190.267}},
                                             color={0,0,127}));
  connect(upProCon.yBoi, logSwi1.u1) annotation (Line(points={{142,108},{148,108},
          {148,278},{178,278}}, color={255,0,255}));
  connect(dowProCon.yBoi, logSwi1.u3) annotation (Line(points={{142,52},{156,52},
          {156,262},{178,262}}, color={255,0,255}));
  connect(lat.y, booRep.u) annotation (Line(points={{-28,360},{-16,360},{-16,270},
          {118,270}},                  color={255,0,255}));
  connect(booRep.y, logSwi1.u2) annotation (Line(points={{142,270},{178,270}},
                                               color={255,0,255}));
  connect(upProCon.yHotWatIsoVal, swi.u1) annotation (Line(points={{142,100},{172,
          100},{172,238},{178,238}},
                                   color={0,0,127}));
  connect(dowProCon.yHotWatIsoVal, swi.u3) annotation (Line(points={{142,44},{164,
          44},{164,222},{178,222}},
                                  color={0,0,127}));
  connect(booRep.y, swi.u2) annotation (Line(points={{142,270},{160,270},{160,230},
          {178,230}}, color={255,0,255}));
  connect(priPumCon.yPumSpe, yPriPumSpe) annotation (Line(points={{142,-183.733},
          {260,-183.733},{260,-200},{420,-200}},
                                            color={0,0,127}));
  connect(bypValPos.yBypValPos, yBypValPos) annotation (Line(points={{142,-40},{
          148,-40},{148,-30},{420,-30}}, color={0,0,127}));
  connect(staSetCon.ySta, intToRea1.u) annotation (Line(points={{-188,8},{20,8},
          {20,300},{-250,300},{-250,370},{-242,370}},
                                                    color={255,127,0}));
  connect(reaToInt1.y, minBoiFloSet.uStaSet) annotation (Line(points={{-158,370},
          {-148,370},{-148,314},{248,314}},
                                        color={255,127,0}));
  connect(plaEna.yPla, staSetCon.uPla) annotation (Line(points={{-318,330},{-230,
          330},{-230,-16},{-212,-16}},      color={255,0,255}));
  connect(staSetCon.yChaEdg, pre4.u) annotation (Line(points={{-188,0},{-180,0},
          {-180,150},{-220,150},{-220,180},{-218,180}},
                              color={255,0,255}));
  connect(pre4.y, lat1.u) annotation (Line(points={{-194,180},{-190,180}},
                                    color={255,0,255}));
  connect(hotWatSupTemRes.TPlaHotWatSupSet, staSetCon.THotWatSupSet)
    annotation (Line(points={{-118,184},{-100,184},{-100,90},{-226,90},{-226,20},
          {-212,20}},
                color={0,0,127}));
  connect(reaToInt.y, conSet.uCurSta) annotation (Line(points={{-86,-40},{-80,-40},
          {-80,-102},{-62,-102}},         color={255,127,0}));
  connect(reaToInt1.y, intToRea.u) annotation (Line(points={{-158,370},{-148,370},
          {-148,-22},{-168,-22},{-168,-40},{-164,-40}},
                                                  color={255,127,0}));
  connect(reaToInt1.y, hotWatSupTemRes.uCurStaSet) annotation (Line(points={{-158,
          370},{-148,370},{-148,172},{-142,172}}, color={255,127,0}));
  connect(minBoiFloSet.VHotWatMinSet_flow, upProCon.VMinHotWatSet_flow)
    annotation (Line(points={{272,320},{280,320},{280,290},{110,290},{110,111},{
          118,111}}, color={0,0,127}));
  connect(minBoiFloSet.VHotWatMinSet_flow, dowProCon.VMinHotWatSet_flow)
    annotation (Line(points={{272,320},{280,320},{280,290},{110,290},{110,54},{118,
          54}}, color={0,0,127}));
  connect(minBoiFloSet.VHotWatMinSet_flow, bypValPos.VHotWatMinSet_flow)
    annotation (Line(points={{272,320},{280,320},{280,290},{110,290},{110,-34},{
          118,-34}}, color={0,0,127}));
  connect(logSwi.y, pre6.u)
    annotation (Line(points={{44,330},{58,330}}, color={255,0,255}));
  connect(pre6.y, minBoiFloSet.uOnOff) annotation (Line(points={{82,330},{94,330},
          {94,322},{248,322}}, color={255,0,255}));
  connect(intSwi.y, intToRea2.u) annotation (Line(points={{42,380},{58,380}},
                          color={255,127,0}));
  connect(reaToInt2.y, minBoiFloSet.uLasDisBoi) annotation (Line(points={{142,380},
          {150,380},{150,326},{248,326}}, color={255,127,0}));
  connect(upProCon.yStaChaPro, or2.u1) annotation (Line(points={{142,104},{168,104},
          {168,70},{178,70}},                                      color={255,0,
          255}));
  connect(dowProCon.yStaChaPro, or2.u2) annotation (Line(points={{142,48},{158,48},
          {158,62},{178,62}},                  color={255,0,255}));
  connect(pre1.y, triSam.trigger) annotation (Line(points={{322,-10},{372,-10},{
          372,-64},{-126,-64},{-126,-52}},
                                       color={255,0,255}));
  connect(pre1.y, staSetCon.uStaChaProEnd) annotation (Line(points={{322,-10},{372,
          -10},{372,-64},{-212,-64},{-212,-28}},
                                              color={255,0,255}));
  connect(pre1.y, minBoiFloSet.uStaChaPro) annotation (Line(points={{322,-10},{372,
          -10},{372,300},{140,300},{140,318},{248,318}},
                                    color={255,0,255}));
  connect(pre1.y, lat1.clr) annotation (Line(points={{322,-10},{372,-10},{372,164},
          {-192,164},{-192,174},{-190,174}},
                                         color={255,0,255}));
  connect(priPumCon.yHotWatPum, yPriPum)
    annotation (Line(points={{142,-176.267},{260,-176.267},{260,-160},{420,-160}},
          color={255,0,255}));

  connect(uBoiAva, staSetCon.uBoiAva) annotation (Line(points={{-420,48},{-300,48},
          {-300,-24},{-212,-24}},      color={255,0,255}));
  connect(plaEna.yPla, upProCon.uPlaEna) annotation (Line(points={{-318,330},{
          -230,330},{-230,83},{118,83}},                             color={255,
          0,255}));
  connect(plaDis.yHotWatIsoVal, yHotWatIsoVal) annotation (Line(points={{262,68},
          {300,68},{300,120},{420,120}}, color={0,0,127}));
  connect(plaDis.yBoi, yBoi) annotation (Line(points={{262,76},{274,76},{274,200},
          {420,200}},      color={255,0,255}));
  connect(or2.y, plaDis.uStaChaProEnd) annotation (Line(points={{202,70},{208,70},
          {208,62},{238,62}},                   color={255,0,255}));
  connect(swi.y, plaDis.uHotWatIsoVal) annotation (Line(points={{202,230},{220,230},
          {220,70},{238,70}}, color={0,0,127}));
  connect(logSwi1.y, plaDis.uBoi) annotation (Line(points={{202,270},{230,270},{
          230,74},{238,74}}, color={255,0,255}));
  connect(plaDis.yStaChaPro, pre1.u) annotation (Line(points={{262,64},{266,64},
          {266,-10},{298,-10}},                  color={255,0,255}));
  connect(plaEna.yPla, plaDis.uPla) annotation (Line(points={{-318,330},{-230,
          330},{-230,140},{226,140},{226,78},{238,78}},              color={255,
          0,255}));
  connect(plaEna.yPla, priPumCon.uPlaEna) annotation (Line(points={{-318,330},{
          -230,330},{-230,-78},{90,-78},{90,-158.533},{118,-158.533}},
                                                                  color={255,0,255}));
  connect(hotWatSupTemRes.TPlaHotWatSupSet, upProCon.THotWatSupSet) annotation (
     Line(points={{-118,184},{-100,184},{-100,107},{118,107}}, color={0,0,127}));
  connect(TRetPri, staSetCon.THotWatRetPri) annotation (Line(points={{-420,208},
          {-260,208},{-260,-4},{-212,-4}},   color={0,0,127}));
  connect(TRetSec, staSetCon.THotWatRetSec) annotation (Line(points={{-420,128},
          {-290,128},{-290,-8},{-212,-8}}, color={0,0,127}));
  connect(upProCon.yNexEnaBoi, intSwi1.u1) annotation (Line(points={{142,92},{160,
          92},{160,160},{56,160},{56,298},{62,298}}, color={255,127,0}));
  connect(dowProCon.yNexEnaBoi, intSwi1.u3) annotation (Line(points={{142,36},{152,
          36},{152,200},{44,200},{44,282},{62,282}}, color={255,127,0}));
  connect(lat.y, intSwi1.u2) annotation (Line(points={{-28,360},{-16,360},{-16,290},
          {62,290}}, color={255,0,255}));
  connect(intSwi1.y, priPumCon.uNexEnaBoi) annotation (Line(points={{86,290},{
          96,290},{96,-178.133},{118,-178.133}},
                                              color={255,127,0}));
  connect(staSetCon.yChaUpEdg, priPumCon.uStaUp) annotation (Line(points={{-188,4},
          {58,4},{58,-74},{92,-74},{92,-169.733},{118,-169.733}},
                                                          color={255,0,255}));
  connect(logSwi.y, priPumCon.uOnOff) annotation (Line(points={{44,330},{50,330},
          {50,-76},{98,-76},{98,-172.533},{118,-172.533}},  color={255,0,255}));
  connect(plaDis.yBoi, priPumCon.uBoiSta) annotation (Line(points={{262,76},{
          274,76},{274,-88},{112,-88},{112,-166.933},{118,-166.933}},
                                                                  color={255,0,255}));
  connect(conSet.yMinPriPumSpe, priPumCon.uMinPriPumSpeCon) annotation (Line(
        points={{-38,-102},{88,-102},{88,-193.067},{118,-193.067}},
                                                           color={0,0,127}));
  connect(VHotWatSec_flow, priPumCon.VHotWatSec_flow) annotation (Line(points={{-420,
          -70},{8,-70},{8,-224},{114,-224},{114,-195.867},{118,-195.867}},
        color={0,0,127}));
  connect(VHotWatDec_flow, priPumCon.VHotWatDec_flow) annotation (Line(points={{-420,
          -110},{-190,-110},{-190,-212},{6,-212},{6,-226},{116,-226},{116,
          -198.667},{118,-198.667}},
                             color={0,0,127}));
  connect(TSupPri, priPumCon.THotWatPri) annotation (Line(points={{-420,248},{
          -240,248},{-240,-201.467},{118,-201.467}},          color={0,0,127}));
  connect(TSupSec, priPumCon.THotWatSec) annotation (Line(points={{-420,-150},{
          -186,-150},{-186,-214},{2,-214},{2,-230},{108,-230},{108,-204.267},{
          118,-204.267}},
          color={0,0,127}));
  connect(TSupBoi, priPumCon.THotWatBoiSup) annotation (Line(points={{-420,-190},
          {-184,-190},{-184,-216},{0,-216},{0,-232},{110,-232},{110,-207.067},{
          118,-207.067}},
                      color={0,0,127}));
  connect(dpHotWatPri_loc, priPumCon.dpHotWat_local) annotation (Line(points={{-420,
          -220},{-180,-220},{-180,-234},{96,-234},{96,-184.667},{118,-184.667}},
        color={0,0,127}));
  connect(reaToInt2.y, priPumCon.uLasDisBoi) annotation (Line(points={{142,380},
          {150,380},{150,340},{288,340},{288,-210},{102,-210},{102,-181.867},{
          118,-181.867}}, color={255,127,0}));
  connect(conInt1.y, minBoiFloSet1.uStaSet) annotation (Line(points={{-368,-30},
          {-350,-30},{-350,4},{-342,4}}, color={255,127,0}));
  connect(pre1.y, dowProCon.uStaChaPro) annotation (Line(points={{322,-10},{372,
          -10},{372,-64},{78,-64},{78,26},{118,26}}, color={255,0,255}));
  connect(pre1.y, upProCon.uStaChaPro) annotation (Line(points={{322,-10},{372,
          -10},{372,-64},{78,-64},{78,80},{118,80}}, color={255,0,255}));
  connect(upProCon.yPumChaPro, or1.u1) annotation (Line(points={{142,84},{160,84},
          {160,14},{32,14},{32,-210},{56,-210}}, color={255,0,255}));
  connect(dowProCon.yPumChaPro, or1.u2) annotation (Line(points={{142,28},{156,28},
          {156,18},{28,18},{28,-218},{56,-218}}, color={255,0,255}));
  connect(or1.y, priPumCon.uPumChaPro) annotation (Line(points={{80,-210},{100,
          -210},{100,-175.333},{118,-175.333}},
                                          color={255,0,255}));
  connect(staSetCon.yChaDowEdg, and2.u2) annotation (Line(points={{-188,-4},{-40,
          -4},{-40,52},{-30,52}}, color={255,0,255}));
  connect(plaEna.yPla, and2.u1) annotation (Line(points={{-318,330},{-230,330},
          {-230,60},{-30,60}},color={255,0,255}));
  connect(and2.y, dowProCon.uStaDowPro) annotation (Line(points={{-6,60},{74,60},
          {74,34},{118,34}}, color={255,0,255}));
  connect(TSupResReq, hotWatSupTemRes.nHotWatSupResReq) annotation (Line(points=
         {{-420,380},{-256,380},{-256,200},{-144,200},{-144,184},{-142,184}},
        color={255,127,0}));
  connect(uBoi, upProCon.uBoi) annotation (Line(points={{-420,-360},{-34,-360},{
          -34,99},{118,99}}, color={255,0,255}));
  connect(uBoi, dowProCon.uBoi) annotation (Line(points={{-420,-360},{-34,-360},
          {-34,42},{118,42}}, color={255,0,255}));
  connect(uPriPum, hotWatSupTemRes.uHotWatPumSta) annotation (Line(points={{-420,
          -400},{-28,-400},{-28,28},{-158,28},{-158,188},{-142,188}}, color={255,
          0,255}));
  connect(uPriPum, priPumCon.uHotWatPum) annotation (Line(points={{-420,-400},{
          -28,-400},{-28,-155.733},{118,-155.733}},
                                                color={255,0,255}));
  connect(uPriPum, bypValPos.uPumSta) annotation (Line(points={{-420,-400},{-28,
          -400},{-28,-42},{118,-42}}, color={255,0,255}));
  connect(uPriPum, cha.u) annotation (Line(points={{-420,-400},{-28,-400},{-28,-420},
          {158,-420}}, color={255,0,255}));
  connect(cha.y, mulOr.u[1:nPumPri]) annotation (Line(points={{182,-420},{190,-420},{190,
          -420},{198,-420}},     color={255,0,255}));
  connect(mulOr.y, plaDis.uPumChaPro) annotation (Line(points={{222,-420},{232,-420},
          {232,66},{238,66}}, color={255,0,255}));
  connect(mulOr.y, upProCon.uPumChaPro) annotation (Line(points={{222,-420},{232,
          -420},{232,-20},{70,-20},{70,77},{118,77}}, color={255,0,255}));
  connect(mulOr.y, dowProCon.uPumChaPro) annotation (Line(points={{222,-420},{232,
          -420},{232,-20},{70,-20},{70,22},{118,22}}, color={255,0,255}));
  connect(uPriPumSpe, mulMax.u[1:2]) annotation (Line(points={{-420,-560},{-402,
          -560},{-402,-560},{-382,-560}}, color={0,0,127}));
  connect(mulMax.y, staSetCon.uPumSpe) annotation (Line(points={{-358,-560},{-262,
          -560},{-262,-12},{-212,-12}},
                                      color={0,0,127}));
  connect(uHotWatIsoVal, upProCon.uHotWatIsoVal) annotation (Line(points={{-420,
          -480},{38,-480},{38,103},{118,103}}, color={0,0,127}));
  connect(uHotWatIsoVal, dowProCon.uHotWatIsoVal) annotation (Line(points={{-420,
          -480},{38,-480},{38,46},{118,46}}, color={0,0,127}));
  connect(uHotWatIsoVal, priPumCon.uHotIsoVal) annotation (Line(points={{-420,
          -480},{38,-480},{38,-150},{110,-150},{110,-161.333},{118,-161.333}},
                                                                         color={
          0,0,127}));
  connect(uBypValPos, staSetCon.uBypValPos) annotation (Line(points={{-420,-520},
          {-258,-520},{-258,0},{-212,0}}, color={0,0,127}));
  connect(hotWatSupTemRes.TBoiHotWatSupSet, TBoiHotWatSupSet) annotation (Line(
        points={{-118,176},{360,176},{360,170},{420,170}}, color={0,0,127}));
  connect(intWitRes.y, reaToInt1.u)
    annotation (Line(points={{-188,370},{-182,370}}, color={0,0,127}));
  connect(intToRea1.y, intWitRes.y_reset_in) annotation (Line(points={{-218,370},
          {-216,370},{-216,362},{-212,362}}, color={0,0,127}));
  connect(reaToInt2.u, intWitRes1.y)
    annotation (Line(points={{118,380},{112,380}}, color={0,0,127}));
  connect(intToRea2.y, intWitRes1.y_reset_in) annotation (Line(points={{82,380},
          {84,380},{84,372},{88,372}}, color={0,0,127}));
  connect(con1.y, intWitRes.u) annotation (Line(points={{-258,420},{-214,420},{-214,
          370},{-212,370}},                            color={0,0,127}));
  connect(con1.y, intWitRes1.u) annotation (Line(points={{-258,420},{-214,420},{
          -214,398},{88,398},{88,380}},  color={0,0,127}));
  connect(cha1.y, intWitRes.trigger) annotation (Line(points={{-198,330},{-190,
          330},{-190,352},{-200,352},{-200,358}}, color={255,0,255}));
  connect(staSetCon.ySta, cha1.u) annotation (Line(points={{-188,8},{20,8},{20,300},
          {-226,300},{-226,330},{-222,330}},      color={255,127,0}));
  connect(intSwi.y, cha2.u) annotation (Line(points={{42,380},{54,380},{54,354},
          {74,354}}, color={255,127,0}));
  connect(cha2.y, intWitRes1.trigger) annotation (Line(points={{98,354},{100,
          354},{100,368}}, color={255,0,255}));
  connect(hotWatSupTemRes.TPlaHotWatSupSet, TPlaHotWatSupSet) annotation (Line(
        points={{-118,184},{320,184},{320,240},{420,240}}, color={0,0,127}));
  connect(plaEna.yPla, yPla) annotation (Line(points={{-318,330},{-230,330},{
          -230,252},{-80,252},{-80,192},{380,192},{380,300},{420,300}},
                                                                   color={255,0,
          255}));
  connect(uSchEna, plaEna.uSchEna) annotation (Line(points={{-420,420},{-350,420},
          {-350,336},{-342,336}}, color={255,0,255}));
  connect(uPla, yPla) annotation (Line(points={{-420,280},{-90,280},{-90,210},{380,
          210},{380,300},{420,300}}, color={255,0,255}));
  connect(uPla, and2.u1) annotation (Line(points={{-420,280},{-90,280},{-90,60},
          {-30,60}}, color={255,0,255}));
  connect(uPla, plaDis.uPla) annotation (Line(points={{-420,280},{-90,280},{-90,
          210},{226,210},{226,78},{238,78}}, color={255,0,255}));
  connect(uPla, upProCon.uPlaEna) annotation (Line(points={{-420,280},{-90,280},
          {-90,83},{118,83}}, color={255,0,255}));
  connect(uPla, staSetCon.uPla) annotation (Line(points={{-420,280},{-276,280},{
          -276,-16},{-212,-16}},         color={255,0,255}));
  connect(uPla, priPumCon.uPlaEna) annotation (Line(points={{-420,280},{-276,
          280},{-276,-78},{90,-78},{90,-158},{118,-158},{118,-158.533}},
                                                                    color={255,0,
          255}));
  connect(staSetCon.yCapMinFir,yCapMinFir)  annotation (Line(points={{-188,-16},
          {-178,-16},{-178,-260},{420,-260}},     color={0,0,127}));
  connect(conSet.yMaxSecPumSpe, yMaxSecPumSpe) annotation (Line(points={{-38,-106},
          {20,-106},{20,-80},{420,-80}}, color={0,0,127}));
  connect(minFloSetVal.y, VMinSetFir_flow)
    annotation (Line(points={{342,-300},{420,-300}}, color={0,0,127}));
  connect(staSetCon.yCapDesHig, yCapDesHig) annotation (Line(points={{-188,-20},
          {14,-20},{14,-340},{420,-340}},                          color={0,0,127}));
  connect(pre1.y, yStaChaProEnd) annotation (Line(points={{322,-10},{372,-10},{372,
          80},{420,80}}, color={255,0,255}));
  connect(staSetCon.yHig, yHig) annotation (Line(points={{-188,-12},{256,-12},{256,
          40},{420,40}},      color={255,0,255}));
  annotation (defaultComponentName="boiPlaCon",
    Icon(coordinateSystem(extent={{-100,-420},{100,420}}),
       graphics={
        Rectangle(
          extent={{-100,-420},{100,420}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-110,460},{110,420}},
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
            extent={{-394,392},{-266,290}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Text(
            extent={{-362,304},{-298,288}},
            pattern=LinePattern.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
            textString="Enable boiler plant"),
          Rectangle(
            extent={{-242,60},{-72,-70}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Text(
            extent={{-140,56},{-76,40}},
            pattern=LinePattern.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
          textString="Calculate stage setpoint"),
          Rectangle(
            extent={{-226,238},{-108,162}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Text(
            extent={{-226,236},{-156,218}},
            pattern=LinePattern.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
          textString="Calculate hot water supply
temperature setpoint",
          horizontalAlignment=TextAlignment.Left),
          Rectangle(
            extent={{-98,-76},{-2,-138}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Text(
            extent={{-94,-118},{0,-136}},
            pattern=LinePattern.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Calculate condensation
control setpoints"),
          Rectangle(
            extent={{52,-106},{224,-226}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Text(
            extent={{146,-106},{224,-114}},
            pattern=LinePattern.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Primary pump controller"),
          Rectangle(
            extent={{82,136},{264,-12}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Text(
            extent={{152,4},{226,-8}},
            pattern=LinePattern.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Staging process controllers"),
          Rectangle(
            extent={{-70,398},{226,216}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Text(
            extent={{152,392},{226,354}},
            pattern=LinePattern.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Pass signal from
up-staging or down-staging
process controller based
on the appropriate process"),
          Rectangle(
            extent={{238,362},{358,282}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Text(
            extent={{298,358},{346,312}},
            pattern=LinePattern.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Calculate minimum flow
setpoint for current stage"),
          Rectangle(
            extent={{-396,48},{-292,-54}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Text(
            extent={{-366,-26},{-292,-64}},
            pattern=LinePattern.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Calculate minimum flow
setpoint for all stages"),
          Rectangle(
            extent={{108,-22},{186,-60}},
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Text(
            extent={{156,-34},{192,-58}},
            pattern=LinePattern.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Bypass
valve
controller")}),
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
end PrimaryController;
