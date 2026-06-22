within Buildings.Templates.Plants.Controls.Pumps.Primary;
block VariableSpeedHeatPumps
  "Variable speed primary pumps in heat pump plants"
  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  parameter Boolean have_pumPriHdr
    "Set to true for headered primary pumps, false for dedicated pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  parameter Boolean have_pumChiWatPriDedHp(start=false) = false
    "Set to true for HP with separate dedicated primary pumps for CHW and HW circuits"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=not have_pumPriHdr and nHp > 0));
  final parameter Boolean have_pumPriComDedHp =
    nHp > 0
      and have_heaWat
      and have_chiWat
      and not have_pumPriHdr
      and not have_pumChiWatPriDedHp
    "Set to true for HP with single dedicated primary pump serving both CHW and HW circuits"
    annotation(Evaluate=true);
  parameter Integer nHp
    "Number of 2-pipe heat pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  parameter Integer nPhp
    "Number of polyvalent heat pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  final parameter Integer nEqu = nHp + nPhp
    "Heating or cooling equipment count"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  parameter Boolean have_pumPriCtlDp
    "Set to true for primary variable speed pumps using ∆p pump speed control"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  parameter Integer nPumHeaWatPri(start=0)
    "Number of primary HW pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_heaWat));
  parameter Integer nPumChiWatPri(start=0)
    "Number of primary CHW pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_chiWat and have_pumPriHdr
          or nPhp > 0
        or nHp > 0 and have_pumChiWatPriDedHp));
  parameter Real yPumHeaWatPriHdrSet(
    max=2,
    min=0,
    start=1,
    unit="1") "Primary HW pump speed providing design flow – Headered pumps"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and have_pumPriHdr and not have_pumPriCtlDp));
  parameter Real yPumChiWatPriHdrSet(
    max=2,
    min=0,
    start=1,
    unit="1") "Primary CHW pump speed providing design flow – Headered pumps"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_chiWat and have_pumPriHdr and not have_pumPriCtlDp));
  parameter Real yPumHeaWatPriDedHpSet(
    max=2,
    min=0,
    start=1,
    unit="1") "Primary pump speed providing design flow in heating mode – HP dedicated pumps"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and not have_pumPriHdr and nHp > 0 and not have_pumPriCtlDp));
  parameter Real yPumChiWatPriDedHpSet(
    max=2,
    min=0,
    start=1,
    unit="1") "Primary pump speed providing design flow in cooling mode – HP dedicated pumps"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_chiWat and not have_pumPriHdr and nHp > 0 and not have_pumPriCtlDp));
  parameter Real yPumHeaWatPriDedPhpSet(
    max=2,
    min=0,
    start=1,
    unit="1")
    "Primary HW pump speed providing design flow – Polyvalent HP dedicated pumps"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and not have_pumPriHdr and nPhp > 0 and not have_pumPriCtlDp));
  parameter Real yPumChiWatPriDedPhpSet(
    max=2,
    min=0,
    start=1,
    unit="1")
    "Primary CHW pump speed providing design flow – Polyvalent HP dedicated pumps"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_chiWat and not have_pumPriHdr and nPhp > 0 and not have_pumPriCtlDp));
  parameter Boolean have_senDpHeaWatRemWir(start=false)
    "Set to true for remote HW differential pressure sensor(s) hardwired to controller"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_heaWat and have_pumPriCtlDp));
  parameter Integer nSenDpHeaWatRem(start=0)
    "Number of remote HW differential pressure sensors used for pump speed control"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_heaWat and have_pumPriCtlDp));
  parameter Real yPumHeaWatPri_min(max=1, min=0, start=0.1, unit="1") = 0.1
    "Minimum primary HW pump speed"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and have_pumPriCtlDp));
  parameter Real kCtlDpHeaWat(
    min=100 * Buildings.Controls.OBC.CDL.Constants.eps,
    start=1) = 1
    "Gain of controller for HW loop ∆p control"
    annotation(Dialog(group="Control gains",
      enable=have_heaWat and have_pumPriCtlDp));
  parameter Real TiCtlDpHeaWat(
    min=100 * Buildings.Controls.OBC.CDL.Constants.eps,
    start=60,
    unit="s") = 60
    "Time constant of integrator block for HW loop ∆p control"
    annotation(Dialog(group="Control gains",
      enable=have_heaWat and have_pumPriCtlDp));
  parameter Boolean have_senDpChiWatRemWir(start=false)
    "Set to true for remote CHW differential pressure sensor(s) hardwired to controller"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_chiWat and have_pumPriCtlDp));
  parameter Integer nSenDpChiWatRem(start=0)
    "Number of remote CHW differential pressure sensors used for pump speed control"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_chiWat and have_pumPriCtlDp));
  parameter Real yPumChiWatPri_min(max=1, min=0, start=0.1, unit="1") = 0.1
    "Minimum primary CHW pump speed"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_chiWat and have_pumPriCtlDp));
  parameter Real kCtlDpChiWat(
    min=100 * Buildings.Controls.OBC.CDL.Constants.eps,
    start=1) = 1
    "Gain of controller for CHW loop ∆p control"
    annotation(Dialog(group="Control gains",
      enable=have_chiWat and have_pumPriCtlDp));
  parameter Real TiCtlDpChiWat(
    min=100 * Buildings.Controls.OBC.CDL.Constants.eps,
    start=60,
    unit="s") = 60
    "Time constant of integrator block for CHW loop ∆p control"
    annotation(Dialog(group="Control gains",
      enable=have_chiWat and have_pumPriCtlDp));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriHdr[nPumHeaWatPri]
    if have_heaWat and have_pumPriHdr
    "Primary HW pump start command – Headered pumps"
    annotation(Placement(transformation(extent={{-240,-60},{-200,-20}}),
      iconTransformation(extent={{-140,180},{-100,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriHdr
    if have_heaWat and have_pumPriHdr
    "Headered primary HW pump speed command"
    annotation(Placement(transformation(extent={{200,100},{240,140}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriHdr[nPumChiWatPri]
    if have_chiWat and have_pumPriHdr
    "Primary CHW pump start command – Headered pumps"
    annotation(Placement(transformation(extent={{-240,-120},{-200,-80}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriHdr
    if have_chiWat and have_pumPriHdr
    "Headered primary CHW pump speed command"
    annotation(Placement(transformation(extent={{200,40},{240,80}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriDedHp[nHp]
    if have_heaWat and not have_pumPriHdr and nHp > 0
    "HP dedicated primary HW pump speed command"
    annotation(Placement(transformation(extent={{200,-140},{240,-100}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriDedHp[nHp]
    if have_chiWat and nHp > 0 and have_pumChiWatPriDedHp
    "HP dedicated primary CHW pump speed command"
    annotation(Placement(transformation(extent={{200,-180},{240,-140}}),
      iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaHp[nHp]
    if have_pumPriComDedHp
    "HP heating/cooling mode command"
    annotation(Placement(transformation(extent={{-240,-240},{-200,-200}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumChiWatPriDedHp[nHp]
    if have_chiWat and nHp > 0 and have_pumChiWatPriDedHp
    "Set prescribed speed when pump is enabled"
    annotation(Placement(transformation(extent={{170,-170},{190,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0)
    "Constant"
    annotation(Placement(transformation(extent={{-50,-190},{-30,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumHeaWatPriDedHp[nHp]
    if have_heaWat and nHp > 0 and not have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation(Placement(transformation(extent={{170,-130},{190,-110}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(nout=nHp)
    if nHp > 0
    "Replicate signal"
    annotation(Placement(transformation(extent={{50,-190},{70,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumChiWatPriHdr
    if have_chiWat and have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation(Placement(transformation(extent={{170,50},{190,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumHeaWatPriHdr
    if have_heaWat and have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation(Placement(transformation(extent={{170,110},{190,130}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumChiWatPri(nin=nPumChiWatPri)
    if have_chiWat and have_pumPriHdr
    "Return true if any pump is enabled"
    annotation(Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumHeaWatPri(nin=nPumHeaWatPri)
    if have_heaWat and have_pumPriHdr
    "Return true if any pump is enabled"
    annotation(Placement(transformation(extent={{-10,110},{10,130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch selSpeHeaCooHp[nHp]
    if have_pumPriComDedHp
    "Select prescribed pump speed depending on heating/cooling mode – HP with common CHW and HW dedicated pumps"
    annotation(Placement(transformation(extent={{120,-10},{140,10}})));
  Utilities.PlaceholderReal ph[nHp](
    each final have_inp=have_pumPriComDedHp,
    each final have_inpPh=true)
    if have_heaWat and not have_pumPriHdr and nHp > 0
    "Always use HW pump speed in case of separate dedicated CHW pumps "
    annotation(Placement(transformation(extent={{160,-10},{180,10}})));
  Generic.ControlDifferentialPressure ctlDpHeaWat(
    final have_senDpRemWir=have_senDpHeaWatRemWir,
    final k=kCtlDpHeaWat,
    final nPum=nPumHeaWatPri,
    final nSenDpRem=nSenDpHeaWatRem,
    final Ti=TiCtlDpHeaWat,
    final y_min=yPumHeaWatPri_min)
    if have_heaWat and have_pumPriCtlDp
    "HW loop ∆p control"
    annotation(Placement(transformation(extent={{-20,254},{0,274}})));
  Utilities.PlaceholderReal phSpePumHeaWatPriHp(
    final have_inp=have_pumPriCtlDp,
    final have_inpPh=false,
    final u_internal=yPumHeaWatPriDedHpSet) if have_heaWat and nHp > 0
    "Replace with fixed speed – HP"
    annotation (Placement(transformation(extent={{48,10},{68,30}})));
  Generic.ControlDifferentialPressure ctlDpChiWat(
    final have_senDpRemWir=have_senDpChiWatRemWir,
    final k=kCtlDpChiWat,
    final nPum=nPumChiWatPri + (if nHp > 0 and not have_pumPriHdr and
      not have_pumChiWatPriDedHp
      then nHp else 0),
    final nSenDpRem=nSenDpChiWatRem,
    final Ti=TiCtlDpChiWat,
    final y_min=if have_chiWat then yPumChiWatPri_min else yPumHeaWatPri_min)
    if have_chiWat and have_pumPriCtlDp
    "CHW loop ∆p control"
    annotation(Placement(transformation(extent={{-20,154},{0,174}})));
  Utilities.PlaceholderReal phSpePumChiWatPriHp(
    final have_inp=have_pumPriCtlDp,
    final have_inpPh=false,
    final u_internal=yPumChiWatPriDedHpSet) if nHp > 0 and have_chiWat
    "Replace with fixed speed – HP"
    annotation (Placement(transformation(extent={{48,-30},{68,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriHdr_actual[nPumHeaWatPri]
    if have_heaWat and have_pumPriCtlDp and have_pumPriHdr
    "Primary HW pump status – Headered pumps"
    annotation(Placement(transformation(extent={{-240,240},{-200,280}}),
      iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriHdr_actual[nPumChiWatPri]
    if have_chiWat and have_pumPriCtlDp and have_pumPriHdr
    "Primary CHW pump status – Headered pumps"
    annotation(Placement(transformation(extent={{-240,180},{-200,220}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not u1CooHp[nHp]
    if have_pumPriComDedHp
    "Return true if HP cooling mode command"
    annotation(Placement(transformation(extent={{-190,-210},{-170,-190}})));
  Buildings.Controls.OBC.CDL.Logical.And u1CooAndOnDedHp[nHp]
    if have_pumPriCtlDp and have_pumPriComDedHp
    "Return true if cooling mode command and pump proven on – HP with dedicated pumps"
    annotation(Placement(transformation(extent={{-130,110},{-110,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatLoc(final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and not have_senDpChiWatRemWir
    "Local CHW differential pressure"
    annotation(Placement(transformation(extent={{-240,-40},{-200,0}}),
      iconTransformation(extent={{-140,-220},{-100,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatLocSet[nSenDpChiWatRem](
    each final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and not have_senDpChiWatRemWir
    "Local CHW differential pressure setpoint output from each of the remote loops"
    annotation(Placement(transformation(extent={{-240,-20},{-200,20}}),
      iconTransformation(extent={{-140,-200},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatRem[nSenDpChiWatRem](
    each final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and have_senDpChiWatRemWir
    "Remote CHW differential pressure"
    annotation(Placement(transformation(extent={{-240,0},{-200,40}}),
      iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatLoc(final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and not have_senDpHeaWatRemWir
    "Local HW differential pressure"
    annotation(Placement(transformation(extent={{-240,40},{-200,80}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatLocSet[nSenDpHeaWatRem](
    each final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and not have_senDpHeaWatRemWir
    "Local HW differential pressure setpoint output from each of the remote loops"
    annotation(Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatRem[nSenDpHeaWatRem](
    each final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and have_senDpHeaWatRemWir
    "Remote HW differential pressure"
    annotation(Placement(transformation(extent={{-240,80},{-200,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatRemSet[nSenDpHeaWatRem](
    each final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and have_senDpHeaWatRemWir
    "Remote HW differential pressure setpoint"
    annotation(Placement(transformation(extent={{-240,100},{-200,140}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatRemSet[nSenDpChiWatRem](
    each final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and have_senDpChiWatRemWir
    "Remote CHW differential pressure setpoint"
    annotation(Placement(transformation(extent={{-240,20},{-200,60}}),
      iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpHeaWatLocSetMax(
    final unit="Pa")
    if have_heaWat and have_pumPriCtlDp and not have_senDpHeaWatRemWir
    "Maximum HW local differential pressure setpoint"
    annotation(Placement(transformation(extent={{200,240},{240,280}}),
      iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpChiWatLocSetMax(
    final unit="Pa")
    if have_chiWat and have_pumPriCtlDp and not have_senDpChiWatRemWir
    "Maximum CHW local differential pressure setpoint"
    annotation(Placement(transformation(extent={{200,140},{240,180}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latCoo[nHp]
    if have_pumPriComDedHp
    "Latch signal until pump is re-enabled with equipment commanded to alternative mode"
    annotation(Placement(transformation(extent={{-110,-190},{-90,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgU1PumHeaWatPri[nHp]
    if have_pumPriComDedHp
    "Return true exactly when the pump is enabled"
    annotation(Placement(transformation(extent={{-190,-170},{-170,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And edgU1Coo[nHp]
    if have_pumPriComDedHp
    "Return true if equipment commanded in cooling mode when the pump is enabled"
    annotation(Placement(transformation(extent={{-152,-190},{-132,-170}})));
  Buildings.Controls.OBC.CDL.Logical.And edgU1AndHea[nHp]
    if have_pumPriComDedHp
    "Return true if equipment commanded in heating mode when the pump is enabled"
    annotation(Placement(transformation(extent={{-152,-230},{-132,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latHea[nHp]
    if have_pumPriComDedHp
    "Latch signal until pump is re-enabled with equipment commanded to alternative mode"
    annotation(Placement(transformation(extent={{-110,-230},{-90,-210}})));
  Buildings.Controls.OBC.CDL.Logical.And u1HeaAndOnDedHp[nHp]
    if have_pumPriCtlDp and have_pumPriComDedHp
    "Return true if heating mode command and pump proven on – HP with dedicated pumps"
    annotation(Placement(transformation(extent={{-130,210},{-110,230}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriDedHp_actual[nHp]
    if have_heaWat and have_pumPriCtlDp and not have_pumPriHdr and nHp > 0
    "Primary HW pump status – HP dedicated pumps"
    annotation(Placement(transformation(extent={{-240,220},{-200,260}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriDedPhp_actual[nPhp]
    if have_heaWat and have_pumPriCtlDp and not have_pumPriHdr and nPhp > 0
    "Primary HW pump status – PHP dedicated pumps"
    annotation(Placement(transformation(extent={{-240,200},{-200,240}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriDedHp_actual[nHp]
    if have_pumChiWatPriDedHp and have_pumPriCtlDp and nHp > 0
    "Primary CHW pump status – HP dedicated pumps"
    annotation(Placement(transformation(extent={{-240,160},{-200,200}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriDedPhp_actual[nPhp]
    if have_chiWat and have_pumPriCtlDp and not have_pumPriHdr and nPhp > 0
    "Primary CHW pump status – PHP dedicated pumps"
    annotation(Placement(transformation(extent={{-240,140},{-200,180}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriDedHp[nHp]
    if have_heaWat and not have_pumPriHdr and nHp > 0
    "Primary HW pump start command – HP dedicated pumps"
    annotation(Placement(transformation(extent={{-240,-80},{-200,-40}}),
      iconTransformation(extent={{-140,160},{-100,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriDedPhp[nPhp]
    if have_heaWat and not have_pumPriHdr and nPhp > 0
    "Primary HW pump start command – PHP dedicated pumps"
    annotation(Placement(transformation(extent={{-240,-100},{-200,-60}}),
      iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriDedHp[nHp]
    if have_chiWat and nHp > 0 and have_pumChiWatPriDedHp
    "Primary CHW pump start command – HP dedicated pumps"
    annotation(Placement(transformation(extent={{-240,-140},{-200,-100}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriDedPhp[nPhp]
    if have_chiWat and nPhp > 0 and not have_pumPriHdr
    "Primary CHW pump start command – PHP dedicated pumps"
    annotation(Placement(transformation(extent={{-240,-160},{-200,-120}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Utilities.PlaceholderLogical pumDedOnAndHeaHp[nHp](
    each final have_inp=have_pumPriCtlDp and have_pumPriComDedHp,
    each final have_inpPh=true)
    if have_heaWat and have_pumPriCtlDp and not have_pumPriHdr and nHp > 0
    "Dedicated pump on and heating mode – HP"
    annotation(Placement(transformation(extent={{-100,210},{-80,230}})));
  Utilities.ConcatenateSelectLogical pumDedOnHea(
    have_u1=nHp > 0,
    final have_u2=nPhp > 0,
    final nin2=nPhp,
    final nin1=nHp)
    if have_heaWat and have_pumPriCtlDp and not have_pumPriHdr
    "Dedicated pump on and heating mode"
    annotation(Placement(transformation(extent={{-60,210},{-40,230}})));
  Utilities.PlaceholderLogical pumDedOnAndHeaHp2[nHp](
    each final have_inp=have_pumPriCtlDp and have_pumPriComDedHp,
    each final have_inpPh=true)
    if have_chiWat and have_pumPriCtlDp and not have_pumPriHdr and nHp > 0
    "Dedicated pump on and heating mode – HP"
    annotation(Placement(transformation(extent={{-100,110},{-80,130}})));
  Utilities.ConcatenateSelectLogical pumDedOnCoo(
    final have_u1=nHp > 0,
    final have_u2=nPhp > 0,
    final nin2=nPhp,
    final nin1=nHp)
    if have_chiWat and have_pumPriCtlDp and not have_pumPriHdr
    "Dedicated pump on and cooling mode"
    annotation(Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep3(final nout=nHp)
    if have_heaWat and nHp > 0
    "Replicate signal"
    annotation(Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep4(final nout=nHp)
    if nHp > 0 and have_chiWat
    "Replicate signal"
    annotation(Placement(transformation(extent={{80,-30},{100,-10}})));
  Utilities.PlaceholderReal phSpePumHeaWatPriPhp(
    final have_inp=have_pumPriCtlDp,
    final have_inpPh=false,
    final u_internal=yPumHeaWatPriDedPhpSet) if have_heaWat and nPhp > 0
    "Replace with fixed speed – PHP"
    annotation (Placement(transformation(extent={{48,-70},{68,-50}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep5(final nout=nPhp)
    if have_heaWat and nPhp > 0
    "Replicate signal"
    annotation(Placement(transformation(extent={{80,-70},{100,-50}})));
  Utilities.PlaceholderReal phSpePumChiWatPriPhp(
    final have_inp=have_pumPriCtlDp,
    final have_inpPh=false,
    final u_internal=yPumChiWatPriDedPhpSet) if have_chiWat and nPhp > 0
    "Replace with fixed speed – PHP"
    annotation (Placement(transformation(extent={{48,-110},{68,-90}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep6(final nout=nPhp)
    if have_chiWat and nPhp > 0
    "Replicate signal"
    annotation(Placement(transformation(extent={{80,-110},{100,-90}})));
  Utilities.PlaceholderReal phSpePumHeaWatPri(
    final have_inp=have_pumPriCtlDp,
    final have_inpPh=false,
    final u_internal=yPumHeaWatPriHdrSet) if have_heaWat and have_pumPriHdr
    "Replace with fixed speed – HP XOR PHP (both NOT supported)"
    annotation (Placement(transformation(extent={{50,130},{70,150}})));
  Utilities.PlaceholderReal phSpePumChiWatPri(
    final have_inp=have_pumPriCtlDp,
    final have_inpPh=false,
    final u_internal=yPumChiWatPriHdrSet) if have_chiWat and have_pumPriHdr
    "Replace with fixed speed – HP XOR PHP (both NOT supported)"
    annotation (Placement(transformation(extent={{50,70},{70,90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumChiWatPriDedPhp[nPhp]
    if have_chiWat and not have_pumPriHdr and nPhp > 0
    "Set prescribed speed when pump is enabled"
    annotation(Placement(transformation(extent={{170,-250},{190,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumHeaWatPriDedPhp[nPhp]
    if have_heaWat and not have_pumPriHdr and nPhp > 0
    "Set prescribed speed when pump is enabled"
    annotation(Placement(transformation(extent={{170,-210},{190,-190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriDedPhp[nPhp]
    if have_heaWat and not have_pumPriHdr and nPhp > 0
    "PHP dedicated primary HW pump speed command"
    annotation(Placement(transformation(extent={{200,-220},{240,-180}}),
      iconTransformation(extent={{100,-182},{140,-142}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriDedPhp[nPhp]
    if have_chiWat and not have_pumPriHdr and nPhp > 0
    "PHP dedicated primary CHW pump speed command"
    annotation(Placement(transformation(extent={{200,-260},{240,-220}}),
      iconTransformation(extent={{100,-220},{140,-180}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep1(nout=nPhp)
    if nPhp > 0
    "Replicate signal"
    annotation(Placement(transformation(extent={{50,-230},{70,-210}})));
equation
  connect(setPumChiWatPriDedHp.y, yPumChiWatPriDedHp)
    annotation(Line(points={{192,-160},{220,-160}},
      color={0,0,127}));
  connect(setPumHeaWatPriDedHp.y, yPumHeaWatPriDedHp)
    annotation(Line(points={{192,-120},{220,-120}},
      color={0,0,127}));
  connect(zer.y, rep.u)
    annotation(Line(points={{-28,-180},{48,-180}},
      color={0,0,127}));
  connect(setPumHeaWatPriHdr.y, yPumHeaWatPriHdr)
    annotation(Line(points={{192,120},{220,120}},
      color={0,0,127}));
  connect(setPumChiWatPriHdr.y, yPumChiWatPriHdr)
    annotation(Line(points={{192,60},{220,60}},
      color={0,0,127}));
  connect(zer.y, setPumChiWatPriHdr.u3)
    annotation(Line(points={{-28,-180},{30,-180},{30,52},{168,52}},
      color={0,0,127}));
  connect(rep.y, setPumHeaWatPriDedHp.u3)
    annotation(Line(points={{72,-180},{160,-180},{160,-128},{168,-128}},
      color={0,0,127}));
  connect(zer.y, setPumHeaWatPriHdr.u3)
    annotation(Line(points={{-28,-180},{30,-180},{30,112},{168,112}},
      color={0,0,127}));
  connect(u1PumChiWatPriHdr, anyPumChiWatPri.u)
    annotation(Line(points={{-220,-100},{-18,-100},{-18,60},{-12,60}},
      color={255,0,255}));
  connect(u1PumHeaWatPriHdr, anyPumHeaWatPri.u)
    annotation(Line(points={{-220,-40},{-20,-40},{-20,120},{-12,120}},
      color={255,0,255}));
  connect(anyPumHeaWatPri.y, setPumHeaWatPriHdr.u2)
    annotation(Line(points={{12,120},{168,120}},
      color={255,0,255}));
  connect(anyPumChiWatPri.y, setPumChiWatPriHdr.u2)
    annotation(Line(points={{12,60},{168,60}},
      color={255,0,255}));
  connect(u1HeaHp, u1CooHp.u)
    annotation(Line(points={{-220,-220},{-196,-220},{-196,-200},{-192,-200}},
      color={255,0,255}));
  connect(dpHeaWatRemSet, ctlDpHeaWat.dpRemSet)
    annotation(Line(points={{-220,120},{-180,120},{-180,268},{-22,268}},
      color={0,0,127}));
  connect(dpHeaWatRem, ctlDpHeaWat.dpRem)
    annotation(Line(points={{-220,100},{-176,100},{-176,264},{-22,264}},
      color={0,0,127}));
  connect(dpHeaWatLocSet, ctlDpHeaWat.dpLocSet)
    annotation(Line(points={{-220,80},{-172,80},{-172,260},{-22,260}},
      color={0,0,127}));
  connect(dpHeaWatLoc, ctlDpHeaWat.dpLoc)
    annotation(Line(points={{-220,60},{-168,60},{-168,256},{-22,256}},
      color={0,0,127}));
  connect(dpChiWatRemSet, ctlDpChiWat.dpRemSet)
    annotation(Line(points={{-220,40},{-164,40},{-164,168},{-22,168}},
      color={0,0,127}));
  connect(dpChiWatRem, ctlDpChiWat.dpRem)
    annotation(Line(points={{-220,20},{-160,20},{-160,164},{-22,164}},
      color={0,0,127}));
  connect(dpChiWatLocSet, ctlDpChiWat.dpLocSet)
    annotation(Line(points={{-220,0},{-156,0},{-156,160},{-22,160}},
      color={0,0,127}));
  connect(dpChiWatLoc, ctlDpChiWat.dpLoc)
    annotation(Line(points={{-220,-20},{-152,-20},{-152,156},{-22,156}},
      color={0,0,127}));
  connect(ctlDpHeaWat.dpLocSetMax, dpHeaWatLocSetMax)
    annotation(Line(points={{2,260},{220,260}},
      color={0,0,127}));
  connect(ctlDpChiWat.dpLocSetMax, dpChiWatLocSetMax)
    annotation(Line(points={{2,160},{220,160}},
      color={0,0,127}));
  connect(u1HeaHp, edgU1AndHea.u2)
    annotation(Line(points={{-220,-220},{-196,-220},{-196,-228},{-154,-228}},
      color={255,0,255}));
  connect(edgU1AndHea.y, latHea.u)
    annotation(Line(points={{-130,-220},{-112,-220}},
      color={255,0,255}));
  connect(latCoo.y, u1CooAndOnDedHp.u2)
    annotation(Line(
      points={{-88,-180},{-84,-180},{-84,-158},{-136,-158},{-136,112},{-132,112}},
      color={255,0,255}));
  connect(latHea.y, u1HeaAndOnDedHp.u2)
    annotation(Line(
      points={{-88,-220},{-80,-220},{-80,-152},{-140,-152},{-140,212},{-132,212}},
      color={255,0,255}));
  connect(u1CooHp.y, edgU1Coo.u2)
    annotation(Line(points={{-168,-200},{-164,-200},{-164,-188},{-154,-188}},
      color={255,0,255}));
  connect(edgU1PumHeaWatPri.y, edgU1Coo.u1)
    annotation(Line(points={{-168,-160},{-160,-160},{-160,-180},{-154,-180}},
      color={255,0,255}));
  connect(edgU1PumHeaWatPri.y, edgU1AndHea.u1)
    annotation(Line(points={{-168,-160},{-160,-160},{-160,-220},{-154,-220}},
      color={255,0,255}));
  connect(edgU1Coo.y, latCoo.u)
    annotation(Line(points={{-130,-180},{-112,-180}},
      color={255,0,255}));
  connect(edgU1AndHea.y, latCoo.clr)
    annotation(Line(points={{-130,-220},{-118,-220},{-118,-186},{-112,-186}},
      color={255,0,255}));
  connect(edgU1Coo.y, latHea.clr)
    annotation(Line(points={{-130,-180},{-124,-180},{-124,-226},{-112,-226}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedHp_actual, u1HeaAndOnDedHp.u1)
    annotation(Line(points={{-220,240},{-144,240},{-144,220},{-132,220}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedHp_actual, u1CooAndOnDedHp.u1)
    annotation(Line(points={{-220,240},{-144,240},{-144,120},{-132,120}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedHp, edgU1PumHeaWatPri.u)
    annotation(Line(points={{-220,-60},{-196,-60},{-196,-160},{-192,-160}},
      color={255,0,255}));
  connect(u1HeaAndOnDedHp.y, pumDedOnAndHeaHp.u)
    annotation(Line(points={{-108,220},{-102,220}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedHp_actual, pumDedOnAndHeaHp.uPh)
    annotation(Line(
      points={{-220,240},{-144,240},{-144,200},{-104,200},{-104,214},{-102,214}},
      color={255,0,255}));
  connect(pumDedOnAndHeaHp.y, pumDedOnHea.u1)
    annotation(Line(points={{-78,220},{-62,220}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedPhp_actual, pumDedOnHea.u2)
    annotation(Line(
      points={{-220,220},{-184,220},{-184,196},{-66,196},{-66,212},{-62,212}},
      color={255,0,255}));
  connect(pumDedOnHea.y, ctlDpHeaWat.y1_actual)
    annotation(Line(points={{-38,220},{-30,220},{-30,272},{-22,272}},
      color={255,0,255}));
  connect(u1PumHeaWatPriHdr_actual, ctlDpHeaWat.y1_actual)
    annotation(Line(points={{-220,260},{-184,260},{-184,272},{-22,272}},
      color={255,0,255}));
  connect(u1PumChiWatPriHdr_actual, ctlDpChiWat.y1_actual)
    annotation(Line(points={{-220,200},{-188,200},{-188,172},{-22,172}},
      color={255,0,255}));
  connect(pumDedOnCoo.y, ctlDpChiWat.y1_actual)
    annotation(Line(points={{-38,120},{-30,120},{-30,172},{-22,172}},
      color={255,0,255}));
  connect(pumDedOnAndHeaHp2.y, pumDedOnCoo.u1)
    annotation(Line(points={{-78,120},{-62,120}},
      color={255,0,255}));
  connect(u1CooAndOnDedHp.y, pumDedOnAndHeaHp2.u)
    annotation(Line(points={{-108,120},{-102,120}},
      color={255,0,255}));
  connect(u1PumChiWatPriDedHp_actual, pumDedOnAndHeaHp2.uPh)
    annotation(Line(
      points={{-220,180},{-192,180},{-192,106},{-108,106},{-108,114},{-102,114}},
      color={255,0,255}));
  connect(u1PumChiWatPriDedPhp_actual, pumDedOnCoo.u2)
    annotation(Line(
      points={{-220,160},{-194,160},{-194,104},{-66,104},{-66,112},{-62,112}},
      color={255,0,255}));
  connect(latHea.y, selSpeHeaCooHp.u2)
    annotation(Line(points={{-88,-220},{-80,-220},{-80,0},{118,0}},
      color={255,0,255}));
  connect(phSpePumHeaWatPriHp.y, rep3.u)
    annotation(Line(points={{70,20},{78,20}},
      color={0,0,127}));
  connect(ctlDpHeaWat.y, phSpePumHeaWatPriHp.u)
    annotation(Line(points={{2,264},{40,264},{40,20},{46,20}},
      color={0,0,127}));
  connect(ctlDpChiWat.y, phSpePumChiWatPriHp.u)
    annotation(Line(points={{2,164},{34,164},{34,-20},{46,-20}},
      color={0,0,127}));
  connect(phSpePumChiWatPriHp.y, rep4.u)
    annotation(Line(points={{70,-20},{78,-20}},
      color={0,0,127}));
  connect(rep3.y, selSpeHeaCooHp.u1)
    annotation(Line(points={{102,20},{110,20},{110,8},{118,8}},
      color={0,0,127}));
  connect(rep4.y, selSpeHeaCooHp.u3)
    annotation(Line(points={{102,-20},{110,-20},{110,-8},{118,-8}},
      color={0,0,127}));
  connect(selSpeHeaCooHp.y, ph.u)
    annotation(Line(points={{142,0},{158,0}},
      color={0,0,127}));
  connect(rep3.y, ph.uPh)
    annotation(Line(points={{102,20},{150,20},{150,-6},{158,-6}},
      color={0,0,127}));
  connect(phSpePumHeaWatPriPhp.y, rep5.u)
    annotation(Line(points={{70,-60},{78,-60}},
      color={0,0,127}));
  connect(phSpePumChiWatPriPhp.y, rep6.u)
    annotation(Line(points={{70,-100},{78,-100}},
      color={0,0,127}));
  connect(ctlDpHeaWat.y, phSpePumHeaWatPriPhp.u)
    annotation(Line(points={{2,264},{40,264},{40,-60},{46,-60}},
      color={0,0,127}));
  connect(ctlDpChiWat.y, phSpePumChiWatPriPhp.u)
    annotation(Line(points={{2,164},{34,164},{34,-100},{46,-100}},
      color={0,0,127}));
  connect(phSpePumHeaWatPri.y, setPumHeaWatPriHdr.u1)
    annotation(Line(points={{72,140},{80,140},{80,128},{168,128}},
      color={0,0,127}));
  connect(ctlDpHeaWat.y, phSpePumHeaWatPri.u)
    annotation(Line(points={{2,264},{40,264},{40,140},{48,140}},
      color={0,0,127}));
  connect(phSpePumChiWatPri.y, setPumChiWatPriHdr.u1)
    annotation(Line(points={{72,80},{80,80},{80,68},{168,68}},
      color={0,0,127}));
  connect(ctlDpChiWat.y, phSpePumChiWatPri.u)
    annotation(Line(points={{2,164},{34,164},{34,80},{48,80}},
      color={0,0,127}));
  connect(ph.y, setPumHeaWatPriDedHp.u1)
    annotation(Line(
      points={{182,0},{188,0},{188,-100},{160,-100},{160,-112},{168,-112}},
      color={0,0,127}));
  connect(rep4.y, setPumChiWatPriDedHp.u1)
    annotation(Line(points={{102,-20},{110,-20},{110,-152},{168,-152}},
      color={0,0,127}));
  connect(u1PumChiWatPriDedHp, setPumChiWatPriDedHp.u2)
    annotation(Line(points={{-220,-120},{0,-120},{0,-160},{168,-160}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedHp, setPumHeaWatPriDedHp.u2)
    annotation(Line(points={{-220,-60},{4,-60},{4,-120},{168,-120}},
      color={255,0,255}));
  connect(setPumChiWatPriDedPhp.y, yPumChiWatPriDedPhp)
    annotation(Line(points={{192,-240},{220,-240}},
      color={0,0,127}));
  connect(setPumHeaWatPriDedPhp.y, yPumHeaWatPriDedPhp)
    annotation(Line(points={{192,-200},{220,-200}},
      color={0,0,127}));
  connect(u1PumHeaWatPriDedPhp, setPumHeaWatPriDedPhp.u2)
    annotation(Line(points={{-220,-80},{-4,-80},{-4,-200},{168,-200}},
      color={255,0,255}));
  connect(u1PumChiWatPriDedPhp, setPumChiWatPriDedPhp.u2)
    annotation(Line(points={{-220,-140},{-8,-140},{-8,-240},{168,-240}},
      color={255,0,255}));
  connect(rep.y, setPumChiWatPriDedHp.u3)
    annotation(Line(points={{72,-180},{160,-180},{160,-168},{168,-168}},
      color={0,0,127}));
  connect(zer.y, rep1.u)
    annotation(Line(points={{-28,-180},{30,-180},{30,-220},{48,-220}},
      color={0,0,127}));
  connect(rep1.y, setPumHeaWatPriDedPhp.u3)
    annotation(Line(points={{72,-220},{160,-220},{160,-208},{168,-208}},
      color={0,0,127}));
  connect(rep1.y, setPumChiWatPriDedPhp.u3)
    annotation(Line(points={{72,-220},{160,-220},{160,-248},{168,-248}},
      color={0,0,127}));
  connect(rep5.y, setPumHeaWatPriDedPhp.u1)
    annotation(Line(points={{102,-60},{140,-60},{140,-192},{168,-192}},
      color={0,0,127}));
  connect(rep6.y, setPumChiWatPriDedPhp.u1)
    annotation(Line(points={{102,-100},{120,-100},{120,-232},{168,-232}},
      color={0,0,127}));
annotation(defaultComponentName="ctlPumPri",
  Icon(coordinateSystem(preserveAspectRatio=true,
    extent={{-100,-220},{100,220}},
    grid={2,2}),
    graphics={Rectangle(extent={{-100,220},{100,-220}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,270},{150,230}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(extent={{-200,-280},{200,280}},
    grid={2,2}),
    graphics={Rectangle(extent={{-198,-144},{-60,-278}},
      lineColor={0,0,0},
      fillColor={215,215,215},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None),
    Text(extent={{-196,-240},{-60,-260}},
      textColor={0,0,255},
      horizontalAlignment=TextAlignment.Left,
      textString="Latch operating mode of associated
HP when the dedicated pump is enabled")}),
  Documentation(
    info="<html>
<h4>
  Plants with variable speed primary pumps that are not controlled to maintain
  differential pressure or flow setpoint
</h4>
<h5>Heating-only plants</h5>
<p>
  When commanded on, the primary HW pumps are commanded at a fixed speed
  <code>yPumHeaWatPriSet</code>, as determined during the Testing, Adjusting,
  and Balancing phase to provide the design heat pump flow.
</p>
<h5>Cooling-only plants</h5>
<p>
  When commanded on, the primary CHW pumps are commanded at a fixed speed
  <code>yPumChiWatPriSet</code>, as determined during the Testing, Adjusting,
  and Balancing phase to provide the design heat pump flow.
</p>
<h5>Heating and cooling plants with common primary CHW and HW pumps</h5>
<p>
  When commanded on, the primary pumps are commanded at a fixed speed
  <code>yPumHeaWatPriSet</code> in heating mode or
  <code>yPumChiWatPriSet</code> in cooling mode, as determined during the
  Testing, Adjusting, and Balancing phase to provide the design heat pump flow
  in heating mode or cooling mode. The operating mode of the associated heat
  pump is determined and latched at the time the pump is enabled.
</p>
<h5>Heating and cooling plants with separate primary CHW and HW pumps</h5>
<p>
  When commanded on, the primary HW pumps are commanded at a fixed speed
  <code>yPumHeaWatPriSet</code>. When commanded on, the primary CHW pumps are
  commanded at a fixed speed <code>yPumChiWatPriSet</code>. The pump speed
  <code>yPumHeaWatPriSet</code> or <code>yPumChiWatPriSet</code> is determined
  during the Testing, Adjusting, and Balancing phase to provide the design
  heat pump flow in heating mode or cooling mode.
</p>
<h4>
  Plants with variable speed primary pumps that are controlled to maintain
  differential pressure or flow setpoint
</h4>
<h5>Heating-only plants</h5>
<p>
  The pumps are controlled as described in
  <a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure\">
    Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure</a>.
  The \"pump proven on\" condition is evaluated based on the primary HW pump
  status.
</p>
<h5>Cooling-only plants</h5>
<p>
  The pumps are controlled as described in
  <a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure\">
    Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure</a>.
  The \"pump proven on\" condition is evaluated based on the primary CHW pump
  status.
</p>
<h5>Heating and cooling plants with common primary CHW and HW pumps</h5>
<p>
  The pumps are controlled as described in
  <a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure\">
    Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure</a>.
  For the HW loop, the \"pump proven on\" condition is evaluated based on the
  status of the primary pumps associated with heat pumps that are commanded in
  heating mode. For the CHW loop, the \"pump proven on\" condition is evaluated
  based on the status of the primary pumps associated with heat pumps that are
  commanded in cooling mode. The operating mode of the associated heat pump is
  determined and latched at the time the pump is enabled.
</p>
<h5>Heating and cooling plants with separate primary CHW and HW pumps</h5>
<p>
  The pumps are controlled as described in
  <a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure\">
    Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure</a>.
  For the HW loop, the \"pump proven on\" condition is evaluated based on the
  status of the primary HW pumps. For the CHW loop, the \"pump proven on\"
  condition is evaluated based on the status of the primary CHW pumps.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    May 31, 2024, by Antoine Gautier:<br />
    Added logic for ∆p-controlled primary pumps and latching of HP operating
    mode.
  </li>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end VariableSpeedHeatPumps;
