within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.Validation;
model ReliefDamper
  "Validate model for calculating relief damper control"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefDamper relDam(
    final k=0.1) "Relief damper control"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefDamper relDam1
    "Relief damper control"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse yFan(
    final period=4000) "Supply fan status"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp dpBui(
    final height=40,
    final offset=0,
    final duration=1800) "Building static presure"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

equation
  connect(yFan.y, relDam.u1SupFan) annotation (Line(points={{-58,70},{-20,70},{
          -20,64},{18,64}}, color={255,0,255}));
  connect(dpBui.y, relDam.dpBui) annotation (Line(points={{-58,20},{0,20},{0,76},
          {18,76}}, color={0,0,127}));
  connect(yFan.y, relDam1.u1SupFan) annotation (Line(points={{-58,70},{-20,70},
          {-20,-36},{18,-36}}, color={255,0,255}));
  connect(dpBui.y, relDam1.dpBui) annotation (Line(points={{-58,20},{0,20},{0,-24},
          {18,-24}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/SetPoints/Validation/ReliefDamper.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefDamper\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefDamper</a>
for actuated relief damper control without fan
for systems with multiple
zones.
</p>
</html>", revisions="<html>
<ul>
<li>
February 6, by Jianjun Hu:<br/>
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
end ReliefDamper;
