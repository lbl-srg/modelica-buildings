within Buildings.Controls.OBC.Shade.Validation;
model Shade_T "Validation model for shade control based on temperature"

  Buildings.Controls.OBC.Shade.Shade_T shaT(
    THigh=298.15,
    TLow=295.15)
    "Shade controller"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  CDL.Continuous.Sources.Sine T(
    final amplitude=10,
    final freqHz=1/(2*1800),
    final offset=293.15)
    "Measured temperature"
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
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
June 8, 2018, by Michael Wetter:<br/>
Refactored model for new implemenation.
</li>
<li>
June 05, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Shade_T;
