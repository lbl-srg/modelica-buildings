within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.Validation;
model ExhaustDamper
  "Validate the controller of an actuated exhaust damper without fan"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.ExhaustDamper
    exhDamPos(k=0.1) "Block of controlling actuated exhaust damper without fan"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFan(k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp meaBuiPre(
    height=8,
    duration=1200,
    offset=8,
    startTime=0)
    "Measured indoor building static pressure"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.ExhaustDamper
    exhDamPos1(k=0.5)
    "Block of controlling actuated exhaust damper without fan"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.ExhaustDamper
    exhDamPos2(k=1) "Block of controlling actuated exhaust damper without fan"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
equation
  connect(meaBuiPre.y, exhDamPos.dpBui) annotation (Line(points={{-59,50},{-40,
          50},{-40,56},{-1,56}}, color={0,0,127}));
  connect(supFan.y, exhDamPos.uSupFan) annotation (Line(points={{-59,-30},{-20,
          -30},{-20,44},{-1,44}}, color={255,0,255}));

  connect(supFan.y, exhDamPos1.uSupFan) annotation (Line(points={{-59,-30},{-20,
          -30},{-20,4},{-1,4}}, color={255,0,255}));
  connect(supFan.y, exhDamPos2.uSupFan) annotation (Line(points={{-59,-30},{-20,
          -30},{-20,-36},{-1,-36}}, color={255,0,255}));
  connect(meaBuiPre.y, exhDamPos1.dpBui) annotation (Line(points={{-59,50},{-40,
          50},{-40,16},{-1,16}}, color={0,0,127}));
  connect(meaBuiPre.y, exhDamPos2.dpBui) annotation (Line(points={{-59,50},{-40,
          50},{-40,-24},{-1,-24}}, color={0,0,127}));
annotation (
  experiment(StopTime=1200.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/SetPoints/Validation/ExhaustDamper.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.ExhaustDamper\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.ExhaustDamper</a>.
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
