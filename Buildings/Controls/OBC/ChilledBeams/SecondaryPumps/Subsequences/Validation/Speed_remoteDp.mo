within Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences.Validation;
model Speed_remoteDp
  "Validate sequence of controlling chilled water pump speed using remote DP"

  Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences.Speed_remoteDp
    chiPumSpe(
    final nSen=2,
    final nPum=2)
    "Chilled water pump speed control based on remote hardwired differential pressure sensor"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse pumSta[2](
    final width=fill(0.95, 2),
    final period=fill(10, 2),
    final shift=fill(1, 2))
    "Pump status"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant difPreSet(
    final k=8.5)
    "Pressure difference setpoint"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin remPreSen1(
    final offset=8.5,
    final freqHz=1/10,
    final amplitude=1.5)
    "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin remPreSen2(
    final offset=8.5,
    final freqHz=1/10,
    final startTime=2,
    final amplitude=1)
    "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

equation
  connect(difPreSet.y,chiPumSpe.dpChiWatSet)
    annotation (Line(points={{-38,-60},{-20,-60},{-20,-8},{38,-8}},
      color={0,0,127}));

  connect(remPreSen1.y, chiPumSpe.dpChiWat[1]) annotation (Line(points={{-38,20},
          {-20,20},{-20,-1},{38,-1}}, color={0,0,127}));

  connect(remPreSen2.y, chiPumSpe.dpChiWat[2]) annotation (Line(points={{-38,-20},
          {-30,-20},{-30,1},{38,1}}, color={0,0,127}));

  connect(pumSta.y, chiPumSpe.uChiWatPum) annotation (Line(points={{-38,60},{-10,
          60},{-10,8},{38,8}}, color={255,0,255}));
annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ChilledBeams/SecondaryPumps/Subsequences/Validation/Speed_remoteDp.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences.Speed_remoteDp\">
Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences.Speed_remoteDp</a>.
</p>
<p>
It consists of an open-loop setup for block <code>chiPumSpe</code> with
a Boolean pulse input signal <code>pumSta</code> that is used to simulate chilled 
water pump status <code>chiPumSpe.uChiWatPum</code>, 
two sine input signals <code>remPreSen1</code> and <code>remPreSen2</code> that 
are used to represent remote pressure difference sensor readings, 
a constant input signal <code>difPreSet</code> that generates a pressure difference 
setpoint, and an output signal <code>chiPumSpe.yChiWatPumSpe</code> for the 
chilled water pump speed setpoint in chilled beam systems with variable-speed pumps. 
</p>
<p>
The following observations should be apparent from the simulation plots:
<ol>
<li>
The block <code>chiPumSpe</code> outputs chilled water pump speed <code>yChiWatPumSpe</code>,
based on the difference between the measured chilled water differential pressure
<code>dpChiWat</code> and the setpoint <code>dpChiWatSet</code> whenever any of the pumps 
are proven on (<code>uChiWatPum = true</code>).
</li>
<li>
<code>chiPumSpe</code> runs the pump at minimum speed (<code>yChiWatPumSpe = minPumSpe</code>)
when none of the pumps are not yet proven on (<code>uChiWatPum = false</code>).
</li>
</ol>
</p>
</html>", revisions="<html>
<ul>
<li>
August 4, 2020, by Karthik Devaprasad:<br/>
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
end Speed_remoteDp;
