within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.Validation;
model EnableLag_variableSecondary_flowrate
    "Validate sequence for enabling variable-speed secondary lag pumps with flowrate sensor in secondary loop"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLag_variableSecondary_flowrate
    enaLagSecPum(
    final nPum=3)
    "Enable variable-speed secondary lag pump with flowrate sensor in secondary loop"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold nexLagPum(
    final trueHoldDuration=10)
    "Hold pulse signal for easy visualization"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold preLagPum(
    final trueHoldDuration=10)
    "Hold pulse signal for easy visualization"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](
    final k=fill(true, 2))
    "Constant true"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=0.25,
    final freqHz=1/3600,
    final offset=0.25)
    "Measured hot water flow rate"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

equation
  connect(con[1].y,enaLagSecPum. uHotWatPum[1]) annotation (Line(points={{-58,20},
          {-42,20},{-42,14.8667},{-22,14.8667}},color={255,0,255}));

  connect(con[2].y,enaLagSecPum. uHotWatPum[2]) annotation (Line(points={{-58,20},
          {-42,20},{-42,16.2},{-22,16.2}},color={255,0,255}));

  connect(con1.y,enaLagSecPum. uHotWatPum[3]) annotation (Line(points={{-58,-20},
          {-40,-20},{-40,17.5333},{-22,17.5333}}, color={255,0,255}));

  connect(sin.y,enaLagSecPum.VHotWat_flow)
    annotation (Line(points={{-58,60},{-40,60},{-40,24},{-22,24}},
      color={0,0,127}));

  connect(enaLagSecPum.yUp, nexLagPum.u) annotation (Line(points={{2,24},{16,24},
          {16,40},{28,40}}, color={255,0,255}));

  connect(enaLagSecPum.yDown, preLagPum.u) annotation (Line(points={{2,16},{16,16},
          {16,0},{28,0}}, color={255,0,255}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Pumps/SecondaryPumps/Subsequences/Validation/EnableLag_variableSecondary_flowrate.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLag_variableSecondary_flowrate\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLag_variableSecondary_flowrate</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 25, 2020, by Karthik Devaprasad:<br/>
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
end EnableLag_variableSecondary_flowrate;
