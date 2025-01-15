within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Validation;
model Speed_primary_localDp
  "Validate sequence of controlling chilled water pump speed for primary-only plants with local DP sensor hardwired to the plant controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Speed_primary_localDp
    chiPumSpe(nSen=2, nPum=2)
    "Chilled water pump speed control based local pressure difference sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse pumSta[2](
    final width=fill(0.9, 2),
    final period=fill(10, 2),
    final shift=fill(1, 2)) "Pump status"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant difPreSet(
    final k=8.5*6894.75)
    "Pressure difference setpoint"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin remPreSen1(
    final offset=8.5*6894.75,
    final freqHz=1/10,
    final amplitude=1.5*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin remPreSen2(
    final offset=8.5*6894.75,
    final freqHz=1/10,
    final startTime=2,
    final amplitude=1*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin locPreSen(
    final freqHz=1/5,
    final amplitude=1*6894.75,
    final offset=8.5*6894.75)  "Local pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=2) "Replicate real input"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));

equation
  connect(locPreSen.y, chiPumSpe.dpChiWat_local)
    annotation (Line(points={{-38,80},{0,80},{0,8},{18,8}},
      color={0,0,127}));
  connect(remPreSen1.y, chiPumSpe.dpChiWat_remote[1])
    annotation (Line(points={{-38,0},{-20,0},{-20,-4.5},{18,-4.5}},
      color={0,0,127}));
  connect(remPreSen2.y, chiPumSpe.dpChiWat_remote[2])
    annotation (Line(points={{-38,-40},{-20,-40},{-20,-3.5},{18,-3.5}},
      color={0,0,127}));
  connect(pumSta.y, chiPumSpe.uChiWatPum)
    annotation (Line(points={{-38,40},{-20,40},{-20,4},{18,4}},
      color={255,0,255}));
  connect(difPreSet.y, reaRep.u)
    annotation (Line(points={{-38,-80},{-32,-80}}, color={0,0,127}));
  connect(reaRep.y, chiPumSpe.dpChiWatSet_remote)
    annotation (Line(points={{-8,-80},{0,-80},{0,-8},{18,-8}}, color={0,0,127}));

annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Pumps/ChilledWater/Subsequences/Validation/Speed_primary_localDp.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Speed_primary_localDp\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Speed_primary_localDp</a>.
</p>
<p>
It shows the process of specifying the chilled water pump speed
for a primary-only plant, with one local pressure sensor and two
remote pressure sensors.
</p>
<ul>
<li>
Both pumps become enabled at 1 second. Thus the pump speed
setpoint becomes non-zero.
</li>
<li>
After 1 seconds, the two remote pressure sensors have the measured values higher than
the setpoint. The reverse acting PID controller thus gives the minimum
output. The local pressure setpoint is at the minimum value (<code>50000 Pa</code>).
</li>
<li>
When the remote sensors have the measured values that becoome lower than the setpoint,
their reverse acting PID controllers give the output greater than the minimum.
The greater of the two output values from both PID controllers is picked for
specifying the local pressure setpoint (<code>locDpSet.y</code>).
</li>
<li>
The reverse acting PID controller for the local pressure control gives
minimum output (<code>0.1</code>) if the measured local pressure value is greater than its
setpoint. When the measured value becomes greater than its setpoint,
the PID controller increases its output, thus increases the chilled water
pump speed.
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
