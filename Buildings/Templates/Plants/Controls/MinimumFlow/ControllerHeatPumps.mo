within Buildings.Templates.Plants.Controls.MinimumFlow;
block ControllerHeatPumps
  "CHW and/or HW minimum flow bypass valve controller for heat pump plants"
  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation(Evaluate=true);
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation(Evaluate=true);
  parameter Boolean have_pumPriHdr
    "Set to true for headered primary pumps, false for dedicated pumps"
    annotation(Evaluate=true);
  parameter Boolean have_pumChiWatPriDedHp(start=false)
    "Set to true for HP with separate dedicated primary pumps for CHW and HW circuits"
    annotation(Evaluate=true,
      Dialog(enable=not have_pumPriHdr and nHp > 0));
  // Use isolation valve command if valves are present and for:
  // - HP with dedicated pumps serving both CHW and HW loops
  // - Headered primary pumps
  final parameter Boolean use_valEqu[nEqu] = {(have_valInlIso or have_valOutIso)
    and (not have_pumPriHdr and i <= nHp and not have_pumChiWatPriDedHp
      or have_pumPriHdr) for i in 1:nEqu}
    "Set to true to use isolation valve command to enable control loop – Each unit"
    annotation(Evaluate=true);
  final parameter Boolean use_val = (have_valInlIso or have_valOutIso)
    and (not have_pumPriHdr and nHp > 0 and not have_pumChiWatPriDedHp
      or have_pumPriHdr)
    "Set to true to use isolation valve command to enable control loop – Any unit"
    annotation(Evaluate=true);
  // Use dedicated primary pump status for:
  // - HP with dedicated pumps serving both CHW and HW loops
  //  (valve may be open when HP disabled for expansion/contraction of water)
  // - HP with dedicated pumps, one per CHW and HW loop
  // - PHP with dedicated pumps
  // Resolves to any configuration with dedicated pumps.
  final parameter Boolean use_pumPriDedEqu[nEqu] =
    {not have_pumPriHdr for i in 1:nEqu}
    "Set to true to use dedicated primary pump status to enable control loop – Each unit"
    annotation(Evaluate=true);
  final parameter Boolean use_pumPriDed = not have_pumPriHdr
    "Set to true to use dedicated primary pump status to enable control loop – Any unit"
    annotation(Evaluate=true);
  parameter Integer nHp
    "Number of 2-pipe heat pumps"
    annotation(Evaluate=true);
  parameter Integer nPhp
    "Number of polyvalent heat pumps"
    annotation(Evaluate=true);
  final parameter Integer nEqu = nHp + nPhp
    "Heating or cooling equipment count"
    annotation(Evaluate=true);
  parameter Boolean have_valInlIso
    "Set to true if inlet isolation valves are present"
    annotation(Evaluate=true);
  parameter Boolean have_valOutIso
    "Set to true if outlet isolation valves are present"
    annotation(Evaluate=true);
  parameter Real VHeaWat_flow_nominal[nEqu](
    start=fill(0, nEqu),
    unit=fill("m3/s", nEqu))
    "Design HW flow rate – Each unit"
    annotation(Dialog(enable=have_heaWat));
  parameter Real VHeaWat_flow_min[nEqu](
    start=fill(0, nEqu),
    unit=fill("m3/s", nEqu))
    "Minimum HW flow rate – Each unit"
    annotation(Dialog(enable=have_heaWat));
  parameter Real VChiWat_flow_nominal[nEqu](
    start=fill(0, nEqu),
    unit=fill("m3/s", nEqu))
    "Design CHW flow rate – Each unit"
    annotation(Dialog(enable=have_chiWat));
  parameter Real VChiWat_flow_min[nEqu](
    start=fill(0, nEqu),
    unit=fill("m3/s", nEqu))
    "Minimum CHW flow rate – Each unit"
    annotation(Dialog(enable=have_chiWat));
  parameter Real k(min=0) = 1 "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(
    min=Buildings.Controls.OBC.CDL.Constants.small) = 0.5
    "Time constant of integrator block";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriDedHp_actual[nHp]
    if have_heaWat and nHp > 0 and not have_pumPriHdr
    "Primary HW pump status – HP dedicated pumps"
    annotation(Placement(transformation(extent={{-200,-60},{-160,-20}}),
      iconTransformation(extent={{-140,-18},{-100,22}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriDedPhp_actual[nPhp]
    if have_heaWat and nPhp > 0 and not have_pumPriHdr
    "Primary HW pump status – Polyvalent HP dedicated pumps"
    annotation(Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,-38},{-100,2}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWatPri_flow(
    final unit="m3/s")
    if have_chiWat
    "Primary CHW volume flow rate"
    annotation(Placement(transformation(extent={{-200,-200},{-160,-160}}),
      iconTransformation(extent={{-140,-138},{-100,-98}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHeaWatPri_flow(
    final unit="m3/s")
    if have_heaWat
    "Primary HW volume flow rate"
    annotation(Placement(transformation(extent={{-200,-180},{-160,-140}}),
      iconTransformation(extent={{-140,-118},{-100,-78}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValHeaWatInlIso[nEqu]
    if have_heaWat and have_valInlIso
    "Inlet HW isolation valve command"
    annotation(Placement(transformation(extent={{-200,60},{-160,100}}),
      iconTransformation(extent={{-140,82},{-100,122}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValHeaWatOutIso[nEqu]
    if have_heaWat and have_valOutIso
    "Outlet HW isolation valve command"
    annotation(Placement(transformation(extent={{-200,40},{-160,80}}),
      iconTransformation(extent={{-140,62},{-100,102}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValHeaWatMinByp(
    final unit="1")
    if have_heaWat
    "HW minimum flow bypass valve command"
    annotation(Placement(transformation(extent={{160,40},{200,80}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hp[nHp]
    if nHp > 0
    "HP enable command"
    annotation(Placement(transformation(extent={{-200,160},{-160,200}}),
      iconTransformation(extent={{-140,122},{-100,162}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VHeaWatPriSet_flow(
    final unit="m3/s")
    if have_heaWat
    "Primary HW flow setpoint"
    annotation(Placement(transformation(extent={{160,80},{200,120}}),
      iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaHp[nHp]
    if have_heaWat and have_chiWat and nHp > 0
    "HP heating mode command"
    annotation(Placement(transformation(extent={{-200,140},{-160,180}}),
      iconTransformation(extent={{-140,102},{-100,142}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValChiWatInlIso[nEqu]
    if have_chiWat and have_valInlIso
    "Inlet CHW isolation valve command"
    annotation(Placement(transformation(extent={{-200,20},{-160,60}}),
      iconTransformation(extent={{-140,42},{-100,82}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValChiWatOutIso[nEqu]
    if have_chiWat and have_valOutIso
    "Outlet CHW isolation valve command"
    annotation(Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,22},{-100,62}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValChiWatMinByp(
    final unit="1")
    if have_chiWat
    "CHW minimum flow bypass valve command"
    annotation(Placement(transformation(extent={{160,-80},{200,-40}}),
      iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VChiWatPriSet_flow(
    final unit="m3/s")
    if have_chiWat
    "Primary CHW flow setpoint"
    annotation(Placement(transformation(extent={{160,-40},{200,0}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Controller ctlFloMinHeaWat(
    final use_val=use_val,
    final use_valEqu=use_valEqu,
    final use_pumPriDed=use_pumPriDed,
    final use_pumPriDedEqu=use_pumPriDedEqu,
    final V_flow_nominal=VHeaWat_flow_nominal,
    final V_flow_min=VHeaWat_flow_min,
    final k=k,
    final Ti=Ti,
    final nEqu=nEqu)
    if have_heaWat
    "HW minimum flow control"
    annotation(Placement(transformation(extent={{112,-10},{132,10}})));
  Controller ctlFloMinChiWat(
    final use_val=use_val,
    final use_valEqu=use_valEqu,
    final use_pumPriDed=use_pumPriDed,
    final use_pumPriDedEqu=use_pumPriDedEqu,
    final V_flow_nominal=VChiWat_flow_nominal,
    final V_flow_min=VChiWat_flow_min,
    final k=k,
    final Ti=Ti,
    final nEqu=nEqu)
    if have_chiWat
    "CHW minimum flow control"
    annotation(Placement(transformation(extent={{110,-70},{130,-50}})));
  Utilities.PlaceholderLogical phHeaCooHp[nHp](
    each final have_inp=have_heaWat and have_chiWat,
    each final have_inpPh=false,
    each final u_internal=have_heaWat)
    if nHp > 0
    "Placeholder signal for single mode applications"
    annotation(Placement(transformation(extent={{-150,150},{-130,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not u1CooHp[nHp]
    if have_chiWat and nHp > 0
    "True if HP in cooling mode"
    annotation(Placement(transformation(extent={{-110,102},{-90,122}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHeaHp[nHp]
    if have_heaWat and nHp > 0
    "True if HP commanded on in heating mode"
    annotation(Placement(transformation(extent={{-60,170},{-40,190}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndCooHp[nHp]
    if have_chiWat and nHp > 0
    "True if HP commanded on in cooling mode"
    annotation(Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Logical.And pumDedOnAndCooHp[nHp]
    if have_heaWat
      and have_chiWat
      and nHp > 0
      and not have_pumPriHdr
      and not have_pumChiWatPriDedHp
    "Dedicated pump on and cooling mode – HP with common CHW and HW pumps"
    annotation(Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And pumDedOnAndHeaHp[nHp]
    if have_heaWat
      and have_chiWat
      and nHp > 0
      and not have_pumPriHdr
      and not have_pumChiWatPriDedHp
    "Dedicated pump on and HP in heating mode – HP with common CHW and HW pump"
    annotation(Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaPhp[nPhp]
    if nPhp > 0
    "Polyvalent HP heating mode command"
    annotation(Placement(transformation(extent={{-200,120},{-160,160}}),
      iconTransformation(extent={{-140,102},{-100,142}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooPhp[nPhp]
    if nPhp > 0
    "Polyvalent HP cooling mode command"
    annotation(Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,102},{-100,142}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriDedHp_actual[nHp]
    if have_chiWat and nHp > 0 and not have_pumPriHdr and have_pumChiWatPriDedHp
    "Primary CHW pump status – HP dedicated pumps"
    annotation(Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,-78},{-100,-38}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriDedPhp_actual[nPhp]
    if have_chiWat and not have_pumPriHdr and nPhp > 0
    "Primary CHW pump status – Polyvalent HP dedicated pumps"
    annotation(Placement(transformation(extent={{-200,-140},{-160,-100}}),
      iconTransformation(extent={{-140,-98},{-100,-58}})));
  Utilities.PlaceholderLogical phValHeaWatInlIso[nEqu](
    each final have_inp=have_valInlIso,
    each final have_inpPh=false,
    each final u_internal=false)
    if have_heaWat
    "Placeholder signal"
    annotation(Placement(transformation(extent={{-150,70},{-130,90}})));
  Utilities.PlaceholderLogical phValHeaWatOutIso[nEqu](
    each final have_inp=have_valOutIso,
    each final have_inpPh=false,
    each final u_internal=false)
    if have_heaWat
    "Placeholder signal"
    annotation(Placement(transformation(extent={{-110,50},{-90,70}})));
  Buildings.Controls.OBC.CDL.Logical.Or valHeaWatInlOrOutIso[nEqu]
    if have_heaWat
    "Inlet or outlet HW isolation valve commanded open"
    annotation(Placement(transformation(extent={{60,70},{80,90}})));
  Utilities.PlaceholderLogical phValChiWatInlIso[nEqu](
    each final have_inp=have_valInlIso,
    each final have_inpPh=false,
    each final u_internal=false)
    if have_chiWat
    "Placeholder signal"
    annotation(Placement(transformation(extent={{-150,30},{-130,50}})));
  Utilities.PlaceholderLogical phValChiWatOutIso[nEqu](
    each final have_inp=have_valOutIso,
    each final have_inpPh=false,
    each final u_internal=false)
    if have_chiWat
    "Placeholder signal"
    annotation(Placement(transformation(extent={{-110,10},{-90,30}})));
  Buildings.Controls.OBC.CDL.Logical.Or valChiWatInlOrOutIso[nEqu]
    if have_chiWat
    "Inlet or outlet CHW isolation valve commanded open"
    annotation(Placement(transformation(extent={{60,30},{80,50}})));
  Utilities.ConcatenateSelectLogical pumDedOnCoo(
    final have_u1=nHp > 0,
    final have_u2=nPhp > 0,
    nin2=nPhp,
    nin1=nHp)
    if have_chiWat and not have_pumPriHdr
    "Dedicated pump on and cooling mode"
    annotation(Placement(transformation(extent={{0,-90},{20,-70}})));
  Utilities.ConcatenateSelectLogical pumDedOnHeaHpPhp(
    final have_u1=nHp > 0,
    final have_u2=nPhp > 0,
    nin2=nPhp,
    nin1=nHp)
    if have_heaWat and not have_pumPriHdr
    "Dedicated pump on and heating mode"
    annotation(Placement(transformation(extent={{0,-30},{20,-10}})));
  Utilities.PlaceholderLogical pumDedOnAndHeaHp1[nHp](
    each final have_inp=have_heaWat
      and have_chiWat
      and nHp > 0
      and not have_pumPriHdr
      and not have_pumChiWatPriDedHp,
    each final have_inpPh=true)
    if have_heaWat and not have_pumPriHdr and nHp > 0
    "Dedicated pump on and heating mode – HP"
    annotation(Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Utilities.PlaceholderLogical pumDedOnAndHeaHp2[nHp](
    each final have_inp=have_heaWat
      and have_chiWat
      and nHp > 0
      and not have_pumPriHdr
      and not have_pumChiWatPriDedHp,
    each final have_inpPh=true)
    if have_chiWat and not have_pumPriHdr and nHp > 0
    "Dedicated pump on and heating mode – HP"
    annotation(Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Utilities.ConcatenateSelectLogical onAndHea(
    final have_u1=nHp > 0,
    final have_u2=nPhp > 0,
    final nin2=nPhp,
    final nin1=nHp)
    if have_heaWat
    "Heating mode enable"
    annotation(Placement(transformation(extent={{0,170},{20,190}})));
  Utilities.ConcatenateSelectLogical onAndCoo(
    final have_u1=nHp > 0,
    final have_u2=nPhp > 0,
    final nin2=nPhp,
    final nin1=nHp)
    if have_chiWat
    "Cooling mode enable"
    annotation(Placement(transformation(extent={{0,110},{20,130}})));
equation
  connect(ctlFloMinHeaWat.y, yValHeaWatMinByp)
    annotation(Line(points={{134,0},{150,0},{150,60},{180,60}},
      color={0,0,127}));
  connect(ctlFloMinHeaWat.VPriSet_flow, VHeaWatPriSet_flow)
    annotation(Line(points={{134,6},{140,6},{140,100},{180,100}},
      color={0,0,127}));
  connect(ctlFloMinChiWat.y, yValChiWatMinByp)
    annotation(Line(points={{132,-60},{180,-60}},
      color={0,0,127}));
  connect(ctlFloMinChiWat.VPriSet_flow, VChiWatPriSet_flow)
    annotation(Line(points={{132,-54},{140,-54},{140,-20},{180,-20}},
      color={0,0,127}));
  connect(u1HeaHp, phHeaCooHp.u)
    annotation(Line(points={{-180,160},{-152,160}},
      color={255,0,255}));
  connect(phHeaCooHp.y, u1CooHp.u)
    annotation(Line(points={{-128,160},{-120,160},{-120,112},{-112,112}},
      color={255,0,255}));
  connect(u1Hp, onAndHeaHp.u1)
    annotation(Line(points={{-180,180},{-62,180}},
      color={255,0,255}));
  connect(VChiWatPri_flow, ctlFloMinChiWat.VPri_flow)
    annotation(Line(points={{-180,-180},{100,-180},{100,-64},{108,-64}},
      color={0,0,127}));
  connect(VHeaWatPri_flow, ctlFloMinHeaWat.VPri_flow)
    annotation(Line(points={{-180,-160},{98,-160},{98,-4},{110,-4}},
      color={0,0,127}));
  connect(u1CooHp.y, onAndCooHp.u2)
    annotation(Line(points={{-88,112},{-62,112}},
      color={255,0,255}));
  connect(u1CooHp.y, pumDedOnAndCooHp.u1)
    annotation(Line(points={{-88,112},{-80,112},{-80,-80},{-72,-80}},
      color={255,0,255}));
  connect(phHeaCooHp.y, onAndHeaHp.u2)
    annotation(Line(points={{-128,160},{-120,160},{-120,172},{-62,172}},
      color={255,0,255}));
  connect(phHeaCooHp.y, pumDedOnAndHeaHp.u1)
    annotation(Line(points={{-128,160},{-120,160},{-120,-20},{-72,-20}},
      color={255,0,255}));
  connect(u1Hp, onAndCooHp.u1)
    annotation(Line(points={{-180,180},{-80,180},{-80,120},{-62,120}},
      color={255,0,255}));
  connect(u1ValHeaWatInlIso, phValHeaWatInlIso.u)
    annotation(Line(points={{-180,80},{-152,80}},
      color={255,0,255}));
  connect(u1ValHeaWatOutIso, phValHeaWatOutIso.u)
    annotation(Line(points={{-180,60},{-112,60}},
      color={255,0,255}));
  connect(phValHeaWatInlIso.y, valHeaWatInlOrOutIso.u1)
    annotation(Line(points={{-128,80},{58,80}},
      color={255,0,255}));
  connect(phValHeaWatOutIso.y, valHeaWatInlOrOutIso.u2)
    annotation(Line(points={{-88,60},{40,60},{40,72},{58,72}},
      color={255,0,255}));
  connect(valHeaWatInlOrOutIso.y, ctlFloMinHeaWat.u1ValIso)
    annotation(Line(points={{82,80},{92,80},{92,4},{110,4}},
      color={255,0,255}));
  connect(u1ValChiWatInlIso, phValChiWatInlIso.u)
    annotation(Line(points={{-180,40},{-152,40}},
      color={255,0,255}));
  connect(u1ValChiWatOutIso, phValChiWatOutIso.u)
    annotation(Line(points={{-180,20},{-112,20}},
      color={255,0,255}));
  connect(phValChiWatInlIso.y, valChiWatInlOrOutIso.u1)
    annotation(Line(points={{-128,40},{58,40}},
      color={255,0,255}));
  connect(phValChiWatOutIso.y, valChiWatInlOrOutIso.u2)
    annotation(Line(points={{-88,20},{40,20},{40,32},{58,32}},
      color={255,0,255}));
  connect(valChiWatInlOrOutIso.y, ctlFloMinChiWat.u1ValIso)
    annotation(Line(points={{82,40},{88,40},{88,-56},{108,-56}},
      color={255,0,255}));
  connect(u1PumChiWatPriDedPhp_actual, pumDedOnCoo.u2)
    annotation(Line(points={{-180,-120},{-10,-120},{-10,-88},{-2,-88}},
      color={255,0,255}));
  connect(pumDedOnCoo.y, ctlFloMinChiWat.u1PumPri_actual)
    annotation(Line(points={{22,-80},{94,-80},{94,-60},{108,-60}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedPhp_actual, pumDedOnHeaHpPhp.u2)
    annotation(Line(points={{-180,-60},{-10,-60},{-10,-28},{-2,-28}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedHp_actual, pumDedOnAndHeaHp.u2)
    annotation(Line(points={{-180,-40},{-140,-40},{-140,-28},{-72,-28}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedHp_actual, pumDedOnAndCooHp.u2)
    annotation(Line(points={{-180,-40},{-140,-40},{-140,-88},{-72,-88}},
      color={255,0,255}));
  connect(pumDedOnHeaHpPhp.y, ctlFloMinHeaWat.u1PumPri_actual)
    annotation(Line(points={{22,-20},{84,-20},{84,0},{110,0}},
      color={255,0,255}));
  connect(pumDedOnAndHeaHp.y, pumDedOnAndHeaHp1.u)
    annotation(Line(points={{-48,-20},{-42,-20}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedHp_actual, pumDedOnAndHeaHp1.uPh)
    annotation(Line(points={{-180,-40},{-46,-40},{-46,-26},{-42,-26}},
      color={255,0,255}));
  connect(pumDedOnAndHeaHp1.y, pumDedOnHeaHpPhp.u1)
    annotation(Line(points={{-18,-20},{-2,-20}},
      color={255,0,255}));
  connect(pumDedOnAndHeaHp2.y, pumDedOnCoo.u1)
    annotation(Line(points={{-18,-80},{-2,-80}},
      color={255,0,255}));
  connect(u1PumChiWatPriDedHp_actual, pumDedOnAndHeaHp2.uPh)
    annotation(Line(points={{-180,-100},{-46,-100},{-46,-86},{-42,-86}},
      color={255,0,255}));
  connect(pumDedOnAndCooHp.y, pumDedOnAndHeaHp2.u)
    annotation(Line(points={{-48,-80},{-42,-80}},
      color={255,0,255}));
  connect(onAndHeaHp.y, onAndHea.u1)
    annotation(Line(points={{-38,180},{-2,180}},
      color={255,0,255}));
  connect(u1HeaPhp, onAndHea.u2)
    annotation(Line(points={{-180,140},{-20,140},{-20,172},{-2,172}},
      color={255,0,255}));
  connect(onAndHea.y, ctlFloMinHeaWat.u1Equ)
    annotation(Line(points={{22,180},{100,180},{100,8},{110,8}},
      color={255,0,255}));
  connect(onAndCooHp.y, onAndCoo.u1)
    annotation(Line(points={{-38,120},{-2,120}},
      color={255,0,255}));
  connect(onAndCoo.y, ctlFloMinChiWat.u1Equ)
    annotation(Line(points={{22,120},{96,120},{96,-52},{108,-52}},
      color={255,0,255}));
  connect(u1CooPhp, onAndCoo.u2)
    annotation(Line(
      points={{-180,120},{-140,120},{-140,100},{-20,100},{-20,112},{-2,112}},
      color={255,0,255}));
annotation(defaultComponentName="ctlFloMin",
  Icon(coordinateSystem(preserveAspectRatio=true,
    extent={{-100,-160},{100,160}},
    grid={2,2}),
    graphics={Rectangle(extent={{-100,162},{100,-160}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,212},{150,172}},
      textString="%name",
      textColor={0,0,255})}),
  Documentation(
    revisions="<html>
<ul>
  <li>
    July 10, 2026, by Antoine Gautier:<br />
    Renamed from <code>ControllerDualMode</code> and refactored to support
    plants with polyvalent heat pumps.<br />
    This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4512\">#4512</a>.
  </li>
  <li>
    May 31, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>",
    info="<html>
<h4>HW minimum flow</h4>
<p>
  The HW minimum flow bypass valve is modulated based on a reverse acting
  control loop to maintain the primary HW flow rate at setpoint. The setpoint
  is calculated as described in
  <a href=\"modelica://Buildings.Templates.Plants.Controls.MinimumFlow.Setpoint\">
    Buildings.Templates.Plants.Controls.MinimumFlow.Setpoint</a> using the
  number of units commanded on <i>in heating mode</i> at each stage.
</p>
<p>
  <b>When using isolation valve command signals</b>
  (<code>have_valInlIso=true</code> or <code>have_valOutIso=true</code>): When
  any HW isolation valve is commanded open, the HW bypass valve control loop
  is enabled. The valve is opened <i>100&nbsp;%</i> otherwise. When enabled,
  the HW bypass valve loop shall be biased to start with the valve
  <i>100&nbsp;%</i> open.
</p>
<p>
  <b>Otherwise</b>
  (<code>have_valInlIso=false</code> and <code>have_valOutIso=false</code>):
</p>
<ul>
  <li>
    <b
      >For heating and cooling plants with common dedicated CHW and HW
      pumps</b
    >: When any primary pump is proven on and the associated heat pump is
    commanded in heating mode, the HW bypass valve control loop is enabled.
    The valve is opened <i>100&nbsp;%</i> otherwise. When enabled, the HW
    bypass valve loop shall be biased to start with the valve
    <i>100&nbsp;%</i> open.
  </li>
  <li>
    <b>For any other plants</b>: When any primary HW pump is proven on, the HW
    bypass valve control loop is enabled. The valve is opened
    <i>100&nbsp;%</i> otherwise. When enabled, the HW bypass valve loop shall
    be biased to start with the valve <i>100&nbsp;%</i> open.
  </li>
</ul>
<h4>CHW minimum flow</h4>
<p>
  The CHW minimum flow bypass valve is modulated based on a reverse acting
  control loop to maintain the primary CHW flow rate at setpoint. The setpoint
  is calculated as described in
  <a href=\"modelica://Buildings.Templates.Plants.Controls.MinimumFlow.Setpoint\">
    Buildings.Templates.Plants.Controls.MinimumFlow.Setpoint</a> using the
  number of units commanded on <i>in cooling mode</i> at each stage.
</p>
<p>
  <b>When using isolation valve command signals</b>
  (<code>have_valInlIso=true</code> or <code>have_valOutIso=true</code>): When
  any CHW isolation valve is commanded open, the CHW bypass valve control loop
  is enabled. The valve is opened <i>100&nbsp;%</i> otherwise. When enabled,
  the CHW bypass valve loop shall be biased to start with the valve
  <i>100&nbsp;%</i> open.
</p>
<p>
  <b>Otherwise</b>
  (<code>have_valInlIso=false</code> and <code>have_valOutIso=false</code>):
</p>
<ul>
  <li>
    <b
      >For heating and cooling plants with common dedicated CHW and HW
      pumps</b
    >: When any primary pump is proven on and the associated heat pump is
    commanded in cooling mode, the CHW bypass valve control loop is enabled.
    The valve is opened <i>100&nbsp;%</i> otherwise. When enabled, the CHW
    bypass valve loop shall be biased to start with the valve
    <i>100&nbsp;%</i> open.
  </li>
  <li>
    <b>For any other plants</b>: When any primary CHW pump is proven on, the
    CHW bypass valve control loop is enabled. The valve is opened
    <i>100&nbsp;%</i> otherwise. When enabled, the CHW bypass valve loop shall
    be biased to start with the valve <i>100&nbsp;%</i> open.
  </li>
</ul>
</html>"),
  Diagram(coordinateSystem(extent={{-160,-200},{160,200}})));
end ControllerHeatPumps;
