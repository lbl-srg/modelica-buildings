within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences.Validation;
model LessCoupled
  "Validation sequence of controlling tower fan speed based on condenser water return temperature control for less coupled plant"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences.LessCoupled
    lesCouTowSpe
    "Tower fan speed control based on the condenser water return temperature control for close coupled plants"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine conRet(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 32) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram1(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Add real inputs"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conRetSet(
    final k=273.15 + 32)
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp conWatPumSpe[2](
    final height=fill(0.5, 2),
    final duration=fill(3600, 2),
    final startTime=fill(300, 2)) "Measured condenser water pump speed"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp towMaxSpe(
    final height=0.25,
    final duration=3600,
    final offset=0.5) "Maximum tower speed specified by head pressure control loop"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp towMaxSpe1(
    final height=-0.25,
    final duration=3600,
    final offset=0.8) "Maximum tower speed specified by head pressure control loop"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp plrTowMaxSpe(
    final height=-0.3,
    final duration=3600,
    final offset=0.9) "Maximum tower speed reset based on the partial load"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine conSup(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 32) "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram2(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1 "Add real inputs"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

equation
  connect(conRetSet.y, lesCouTowSpe.TConWatRetSet)
    annotation (Line(points={{2,110},{40,110},{40,60},{58,60}}, color={0,0,127}));
  connect(conRet.y, add2.u1)
    annotation (Line(points={{-58,110},{-40,110},{-40,86},{-22,86}},
      color={0,0,127}));
  connect(ram1.y, add2.u2)
    annotation (Line(points={{-58,80},{-40,80},{-40,74},{-22,74}}, color={0,0,127}));
  connect(add2.y, lesCouTowSpe.TConWatRet)
    annotation (Line(points={{2,80},{32,80},{32,56},{58,56}}, color={0,0,127}));
  connect(conWatPumSpe.y, lesCouTowSpe.uConWatPumSpe)
    annotation (Line(points={{-58,40},{20,40},{20,52},{58,52}}, color={0,0,127}));
  connect(towMaxSpe.y, lesCouTowSpe.uMaxTowSpeSet[1])
    annotation (Line(points={{-58,-70},{-40,-70},{-40,-40},{32,-40},{32,44},
      {58,44}}, color={0,0,127}));
  connect(towMaxSpe1.y, lesCouTowSpe.uMaxTowSpeSet[2])
    annotation (Line(points={{2,-70},{32,-70},{32,44},{58,44}}, color={0,0,127}));
  connect(plrTowMaxSpe.y, lesCouTowSpe.plrTowMaxSpe)
    annotation (Line(points={{-58,-110},{40,-110},{40,40},{58,40}}, color={0,0,127}));
  connect(conSup.y, add1.u1)
    annotation (Line(points={{-58,0},{-40,0},{-40,6},{-22,6}}, color={0,0,127}));
  connect(ram2.y, add1.u2)
    annotation (Line(points={{-58,-30},{-40,-30},{-40,-6},{-22,-6}}, color={0,0,127}));
  connect(add1.y, lesCouTowSpe.TConWatSup)
    annotation (Line(points={{2,0},{26,0},{26,48},{58,48}}, color={0,0,127}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Tower/FanSpeed/ReturnWaterTemperature/Subsequences/Validation/LessCoupled.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences.LessCoupled\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences.LessCoupled</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 12, 2019, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,140}})));
end LessCoupled;
