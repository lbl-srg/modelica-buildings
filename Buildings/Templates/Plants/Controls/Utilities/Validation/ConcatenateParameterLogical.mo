within Buildings.Templates.Plants.Controls.Utilities.Validation;
model ConcatenateParameterLogical
  "Validation model"
  Buildings.Templates.Plants.Controls.Utilities.ConcatenateParameterLogical catApp(
    nin1=2,
    is_app=true,
    new=fill(true, 1))
    "Append to input array"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](k={false, true})
    "Constant array"
    annotation(Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Templates.Plants.Controls.Utilities.ConcatenateParameterLogical cat0(
    new=fill(true, 0),
    nin1=2)
    "Zero-sized array concatenation (no-op)"
    annotation(Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Templates.Plants.Controls.Utilities.ConcatenateParameterLogical catPre(
    nin1=2,
    is_app=false,
    new=fill(true, 2))
    "Prepend to input array"
    annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(con.y, catApp.u1)
    annotation(Line(points={{-38,0},{-26,0},{-26,0},{-12,0}},
      color={255,0,255}));
  connect(con.y, cat0.u1)
    annotation(Line(points={{-38,0},{-20,0},{-20,40},{-12,40}},
      color={255,0,255}));
  connect(con.y, catPre.u1)
    annotation(Line(points={{-38,0},{-20,0},{-20,-40},{-12,-40}},
      color={255,0,255}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Utilities/Validation/ConcatenateParameterLogical.mos"
    "Simulate and plot"),
  experiment(StopTime=1.0,
    Tolerance=1e-06),
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Ellipse(lineColor={75,138,73},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      extent={{-100,-100},{100,100}}),
    Polygon(lineColor={0,0,255},
      fillColor={75,138,73},
      pattern=LinePattern.None,
      fillPattern=FillPattern.Solid,
      points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(
    info="<html>
<p>
  Validation model for the block
  <a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.ConcatenateLogical\">
    Buildings.Templates.Plants.Controls.Utilities.ConcatenateLogical</a>.
</p>
</html>"));
end ConcatenateParameterLogical;
