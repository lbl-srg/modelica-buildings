within Buildings.Templates.Plants.Controls.Utilities;
block ConcatenateLogical
  parameter Boolean is_app = true
    "Set to true to append to the input array, false to prepend"
    annotation(Evaluate=true);
  parameter Integer nin = 0
    "Size of input array"
    annotation(Evaluate=true,
      Dialog(connectorSizing=true),
      HideResult=true);
  parameter Boolean new[:] "New array to be concatenated with the input array";
  final parameter Integer nNew = size(new, 1) "Size of new array";
  final parameter Integer nout = nin + nNew "Size of output array";
  final parameter Integer idxExtInp[nout] =
    if is_app
    then cat(1, {i for i in 1:nin}, fill(1, nNew))
    else cat(1, fill(1, nNew), {i for i in 1:nin})
    "Indices of input array to be extracted";
  final parameter Integer idxExtNew[nout] =
    if is_app
    then cat(1, fill(1, nin), {i for i in 1:nNew})
    else cat(1, {i for i in 1:nNew}, fill(1, nin))
    "Indices of new array to be extracted";
  final parameter Boolean selInpNew[nout] =
    if is_app
    then cat(1, fill(true, nin), fill(false, nNew))
    else cat(1, fill(false, nNew), fill(true, nin))
    "Selector for input array (true) or new array (false) values";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1[nin]
    "Array of Boolean signals"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[nout]
    "Concatenated array"
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal expInp(
    final nin=nin,
    final nout=nout,
    final extract=idxExtInp)
    "Expand input array"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nout]
    "Switch between input array and new array"
    annotation(Placement(transformation(extent={{62,-10},{82,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nout](
    final k=selInpNew)
    annotation(Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant newCst[nNew](final k=new)
    if nNew > 0
    "New array to be concatenated"
    annotation(Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal expNew(
    final nin=nNew,
    final nout=nout,
    final extract=idxExtNew)
    if nNew > 0
    "Expand new array"
    annotation(Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant new0[nout](
    final k=fill(true, nout))
    if nNew == 0
    "Placeholder for zero-sized array"
    annotation(Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(u1, expInp.u)
    annotation(Line(points={{-120,0},{-12,0}},
      color={255,0,255}));
  connect(logSwi.y, y)
    annotation(Line(points={{84,0},{120,0}},
      color={255,0,255}));
  connect(con.y, logSwi.u2)
    annotation(Line(points={{-68,-20},{30,-20},{30,0},{60,0}},
      color={255,0,255}));
  connect(expInp.y, logSwi.u1)
    annotation(Line(points={{12,0},{20,0},{20,8},{60,8}},
      color={255,0,255}));
  connect(newCst.y, expNew.u)
    annotation(Line(points={{-68,-80},{-12,-80}},
      color={255,0,255}));
  connect(expNew.y, logSwi.u3)
    annotation(Line(points={{12,-80},{40,-80},{40,-8},{60,-8}},
      color={255,0,255}));
  connect(new0.y, logSwi.u3)
    annotation(Line(points={{-38,-50},{40,-50},{40,-8},{60,-8}},
      color={255,0,255}));
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
  This block concatenates a Boolean array provided as a parameter with an
  input Boolean array.
</p>
<p>
  When <code>is_app = true</code> (default), the new values are appended after
  the input array.
</p>
<p>
  When <code>is_app = false</code>, the new values are prepended before the
  input array.
</p>
<p>
  A zero-sized array can be provided as a parameter. The block then is a
  no-op, returning the input array unchanged.
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
