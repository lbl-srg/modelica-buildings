within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.Validation;
model ReturnFanDirectPressure
  "Validate model for calculating return fan control with direct building pressure
  of multi zone VAV AHU"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.ReturnFanDirectPressure
    retFanPre(k=0.1) "Return fan control with direct building pressure"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse yFan(period=4000)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dpBui(
    height=40,
    offset=0,
    duration=1800) "Building static presure"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.ReturnFanDirectPressure
    retFanPre1(k=0.5) "Return fan control with direct building pressure"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.ReturnFanDirectPressure
    retFanPre2 "Return fan control with direct building pressure"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(yFan.y, retFanPre.uFan) annotation (Line(points={{-59,70},{-20,70},{-20,
          64},{18,64}}, color={255,0,255}));
  connect(dpBui.y, retFanPre.dpBui) annotation (Line(points={{-59,20},{0,20},{0,
          76},{18,76}}, color={0,0,127}));
  connect(yFan.y, retFanPre1.uFan) annotation (Line(points={{-59,70},{-20,70},{
          -20,14},{18,14}}, color={255,0,255}));
  connect(yFan.y, retFanPre2.uFan) annotation (Line(points={{-59,70},{-20,70},{
          -20,-36},{18,-36}}, color={255,0,255}));
  connect(dpBui.y, retFanPre1.dpBui) annotation (Line(points={{-59,20},{0,20},{0,
          26},{18,26}}, color={0,0,127}));
  connect(dpBui.y, retFanPre2.dpBui) annotation (Line(points={{-59,20},{0,20},{0,
          -24},{18,-24}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/SetPoints/Validation/ReturnFanDirectPressure.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.ReturnFanDirectPressure\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.ReturnFanDirectPressure</a>
for exhaust air damper and return fan control with direct building pressure measurement
for systems with multiple
zones.
</p>
</html>", revisions="<html>
<ul>
<li>
October 16, 2017, by Michael Wetter:<br/>
Changed example to also test for fan off signal.
</li>
<li>
October 16, 2017, by Jianjun Hu:<br/>
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
end ReturnFanDirectPressure;
