within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.Validation;
model LocalDp_setpoint
  "Validate sequence of calculating local differential pressure setpoint"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.LocalDp_setpoint
    locDpSet(nSen=2, nPum=2) "Local differential pressure setpoint"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse pumSta[2](
    final width=fill(0.9, 2),
    final period=fill(10, 2),
    final shift=fill(1, 2)) "Pump status"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant difPreSet(
    final k=8.5*6894.75)
    "Pressure difference setpoint"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin remPreSen1(
    final offset=8.5*6894.75,
    final freqHz=1/10,
    final amplitude=1.5*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin remPreSen2(
    final offset=8.5*6894.75,
    final freqHz=1/10,
    final startTime=2,
    final amplitude=1*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=2) "Replicate real input"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

equation
  connect(remPreSen1.y, locDpSet.dpChiWat_remote[1]) annotation (Line(points={{-38,20},
          {-20,20},{-20,-0.5},{18,-0.5}}, color={0,0,127}));
  connect(remPreSen2.y, locDpSet.dpChiWat_remote[2]) annotation (Line(points={{-38,-20},
          {-20,-20},{-20,0.5},{18,0.5}}, color={0,0,127}));
  connect(pumSta.y, locDpSet.uChiWatPum) annotation (Line(points={{-38,60},{0,
          60},{0,6},{18,6}}, color={255,0,255}));
  connect(difPreSet.y, reaRep.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={0,0,127}));
  connect(reaRep.y, locDpSet.dpChiWatSet_remote) annotation (Line(points={{-18,-60},
          {0,-60},{0,-5},{18,-5}}, color={0,0,127}));

annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Pumps/ChilledWater/Subsequences/Validation/LocalDp_setpoint.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.LocalDp_setpoint\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.LocalDp_setpoint</a>.
</p>
<p>
It shows the process of specifying the local pressure setpoint
for a primary-only plant, with one local pressure sensor and two
remote pressure sensors.
</p>
<ul>
<li>
After 1 second, the two remote pressure sensors have the measured values higher than
the setpoint. The reverse acting PID controller thus gives the minimum
output. The local pressure setpoint is at the minimum value (<code>50000 Pa</code>).
</li>
<li>
When the remote sensors have the measured values that become lower than the setpoint,
their reverse acting PID controllers give the output greater than the minimum.
The greater of the two output values from both PID controllers is picked for
specifying the local pressure setpoint.
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
end LocalDp_setpoint;
