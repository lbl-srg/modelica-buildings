within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps;
block Controller
    "Sequences to control hot water pumps in boiler plants"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Pump control parameters", group="PID parameters"));

  parameter Boolean have_heaPriPum
    "Flag of headered hot water pumps design: true=headered, false=dedicated"
    annotation (Dialog(group="Plant parameters"));

  parameter Boolean have_priOnl
    "True: Plant is primary-only;
     False: Plant is primary-secondary"
    annotation (Dialog(group="Plant parameters"));

  parameter Boolean have_varPriPum
    "True: Variable-speed primary pumps;
     False: Fixed-speed primary pumps"
    annotation (Dialog(group="Plant parameters"));

  parameter Boolean use_priSecFloSen
    "True: Use flowrate sensors in primary/secondary loops for speed regulation;
    False: Flowrate sensor in decoupler leg for spoeed regulation"
    annotation (Dialog(group="Plant parameters",
      enable= speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.flowrate));

  parameter Boolean use_priTemSen
    "True: Use Temperature sensors in primary loop for speed control;
    False: Use temperature sensors in boiler supply for speed control"
    annotation (Dialog(group="Plant parameters",
      enable= speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Integer nPum
    "Total number of hot water pumps"
    annotation (Dialog(group="Plant parameters"));

  parameter Integer nBoi
    "Total number of boilers"
    annotation (Dialog(group="Plant parameters"));

  parameter Integer nSen
    "Total number of remote differential pressure sensors"
    annotation (Dialog(group="Plant parameters"));

  parameter Integer numIgnReq = 0
    "Number of ignored requests"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable= speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Integer nPum_nominal(
    final max=nPum,
    final min=1) = nPum
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(group="Plant parameters"));

  parameter Real minPumSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=maxPumSpe) = 0.1
    "Minimum pump speed"
    annotation (Dialog(group="Pump parameters", enable=have_varPriPum));

  parameter Real maxPumSpe(
    final unit="1",
    displayUnit="1",
    final min=minPumSpe,
    final max=1) = 1
    "Maximum pump speed"
    annotation (Dialog(group="Pump parameters", enable=have_varPriPum));

  parameter Real VHotWat_flow_nominal(
    final min=1e-6,
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Total plant design hot water flow rate"
    annotation (Dialog(group="Plant parameters"));

  parameter Real boiDesFlo[nBoi](
    final min=1e-6,
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")=
    "Vector of design flowrates for all boilers in plant"
    annotation (Dialog(group="Plant parameters"));

  parameter Real maxLocDp(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6)
    "Maximum hot water loop local differential pressure setpoint"
    annotation (Dialog(tab="Pump control parameters", group="DP-based speed regulation",
      enable = speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP));

  parameter Real minLocDp(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference",
    final min=1e-6)
    "Minimum hot water loop local differential pressure setpoint"
    annotation (Dialog(tab="Pump control parameters",
      group="DP-based speed regulation",
      enable = speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP));

  parameter Real offTimThr(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 180
    "Threshold to check lead boiler off time"
    annotation (Dialog(tab="Pump control parameters", group="Pump staging parameters"));

  parameter Real timPer(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 600
    "Delay time period for enabling and disabling lag pumps"
    annotation (Dialog(tab="Pump control parameters", group="Pump staging parameters"));

  parameter Real delBoiDis(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0)=180
    "Time delay after boilers have been disabled before completing disabling process"
    annotation (Dialog(tab="Pump control parameters", group="Pump staging parameters"));

  parameter Real staCon(
    final unit="1",
    displayUnit="1") = -0.03
    "Constant used in the staging equation"
    annotation (Dialog(tab="Pump control parameters", group="Pump staging parameters"));

  parameter Real relFloHys(
    final unit="1",
    displayUnit="1") = 0.01
    "Constant value used in hysteresis for checking relative flow rate"
    annotation (Dialog(tab="Pump control parameters", group="Pump staging parameters"));

  parameter Real delTim(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 900
    "Delay time"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real samPer(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 120
    "Sample period of component"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real triAmo(
    final unit="1",
    displayUnit="1") = -0.02
    "Trim amount"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real resAmo(
    final unit="1",
    displayUnit="1") = 0.03
    "Respond amount"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real maxRes(
    final unit="1",
    displayUnit="1") = 0.06
    "Maximum response per time interval"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real twoReqLimLow(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1.2
    "Lower limit of hysteresis loop sending two requests"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real twoReqLimHig(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 2
    "Higher limit of hysteresis loop sending two requests"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real oneReqLimLow(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.2
    "Lower limit of hysteresis loop sending one request"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real oneReqLimHig(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Higher limit of hysteresis loop sending one request"
    annotation (Dialog(tab="Pump control parameters",
      group="Temperature-based speed regulation",
      enable = speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature));

  parameter Real k(
    final unit="1",
    displayUnit="1",
    final min=0) = 1
    "Gain of controller"
    annotation (Dialog(tab="Pump control parameters", group="PID parameters"));

  parameter Real Ti(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Pump control parameters", group="PID parameters"));

  parameter Real Td(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Pump control parameters", group="PID parameters"));

  parameter Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes
    speConTyp = Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP
    "Speed regulation method"
    annotation (Dialog(group="Plant parameters", enable=have_varPriPum));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp if not have_priOnl
    "Stage up signal"
    annotation (Placement(transformation(extent={{-320,-210},{-280,-170}}),
      iconTransformation(extent={{-140,90},{-100,130}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff if not have_priOnl
    "Signal indicating stage change with simultaneous enabling and disabling of boilers"
    annotation (Placement(transformation(extent={{-320,-240},{-280,-200}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatPum[nPum]
    "Hot water pumps operating status"
    annotation (Placement(transformation(extent={{-320,120},{-280,160}}),
      iconTransformation(extent={{-140,240},{-100,280}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPlaEna
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-320,90},{-280,130}}),
      iconTransformation(extent={{-140,210},{-100,250}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiSta[nBoi] if not have_priOnl
    "Boiler status vector"
    annotation (Placement(transformation(extent={{-320,-90},{-280,-50}}),
      iconTransformation(extent={{-140,120},{-100,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumChaPro if not have_priOnl
    "Signal indicating start of pump change process"
    annotation (Placement(transformation(extent={{-320,-270},{-280,-230}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexEnaBoi if not have_heaPriPum
    "Index of next enabled boiler"
    annotation (Placement(transformation(extent={{-320,-320},{-280,-280}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uLasDisBoi if not have_heaPriPum
    "Index of last disabled boiler"
    annotation (Placement(transformation(extent={{-320,-360},{-280,-320}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uPumLeaLag[nPum] if have_heaPriPum
    "Hot water pump lead-lag order"
    annotation (Placement(transformation(extent={{-320,210},{-280,250}}),
      iconTransformation(extent={{-140,270},{-100,310}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotIsoVal[nBoi](
    final unit="1",
    displayUnit="1") if have_heaPriPum
    "Hot water isolation valve status"
    annotation (Placement(transformation(extent={{-320,50},{-280,90}}),
      iconTransformation(extent={{-140,180},{-100,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMinPriPumSpeCon(
    final unit="1",
    displayUnit="1") if have_varPriPum and not have_priOnl
    "Minimum allowed pump speed for non-condensing boilers"
    annotation (Placement(transformation(extent={{-320,-560},{-280,-520}}),
      iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWat_local(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") if have_priOnl and have_varPriPum
     and locDPReg
    "Hot water differential static pressure from local sensor"
    annotation (Placement(transformation(extent={{-320,-460},{-280,-420}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWat_remote[nSen](
    final unit=fill("Pa", nSen),
    final quantity=fill("PressureDifference", nSen)) if have_priOnl and
    have_varPriPum and (locDPReg or remDPReg)
    "Hot water differential static pressure from remote sensor"
    annotation (Placement(transformation(extent={{-320,-500},{-280,-460}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatSet(
    final unit="Pa",
    final quantity="PressureDifference") if have_priOnl and have_varPriPum
     and (locDPReg or remDPReg)
    "Hot water differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-320,-530},{-280,-490}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWat_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") if have_varPriPum
    "Hot water flow"
    annotation (Placement(transformation(extent={{-320,-40},{-280,0}}),
      iconTransformation(extent={{-140,150},{-100,190}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatSec_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") if not have_priOnl and have_varPriPum
     and floReg and use_priSecFloSen
    "Measured hot water flowrate through secondary loop"
    annotation (Placement(transformation(extent={{-320,-600},{-280,-560}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatDec_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") if not have_priOnl and have_varPriPum
     and floReg and not use_priSecFloSen
    "Measured hot water flowrate through decoupler"
    annotation (Placement(transformation(extent={{-320,-630},{-280,-590}}),
      iconTransformation(extent={{-140,-220},{-100,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatPri(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if not have_priOnl and
    have_varPriPum and temReg and use_priTemSen
    "Measured hot water temperature at primary loop supply"
    annotation (Placement(transformation(extent={{-320,-660},{-280,-620}}),
      iconTransformation(extent={{-140,-250},{-100,-210}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSec(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if not have_priOnl and
    have_varPriPum and temReg
    "Measured hot water temperature at secondary loop supply"
    annotation (Placement(transformation(extent={{-320,-690},{-280,-650}}),
      iconTransformation(extent={{-140,-280},{-100,-240}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatBoiSup[nBoi](
    final unit=fill("K", nBoi),
    displayUnit=fill("K",nBoi),
    final quantity=fill("ThermodynamicTemperature",nBoi)) if not have_priOnl
     and have_varPriPum and temReg and not use_priTemSen
    "Measured hot water temperature at boiler supply"
    annotation (Placement(transformation(extent={{-320,-720},{-280,-680}}),
      iconTransformation(extent={{-140,-310},{-100,-270}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHotWatPum[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{280,-20},{320,20}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumSpe(
    final min=0,
    final max=1,
    final unit="1") if have_varPriPum
    "Hot water pump speed"
    annotation (Placement(transformation(extent={{280,-566},{320,-526}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.EnableLag_flowrate
    enaLagHotPum(
    final nPum=nPum,
    final nPum_nominal=nPum_nominal,
    final timPer=timPer,
    final staCon=staCon,
    final relFloHys=relFloHys,
    final VHotWat_flow_nominal=VHotWat_flow_nominal) if have_priOnl and have_heaPriPum
    "Enable lag pump for primary-only plants using differential pressure pump speed control"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_localDp
    pumSpeLocDp(
    final controllerType=controllerType,
    final nSen=nSen,
    final nPum=nPum,
    final minLocDp=minLocDp,
    final maxLocDp=maxLocDp,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe,
    final k=k,
    final Ti=Ti,
    final Td=Td) if have_priOnl and have_varPriPum and locDPReg
    "Hot water pump speed control with local DP sensor"
    annotation (Placement(transformation(extent={{-60,-490},{-40,-470}})));

protected
  parameter Boolean remDPReg = (speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP)
    "Boolean flag for pump speed control with remote differential pressure";

  parameter Boolean locDPReg = (speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.localDP)
    "Boolean flag for pump speed control with local differential pressure";

  parameter Boolean temReg = (speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.temperature)
    "Boolean flag for pump speed control with temperature readings";

  parameter Boolean floReg = (speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.flowrate)
    "Boolean flag for pump speed control with flowrate readings";

  parameter Integer pumInd[nPum]={i for i in 1:nPum}
    "Pump index, {1,2,...,n}";

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=0) if have_priOnl
    "Constant Real zero signal"
    annotation (Placement(transformation(extent={{40,-466},{60,-446}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=0,
    final h=0) if not have_heaPriPum
    "Check if the lead boiler is turned on"
    annotation (Placement(transformation(extent={{-192,-80},{-172,-60}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 if not have_heaPriPum
    "Logical And"
    annotation (Placement(transformation(extent={{-46,-294},{-26,-274}})));

  Buildings.Controls.OBC.CDL.Logical.Or or3 if not have_heaPriPum
    "Logical Or"
    annotation (Placement(transformation(extent={{-48,-328},{-28,-308}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr1(
    final t=1)
    "Ensure module does not enable lead pump"
    annotation (Placement(transformation(extent={{-30,22},{-10,42}})));

  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr1(
    final t=1)
    "Ensure module does not disable lead pump"
    annotation (Placement(transformation(extent={{18,-20},{38,0}})));

  Buildings.Controls.OBC.CDL.Logical.And and3 if have_heaPriPum
    "Logical And"
    annotation (Placement(transformation(extent={{70,22},{90,42}})));

  Buildings.Controls.OBC.CDL.Logical.Or or4 if have_heaPriPum
    "Logical Or"
    annotation (Placement(transformation(extent={{72,-20},{92,0}})));

  Buildings.Controls.OBC.CDL.Reals.Max max if have_varPriPum
    "Pass higher value"
    annotation (Placement(transformation(extent={{134,-556},{154,-536}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.EnableLead_dedicated
    enaDedLeaPum(
    final offTimThr=offTimThr) if not have_heaPriPum
    "Enable lead pump of dedicated pumps"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.EnableLead_headered
    enaHeaLeaPum(
    final nBoi=nBoi) if have_heaPriPum "Enable lead pump of headered pumps"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_remoteDp
    pumSpeRemDp(
    final controllerType=controllerType,
    final nSen=nSen,
    final nPum=nPum,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe,
    final k=k,
    final Ti=Ti,
    final Td=Td) if have_priOnl and have_varPriPum and remDPReg
    "Hot water pump speed control with remote DP sensor"
    annotation (Placement(transformation(extent={{-60,-530},{-40,-510}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.Speed_flow
    pumSpeFlo(
    final controllerType=controllerType,
    final use_priSecSen=use_priSecFloSen,
    final nPum=nPum,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final VHotWat_flow_nominal=VHotWat_flow_nominal) if not have_priOnl and
    have_varPriPum and floReg
    "Pump speed control using flow sensors"
    annotation (Placement(transformation(extent={{-60,-574},{-40,-554}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.Speed_temperature
    pumSpeTem(
    final use_priSen=use_priTemSen,
    final nBoi=nBoi,
    final nPum=nPum,
    final numIgnReq=numIgnReq,
    final boiDesFlo=boiDesFlo,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe,
    final delTim=delTim,
    final samPer=samPer,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes,
    final twoReqLimLow=twoReqLimLow,
    final twoReqLimHig=twoReqLimHig,
    final oneReqLimLow=oneReqLimLow,
    final oneReqLimHig=oneReqLimHig) if not have_priOnl and have_varPriPum
     and temReg "Pump speed control using temperature sensors"
    annotation (Placement(transformation(extent={{-60,-608},{-40,-588}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nBoi] if not have_heaPriPum
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-252,-80},{-232,-60}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=nBoi) if not have_heaPriPum
    "Identify status of lead boiler"
    annotation (Placement(transformation(extent={{-222,-80},{-202,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-274,190},{-254,210}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nPum] if have_heaPriPum
    "Convert integer to real number"
    annotation (Placement(transformation(extent={{-220,220},{-200,240}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor leaPum(
    final nin=nPum) if have_heaPriPum
    "Lead pump index"
    annotation (Placement(transformation(extent={{-80,220},{-60,240}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt if have_heaPriPum
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-40,220},{-20,240}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexLagPum(
    final nin=nPum) if have_heaPriPum
    "Next lag pump"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1 if have_heaPriPum
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor lasLagPum(
    final nin=nPum) if have_heaPriPum
    "Last lag pump"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2 if have_heaPriPum
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nPum]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-250,-130},{-230,-110}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nPum)
    "Sum of integer inputs"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt if have_heaPriPum
    "Integer add"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nPum] if
    have_heaPriPum and (not have_priOnl)
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-250,-166},{-230,-146}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt1(
    final nin=nBoi) if have_heaPriPum and (not have_priOnl)
    "Sum of integer inputs"
    annotation (Placement(transformation(extent={{-200,-166},{-180,-146}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[nPum] if
    have_heaPriPum and (not have_priOnl)
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-248,-250},{-228,-230}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt2(
    final nin=nBoi) if have_heaPriPum and (not have_priOnl)
    "Sum of integer inputs"
    annotation (Placement(transformation(extent={{-202,-250},{-182,-230}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1 if not have_priOnl
    "Logical or"
    annotation (Placement(transformation(extent={{-250,-200},{-230,-180}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt1 if have_heaPriPum and (not have_priOnl)
    "Increase number of enabled boilers by one to initiate pump enable"
    annotation (Placement(transformation(extent={{-130,-170},{-110,-150}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi if have_heaPriPum and (not have_priOnl)
    "Integer switch"
    annotation (Placement(transformation(extent={{-96,-200},{-76,-180}})));

  Buildings.Controls.OBC.CDL.Integers.Greater intGre if have_heaPriPum and (not
    have_priOnl)
    "Check if more boilers than pumps are enabled"
    annotation (Placement(transformation(extent={{-40,-200},{-20,-180}})));

  Buildings.Controls.OBC.CDL.Integers.Less intLes if have_heaPriPum and (not
    have_priOnl)
    "Check if less boilers than pumps are enabled"
    annotation (Placement(transformation(extent={{-38,-250},{-18,-230}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat if not have_priOnl
    "Hold true signal when a pump needs to be enabled for stage change"
    annotation (Placement(transformation(extent={{-200,-200},{-180,-180}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 if have_heaPriPum and (not
    have_priOnl)
    "Initiate the pump enable process"
    annotation (Placement(transformation(extent={{0,-200},{20,-180}})));

  Buildings.Controls.OBC.CDL.Logical.And and5 if have_heaPriPum and (not
    have_priOnl)
    "Initiate the pump disable process"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 if have_heaPriPum and (not
    have_priOnl)
    "Logical not"
    annotation (Placement(transformation(extent={{50,-250},{70,-230}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.ChangeStatus
    chaPumSta(final nPum=nPum) if
                        not have_heaPriPum
    "Change lead pump status for dedicated primary pumps"
    annotation (Placement(transformation(extent={{58,100},{80,120}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.ChangeStatus
    chaPumSta1(
    final nPum=nPum) if have_heaPriPum
    "Change lead pump status for headered primary pumps"
    annotation (Placement(transformation(extent={{58,66},{80,86}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.ChangeStatus
    chaPumSta2(
    final nPum=nPum) if have_priOnl and have_heaPriPum
    "Change lag pump status for headered primary pumps in a plant that is primary-only"
    annotation (Placement(transformation(extent={{128,-42},{150,-22}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.ChangeStatus
    chaPumSta3(
    final nPum=nPum) if have_heaPriPum and (not have_priOnl)
    "Change lag pump status for headered primary pumps in a plant that is not primary-only"
    annotation (Placement(transformation(extent={{130,-182},{152,-162}})));

  Buildings.Controls.OBC.CDL.Logical.And and1 if not have_heaPriPum
    "Lag pump enable"
    annotation (Placement(transformation(extent={{-148,-294},{-128,-274}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2 if not have_heaPriPum
    "Logical not"
    annotation (Placement(transformation(extent={{-148,-330},{-128,-310}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.ChangeStatus
    chaPumSta4(
    final nPum=nPum) if not have_heaPriPum
    "Change lag pump status for dedicated primary pumps"
    annotation (Placement(transformation(extent={{62,-314},{84,-294}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2 if not have_heaPriPum
    "Lag pump disable"
    annotation (Placement(transformation(extent={{-110,-312},{-90,-292}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical Not"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=delBoiDis)
    "Delay pump disable after boilers have been disabled"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nPum]
    "Logical switch"
    annotation (Placement(transformation(extent={{182,-42},{202,-22}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nPum)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{142,30},{162,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nPum](
    final k=fill(false, nPum))
    "Boolean False signal"
    annotation (Placement(transformation(extent={{128,0},{148,20}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1 if not have_priOnl
    "Latch to hold process completion signal"
    annotation (Placement(transformation(extent={{-60,-400},{-40,-380}})));

  Buildings.Controls.OBC.CDL.Logical.Xor xor[nPum] if not have_priOnl
    "Check if all pumps are enabled and disabled as required"
    annotation (Placement(transformation(extent={{-180,-400},{-160,-380}})));

  Buildings.Controls.OBC.CDL.Logical.Not not4[nPum] if not have_priOnl
    "True signal for pumps that are at correct state"
    annotation (Placement(transformation(extent={{-140,-400},{-120,-380}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(nin=nPum) if not have_priOnl
    "Check if all pumps are at desired status"
    annotation (Placement(transformation(extent={{-100,-400},{-80,-380}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[nPum] if not have_priOnl
    "Logical pre block"
    annotation (Placement(transformation(extent={{-220,-400},{-200,-380}})));

  Buildings.Controls.OBC.CDL.Logical.Not not5 if not have_priOnl
    "Generate true signal when process is incomplete"
    annotation (Placement(transformation(extent={{-20,-400},{0,-380}})));

equation
  connect(enaDedLeaPum.uPlaEna, uPlaEna) annotation (Line(points={{-202,115},{-240,
          115},{-240,110},{-300,110}}, color={255,0,255}));

  connect(uPumLeaLag, intToRea.u)
    annotation (Line(points={{-300,230},{-222,230}}, color={255,127,0}));

  connect(intToRea.y, leaPum.u)
    annotation (Line(points={{-198,230},{-82,230}}, color={0,0,127}));

  connect(conInt.y, leaPum.index)
    annotation (Line(points={{-252,200},{-70,200},{-70,218}}, color={255,127,0}));

  connect(leaPum.y, reaToInt.u)
    annotation (Line(points={{-58,230},{-42,230}},color={0,0,127}));

  connect(intToRea.y, nexLagPum.u)
    annotation (Line(points={{-198,230},{-160,230},{-160,-50},{-82,-50}},
      color={0,0,127}));

  connect(nexLagPum.y, reaToInt1.u)
    annotation (Line(points={{-58,-50},{-42,-50}}, color={0,0,127}));

  connect(lasLagPum.y, reaToInt2.u)
    annotation (Line(points={{-58,-100},{-42,-100}}, color={0,0,127}));

  connect(enaLagHotPum.VHotWat_flow,VHotWat_flow)
    annotation (Line(points={{-202,4},{-266,4},{-266,-20},{-300,-20}},
      color={0,0,127}));

  connect(uHotWatPum,enaLagHotPum.uHotWatPum)
    annotation (Line(points={{-300,140},{-260,140},{-260,-3.8},{-202,-3.8}},
      color={255,0,255}));

  connect(intToRea.y, lasLagPum.u)
    annotation (Line(points={{-198,230},{-160,230},{-160,-100},{-82,-100}},
      color={0,0,127}));

  connect(pumSpeLocDp.dpHotWat_local,dpHotWat_local)
    annotation (Line(points={{-62,-472},{-230,-472},{-230,-440},{-300,-440}},
      color={0,0,127}));

  connect(pumSpeLocDp.dpHotWat_remote,dpHotWat_remote)
    annotation (Line(points={{-62,-484},{-200,-484},{-200,-480},{-300,-480}},
      color={0,0,127}));

  connect(pumSpeLocDp.dpHotWatSet,dpHotWatSet)
    annotation (Line(points={{-62,-488},{-220,-488},{-220,-510},{-300,-510}},
      color={0,0,127}));

  connect(dpHotWat_remote,pumSpeRemDp.dpHotWat)
    annotation (Line(points={{-300,-480},{-200,-480},{-200,-520},{-62,-520}},
      color={0,0,127}));

  connect(dpHotWatSet,pumSpeRemDp.dpHotWatSet)
    annotation (Line(points={{-300,-510},{-220,-510},{-220,-528},{-62,-528}},
      color={0,0,127}));

  connect(uHotWatPum, booToInt.u)
    annotation (Line(points={{-300,140},{-260,140},{-260,-120},{-252,-120}},
      color={255,0,255}));

  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-228,-120},{-202,-120}}, color={255,127,0}));

  connect(addInt.y, nexLagPum.index)
    annotation (Line(points={{-98,-70},{-70,-70},{-70,-62}}, color={255,127,0}));

  connect(mulSumInt.y, addInt.u2)
    annotation (Line(points={{-178,-120},{-128,-120},{-128,-76},{-122,-76}},
      color={255,127,0}));

  connect(conInt.y, addInt.u1)
    annotation (Line(points={{-252,200},{-140,200},{-140,-64},{-122,-64}},
      color={255,127,0}));

  connect(mulSumInt.y, lasLagPum.index)
    annotation (Line(points={{-178,-120},{-70,-120},{-70,-112}}, color={255,127,0}));

  connect(uHotIsoVal, enaHeaLeaPum.uHotWatIsoVal) annotation (Line(points={{-300,70},
          {-202,70}},                              color={0,0,127}));

  connect(VHotWat_flow,pumSpeFlo. VHotWatPri_flow) annotation (Line(points={{-300,
          -20},{-266,-20},{-266,-564},{-62,-564}},      color={0,0,127}));

  connect(VHotWatSec_flow,pumSpeFlo. VHotWatSec_flow) annotation (Line(points={{-300,
          -580},{-240,-580},{-240,-569},{-62,-569}},       color={0,0,127}));

  connect(VHotWatDec_flow,pumSpeFlo. VHotWatDec_flow) annotation (Line(points={{-300,
          -610},{-240,-610},{-240,-569},{-62,-569}},       color={0,0,127}));

  connect(THotWatPri, pumSpeTem.THotWatPri) annotation (Line(points={{-300,-640},
          {-80,-640},{-80,-594},{-62,-594}}, color={0,0,127}));

  connect(THotWatSec, pumSpeTem.THotWatSec) annotation (Line(points={{-300,-670},
          {-76,-670},{-76,-598},{-62,-598}}, color={0,0,127}));

  connect(THotWatBoiSup, pumSpeTem.THotWatBoiSup) annotation (Line(points={{-300,
          -700},{-68,-700},{-68,-606},{-62,-606}}, color={0,0,127}));

  connect(uBoiSta, pumSpeTem.uBoiSta) annotation (Line(points={{-300,-70},{-270,
          -70},{-270,-602},{-62,-602}}, color={255,0,255}));

  connect(uBoiSta, booToRea.u)
    annotation (Line(points={{-300,-70},{-254,-70}}, color={255,0,255}));

  connect(booToRea.y, extIndSig.u)
    annotation (Line(points={{-230,-70},{-224,-70}}, color={0,0,127}));

  connect(conInt.y, extIndSig.index) annotation (Line(points={{-252,200},{-140,200},
          {-140,-88},{-212,-88},{-212,-82}}, color={255,127,0}));

  connect(uBoiSta, booToInt1.u) annotation (Line(points={{-300,-70},{-270,-70},{
          -270,-156},{-252,-156}}, color={255,0,255}));

  connect(booToInt1.y, mulSumInt1.u[1:nPum]) annotation (Line(points={{-228,-156},
          {-202,-156}},                            color={255,127,0}));

  connect(booToInt2.y,mulSumInt2. u[1:nPum]) annotation (Line(points={{-226,-240},
          {-204,-240}},                            color={255,127,0}));

  connect(uHotWatPum, booToInt2.u) annotation (Line(points={{-300,140},{-260,140},
          {-260,-240},{-250,-240}}, color={255,0,255}));

  connect(or1.u1, uStaUp)
    annotation (Line(points={{-252,-190},{-300,-190}}, color={255,0,255}));

  connect(uOnOff, or1.u2) annotation (Line(points={{-300,-220},{-256,-220},{-256,
          -198},{-252,-198}}, color={255,0,255}));

  connect(conInt.y, addInt1.u1) annotation (Line(points={{-252,200},{-140,200},{
          -140,-154},{-132,-154}}, color={255,127,0}));

  connect(mulSumInt1.y, addInt1.u2) annotation (Line(points={{-178,-156},{-154,-156},
          {-154,-166},{-132,-166}}, color={255,127,0}));

  connect(addInt1.y, intSwi.u1) annotation (Line(points={{-108,-160},{-104,-160},
          {-104,-182},{-98,-182}}, color={255,127,0}));

  connect(mulSumInt1.y, intSwi.u3) annotation (Line(points={{-178,-156},{-154,-156},
          {-154,-198},{-98,-198}}, color={255,127,0}));

  connect(intSwi.y, intGre.u1)
    annotation (Line(points={{-74,-190},{-42,-190}}, color={255,127,0}));

  connect(mulSumInt2.y, intGre.u2) annotation (Line(points={{-180,-240},{-72,-240},
          {-72,-198},{-42,-198}}, color={255,127,0}));

  connect(intSwi.y, intLes.u1) annotation (Line(points={{-74,-190},{-56,-190},{-56,
          -240},{-40,-240}}, color={255,127,0}));

  connect(mulSumInt2.y, intLes.u2) annotation (Line(points={{-180,-240},{-72,-240},
          {-72,-248},{-40,-248}}, color={255,127,0}));

  connect(or1.y, lat.u)
    annotation (Line(points={{-228,-190},{-202,-190}}, color={255,0,255}));

  connect(lat.y, intSwi.u2)
    annotation (Line(points={{-178,-190},{-98,-190}}, color={255,0,255}));

  connect(intGre.y, and4.u1)
    annotation (Line(points={{-18,-190},{-2,-190}}, color={255,0,255}));

  connect(intLes.y, and5.u1)
    annotation (Line(points={{-16,-240},{-2,-240}}, color={255,0,255}));

  connect(not1.u, and5.y)
    annotation (Line(points={{48,-240},{22,-240}}, color={255,0,255}));

  connect(pumSpeRemDp.yHotWatPumSpe, max.u2) annotation (Line(points={{-38,-520},
          {96,-520},{96,-552},{132,-552}}, color={0,0,127}));

  connect(pumSpeLocDp.yHotWatPumSpe, max.u2) annotation (Line(points={{-38,-480},
          {96,-480},{96,-552},{132,-552}}, color={0,0,127}));

  connect(pumSpeFlo.yHotWatPumSpe, max.u2) annotation (Line(points={{-38,-564},{
          96,-564},{96,-552},{132,-552}}, color={0,0,127}));

  connect(pumSpeTem.yHotWatPumSpe, max.u2) annotation (Line(points={{-38,-598},{
          96,-598},{96,-552},{132,-552}}, color={0,0,127}));

  connect(uMinPriPumSpeCon, max.u1)
    annotation (Line(points={{-300,-540},{132,-540}}, color={0,0,127}));

  connect(enaDedLeaPum.yLea, chaPumSta.uNexLagPumSta) annotation (Line(points={
          {-178,110},{22,110},{22,118},{56,118}}, color={255,0,255}));

  connect(enaDedLeaPum.yLea, chaPumSta.uLasLagPumSta) annotation (Line(points={
          {-178,110},{22,110},{22,115},{56,115}}, color={255,0,255}));

  connect(reaToInt.y, chaPumSta1.uNexLagPum) annotation (Line(points={{-18,230},
          {46,230},{46,72},{56,72}}, color={255,127,0}));

  connect(reaToInt.y, chaPumSta1.uLasLagPum) annotation (Line(points={{-18,230},
          {46,230},{46,68},{56,68}}, color={255,127,0}));

  connect(enaHeaLeaPum.yLea, chaPumSta1.uNexLagPumSta) annotation (Line(points=
          {{-178,70},{36,70},{36,84},{56,84}}, color={255,0,255}));

  connect(enaHeaLeaPum.yLea, chaPumSta1.uLasLagPumSta) annotation (Line(points=
          {{-178,70},{36,70},{36,81},{56,81}}, color={255,0,255}));

  connect(uHotWatPum, chaPumSta.uHotWatPum) annotation (Line(points={{-300,140},
          {26,140},{26,110},{56,110}}, color={255,0,255}));

  connect(uHotWatPum, chaPumSta1.uHotWatPum) annotation (Line(points={{-300,140},
          {26,140},{26,76},{56,76}}, color={255,0,255}));

  connect(reaToInt1.y, chaPumSta2.uNexLagPum) annotation (Line(points={{-18,-50},
          {30,-50},{30,-36},{126,-36}},color={255,127,0}));

  connect(reaToInt2.y, chaPumSta2.uLasLagPum) annotation (Line(points={{-18,
          -100},{34,-100},{34,-40},{126,-40}},color={255,127,0}));

  connect(reaToInt1.y, chaPumSta3.uNexLagPum) annotation (Line(points={{-18,-50},
          {30,-50},{30,-176},{128,-176}},color={255,127,0}));

  connect(reaToInt2.y, chaPumSta3.uLasLagPum) annotation (Line(points={{-18,
          -100},{34,-100},{34,-180},{128,-180}},color={255,127,0}));

  connect(lat.y, and1.u1) annotation (Line(points={{-178,-190},{-170,-190},{
          -170,-284},{-150,-284}}, color={255,0,255}));

  connect(lat.y, or2.u1) annotation (Line(points={{-178,-190},{-170,-190},{-170,
          -302},{-112,-302}}, color={255,0,255}));

  connect(not2.y, or2.u2) annotation (Line(points={{-126,-320},{-118,-320},{
          -118,-310},{-112,-310}}, color={255,0,255}));

  connect(uNexEnaBoi, chaPumSta4.uNexLagPum) annotation (Line(points={{-300,
          -300},{-188,-300},{-188,-334},{26,-334},{26,-308},{60,-308}}, color={
          255,127,0}));

  connect(uLasDisBoi, chaPumSta4.uLasLagPum) annotation (Line(points={{-300,
          -340},{32,-340},{32,-312},{60,-312}}, color={255,127,0}));

  connect(chaPumSta.yHotWatPum, chaPumSta4.uHotWatPum) annotation (Line(points=
          {{80,110},{104,110},{104,-266},{52,-266},{52,-304},{60,-304}}, color=
          {255,0,255}));

  connect(chaPumSta1.yHotWatPum, chaPumSta2.uHotWatPum) annotation (Line(points={{80,76},
          {100,76},{100,-32},{126,-32}},                          color={255,0,
          255}));
  connect(chaPumSta1.yHotWatPum, chaPumSta3.uHotWatPum) annotation (Line(points={{80,76},
          {100,76},{100,-172},{128,-172}},                            color={
          255,0,255}));

  connect(greThr.u, extIndSig.y)
    annotation (Line(points={{-194,-70},{-200,-70}}, color={0,0,127}));
  connect(greThr.y, enaDedLeaPum.uLeaBoiSta) annotation (Line(points={{-170,-70},
          {-166,-70},{-166,-42},{-218,-42},{-218,105},{-202,105}}, color={255,0,
          255}));
  connect(and1.y, and2.u1)
    annotation (Line(points={{-126,-284},{-48,-284}}, color={255,0,255}));
  connect(or2.y, or3.u1) annotation (Line(points={{-88,-302},{-70,-302},{-70,-318},
          {-50,-318}},color={255,0,255}));
  connect(and2.y, chaPumSta4.uNexLagPumSta) annotation (Line(points={{-24,-284},
          {-20,-284},{-20,-296},{60,-296}}, color={255,0,255}));
  connect(or3.y, chaPumSta4.uLasLagPumSta) annotation (Line(points={{-26,-318},{
          48,-318},{48,-299},{60,-299}}, color={255,0,255}));
  connect(intGreEquThr1.y, and3.u1)
    annotation (Line(points={{-8,32},{68,32}}, color={255,0,255}));
  connect(enaLagHotPum.yUp, and3.u2) annotation (Line(points={{-178,4},{2,4},{2,
          24},{68,24}}, color={255,0,255}));
  connect(or4.y, chaPumSta2.uLasLagPumSta) annotation (Line(points={{94,-10},{
          108,-10},{108,-27},{126,-27}}, color={255,0,255}));
  connect(and3.y, chaPumSta2.uNexLagPumSta) annotation (Line(points={{92,32},{
          112,32},{112,-24},{126,-24}}, color={255,0,255}));
  connect(intLesEquThr1.y, or4.u1)
    annotation (Line(points={{40,-10},{70,-10}}, color={255,0,255}));
  connect(enaLagHotPum.yDown, or4.u2) annotation (Line(points={{-178,-4},{2,-4},
          {2,-28},{66,-28},{66,-18},{70,-18}}, color={255,0,255}));
  connect(and4.y, and3.u2) annotation (Line(points={{22,-190},{50,-190},{50,24},
          {68,24}}, color={255,0,255}));
  connect(not1.y, or4.u2) annotation (Line(points={{72,-240},{76,-240},{76,-212},
          {54,-212},{54,-28},{66,-28},{66,-18},{70,-18}}, color={255,0,255}));
  connect(or4.y, chaPumSta3.uLasLagPumSta) annotation (Line(points={{94,-10},{
          108,-10},{108,-167},{128,-167}}, color={255,0,255}));
  connect(and3.y, chaPumSta3.uNexLagPumSta) annotation (Line(points={{92,32},{
          112,32},{112,-164},{128,-164}}, color={255,0,255}));
  connect(mulSumInt.y, intGreEquThr1.u) annotation (Line(points={{-178,-120},{
          -48,-120},{-48,32},{-32,32}}, color={255,127,0}));
  connect(mulSumInt.y, intLesEquThr1.u) annotation (Line(points={{-178,-120},{8,
          -120},{8,-10},{16,-10}}, color={255,127,0}));
  connect(con.y, max.u1) annotation (Line(points={{62,-456},{82,-456},{82,-540},
          {132,-540}}, color={0,0,127}));
  connect(uPlaEna, not3.u) annotation (Line(points={{-300,110},{-240,110},{-240,
          40},{-202,40}}, color={255,0,255}));
  connect(not3.y, truDel.u)
    annotation (Line(points={{-178,40},{-122,40}}, color={255,0,255}));
  connect(truDel.y, booRep.u) annotation (Line(points={{-98,40},{-48,40},{-48,54},
          {122,54},{122,40},{140,40}}, color={255,0,255}));
  connect(chaPumSta2.yHotWatPum, logSwi.u3) annotation (Line(points={{150,-32},{
          166,-32},{166,-40},{180,-40}}, color={255,0,255}));
  connect(booRep.y, logSwi.u2) annotation (Line(points={{164,40},{174,40},{174,-32},
          {180,-32}}, color={255,0,255}));
  connect(con1.y, logSwi.u1) annotation (Line(points={{150,10},{166,10},{166,-24},
          {180,-24}}, color={255,0,255}));
  connect(logSwi.y, yHotWatPum) annotation (Line(points={{204,-32},{248,-32},{248,
          0},{300,0}}, color={255,0,255}));
  connect(chaPumSta3.yHotWatPum, logSwi.u3) annotation (Line(points={{152,-172},
          {166,-172},{166,-40},{180,-40}}, color={255,0,255}));
  connect(chaPumSta4.yHotWatPum, logSwi.u3) annotation (Line(points={{84,-304},{
          166,-304},{166,-40},{180,-40}}, color={255,0,255}));
  connect(uNexEnaBoi, chaPumSta.uNexLagPum) annotation (Line(points={{-300,-300},
          {-278,-300},{-278,98},{22,98},{22,106},{56,106}}, color={255,127,0}));
  connect(uLasDisBoi, chaPumSta.uLasLagPum) annotation (Line(points={{-300,-340},
          {-264,-340},{-264,96},{28,96},{28,102},{56,102}}, color={255,127,0}));
  connect(uHotWatPum, pumSpeLocDp.uHotWatPum) annotation (Line(points={{-300,140},
          {-260,140},{-260,-476},{-62,-476}}, color={255,0,255}));
  connect(uHotWatPum, pumSpeRemDp.uHotWatPum) annotation (Line(points={{-300,140},
          {-260,140},{-260,-512},{-62,-512}}, color={255,0,255}));
  connect(uHotWatPum, pumSpeFlo.uHotWatPum) annotation (Line(points={{-300,140},
          {-260,140},{-260,-559},{-62,-559}}, color={255,0,255}));
  connect(uHotWatPum, pumSpeTem.uHotWatPum) annotation (Line(points={{-300,140},
          {-260,140},{-260,-590},{-62,-590}}, color={255,0,255}));
  connect(max.y, yPumSpe)
    annotation (Line(points={{156,-546},{300,-546}}, color={0,0,127}));
  connect(xor.y, not4.u)
    annotation (Line(points={{-158,-390},{-142,-390}}, color={255,0,255}));
  connect(not4.y, mulAnd.u[1:nPum]) annotation (Line(points={{-118,-390},{-110,-390},
          {-110,-390},{-102,-390}}, color={255,0,255}));
  connect(mulAnd.y, lat1.u)
    annotation (Line(points={{-78,-390},{-62,-390}}, color={255,0,255}));
  connect(pre1.y, xor.u1)
    annotation (Line(points={{-198,-390},{-182,-390}}, color={255,0,255}));
  connect(logSwi.y, pre1.u) annotation (Line(points={{204,-32},{248,-32},{248,-370},
          {-240,-370},{-240,-390},{-222,-390}}, color={255,0,255}));
  connect(uHotWatPum, xor.u2) annotation (Line(points={{-300,140},{-260,140},{-260,
          -360},{-190,-360},{-190,-398},{-182,-398}}, color={255,0,255}));
  connect(uPumChaPro, lat1.clr) annotation (Line(points={{-300,-250},{-274,-250},
          {-274,-410},{-70,-410},{-70,-396},{-62,-396}}, color={255,0,255}));
  connect(lat1.y, not5.u)
    annotation (Line(points={{-38,-390},{-22,-390}}, color={255,0,255}));
  connect(intGreEquThr1.y, and2.u2) annotation (Line(points={{-8,32},{58,32},{58,
          -206},{82,-206},{82,-260},{-58,-260},{-58,-292},{-48,-292}}, color={255,
          0,255}));
  connect(intLesEquThr1.y, or3.u2) annotation (Line(points={{40,-10},{62,-10},{62,
          -200},{88,-200},{88,-342},{-64,-342},{-64,-326},{-50,-326}}, color={255,
          0,255}));
  connect(lat1.y, lat.clr) annotation (Line(points={{-38,-390},{-34,-390},{-34,
          -366},{-176,-366},{-176,-206},{-216,-206},{-216,-196},{-202,-196}},
        color={255,0,255}));
  connect(not5.y, not2.u) annotation (Line(points={{2,-390},{20,-390},{20,-360},
          {-160,-360},{-160,-320},{-150,-320}}, color={255,0,255}));
  connect(not5.y, and1.u2) annotation (Line(points={{2,-390},{20,-390},{20,-360},
          {-160,-360},{-160,-292},{-150,-292}}, color={255,0,255}));
  connect(not5.y, and4.u2) annotation (Line(points={{2,-390},{20,-390},{20,-360},
          {-160,-360},{-160,-266},{-10,-266},{-10,-198},{-2,-198}}, color={255,
          0,255}));
  connect(not5.y, and5.u2) annotation (Line(points={{2,-390},{20,-390},{20,-360},
          {-160,-360},{-160,-266},{-10,-266},{-10,-248},{-2,-248}}, color={255,
          0,255}));
annotation (defaultComponentName="priPumCon",
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-280,-720},{280,260}}),
  graphics={
    Rectangle(
      extent={{-276,256},{274,60}},
      fillColor={210,210,210},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None),
    Text(
      extent={{206,248},{270,232}},
      pattern=LinePattern.None,
      fillColor={210,210,210},
      fillPattern=FillPattern.Solid,
      textColor={0,0,127},
      horizontalAlignment=TextAlignment.Right,
      textString="Enable lead pump"),
    Rectangle(
      extent={{-276,56},{274,-136}},
      fillColor={210,210,210},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None),
    Text(
      extent={{192,52},{270,36}},
      pattern=LinePattern.None,
      fillColor={210,210,210},
      fillPattern=FillPattern.Solid,
      textColor={0,0,127},
      horizontalAlignment=TextAlignment.Right,
      textString="Enable next lag pump"),
    Text(
      extent={{188,-126},{266,-136}},
      pattern=LinePattern.None,
      fillColor={210,210,210},
      fillPattern=FillPattern.Solid,
      textColor={0,0,127},
      horizontalAlignment=TextAlignment.Right,
      textString="Disable last lag pump"),
    Rectangle(
      extent={{-278,-420},{272,-714}},
      fillColor={210,210,210},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None),
    Text(
      extent={{220,-422},{266,-434}},
      pattern=LinePattern.None,
      fillColor={210,210,210},
      fillPattern=FillPattern.Solid,
      textColor={0,0,127},
      horizontalAlignment=TextAlignment.Right,
      textString="Pump speed"),
    Rectangle(
      extent={{-276,-268},{274,-356}},
      fillColor={210,210,210},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None),
    Text(
      extent={{74,-272},{262,-286}},
      pattern=LinePattern.None,
      fillColor={210,210,210},
      fillPattern=FillPattern.Solid,
      textColor={0,0,127},
      horizontalAlignment=TextAlignment.Right,
      textString="Enable/Disable lag pumps for dedicated primary pumps"),
    Rectangle(
      extent={{-276,-140},{274,-264}},
      fillColor={210,210,210},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None),
    Text(
      extent={{178,-146},{264,-202}},
      pattern=LinePattern.None,
      fillColor={210,210,210},
      fillPattern=FillPattern.Solid,
      textColor={0,0,127},
      horizontalAlignment=TextAlignment.Left,
          textString="Enable/Disable lag pumps
for headered pumps in 
plants that are not 
primary-only")}),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-300},{100,300}}),
    graphics={
      Rectangle(
        extent={{-100,-300},{100,300}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-100,350},{100,310}},
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
        fillPattern=FillPattern.Solid)}),
Documentation(info="<html>
<p>
Primary hot water pump control sequence per ASHRAE RP-1711, March, 2020 draft, 
section 5.3.6. It consists of:
</p>
<ul>
<li>
Subsequences to enable lead pump, 
<ul>
<li>
for plants with dedicated pumps 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.EnableLead_dedicated\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.EnableLead_dedicated</a>.
</li>
<li>
for plants with headered pumps 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.EnableLead_headered\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.EnableLead_headered</a>.
</li>
</ul>
</li>
<li>
Subsequences to stage lag pumps
<ul>
<li>
for primary-only plants with headered, variable-speed pumps
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.EnableLag_flowrate\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.EnableLag_flowrate</a>.
</li>
<li>
for other plants with headered pumps.
</li>
<li>
for plants with dedicated pumps.
</li>
</ul>
<li>
Subsequences to control pump speed,
<ul>
<li>
for primary-only plants, where the remote DP sensor(s) is not hardwired to the plant
controller, but a local DP sensor is hardwired
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_localDp\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_localDp</a>.
</li>
<li>
for primary-only plants, where the remote DP sensor(s) is hardwired to the plant controller
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_remoteDp\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_remoteDp</a>.
</li>
<li>
for primary-secondary plants, with flowrate sensor(s) for speed regulation
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.Speed_flow\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.Speed_flow</a>.
</li>
<li>
for primary-secondary plants, with temperature sensors for speed regulation
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.Speed_temperature\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.Speed_temperature</a>.
</li>
</ul>
</li>
</ul>
<p>
The parameter values for valid pump configurations are as follows:
</p>
<br>
      <table summary=\"allowedConfigurations\" border=\"1\">
        <thead>
          <tr>
            <th>Parameters/Pump configurations</th>
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
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>have_priOnl</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>FALSE</td>
            <td>FALSE</td>
            <td>FALSE</td>
            <td>FALSE</td>
            <td>FALSE</td>
            <td>FALSE</td>
            <td>FALSE</td>
            <td>FALSE</td>
            <td>FALSE</td>
            <td>FALSE</td>
          </tr>
          <tr>
            <td>have_heaPriPum</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>FALSE</td>
            <td>FALSE</td>
            <td>FALSE</td>
            <td>FALSE</td>
            <td>FALSE</td>
          </tr>
          <tr>
            <td>have_varPriPum</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>FALSE</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>TRUE</td>
            <td>FALSE</td>
          </tr>
          <tr>
            <td>speConTyp</td>
            <td>remoteDP</td>
            <td>localDP</td>
            <td>flowrate</td>
            <td>flowrate</td>
            <td>temperature</td>
            <td>temperature</td>
            <td>NA</td>
            <td>flowrate</td>
            <td>flowrate</td>
            <td>temperature</td>
            <td>temperature</td>
            <td>NA</td>
          </tr>
          <tr>
            <td>use_priSecFloSen</td>
            <td>NA</td>
            <td>NA</td>
            <td>TRUE</td>
            <td>FALSE</td>
            <td>NA</td>
            <td>NA</td>
            <td>NA</td>
            <td>TRUE</td>
            <td>FALSE</td>
            <td>NA</td>
            <td>NA</td>
            <td>NA</td>
          </tr>
          <tr>
            <td>use_priTemSen</td>
            <td>NA</td>
            <td>NA</td>
            <td>NA</td>
            <td>NA</td>
            <td>TRUE</td>
            <td>FALSE</td>
            <td>NA</td>
            <td>NA</td>
<td>NA</td>
<td>TRUE</td>
<td>FALSE</td>
<td>NA</td>
</tr>
</tbody>
</table> 
</html>",
revisions="<html>
<ul>
<li>
August 11, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
