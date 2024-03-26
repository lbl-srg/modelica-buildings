within Buildings.Templates.Plants.Controls.Pumps.Primary;
block VariableSpeedNoDpControl
  "Variable speed pump without differential pressure control"
  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  final parameter Boolean have_pumHeaWatPri=have_heaWat
    "Set to true for plants with primary HW pumps"
    annotation (Evaluate=true);
  parameter Boolean have_pumChiWatPriDed(start=false)
    "Set to true for plants with separate dedicated primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_chiWat and not have_pumPriHdr));
  final parameter Boolean have_pumChiWatPri=
    have_chiWat and (have_pumPriHdr or have_pumChiWatPriDed)
    "Set to true for plants with separate primary CHW pumps"
    annotation (Evaluate=true);
  parameter Boolean have_pumPriHdr
    "Set to true for headered primary pumps, false for dedicated pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Integer nEqu(min=1, start=0)
    "Number of equipment"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_heaWat and have_chiWat));
  parameter Integer nPumHeaWatPri
    "Number of primary HW pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Integer nPumChiWatPri(start=if have_chiWat and have_pumChiWatPri then nEqu else 0)
    "Number of primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_pumChiWatPri));
  parameter Real yPumHeaWatPriSet(
    max=1,
    min=0,
    start=1,
    unit="1")
    "Primary pump speed providing design heat pump flow in heating mode"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat));
  parameter Real yPumChiWatPriSet(
    max=1,
    min=0,
    start=1,
    unit="1")
    "Primary pump speed providing design heat pump flow in cooling mode"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_chiWat));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri[nPumHeaWatPri]
    if have_heaWat and have_pumHeaWatPri
    "Primary HW pump start command"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriHdr
    if have_heaWat and have_pumHeaWatPri and have_pumPriHdr
    "Headered primary HW pump speed command"
    annotation (Placement(transformation(extent={{140,80},{180,120}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri[nPumChiWatPri]
    if have_chiWat and have_pumChiWatPri
    "Primary CHW pump start command"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriHdr
    if have_chiWat and have_pumChiWatPri and have_pumPriHdr
    "Headered primary CHW pump speed command"
    annotation (Placement(transformation(extent={{140,40},{180,80}}),
      iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriDed[nPumHeaWatPri]
    if have_heaWat and have_pumHeaWatPri and not have_pumPriHdr
    "Dedicated primary HW pump speed command"
    annotation (Placement(transformation(extent={{140,-80},{180,-40}}),
      iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriDed[nPumChiWatPri]
    if have_chiWat and have_pumChiWatPri and not have_pumPriHdr
    "Dedicated primary CHW pump speed command"
    annotation (Placement(transformation(extent={{140,-120},{180,-80}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea[nEqu] if have_heaWat
     and have_chiWat and not have_pumChiWatPriDed and not have_pumPriHdr
    "Heating/cooling mode command"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumChiWatPriDed[nPumChiWatPri]
    if have_chiWat and have_pumChiWatPri and not have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation (Placement(transformation(extent={{110,-110},{130,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Constant"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant spePumChiWatPri(
    final k=yPumChiWatPriSet)
    if have_chiWat
    "Constant"
    annotation (Placement(transformation(extent={{-110,-130},{-90,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumHeaWatPriDed[nPumHeaWatPri]
    if have_heaWat and have_pumHeaWatPri and not have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation (Placement(transformation(extent={{110,-70},{130,-50}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(
    nout=nPumHeaWatPri)
    if have_heaWat and have_pumHeaWatPri
    "Replicate signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep1(
    nout=nPumChiWatPri)
    if have_chiWat and have_pumChiWatPri
    "Replicate signal"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep2(
    nout=nPumChiWatPri)
    if have_chiWat and have_pumChiWatPri
    "Replicate signal"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant spePumHeaWatPri(
    final k=yPumHeaWatPriSet)
    if have_heaWat and have_pumHeaWatPri
    "Constant"
    annotation (Placement(transformation(extent={{-110,110},{-90,130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumChiWatPriHdr
    if have_chiWat and have_pumChiWatPri and have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation (Placement(transformation(extent={{110,50},{130,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch setPumHeaWatPriHdr
    if have_heaWat and have_pumHeaWatPri and have_pumPriHdr
    "Set prescribed speed when pump is enabled"
    annotation (Placement(transformation(extent={{110,90},{130,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumChiWatPri(
    nin=nPumChiWatPri)
    if have_chiWat and have_pumChiWatPri
    "Return true if any pump is enabled"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumHeaWatPri(
    nin=nPumHeaWatPri)
    if have_heaWat and have_pumHeaWatPri
    "Return true if any pump is enabled"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch selSpeHea[nPumHeaWatPri] if
    have_heaWat and have_chiWat and not have_pumChiWatPri and not
    have_pumPriHdr
    "Select prescribed pump speed depending on heating/cooling mode – Case with common CHW and HW dedicated pumps"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep3(
    nout=nPumHeaWatPri)
    if have_heaWat and have_pumHeaWatPri
    "Replicate signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep4(
    nout=nPumHeaWatPri) if have_heaWat and have_chiWat and not
    have_pumChiWatPri and not have_pumPriHdr
    "Replicate signal"
    annotation (Placement(transformation(extent={{-30,2},{-10,22}})));
  Utilities.PlaceholderReal ph[nPumHeaWatPri](
    each final have_inp=have_heaWat and have_chiWat and not have_pumChiWatPri
         and not have_pumPriHdr,
    each final have_inpPh=false,
    each final u_internal=yPumHeaWatPriSet)
    if have_heaWat and have_pumHeaWatPri and not have_pumPriHdr
    "Always use HW pump speed in case of separate dedicated CHW pumps "
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
equation
  connect(u1PumChiWatPri, setPumChiWatPriDed.u2)
    annotation (Line(points={{-160,0},{-126,0},{-126,-100},{108,-100}},color={255,0,255}));
  connect(setPumChiWatPriDed.y, yPumChiWatPriDed)
    annotation (Line(points={{132,-100},{160,-100}},color={0,0,127}));
  connect(setPumHeaWatPriDed.y, yPumHeaWatPriDed)
    annotation (Line(points={{132,-60},{160,-60}},color={0,0,127}));
  connect(zer.y, rep.u)
    annotation (Line(points={{-88,-80},{-70,-80},{-70,-20},{-62,-20}},color={0,0,127}));
  connect(spePumChiWatPri.y, rep1.u)
    annotation (Line(points={{-88,-120},{-62,-120}},color={0,0,127}));
  connect(zer.y, rep2.u)
    annotation (Line(points={{-88,-80},{-62,-80}},color={0,0,127}));
  connect(setPumHeaWatPriHdr.y, yPumHeaWatPriHdr)
    annotation (Line(points={{132,100},{160,100}},color={0,0,127}));
  connect(setPumChiWatPriHdr.y, yPumChiWatPriHdr)
    annotation (Line(points={{132,60},{160,60}},color={0,0,127}));
  connect(rep2.y, setPumChiWatPriDed.u3)
    annotation (Line(points={{-38,-80},{-20,-80},{-20,-108},{108,-108}},color={0,0,127}));
  connect(rep1.y, setPumChiWatPriDed.u1)
    annotation (Line(points={{-38,-120},{80,-120},{80,-92},{108,-92}},color={0,0,127}));
  connect(zer.y, setPumChiWatPriHdr.u3)
    annotation (Line(points={{-88,-80},{-70,-80},{-70,52},{108,52}},color={0,0,127}));
  connect(rep.y, setPumHeaWatPriDed.u3)
    annotation (Line(points={{-38,-20},{-20,-20},{-20,-68},{108,-68}},color={0,0,127}));
  connect(zer.y, setPumHeaWatPriHdr.u3)
    annotation (Line(points={{-88,-80},{-70,-80},{-70,92},{108,92}},color={0,0,127}));
  connect(spePumChiWatPri.y, setPumChiWatPriHdr.u1)
    annotation (Line(points={{-88,-120},{-80,-120},{-80,68},{108,68}},color={0,0,127}));
  connect(u1PumChiWatPri, anyPumChiWatPri.u)
    annotation (Line(points={{-160,0},{-112,0}},color={255,0,255}));
  connect(u1PumHeaWatPri, anyPumHeaWatPri.u)
    annotation (Line(points={{-160,60},{-136,60},{-136,60},{-112,60}},color={255,0,255}));
  connect(anyPumHeaWatPri.y, setPumHeaWatPriHdr.u2)
    annotation (Line(points={{-88,60},{60,60},{60,100},{108,100}},color={255,0,255}));
  connect(spePumHeaWatPri.y, setPumHeaWatPriHdr.u1)
    annotation (Line(points={{-88,120},{40,120},{40,108},{108,108}},color={0,0,127}));
  connect(anyPumChiWatPri.y, setPumChiWatPriHdr.u2)
    annotation (Line(points={{-88,0},{80,0},{80,60},{108,60}},color={255,0,255}));
  connect(u1PumHeaWatPri, setPumHeaWatPriDed.u2)
    annotation (Line(points={{-160,60},{-120,60},{-120,-60},{108,-60}},color={255,0,255}));
  connect(u1Hea, selSpeHea.u2)
    annotation (Line(points={{-160,-60},{-132,-60},{-132,-40},{38,-40}},color={255,0,255}));
  connect(spePumHeaWatPri.y, rep3.u)
    annotation (Line(points={{-88,120},{-84,120},{-84,30},{-62,30}},
      color={0,0,127}));
  connect(rep3.y, selSpeHea.u1)
    annotation (Line(points={{-38,30},{30,30},{30,-32},{38,-32}},color={0,0,127}));
  connect(rep4.y, selSpeHea.u3)
    annotation (Line(points={{-8,12},{20,12},{20,-48},{38,-48}},color={0,0,127}));
  connect(spePumChiWatPri.y, rep4.u)
    annotation (Line(points={{-88,-120},{-80,-120},{-80,12},{-32,12}},color={0,0,127}));
  connect(ph.y, setPumHeaWatPriDed.u1) annotation (Line(points={{92,-40},{100,-40},
          {100,-52},{108,-52}}, color={0,0,127}));
  connect(selSpeHea.y, ph.u)
    annotation (Line(points={{62,-40},{68,-40}}, color={0,0,127}));
  annotation (
    defaultComponentName="ctlPumPri",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        extent={{-140,-140},{140,140}})));
end VariableSpeedNoDpControl;
