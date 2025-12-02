within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.Validation;
model Speed_primary_localDp
  "Validate sequence of controlling chilled water pump speed for primary-only plants with local DP sensor hardwired to the plant controller"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.Speed_primary_localDp
    chiPumSpe(        nPum=2)
    "Chilled water pump speed control based local pressure difference sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse pumSta[2](
    final width=fill(0.9, 2),
    final period=fill(10, 2),
    final shift=fill(1, 2)) "Pump status"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp locDpSet(
    final height=20000,
    final duration=3,
    final offset=55000,
    final startTime=5) "Local differential pressure setpoint"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin locPreSen(
    final freqHz=1/5,
    final amplitude=1*6894.75,
    final offset=8.5*6894.75)  "Local pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,52},{-40,72}})));

equation
  connect(locPreSen.y, chiPumSpe.dpChiWat_local)
    annotation (Line(points={{-38,62},{0,62},{0,6},{18,6}},
      color={0,0,127}));
  connect(pumSta.y, chiPumSpe.uChiWatPum)
    annotation (Line(points={{-38,-60},{0,-60},{0,-6},{18,-6}},
      color={255,0,255}));
  connect(locDpSet.y, chiPumSpe.dpChiWatSet_local)
    annotation (Line(points={{-38,0},{18,0}}, color={0,0,127}));
annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Pumps/ChilledWater/Subsequences/Validation/Speed_primary_localDp.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.Speed_primary_localDp\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.Speed_primary_localDp</a>.
</p>
<p>
It shows the process of specifying the chilled water pump speed
for a primary-only plant, with one local pressure sensor and two
remote pressure sensors.
</p>
<ul>
<li>
Both pumps become enabled at 1 second. Thus, the pump speed
setpoint becomes non-zero.
</li>
<li>
From 1 second to 3 seconds, the measured pressure is greater
than the setpoint. Thus, the pump speed is at the minimum (0.1).
</li>
<li>
From 3 seconds to 4.5 seconds, the measured pressure becomes lower than the setpoint.
Thus, the pump speed increases.
</li>
<li>
From 4.5 seconds to 6.5 seconds, the measured pressure becomes greater than the
setpoint. Thus, the pump speed becomes the minimum (0.1) again.
</li>
<li>
After 6.5 seconds, the measured pressure becomes lower than the set point.
The pump speed increases up to the maximum speed (1.0).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
Arpil 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Speed_primary_localDp;
