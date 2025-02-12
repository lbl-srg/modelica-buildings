within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Validation;
model Coupled
  "Validation sequence of controlling tower fan speed based on condenser water return temperature control for close coupled plant"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Coupled
    couTowSpe(k=0.1, Ti=5)
    "Tower fan speed control based on the condenser water return temperature control for close coupled plants"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin conRet(
    final amplitude=1,
    final freqHz=1/1800,
    final offset=273.15 + 32) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram1(
    final height=2,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 "Add real inputs"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conRetSet(
    final k=273.15 + 32)
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp conWatPumSpe[2](
    final height=fill(0.5, 2),
    final duration=fill(3600, 2),
    final startTime=fill(300, 2)) "Measured condenser water pump speed"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp towMaxSpe(
    final height=0.25,
    final duration=3600,
    final offset=0.5) "Maximum tower speed specified by head pressure control loop"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp towMaxSpe1(
    final height=-0.25,
    final duration=3600,
    final offset=0.8) "Maximum tower speed specified by head pressure control loop"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp plrTowMaxSpe(
    final height=-0.3,
    final duration=3600,
    final offset=0.9) "Maximum tower speed reset based on the partial load"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta1(
    final width=0.2, final period=3600)  "Chiller one enabling status"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[2] "Logical not"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[2] "Logical switch"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta2(
    final width=0.1,
    final period=3600)
    "Chiller one enabling status"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));

equation
  connect(conRetSet.y, couTowSpe.TConWatRetSet)
    annotation (Line(points={{2,120},{20,120},{20,100},{58,100}}, color={0,0,127}));
  connect(conRet.y, add2.u1)
    annotation (Line(points={{-58,120},{-40,120},{-40,96},{-22,96}}, color={0,0,127}));
  connect(ram1.y, add2.u2)
    annotation (Line(points={{-58,60},{-40,60},{-40,84},{-22,84}}, color={0,0,127}));
  connect(add2.y, couTowSpe.TConWatRet)
    annotation (Line(points={{2,90},{20,90},{20,96},{58,96}}, color={0,0,127}));
  connect(conWatPumSpe.y, couTowSpe.uConWatPumSpe)
    annotation (Line(points={{2,50},{26,50},{26,92},{58,92}},   color={0,0,127}));
  connect(chiSta1.y, not1[1].u)
    annotation (Line(points={{-58,-70},{-50,-70},{-50,-90},{-42,-90}},
      color={255,0,255}));
  connect(chiSta2.y, not1[2].u)
    annotation (Line(points={{-58,-110},{-50,-110},{-50,-90},{-42,-90}},
      color={255,0,255}));
  connect(not1.y, swi.u2)
    annotation (Line(points={{-18,-90},{-14,-90},{-14,-10},{-2,-10}},
      color={255,0,255}));
  connect(towMaxSpe1.y, swi[2].u1)
    annotation (Line(points={{-58,-30},{-20,-30},{-20,-2},{-2,-2}},
      color={0,0,127}));
  connect(towMaxSpe.y, swi[1].u1)
    annotation (Line(points={{-58,10},{-20,10},{-20,-2},{-2,-2}}, color={0,0,127}));
  connect(swi.y, couTowSpe.uMaxTowSpeSet)
    annotation (Line(points={{22,-10},{32,-10},{32,88},{58,88}}, color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-18,-50},{-8,-50},{-8,-18},{-2,-18}}, color={0,0,127}));
  connect(not1.y, couTowSpe.uChi)
    annotation (Line(points={{-18,-90},{38,-90},{38,84},{58,84}}, color={255,0,255}));
  connect(plrTowMaxSpe.y, couTowSpe.plrTowMaxSpe)
    annotation (Line(points={{22,-110},{44,-110},{44,80},{58,80}}, color={0,0,127}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/FanSpeed/ReturnWaterTemperature/Subsequences/Validation/Coupled.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Coupled\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Coupled</a>.
</p>
<p>
It shows tower fan speed control for a plant with 2 chillers. The chiller 2 becomes proven on
since 360 seconds and the chiller 1 becomes proven on since 720 seconds. It shows following
processes:
</p>
<ul>
<li>
Before 360 seconds, no chiller is proven. Thus the two speed setpoint is 0.
</li>
<li>
After 360 seconds, chiller 2 becomes proven on and the condenser water pump speed
becomes greater than 0. When the pump speed becomes greater than the threshold
and shows the pump is proven on at around 444 seconds, the PID controller retriggered
and the output starts from the minimum.
However, before the condenser pump is proven on, the
tow fan speed setpoint is 0.
</li>
<li>
From around 444 seconds to 720 seconds, the tow fan speed setpoint is the minimum of
<code>uMaxTowSpeSet[2]</code>, <code>plrTowMaxSpe</code> and the tower speed from
the loop mapping.
</li>
<li>
After 720 seconds when the chiller 1 also becomes proven on, the tow fan speed
setpoint is the minimum of <code>uMaxTowSpeSet[1]</code>, 
<code>uMaxTowSpeSet[2]</code>, <code>plrTowMaxSpe</code> and the tower speed from
the loop mapping.
</li>
</ul>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,140}})));
end Coupled;
