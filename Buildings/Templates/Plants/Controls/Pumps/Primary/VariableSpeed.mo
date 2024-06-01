within Buildings.Templates.Plants.Controls.Pumps.Primary;
block VariableSpeed
  "Variable speed primary pumps"
  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Boolean have_pumPriCtlDp
    "Set to true for primary variable speed pumps using ∆p pump speed control"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  final parameter Boolean have_pumHeaWatPri=have_heaWat
    "Set to true for plants with primary HW pumps"
    annotation (Evaluate=true);
  parameter Boolean have_pumChiWatPriDed(
    start=false)
    "Set to true for plants with separate dedicated primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_chiWat and not have_pumPriHdr));
  final parameter Boolean have_pumChiWatPri=have_chiWat and (have_pumPriHdr or have_pumChiWatPriDed)
    "Set to true for plants with separate primary CHW pumps"
    annotation (Evaluate=true);
  parameter Boolean have_pumPriHdr
    "Set to true for headered primary pumps, false for dedicated pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Integer nEqu(
    start=0)
    "Number of equipment"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_heaWat and have_chiWat));
  parameter Integer nPumHeaWatPri
    "Number of primary HW pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Integer nPumChiWatPri(
    start=if have_pumChiWatPri then nEqu else 0)
    "Number of primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_pumChiWatPri));
  parameter Real yPumHeaWatPriSet(
    max=2,
    min=0,
    start=1,
    unit="1")
    "Primary pump speed providing design heat pump flow in heating mode"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and not have_pumPriCtlDp));
  parameter Real yPumChiWatPriSet(
    max=2,
    min=0,
    start=1,
    unit="1")
    "Primary pump speed providing design heat pump flow in cooling mode"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_chiWat and not have_pumPriCtlDp));
  parameter Boolean have_senDpHeaWatRemWir(
    start=false)
    "Set to true for remote HW differential pressure sensor(s) hardwired to controller"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_heaWat and have_pumPriCtlDp));
  parameter Integer nSenDpHeaWatRem(
    start=0)
    "Number of remote HW differential pressure sensors used for pump speed control"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_heaWat and have_pumPriCtlDp));
  parameter Real yPumHeaWatPri_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")=0.1
    "Minimum primary HW pump speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and have_pumPriCtlDp));
  parameter Real kCtlDpHeaWat(
    min=100 * Buildings.Controls.OBC.CDL.Constants.eps,
    start=1)=1
    "Gain of controller for HW loop ∆p control"
    annotation (Dialog(group="Control gains",
      enable=have_heaWat and have_pumPriCtlDp));
  parameter Real TiCtlDpHeaWat(
    min=100 * Buildings.Controls.OBC.CDL.Constants.eps,
    start=60,
    unit="s")=60
    "Time constant of integrator block for HW loop ∆p control"
    annotation (Dialog(group="Control gains",
      enable=have_heaWat and have_pumPriCtlDp));
  parameter Boolean have_senDpChiWatRemWir(
    start=false)
    "Set to true for remote CHW differential pressure sensor(s) hardwired to controller"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_chiWat and have_pumPriCtlDp));
  parameter Integer nSenDpChiWatRem(
    start=0)
    "Number of remote CHW differential pressure sensors used for pump speed control"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_chiWat and have_pumPriCtlDp));
  parameter Real yPumChiWatPri_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")=0.1
    "Minimum primary CHW pump speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_pumChiWatPri and have_pumPriCtlDp));
  parameter Real kCtlDpChiWat(
    min=100 * Buildings.Controls.OBC.CDL.Constants.eps,
    start=1)=1
    "Gain of controller for CHW loop ∆p control"
    annotation (Dialog(group="Control gains",
      enable=have_chiWat and have_pumPriCtlDp));
  parameter Real TiCtlDpChiWat(
    min=100 * Buildings.Controls.OBC.CDL.Constants.eps,
    start=60,
    unit="s")=60
    "Time constant of integrator block for CHW loop ∆p control"
    annotation (Dialog(group="Control gains",
      enable=have_chiWat and have_pumPriCtlDp));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri[nPumHeaWatPri]
    if have_pumHeaWatPri
    "Primary HW pump start command"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriHdr
    if have_pumHeaWatPri and have_pumPriHdr
    "Headered primary HW pump speed command"
    annotation (Placement(transformation(extent={{160,80},{200,120}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri[nPumChiWatPri]
    if have_pumChiWatPri
    "Primary CHW pump start command"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriHdr
    if have_pumChiWatPri and have_pumPriHdr
    "Headered primary CHW pump speed command"
    annotation (Placement(transformation(extent={{160,40},{200,80}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriDed[nPumHeaWatPri]
    if have_pumHeaWatPri and not have_pumPriHdr
    "Dedicated primary HW pump speed command"
    annotation (Placement(transformation(extent={{160,-120},{200,-80}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriDed[nPumChiWatPri]
    if have_pumChiWatPri and not have_pumPriHdr
    "Dedicated primary CHW pump speed command"
    annotation (Placement(transformation(extent={{160,-200},{200,-160}}),
      iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea[nEqu]
    if have_heaWat and have_chiWat and not have_pumChiWatPri
    "Heating/cooling mode command"
    annotation (Placement(transformation(extent={{-200,-180},{-160,-140}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumChiWatPriDed[nPumChiWatPri]
    if have_pumChiWatPri and not have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation (Placement(transformation(extent={{130,-190},{150,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Constant"
    annotation (Placement(transformation(extent={{-130,-210},{-110,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumHeaWatPriDed[nPumHeaWatPri]
    if have_pumHeaWatPri and not have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation (Placement(transformation(extent={{130,-110},{150,-90}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(
    nout=nPumHeaWatPri)
    if have_pumHeaWatPri
    "Replicate signal"
    annotation (Placement(transformation(extent={{92,-150},{112,-130}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep1(
    nout=nPumChiWatPri)
    if have_pumChiWatPri
    "Replicate signal"
    annotation (Placement(transformation(extent={{10,-170},{30,-150}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep2(
    nout=nPumChiWatPri)
    if have_pumChiWatPri
    "Replicate signal"
    annotation (Placement(transformation(extent={{10,-210},{30,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumChiWatPriHdr
    if have_pumChiWatPri and have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation (Placement(transformation(extent={{130,50},{150,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumHeaWatPriHdr
    if have_pumHeaWatPri and have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation (Placement(transformation(extent={{130,90},{150,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumChiWatPri(
    nin=nPumChiWatPri)
    if have_pumChiWatPri
    "Return true if any pump is enabled"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumHeaWatPri(
    nin=nPumHeaWatPri)
    if have_pumHeaWatPri
    "Return true if any pump is enabled"
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch selSpeHea[nPumHeaWatPri]
    if have_heaWat and have_chiWat and not have_pumChiWatPri and not have_pumPriHdr
    "Select prescribed pump speed depending on heating/cooling mode – Case with common CHW and HW dedicated pumps"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep3(
    nout=nPumHeaWatPri)
    if have_pumHeaWatPri
    "Replicate signal"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep4(
    nout=nPumHeaWatPri)
    if have_heaWat and have_chiWat and not have_pumChiWatPri and not have_pumPriHdr
    "Replicate signal"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  Utilities.PlaceholderReal ph[nPumHeaWatPri](
    each final have_inp=have_heaWat and have_chiWat and not have_pumChiWatPri
      and not have_pumPriHdr,
    each final have_inpPh=true)
    if have_pumHeaWatPri and not have_pumPriHdr
    "Always use HW pump speed in case of separate dedicated CHW pumps "
    annotation (Placement(transformation(extent={{92,-90},{112,-70}})));
  Generic.ControlDifferentialPressure ctlDpHeaWat(
    final have_senDpRemWir=have_senDpHeaWatRemWir,
    final k=kCtlDpHeaWat,
    final nPum=nPumHeaWatPri,
    final nSenDpRem=nSenDpHeaWatRem,
    final Ti=TiCtlDpHeaWat,
    final y_min=yPumHeaWatPri_min)
    if have_heaWat and have_pumPriCtlDp
    "HW loop ∆p control"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));
  Utilities.PlaceholderReal phSpePumHeaWatPri(
    final have_inp=have_pumPriCtlDp,
    final have_inpPh=false,
    final u_internal=yPumHeaWatPriSet)
    if have_heaWat
    "Replace with fixed speed"
    annotation (Placement(transformation(extent={{-30,190},{-10,210}})));
  Generic.ControlDifferentialPressure ctlDpChiWat(
    final have_senDpRemWir=have_senDpChiWatRemWir,
    final k=kCtlDpChiWat,
    final nPum=if have_pumChiWatPri then nPumChiWatPri else nPumHeaWatPri,
    final nSenDpRem=nSenDpChiWatRem,
    final Ti=TiCtlDpChiWat,
    final y_min=if have_pumChiWatPri then yPumChiWatPri_min else yPumHeaWatPri_min)
    if have_chiWat and have_pumPriCtlDp
    "CHW loop ∆p control"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Utilities.PlaceholderReal phSpePumChiWatPri(
    final have_inp=have_pumPriCtlDp,
    final have_inpPh=false,
    final u_internal=yPumChiWatPriSet)
    if have_chiWat
    "Replace with fixed speed"
    annotation (Placement(transformation(extent={{-30,150},{-10,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri_actual[nPumHeaWatPri]
    if have_pumHeaWatPri and have_pumPriCtlDp
    "Primary HW pump status"
    annotation (Placement(transformation(extent={{-200,180},{-160,220}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri_actual[nPumChiWatPri]
    if have_pumChiWatPri and have_pumPriCtlDp
    "Primary CHW pump status"
    annotation (Placement(transformation(extent={{-200,160},{-160,200}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not u1Coo[nEqu]
    if have_heaWat and have_chiWat and not have_pumChiWatPri
    "Return true if cooling mode command"
    annotation (Placement(transformation(extent={{-150,-150},{-130,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And u1CooAndOn[nPumHeaWatPri]
    if have_heaWat and have_chiWat and not have_pumChiWatPri and have_pumPriCtlDp
    "Return true if cooling mode command and pump proven on"
    annotation (Placement(transformation(extent={{-140,138},{-120,158}})));
  Utilities.PlaceholderLogical phPumChiWatPriSta[if have_pumChiWatPri then nPumChiWatPri
    else nPumHeaWatPri](
    each final have_inp=have_pumChiWatPri,
    each final have_inpPh=true)
    if have_chiWat and have_pumPriCtlDp
    "Replace with common dedicated pump signal"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatLoc(
    final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and not have_senDpChiWatRemWir
    "Local CHW differential pressure"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatLocSet[nSenDpChiWatRem](
    each final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and not have_senDpChiWatRemWir
    "Local CHW differential pressure setpoint output from each of the remote loops"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatRem[nSenDpChiWatRem](
    each final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and have_senDpChiWatRemWir
    "Remote CHW differential pressure"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatLoc(
    final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and not have_senDpHeaWatRemWir
    "Local HW differential pressure"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatLocSet[nSenDpHeaWatRem](
    each final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and not have_senDpHeaWatRemWir
    "Local HW differential pressure setpoint output from each of the remote loops"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatRem[nSenDpHeaWatRem](
    each final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and have_senDpHeaWatRemWir
    "Remote HW differential pressure"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatRemSet[nSenDpHeaWatRem](
    each final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and have_senDpHeaWatRemWir
    "Remote HW differential pressure setpoint"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatRemSet[nSenDpChiWatRem](
    each final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and have_senDpChiWatRemWir
    "Remote CHW differential pressure setpoint"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpHeaWatLocSetMax(
    final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and not have_senDpHeaWatRemWir
    "Maximum HW local differential pressure setpoint"
    annotation (Placement(transformation(extent={{160,180},{200,220}}),
      iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpChiWatLocSetMax(
    final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and not have_senDpChiWatRemWir
    "Maximum CHW local differential pressure setpoint"
    annotation (Placement(transformation(extent={{160,140},{200,180}}),
      iconTransformation(extent={{100,60},{140,100}})));
equation
  connect(u1PumChiWatPri, setPumChiWatPriDed.u2)
    annotation (Line(points={{-180,-80},{-58,-80},{-58,-180},{128,-180}},color={255,0,255}));
  connect(setPumChiWatPriDed.y, yPumChiWatPriDed)
    annotation (Line(points={{152,-180},{180,-180}},color={0,0,127}));
  connect(setPumHeaWatPriDed.y, yPumHeaWatPriDed)
    annotation (Line(points={{152,-100},{180,-100}},color={0,0,127}));
  connect(zer.y, rep.u)
    annotation (Line(points={{-108,-200},{-10,-200},{-10,-140},{90,-140}},color={0,0,127}));
  connect(zer.y, rep2.u)
    annotation (Line(points={{-108,-200},{8,-200}},color={0,0,127}));
  connect(setPumHeaWatPriHdr.y, yPumHeaWatPriHdr)
    annotation (Line(points={{152,100},{180,100}},color={0,0,127}));
  connect(setPumChiWatPriHdr.y, yPumChiWatPriHdr)
    annotation (Line(points={{152,60},{180,60}},color={0,0,127}));
  connect(rep2.y, setPumChiWatPriDed.u3)
    annotation (Line(points={{32,-200},{120,-200},{120,-188},{128,-188}},color={0,0,127}));
  connect(rep1.y, setPumChiWatPriDed.u1)
    annotation (Line(points={{32,-160},{120,-160},{120,-172},{128,-172}},color={0,0,127}));
  connect(zer.y, setPumChiWatPriHdr.u3)
    annotation (Line(points={{-108,-200},{-10,-200},{-10,52},{128,52}},color={0,0,127}));
  connect(rep.y, setPumHeaWatPriDed.u3)
    annotation (Line(points={{114,-140},{120,-140},{120,-108},{128,-108}},color={0,0,127}));
  connect(zer.y, setPumHeaWatPriHdr.u3)
    annotation (Line(points={{-108,-200},{-10,-200},{-10,92},{128,92}},color={0,0,127}));
  connect(u1PumChiWatPri, anyPumChiWatPri.u)
    annotation (Line(points={{-180,-80},{-58,-80},{-58,60},{-52,60}},color={255,0,255}));
  connect(u1PumHeaWatPri, anyPumHeaWatPri.u)
    annotation (Line(points={{-180,-60},{-60,-60},{-60,100},{-52,100}},color={255,0,255}));
  connect(anyPumHeaWatPri.y, setPumHeaWatPriHdr.u2)
    annotation (Line(points={{-28,100},{128,100}},color={255,0,255}));
  connect(anyPumChiWatPri.y, setPumChiWatPriHdr.u2)
    annotation (Line(points={{-28,60},{128,60}},color={255,0,255}));
  connect(u1PumHeaWatPri, setPumHeaWatPriDed.u2)
    annotation (Line(points={{-180,-60},{120,-60},{120,-100},{128,-100}},color={255,0,255}));
  connect(u1Hea, selSpeHea.u2)
    annotation (Line(points={{-180,-160},{-16,-160},{-16,-80},{48,-80}},color={255,0,255}));
  connect(rep3.y, selSpeHea.u1)
    annotation (Line(points={{32,-40},{40,-40},{40,-72},{48,-72}},color={0,0,127}));
  connect(rep4.y, selSpeHea.u3)
    annotation (Line(points={{32,-100},{40,-100},{40,-88},{48,-88}},color={0,0,127}));
  connect(ph.y, setPumHeaWatPriDed.u1)
    annotation (Line(points={{114,-80},{118,-80},{118,-92},{128,-92}},color={0,0,127}));
  connect(selSpeHea.y, ph.u)
    annotation (Line(points={{72,-80},{90,-80}},color={0,0,127}));
  connect(ctlDpHeaWat.y, phSpePumHeaWatPri.u)
    annotation (Line(points={{-38,200},{-32,200}},color={0,0,127}));
  connect(phSpePumHeaWatPri.y, setPumHeaWatPriHdr.u1)
    annotation (Line(points={{-8,200},{120,200},{120,108},{128,108}},color={0,0,127}));
  connect(phSpePumHeaWatPri.y, rep3.u)
    annotation (Line(points={{-8,200},{2,200},{2,-40},{8,-40}},color={0,0,127}));
  connect(ctlDpChiWat.y, phSpePumChiWatPri.u)
    annotation (Line(points={{-38,160},{-32,160}},color={0,0,127}));
  connect(phSpePumChiWatPri.y, setPumChiWatPriHdr.u1)
    annotation (Line(points={{-8,160},{110,160},{110,68},{128,68}},color={0,0,127}));
  connect(phSpePumChiWatPri.y, rep1.u)
    annotation (Line(points={{-8,160},{0,160},{0,-160},{8,-160}},color={0,0,127}));
  connect(u1PumHeaWatPri_actual, ctlDpHeaWat.y1_actual)
    annotation (Line(points={{-180,200},{-150,200},{-150,208},{-62,208}},color={255,0,255}));
  connect(u1Hea, u1Coo.u)
    annotation (Line(points={{-180,-160},{-155,-160},{-155,-140},{-152,-140}},
      color={255,0,255}));
  connect(u1Coo.y, u1CooAndOn.u2)
    annotation (Line(points={{-128,-140},{-120,-140},{-120,-120},{-150,-120},{-150,140},{-142,140}},
      color={255,0,255}));
  connect(u1PumHeaWatPri_actual, u1CooAndOn.u1)
    annotation (Line(points={{-180,200},{-150,200},{-150,148},{-142,148}},color={255,0,255}));
  connect(u1PumChiWatPri_actual, phPumChiWatPriSta.u)
    annotation (Line(points={{-180,180},{-142,180}},color={255,0,255}));
  connect(u1CooAndOn.y, phPumChiWatPriSta.uPh)
    annotation (Line(points={{-118,148},{-116,148},{-116,166},{-144,166},{-144,174},{-142,174}},
      color={255,0,255}));
  connect(phPumChiWatPriSta.y, ctlDpChiWat.y1_actual)
    annotation (Line(points={{-118,180},{-80,180},{-80,168},{-62,168}},color={255,0,255}));
  connect(phSpePumChiWatPri.y, rep4.u)
    annotation (Line(points={{-8,160},{0,160},{0,-100},{8,-100}},color={0,0,127}));
  connect(dpHeaWatRemSet, ctlDpHeaWat.dpRemSet)
    annotation (Line(points={{-180,120},{-100,120},{-100,204},{-62,204}},color={0,0,127}));
  connect(dpHeaWatRem, ctlDpHeaWat.dpRem)
    annotation (Line(points={{-180,100},{-96,100},{-96,200},{-62,200}},color={0,0,127}));
  connect(dpHeaWatLocSet, ctlDpHeaWat.dpLocSet)
    annotation (Line(points={{-180,80},{-92,80},{-92,196},{-62,196}},color={0,0,127}));
  connect(dpHeaWatLoc, ctlDpHeaWat.dpLoc)
    annotation (Line(points={{-180,60},{-88,60},{-88,192},{-62,192}},color={0,0,127}));
  connect(dpChiWatRemSet, ctlDpChiWat.dpRemSet)
    annotation (Line(points={{-180,40},{-80,40},{-80,164},{-62,164}},color={0,0,127}));
  connect(dpChiWatRem, ctlDpChiWat.dpRem)
    annotation (Line(points={{-180,20},{-76,20},{-76,160},{-62,160}},color={0,0,127}));
  connect(dpChiWatLocSet, ctlDpChiWat.dpLocSet)
    annotation (Line(points={{-180,0},{-72,0},{-72,156},{-62,156}},color={0,0,127}));
  connect(dpChiWatLoc, ctlDpChiWat.dpLoc)
    annotation (Line(points={{-180,-20},{-66,-20},{-66,152},{-62,152}},color={0,0,127}));
  connect(ctlDpHeaWat.dpLocSetMax, dpHeaWatLocSetMax)
    annotation (Line(points={{-38,196},{-34,196},{-34,186},{140,186},{140,200},{180,200}},
      color={0,0,127}));
  connect(ctlDpChiWat.dpLocSetMax, dpChiWatLocSetMax)
    annotation (Line(points={{-38,156},{-34,156},{-34,180},{140,180},{140,160},{180,160}},
      color={0,0,127}));
  connect(rep3.y, ph.uPh)
    annotation (Line(points={{32,-40},{80,-40},{80,-86},{90,-86}},color={0,0,127}));
  annotation (
    defaultComponentName="ctlPumPri",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-140},{100,140}}),
      graphics={
        Rectangle(
          extent={{-100,140},{100,-140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,190},{150,150}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        extent={{-160,-220},{160,220}})),
    Documentation(
      info="<html>
<h4>Plants with variable speed primary pumps that are not controlled to maintain differential pressure or flow setpoint</h4>
<h5>
Heating-only plants
</h5>
<p>
When commanded on, the primary HW pumps are commanded at a fixed
speed <code>yPumHeaWatPriSet</code>, as determined during the Testing, Adjusting,
and Balancing phase to provide the design heat pump flow.
</p>
<h5>
Cooling-only plants
</h5>
<p>
When commanded on, the primary CHW pumps are commanded at a fixed
speed <code>yPumChiWatPriSet</code>, as determined during the Testing, Adjusting,
and Balancing phase to provide the design heat pump flow.
</p>
<h5>
Heating and cooling plants with common primary CHW and HW pumps
</h5>
<p>
When commanded on, the primary pumps are commanded at a fixed
speed <code>yPumHeaWatPriSet</code> in heating mode or
<code>yPumChiWatPriSet</code> in cooling mode, as determined during the
Testing, Adjusting, and Balancing phase to provide the design heat pump flow
in heating mode or cooling mode.
</p>
<h5>
Heating and cooling plants with separate primary CHW and HW pumps
</h5>
<p>
When commanded on, the primary HW pumps are commanded at a fixed
speed <code>yPumHeaWatPriSet</code>.
When commanded on, the primary CHW pumps are commanded at a fixed
speed <code>yPumChiWatPriSet</code>.
The pump speed <code>yPumHeaWatPriSet</code> or <code>yPumChiWatPriSet</code>
is determined during the Testing, Adjusting, and Balancing phase to provide
the design heat pump flow in heating mode or cooling mode.
</p>
<h4>Plants with variable speed primary pumps that are controlled to maintain differential pressure or flow setpoint</h4>
<h5>
Heating-only plants
</h5>
<p>
The pumps are controlled as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure\">
Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure</a>.
The \"pump proven on\" condition is evaluated based on the primary HW pump status.
</p>
<h5>
Cooling-only plants
</h5>
<p>
The pumps are controlled as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure\">
Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure</a>.
The \"pump proven on\" condition is evaluated based on the primary CHW pump status.
</p>
<h5>
Heating and cooling plants with common primary CHW and HW pumps
</h5>
<p>
The pumps are controlled as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure\">
Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure</a>.
For the HW loop, the \"pump proven on\" condition is evaluated based on the status
of the primary pumps associated with heat pumps that are commanded in 
heating mode.
For the CHW loop, the \"pump proven on\" condition is evaluated based on the status
of the primary pumps associated with heat pumps that are commanded in 
cooling mode.
</p>
<h5>
Heating and cooling plants with separate primary CHW and HW pumps
</h5>
<p>
The pumps are controlled as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure\">
Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure</a>.
For the HW loop, the \"pump proven on\" condition is evaluated based on the status
of the primary HW pumps.
For the CHW loop, the \"pump proven on\" condition is evaluated based on the status
of the primary CHW pumps.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
Added logic for ∆p-controlled primary pumps.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end VariableSpeed;
