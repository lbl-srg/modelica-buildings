within Buildings.Controls.OBC.Shade.Validation;
model Shade_T "Validation model for shading control based on temperature"
  import Buildings;

  // tests response to a solar irradiance input
  Buildings.Controls.OBC.Shade.Shade_T shaT "Shade enable/disable controller"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  parameter Modelica.SIunits.Temperature TSet(
    final displayUnit="degC") = 300
    "Temperature that enables shading device deployment";

  CDL.Continuous.Sources.Sine T(
    final amplitude=10,
    final freqHz=1/(2*1800),
    final offset=TSet - 10/2)
    "Temperature that crosses the enable treshold from below and from above"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(T.y, shaT.T) annotation (Line(points={{-19,0},{18,0}}, color={0,0,127}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
    __Dymola_Commands(file=
        "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Shade/Validation/Shade_T.mos"
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
<a href=\"modelica://Buildings.Controls.OBC.Shade.Shade_T\">
Buildings.Controls.OBC.Shade.Shade_T</a>
for a temperature input signal.
</p>
</html>", revisions="<html>
<ul>
<li>
June 05, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Shade_T;
