within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Validation;
model EnableLag_primary_dP
  "Validate sequence for enabling lag pump for primary-only plants using differential pressure pump speed control"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP
    enaLagChiPum(
    final nPum=3,
    final VChiWat_flow_nominal=0.5)
    "Enable lag pump for primary-only plants using differential pressure pump speed control"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler nexLagPumTri
    "Next lag pump enabling trigger"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler lasLagPumTri
    "Last lag pump disabling trigger"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](
    final k=fill(true, 2)) "Constant true"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin sin(
    final amplitude=0.25,
    final freqHz=1/3600,
    final offset=0.25) "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin sin1(
    final freqHz=1/3600) "Generate sine wave"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

equation
  connect(con[1].y, enaLagChiPum.uChiWatPum[1])
    annotation (Line(points={{-58,0},{-40,0},{-40,14.8667},{-22,14.8667}},
      color={255,0,255}));
  connect(con[2].y, enaLagChiPum.uChiWatPum[2])
    annotation (Line(points={{-58,0},{-40,0},{-40,16.2},{-22,16.2}},
      color={255,0,255}));
  connect(con1.y, enaLagChiPum.uChiWatPum[3])
    annotation (Line(points={{-58,-40},{-40,-40},{-40,17.5333},{-22,17.5333}},
      color={255,0,255}));
  connect(sin.y, enaLagChiPum.VChiWat_flow)
    annotation (Line(points={{-58,40},{-40,40},{-40,24},{-22,24}},
      color={0,0,127}));
  connect(sin1.y, nexLagPumTri.u)
    annotation (Line(points={{2,60},{38,60}}, color={0,0,127}));
  connect(enaLagChiPum.yUp, nexLagPumTri.trigger)
    annotation (Line(points={{2,24},{50,24},{50,48.2}}, color={255,0,255}));
  connect(sin1.y, lasLagPumTri.u)
    annotation (Line(points={{2,60},{20,60},{20,0},{38,0}}, color={0,0,127}));
  connect(enaLagChiPum.yDown, lasLagPumTri.trigger)
    annotation (Line(points={{2,16},{10,16},{10,-20},{50,-20},{50,-11.8}},
      color={255,0,255}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Pumps/ChilledWater/Subsequences/Validation/EnableLag_primary_dP.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP</a>.
</p>
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
