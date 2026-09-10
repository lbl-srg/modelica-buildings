within Buildings.Templates.Plants.Controls.Utilities;
block ConcatenateParameterLogical
  extends Buildings.Templates.Plants.Controls.Utilities.ConcatenateLogical(
    final have_input=false,
    final nin2=nNew);
  parameter Boolean new[:] "New array to be concatenated with the input array";
  final parameter Integer nNew = size(new, 1)
    "Size of new array"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant newCst[nNew](final k=new)
    if nin2 > 0
    "New array to be concatenated"
    annotation(Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant pla0[nout](
    final k=fill(true, nout))
    if nin2 == 0
    "Placeholder for zero-sized array"
    annotation(Placement(transformation(extent={{-40,-70},{-20,-50}})));
equation
  connect(newCst.y, exp2.u)
    annotation(Line(points={{-68,-60},{-60,-60},{-60,-80},{-12,-80}},
      color={255,0,255}));
  connect(pla0.y, logSwi.u3)
    annotation(Line(points={{-18,-60},{40,-60},{40,-8},{60,-8}},
      color={255,0,255}));
annotation(defaultComponentName="cat1",
  Documentation(
    info="<html>
<p>
  This block concatenates two Boolean arrays, one provided as an input, the
  other one provided as a parameter.
</p>
<p>
  When <code>is_app = true</code> (default), the values of the parameter array
  are appended after the values of the input array.
</p>
<p>
  When <code>is_app = false</code>, the values of the parameter array are
  prepended before the values of the input array.
</p>
<p>
  A zero-sized array can be provided as a parameter. The block then is a
  no-op, returning the input array unchanged.
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
end ConcatenateParameterLogical;
