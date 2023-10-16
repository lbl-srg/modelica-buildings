within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model ResetMinBypass
  "Validate sequence of reseting minimum flow bypass"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass
    minBypRes
    "Check if the setpoint has achieved"
    annotation (Placement(transformation(extent={{40,38},{60,58}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.15,
    final period=600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not upStrDev
    "Upstream device reset status"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.2,
    final period=600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp minFloSet(
    final height=0.5,
    final duration=60,
    final offset=1,
    final startTime=120) "Minimum chiller water flow setpoint"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp meaFlo(
    final height=0.5,
    final duration=80,
    final offset=1,
    final startTime=120) "Measured chiller water flow"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

equation
  connect(booPul2.y, upStrDev.u)
    annotation (Line(points={{-58,50},{-42,50}}, color={255,0,255}));
  connect(booPul1.y, staUp.u)
    annotation (Line(points={{-58,10},{-42,10}}, color={255,0,255}));
  connect(upStrDev.y, minBypRes.uUpsDevSta)
    annotation (Line(points={{-18,50},{0,50},{0,56},{38,56}}, color={255,0,255}));
  connect(staUp.y, minBypRes.chaPro)
    annotation (Line(points={{-18,10},{4,10},{4,52},{38,52}}, color={255,0,255}));
  connect(meaFlo.y, minBypRes.VChiWat_flow)
    annotation (Line(points={{-18,-30},{8,-30},{8,44},{38,44}}, color={0,0,127}));
  connect(minFloSet.y, minBypRes.VMinChiWat_setpoint)
    annotation (Line(points={{-18,-70},{12,-70},{12,40},{38,40}}, color={0,0,127}));

annotation (
 experiment(StopTime=600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/ResetMinBypass.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 26, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-120},{100,100}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end ResetMinBypass;
