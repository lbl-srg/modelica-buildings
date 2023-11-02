within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Validation;
model ExhaustDamper
  "Validate of the controller for actuated exhaust damper without fan"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ExhaustDamper
    exhDamPos "Block of controlling actuated exhaust damper without fan"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFan(k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-40,-52},{-20,-32}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp outDamPos(
    duration=1200,
    startTime=0,
    height=0.6,
    offset=0.4)
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

equation
  connect(supFan.y, exhDamPos.uSupFan) annotation (Line(points={{-19,-42},{0,-42},
          {0,-6},{39,-6}}, color={255,0,255}));
  connect(outDamPos.y, exhDamPos.uOutDamPos)
    annotation (Line(points={{-19,40},{0,40},{0,6},{39,6}},
      color={0,0,127}));

annotation (
  experiment(StopTime=1200.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/SetPoints/Validation/ExhaustDamper.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ExhaustDamper\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ExhaustDamper</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end ExhaustDamper;
