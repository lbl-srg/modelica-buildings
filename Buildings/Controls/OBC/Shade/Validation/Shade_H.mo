within Buildings.Controls.OBC.Shade.Validation;
model Shade_H "Validation model for shading control based on solar irradiance"
  import Buildings;

  // tests response to a solar irradiance input
  Buildings.Controls.OBC.Shade.Shade_H shaH "Shade enable/disable controller"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  parameter Modelica.SIunits.Irradiance HSet = 1000
    "Solar irradiance that enables shading device deployment";

  CDL.Continuous.Sources.Sine H(
    final amplitude=100,
    final freqHz=1/(2*1800),
    final offset=HSet - (100/2))
    "Solar irradiance that crosses the enable treshold from below and from above"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(H.y, shaH.H) annotation (Line(points={{-19,0},{18,0}}, color={0,0,127}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
    __Dymola_Commands(file=
        "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Shade/Validation/Shade_H.mos"
        "Simulate and plot"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,-40},{80,40}})),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.Shade.Shade_H\">
Buildings.Controls.OBC.Shade.Shade_H</a>
for a solar irradiance input signal.
</p>
</html>", revisions="<html>
<ul>
<li>
June 05, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Shade_H;
