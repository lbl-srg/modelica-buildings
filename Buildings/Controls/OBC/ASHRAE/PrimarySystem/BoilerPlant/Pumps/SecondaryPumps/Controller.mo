within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps;
block Controller
    "Sequences to control hot water pumps in boiler plants"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType= Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Pump control parameters", group="PID parameters"));

  parameter Boolean have_varSecPum = false
    "True: Variable-speed secondary pumps;
    False: Fixed-speed secondary pumps"
    annotation (Dialog(group="Plant parameters"));

  parameter Boolean have_secFloSen = true
    "True: Flow sensor in secondary loop;
    False: No flow sensor in secondary loop"
    annotation (Dialog(group="Plant parameters",
      enable=have_varSecPum));

  parameter Integer nPum
    "Total number of secondary hot water pumps"
    annotation (Dialog(group="Plant parameters"));

  parameter Integer nPumPri
    "Total number of primary hot water pumps"
    annotation (Dialog(group="Plant parameters",
      enable=not have_varSecPum));

  parameter Integer nBoi
    "Total number of boilers"
    annotation (Dialog(group="Plant parameters"));

  parameter Integer nSen
    "Total number of remote differential pressure sensors"
    annotation (Dialog(group="Plant parameters"));

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
    annotation (Dialog(group="Pump parameters", enable=have_varSecPum));

  parameter Real maxPumSpe(
    final unit="1",
    displayUnit="1",
    final min=minPumSpe,
    final max=1) = 1
    "Maximum pump speed"
    annotation (Dialog(group="Pump parameters", enable=have_varSecPum));

  parameter Real VHotWat_flow_nominal(
    final min=1e-6,
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Total plant design hot water flow rate"
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
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and have_secFloSen));

  parameter Real delBoiDis(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0)=180
    "Time delay after boilers have been disabled before completing disabling process"
    annotation (Dialog(tab="Pump control parameters", group="Pump staging parameters"));

  parameter Real timPer(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 600
    "Delay time period for enabling and disabling lag pumps"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and have_secFloSen));

  parameter Real staCon(
    final unit="1",
    displayUnit="1") = -0.03
    "Constant used in the staging equation"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and have_secFloSen));

  parameter Real relFloHys(
    final unit="1",
    displayUnit="1") = 0.01
    "Constant value used in hysteresis for checking relative flow rate"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and have_secFloSen));

  parameter Real speLim(
    final unit="1",
    displayUnit="1") = 0.9
    "Speed limit with longer enable delay for enabling next lag pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and not have_secFloSen));

  parameter Real speLim1(
    final unit="1",
    displayUnit="1") = 0.99
    "Speed limit with shorter enable delay for enabling next lag pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and not have_secFloSen));

  parameter Real speLim2(
    final unit="1",
    displayUnit="1") = 0.4
    "Speed limit for disabling last lag pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and not have_secFloSen));

  parameter Real timPer1(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for enabling next lag pump at speed limit speLim"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and not have_secFloSen));

  parameter Real timPer2(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 60
    "Delay time period for enabling next lag pump at speed limit speLim1"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and not have_secFloSen));

  parameter Real timPer3(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 600
    "Delay time period for disabling last lag pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters",
      enable=have_varSecPum and not have_secFloSen));

  parameter Real k(
    final unit="1",
    displayUnit="1",
    final min=0) = 1
    "Gain of controller"
    annotation (Dialog(tab="Pump control parameters",
      group="PID parameters",
      enable=have_varSecPum));

  parameter Real Ti(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Pump control parameters",
      group="PID parameters",
      enable=have_varSecPum));

  parameter Real Td(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Pump control parameters",
      group="PID parameters",
      enable=have_varSecPum));

  parameter Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes
    speConTyp = Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.remoteDP
    "Speed regulation method"
    annotation (Dialog(group="Plant parameters", enable=have_varSecPum));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatPum[nPum]
    "Secondary pumps operating status"
    annotation (Placement(transformation(extent={{-320,120},{-280,160}}),
      iconTransformation(extent={{-140,120},{-100,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPlaEna
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-320,70},{-280,110}}),
      iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPriPumSta[nPumPri] if not have_varSecPum
    "Primary pumps operating status"
    annotation (Placement(transformation(extent={{-320,-176},{-280,-136}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uPumLeaLag[nPum]
    "Hot water pump lead-lag order"
    annotation (Placement(transformation(extent={{-320,210},{-280,250}}),
      iconTransformation(extent={{-140,162},{-100,202}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput supResReq
    "Hot water supply reset requests"
    annotation (Placement(transformation(extent={{-320,20},{-280,60}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxSecPumSpeCon(
    final unit="1",
    displayUnit="1") if have_varSecPum
    "Maximum allowed pump speed for non-condensing boilers"
    annotation (Placement(transformation(extent={{-320,-410},{-280,-370}}),
      iconTransformation(extent={{-140,-200},{-100,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWat_local(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") if have_varSecPum and locDPReg
    "Hot water differential static pressure from local sensor"
    annotation (Placement(transformation(extent={{-320,-310},{-280,-270}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWat_remote[nSen](
    final unit=fill("Pa", nSen),
    final quantity=fill("PressureDifference", nSen),
    displayUnit=fill("Pa", nSen)) if have_varSecPum and (locDPReg or remDPReg)
    "Hot water differential static pressure from remote sensor"
    annotation (Placement(transformation(extent={{-320,-350},{-280,-310}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHotWatSet(
    final unit="Pa",
    final quantity="PressureDifference",
    displayUnit="Pa") if have_varSecPum and (locDPReg or remDPReg)
    "Hot water differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-320,-380},{-280,-340}}),
      iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWat_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate") if have_varSecPum and have_secFloSen
    "Hot water flow"
    annotation (Placement(transformation(extent={{-320,-40},{-280,0}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHotWatPum[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{280,-20},{320,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumSpe(
    final min=0,
    final max=1,
    final unit="1",
    displayUnit="1") if have_varSecPum "Hot water pump speed"
    annotation (Placement(transformation(extent={{280,-420},{320,-380}}),
        iconTransformation(extent={{100,-120},{140,-80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.EnableLag_flowrate
    enaLagHotPum(
    final nPum=nPum,
    final nPum_nominal=nPum_nominal,
    final timPer=timPer,
    final staCon=staCon,
    final relFloHys=relFloHys,
    final VHotWat_flow_nominal=VHotWat_flow_nominal) if have_varSecPum and
    have_secFloSen
    "Enable lag pump for primary-only plants using differential pressure pump speed control"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_localDp
    pumSpeLocDp(
    controllerType=controllerType,
    final nSen=nSen,
    final nPum=nPum,
    final minLocDp=minLocDp,
    final maxLocDp=maxLocDp,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe,
    final k=k,
    final Ti=Ti,
    final Td=Td) if have_varSecPum and locDPReg
    "Hot water pump speed control with local DP sensor"
    annotation (Placement(transformation(extent={{-60,-340},{-40,-320}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLag_pumpSpeed
    enaLagSecPum(
    final speLim=speLim,
    final speLim1=speLim1,
    final speLim2=speLim2,
    final timPer=timPer1,
    final timPer1=timPer2,
    final timPer2=timPer3) if have_varSecPum and not have_secFloSen
    "Enable and disable secondary lag pumps in secondary loop with no flow sensor"
    annotation (Placement(transformation(extent={{-120,28},{-100,48}})));

protected
  parameter Boolean remDPReg = (speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.remoteDP)
    "Boolean flag for pump speed control with remote differential pressure";

  parameter Boolean locDPReg = (speConTyp == Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.localDP)
    "Boolean flag for pump speed control with local differential pressure";

  parameter Integer pumInd[nPum]={i for i in 1:nPum}
    "Pump index, {1,2,...,n}";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.ZeroIndexCorrection
    zerStaIndCor
    "Block to resolve zero index errors"
    annotation (Placement(transformation(extent={{-102,-84},{-82,-64}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.ZeroIndexCorrection
    zerStaIndCor1
    "Block to resolve zero index errors"
    annotation (Placement(transformation(extent={{-114,-134},{-94,-114}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(
    final samplePeriod=1) if have_varSecPum and not have_secFloSen
    "Unit delay for pump speed"
    annotation (Placement(transformation(extent={{-200,28},{-180,48}})));

  Buildings.Controls.OBC.CDL.Continuous.Min min if have_varSecPum
    "Ensure pump speed is below maximum speed for condensation control"
    annotation (Placement(transformation(extent={{160,-410},{180,-390}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLead
    enaHeaLeaPum "Enable lead pump of headered pumps"
    annotation (Placement(transformation(extent={{-200,76},{-180,96}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_remoteDp
    pumSpeRemDp(
    controllerType=controllerType,
    final nSen=nSen,
    final nPum=nPum,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe,
    final k=k,
    final Ti=Ti,
    final Td=Td) if have_varSecPum and remDPReg
    "Hot water pump speed control with remote DP sensor"
    annotation (Placement(transformation(extent={{-60,-380},{-40,-360}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-274,190},{-254,210}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nPum]
    "Convert integer to real number"
    annotation (Placement(transformation(extent={{-220,220},{-200,240}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor leaPum(
    final nin=nPum)
    "Lead pump index"
    annotation (Placement(transformation(extent={{-80,220},{-60,240}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-40,220},{-20,240}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexLagPum(
    final nin=nPum)
    "Next lag pump"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-8,-60},{12,-40}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor lasLagPum(
    final nin=nPum)
    "Last lag pump"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-8,-110},{12,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nPum]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-250,-130},{-230,-110}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nPum)
    "Sum of integer inputs"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt
    "Integer add"
    annotation (Placement(transformation(extent={{-132,-80},{-112,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nPumPri] if not have_varSecPum
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-250,-166},{-230,-146}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt1(
    final nin=nPumPri) if    not have_varSecPum
    "Sum of integer inputs"
    annotation (Placement(transformation(extent={{-200,-166},{-180,-146}})));

  Buildings.Controls.OBC.CDL.Integers.Greater intGre if not have_varSecPum
    "Check if more boilers than pumps are enabled"
    annotation (Placement(transformation(extent={{-60,-200},{-40,-180}})));

  Buildings.Controls.OBC.CDL.Integers.Less intLes if not have_varSecPum
    "Check if less boilers than pumps are enabled"
    annotation (Placement(transformation(extent={{-50,-250},{-30,-230}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 if not have_varSecPum
    "Logical not"
    annotation (Placement(transformation(extent={{2,-250},{22,-230}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.ChangeStatus
    chaPumSta1(final nPum=nPum)
    "Change lead pump status for headered primary pumps"
    annotation (Placement(transformation(extent={{58,68},{80,88}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.ChangeStatus
    chaPumSta2(final nPum=nPum) if have_varSecPum and have_secFloSen
    "Change lag pump status for headered primary pumps in a plant that is primary-only"
    annotation (Placement(transformation(extent={{60,-44},{82,-24}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.ChangeStatus
    chaPumSta3(final nPum=nPum) if not have_varSecPum
    "Change lag pump status for headered primary pumps in a plant that is not primary-only"
    annotation (Placement(transformation(extent={{62,-182},{84,-162}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.ChangeStatus
    chaPumSta4(final nPum=nPum) if have_varSecPum and not have_secFloSen
    "Change pump status of secondary lag pumps in secondary loop with no flow sensor"
    annotation (Placement(transformation(extent={{58,8},{80,28}})));

  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(
    final t=1)
    "Prevent status changer from disabling lead pump"
    annotation (Placement(transformation(extent={{-158,-228},{-138,-208}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2 if not have_varSecPum
    "Logical Or"
    annotation (Placement(transformation(extent={{34,-228},{54,-208}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 if not have_varSecPum
    "Logical And"
    annotation (Placement(transformation(extent={{0,-174},{20,-154}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(
    final t=1)
    "Prevent status changer from enabling lead pump"
    annotation (Placement(transformation(extent={{-112,-160},{-92,-140}})));

  Buildings.Controls.OBC.CDL.Logical.And and1 if have_varSecPum
    "Logical And"
    annotation (Placement(transformation(extent={{-30,32},{-10,52}})));

  Buildings.Controls.OBC.CDL.Logical.Or or3 if have_varSecPum
    "Logical Or"
    annotation (Placement(transformation(extent={{-20,-8},{0,12}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical Not"
    annotation (Placement(transformation(extent={{-200,108},{-180,128}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=delBoiDis)
    "Delay pump disable after boilers have been disabled"
    annotation (Placement(transformation(extent={{-120,108},{-100,128}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nPum)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-66,108},{-46,128}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nPum]
    "Logical switch"
    annotation (Placement(transformation(extent={{192,-10},{212,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nPum](
    final k=fill(false,nPum))
    "Boolean False signal"
    annotation (Placement(transformation(extent={{132,38},{152,58}})));

equation
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
    annotation (Line(points={{-62,-322},{-230,-322},{-230,-290},{-300,-290}},
      color={0,0,127}));

  connect(pumSpeLocDp.dpHotWat_remote,dpHotWat_remote)
    annotation (Line(points={{-62,-334},{-200,-334},{-200,-330},{-300,-330}},
      color={0,0,127}));

  connect(pumSpeLocDp.dpHotWatSet,dpHotWatSet)
    annotation (Line(points={{-62,-338},{-220,-338},{-220,-360},{-300,-360}},
      color={0,0,127}));

  connect(dpHotWat_remote,pumSpeRemDp.dpHotWat)
    annotation (Line(points={{-300,-330},{-200,-330},{-200,-370},{-62,-370}},
      color={0,0,127}));

  connect(dpHotWatSet,pumSpeRemDp.dpHotWatSet)
    annotation (Line(points={{-300,-360},{-220,-360},{-220,-378},{-62,-378}},
      color={0,0,127}));

  connect(uHotWatPum, booToInt.u)
    annotation (Line(points={{-300,140},{-260,140},{-260,-120},{-252,-120}},
      color={255,0,255}));

  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-228,-120},{-202,-120}}, color={255,127,0}));

  connect(mulSumInt.y, addInt.u2)
    annotation (Line(points={{-178,-120},{-166,-120},{-166,-76},{-134,-76}},
      color={255,127,0}));

  connect(conInt.y, addInt.u1)
    annotation (Line(points={{-252,200},{-140,200},{-140,-64},{-134,-64}},
      color={255,127,0}));

  connect(reaToInt.y, chaPumSta1.uNexLagPum) annotation (Line(points={{-18,230},
          {46,230},{46,74},{56,74}}, color={255,127,0}));

  connect(reaToInt.y, chaPumSta1.uLasLagPum) annotation (Line(points={{-18,230},
          {46,230},{46,70},{56,70}}, color={255,127,0}));

  connect(enaHeaLeaPum.yLea, chaPumSta1.uNexLagPumSta) annotation (Line(points={{-178,86},
          {56,86}},                            color={255,0,255}));

  connect(enaHeaLeaPum.yLea, chaPumSta1.uLasLagPumSta) annotation (Line(points={{-178,86},
          {36,86},{36,83},{56,83}},            color={255,0,255}));

  connect(uHotWatPum, chaPumSta1.uHotWatPum) annotation (Line(points={{-300,140},
          {26,140},{26,78},{56,78}}, color={255,0,255}));

  connect(chaPumSta1.yHotWatPum, chaPumSta2.uHotWatPum) annotation (Line(points={{80,78},
          {100,78},{100,-16},{46,-16},{46,-34},{58,-34}},         color={255,0,
          255}));

  connect(chaPumSta1.yHotWatPum, chaPumSta3.uHotWatPum) annotation (Line(points={{80,78},
          {100,78},{100,-154},{44,-154},{44,-172},{60,-172}},         color={
          255,0,255}));

  connect(uMaxSecPumSpeCon, min.u1)
    annotation (Line(points={{-300,-390},{-72,-390},{-72,-394},{158,-394}},
                                                      color={0,0,127}));

  connect(pumSpeLocDp.yHotWatPumSpe, min.u2) annotation (Line(points={{-38,-330},
          {146,-330},{146,-406},{158,-406}}, color={0,0,127}));

  connect(pumSpeRemDp.yHotWatPumSpe, min.u2) annotation (Line(points={{-38,-370},
          {146,-370},{146,-406},{158,-406}}, color={0,0,127}));

  connect(uPriPumSta, booToInt1.u) annotation (Line(points={{-300,-156},{-252,-156}},
                                    color={255,0,255}));

  connect(mulSumInt1.y, intGre.u1) annotation (Line(points={{-178,-156},{-124,-156},
          {-124,-190},{-62,-190}},      color={255,127,0}));

  connect(mulSumInt1.y, intLes.u1) annotation (Line(points={{-178,-156},{-124,-156},
          {-124,-240},{-52,-240}},      color={255,127,0}));

  connect(intLes.y, not1.u)
    annotation (Line(points={{-28,-240},{0,-240}},  color={255,0,255}));

  connect(supResReq, enaHeaLeaPum.supResReq) annotation (Line(points={{-300,40},
          {-220,40},{-220,82},{-202,82}}, color={255,127,0}));

  connect(min.y, uniDel.u) annotation (Line(points={{182,-400},{200,-400},{200,-418},
          {-210,-418},{-210,38},{-202,38}}, color={0,0,127}));

  connect(uniDel.y, enaLagSecPum.uPumSpe)
    annotation (Line(points={{-178,38},{-122,38}}, color={0,0,127}));

  connect(chaPumSta1.yHotWatPum, chaPumSta4.uHotWatPum) annotation (Line(points={{80,78},
          {100,78},{100,42},{50,42},{50,18},{56,18}},         color={255,0,255}));

  connect(uPlaEna, enaHeaLeaPum.uPlaEna)
    annotation (Line(points={{-300,90},{-202,90}}, color={255,0,255}));

  connect(reaToInt1.y, chaPumSta4.uNexLagPum) annotation (Line(points={{14,-50},
          {32,-50},{32,14},{56,14}}, color={255,127,0}));

  connect(reaToInt1.y, chaPumSta2.uNexLagPum) annotation (Line(points={{14,-50},
          {32,-50},{32,-38},{58,-38}}, color={255,127,0}));

  connect(reaToInt1.y, chaPumSta3.uNexLagPum) annotation (Line(points={{14,-50},
          {32,-50},{32,-176},{60,-176}}, color={255,127,0}));

  connect(reaToInt2.y, chaPumSta4.uLasLagPum) annotation (Line(points={{14,-100},
          {38,-100},{38,10},{56,10}}, color={255,127,0}));

  connect(reaToInt2.y, chaPumSta2.uLasLagPum) annotation (Line(points={{14,-100},
          {38,-100},{38,-42},{58,-42}}, color={255,127,0}));

  connect(reaToInt2.y, chaPumSta3.uLasLagPum) annotation (Line(points={{14,-100},
          {38,-100},{38,-180},{60,-180}}, color={255,127,0}));

  connect(intLesEquThr.y, or2.u1)
    annotation (Line(points={{-136,-218},{32,-218}}, color={255,0,255}));

  connect(not1.y, or2.u2) annotation (Line(points={{24,-240},{28,-240},{28,-226},
          {32,-226}}, color={255,0,255}));

  connect(or2.y, chaPumSta3.uLasLagPumSta) annotation (Line(points={{56,-218},{58,
          -218},{58,-167},{60,-167}}, color={255,0,255}));

  connect(mulSumInt.y, intLesEquThr.u) annotation (Line(points={{-178,-120},{-166,
          -120},{-166,-218},{-160,-218}}, color={255,127,0}));

  connect(mulSumInt.y, intGre.u2) annotation (Line(points={{-178,-120},{-166,-120},
          {-166,-198},{-62,-198}}, color={255,127,0}));

  connect(mulSumInt.y, intLes.u2) annotation (Line(points={{-178,-120},{-166,-120},
          {-166,-248},{-52,-248}}, color={255,127,0}));

  connect(and2.y, chaPumSta3.uNexLagPumSta)
    annotation (Line(points={{22,-164},{60,-164}}, color={255,0,255}));

  connect(intGre.y, and2.u2) annotation (Line(points={{-38,-190},{-10,-190},{-10,
          -172},{-2,-172}}, color={255,0,255}));

  connect(intGreEquThr.y, and2.u1)
    annotation (Line(points={{-90,-150},{-10,-150},{-10,-164},{-2,-164}},
                                                    color={255,0,255}));

  connect(mulSumInt.y, intGreEquThr.u) annotation (Line(points={{-178,-120},{-166,
          -120},{-166,-150},{-114,-150}},color={255,127,0}));

  connect(enaLagSecPum.yUp, and1.u1)
    annotation (Line(points={{-98,42},{-32,42}}, color={255,0,255}));
  connect(intGreEquThr.y, and1.u2) annotation (Line(points={{-90,-150},{-40,-150},
          {-40,34},{-32,34}}, color={255,0,255}));
  connect(enaLagHotPum.yUp, and1.u1) annotation (Line(points={{-178,4},{-70,4},{
          -70,42},{-32,42}}, color={255,0,255}));
  connect(intLesEquThr.y, or3.u2) annotation (Line(points={{-136,-218},{-28,-218},
          {-28,-6},{-22,-6}}, color={255,0,255}));
  connect(enaLagSecPum.yDown, or3.u1) annotation (Line(points={{-98,34},{-48,34},
          {-48,2},{-22,2}}, color={255,0,255}));
  connect(enaLagHotPum.yDown, or3.u1) annotation (Line(points={{-178,-4},{-48,-4},
          {-48,2},{-22,2}}, color={255,0,255}));
  connect(and1.y, chaPumSta4.uNexLagPumSta) annotation (Line(points={{-8,42},{28,
          42},{28,26},{56,26}}, color={255,0,255}));
  connect(or3.y, chaPumSta4.uLasLagPumSta) annotation (Line(points={{2,2},{20,2},
          {20,23},{56,23}}, color={255,0,255}));
  connect(and1.y, chaPumSta2.uNexLagPumSta) annotation (Line(points={{-8,42},{28,
          42},{28,-26},{58,-26}}, color={255,0,255}));
  connect(or3.y, chaPumSta2.uLasLagPumSta) annotation (Line(points={{2,2},{20,2},
          {20,-29},{58,-29}}, color={255,0,255}));

  connect(not3.y,truDel. u)
    annotation (Line(points={{-178,118},{-122,118}},
                                                   color={255,0,255}));
  connect(truDel.y,booRep. u) annotation (Line(points={{-98,118},{-68,118}},
                                       color={255,0,255}));
  connect(booRep.y,logSwi. u2) annotation (Line(points={{-44,118},{174,118},{174,
          0},{190,0}},color={255,0,255}));
  connect(con1.y,logSwi. u1) annotation (Line(points={{154,48},{166,48},{166,8},
          {190,8}},   color={255,0,255}));
  connect(uPlaEna, not3.u) annotation (Line(points={{-300,90},{-220,90},{-220,118},
          {-202,118}}, color={255,0,255}));
  connect(chaPumSta3.yHotWatPum, logSwi.u3) annotation (Line(points={{84,-172},{
          122,-172},{122,-174},{174,-174},{174,-8},{190,-8}}, color={255,0,255}));
  connect(chaPumSta2.yHotWatPum, logSwi.u3) annotation (Line(points={{82,-34},{174,
          -34},{174,-8},{190,-8}}, color={255,0,255}));
  connect(chaPumSta4.yHotWatPum, logSwi.u3) annotation (Line(points={{80,18},{158,
          18},{158,-8},{190,-8}}, color={255,0,255}));
  connect(logSwi.y, yHotWatPum)
    annotation (Line(points={{214,0},{300,0}}, color={255,0,255}));
  connect(logSwi.y, pumSpeLocDp.uHotWatPum) annotation (Line(points={{214,0},{274,
          0},{274,-264},{-74,-264},{-74,-326},{-62,-326}}, color={255,0,255}));
  connect(logSwi.y, pumSpeRemDp.uHotWatPum) annotation (Line(points={{214,0},{274,
          0},{274,-264},{-74,-264},{-74,-362},{-62,-362}}, color={255,0,255}));
  connect(booToInt1.y, mulSumInt1.u[1:2]) annotation (Line(points={{-228,-156},{
          -216,-156},{-216,-156},{-202,-156}},     color={255,127,0}));
  connect(min.y, yPumSpe)
    annotation (Line(points={{182,-400},{300,-400}}, color={0,0,127}));
  connect(addInt.y, zerStaIndCor.uInd)
    annotation (Line(points={{-110,-70},{-104,-70}}, color={255,127,0}));
  connect(zerStaIndCor.yIndMod, nexLagPum.index) annotation (Line(points={{-80,-70},
          {-70,-70},{-70,-62}}, color={255,127,0}));
  connect(zerStaIndCor.yCapMod, reaToInt1.u) annotation (Line(points={{-80,-78},
          {-46,-78},{-46,-50},{-10,-50}}, color={0,0,127}));
  connect(nexLagPum.y, zerStaIndCor.uCap) annotation (Line(points={{-58,-50},{-52,
          -50},{-52,-32},{-108,-32},{-108,-78},{-104,-78}}, color={0,0,127}));
  connect(mulSumInt.y, zerStaIndCor1.uInd)
    annotation (Line(points={{-178,-120},{-116,-120}}, color={255,127,0}));
  connect(zerStaIndCor1.yIndMod, lasLagPum.index) annotation (Line(points={{-92,
          -120},{-70,-120},{-70,-112}}, color={255,127,0}));
  connect(zerStaIndCor1.yCapMod, reaToInt2.u) annotation (Line(points={{-92,-128},
          {-44,-128},{-44,-100},{-10,-100}}, color={0,0,127}));
  connect(lasLagPum.y, zerStaIndCor1.uCap) annotation (Line(points={{-58,-100},{
          -50,-100},{-50,-86},{-122,-86},{-122,-128},{-116,-128}}, color={0,0,127}));
annotation (defaultComponentName="secPumCon",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-280,-440},{280,260}}),
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
          extent={{-278,-270},{274,-436}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{220,-272},{266,-284}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Pump speed"),
          Rectangle(
          extent={{-276,-140},{274,-266}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{76,-142},{264,-156}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable/Disable lag pumps for fixed-speed secondary pumps")}),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,200}}),
       graphics={
        Rectangle(
          extent={{-100,-200},{100,200}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,250},{100,210}},
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
Secondary hot water pump control sequence per ASHRAE RP-1711, March, 2020 draft, 
section 5.3.7. It consists of:
</p>
<ul>
<li>
Subsequence to enable lead pump, 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLead\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLead</a>.
</li>
<li>
Subsequences to stage lag pumps
<ul>
<li>
for variable-speed pumps with a flowrate sensor in the secondary loop
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLag_flowrate\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLag_flowrate</a>.
</li>
<li>
for variable-speed pumps without a flowrate sensor in the secondary loop
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLag_pumpSpeed\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLag_pumpSpeed</a>.
</li>
<li>
for fixed-speed pumps.
</li>
</ul>
<li>
Subsequences to control pump speed,
<ul>
<li>
where the remote DP sensor(s) is not hardwired to the plant controller, but a
local DP sensor is hardwired
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_localDp\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_localDp</a>.
</li>
<li>
where the remote DP sensor(s) is hardwired to the plant controller
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_remoteDp\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_remoteDp</a>.
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
        <th>Boolean Parameters/Plant configurations</th>
        <th>1</th>
        <th>2</th>
        <th>3</th>
        <th>4</th>
        <th>5</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>have_varSecPum</td>
        <td>TRUE</td>
        <td>TRUE</td>
        <td>TRUE</td>
        <td>TRUE</td>
        <td>FALSE</td>
      </tr>
      <tr>
        <td>have_secFloSen</td>
        <td>TRUE</td>
        <td>TRUE</td>
        <td>FALSE</td>
        <td>FALSE</td>
        <td>FALSE</td>
      </tr>
      <tr>
        <td>speConTyp</td>
        <td>localDP</td>
        <td>remoteDP</td>
        <td>localDP</td>
        <td>remoteDP</td>
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
