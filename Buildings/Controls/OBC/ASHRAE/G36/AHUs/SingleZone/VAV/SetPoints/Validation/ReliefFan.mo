within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Validation;
model ReliefFan "Validate model for controlling relief fan"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefFan
    relFanCon(
    final k=0.5) "Open relief damper"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefFan
    relFanCon1 "Turning on relief fan"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefFan
    relFanCon2 "Turning off relief fan"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFan(final width=0.8,
      final period=3600)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dpBui(
    final height=40,
    final offset=0,
    final duration=1800) "Building static presure"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dpBui1(
    final height=-15,
    final offset=20,
    final duration=1800,
    startTime=1800)
    "Building static presure"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFan1(
    final k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dpBui2(
    final height=3,
    final offset=11,
    final duration=1800)
    "Building static presure"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

equation
  connect(dpBui.y, relFanCon1.dpBui) annotation (Line(points={{-18,-10},{0,-10},
          {0,13},{38,13}},   color={0,0,127}));
  connect(dpBui1.y, relFanCon2.dpBui) annotation (Line(points={{-18,-70},{0,-70},
          {0,-77},{38,-77}},     color={0,0,127}));
  connect(supFan.y, relFanCon.u1SupFan) annotation (Line(points={{-58,70},{20,70},
          {20,77},{38,77}},  color={255,0,255}));
  connect(supFan1.y, relFanCon1.u1SupFan) annotation (Line(points={{-58,-40},{20,
          -40},{20,7},{38,7}},color={255,0,255}));
  connect(supFan1.y, relFanCon2.u1SupFan) annotation (Line(points={{-58,-40},{20,
          -40},{20,-83},{38,-83}},  color={255,0,255}));
  connect(dpBui2.y, relFanCon.dpBui) annotation (Line(points={{-18,40},{0,40},{0,
          83},{38,83}}, color={0,0,127}));
annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/Validation/ReliefFan.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefFan</a>
for controlling relief fan that is part of AHU.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end ReliefFan;
