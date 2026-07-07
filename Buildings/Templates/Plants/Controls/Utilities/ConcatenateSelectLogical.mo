within Buildings.Templates.Plants.Controls.Utilities;
block ConcatenateSelectLogical
  "Merge both Boolean arrays when present, otherwise return the available one"
  parameter Boolean have_u1
    "Set to true if u1 array available"
    annotation(Evaluate=true);
  parameter Boolean have_u2
    "Set to true if u2 array available"
    annotation(Evaluate=true);
  parameter Integer nin1 = 0
    "Size of input array"
    annotation(Evaluate=true,
      Dialog(connectorSizing=true),
      HideResult=true);
  parameter Integer nin2 = 0
    "Size of input array"
    annotation(Evaluate=true,
      Dialog(connectorSizing=true),
      HideResult=true);
  final parameter Integer nout =
    if have_u1 and have_u2 then nin1 + nin2 elseif have_u1 then nin1 else nin2
    "Size of output array"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1[nin1]
    if have_u1
    "Array of Boolean signals"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u2[nin2]
    if have_u2
    "Array of Boolean signals"
    annotation(Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[nout]
    "Concatenated array"
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  PlaceholderLogical selAva[if have_u1 then nin1 else nin2](
    each final have_inp=have_u1,
    each final have_inpPh=true)
    if not (have_u1 and have_u2)
    "Select available array"
    annotation(Placement(transformation(extent={{-20,-10},{0,10}})));
  ConcatenateLogical cat1(nin1=nin1, nin2=nin2)
    if have_u1 and have_u2
    "Concatenate"
    annotation(Placement(transformation(extent={{-20,-50},{0,-30}})));
equation
  connect(u1, selAva.u)
    annotation(Line(points={{-120,0},{-22,0}},
      color={255,0,255}));
  connect(u2, selAva.uPh)
    annotation(Line(points={{-120,-80},{-40,-80},{-40,-6},{-22,-6}},
      color={255,0,255}));
  connect(u1, cat1.u1)
    annotation(Line(points={{-120,0},{-59,0},{-59,-40},{-22,-40}},
      color={255,0,255}));
  connect(u2, cat1.u2)
    annotation(Line(points={{-120,-80},{-40,-80},{-40,-48},{-22,-48}},
      color={255,0,255}));
  connect(cat1.y, y)
    annotation(Line(points={{2,-40},{80,-40},{80,0},{120,0}},
      color={255,0,255}));
  connect(selAva.y, y)
    annotation(Line(points={{2,0},{120,0}},
      color={255,0,255}));
annotation(defaultComponentName="catOrSel",
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(
    info="<html>
<p>
  This block concatenates two Boolean arrays if both the parameters
  <code>have_u1</code> and <code>have_u2</code> are <code>true</code>.
  Otherwise, it returns the sole available input array unchanged.
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
end ConcatenateSelectLogical;
