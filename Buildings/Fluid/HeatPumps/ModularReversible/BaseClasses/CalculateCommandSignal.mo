within Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses;
block CalculateCommandSignal
  "Calculate the command signal depending on application type"
  parameter Boolean use_rev=true
    "=true if the chiller or heat pump is reversible"
    annotation(choices(checkBox=true));
  parameter Boolean useInHeaPum
    "=false to indicate that this model is used in a chiller"
    annotation(choices(checkBox=true));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    annotation (Placement(transformation(extent={{-10,-11},{10,11}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PLRHea
    if use_rev and (not useInHeaPum) or useInHeaPum
    annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}), iconTransformation(extent
          ={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PLRCoo
    if use_rev and useInHeaPum or (not useInHeaPum) annotation
    (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySet annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent=
            {{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerCoo(final k=0)
    if not (use_rev and useInHeaPum or (not useInHeaPum))
    "Placeholder value"
    annotation (Placement(transformation(extent={{-80,-31},{-60,-9}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerHea(final k=0)
    if not (use_rev and (not useInHeaPum) or useInHeaPum)
    "Placeholder value"
    annotation (Placement(transformation(extent={{-80,9},{-60,31}})));
equation
  connect(PLRCoo, max1.u2) annotation (Line(points={{-120,-60},{-20,-60},{-20,
          -6.6},{-12,-6.6}}, color={0,0,127}));
  connect(PLRHea, max1.u1) annotation (Line(points={{-120,60},{-20,60},{-20,6.6},
          {-12,6.6}}, color={0,0,127}));
  connect(max1.y, ySet)
    annotation (Line(points={{12,0},{62,0},{62,0},{120,0}}, color={0,0,127}));
  connect(zerCoo.y, max1.u2) annotation (Line(points={{-58,-20},{-40,-20},{-40,-6.6},
          {-12,-6.6}}, color={0,0,127}));
  connect(zerHea.y, max1.u1) annotation (Line(points={{-58,20},{-40,20},{-40,6.6},
          {-12,6.6}}, color={0,0,127}));
  annotation (Icon(graphics={   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        textColor={0,0,255})}),           Documentation(info="<html>
<p>
This is a helper block developed specifically for models
that include ideal controls.
Based on the part load ratio required to meet the heating
(<code>PLRHea</code>) or cooling (<code>PLRCoo</code>) load,
the block returns the command signal <code>ySet</code> that
is used by several components of the heat pump and chiller models.
</p>
</html>"));
end CalculateCommandSignal;
