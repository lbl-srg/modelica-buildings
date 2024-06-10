within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.Validation;
model FreezeProtectionMixedAir
  "Validation model for the mixed air temperature based freeze protection block"

  parameter Real TFreSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")= 273.15 + 4
    "Freeze protection set point temperature";

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.FreezeProtectionMixedAir
    freProTMix(final TFreSet=TFreSet)
    "Freeze protection signal based on mixed air temperature"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin1(
    amplitude=20,
    freqHz=1/1800,
    startTime=0,
    offset=TFreSet - 1) "Sine shaped mixed air temperature input signal"
    annotation (Placement(transformation(extent={{-40,2},{-20,20}})));

equation
  connect(sin1.y, freProTMix.TMix)
  annotation (Line(points={{-18,11},{-10,11},{-10,10},{-2,10}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/Generic/Validation/FreezeProtectionMixedAir.mos"
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},{60,60}})),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.FreezeProtectionMixedAir\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.FreezeProtectionMixedAir</a>
for mixed air temperature <code>TMix</code> signal.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 07, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end FreezeProtectionMixedAir;
