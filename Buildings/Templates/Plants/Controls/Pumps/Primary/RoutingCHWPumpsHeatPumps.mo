within Buildings.Templates.Plants.Controls.Pumps.Primary;
block RoutingCHWPumpsHeatPumps
  parameter Boolean have_php
    "Set to true for plants with polyvalent heat pumps"
    annotation(Evaluate=true);
  parameter Boolean have_pumChiWatPri
    "Set to true for plants with separate primary CHW pumps"
    annotation(Evaluate=true);
  parameter Boolean have_pumPriHdr
    "Set to true for headered primary pumps, false for dedicated pumps"
    annotation(Evaluate=true);
  parameter Boolean have_pumChiWatPriDedHp
    "Set to true for HP with separate dedicated primary CHW pumps"
    annotation(Evaluate=true);
  parameter Integer nPumChiWatPriHp
    "Number of dedicated primary CHW pumps serving HP"
    annotation(Evaluate=true);
  parameter Integer nPumChiWatPriPhp
    "Number of dedicated primary CHW pumps serving polyvalent HP"
    annotation(Evaluate=true);
  parameter Integer nPumChiWatPri
    "Number of primary CHW pumps"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriPhp_actual[nPumChiWatPriPhp]
    if have_pumChiWatPri and not have_pumPriHdr and have_php
    "Primary CHW pump status – Polyvalent HP dedicated pumps"
    annotation(Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-102},{-100,-62}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriHp_actual[nPumChiWatPriHp]
    if have_pumChiWatPri and have_pumChiWatPriDedHp
    "Primary CHW pump status – HP dedicated pumps"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriHdr_actual[nPumChiWatPri]
    if have_pumChiWatPri and have_pumPriHdr
    "Primary CHW pump status – Headered pumps"
    annotation(Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Utilities.ConcatenateLogical cat1(nin1=nPumChiWatPriHp, nin2=nPumChiWatPriPhp)
    if have_pumChiWatPri
      and not have_pumPriHdr
      and have_pumChiWatPriDedHp
      and have_php
    annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal pasPumChiWatPriHp(
    final nin=nPumChiWatPriHp,
    final nout=nPumChiWatPriHp)
    if have_pumChiWatPri and have_pumChiWatPriDedHp and not have_php
    "Direct pass-through"
    annotation(Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal pasPumChiWatPriPhp(
    final nin=nPumChiWatPriPhp,
    final nout=nPumChiWatPriPhp)
    if have_pumChiWatPri
      and not have_pumPriHdr
      and have_php
      and not have_pumChiWatPriDedHp
    "Direct pass-through"
    annotation(Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal pasPumChiWatPriHdr(
    final nin=nPumChiWatPri,
    final nout=nPumChiWatPri)
    if have_pumChiWatPri and have_pumPriHdr
    "Direct pass-through"
    annotation(Placement(transformation(extent={{-50,70},{-30,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nPumChiWatPri]
    if have_pumChiWatPri
    "Primary CHW pump status"
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
equation
  connect(u1PumChiWatPriHp_actual, cat1.u1)
    annotation(Line(points={{-120,0},{-80,0},{-80,-40},{-52,-40}},
      color={255,0,255}));
  connect(u1PumChiWatPriPhp_actual, cat1.u2)
    annotation(Line(points={{-120,-80},{-80,-80},{-80,-48},{-52,-48}},
      color={255,0,255}));
  connect(u1PumChiWatPriHp_actual, pasPumChiWatPriHp.u)
    annotation(Line(points={{-120,0},{-52,0}},
      color={255,0,255}));
  connect(u1PumChiWatPriPhp_actual, pasPumChiWatPriPhp.u)
    annotation(Line(points={{-120,-80},{-52,-80}},
      color={255,0,255}));
  connect(u1PumChiWatPriHdr_actual, pasPumChiWatPriHdr.u)
    annotation(Line(points={{-120,80},{-52,80}},
      color={255,0,255}));
  connect(pasPumChiWatPriHdr.y, y1)
    annotation(Line(points={{-28,80},{0,80},{0,0},{120,0}},
      color={255,0,255}));
  connect(pasPumChiWatPriHp.y, y1)
    annotation(Line(points={{-28,0},{120,0}},
      color={255,0,255}));
  connect(cat1.y, y1)
    annotation(Line(points={{-28,-40},{0,-40},{0,0},{120,0}},
      color={255,0,255}));
  connect(pasPumChiWatPriPhp.y, y1)
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
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end RoutingCHWPumpsHeatPumps;
