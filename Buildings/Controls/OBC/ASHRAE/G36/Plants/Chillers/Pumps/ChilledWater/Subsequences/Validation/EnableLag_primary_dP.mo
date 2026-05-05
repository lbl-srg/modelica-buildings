within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.Validation;
model EnableLag_primary_dP
  "Validate sequence for enabling lag pump for primary-only plants using differential pressure pump speed control"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP
    enaLagChiPum(
    final nPum=3,
    final VChiWat_flow_nominal=0.5)
    "Enable lag pump for primary-only plants using differential pressure pump speed control"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler enaEdg
    "Sampler to show the lag pump enabling edge"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler disEdg
    "Sampler to show the lag pump disabling edge"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](
    final k=fill(true, 2)) "Constant true"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    final amplitude=0.25,
    final freqHz=1/3600,
    final offset=0.25) "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

equation
  connect(con[1].y, enaLagChiPum.uChiWatPum[1])
    annotation (Line(points={{-38,0},{-20,0},{-20,-4.46667},{-2,-4.46667}},
      color={255,0,255}));
  connect(con[2].y, enaLagChiPum.uChiWatPum[2])
    annotation (Line(points={{-38,0},{-20,0},{-20,-3.8},{-2,-3.8}},
      color={255,0,255}));
  connect(con1.y, enaLagChiPum.uChiWatPum[3])
    annotation (Line(points={{-38,-40},{-20,-40},{-20,-3.13333},{-2,-3.13333}},
      color={255,0,255}));
  connect(sin.y, enaLagChiPum.VChiWat_flow)
    annotation (Line(points={{-38,40},{-20,40},{-20,4},{-2,4}},
      color={0,0,127}));
  connect(enaLagChiPum.yUp, enaEdg.trigger)
    annotation (Line(points={{22,4},{40,4},{40,48}}, color={255,0,255}));
  connect(sin.y, enaEdg.u) annotation (Line(points={{-38,40},{-20,40},{-20,60},{
          28,60}}, color={0,0,127}));
  connect(enaLagChiPum.yDown, disEdg.trigger)
    annotation (Line(points={{22,-4},{80,-4},{80,28}}, color={255,0,255}));
  connect(sin.y, disEdg.u)
    annotation (Line(points={{-38,40},{68,40}}, color={0,0,127}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Pumps/ChilledWater/Subsequences/Validation/EnableLag_primary_dP.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP</a>.
It validates the conditions for enabling and disabling the lag pump.
</p>
<ul>
<li>
At 2.8 minutes, the condition for enabling the lag pump becomes satisfied and it
lasts more than 10 minutes. At 12.8 minutes, the lag pump enabling output becomes true.
</li>
<li>
At 34 minutes, the condition for disabling the lag pump becomes satisfied and it remains
true for more than 10 minutes. At 44 minutes, the lag pump disabling output becomes true.
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
end EnableLag_primary_dP;
