within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers;
model PrimaryController
  "Boiler plant primary loop controller"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType_priPum= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Primary pump control parameters", group="PID parameters"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType_bypVal= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Bypass valve control parameters"));

  parameter Boolean have_priOnl = false
    "Is the boiler plant primary-only?
    True: The boiler plant is primary-only;
    False: The boiler plant is primary-secondary"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Boolean have_heaPriPum = true
    "True: Headered primary hot water pumps;
    False: Dedicated primary hot water pumps"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Boolean have_isoValSen = false
    "True: Open and closed position sensors for boiler isolation valves;
    False: No sensors for boiler isolation valves"
    annotation(Dialog(tab="General",
      group="Boiler plant configuration parameters",
      enable=have_heaPriPum));

  parameter Boolean have_varPriPum = true
    "True: Variable-speed primary pumps;
    False: Fixed-speed primary pumps"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Boolean have_secFloSen=false
    "Required only for primary-secondary plant with flowrate-based primary pump 
    speed control.
    True: Flowrate sensor in secondary loop;
    False: Flowrate sensor in decoupler"
    annotation(Dialog(tab="General",
      group="Boiler plant configuration parameters",
      enable = (not have_priOnl) and
      speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.flowrate));

  parameter Boolean have_priTemSen(
    final start = false)
    "Required for primary-secondary boiler plant.
    True: Temperature sensor in primary loop.
    False: No temperature sensor in primary loop."
    annotation(Dialog(tab="General",
      group="Boiler plant configuration parameters",
      enable = not have_priOnl));

  parameter Boolean have_priSecTemSen=false
    "Required only for primary-secondary plant with temperature differential-based primary pump 
    speed control.
    True: Temperature sensor in primary loop;
    False: Temperature sensors in boiler supply outlets"
    annotation (Dialog(tab="General",
      group="Boiler plant configuration parameters",
      enable = (not have_priOnl) and
      speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Integer nLooSec(
    final min=1,
    final start=1)
    "Number of secondary loops serviced by primary plant"
    annotation (Dialog(tab="General",
      group="Boiler plant configuration parameters",
      enable=not have_priOnl));

  final parameter Integer nSta=size(staMat,1)
    "Number of boiler plant stages";

  parameter Integer nIgnReq(
    final min=0) = 0
    "Number of hot-water plant requests to be ignored before enabling boiler plant
    loop"
    annotation(Dialog(tab="Plant enable/disable parameters"));

  parameter Integer nBoi
    "Number of boilers"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer boiTyp[nBoi]={
    Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.BoilerTypes.condensingBoiler,
    Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.BoilerTypes.nonCondensingBoiler}
    "Boiler type"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer staMat[:, nBoi]
    "Staging matrix with stage as row index and boiler as column index"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer nPumPri
    "Number of primary pumps in the boiler plant loop"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer nHotWatResReqIgn = 2
    "Number of hot-water supply temperature reset requests to be ignored"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Integer nSenPri(
    final start=1)
    "Total number of remote differential pressure sensors in primary loop"
    annotation(Dialog(tab="General",
      group="Boiler plant configuration parameters",
      enable = have_priOnl));

  parameter Integer nIgnReq_priPum = 0
    "Number of ignored reset requests in primary pump speed control logic"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable= have_temRegPri));

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
    final unit=fill("W",nBoi),
    displayUnit=fill("W",nBoi),
    final quantity=fill("Power",nBoi))
    "Design boiler capacities vector"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real boiFirMin[nBoi](
    final unit=fill("1",nBoi),
    displayUnit=fill("1",nBoi))
    "Boiler minimum firing rate before cycling"
    annotation(Dialog(tab="General",
      group="Boiler plant configuration parameters",
      enable=have_allCon));

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

  parameter Real dTFai(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 10/1.8
    "Required temperature difference between setpoint and measured temperature for
    triggering failsafe condition"
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

  parameter Real dTHys(
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

  parameter Real dTCir(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 3/1.8
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
    final unit=fill("m3/s",nBoi),
    displayUnit=fill("m3/s",nBoi),
    final quantity=fill("VolumeFlowRate",nBoi),
    final min=fill(1e-6,nBoi),
    final max=maxFloSet)
    "Design minimum hot water flow through each boiler"
    annotation(Dialog(tab="General",
      group="Boiler plant configuration parameters"));

  parameter Real maxFloSet[nBoi](
    final unit=fill("m3/s",nBoi),
    displayUnit=fill("m3/s",nBoi),
    final quantity=fill("VolumeFlowRate",nBoi),
    final min=minFloSet,
    final start=minFloSet)
    "Design maximum hot water flow through each boiler"
    annotation(Dialog(tab="General",
      group="Boiler plant configuration parameters",
      enable=have_priOnl));

  parameter Real bypSetRat(
    final unit="m3/s2",
    displayUnit="m3/s2",
    final min=0) = 0.001
    "Rate at which to reset bypass valve setpoint during stage change"
    annotation(Dialog(tab="Staging setpoint parameters", group="General parameters"));

  parameter Real TPlaHotWatSetMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Highest hot water supply temperature setpoint"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real TConBoiHotWatSetMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature",
    final start=353.15)
    "Design hot water supply temperature for condensing boilers"
    annotation(Dialog(tab="Supply temperature reset parameters",
      group="Trim-and-Respond Logic parameters",
      enable=not have_allCon and not have_allNonCon));

  parameter Real dTConBoiHotWatSet(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = -5
    "The offset for hot water setpoint temperature for condensing boilers in 
    non-condensing stage type"
    annotation(Dialog(tab="Supply temperature reset parameters", group="General parameters"));

  parameter Real THotWatSetMinConBoi(
    final unit="K",
    displayUnit="degC",
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
    final quantity="TemperatureDifference") = -1.1
    "Setpoint trim value"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real resAmoVal(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1.7
    "Setpoint respond value"
    annotation(Dialog(tab="Supply temperature reset parameters", group="Trim-and-Respond Logic parameters"));

  parameter Real maxResVal(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 3.9
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
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 341.45
    "Minimum supply temperature required for non-condensing boilers"
    annotation(Dialog(tab="General",
      group="Boiler plant configuration parameters",
      enable=not have_allCon));

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
    final max=1,
    final start=0) = 0.1
    "Minimum pump speed"
    annotation(Dialog(tab="Primary pump control parameters",
      group="General parameters",
      enable=have_priOnl and have_varPriPum));

  parameter Real VHotWatPri_flow_nominal(
    final min=1e-6,
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate",
    final start=0)
    "Plant design hot water flow rate thorugh primary loop"
    annotation (Dialog(group="Boiler plant configuration parameters",
      enable=have_priOnl and have_heaPriPum and (have_remDPRegPri or have_locDPRegPri)));

  parameter Real boiDesFlo[nBoi](
    final min=fill(1e-6,nBoi),
    final unit=fill("m3/s",nBoi),
    displayUnit=fill("m3/s",nBoi),
    final quantity=fill("VolumeFlowRate",nBoi),
    final start=fill(0,nBoi))
    "Vector of design flowrates for all boilers in plant"
    annotation (Dialog(group="Boiler plant configuration parameters",
      enable=have_priOnl));

  parameter Real maxLocDpPri(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6,
    final start=minLocDpPri)
    "Maximum primary loop local differential pressure setpoint"
    annotation (Dialog(tab="Primary pump control parameters", group="DP-based speed regulation",
      enable = (have_locDPRegPri) and have_priOnl));

  parameter Real minLocDpPri(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6,
    final start=34473.8) = 34473.8
    "Minimum primary loop local differential pressure setpoint"
    annotation (Dialog(tab="Primary pump control parameters",
      group="DP-based speed regulation",
      enable = have_locDPRegPri and have_priOnl));

  parameter Real maxRemDpPri[nSenPri](
    final unit=fill("Pa",nSenPri),
    displayUnit=fill("Pa",nSenPri),
    final quantity=fill("PressureDifference",nSenPri),
    final min=fill(1e-6,nSenPri),
    final start=minRemDpPri)
    "Maximum primary loop local differential pressure setpoint"
    annotation (Dialog(tab="Primary pump control parameters", group="DP-based speed regulation",
      enable = (have_remDPRegPri or have_locDPRegPri) and have_priOnl));

  parameter Real minRemDpPri[nSenPri](
    final unit=fill("Pa",nSenPri),
    displayUnit=fill("Pa",nSenPri),
    final quantity=fill("PressureDifference",nSenPri),
    final min=fill(1e-6,nSenPri),
    final start=fill(34473.8,nSenPri)) = fill(34473.8,nSenPri)
    "Minimum primary loop local differential pressure setpoint"
    annotation (Dialog(tab="Primary pump control parameters",
      group="DP-based speed regulation",
      enable = (have_remDPRegPri or have_locDPRegPri) and have_priOnl));

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
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real samPer_priPum(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 120
    "Sample period of component"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real triAmo_priPum(
    final unit="1",
    displayUnit="1") = -0.02
    "Trim amount"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real resAmo_priPum(
    final unit="1",
    displayUnit="1") = 0.03
    "Respond amount"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real maxRes_priPum(
    final unit="1",
    displayUnit="1") = 0.06
    "Maximum response per time interval"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real twoReqLimLow_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1.2
    "Lower limit of hysteresis loop sending two requests"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real twoReqLimHig_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 2
    "Higher limit of hysteresis loop sending two requests"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real oneReqLimLow_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.2
    "Lower limit of hysteresis loop sending one request"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real oneReqLimHig_priPum(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Higher limit of hysteresis loop sending one request"
    annotation (Dialog(tab="Primary pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.temperature));

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
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 333.15
    "Minimum hot water return temperature for optimal non-condensing boiler performance"
    annotation(Dialog(tab="Condensation control parameters"));

  parameter Real TRetMinAll(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 330.35
    "Minimum allowed hot water return temperature for non-condensing boiler"
    annotation(Dialog(tab="Condensation control parameters"));

  parameter Real minSecPumSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1) = 0
    "Minimum secondary pump speed"
    annotation(Dialog(tab="Condensation control parameters",
      enable=not have_allCon));

  parameter Real minPriPumSpeSta[nSta](
    final unit=fill("1",nSta),
    displayUnit=fill("1",nSta),
    final min=fill(0,nSta),
    final max=fill(1,nSta),
    final start=fill(0,nSta))
    "Vector of minimum primary pump speed for each stage"
    annotation(Dialog(group="Boiler plant configuration parameters",
      enable=(not have_priOnl) and have_varPriPum));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes
    speConTypPri = Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.remoteDP
    "Primary pump speed regulation method"
    annotation (Dialog(group="Boiler plant configuration parameters", enable=have_varPriPum));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPriPum[nPumPri]
    "Primary pump status"
    annotation (Placement(transformation(extent={{-440,-320},{-400,-280}}),
      iconTransformation(extent={{-140,-280},{-100,-240}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSchEna
    "Signal indicating if schedule allows plant to be enabled"
    annotation (Placement(transformation(extent={{-440,400},{-400,440}}),
      iconTransformation(extent={{-140,360},{-100,400}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatIsoValOpe[nBoi]
    if have_heaPriPum and have_isoValSen
    "Boiler isolation valve open status"
    annotation (Placement(transformation(extent={{-440,-380},{-400,-340}}),
      iconTransformation(extent={{-140,-320},{-100,-280}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatIsoValClo[nBoi]
    if have_heaPriPum and have_isoValSen
    "Boiler isolation valve closed status"
    annotation (Placement(transformation(extent={{-440,-420},{-400,-380}}),
      iconTransformation(extent={{-140,-362},{-100,-322}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput plaReq
    "Plant requests"
    annotation (Placement(transformation(extent={{-440,330},{-400,370}}),
      iconTransformation(extent={{-140,280},{-100,320}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput resReq
    "Hot water reset requests"
    annotation (Placement(transformation(extent={{-440,360},{-400,400}}),
      iconTransformation(extent={{-140,320},{-100,360}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-440,290},{-400,330}}),
      iconTransformation(extent={{-140,240},{-100,280}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupPri(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_priOnl or have_priTemSen
    "Measured primary loop hot water supply temperature"
    annotation (Placement(transformation(extent={{-440,228},{-400,268}}),
      iconTransformation(extent={{-140,200},{-100,240}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRetPri(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Plant HW return temperature"
    annotation (Placement(transformation(extent={{-440,188},{-400,228}}),
      iconTransformation(extent={{-140,160},{-100,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatPri_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    if have_priOnl or not have_allNonCon or have_floRegPri
    "Measured hot water primary circuit flowrate"
    annotation (Placement(transformation(extent={{-440,148},{-400,188}}),
      iconTransformation(extent={{-140,120},{-100,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatPri_rem[nSenPri](
    final unit=fill("Pa", nSenPri),
    displayUnit=fill("Pa", nSenPri),
    final quantity=fill("PressureDifference", nSenPri)) if have_varPriPum and (have_remDPRegPri or have_locDPRegPri)
    "Measured differential pressure between hot water supply and return in primary circuit"
    annotation (Placement(transformation(extent={{-440,68},{-400,108}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRetSec(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not have_priOnl
    "Measured hot water secondary return temperature"
    annotation (Placement(transformation(extent={{-440,108},{-400,148}}),
      iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatSec_flow[nLooSec](
    final unit=fill("m3/s",nLooSec),
    displayUnit=fill("m3/s",nLooSec),
    final quantity=fill("VolumeFlowRate",nLooSec)) if not have_priOnl and have_secFloSen
    "Measured hot water secondary circuit flowrates from all loops"
    annotation(Placement(transformation(extent={{-440,-90},{-400,-50}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatDec_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") if not have_priOnl and have_varPriPum
     and have_floRegPri and not have_secFloSen
    "Measured hot water flowrate through decoupler leg"
    annotation (Placement(transformation(extent={{-440,-130},{-400,-90}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSec(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if not have_priOnl and have_varPriPum and have_temRegPri
    "Measured hot water supply temperature in secondary loop"
    annotation (Placement(transformation(extent={{-440,-170},{-400,-130}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupBoi[nBoi](
    final unit=fill("K", nBoi),
    displayUnit=fill("degC", nBoi),
    final quantity=fill("ThermodynamicTemperature", nBoi)) if not have_priOnl
     and (have_varPriPum and have_temRegPri and not have_priSecTemSen or not have_priTemSen)
    "Measured hot water supply temperature at boiler outlets"
    annotation (Placement(transformation(extent={{-440,-210},{-400,-170}}),
      iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatPri_loc(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") if have_varPriPum and have_locDPRegPri
    "Measured differential pressure between hot water supply and return in primary circuit"
    annotation (Placement(transformation(extent={{-440,-240},{-400,-200}}),
        iconTransformation(extent={{-140,-200},{-100,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoi[nBoi]
    "Boiler enable signal"
    annotation (Placement(transformation(extent={{400,180},{440,220}}),
      iconTransformation(extent={{100,80},{140,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPriPum[nPumPri]
    "Primary pump enable signal"
    annotation (Placement(transformation(extent={{400,-180},{440,-140}}),
      iconTransformation(extent={{100,-120},{140,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{400,280},{440,320}}),
      iconTransformation(extent={{100,120},{140,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHotWatIsoVal[nBoi]
    if have_heaPriPum
    "Boiler isolation valve enable signal"
    annotation (Placement(transformation(extent={{400,100},{440,140}}),
      iconTransformation(extent={{100,0},{140,40}})));

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
    displayUnit=fill("degC", nBoi),
    final quantity=fill("ThermodynamicTemperature", nBoi))
    "Boiler hot water supply temperature setpoint vector"
    annotation (Placement(transformation(extent={{400,150},{440,190}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMaxSecPumSpe(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) if not have_priOnl and not have_allCon
    "Maximum allowed secondary pump speed for preventing condensation"
    annotation (Placement(transformation(extent={{400,-100},{440,-60}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.PlantEnable plaEna(
    final nIgnReq=nIgnReq,
    final TOutLoc=TOutLoc,
    final plaOffThrTim=plaOffThrTim,
    final plaOnThrTim=plaOnThrTim,
    final staOnReqTim=staOnReqTim)
    "Plant enable controller"
    annotation (Placement(transformation(extent={{-340,320},{-320,340}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.SetpointController staSetCon(
    final have_priOnl=have_priOnl,
    final have_secFloSen=have_secFloSen,
    final nBoi=nBoi,
    final boiTyp=boiTyp,
    final staMat=staMat,
    final boiDesCap=boiDesCap,
    final boiFirMin=boiFirMin,
    final boiMinPriPumSpeSta=minPriPumSpeSta,
    final delStaCha=delStaCha,
    final avePer=avePer,
    final fraNonConBoi=fraNonConBoi,
    final fraConBoi=fraConBoi,
    final delEffCon=delEffCon,
    final dTFai=dTFai,
    final delFaiCon=delFaiCon,
    final sigDif=sigDif,
    final dTHys=dTHys,
    final fraMinFir=fraMinFir,
    final delMinFir=delMinFir,
    final fraDesCap=fraDesCap,
    final delDesCapNonConBoi=delDesCapNonConBoi,
    final delDesCapConBoi=delDesCapConBoi,
    final dTCir=dTCir,
    final delTRetDif=delTRetDif)
    "Staging setpoint controller"
    annotation (Placement(transformation(extent={{-210,-30},{-190,22}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.SetPoints.MinimumFlowSetPoint minBoiFloSet(
    final nBoi=nBoi,
    final nSta=nSta,
    final staMat=staMat,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet,
    final bypSetRat=bypSetRat) if have_priOnl
    "Minimum flow setpoint for the primary loop"
    annotation (Placement(transformation(extent={{250,310},{270,330}})));

protected
  parameter Boolean have_remDPRegPri = (speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.remoteDP)
    "Boolean flag for primary pump speed control with remote differential pressure";

  parameter Boolean have_locDPRegPri = (speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.localDP)
    "Boolean flag for primary pump speed control with local differential pressure";

  parameter Boolean have_temRegPri = (speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.temperature)
    "Boolean flag for primary pump speed control with temperature readings";

  parameter Boolean have_floRegPri = (speConTypPri == Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.flowrate)
    "Boolean flag for primary pump speed control with flowrate readings";

  parameter Integer staInd[nSta]={i for i in 1:nSta}
    "Staging indices starting at 1";

  parameter Integer priPumInd[nPumPri]={i for i in 1:nPumPri}
    "Vector of primary pump indices up to total number of primary pumps";

  parameter Boolean have_allCon = sum(boiTyp)==1*nBoi
    "Check if all the boilers in a plant are condensing boilers";

  parameter Boolean have_allNonCon = sum(boiTyp)==2*nBoi
    "Check if all the boilers in a plant are non-condensing boilers";

  Buildings.Controls.OBC.CDL.Logical.And and1[nBoi] if have_heaPriPum
    "Convey valve position signals from stage-up process block"
    annotation (Placement(transformation(extent={{240,250},{260,270}})));

  Buildings.Controls.OBC.CDL.Logical.And and3[nBoi] if have_heaPriPum
    "Convey valve position signals from stage-down process block"
    annotation (Placement(transformation(extent={{240,220},{260,240}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1[nBoi]
    "Identify stage-down process"
    annotation (Placement(transformation(extent={{182,220},{202,240}})));

  Buildings.Controls.OBC.CDL.Logical.Or or3[nBoi] if have_heaPriPum
    "Output final valve position signals"
    annotation (Placement(transformation(extent={{300,240},{320,260}})));

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

  Buildings.Controls.OBC.CDL.Logical.Change cha[nPumPri]
    "Detect changes in primary pump status"
    annotation (Placement(transformation(extent={{160,-320},{180,-300}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nPumPri)
    "Pass true signal when any of the pump statuses change"
    annotation (Placement(transformation(extent={{200,-320},{220,-300}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Up upProCon(
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
    final sigDif=dTHys,
    final relFloDif=sigDif)
    "Stage-up process controller"
    annotation (Placement(transformation(extent={{120,76},{140,116}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Down dowProCon(
    final have_priOnl=have_priOnl,
    final have_heaPriPum=have_heaPriPum,
    final nBoi=nBoi,
    final nSta=nSta,
    final delEnaMinFloSet=delEnaMinFloSet,
    final chaIsoValTim=chaIsoValTim,
    final delPreBoiEna=delPreBoiEna,
    final boiChaProOnTim=boiChaProOnTim,
    final delBoiEna=delBoiEna,
    final relFloDif=sigDif)
    "Stage-down process controller"
    annotation (Placement(transformation(extent={{120,20},{140,60}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.PrimaryPumps.Controller priPumCon(
    final controllerType=controllerType_priPum,
    final have_heaPriPum=have_heaPriPum,
    final have_priOnl=have_priOnl,
    final have_varPriPum=have_varPriPum,
    final use_priSecFloSen=have_secFloSen,
    final use_priTemSen=have_priSecTemSen,
    final nPum=nPumPri,
    final nBoi=nBoi,
    final nSen=nSenPri,
    final numIgnReq=nIgnReq_priPum,
    final nPum_nominal=nPumPri,
    final minPumSpe=minPumSpePri,
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

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.BypassValve.BypassValvePosition bypValPos(
    final nPum=nPumPri,
    final controllerType=controllerType_bypVal,
    final k=k_bypVal,
    final Ti=Ti_bypVal,
    final Td=Td_bypVal) if have_priOnl
    "Bypass valve controller"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.SetPoints.HotWaterSupplyTemperatureReset hotWatSupTemRes(
    final nPum=nPumPri,
    final nSta=nSta,
    final nBoi=nBoi,
    final nHotWatResReqIgn=nHotWatResReqIgn,
    final boiTyp=boiTyp,
    final TPlaHotWatSetMax = TPlaHotWatSetMax,
    final TConBoiHotWatSetMax = TConBoiHotWatSetMax,
    final dTConBoiHotWatSet=dTConBoiHotWatSet,
    final THotWatSetMinNonConBoi = TMinSupNonConBoi,
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

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.SetPoints.CondensationControl conSet(
    final have_priOnl=have_priOnl,
    final have_varPriPum=have_varPriPum,
    final nSta=nSta,
    final TRetSet=TRetSet,
    final TRetMinAll=TRetMinAll,
    final minSecPumSpe=minSecPumSpe,
    final minPriPumSpeSta=minPriPumSpeSta) if not have_allCon
    "Condensation control setpoint controller"
    annotation (Placement(transformation(extent={{-58,-112},{-38,-92}})));

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

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.SetPoints.MinimumFlowSetPoint minBoiFloSet1[nSta](
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
    final k=fill(true, nSta))
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

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpHotWatSet[nSenPri](
    final k=maxRemDpPri) if have_priOnl
    "Differential pressure setpoint for primary circuit"
    annotation (Placement(transformation(extent={{60,-180},{80,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nBoi]
    "Switch input signal between stage-up and stage-down processes"
    annotation (Placement(transformation(extent={{180,260},{200,280}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{120,260},{140,280}})));

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

  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Logical pre block"
    annotation (Placement(transformation(extent={{300,-20},{320,0}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.PlantDisable plaDis(
    final have_priOnl=have_priOnl,
    final have_heaPriPum=have_heaPriPum,
    final nBoi=nBoi,
    final delBoiDis=delBoiEna)
    "Plant disable process controller"
    annotation (Placement(transformation(extent={{240,60},{260,80}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1 if not have_priOnl
    "Switch input signal between stage-up and stage-down processes"
    annotation (Placement(transformation(extent={{64,280},{84,300}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1 if not have_priOnl
    "Or operator for pump stage change signal from up-staging, down-staging and
    plant disable process controllers"
    annotation (Placement(transformation(extent={{58,-220},{78,-200}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Ensure stage-down process is not initiated when plant is disabled"
    annotation (Placement(transformation(extent={{-28,50},{-8,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerSig(
    final k=0) if have_allCon
    "Zero signal for minimum bypass valve position and minimum primary pump speed
    in condensing-only boiler plants"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant oneSig(
    final k=1) if have_allCon
    "One signal for maximum secondary pump speed in condensing-only boiler plants"
    annotation (Placement(transformation(extent={{350,-120},{370,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{260,196},{240,216}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conHavPriOnl(
    final k=have_priOnl)
    "Boolean parameter selection for plant configuration"
    annotation (Placement(transformation(extent={{-340,-420},{-320,-400}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conIntLocDp(
    final k=have_locDPRegPri)
    "Speed control type signal"
    annotation (Placement(transformation(extent={{-300,-450},{-280,-430}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conIntRemDp(
    final k=have_remDPRegPri)
    "Speed control type signal"
    annotation (Placement(transformation(extent={{-300,-480},{-280,-460}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conIntFlo(
    final k=have_floRegPri)
    "Speed control type signal"
    annotation (Placement(transformation(extent={{-300,-510},{-280,-490}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conIntTem(
    final k=have_temRegPri)
    "Speed control type signal"
    annotation (Placement(transformation(extent={{-300,-540},{-280,-520}})));

  Buildings.Controls.OBC.CDL.Logical.And and4
    "Check if valid speed control type for selected configuration"
    annotation (Placement(transformation(extent={{-240,-450},{-220,-430}})));

  Buildings.Controls.OBC.CDL.Logical.And and5
    "Check if valid speed control type for selected configuration"
    annotation (Placement(transformation(extent={{-240,-480},{-220,-460}})));

  Buildings.Controls.OBC.CDL.Logical.And and6
    "Check if valid speed control type for selected configuration"
    annotation (Placement(transformation(extent={{-240,-510},{-220,-490}})));

  Buildings.Controls.OBC.CDL.Logical.And and7
    "Check if valid speed control type for selected configuration"
    annotation (Placement(transformation(extent={{-240,-540},{-220,-520}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Alternative selection for boiler plant configuration"
    annotation (Placement(transformation(extent={{-300,-570},{-280,-550}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=4)
    "Check compliance with all configuration selection rules"
    annotation (Placement(transformation(extent={{-200,-490},{-180,-470}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Invalid pump speed control selections. Please refer to
    documentation for allowed selections.")
    "Error message for non-compliant configuration selection"
    annotation (Placement(transformation(extent={{-160,-490},{-140,-470}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conHavPriOnl1(
    final k=have_priOnl)
    "Boolean parameter selection for plant configuration"
    annotation (Placement(transformation(extent={{-40,-490},{-20,-470}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conIntLocDp1(
    final k=have_heaPriPum)
    "Primary pump configuration type signal"
    annotation (Placement(transformation(extent={{-40,-450},{-20,-430}})));

  Buildings.Controls.OBC.CDL.Logical.And and8
    "Check if valid pump configuration type for selected configuration"
    annotation (Placement(transformation(extent={{20,-450},{40,-430}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Alternative selection for boiler plant configuration"
    annotation (Placement(transformation(extent={{20,-490},{40,-470}})));

  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Check compliance with all configuration selection rules"
    annotation (Placement(transformation(extent={{60,-470},{80,-450}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Invalid primary pump configuration selections. Please refer to
    documentation for allowed configuration selections.")
    "Error message for non-compliant configuration selection"
    annotation (Placement(transformation(extent={{100,-470},{120,-450}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(
    final nin=nLooSec) if not have_priOnl and have_secFloSen
    "Add up volume flowrate measurements for all secondary loops"
    annotation (Placement(transformation(extent={{-360,-100},{-340,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[nBoi]
    if have_heaPriPum and not have_isoValSen
    "Feed back isolation valve commands"
    annotation (Placement(transformation(extent={{300,80},{320,100}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat2[nBoi]
    if have_heaPriPum and have_isoValSen
    "Current boiler isolation valve status"
    annotation (Placement(transformation(extent={{-320,-370},{-300,-350}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conBoiAva[nBoi](
    final k=fill(true, nBoi))
    "Constant true signal for boiler availability"
    annotation (Placement(transformation(extent={{-320,-80},{-300,-60}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.Subsequences.TemperatureSupplyWeightedAverage TWeiAve(
    final nBoi=nBoi,
    final boiDesFlo=boiDesFlo) if not have_priOnl and (have_varPriPum and
    have_temRegPri and not have_priSecTemSen or not have_priTemSen)
    "Calculate weighted average of boiler supply temperatures"
    annotation (Placement(transformation(extent={{-260,-296},{-240,-276}})));

equation
  connect(staSetCon.yBoi, upProCon.uBoiSet) annotation (Line(points={{-188,
          -14.8333},{64,-14.8333},{64,98},{118,98}},
                                     color={255,0,255}));
  connect(staSetCon.yBoi, dowProCon.uBoiSet) annotation (Line(points={{-188,
          -14.8333},{86,-14.8333},{86,40},{118,40}},
                                      color={255,0,255}));
  connect(staSetCon.ySta, upProCon.uStaSet) annotation (Line(points={{-188,2.5},
          {20,2.5},{20,86},{118,86}},
                                color={255,127,0}));
  connect(staSetCon.ySta, dowProCon.uStaSet) annotation (Line(points={{-188,2.5},
          {20,2.5},{20,30},{118,30}},
                                color={255,127,0}));
  connect(staSetCon.yStaTyp, upProCon.uStaTyp) annotation (Line(points={{-188,
          6.83333},{24,6.83333},{24,90},{118,90}},
                                    color={255,127,0}));
  connect(staSetCon.yChaUpEdg, upProCon.uStaUpPro) annotation (Line(points={{-188,
          -1.83333},{58,-1.83333},{58,94},{118,94}},
                                       color={255,0,255}));
  connect(conSet.yMinBypValPos, bypValPos.uMinBypValPos) annotation (Line(
        points={{-36,-98},{110,-98},{110,-46},{118,-46}},color={0,0,127}));
  connect(staSetCon.yStaTyp, conSet.uStaTyp) annotation (Line(points={{-188,6.83333},
          {-84,6.83333},{-84,-108},{-60,-108}},
                                 color={255,127,0}));
  connect(staSetCon.yChaUpEdg, lat.u) annotation (Line(points={{-188,-1.83333},{
          -64,-1.83333},{-64,360},{-52,360}},
                             color={255,0,255}));
  connect(staSetCon.yChaDowEdg, lat.clr) annotation (Line(points={{-188,-10.5},{
          -60,-10.5},{-60,354},{-52,354}},
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
  connect(dowProCon.yLasDisBoi, intSwi.u3) annotation (Line(points={{142,30},{
          150,30},{150,68},{-6,68},{-6,372},{18,372}},color={255,127,0}));
  connect(lat1.y, hotWatSupTemRes.uStaCha)
    annotation (Line(points={{-166,180},{-142,180}},
                                                  color={255,0,255}));
  connect(staSetCon.yStaTyp, hotWatSupTemRes.uTyp) annotation (Line(points={{-188,
          6.83333},{-144,6.83333},{-144,176},{-142,176}},    color={255,127,0}));
  connect(minBoiFloSet1.VHotWatMinSet_flow, staSetCon.VMinSet_flow) annotation (
     Line(points={{-318,10},{-274,10},{-274,4.66667},{-212,4.66667}},
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
  connect(plaReq, plaEna.plaReq) annotation (Line(points={{-420,350},{-360,350},
          {-360,330},{-342,330}}, color={255,127,0}));
  connect(reaToInt.u, triSam.y)
    annotation (Line(points={{-110,-40},{-114,-40}},
                                                   color={0,0,127}));
  connect(triSam.u, intToRea.y)
    annotation (Line(points={{-138,-40},{-140,-40}},
                                                   color={0,0,127}));
  connect(reaToInt.y, staSetCon.u) annotation (Line(points={{-86,-40},{-80,-40},
          {-80,-60},{-220,-60},{-220,-21.3333},{-212,-21.3333}},
                                                  color={255,127,0}));
  connect(TOut, plaEna.TOut) annotation (Line(points={{-420,310},{-360,310},{-360,
          324},{-342,324}},
                          color={0,0,127}));
  connect(TSupPri, staSetCon.THotWatSup) annotation (Line(points={{-420,248},{-240,
          248},{-240,9},{-212,9}},                    color={0,0,127}));
  connect(TRetPri, conSet.THotWatRet) annotation (Line(points={{-420,208},{-260,
          208},{-260,-96},{-60,-96}},                   color={0,0,127}));
  connect(VHotWatPri_flow, staSetCon.VHotWatPri_flow) annotation (Line(points={{-420,
          168},{-270,168},{-270,17.6667},{-212,17.6667}},
                                                     color={0,0,127}));
  connect(VHotWatPri_flow, upProCon.VHotWat_flow) annotation (Line(points={{-420,
          168},{-270,168},{-270,88},{114,88},{114,118},{118,118}}, color={0,0,127}));
  connect(VHotWatPri_flow, dowProCon.VHotWat_flow) annotation (Line(points={{-420,
          168},{-270,168},{-270,88},{114,88},{114,60},{118,60}}, color={0,0,127}));
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
  connect(dowProCon.yBoi, logSwi1.u3) annotation (Line(points={{142,55},{156,55},
          {156,262},{178,262}}, color={255,0,255}));
  connect(lat.y, booRep.u) annotation (Line(points={{-28,360},{-16,360},{-16,270},
          {118,270}},                  color={255,0,255}));
  connect(booRep.y, logSwi1.u2) annotation (Line(points={{142,270},{178,270}},
                                               color={255,0,255}));
  connect(priPumCon.yPumSpe, yPriPumSpe) annotation (Line(points={{142,-183.733},
          {260,-183.733},{260,-200},{420,-200}},
                                            color={0,0,127}));
  connect(bypValPos.yBypValPos, yBypValPos) annotation (Line(points={{142,-40},{
          148,-40},{148,-30},{420,-30}}, color={0,0,127}));
  connect(staSetCon.ySta, intToRea1.u) annotation (Line(points={{-188,2.5},{20,2.5},
          {20,300},{-250,300},{-250,370},{-242,370}},
                                                    color={255,127,0}));
  connect(reaToInt1.y, minBoiFloSet.uStaSet) annotation (Line(points={{-158,370},
          {-148,370},{-148,314},{248,314}},
                                        color={255,127,0}));
  connect(plaEna.yPla, staSetCon.uPla) annotation (Line(points={{-318,330},{-230,
          330},{-230,-17},{-212,-17}},      color={255,0,255}));
  connect(staSetCon.yChaEdg, pre4.u) annotation (Line(points={{-188,-6.16667},{-180,
          -6.16667},{-180,150},{-220,150},{-220,180},{-218,180}},
                              color={255,0,255}));
  connect(pre4.y, lat1.u) annotation (Line(points={{-194,180},{-190,180}},
                                    color={255,0,255}));
  connect(hotWatSupTemRes.TPlaHotWatSupSet, staSetCon.THotWatSupSet)
    annotation (Line(points={{-118,184},{-100,184},{-100,90},{-226,90},{-226,22},
          {-212,22}},
                color={0,0,127}));
  connect(reaToInt.y, conSet.uCurSta) annotation (Line(points={{-86,-40},{-80,-40},
          {-80,-102},{-60,-102}},         color={255,127,0}));
  connect(reaToInt1.y, intToRea.u) annotation (Line(points={{-158,370},{-148,370},
          {-148,-22},{-168,-22},{-168,-40},{-164,-40}},
                                                  color={255,127,0}));
  connect(reaToInt1.y, hotWatSupTemRes.uCurStaSet) annotation (Line(points={{-158,
          370},{-148,370},{-148,172},{-142,172}}, color={255,127,0}));
  connect(minBoiFloSet.VHotWatMinSet_flow, upProCon.VMinHotWatSet_flow)
    annotation (Line(points={{272,320},{280,320},{280,290},{110,290},{110,114},
          {118,114}},color={0,0,127}));
  connect(minBoiFloSet.VHotWatMinSet_flow, dowProCon.VMinHotWatSet_flow)
    annotation (Line(points={{272,320},{280,320},{280,290},{110,290},{110,55},{
          118,55}},
                color={0,0,127}));
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
  connect(dowProCon.yStaChaPro, or2.u2) annotation (Line(points={{142,50},{158,
          50},{158,62},{178,62}},              color={255,0,255}));
  connect(pre1.y, triSam.trigger) annotation (Line(points={{322,-10},{372,-10},{
          372,-64},{-126,-64},{-126,-52}},
                                       color={255,0,255}));
  connect(pre1.y, staSetCon.uStaChaProEnd) annotation (Line(points={{322,-10},{372,
          -10},{372,-64},{-212,-64},{-212,-30}},
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

  connect(plaEna.yPla, upProCon.uPlaEna) annotation (Line(points={{-318,330},{
          -230,330},{-230,82},{118,82}},                             color={255,
          0,255}));
  connect(plaDis.yBoi, yBoi) annotation (Line(points={{262,76},{274,76},{274,200},
          {420,200}},      color={255,0,255}));
  connect(or2.y, plaDis.uStaChaProEnd) annotation (Line(points={{202,70},{208,70},
          {208,62},{238,62}},                   color={255,0,255}));
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
     Line(points={{-118,184},{-100,184},{-100,110},{118,110}}, color={0,0,127}));
  connect(TRetPri, staSetCon.THotWatRetPri) annotation (Line(points={{-420,208},
          {-260,208},{-260,-4},{-212,-4}},   color={0,0,127}));
  connect(TRetSec, staSetCon.THotWatRetSec) annotation (Line(points={{-420,128},
          {-290,128},{-290,-8.33333},{-212,-8.33333}},
                                           color={0,0,127}));
  connect(upProCon.yNexEnaBoi, intSwi1.u1) annotation (Line(points={{142,92},{160,
          92},{160,160},{56,160},{56,298},{62,298}}, color={255,127,0}));
  connect(dowProCon.yNexEnaBoi, intSwi1.u3) annotation (Line(points={{142,35},{
          152,35},{152,200},{44,200},{44,282},{62,282}},
                                                     color={255,127,0}));
  connect(lat.y, intSwi1.u2) annotation (Line(points={{-28,360},{-16,360},{-16,290},
          {62,290}}, color={255,0,255}));
  connect(intSwi1.y, priPumCon.uNexEnaBoi) annotation (Line(points={{86,290},{
          96,290},{96,-178.133},{118,-178.133}},
                                              color={255,127,0}));
  connect(staSetCon.yChaUpEdg, priPumCon.uStaUp) annotation (Line(points={{-188,
          -1.83333},{58,-1.83333},{58,-74},{92,-74},{92,-169.733},{118,-169.733}},
                                                          color={255,0,255}));
  connect(logSwi.y, priPumCon.uOnOff) annotation (Line(points={{44,330},{50,330},
          {50,-76},{98,-76},{98,-172.533},{118,-172.533}},  color={255,0,255}));
  connect(plaDis.yBoi, priPumCon.uBoi) annotation (Line(points={{262,76},{274,
          76},{274,-88},{112,-88},{112,-166.933},{118,-166.933}}, color={255,0,
          255}));
  connect(conSet.yMinPriPumSpe, priPumCon.uMinPriPumSpeCon) annotation (Line(
        points={{-36,-102},{88,-102},{88,-193.067},{118,-193.067}},
                                                           color={0,0,127}));
  connect(VHotWatDec_flow, priPumCon.VHotWatDec_flow) annotation (Line(points={{-420,
          -110},{-190,-110},{-190,-212},{6,-212},{6,-226},{116,-226},{116,
          -198.667},{118,-198.667}},
                             color={0,0,127}));
  connect(TSupPri, priPumCon.THotWatPri) annotation (Line(points={{-420,248},{
          -240,248},{-240,-201.467},{118,-201.467}},          color={0,0,127}));
  connect(TSupSec, priPumCon.THotWatSec) annotation (Line(points={{-420,-150},{
          -320,-150},{-320,-238},{108,-238},{108,-204.267},{118,-204.267}},
          color={0,0,127}));
  connect(TWeiAve.TSupAveWei, priPumCon.THotWatBoiSupWeiAve) annotation (Line(points={{-238,
          -286},{110,-286},{110,-207.067},{118,-207.067}},
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
          -10},{372,-64},{78,-64},{78,25},{118,25}}, color={255,0,255}));
  connect(pre1.y, upProCon.uStaChaPro) annotation (Line(points={{322,-10},{372,
          -10},{372,-64},{78,-64},{78,78},{118,78}}, color={255,0,255}));
  connect(upProCon.yPumChaPro, or1.u1) annotation (Line(points={{142,84},{160,84},
          {160,14},{32,14},{32,-210},{56,-210}}, color={255,0,255}));
  connect(dowProCon.yPumChaPro, or1.u2) annotation (Line(points={{142,25},{156,
          25},{156,18},{28,18},{28,-218},{56,-218}},
                                                 color={255,0,255}));
  connect(or1.y, priPumCon.uPumChaPro) annotation (Line(points={{80,-210},{100,
          -210},{100,-175.333},{118,-175.333}},
                                          color={255,0,255}));
  connect(staSetCon.yChaDowEdg, and2.u2) annotation (Line(points={{-188,-10.5},{
          -40,-10.5},{-40,52},{-30,52}},
                                  color={255,0,255}));
  connect(plaEna.yPla, and2.u1) annotation (Line(points={{-318,330},{-230,330},
          {-230,60},{-30,60}},color={255,0,255}));
  connect(and2.y, dowProCon.uStaDowPro) annotation (Line(points={{-6,60},{74,60},
          {74,35},{118,35}}, color={255,0,255}));
  connect(resReq, hotWatSupTemRes.nHotWatSupResReq) annotation (Line(points={{-420,
          380},{-256,380},{-256,200},{-144,200},{-144,184},{-142,184}}, color={
          255,127,0}));
  connect(uPriPum, hotWatSupTemRes.uHotWatPumSta) annotation (Line(points={{-420,
          -300},{-28,-300},{-28,28},{-158,28},{-158,188},{-142,188}}, color={255,
          0,255}));
  connect(uPriPum, priPumCon.uHotWatPum) annotation (Line(points={{-420,-300},{
          -28,-300},{-28,-155.733},{118,-155.733}},
                                                color={255,0,255}));
  connect(uPriPum, bypValPos.uPumSta) annotation (Line(points={{-420,-300},{-28,
          -300},{-28,-42},{118,-42}}, color={255,0,255}));
  connect(uPriPum, cha.u) annotation (Line(points={{-420,-300},{-28,-300},{-28,-310},
          {158,-310}}, color={255,0,255}));
  connect(cha.y, mulOr.u[1:nPumPri]) annotation (Line(points={{182,-310},{198,-310}},
                                 color={255,0,255}));
  connect(mulOr.y, plaDis.uPumChaPro) annotation (Line(points={{222,-310},{232,-310},
          {232,66},{238,66}}, color={255,0,255}));
  connect(mulOr.y, upProCon.uPumChaPro) annotation (Line(points={{222,-310},{232,
          -310},{232,-20},{70,-20},{70,74},{118,74}}, color={255,0,255}));
  connect(mulOr.y, dowProCon.uPumChaPro) annotation (Line(points={{222,-310},{232,
          -310},{232,-20},{70,-20},{70,20},{118,20}}, color={255,0,255}));
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
  connect(staSetCon.ySta, cha1.u) annotation (Line(points={{-188,2.5},{20,2.5},{
          20,300},{-226,300},{-226,330},{-222,330}},
                                                  color={255,127,0}));
  connect(intSwi.y, cha2.u) annotation (Line(points={{42,380},{54,380},{54,354},
          {74,354}}, color={255,127,0}));
  connect(cha2.y, intWitRes1.trigger) annotation (Line(points={{98,354},{100,
          354},{100,368}}, color={255,0,255}));
  connect(plaEna.yPla, yPla) annotation (Line(points={{-318,330},{-230,330},{
          -230,252},{-80,252},{-80,192},{380,192},{380,300},{420,300}},
                                                                   color={255,0,
          255}));
  connect(uSchEna, plaEna.uSchEna) annotation (Line(points={{-420,420},{-350,420},
          {-350,336},{-342,336}}, color={255,0,255}));
  connect(conSet.yMaxSecPumSpe, yMaxSecPumSpe) annotation (Line(points={{-36,-106},
          {20,-106},{20,-80},{420,-80}}, color={0,0,127}));
  connect(zerSig.y, bypValPos.uMinBypValPos) annotation (Line(points={{-38,-50},
          {0,-50},{0,-46},{118,-46}}, color={0,0,127}));
  connect(zerSig.y, priPumCon.uMinPriPumSpeCon) annotation (Line(points={{-38,-50},
          {0,-50},{0,-102},{88,-102},{88,-193.067},{118,-193.067}}, color={0,0,127}));
  connect(oneSig.y, yMaxSecPumSpe) annotation (Line(points={{372,-110},{372,
          -112},{388,-112},{388,-80},{420,-80}},
                                color={0,0,127}));
  connect(bypValPos.yBypValPos, staSetCon.uBypValPos) annotation (Line(points={{
          142,-40},{148,-40},{148,-74},{-224,-74},{-224,0},{-220,0},{-220,0.333333},
          {-212,0.333333}}, color={0,0,127}));
  connect(priPumCon.yPumSpe, staSetCon.uPumSpe) annotation (Line(points={{142,
          -183.733},{160,-183.733},{160,-270},{-250,-270},{-250,-12.6667},{-212,
          -12.6667}},
        color={0,0,127}));
  connect(yBoi, pre2.u) annotation (Line(points={{420,200},{276,200},{276,206},
          {262,206}}, color={255,0,255}));
  connect(pre2.y, upProCon.uBoi) annotation (Line(points={{238,206},{72,206},{
          72,102},{118,102}}, color={255,0,255}));
  connect(pre2.y, dowProCon.uBoi) annotation (Line(points={{238,206},{72,206},{
          72,50},{118,50}}, color={255,0,255}));
  connect(plaDis.yHotWatIsoVal, yHotWatIsoVal) annotation (Line(points={{262,68},
          {388,68},{388,120},{420,120}}, color={255,0,255}));
  connect(booRep.y, and1.u1) annotation (Line(points={{142,270},{160,270},{160,
          252},{228,252},{228,260},{238,260}}, color={255,0,255}));
  connect(booRep.y, not1.u) annotation (Line(points={{142,270},{160,270},{160,
          230},{180,230}}, color={255,0,255}));
  connect(not1.y, and3.u1)
    annotation (Line(points={{204,230},{238,230}}, color={255,0,255}));
  connect(upProCon.yHotWatIsoVal, and1.u2) annotation (Line(points={{142,100},{
          164,100},{164,248},{238,248},{238,252}}, color={255,0,255}));
  connect(dowProCon.yHotWatIsoVal, and3.u2) annotation (Line(points={{142,45},{
          164,45},{164,96},{180,96},{180,136},{216,136},{216,222},{238,222}},
        color={255,0,255}));
  connect(and1.y, or3.u1) annotation (Line(points={{262,260},{292,260},{292,250},
          {298,250}}, color={255,0,255}));
  connect(and3.y, or3.u2) annotation (Line(points={{262,230},{292,230},{292,242},
          {298,242}}, color={255,0,255}));
  connect(or3.y, plaDis.uHotWatIsoVal) annotation (Line(points={{322,250},{332,
          250},{332,160},{220,160},{220,70},{238,70}}, color={255,0,255}));
  connect(conHavPriOnl.y, and4.u2) annotation (Line(points={{-318,-410},{-270,-410},
          {-270,-448},{-242,-448}}, color={255,0,255}));
  connect(conHavPriOnl.y, and5.u2) annotation (Line(points={{-318,-410},{-270,-410},
          {-270,-478},{-242,-478}}, color={255,0,255}));
  connect(conHavPriOnl.y, not2.u) annotation (Line(points={{-318,-410},{-308,-410},
          {-308,-560},{-302,-560}},             color={255,0,255}));
  connect(not2.y, and6.u2) annotation (Line(points={{-278,-560},{-270,-560},{-270,
          -508},{-242,-508}}, color={255,0,255}));
  connect(not2.y, and7.u2) annotation (Line(points={{-278,-560},{-270,-560},{-270,
          -538},{-242,-538}}, color={255,0,255}));
  connect(and4.y, mulOr1.u[1]) annotation (Line(points={{-218,-440},{-212,-440},
          {-212,-482.625},{-202,-482.625}}, color={255,0,255}));
  connect(and5.y, mulOr1.u[2]) annotation (Line(points={{-218,-470},{-216,-470},
          {-216,-480.875},{-202,-480.875}}, color={255,0,255}));
  connect(and6.y, mulOr1.u[3]) annotation (Line(points={{-218,-500},{-212,-500},
          {-212,-480},{-202,-480},{-202,-479.125}}, color={255,0,255}));
  connect(and7.y, mulOr1.u[4]) annotation (Line(points={{-218,-530},{-212,-530},
          {-212,-480},{-202,-480},{-202,-477.375}}, color={255,0,255}));
  connect(conIntLocDp.y, and4.u1)
    annotation (Line(points={{-278,-440},{-242,-440}}, color={255,0,255}));
  connect(conIntRemDp.y, and5.u1)
    annotation (Line(points={{-278,-470},{-242,-470}}, color={255,0,255}));
  connect(conIntFlo.y, and6.u1)
    annotation (Line(points={{-278,-500},{-242,-500}}, color={255,0,255}));
  connect(conIntTem.y, and7.u1)
    annotation (Line(points={{-278,-530},{-242,-530}}, color={255,0,255}));
  connect(mulOr1.y, assMes.u)
    annotation (Line(points={{-178,-480},{-162,-480}}, color={255,0,255}));
  connect(plaDis.yHotWatIsoVal, priPumCon.uHotIsoVal) annotation (Line(points={{262,68},
          {280,68},{280,-100},{104,-100},{104,-161.333},{118,-161.333}},
        color={255,0,255}));
  connect(conHavPriOnl1.y, and8.u2) annotation (Line(points={{-18,-480},{10,-480},
          {10,-448},{18,-448}},  color={255,0,255}));
  connect(conHavPriOnl1.y, not3.u) annotation (Line(points={{-18,-480},{18,-480}},
                                  color={255,0,255}));
  connect(conIntLocDp1.y, and8.u1)
    annotation (Line(points={{-18,-440},{18,-440}}, color={255,0,255}));
  connect(or4.y, assMes1.u)
    annotation (Line(points={{82,-460},{98,-460}}, color={255,0,255}));
  connect(and8.y, or4.u1) annotation (Line(points={{42,-440},{52,-440},{52,-460},
          {58,-460}}, color={255,0,255}));
  connect(not3.y, or4.u2) annotation (Line(points={{42,-480},{52,-480},{52,-468},
          {58,-468}}, color={255,0,255}));
  connect(VHotWatSec_flow, mulSum.u) annotation (Line(points={{-420,-70},{-420,-72},
          {-376,-72},{-376,-90},{-362,-90}}, color={0,0,127}));
  connect(mulSum.y, staSetCon.VHotWatSec_flow) annotation (Line(points={{-338,
          -90},{-272,-90},{-272,13.3333},{-212,13.3333}},
                                                     color={0,0,127}));
  connect(mulSum.y, priPumCon.VHotWatSec_flow) annotation (Line(points={{-338,
          -90},{-110,-90},{-110,-195.867},{118,-195.867}},
                                                      color={0,0,127}));
  connect(plaDis.yHotWatIsoVal, pre.u) annotation (Line(points={{262,68},{292,
          68},{292,90},{298,90}}, color={255,0,255}));
  connect(pre.y, dowProCon.uHotWatIsoVal) annotation (Line(points={{322,90},{
          330,90},{330,-244},{40,-244},{40,45},{118,45}}, color={255,0,255}));
  connect(pre.y, upProCon.uHotWatIsoVal) annotation (Line(points={{322,90},{330,
          90},{330,-244},{40,-244},{40,106},{118,106}}, color={255,0,255}));
  connect(lat2.y, upProCon.uHotWatIsoVal) annotation (Line(points={{-298,-360},
          {40,-360},{40,106},{118,106}}, color={255,0,255}));
  connect(lat2.y, dowProCon.uHotWatIsoVal) annotation (Line(points={{-298,-360},
          {40,-360},{40,45},{118,45}}, color={255,0,255}));
  connect(uHotWatIsoValOpe, lat2.u)
    annotation (Line(points={{-420,-360},{-322,-360}}, color={255,0,255}));
  connect(uHotWatIsoValClo, lat2.clr) annotation (Line(points={{-420,-400},{
          -380,-400},{-380,-366},{-322,-366}}, color={255,0,255}));
  connect(conBoiAva.y, staSetCon.uBoiAva) annotation (Line(points={{-298,-70},{
          -234,-70},{-234,-25.6667},{-212,-25.6667}},
                                                 color={255,0,255}));
  connect(TSupBoi, TWeiAve.THotWatBoiSup) annotation (Line(points={{-420,-190},{
          -340,-190},{-340,-292},{-262,-292}}, color={0,0,127}));
  connect(pre2.y, TWeiAve.uBoiSta) annotation (Line(points={{238,206},{72,206},{
          72,118},{-266,118},{-266,-280},{-262,-280}}, color={255,0,255}));
  connect(TWeiAve.TSupAveWei, staSetCon.THotWatSup) annotation (Line(points={{-238,
          -286},{-220,-286},{-220,-204},{-242,-204},{-242,10},{-212,10},{-212,9}},
        color={0,0,127}));
  annotation (defaultComponentName="conPlaBoi",
    Icon(coordinateSystem(extent={{-100,-400},{100,400}}),
       graphics={
        Rectangle(
          extent={{-100,-400},{100,400}},
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
Block that controls the primary loop of a boiler plant according to section 5.21
in ASHRAE Guideline 36, 2021. It consists of the following components:
</p>
<ul>
<li>
Plant enable controller: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.PlantEnable\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.PlantEnable</a>.
</li>
<li>
Staging setpoint calculator: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.SetpointController\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.SetpointController</a>.
</li>
<li>
Stage-up process controller: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Up\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Up</a>.
</li>
<li>
Stage-down process controller: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Down\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Down</a>.
</li>
<li>
Primary pump controller: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.PrimaryPumps.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.PrimaryPumps.Controller</a>.
</li>
<li>
Bypass valve controller: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.BypassValve.BypassValvePosition\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.BypassValve.BypassValvePosition</a>.
</li>
<li>
Minimum flow setpoint calculator: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.SetPoints.MinimumFlowSetPoint\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.SetPoints.MinimumFlowSetPoint</a>.
</li>
<li>
Hot water supply temperature setpoint calculator: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.SetPoints.HotWaterSupplyTemperatureReset\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.SetPoints.HotWaterSupplyTemperatureReset</a>.
</li>
<li>
Condensation control setpoint calculator: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.SetPoints.CondensationControl\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.SetPoints.CondensationControl</a>.
</li>
<li>
Plant disable process controller: <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.PlantDisable\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.PlantDisable</a>.
</li>
</ul>
<p>
For correct usage of this block, refer to the example model
<a href=\"modelica://Buildings.Examples.BoilerPlants.ClosedLoopTest\">
Buildings.Examples.BoilerPlants.ClosedLoopTest</a>.
</p>
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
  </tr></thead>
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
  </tr>
  <tr>
    <td>have_heaPriPum</td>
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
    <td>have_varPriPum</td>
    <td>True</td>
    <td>True</td>
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
    <td>temperature</td>
    <td>NA</td>
    <td>flowrate</td>
    <td>temperature</td>
    <td>NA</td>
  </tr>
</tbody>
</table>
<p>
Note:
<ol>
<li>
The controller currently assumes the boilers are constantly available. Future
modifications will include logic for detecting availability.
</li>
<li>
The controller currently does not accommodate lead-lag rotation of boilers and
pumps. Future modifications will include existing sequences for lead-lag rotation.
</li>
</ol>
</p>
</html>"));
end PrimaryController;
