within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.Validation;
model ResetMinBypass
  "Validate sequence of reseting minimum flow bypass"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.ResetMinBypass
    minBypRes(byPasSetTim=120)
    "Check if the setpoint has achieved"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.15,
    final period=600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not upStrDev
    "Upstream device reset status"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.2,
    final period=600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp minFloSet(
    final height=0.5,
    final duration=60,
    final offset=1,
    final startTime=120) "Minimum chiller water flow setpoint"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp meaFlo(
    final height=0.7,
    final duration=80,
    final offset=1,
    final startTime=120) "Measured chiller water flow"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  CDL.Logical.And inPro "In setpoint changing process"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  CDL.Logical.Sources.Pulse                        booPul3(final width=0.5,
      final period=600)
                      "Boolean pulse"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

equation
  connect(booPul2.y, upStrDev.u)
    annotation (Line(points={{-58,80},{-42,80}}, color={255,0,255}));
  connect(booPul1.y, staUp.u)
    annotation (Line(points={{-58,40},{-42,40}}, color={255,0,255}));
  connect(upStrDev.y, minBypRes.uUpsDevSta)
    annotation (Line(points={{-18,80},{0,80},{0,8},{18,8}}, color={255,0,255}));
  connect(staUp.y, minBypRes.uStaPro) annotation (Line(points={{-18,40},{-10,40},
          {-10,4},{18,4}}, color={255,0,255}));
  connect(meaFlo.y, minBypRes.VChiWat_flow)
    annotation (Line(points={{-58,0},{18,0}}, color={0,0,127}));
  connect(minFloSet.y, minBypRes.VMinChiWat_setpoint)
    annotation (Line(points={{-18,-30},{0,-30},{0,-4},{18,-4}}, color={0,0,127}));
  connect(inPro.y, minBypRes.uSetChaPro) annotation (Line(points={{-18,-70},{10,
          -70},{10,-8},{18,-8}}, color={255,0,255}));

  connect(booPul3.y, inPro.u1)
    annotation (Line(points={{-58,-70},{-42,-70}}, color={255,0,255}));
  connect(upStrDev.y, inPro.u2) annotation (Line(points={{-18,80},{0,80},{0,8},{
          -50,8},{-50,-78},{-42,-78}}, color={255,0,255}));
annotation (
 experiment(StopTime=600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Staging/Processes/Subsequences/Validation/ResetMinBypass.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.ResetMinBypass\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.ResetMinBypass</a>.
</p>
<p>
The instance <code>minBypRes</code> shows the process of changing the bypass valve
when the minimum bypass chilled water flow setpoint has been changed, when the
plant is in a staging up process.
</p>
<ul>
<li>
Before 90 seconds, the plant is not in the staging process. There is no change to the
minimum bypass valve (<code>yMinBypRes=true</code>).
</li>
<li>
At 90 seconds, the plant starts staging process. However, it is not yet to change
the bypass valve (<code>yMinBypRes=true</code>). As the upstream subprocess has
not finished (<code>uUpsDevSta=false</code>).
</li>
<li>
At 120 seconds, the plant is still in the staging process and the upstream subprocess
has finished (<code>uUpsDevSta=true</code>). It starts changing the minimum flow
setpoint (<code>uSetChaPro=true</code>) and changing the bypass valve
(<code>yMinBypRes=false</code>). The measured chiller water flow becomes different
from its setpoint.
</li>
<li>
At 300 seconds, it finished the setpoint changing process and the <code>uSetChaPro</code>
becomes false. The chilled water flow has been greater than the setpoint.
</li>
<li>
After 60 seconds to 360 seconds, the minimum bypass valve position changing process
is finished (<code>yMinBypRes=true</code>).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 26, 2019, by Jianjun Hu:<br/>
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
