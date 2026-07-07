within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences;
block EventSequencingMultiple
  "Staging event sequencing for multiple heat pumps"
  parameter Integer nHp
    "Number of heat pumps"
    annotation(Evaluate=true);
  parameter Integer nPhp
    "Number of polyvalent eat pumps"
    annotation(Evaluate=true);
  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation(Evaluate=true);
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation(Evaluate=true);
  parameter Boolean have_valHpInlIso(start=false)
    "Set to true for plants with isolation valves at heat pump inlet"
    annotation(Evaluate=true,
      Dialog(enable=nHp > 0));
  parameter Boolean have_valHpOutIso(start=false)
    "Set to true for plants with isolation valves at heat pump outlet"
    annotation(Evaluate=true,
      Dialog(enable=nHp > 0));
  parameter Boolean have_valPhpInlIso(start=false)
    "Set to true for isolation valves at polyvalent HP inlet"
    annotation(Evaluate=true,
      Dialog(enable=nPhp > 0));
  parameter Boolean have_valPhpOutIso(start=false)
    "Set to true for isolation valves at polyvalent HP outlet"
    annotation(Evaluate=true,
      Dialog(enable=nPhp > 0));
  parameter Boolean have_pumPriHdr
    "Set to true for plants with headered primary pumps"
    annotation(Evaluate=true);
  parameter Boolean have_pumChiWatPriDedHp(start=false)
    "Set to true for HP with separate dedicated primary pumps for CHW and HW circuits"
    annotation(Evaluate=true,
      Dialog(enable=have_chiWat and nHp > 0));
  parameter Integer nPumHeaWatPri
    "Number of primary HW pumps"
    annotation(Evaluate=true);
  parameter Integer nPumChiWatPri
    "Number of primary CHW pumps"
    annotation(Evaluate=true);
  parameter Real dtVal(min=0, start=90, unit="s") = 90
    "Nominal valve timing"
    annotation(Dialog(
      enable=nHp > 0 and (have_valHpInlIso or have_valHpOutIso)
        or nPhp > 0 and (have_valPhpInlIso or have_valPhpOutIso)));
  parameter Real dtOff(min=0, unit="s") = 180
    "Heat pump internal shutdown cycle timing";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ShcPhp[nPhp]
    if nPhp > 0 "SHC enable command – Polyvalent HP"
    annotation(Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaHpPhp[nHp + nPhp]
    if have_heaWat
    "Heating enable command – HP or polyvalent HP (single mode)"
    annotation(Placement(transformation(extent={{-160,60},{-120,100}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriDed_actual[nPumHeaWatPri]
    if have_heaWat and not have_pumPriHdr
    "Dedicated primary HW pump status"
    annotation(Placement(transformation(extent={{-160,-40},{-120,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriDed_actual[nPumChiWatPri]
    if have_chiWat and not have_pumPriHdr or have_pumChiWatPriDedHp
    "Dedicated primary CHW pump status"
    annotation(Placement(transformation(extent={{-160,-60},{-120,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatInlIso[nHp +
    nPhp]
    if have_heaWat and (have_valHpInlIso or have_valPhpInlIso)
    "Inlet HW isolation valve command"
    annotation(Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatOutIso[nHp +
    nPhp]
    if have_heaWat and (have_valHpOutIso or have_valPhpOutIso)
    "Outlet HW isolation valve command"
    annotation(Placement(transformation(extent={{120,-40},{160,0}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatInlIso[nHp +
    nPhp]
    if have_chiWat and (have_valHpInlIso or have_valPhpInlIso)
    "Inlet CHW isolation valve command"
    annotation(Placement(transformation(extent={{120,-60},{160,-20}}),
      iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatOutIso[nHp +
    nPhp]
    if have_chiWat and (have_valHpOutIso or have_valPhpOutIso)
    "Outlet CHW isolation valve command"
    annotation(Placement(transformation(extent={{120,-80},{160,-40}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatPri[nHp + nPhp]
    "Primary HW pump request to pump staging logic"
    annotation(Placement(transformation(extent={{120,-100},{160,-60}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatPri[nHp + nPhp]
    "Primary CHW pump request to pump staging logic"
    annotation(Placement(transformation(extent={{120,-120},{160,-80}}),
      iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hp[nHp]
    if nHp > 0
    "Heat pump enable command"
    annotation(Placement(transformation(extent={{120,60},{160,100}}),
      iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaHp[nHp]
    if have_heaWat and have_chiWat and nHp > 0
    "Heat pump heating mode command"
    annotation(Placement(transformation(extent={{120,40},{160,80}}),
      iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooHpPhp[nHp + nPhp]
    if have_chiWat
    "Cooling enable command – HP or polyvalent HP (single mode)"
    annotation(Placement(transformation(extent={{-160,40},{-120,80}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaPhp[nPhp]
    if nPhp > 0
    "Polyvalent HP heating on/off command"
    annotation(Placement(transformation(extent={{120,20},{160,60}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooPhp[nPhp]
    if nPhp > 0
    "Polyvalent HP cooling on/off command"
    annotation(Placement(transformation(extent={{120,0},{160,40}}),
      iconTransformation(extent={{100,40},{140,80}})));
  EventSequencingSingle seqEveHp[nHp](
    each final is_php=false,
    each final have_heaWat=have_heaWat,
    each final have_chiWat=have_chiWat,
    each final have_valInlIso=have_valHpInlIso,
    each final have_valOutIso=have_valHpOutIso,
    each final have_pumHeaWatPri=have_heaWat,
    each final have_pumChiWatPri=have_chiWat and have_pumPriHdr
      or have_pumChiWatPriDedHp,
    each final dtVal=dtVal,
    each final dtOff=dtOff)
    if nHp > 0
    "HP event sequencing"
    annotation(Placement(transformation(extent={{-20,40},{0,68}})));
  EventSequencingSingle seqEvePhp[nPhp](
    each final is_php=true,
    each final have_heaWat=have_heaWat,
    each final have_chiWat=have_chiWat,
    each final have_valInlIso=have_valPhpInlIso,
    each final have_valOutIso=have_valPhpOutIso,
    each final have_pumHeaWatPri=have_heaWat,
    each final have_pumChiWatPri=have_chiWat,
    each final dtVal=dtVal,
    each final dtOff=dtOff)
    if nPhp > 0
    "Polyvalent HP event sequencing"
    annotation(Placement(transformation(extent={{-20,-68},{0,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriHdr_actual
    if have_heaWat and have_pumPriHdr
    "Lead headered primary HW pump status"
    annotation(Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriHdr_actual
    if have_chiWat and have_pumPriHdr
    "Lead headered primary CHW pump status"
    annotation(Placement(transformation(extent={{-160,-100},{-120,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Utilities.ConcatenateParameterLogical u1PumHeaWatPriDed_internal(
    final nin1=nPumHeaWatPri,
    final is_app=false,
    final new=fill(false, max(0, nHp + nPhp - nPumHeaWatPri)))
    if have_heaWat and not have_pumPriHdr
    "Prepend with false if nHp+nPhp > nPum"
    annotation(Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Utilities.ConcatenateParameterLogical u1PumChiWatPriDed_internal(
    final nin1=nPumChiWatPri,
    final is_app=false,
    final new=fill(false, max(0, nHp + nPhp - nPumChiWatPri)))
    if have_chiWat
      and (not have_pumPriHdr and nPhp > 0 or have_pumChiWatPriDedHp)
    "Prepend with false if nHp+nPhp > nPum"
    annotation(Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator u1PumHeaWatPriHdr_internal(
    final nout=nHp + nPhp)
    if have_heaWat and have_pumPriHdr
    "Replicate"
    annotation(Placement(transformation(extent={{-108,-70},{-88,-50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator u1PumChiWatPriHdr_internal(
    final nout=nHp + nPhp)
    if have_chiWat and have_pumPriHdr
    "Replicate"
    annotation(Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(u1HeaHpPhp[1:nHp], seqEveHp.u1Hea)
    annotation(Line(points={{-140,80},{-26,80},{-26,66},{-22,66}},
      color={255,0,255}));
  connect(u1CooHpPhp[1:nHp], seqEveHp.u1Coo)
    annotation(Line(points={{-140,60},{-30,60},{-30,64},{-22,64}},
      color={255,0,255}));
  connect(seqEveHp.y1, y1Hp)
    annotation(Line(points={{2,66},{80,66},{80,80},{140,80}},
      color={255,0,255}));
  connect(seqEveHp.y1Hea, y1HeaHp)
    annotation(Line(points={{2,64},{80,64},{80,60},{140,60}},
      color={255,0,255}));
  connect(u1HeaHpPhp[nHp + 1:nHp + nPhp], seqEvePhp.u1Hea)
    annotation(Line(points={{-140,80},{-26,80},{-26,-42},{-22,-42}},
      color={255,0,255}));
  connect(u1CooHpPhp[nHp + 1:nHp + nPhp], seqEvePhp.u1Coo)
    annotation(Line(points={{-140,60},{-30,60},{-30,-44},{-22,-44}},
      color={255,0,255}));
  connect(u1ShcPhp, seqEvePhp.u1Shc)
    annotation(Line(points={{-140,40},{-42,40},{-42,-46},{-22,-46}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDed_actual, u1PumHeaWatPriDed_internal.u1)
    annotation(Line(points={{-140,-20},{-112,-20}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDed_internal.y[1:nHp], seqEveHp.u1PumHeaWatPri_actual)
    annotation(Line(points={{-88,-20},{-38,-20},{-38,54},{-22,54}},
      color={255,0,255}));
  connect(u1PumChiWatPriDed_actual, u1PumChiWatPriDed_internal.u1)
    annotation(Line(points={{-140,-40},{-82,-40}},
      color={255,0,255}));
  connect(u1PumChiWatPriDed_internal.y[nHp + 1:nHp +
    nPhp], seqEvePhp.u1PumChiWatPri_actual)
    annotation(Line(points={{-58,-40},{-34,-40},{-34,-56},{-22,-56}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDed_internal.y[nHp + 1:nHp +
    nPhp], seqEvePhp.u1PumHeaWatPri_actual)
    annotation(Line(points={{-88,-20},{-38,-20},{-38,-54},{-22,-54}},
      color={255,0,255}));
  connect(u1PumChiWatPriDed_internal.y[1:nHp], seqEveHp.u1PumChiWatPri_actual)
    annotation(Line(points={{-58,-40},{-34,-40},{-34,52},{-22,52}},
      color={255,0,255}));
  connect(u1PumHeaWatPriHdr_actual, u1PumHeaWatPriHdr_internal.u)
    annotation(Line(points={{-140,-60},{-110,-60}},
      color={255,0,255}));
  connect(u1PumChiWatPriHdr_actual, u1PumChiWatPriHdr_internal.u)
    annotation(Line(points={{-140,-80},{-82,-80}},
      color={255,0,255}));
  connect(u1PumHeaWatPriHdr_internal.y[1:nHp], seqEveHp.u1PumHeaWatPri_actual)
    annotation(Line(points={{-86,-60},{-50,-60},{-50,54},{-22,54}},
      color={255,0,255}));
  connect(u1PumChiWatPriHdr_internal.y[1:nHp], seqEveHp.u1PumChiWatPri_actual)
    annotation(Line(points={{-58,-80},{-46,-80},{-46,52},{-22,52}},
      color={255,0,255}));
  connect(u1PumHeaWatPriHdr_internal.y[nHp + 1:nHp +
    nPhp], seqEvePhp.u1PumHeaWatPri_actual)
    annotation(Line(points={{-86,-60},{-50,-60},{-50,-54},{-22,-54}},
      color={255,0,255}));
  connect(u1PumChiWatPriHdr_internal.y[nHp + 1:nHp +
    nPhp], seqEvePhp.u1PumChiWatPri_actual)
    annotation(Line(points={{-58,-80},{-46,-80},{-46,-56},{-22,-56}},
      color={255,0,255}));
  connect(seqEvePhp.y1PumChiWatPri, y1PumChiWatPri[nHp + 1:nHp + nPhp])
    annotation(Line(points={{2,-64},{38,-64},{38,-100},{140,-100}},
      color={255,0,255}));
  connect(seqEvePhp.y1PumHeaWatPri, y1PumHeaWatPri[nHp + 1:nHp + nPhp])
    annotation(Line(points={{2,-62},{42,-62},{42,-80},{140,-80}},
      color={255,0,255}));
  connect(seqEvePhp.y1AndHea, y1HeaPhp)
    annotation(Line(points={{2,-46},{102,-46},{102,40},{140,40}},
      color={255,0,255}));
  connect(seqEvePhp.y1AndCoo, y1CooPhp)
    annotation(Line(points={{2,-48},{104,-48},{104,20},{140,20}},
      color={255,0,255}));
  connect(seqEveHp.y1ValHeaWatInlIso, y1ValHeaWatInlIso[1:nHp])
    annotation(Line(points={{2,56},{100,56},{100,0},{140,0}},
      color={255,0,255}));
  connect(seqEveHp.y1ValHeaWatOutIso, y1ValHeaWatOutIso[1:nHp])
    annotation(Line(points={{2,54},{98,54},{98,-20},{140,-20}},
      color={255,0,255}));
  connect(seqEveHp.y1ValChiWatInlIso, y1ValChiWatInlIso[1:nHp])
    annotation(Line(points={{2,52},{96,52},{96,-40},{140,-40}},
      color={255,0,255}));
  connect(seqEveHp.y1ValChiWatOutIso, y1ValChiWatOutIso[1:nHp])
    annotation(Line(points={{2,50},{94,50},{94,-60},{140,-60}},
      color={255,0,255}));
  connect(seqEvePhp.y1ValHeaWatInlIso, y1ValHeaWatInlIso[nHp + 1:nHp + nPhp])
    annotation(Line(points={{2,-52},{38,-52},{38,0},{140,0}},
      color={255,0,255}));
  connect(seqEvePhp.y1ValHeaWatOutIso, y1ValHeaWatOutIso[nHp + 1:nHp + nPhp])
    annotation(Line(points={{2,-54},{40,-54},{40,-20},{140,-20}},
      color={255,0,255}));
  connect(seqEvePhp.y1ValChiWatInlIso, y1ValChiWatInlIso[nHp + 1:nHp + nPhp])
    annotation(Line(points={{2,-56},{42,-56},{42,-40},{140,-40}},
      color={255,0,255}));
  connect(seqEvePhp.y1ValChiWatOutIso, y1ValChiWatOutIso[nHp + 1:nHp + nPhp])
    annotation(Line(points={{2,-58},{42,-58},{42,-60},{140,-60}},
      color={255,0,255}));
  connect(seqEveHp.y1PumChiWatPri, y1PumChiWatPri[1:nHp])
    annotation(Line(points={{2,44},{88,44},{88,-100},{140,-100}},
      color={255,0,255}));
  connect(seqEveHp.y1PumHeaWatPri, y1PumHeaWatPri[1:nHp])
    annotation(Line(points={{2,46},{90,46},{90,-80},{140,-80}},
      color={255,0,255}));
annotation(defaultComponentName="seqEve",
  Icon(coordinateSystem(preserveAspectRatio=true,
    extent={{-100,-120},{100,120}},
    grid={2,2}),
    graphics={Rectangle(extent={{-100,140},{100,-142}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,190},{150,150}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
  Documentation(
    info="<html>
<p>
  This block applies the staging event sequencing logic of
  <a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.EventSequencingSingle\">
    Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.EventSequencingSingle</a>
  to a group of <code>nHp</code> reversible heat pumps and <code>nPhp</code>
  polyvalent heat pumps.
</p>
<p>
  To facilitate integration into plant controllers serving both reversible
  and polyvalent heat pumps, the output connectors for the isolation valve
  commands and the primary pump enable commands have always the same
  dimension <code>nHp + nPhp</code>.
  When a piece of equipment is not present for a given unit, the
  corresponding array element is set to <code>false</code>.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    July 10, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end EventSequencingMultiple;
