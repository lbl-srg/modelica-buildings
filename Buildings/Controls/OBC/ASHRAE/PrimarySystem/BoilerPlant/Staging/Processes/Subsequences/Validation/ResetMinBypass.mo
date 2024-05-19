within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.Validation;
model ResetMinBypass
    "Validate sequence of reseting minimum flow bypass"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.ResetMinBypass
    minBypRes
    "Check if the setpoint has achieved"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.15,
    final period=600)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Logical.Not staUp
    "Stage up command"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Logical.Not upStrDev
    "Upstream device reset status"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.2,
    final period=600)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp minFloSet(
    final height=0.5,
    final duration=180,
    final offset=1,
    final startTime=60)
    "Minimum boiler water flow setpoint"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp meaFlo(
    final height=0.5,
    final duration=80,
    final offset=1,
    final startTime=120)
    "Measured boiler water flow"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

equation
  connect(booPul2.y, upStrDev.u)
    annotation (Line(points={{-58,60},{-42,60}}, color={255,0,255}));

  connect(booPul1.y, staUp.u)
    annotation (Line(points={{-58,20},{-42,20}}, color={255,0,255}));

  connect(upStrDev.y, minBypRes.uUpsDevSta)
    annotation (Line(points={{-18,60},{16,60},{16,8},{38,8}}, color={255,0,255}));

  connect(staUp.y, minBypRes.chaPro)
    annotation (Line(points={{-18,20},{12,20},{12,4},{38,4}}, color={255,0,255}));

  connect(meaFlo.y,minBypRes.VHotWat_flow)
    annotation (Line(points={{-18,-20},{12,-20},{12,-4},{38,-4}},
                                                                color={0,0,127}));

  connect(minFloSet.y, minBypRes.VMinHotWatSet_flow) annotation (Line(points={{-18,-60},
          {16,-60},{16,-8},{38,-8}},          color={0,0,127}));

annotation (
 experiment(StopTime=600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/Processes/Subsequences/Validation/ResetMinBypass.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.ResetMinBypass\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.ResetMinBypass</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 13, 2020 by Karthik Devaprasad:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end ResetMinBypass;
