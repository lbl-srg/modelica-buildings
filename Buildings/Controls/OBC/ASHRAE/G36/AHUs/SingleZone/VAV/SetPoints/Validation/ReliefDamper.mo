within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Validation;
model ReliefDamper "Validation of relief damper control"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefDamper relDam(final
      relDam_min=0.1, final relDam_max=0.6) "Relief damper controller"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp outDamMin(
    final height=0.1,
    final offset=0.1,
    final duration=3600)
    "Outdoor damper minimum position"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse fanStatus(final width=0.8,
    final period=3600)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp outDam(
    final height=0.6,
    final offset=0.2,
    final duration=3600)
    "Outdoor damper position"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(fanStatus.y, relDam.u1SupFan) annotation (Line(points={{-38,-60},{20,
          -60},{20,-7},{58,-7}}, color={255,0,255}));
  connect(outDam.y, relDam.uOutDam)
    annotation (Line(points={{-38,0},{58,0}}, color={0,0,127}));
  connect(outDamMin.y, relDam.uOutDam_min) annotation (Line(points={{-38,60},{
          20,60},{20,7},{58,7}}, color={0,0,127}));

annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600, Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/Validation/ReliefDamper.mos"
    "Simulate and plot"),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefDamper\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefDamper</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 8, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReliefDamper;
