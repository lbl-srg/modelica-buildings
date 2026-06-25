within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences;
block RoutingPrimaryPumpStatus
  "Primary pump status signal routing"
  parameter Boolean have_pumPriHdr
    "Set to true for headered primary pumps, false for dedicated pumps"
    annotation(Evaluate=true);
  parameter Integer nPumPriDedHp
    "Number of dedicated primary pumps serving HP"
    annotation(Evaluate=true);
  parameter Integer nPumPriDedPhp
    "Number of dedicated primary pumps serving polyvalent HP"
    annotation(Evaluate=true);
  parameter Integer nPumPri
    "Number of primary pumps"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumPriDedPhp_actual[nPumPriDedPhp]
    if nPumPriDedPhp > 0
    "Primary pump status – Polyvalent HP dedicated pumps"
    annotation(Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-102},{-100,-62}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumPriDedHp_actual[nPumPriDedHp]
    if nPumPriDedHp > 0
    "Primary pump status – HP dedicated pumps"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumPriHdr_actual[nPumPri]
    if have_pumPriHdr
    "Primary pump status – Headered pumps"
    annotation(Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Utilities.ConcatenateLogical pumPriDedHpPhp(
    nin1=nPumPriDedHp,
    nin2=nPumPriDedPhp)
    if nPumPriDedHp > 0 and nPumPriDedPhp > 0
    "Concatenate dedicated pump signals – Plants with HP and polyvalent HP"
    annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal pumPriDedHp(
    final nin=nPumPriDedHp,
    final nout=nPumPriDedHp)
    if nPumPriDedHp > 0 and nPumPriDedPhp == 0
    "Direct pass-through – Plants with HP and no polyvalent HP"
    annotation(Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal pumPriDedPhp(
    final nin=nPumPriDedPhp,
    final nout=nPumPriDedPhp)
    if nPumPriDedHp == 0 and nPumPriDedPhp > 0
    "Direct pass-through – Plants with polyvalent HP and no HP"
    annotation(Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal pumPriHdr(
    final nin=nPumPri,
    final nout=nPumPri)
    if have_pumPriHdr
    "Direct pass-through – Plants with headered primary pumps"
    annotation(Placement(transformation(extent={{-50,70},{-30,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nPumPri]
    "Primary CHW pump status"
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
equation
  connect(u1PumPriDedHp_actual, pumPriDedHpPhp.u1)
    annotation(Line(points={{-120,0},{-80,0},{-80,-40},{-52,-40}},
      color={255,0,255}));
  connect(u1PumPriDedPhp_actual, pumPriDedHpPhp.u2)
    annotation(Line(points={{-120,-80},{-80,-80},{-80,-48},{-52,-48}},
      color={255,0,255}));
  connect(u1PumPriDedHp_actual, pumPriDedHp.u)
    annotation(Line(points={{-120,0},{-52,0}},
      color={255,0,255}));
  connect(u1PumPriDedPhp_actual, pumPriDedPhp.u)
    annotation(Line(points={{-120,-80},{-52,-80}},
      color={255,0,255}));
  connect(u1PumPriHdr_actual, pumPriHdr.u)
    annotation(Line(points={{-120,80},{-52,80}},
      color={255,0,255}));
  connect(pumPriHdr.y, y1)
    annotation(Line(points={{-28,80},{0,80},{0,0},{120,0}},
      color={255,0,255}));
  connect(pumPriDedHp.y, y1)
    annotation(Line(points={{-28,0},{120,0}},
      color={255,0,255}));
  connect(pumPriDedHpPhp.y, y1)
    annotation(Line(points={{-28,-40},{0,-40},{0,0},{120,0}},
      color={255,0,255}));
  connect(pumPriDedPhp.y, y1)
    annotation(Line(points={{-28,-80},{0,-80},{0,0},{120,0}},
      color={255,0,255}));
annotation(defaultComponentName="rouPumChiWatPri",
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255}),
    Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(
    info="<html>
<p>
  This block consolidates primary pump status signals into a single output
  array. Based on the specified pumping configuration, exactly one of the
  following paths is instantiated:
</p>
<ul>
  <li>
    <b>Headered primary pumps</b>: the headered pump status signals are passed
    through directly.
  </li>
  <li>
    <b>Dedicated pumps — reversible HP only</b>: the HP dedicated pump status
    signals are passed through directly.
  </li>
  <li>
    <b>Dedicated pumps — polyvalent HP only</b>: the polyvalent HP dedicated
    pump status signals are passed through directly.
  </li>
  <li>
    <b>Dedicated pumps — reversible HP and polyvalent HP</b>: the HP and
    polyvalent HP dedicated pump status signals are concatenated.
  </li>
</ul>
</html>", revisions="<html>
<ul>
  <li>
    July 1, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end RoutingPrimaryPumpStatus;
