within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.Validation;
model ReturnFanAirflowTracking
  "Validate model for controlling return fan of units using return fan with airflow tracking"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanAirflowTracking
    retFanAirTra(final difFloSet=0.5, final k=0.1)
    "Return fan control with airflow tracking"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanAirflowTracking
    retFanAirTra1(final difFloSet=0.5)
    "Return fan control with airflow tracking"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse yFan(width=0.75,
    final period=4000) "Supply fan status"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp supFlo(
    final height=1.0,
    final offset=0.2,
    final duration=1800) "Supply air flow rate"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp retFlo(
    final height=0.4,
    final offset=0.1,
    final duration=1800) "Return air flow rate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

equation
  connect(yFan.y, retFanAirTra.u1SupFan) annotation (Line(points={{-58,70},{-20,
          70},{-20,64},{18,64}}, color={255,0,255}));
  connect(yFan.y, retFanAirTra1.u1SupFan) annotation (Line(points={{-58,70},{-20,
          70},{-20,-36},{18,-36}}, color={255,0,255}));
  connect(supFlo.y, retFanAirTra.VAirSup_flow) annotation (Line(points={{-58,20},
          {-10,20},{-10,76},{18,76}}, color={0,0,127}));
  connect(supFlo.y, retFanAirTra1.VAirSup_flow) annotation (Line(points={{-58,
          20},{-10,20},{-10,-24},{18,-24}}, color={0,0,127}));
  connect(retFlo.y, retFanAirTra.VAirRet_flow) annotation (Line(points={{-58,-40},
          {0,-40},{0,70},{18,70}}, color={0,0,127}));
  connect(retFlo.y, retFanAirTra1.VAirRet_flow) annotation (Line(points={{-58,-40},
          {0,-40},{0,-30},{18,-30}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/SetPoints/Validation/ReturnFanAirflowTracking.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanAirflowTracking\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanAirflowTracking</a>
for return fan control with airflow tracking
for systems with multiple
zones.
</p>
</html>", revisions="<html>
<ul>
<li>
February 6, 2022, by Jianjun Hu:<br/>
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
end ReturnFanAirflowTracking;
