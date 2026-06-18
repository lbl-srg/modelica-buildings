within Buildings.Templates.Plants.Controls.Utilities;
block ConcatenateLogical
  parameter Boolean is_app = true
    "Set to true to append to the input array, false to prepend"
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
  final parameter Integer nout = nin1 +nin2  "Size of output array";
  final parameter Integer idxExt1[nout]=if is_app then cat(
      1,
      {i for i in 1:nin1},
      fill(1, nin2)) else cat(
      1,
      fill(1, nin2),
      {i for i in 1:nin1}) "Indices of first array to be extracted";
  final parameter Integer idxExt2[nout]=if is_app then cat(
      1,
      fill(1, nin1),
      {i for i in 1:nin2}) else cat(
      1,
      {i for i in 1:nin2},
      fill(1, nin1)) "Indices of second array to be extracted";
  final parameter Boolean selInp[nout]=if is_app then cat(1, fill(true, nin1),
      fill(false, nin2)) else cat(1, fill(false, nin2), fill(true, nin1))
    "Selector for first (true) or second (false) array values";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1[nin1]
    "Array of Boolean signals"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u2[nin2] if have_input
    "Array of Boolean signals"
    annotation(Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[nout]
    "Concatenated array"
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal expInp(
    final nin=nin1,
    final nout=nout,
    final extract=idxExt1) if nin1 > 0 "Expand array"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nout]
    "Switch between first and second array"
    annotation(Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nout](final k=selInp)
    "Input selector"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal exp2(
    final nin=nin2,
    final nout=nout,
    final extract=idxExt2) if nin2 > 0 "Expand array"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
protected
  // The parameter have_input is used in ConcatenateParameterLogical
  parameter Boolean have_input = true
    "Set to true if second array provided as input, false if provided as parameter"
    annotation(Evaluate=true);
equation
  connect(u1, expInp.u)
    annotation(Line(points={{-120,0},{-12,0}},
      color={255,0,255}));
  connect(logSwi.y, y)
    annotation(Line(points={{82,0},{120,0}},
      color={255,0,255}));
  connect(con.y, logSwi.u2)
    annotation(Line(points={{-68,-20},{30,-20},{30,0},{58,0}},
      color={255,0,255}));
  connect(expInp.y, logSwi.u1)
    annotation(Line(points={{12,0},{20,0},{20,8},{58,8}},
      color={255,0,255}));
  connect(exp2.y, logSwi.u3) annotation (Line(points={{12,-80},{40,-80},{40,-8},
          {58,-8}}, color={255,0,255}));
  connect(u2, exp2.u)
    annotation (Line(points={{-120,-80},{-12,-80}}, color={255,0,255}));
annotation(defaultComponentName="cat1",
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
  This block concatenates two Boolean arrays.
</p>
<p>
  When <code>is_app = true</code> (default), the values of <code>u2</code>
  are appended after the values of <code>u1</code>.
</p>
<p>
  When <code>is_app = false</code>, the values of <code>u2</code>
  are prepended before the values of <code>u1</code>.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    July 1, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end ConcatenateLogical;
