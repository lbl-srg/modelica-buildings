within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Validation;
model EnableLag_flowrate
  "Validate sequence for enabling lag pump using measured volume flow-rate"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.EnableLag_flowrate
    enaLagPriPum(
    final nPum=3)
    "Enable lag pump for primary-only plants with headered variable speed primary pumps"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold nexLagPum(
    final trueHoldDuration=10)
    "Hold pulse signal for easy visualization"
    annotation (Placement(transformation(extent={{30,20},{50,40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold preLagPum(
    final trueHoldDuration=10)
    "Hold pulse signal for easy visualization"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](
    final k=fill(true, 2))
    "Constant true"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin(
    final amplitude=0.25,
    final freqHz=1/3600,
    final offset=0.25)
    "Measured hot water flow rate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

equation
  connect(con[1].y,enaLagPriPum. uHotWatPum[1]) annotation (Line(points={{-58,0},
          {-42,0},{-42,14.8667},{-22,14.8667}}, color={255,0,255}));

  connect(con[2].y,enaLagPriPum. uHotWatPum[2]) annotation (Line(points={{-58,0},
          {-42,0},{-42,16.2},{-22,16.2}}, color={255,0,255}));

  connect(con1.y,enaLagPriPum. uHotWatPum[3]) annotation (Line(points={{-58,-40},
          {-40,-40},{-40,17.5333},{-22,17.5333}}, color={255,0,255}));

  connect(sin.y,enaLagPriPum.VHotWat_flow)
    annotation (Line(points={{-58,40},{-40,40},{-40,24},{-22,24}},
      color={0,0,127}));

  connect(enaLagPriPum.yUp, nexLagPum.u) annotation (Line(points={{2,24},{16,24},
          {16,30},{28,30}}, color={255,0,255}));
  connect(enaLagPriPum.yDown, preLagPum.u) annotation (Line(points={{2,16},{16,16},
          {16,0},{28,0}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Pumps/Generic/Validation/EnableLag_flowrate.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.EnableLag_flowrate\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.EnableLag_flowrate</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 30, 2020, by Karthik Devaprasad:<br/>
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
end EnableLag_flowrate;
