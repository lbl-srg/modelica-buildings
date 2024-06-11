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
    annotation (Placement(transformation(extent={{-240,-80},{-200,-40}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriHdr
    if have_pumHeaWatPri and have_pumPriHdr
    "Headered primary HW pump speed command"
    annotation (Placement(transformation(extent={{200,80},{240,120}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri[nPumChiWatPri]
    if have_pumChiWatPri
    "Primary CHW pump start command"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriHdr
    if have_pumChiWatPri and have_pumPriHdr
    "Headered primary CHW pump speed command"
    annotation (Placement(transformation(extent={{200,40},{240,80}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriDed[nPumHeaWatPri]
    if have_pumHeaWatPri and not have_pumPriHdr
    "Dedicated primary HW pump speed command"
    annotation (Placement(transformation(extent={{200,-100},{240,-60}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriDed[nPumChiWatPri]
    if have_pumChiWatPri and not have_pumPriHdr
    "Dedicated primary CHW pump speed command"
    annotation (Placement(transformation(extent={{200,-200},{240,-160}}),
      iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea[nEqu]
    if have_heaWat and have_chiWat and not have_pumChiWatPri
    "Heating/cooling mode command"
    annotation (Placement(transformation(extent={{-240,-180},{-200,-140}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumChiWatPriDed[nPumChiWatPri]
    if have_pumChiWatPri and not have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation (Placement(transformation(extent={{170,-190},{190,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Constant"
    annotation (Placement(transformation(extent={{-10,-210},{10,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumHeaWatPriDed[nPumHeaWatPri]
    if have_pumHeaWatPri and not have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation (Placement(transformation(extent={{170,-90},{190,-70}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(
    nout=nPumHeaWatPri)
    if have_pumHeaWatPri
    "Replicate signal"
    annotation (Placement(transformation(extent={{50,-130},{70,-110}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep1(
    nout=nPumChiWatPri)
    if have_pumChiWatPri
    "Replicate signal"
    annotation (Placement(transformation(extent={{50,-170},{70,-150}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep2(
    nout=nPumChiWatPri)
    if have_pumChiWatPri
    "Replicate signal"
    annotation (Placement(transformation(extent={{50,-210},{70,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumChiWatPriHdr
    if have_pumChiWatPri and have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation (Placement(transformation(extent={{170,50},{190,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumHeaWatPriHdr
    if have_pumHeaWatPri and have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation (Placement(transformation(extent={{170,90},{190,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumChiWatPri(
    nin=nPumChiWatPri)
    if have_pumChiWatPri
    "Return true if any pump is enabled"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumHeaWatPri(
    nin=nPumHeaWatPri)
    if have_pumHeaWatPri
    "Return true if any pump is enabled"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch selSpeHea[nPumHeaWatPri]
    if have_heaWat and have_chiWat and not have_pumChiWatPri and not have_pumPriHdr
    "Select prescribed pump speed depending on heating/cooling mode – Case with common CHW and HW dedicated pumps"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep3(
    nout=nPumHeaWatPri)
    if have_heaWat
    "Replicate signal"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep4(
    nout=nPumHeaWatPri)
    if have_heaWat and have_chiWat and not have_pumChiWatPri and not have_pumPriHdr
    "Replicate signal"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Utilities.PlaceholderReal ph[nPumHeaWatPri](
    each final have_inp=have_heaWat and have_chiWat and not have_pumChiWatPri
      and not have_pumPriHdr,
    each final have_inpPh=true)
    if have_pumHeaWatPri and not have_pumPriHdr
    "Always use HW pump speed in case of separate dedicated CHW pumps "
    annotation (Placement(transformation(extent={{132,-70},{152,-50}})));
  Generic.ControlDifferentialPressure ctlDpHeaWat(
    final have_senDpRemWir=have_senDpHeaWatRemWir,
    final k=kCtlDpHeaWat,
    final nPum=nPumHeaWatPri,
    final nSenDpRem=nSenDpHeaWatRem,
    final Ti=TiCtlDpHeaWat,
    final y_min=yPumHeaWatPri_min)
    if have_heaWat and have_pumPriCtlDp
    "HW loop ∆p control"
    annotation (Placement(transformation(extent={{-20,214},{0,234}})));
  Utilities.PlaceholderReal phSpePumHeaWatPri(
    final have_inp=have_pumPriCtlDp,
    final have_inpPh=false,
    final u_internal=yPumHeaWatPriSet)
    if have_heaWat
    "Replace with fixed speed"
    annotation (Placement(transformation(extent={{12,190},{32,210}})));
  Generic.ControlDifferentialPressure ctlDpChiWat(
    final have_senDpRemWir=have_senDpChiWatRemWir,
    final k=kCtlDpChiWat,
    final nPum=if have_pumChiWatPri then nPumChiWatPri else nPumHeaWatPri,
    final nSenDpRem=nSenDpChiWatRem,
    final Ti=TiCtlDpChiWat,
    final y_min=if have_pumChiWatPri then yPumChiWatPri_min else yPumHeaWatPri_min)
    if have_chiWat and have_pumPriCtlDp
    "CHW loop ∆p control"
    annotation (Placement(transformation(extent={{-20,154},{0,174}})));
  Utilities.PlaceholderReal phSpePumChiWatPri(
    final have_inp=have_pumPriCtlDp,
    final have_inpPh=false,
    final u_internal=yPumChiWatPriSet)
    if have_chiWat
    "Replace with fixed speed"
    annotation (Placement(transformation(extent={{10,130},{30,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri_actual[nPumHeaWatPri]
    if have_pumHeaWatPri and have_pumPriCtlDp
    "Primary HW pump status"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri_actual[nPumChiWatPri]
    if have_pumChiWatPri and have_pumPriCtlDp
    "Primary CHW pump status"
    annotation (Placement(transformation(extent={{-240,160},{-200,200}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not u1Coo[nEqu]
    if have_heaWat and have_chiWat and not have_pumChiWatPri
    "Return true if cooling mode command"
    annotation (Placement(transformation(extent={{-190,-150},{-170,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And u1CooAndOn[nPumHeaWatPri]
    if have_heaWat and have_chiWat and not have_pumChiWatPri and have_pumPriCtlDp
    "Return true if cooling mode command and pump proven on"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));
  Utilities.PlaceholderLogical phPumChiWatPriSta[if have_pumChiWatPri then nPumChiWatPri
    else nPumHeaWatPri](
    each final have_inp=have_pumChiWatPri,
    each final have_inpPh=true)
    if have_chiWat and have_pumPriCtlDp
    "Replace with common dedicated pump signal"
    annotation (Placement(transformation(extent={{-50,130},{-30,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatLoc(
    final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and not have_senDpChiWatRemWir
    "Local CHW differential pressure"
    annotation (Placement(transformation(extent={{-240,-40},{-200,0}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatLocSet[nSenDpChiWatRem](
    each final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and not have_senDpChiWatRemWir
    "Local CHW differential pressure setpoint output from each of the remote loops"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatRem[nSenDpChiWatRem](
    each final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and have_senDpChiWatRemWir
    "Remote CHW differential pressure"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatLoc(
    final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and not have_senDpHeaWatRemWir
    "Local HW differential pressure"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatLocSet[nSenDpHeaWatRem](
    each final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and not have_senDpHeaWatRemWir
    "Local HW differential pressure setpoint output from each of the remote loops"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatRem[nSenDpHeaWatRem](
    each final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and have_senDpHeaWatRemWir
    "Remote HW differential pressure"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatRemSet[nSenDpHeaWatRem](
    each final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and have_senDpHeaWatRemWir
    "Remote HW differential pressure setpoint"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatRemSet[nSenDpChiWatRem](
    each final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and have_senDpChiWatRemWir
    "Remote CHW differential pressure setpoint"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpHeaWatLocSetMax(
    final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and not have_senDpHeaWatRemWir
    "Maximum HW local differential pressure setpoint"
    annotation (Placement(transformation(extent={{200,200},{240,240}}),
      iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpChiWatLocSetMax(
    final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and not have_senDpChiWatRemWir
    "Maximum CHW local differential pressure setpoint"
    annotation (Placement(transformation(extent={{200,140},{240,180}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latCoo[nPumHeaWatPri]
    if have_heaWat and have_chiWat and not have_pumChiWatPri
    "Latch signal until pump is re-enabled with equipment commanded to alternative mode"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgU1PumHeaWatPri[nPumHeaWatPri]
    if have_heaWat and have_chiWat and not have_pumChiWatPri
    "Return true exactly when the pump is enabled"
    annotation (Placement(transformation(extent={{-190,-110},{-170,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And edgU1Coo[nPumHeaWatPri]
    if have_heaWat and have_chiWat and not have_pumChiWatPri
    "Return true if equipment commanded in cooling mode when the pump is enabled"
    annotation (Placement(transformation(extent={{-152,-130},{-132,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And edgU1AndHea[nPumHeaWatPri]
    if have_heaWat and have_chiWat and not have_pumChiWatPri
    "Return true if equipment commanded in heating mode when the pump is enabled"
    annotation (Placement(transformation(extent={{-152,-170},{-132,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latHea[nPumHeaWatPri]
    if have_heaWat and have_chiWat and not have_pumChiWatPri
    "Latch signal until pump is re-enabled with equipment commanded to alternative mode"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And u1HeaAndOn[nPumHeaWatPri]
    if have_heaWat and have_chiWat and not have_pumChiWatPri and have_pumPriCtlDp
    "Return true if heating mode command and pump proven on"
    annotation (Placement(transformation(extent={{-90,170},{-70,190}})));
  Utilities.PlaceholderLogical phPumHeaWatPriSta[nPumHeaWatPri](
    each final have_inp=have_chiWat and have_pumChiWatPri or not have_chiWat,
    each final have_inpPh=true)
    if have_heaWat and have_pumPriCtlDp
    "Replace with common dedicated pump signal"
    annotation (Placement(transformation(extent={{-50,190},{-30,210}})));
equation
  connect(u1PumChiWatPri, setPumChiWatPriDed.u2)
    annotation (Line(points={{-220,-80},{-18,-80},{-18,-180},{168,-180}},color={255,0,255}));
  connect(setPumChiWatPriDed.y, yPumChiWatPriDed)
    annotation (Line(points={{192,-180},{220,-180}},color={0,0,127}));
  connect(setPumHeaWatPriDed.y, yPumHeaWatPriDed)
    annotation (Line(points={{192,-80},{220,-80}},color={0,0,127}));
  connect(zer.y, rep.u)
    annotation (Line(points={{12,-200},{30,-200},{30,-120},{48,-120}},color={0,0,127}));
  connect(zer.y, rep2.u)
    annotation (Line(points={{12,-200},{48,-200}},color={0,0,127}));
  connect(setPumHeaWatPriHdr.y, yPumHeaWatPriHdr)
    annotation (Line(points={{192,100},{220,100}},color={0,0,127}));
  connect(setPumChiWatPriHdr.y, yPumChiWatPriHdr)
    annotation (Line(points={{192,60},{220,60}},color={0,0,127}));
  connect(rep2.y, setPumChiWatPriDed.u3)
    annotation (Line(points={{72,-200},{160,-200},{160,-188},{168,-188}},color={0,0,127}));
  connect(rep1.y, setPumChiWatPriDed.u1)
    annotation (Line(points={{72,-160},{160,-160},{160,-172},{168,-172}},color={0,0,127}));
  connect(zer.y, setPumChiWatPriHdr.u3)
    annotation (Line(points={{12,-200},{30,-200},{30,52},{168,52}},color={0,0,127}));
  connect(rep.y, setPumHeaWatPriDed.u3)
    annotation (Line(points={{72,-120},{160,-120},{160,-88},{168,-88}},color={0,0,127}));
  connect(zer.y, setPumHeaWatPriHdr.u3)
    annotation (Line(points={{12,-200},{30,-200},{30,92},{168,92}},color={0,0,127}));
  connect(u1PumChiWatPri, anyPumChiWatPri.u)
    annotation (Line(points={{-220,-80},{-18,-80},{-18,60},{-12,60}},color={255,0,255}));
  connect(u1PumHeaWatPri, anyPumHeaWatPri.u)
    annotation (Line(points={{-220,-60},{-20,-60},{-20,100},{-12,100}},color={255,0,255}));
  connect(anyPumHeaWatPri.y, setPumHeaWatPriHdr.u2)
    annotation (Line(points={{12,100},{168,100}},color={255,0,255}));
  connect(anyPumChiWatPri.y, setPumChiWatPriHdr.u2)
    annotation (Line(points={{12,60},{168,60}},color={255,0,255}));
  connect(u1PumHeaWatPri, setPumHeaWatPriDed.u2)
    annotation (Line(points={{-220,-60},{-20,-60},{-20,-100},{140,-100},{140,-80},{168,-80}},
      color={255,0,255}));
  connect(rep3.y, selSpeHea.u1)
    annotation (Line(points={{72,-20},{80,-20},{80,-52},{88,-52}},color={0,0,127}));
  connect(ph.y, setPumHeaWatPriDed.u1)
    annotation (Line(points={{154,-60},{158,-60},{158,-72},{168,-72}},color={0,0,127}));
  connect(selSpeHea.y, ph.u)
    annotation (Line(points={{112,-60},{130,-60}},color={0,0,127}));
  connect(u1Hea, u1Coo.u)
    annotation (Line(points={{-220,-160},{-196,-160},{-196,-140},{-192,-140}},
      color={255,0,255}));
  connect(u1PumChiWatPri_actual, phPumChiWatPriSta.u)
    annotation (Line(points={{-220,180},{-120,180},{-120,140},{-52,140}},color={255,0,255}));
  connect(phPumChiWatPriSta.y, ctlDpChiWat.y1_actual)
    annotation (Line(points={{-28,140},{-26,140},{-26,172},{-22,172}},color={255,0,255}));
  connect(dpHeaWatRemSet, ctlDpHeaWat.dpRemSet)
    annotation (Line(points={{-220,120},{-180,120},{-180,228},{-22,228}},color={0,0,127}));
  connect(dpHeaWatRem, ctlDpHeaWat.dpRem)
    annotation (Line(points={{-220,100},{-176,100},{-176,224},{-22,224}},color={0,0,127}));
  connect(dpHeaWatLocSet, ctlDpHeaWat.dpLocSet)
    annotation (Line(points={{-220,80},{-172,80},{-172,220},{-22,220}},color={0,0,127}));
  connect(dpHeaWatLoc, ctlDpHeaWat.dpLoc)
    annotation (Line(points={{-220,60},{-168,60},{-168,216},{-22,216}},color={0,0,127}));
  connect(dpChiWatRemSet, ctlDpChiWat.dpRemSet)
    annotation (Line(points={{-220,40},{-164,40},{-164,168},{-22,168}},color={0,0,127}));
  connect(dpChiWatRem, ctlDpChiWat.dpRem)
    annotation (Line(points={{-220,20},{-160,20},{-160,164},{-22,164}},color={0,0,127}));
  connect(dpChiWatLocSet, ctlDpChiWat.dpLocSet)
    annotation (Line(points={{-220,0},{-156,0},{-156,160},{-22,160}},color={0,0,127}));
  connect(dpChiWatLoc, ctlDpChiWat.dpLoc)
    annotation (Line(points={{-220,-20},{-152,-20},{-152,156},{-22,156}},color={0,0,127}));
  connect(ctlDpHeaWat.dpLocSetMax, dpHeaWatLocSetMax)
    annotation (Line(points={{2,220},{220,220}},color={0,0,127}));
  connect(ctlDpChiWat.dpLocSetMax, dpChiWatLocSetMax)
    annotation (Line(points={{2,160},{220,160}},color={0,0,127}));
  connect(rep3.y, ph.uPh)
    annotation (Line(points={{72,-20},{120,-20},{120,-66},{130,-66}},color={0,0,127}));
  connect(rep4.y, selSpeHea.u3)
    annotation (Line(points={{72,-80},{80,-80},{80,-68},{88,-68}},color={0,0,127}));
  connect(u1PumHeaWatPri, edgU1PumHeaWatPri.u)
    annotation (Line(points={{-220,-60},{-196,-60},{-196,-100},{-192,-100}},
      color={255,0,255}));
  connect(u1Hea, edgU1AndHea.u2)
    annotation (Line(points={{-220,-160},{-196,-160},{-196,-168},{-154,-168}},
      color={255,0,255}));
  connect(u1PumHeaWatPri_actual, u1HeaAndOn.u1)
    annotation (Line(points={{-220,200},{-100,200},{-100,180},{-92,180}},color={255,0,255}));
  connect(edgU1AndHea.y, latHea.u)
    annotation (Line(points={{-130,-160},{-122,-160}},color={255,0,255}));
  connect(phSpePumChiWatPri.y, setPumChiWatPriHdr.u1)
    annotation (Line(points={{32,140},{40,140},{40,68},{168,68}},color={0,0,127}));
  connect(ctlDpHeaWat.y, phSpePumHeaWatPri.u)
    annotation (Line(points={{2,224},{6,224},{6,200},{10,200}},color={0,0,127}));
  connect(ctlDpChiWat.y, phSpePumChiWatPri.u)
    annotation (Line(points={{2,164},{6,164},{6,140},{8,140}},color={0,0,127}));
  connect(phSpePumHeaWatPri.y, setPumHeaWatPriHdr.u1)
    annotation (Line(points={{34,200},{42,200},{42,108},{168,108}},color={0,0,127}));
  connect(phSpePumHeaWatPri.y, rep3.u)
    annotation (Line(points={{34,200},{42,200},{42,-20},{48,-20}},color={0,0,127}));
  connect(phSpePumChiWatPri.y, rep4.u)
    annotation (Line(points={{32,140},{40,140},{40,-80},{48,-80}},color={0,0,127}));
  connect(u1CooAndOn.y, phPumChiWatPriSta.uPh)
    annotation (Line(points={{-68,120},{-60,120},{-60,134},{-52,134}},color={255,0,255}));
  connect(phPumHeaWatPriSta.y, ctlDpHeaWat.y1_actual)
    annotation (Line(points={{-28,200},{-26,200},{-26,232},{-22,232}},color={255,0,255}));
  connect(u1HeaAndOn.y, phPumHeaWatPriSta.uPh)
    annotation (Line(points={{-68,180},{-60,180},{-60,194},{-52,194}},color={255,0,255}));
  connect(u1PumHeaWatPri_actual, phPumHeaWatPriSta.u)
    annotation (Line(points={{-220,200},{-52,200}},color={255,0,255}));
  connect(latCoo.y, u1CooAndOn.u2)
    annotation (Line(points={{-98,-120},{-96,-120},{-96,112},{-92,112}},color={255,0,255}));
  connect(latHea.y, selSpeHea.u2)
    annotation (Line(points={{-98,-160},{0,-160},{0,-60},{88,-60}},color={255,0,255}));
  connect(latHea.y, u1HeaAndOn.u2)
    annotation (Line(points={{-98,-160},{-98,172},{-92,172}},color={255,0,255}));
  connect(phSpePumChiWatPri.y, rep1.u)
    annotation (Line(points={{32,140},{40,140},{40,-160},{48,-160}},color={0,0,127}));
  connect(u1PumHeaWatPri_actual, u1CooAndOn.u1)
    annotation (Line(points={{-220,200},{-100,200},{-100,120},{-92,120}},color={255,0,255}));
  connect(u1Coo.y, edgU1Coo.u2)
    annotation (Line(points={{-168,-140},{-164,-140},{-164,-128},{-154,-128}},
      color={255,0,255}));
  connect(edgU1PumHeaWatPri.y, edgU1Coo.u1)
    annotation (Line(points={{-168,-100},{-160,-100},{-160,-120},{-154,-120}},
      color={255,0,255}));
  connect(edgU1PumHeaWatPri.y, edgU1AndHea.u1)
    annotation (Line(points={{-168,-100},{-160,-100},{-160,-160},{-154,-160}},
      color={255,0,255}));
  connect(edgU1Coo.y, latCoo.u)
    annotation (Line(points={{-130,-120},{-122,-120}},color={255,0,255}));
  connect(edgU1AndHea.y, latCoo.clr)
    annotation (Line(points={{-130,-160},{-126,-160},{-126,-126},{-122,-126}},
      color={255,0,255}));
  connect(edgU1Coo.y, latHea.clr)
    annotation (Line(points={{-130,-120},{-128,-120},{-128,-166},{-122,-166}},
      color={255,0,255}));
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
        extent={{-200,-240},{200,240}}),
      graphics={
        Rectangle(
          extent={{-198,-84},{-22,-218}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-196,-180},{-60,-200}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Latch operating mode of associated
HP when the pump is enabled")}),
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
The operating mode of the associated heat pump is determined and 
latched at the time the pump is enabled.
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
The operating mode of the associated heat pump is determined and 
latched at the time the pump is enabled.
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
Added logic for ∆p-controlled primary pumps and latching of HP operating mode.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end VariableSpeed;
