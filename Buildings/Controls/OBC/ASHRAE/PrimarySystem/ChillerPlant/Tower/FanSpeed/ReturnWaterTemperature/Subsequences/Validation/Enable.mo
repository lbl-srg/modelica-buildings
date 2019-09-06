within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences.Validation;
model Enable "Validation sequence of enabling and disabling tower fans"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine conRet(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 32) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram1(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Add real inputs"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conRetSet(
    final k=273.15 + 32)
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp conWatPumSpe[2](
    final height=fill(0.5, 2),
    final duration=fill(3600, 2),
    final startTime=fill(300, 2)) "Measured condenser water pump speed"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp towMaxSpe(
    final height=0.25,
    final duration=3600,
    final offset=0.5) "Maximum tower speed specified by head pressure control loop"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp towMaxSpe1(
    final height=-0.25,
    final duration=3600,
    final offset=0.8) "Maximum tower speed specified by head pressure control loop"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp plrTowMaxSpe(
    final height=-0.3,
    final duration=3600,
    final offset=0.9) "Maximum tower speed reset based on the partial load"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences.Enable
    enaTow "Enabling and disabling tower fans"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
equation
  connect(conRet.y, add2.u1)
    annotation (Line(points={{-58,80},{-40,80},{-40,56},{-22,56}}, color={0,0,127}));
  connect(ram1.y, add2.u2)
    annotation (Line(points={{-58,50},{-40,50},{-40,44},{-22,44}}, color={0,0,127}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Tower/FanSpeed/ReturnWaterTemperature/Subsequences/Validation/CoupledSpeed.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences.CoupledSpeed\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences.CoupledSpeed</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 12, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Enable;
