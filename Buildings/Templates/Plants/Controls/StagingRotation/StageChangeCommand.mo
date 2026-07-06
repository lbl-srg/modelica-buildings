within Buildings.Templates.Plants.Controls.StagingRotation;
block StageChangeCommand
  "Generate stage change command"
  parameter Buildings.Templates.Plants.Controls.Types.Application typ
    "Type of application"
    annotation(Evaluate=true);
  parameter Boolean have_php = false
    "Set to true for plants with polyvalent heat pumps"
    annotation(Evaluate=true);
  parameter Boolean have_pumSec
    "Set to true for primary-secondary distribution, false for primary-only"
    annotation(Evaluate=true);
  parameter Boolean have_inpPlrSta = false
    "Set to true to use an input signal for SPLR, false to use a parameter"
    annotation(Evaluate=true);
  parameter Real plrSta(max=1, min=0, start=0.9, unit="1") = 0.9
    "Staging part load ratio"
    annotation(Dialog(enable=not have_inpPlrSta));
  final parameter Real traStaEqu[nEqu, nSta] =
    {{staEqu[i, j] for i in 1:nSta} for j in 1:nEqu}
    "Transpose of staging matrix";
  parameter Real staEqu[:, :](
    each final max=1,
    each final min=0,
    each final unit="1")
    "Staging matrix – Equipment required for each stage";
  final parameter Integer nSta =
    if have_php
    then integer((1 + sqrt(1 + 4 * size(staEqu, 1))) / 2) - 1
    else size(staEqu, 1)
    "Number of stages"
    annotation(Evaluate=true);
  final parameter Integer nEqu = size(staEqu, 2)
    "Number of equipment"
    annotation(Evaluate=true);
  parameter Real capEqu[:](each final min=0, each final unit="W")
    "Design capacity of each equipment";
  parameter Real dtRun(min=0, unit="s") = 900
    "Runtime with exceeded staging part load ratio before staging event is triggered";
  parameter Real dtMea(min=0, unit="s") = 300
    "Duration used to compute the moving average of required capacity";
  parameter Real cp_default(min=0, unit="J/(kg.K)")
    "Default specific heat capacity used to compute required capacity";
  parameter Real rho_default(min=0, unit="kg/m3")
    "Default density used to compute required capacity";
  parameter Real dT(min=0, unit="K") "Delta-T triggering stage up command (>0)";
  parameter Real dtPri(min=0, unit="s") = 900
    "Runtime with high primary-setpoint Delta-T before staging up";
  parameter Real dtSec(min=0, start=600, unit="s") = 600
    "Runtime with high secondary-primary and secondary-setpoint Delta-T before staging up"
    annotation(Dialog(enable=have_pumSec));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaSta[nSta]
    "Stage available signal"
    annotation(Placement(transformation(extent={{-240,0},{-200,40}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1StaPro
    "Staging process in progress"
    annotation(Placement(transformation(extent={{-240,-40},{-200,0}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPlrSta(
    final unit="1",
    final min=0,
    final max=1)
    if have_inpPlrSta
    "Input signal for staging part load ratio"
    annotation(Placement(transformation(extent={{-240,-280},{-200,-240}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  // We allow the stage index to be zero, e.g., when the plant is disabled.
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta(
    final min=0,
    final max=nSta)
    "Stage index"
    annotation(Placement(transformation(extent={{-240,120},{-200,160}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    displayUnit="degC")
    "Return temperature used to compute required capacity"
    annotation(Placement(transformation(extent={{-240,-200},{-200,-160}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Active supply temperature setpoint used to compute required capacity"
    annotation(Placement(transformation(extent={{-240,-140},{-200,-100}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow(final unit="m3/s")
    "Volume flow rate used to compute required capacity"
    annotation(Placement(transformation(extent={{-240,-240},{-200,-200}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Up "Stage up command"
    annotation(Placement(transformation(extent={{200,40},{240,80}}),
      iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Dow
    "Stage down command"
    annotation(Placement(transformation(extent={{200,-140},{240,-100}}),
      iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaOpp(
    final min=0,
    final max=nSta) if have_php "Stage index of opposite mode"
    annotation(Placement(transformation(extent={{-240,200},{-200,240}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput staTra[nEqu, nSta](
    each final unit="1",
    each final min=0,
    each final max=1)
    if have_php
    "Transpose of staging matrix at given stage"
    annotation(Placement(transformation(extent={{200,200},{240,240}}),
      iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Lck if have_php and typ ==
    Buildings.Templates.Plants.Controls.Types.Application.Cooling
    "Lock stage up command" annotation (Placement(transformation(extent={{-240,300},
            {-200,340}}), iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Lck
    if have_php and typ ==
    Buildings.Templates.Plants.Controls.Types.Application.Heating
    "Lock stage up command of opposite mode" annotation (Placement(
        transformation(extent={{200,260},{240,300}}), iconTransformation(extent={{100,-80},
            {140,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant traMatStaEqu[nEqu, nSta](
    final k=traStaEqu)
    if not have_php
    "Transpose of staging matrix"
    annotation(Placement(transformation(extent={{-70,170},{-50,190}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquSta[nEqu](
    each final nin=nSta)
    "Extract equipment required at given stage"
    annotation(Placement(transformation(extent={{-10,170},{10,190}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=nEqu)
    "Replicate signal"
    annotation(Placement(transformation(extent={{-110,150},{-90,170}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply capEquSta[nEqu]
    "Capacity of each equipment required at given stage"
    annotation(Placement(transformation(extent={{30,170},{50,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant capEquPar[nEqu](
    final k=capEqu)
    "Capacity of each equipment"
    annotation(Placement(transformation(extent={{-180,190},{-160,210}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum capSta(nin=nEqu)
    "Compute nominal capacity of active stage"
    annotation(Placement(transformation(extent={{70,170},{90,190}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(h=1E-4 * min(capEqu))
    "Compare OPLR to SPLR (hysteresis is to avoid chattering with some simulators)"
    annotation(Placement(transformation(extent={{-90,-150},{-70,-130}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset timUp(
    final t=dtRun)
    "Timer"
    annotation(Placement(transformation(extent={{-50,-150},{-30,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Less les(h=1E-4 * min(capEqu))
    "Compare OPLR to SPLR (hysteresis is to avoid chattering with some simulators)"
    annotation(Placement(transformation(extent={{-90,-190},{-70,-170}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset timDow(
    final t=dtRun)
    "Timer"
    annotation(Placement(transformation(extent={{-50,-190},{-30,-170}})));
  Utilities.HoldReal hol(final dtHol=dtRun)
    "Hold value of required capacity at stage change"
    annotation(Placement(transformation(extent={{-130,-150},{-110,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Maximum between stage index and 1"
    annotation(Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(final k=1)
    "Constant"
    annotation(Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxSta[nSta](final k=1:
        nSta)
    "Stage index"
    annotation(Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Integers.Less idxStaLesAct[nSta]
    "Return true if stage index lower than active stage index"
    annotation(Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Logical.And idxStaLesActAva[nSta]
    "True if stage index lower than active stage index and stage available"
    annotation(Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep1(
    final nout=nSta)
    "Replicate signal"
    annotation(Placement(transformation(extent={{-180,50},{-160,70}})));
  Utilities.LastTrueIndex idxLasTru(nin=nSta)
    "Index of next available lower stage"
    annotation(Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt1
    "Maximum between stage index and 1"
    annotation(Placement(transformation(extent={{-30,50},{-10,70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep2(
    final nout=nEqu)
    "Replicate signal"
    annotation(Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquStaLow[nEqu](
    each final nin=nSta)
    "Extract equipment required at next available lower stage"
    annotation(Placement(transformation(extent={{-10,130},{10,150}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply capEquStaLow[nEqu]
    "Capacity of each equipment required at next available lower stage"
    annotation(Placement(transformation(extent={{30,130},{50,150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum capStaLow(nin=nEqu)
    "Compute nominal capacity of next available lower stage"
    annotation(Placement(transformation(extent={{70,130},{90,150}})));
  Buildings.Controls.OBC.CDL.Integers.Min minInt
    "Minimum between stage index and 1"
    annotation(Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert to real value"
    annotation(Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply setZer
    "Set nominal capacity to zero if no lower available stage"
    annotation(Placement(transformation(extent={{110,130},{130,150}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply splTimCapSta
    "SPLR times capacity of active stage"
    annotation(Placement(transformation(extent={{-130,-190},{-110,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply splTimCapStaLow
    "SPLR times capacity of next available lower stage"
    annotation(Placement(transformation(extent={{-130,-230},{-110,-210}})));
  Utilities.PlaceholderReal parPlrSta(
    final have_inp=have_inpPlrSta,
    final have_inpPh=false,
    final u_internal=plrSta)
    "Parameter value for SPLR"
    annotation(Placement(transformation(extent={{-190,-270},{-170,-250}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge endStaPro
    "True when staging process terminates"
    annotation(Placement(transformation(extent={{-130,-30},{-110,-10}})));
  LoadAverage capReq(
    final typ=typ,
    final cp_default=cp_default,
    final rho_default=rho_default,
    final dtMea=dtMea)
    "Compute required capacity"
    annotation(Placement(transformation(extent={{-170,-150},{-150,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPriSup(
    final unit="K",
    displayUnit="degC")
    "Primary supply temperature"
    annotation(Placement(transformation(extent={{-240,-80},{-200,-40}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSecSup(
    final unit="K",
    displayUnit="degC")
    if have_pumSec
    "Secondary supply temperature"
    annotation(Placement(transformation(extent={{-240,-100},{-200,-60}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  FailsafeCondition faiSaf(
    final typ=typ,
    final have_pumSec=have_pumSec,
    final dT=dT,
    final dtPri=dtPri,
    final dtSec=dtSec)
    "Failsafe stage up condition "
    annotation(Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Or effOrFaiSaf
    "Efficiency OR failsafe condition met"
    annotation(Placement(transformation(extent={{10,-110},{30,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not notFaiSaf
    "Failsafe stage up condition is not true"
    annotation(Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And effAndNotFaiSaf
    "Efficiency condition met AND failsafe stage up condition is not true"
    annotation(Placement(transformation(extent={{10,-190},{30,-170}})));
  PolyvalentHeatPumps.ExtractStagingMatrix extTra(
    final sta=staEqu,
    is_transpose=true)
    if have_php
    "Extract transpose of staging matrix for the opposite mode stage index"
    annotation(Placement(transformation(extent={{-70,210},{-50,230}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquStaNexHig[nEqu](each final
            nin=nSta) if have_php and typ == Buildings.Templates.Plants.Controls.Types.Application.Heating
    "Extract equipment required at next available higher stages"
    annotation (Placement(transformation(extent={{-10,270},{10,290}})));
  PolyvalentHeatPumps.ExtractStagingMatrix extTraOppNexHig(final sta=staEqu,
      is_transpose=true) if have_php and typ == Buildings.Templates.Plants.Controls.Types.Application.Heating
    "Extract transpose of staging matrix for the next available higher stage of opposite mode"
    annotation (Placement(transformation(extent={{-180,270},{-160,290}})));
  Buildings.Controls.OBC.CDL.Logical.And upAndCouEquStaNexHigZer
    if have_php
     and typ == Buildings.Templates.Plants.Controls.Types.Application.Heating
    "True if stage up command and equipment count at next available higher stages is zero"
    annotation (Placement(transformation(extent={{172,270},{192,290}})));
  Utilities.PlaceholderLogical phLckOpp(
    final have_inp=have_php and typ == Buildings.Templates.Plants.Controls.Types.Application.Cooling,
    final have_inpPh=false,
    final u_internal=false) "Placeholder value (no lock)"
    annotation (Placement(transformation(extent={{-180,310},{-160,330}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLck
    "True if stage up command is not locked"
    annotation (Placement(transformation(extent={{-140,310},{-120,330}})));
  Buildings.Controls.OBC.CDL.Logical.And upAndNotLck
    "True if stage up command and no active lock"
    annotation (Placement(transformation(extent={{172,50},{192,70}})));
  Buildings.Controls.OBC.CDL.Integers.Greater idxStaGreAct[nSta] if have_php
    "Return true if stage index greater than active stage index"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Logical.And idxStaGreActAva[nSta] if have_php
    "True if stage index greater than active stage index and stage available"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Utilities.FirstTrueIndex idxFirTru(nin=nSta) if have_php
    "Index of next available higher stage"
    annotation(Placement(transformation(extent={{-70,90},{-50,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaOppNexHig(final min=0,
      final max=nSta) if have_php and typ == Buildings.Templates.Plants.Controls.Types.Application.Heating
    "Next available higher stage index of opposite mode" annotation (Placement(
        transformation(extent={{-240,260},{-200,300}}), iconTransformation(
          extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxCurSta if have_php
    "Guard against first true index returning 0"
    annotation (Placement(transformation(extent={{-30,90},{-10,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yStaNexHig(final min=0,
      final max=nSta) if have_php "Next available higher stage index"
    annotation (Placement(transformation(extent={{200,80},{240,120}}),
        iconTransformation(extent={{100,38},{140,78}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep4(final
      nout=nEqu) if have_php and typ == Buildings.Templates.Plants.Controls.Types.Application.Heating
    "Replicate signal"
    annotation(Placement(transformation(extent={{50,230},{30,250}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum couEquStaNexHig(nin=nEqu) if
    have_php and typ == Buildings.Templates.Plants.Controls.Types.Application.Heating
    "Equipment count at next available higher stages"
    annotation (Placement(transformation(extent={{30,270},{50,290}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold couEquStaNexHigZer(
    t=1E-3)
    if
    have_php and typ == Buildings.Templates.Plants.Controls.Types.Application.Heating
    "True if equipment count at next available higher stages is zero"
    annotation (Placement(transformation(extent={{70,270},{90,290}})));
  // HACK(AntoineGautier): The 0 s hold block below solves an initialization
  // error with OCT 1.66 for Templates.Plants.HeatPumps.Validation.AirToWaterPolyvalent
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(final trueHoldDuration=0)
    if have_php and typ == Buildings.Templates.Plants.Controls.Types.Application.Heating
    "No-op hold to improve tool support"
    annotation (Placement(transformation(extent={{110,270},{130,290}})));
equation
  connect(intScaRep.y, reqEquSta.index)
    annotation(Line(points={{-88,160},{0,160},{0,168}},
      color={255,127,0}));
  connect(traMatStaEqu.y, reqEquSta.u)
    annotation(Line(points={{-48,180},{-12,180}},
      color={0,0,127}));
  connect(capEquSta.y, capSta.u)
    annotation(Line(points={{52,180},{68,180}},
      color={0,0,127}));
  connect(intScaRep.u, maxInt.y)
    annotation(Line(points={{-112,160},{-118,160}},
      color={255,127,0}));
  connect(idxSta.y, idxStaLesAct.u1)
    annotation(Line(points={{-158,100},{-148,100},{-148,60},{-142,60}},
      color={255,127,0}));
  connect(uSta, intScaRep1.u)
    annotation(Line(points={{-220,140},{-190,140},{-190,60},{-182,60}},
      color={255,127,0}));
  connect(intScaRep1.y, idxStaLesAct.u2)
    annotation(Line(points={{-158,60},{-154,60},{-154,52},{-142,52}},
      color={255,127,0}));
  connect(idxStaLesAct.y, idxStaLesActAva.u1)
    annotation(Line(points={{-118,60},{-106,60},{-106,20},{-102,20}},
      color={255,0,255}));
  connect(u1AvaSta, idxStaLesActAva.u2)
    annotation(Line(points={{-220,20},{-110,20},{-110,12},{-102,12}},
      color={255,0,255}));
  connect(idxStaLesActAva.y, idxLasTru.u1)
    annotation(Line(points={{-78,20},{-72,20}},
      color={255,0,255}));
  connect(idxLasTru.y, maxInt1.u2)
    annotation(Line(points={{-48,20},{-44,20},{-44,54},{-32,54}},
      color={255,127,0}));
  connect(one.y, maxInt1.u1)
    annotation(Line(points={{-158,140},{-40,140},{-40,66},{-32,66}},
      color={255,127,0}));
  connect(maxInt1.y, intScaRep2.u)
    annotation(Line(points={{-8,60},{-2,60}},
      color={255,127,0}));
  connect(uSta, maxInt.u1)
    annotation(Line(points={{-220,140},{-190,140},{-190,166},{-142,166}},
      color={255,127,0}));
  connect(one.y, maxInt.u2)
    annotation(Line(points={{-158,140},{-150,140},{-150,154},{-142,154}},
      color={255,127,0}));
  connect(intScaRep2.y, reqEquStaLow.index)
    annotation(Line(points={{22,60},{30,60},{30,120},{0,120},{0,128}},
      color={255,127,0}));
  connect(traMatStaEqu.y, reqEquStaLow.u)
    annotation(Line(points={{-48,180},{-20,180},{-20,140},{-12,140}},
      color={0,0,127}));
  connect(reqEquStaLow.y, capEquStaLow.u2)
    annotation(Line(points={{12,140},{16,140},{16,134},{28,134}},
      color={0,0,127}));
  connect(capEquStaLow.y, capStaLow.u)
    annotation(Line(points={{52,140},{68,140}},
      color={0,0,127}));
  connect(idxLasTru.y, minInt.u2)
    annotation(Line(points={{-48,20},{-44,20},{-44,14},{-32,14}},
      color={255,127,0}));
  connect(one.y, minInt.u1)
    annotation(Line(points={{-158,140},{-40,140},{-40,26},{-32,26}},
      color={255,127,0}));
  connect(minInt.y, intToRea.u)
    annotation(Line(points={{-8,20},{-2,20}},
      color={255,127,0}));
  connect(capStaLow.y, setZer.u1)
    annotation(Line(points={{92,140},{100,140},{100,146},{108,146}},
      color={0,0,127}));
  connect(intToRea.y, setZer.u2)
    annotation(Line(points={{22,20},{100,20},{100,134},{108,134}},
      color={0,0,127}));
  connect(hol.y, gre.u1)
    annotation(Line(points={{-108,-140},{-92,-140}},
      color={0,0,127}));
  connect(splTimCapSta.y, gre.u2)
    annotation(Line(points={{-108,-180},{-106,-180},{-106,-148},{-92,-148}},
      color={0,0,127}));
  connect(capSta.y, splTimCapSta.u2)
    annotation(Line(
      points={{92,180},{136,180},{136,-200},{-136,-200},{-136,-186},{-132,-186}},
      color={0,0,127}));
  connect(setZer.y, splTimCapStaLow.u2)
    annotation(Line(
      points={{132,140},{140,140},{140,-240},{-136,-240},{-136,-226},{-132,-226}},
      color={0,0,127}));
  connect(splTimCapStaLow.y, les.u2)
    annotation(Line(points={{-108,-220},{-100,-220},{-100,-188},{-92,-188}},
      color={0,0,127}));
  connect(hol.y, les.u1)
    annotation(Line(points={{-108,-140},{-100,-140},{-100,-180},{-92,-180}},
      color={0,0,127}));
  connect(gre.y, timUp.u)
    annotation(Line(points={{-68,-140},{-52,-140}},
      color={255,0,255}));
  connect(les.y, timDow.u)
    annotation(Line(points={{-68,-180},{-52,-180}},
      color={255,0,255}));
  connect(uPlrSta, parPlrSta.u)
    annotation(Line(points={{-220,-260},{-192,-260}},
      color={0,0,127}));
  connect(parPlrSta.y, splTimCapSta.u1)
    annotation(Line(points={{-168,-260},{-140,-260},{-140,-174},{-132,-174}},
      color={0,0,127}));
  connect(parPlrSta.y, splTimCapStaLow.u1)
    annotation(Line(points={{-168,-260},{-140,-260},{-140,-214},{-132,-214}},
      color={0,0,127}));
  connect(u1StaPro, hol.u1)
    annotation(Line(points={{-220,-20},{-140,-20},{-140,-140},{-132,-140}},
      color={255,0,255}));
  connect(endStaPro.y, timUp.reset)
    annotation(Line(points={{-108,-20},{-60,-20},{-60,-148},{-52,-148}},
      color={255,0,255}));
  connect(endStaPro.y, timDow.reset)
    annotation(Line(points={{-108,-20},{-60,-20},{-60,-188},{-52,-188}},
      color={255,0,255}));
  connect(TSupSet, capReq.TSupSet)
    annotation(Line(points={{-220,-120},{-180,-120},{-180,-134},{-172,-134}},
      color={0,0,127}));
  connect(TRet, capReq.TRet)
    annotation(Line(points={{-220,-180},{-192,-180},{-192,-140},{-172,-140}},
      color={0,0,127}));
  connect(V_flow, capReq.V_flow)
    annotation(Line(points={{-220,-220},{-180,-220},{-180,-146},{-172,-146}},
      color={0,0,127}));
  connect(capReq.QReq_flow, hol.u)
    annotation(Line(points={{-148,-140},{-144,-140},{-144,-146},{-132,-146}},
      color={0,0,127}));
  connect(u1StaPro, endStaPro.u)
    annotation(Line(points={{-220,-20},{-132,-20}},
      color={255,0,255}));
  connect(TPriSup, faiSaf.TPriSup)
    annotation(Line(points={{-220,-60},{-92,-60}},
      color={0,0,127}));
  connect(endStaPro.y, faiSaf.reset)
    annotation(Line(points={{-108,-20},{-100,-20},{-100,-52},{-92,-52}},
      color={255,0,255}));
  connect(TSecSup, faiSaf.TSecSup)
    annotation(Line(points={{-220,-80},{-100,-80},{-100,-64},{-92,-64}},
      color={0,0,127}));
  connect(TSupSet, faiSaf.TSupSet)
    annotation(Line(points={{-220,-120},{-180,-120},{-180,-56},{-92,-56}},
      color={0,0,127}));
  connect(faiSaf.y1, effOrFaiSaf.u1)
    annotation(Line(points={{-68,-60},{0,-60},{0,-100},{8,-100}},
      color={255,0,255}));
  connect(timUp.passed, effOrFaiSaf.u2)
    annotation(Line(points={{-28,-148},{0,-148},{0,-108},{8,-108}},
      color={255,0,255}));
  connect(faiSaf.y1, notFaiSaf.u)
    annotation(Line(points={{-68,-60},{-56,-60},{-56,-80},{-52,-80}},
      color={255,0,255}));
  connect(timDow.passed, effAndNotFaiSaf.u2)
    annotation(Line(points={{-28,-188},{8,-188}},
      color={255,0,255}));
  connect(notFaiSaf.y, effAndNotFaiSaf.u1)
    annotation(Line(points={{-28,-80},{-20,-80},{-20,-180},{8,-180}},
      color={255,0,255}));
  connect(effAndNotFaiSaf.y, y1Dow)
    annotation(Line(points={{32,-180},{180,-180},{180,-120},{220,-120}},
      color={255,0,255}));
  connect(uStaOpp, extTra.u)
    annotation(Line(points={{-220,220},{-72,220}},
      color={255,127,0}));
  connect(extTra.y, reqEquSta.u)
    annotation(Line(points={{-48,220},{-20,220},{-20,180},{-12,180}},
      color={0,0,127}));
  connect(extTra.y, reqEquStaLow.u)
    annotation(Line(points={{-48,220},{-20,220},{-20,140},{-12,140}},
      color={0,0,127}));
  connect(extTra.y, staTra)
    annotation(Line(points={{-48,220},{220,220}},
      color={0,0,127}));
  connect(effOrFaiSaf.y, upAndCouEquStaNexHigZer.u2) annotation (Line(points={{32,
          -100},{160,-100},{160,272},{170,272}}, color={255,0,255}));
  connect(phLckOpp.u, u1Lck)
    annotation (Line(points={{-182,320},{-220,320}}, color={255,0,255}));
  connect(phLckOpp.y, notLck.u)
    annotation (Line(points={{-158,320},{-142,320}}, color={255,0,255}));
  connect(effOrFaiSaf.y, upAndNotLck.u2) annotation (Line(points={{32,-100},{160,
          -100},{160,52},{170,52}}, color={255,0,255}));
  connect(upAndNotLck.y, y1Up)
    annotation (Line(points={{194,60},{220,60}}, color={255,0,255}));
  connect(notLck.y, upAndNotLck.u1) annotation (Line(points={{-118,320},{150,320},
          {150,60},{170,60}}, color={255,0,255}));
  connect(idxSta.y, idxStaGreAct.u1)
    annotation (Line(points={{-158,100},{-142,100}}, color={255,127,0}));
  connect(intScaRep1.y, idxStaGreAct.u2) annotation (Line(points={{-158,60},{-154,
          60},{-154,92},{-142,92}}, color={255,127,0}));
  connect(reqEquSta.y, capEquSta.u2) annotation (Line(points={{12,180},{16,180},
          {16,174},{28,174}}, color={0,0,127}));
  connect(capEquPar.y, capEquSta.u1) annotation (Line(points={{-158,200},{20,200},
          {20,186},{28,186}}, color={0,0,127}));
  connect(capEquPar.y, capEquStaLow.u1) annotation (Line(points={{-158,200},{20,
          200},{20,146},{28,146}}, color={0,0,127}));
  connect(idxStaGreAct.y, idxStaGreActAva.u1)
    annotation (Line(points={{-118,100},{-102,100}}, color={255,0,255}));
  connect(u1AvaSta, idxStaGreActAva.u2) annotation (Line(points={{-220,20},{-110,
          20},{-110,92},{-102,92}}, color={255,0,255}));
  connect(idxStaGreActAva.y, idxFirTru.u1)
    annotation (Line(points={{-78,100},{-72,100}}, color={255,0,255}));
  connect(idxFirTru.y, maxCurSta.u2) annotation (Line(points={{-48,100},{-44,100},
          {-44,94},{-32,94}}, color={255,127,0}));
  connect(maxCurSta.y, yStaNexHig)
    annotation (Line(points={{-8,100},{220,100}}, color={255,127,0}));
  connect(extTraOppNexHig.y, reqEquStaNexHig.u)
    annotation (Line(points={{-158,280},{-12,280}}, color={0,0,127}));
  connect(intScaRep4.y, reqEquStaNexHig.index)
    annotation (Line(points={{28,240},{0,240},{0,268}}, color={255,127,0}));
  connect(reqEquStaNexHig.y, couEquStaNexHig.u)
    annotation (Line(points={{12,280},{28,280}}, color={0,0,127}));
  connect(couEquStaNexHig.y, couEquStaNexHigZer.u)
    annotation (Line(points={{52,280},{68,280}}, color={0,0,127}));
  connect(upAndCouEquStaNexHigZer.y, y1Lck)
    annotation (Line(points={{194,280},{220,280}}, color={255,0,255}));
  connect(uStaOppNexHig, extTraOppNexHig.u)
    annotation (Line(points={{-220,280},{-182,280}}, color={255,127,0}));
  connect(maxCurSta.y, intScaRep4.u) annotation (Line(points={{-8,100},{180,100},
          {180,240},{52,240}}, color={255,127,0}));
  connect(couEquStaNexHigZer.y, truFalHol.u)
    annotation (Line(points={{92,280},{108,280}}, color={255,0,255}));
  connect(truFalHol.y, upAndCouEquStaNexHigZer.u1)
    annotation (Line(points={{132,280},{170,280}}, color={255,0,255}));
  connect(one.y, maxCurSta.u1) annotation (Line(points={{-158,140},{-40,140},{
          -40,106},{-32,106}}, color={255,127,0}));
annotation(defaultComponentName="chaSta",
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-140},{100,140}},
        grid={2,2}),
    graphics={Rectangle(extent={{-100,140},{100,-140}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,190},{150,150}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-280},{200,340}})),
  Documentation(
    info="<html>
<p>
  The plant equipment is staged in part based on required capacity,
  <i>Qrequired</i>, relative to nominal capacity of a given stage,
  <i>Qstage</i>. This ratio is the operative part load ratio, <i>OPLR</i>.
</p>
<p>
  <i>OPLR = Qrequired / Qstage</i>
</p>
<p>
  If both primary and secondary return temperature and flow rate sensors are
  available, the sensors in the primary loop are used for calculating
  <i>Qrequired</i>. (This condition is implemented in
  <a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.AirToWater\">
    Buildings.Templates.Plants.Controls.HeatPumps.AirToWater</a>.)
</p>
<p>
  The required capacity is calculated based on return temperature, active
  supply temperature setpoint and measured flow through the associated circuit
  flow meter.
</p>
<p>
  The required capacity used in logic is a rolling average over a period of
  <code>dtMea</code> of instantaneous values sampled at minimum once every
  <i>30</i>&nbsp;s.
</p>
<p>
  When a stage up or stage down transition is initiated,
  <i>Qrequired</i> is held fixed at its last value until the longer of the
  successful completion of the stage change and the duration
  <code>dtRun</code>.
</p>
<p>
  The nominal capacity of a given stage, <i>Qstage</i>, is calculated as the
  sum of the design capacities of all units enabled in a given stage.
</p>
<p>
  Staging is executed per the conditions below subject to the following
  requirements.
</p>
<ul>
  <li>
    Each stage has a minimum runtime of <code>dtRun</code>. (This condition is
    implemented in
    <a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.StageIndex\">
      Buildings.Templates.Plants.Controls.Utilities.StageIndex</a>.)
  </li>
  <li>Timers are reset to zero at the completion of every stage change.</li>
  <li>
    Any unavailable stage is skipped during staging events, but staging
    conditionals in the current stage are evaluated as per usual.
  </li>
</ul>
<p>A stage up command is triggered if any of the following is true:</p>
<ul>
  <li>
    Availability condition: The equipment necessary to operate the current
    stage is unavailable. The availability condition is not subject to the
    minimum stage runtime requirement. (This condition is implemented in
    <a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.StageIndex\">
      Buildings.Templates.Plants.Controls.Utilities.StageIndex</a>.)
  </li>
  <li>
    Efficiency condition: Current stage <i>OPLR &gt; plrSta</i> for a duration
    of <code>dtRun</code>.
  </li>
  <li>
    Failsafe condition: see
    <a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.FailsafeCondition\">
      Buildings.Templates.Plants.Controls.StagingRotation.FailsafeCondition</a>.
  </li>
</ul>
<p>A stage down command is triggered if both of the following are true:</p>
<ul>
  <li>
    Next available lower stage <i>OPLR &lt; plrSta</i> for a duration of
    <code>dtRun</code>.
  </li>
  <li>The failsafe stage up condition is not true.</li>
</ul>
<h4>Details</h4>
<p>
  A staging matrix <code>staEqu</code> is required as a parameter. See the
  documentation of
  <a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable\">
    Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable</a> for
  the associated definition and requirements.
</p>
<p>
  An \"if\" condition is used to generate the stage up and down command as
  opposed to a \"when\" condition. This means that the command remains true as
  long as the condition is verified. This is necessary, for example, if no
  higher stage is available when a stage up command is triggered. Using a
  \"when\" condition &ndash; which is only valid at the point in time at which
  the condition becomes true &ndash; would prevent the plant from staging when
  a higher stage becomes available again. To avoid multiple consecutive stage
  changes, the block that receives the stage up and down command and computes
  the stage index must enforce a minimum stage runtime of <code>dtRun</code>.
</p>
<h5>Locking logic for polyvalent heat pump plants</h5>
<p>
  For plants with polyvalent heat pumps (<code>have_php=true</code>), a
  locking mechanism prevents a race condition in which heating and cooling
  simultaneously stage up to an infeasible stage combination.
  Such a combination is encoded as a zero equipment count in the staging
  matrix.
  This race condition is not captured by the stage availability logic in
  <a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.StageAvailability\">
    Buildings.Templates.Plants.Controls.StagingRotation.StageAvailability</a>:
  that block evaluates feasibility based on the current stage of the
  opposite mode, so it correctly clears infeasible stages in steady state,
  but cannot anticipate that the opposite mode will also stage up within
  the same event iteration.
</p>
<p>
  The heating-mode instance of this block evaluates the
  feasibility of the combined next step by looking up the equipment count
  for the pair (next available higher heating stage, next available higher
  cooling stage) in the staging matrix.
  If that count is zero &ndash; i.e., the combination is infeasible &ndash;
  the heating block asserts the lock output.
  This signal is connected to the cooling-mode instance which inhibits
  the stage-up command.
  Heating therefore stages up with priority, landing on a combination that is
  feasible with the current cooling stage.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    May 31, 2024, by Antoine Gautier:<br />
    Refactored using <code>LoadAverage</code> block and added failsafe
    condition.
  </li>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end StageChangeCommand;
