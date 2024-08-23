within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Validation;
model LessCoupled
  "Validation sequence of controlling tower fan speed based on condenser water return temperature control for less coupled plant"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.LessCoupled
    lesCouTowSpe
    "Tower fan speed control based on the condenser water return temperature control for close coupled plants"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin conRet(
    amplitude=2,
    freqHz=1/1800,
    offset=273.15 + 32) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram1(
    height=3,
    duration=3600,
    startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 "Add real inputs"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conRetSet(
    k=273.15 + 32) "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp conWatPumSpe[2](
    height=fill(0.5, 2),
    duration=fill(3600, 2),
    startTime=fill(300, 2)) "Measured condenser water pump speed"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp towMaxSpe(
    height=0.25,
    duration=3600,
    offset=0.5) "Maximum tower speed specified by head pressure control loop"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp towMaxSpe1(
    height=-0.25,
    duration=3600,
    offset=0.8) "Maximum tower speed specified by head pressure control loop"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp plrTowMaxSpe(
    height=-0.3,
    duration=3600,
    offset=0.9) "Maximum tower speed reset based on the partial load"
    annotation (Placement(transformation(extent={{50,-140},{70,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin conSup(
    amplitude=2,
    freqHz=1/1800,
    offset=273.15 + 29) "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram2(
    height=3,
    duration=3600,
    startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1 "Add real inputs"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[2] "Logical switch"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer[2](
    k=fill(0,2))   "Constant zero"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[2] "Logical not"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta1(
    width=0.2,
    period=3600) "Chiller one enabling status"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta2(
    width=0.1,
    period=3600)  "Chiller one enabling status"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaEna(
    k=true) "Plant enable status"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

equation
  connect(conRetSet.y, lesCouTowSpe.TConWatRetSet)
    annotation (Line(points={{2,140},{40,140},{40,90},{58,90}}, color={0,0,127}));
  connect(conRet.y, add2.u1)
    annotation (Line(points={{-58,140},{-40,140},{-40,116},{-22,116}},
      color={0,0,127}));
  connect(ram1.y, add2.u2)
    annotation (Line(points={{-58,110},{-40,110},{-40,104},{-22,104}},
      color={0,0,127}));
  connect(add2.y, lesCouTowSpe.TConWatRet)
    annotation (Line(points={{2,110},{32,110},{32,88},{58,88}},
      color={0,0,127}));
  connect(conWatPumSpe.y, lesCouTowSpe.uConWatPumSpe)
    annotation (Line(points={{-58,60},{20,60},{20,82},{58,82}}, color={0,0,127}));
  connect(conSup.y, add1.u1)
    annotation (Line(points={{-58,30},{-40,30},{-40,36},{-22,36}},
      color={0,0,127}));
  connect(ram2.y, add1.u2)
    annotation (Line(points={{-58,0},{-40,0},{-40,24},{-22,24}}, color={0,0,127}));
  connect(add1.y, lesCouTowSpe.TConWatSup)
    annotation (Line(points={{2,30},{26,30},{26,78},{58,78}},
      color={0,0,127}));
  connect(chiSta1.y, not1[1].u)
    annotation (Line(points={{-58,-100},{-50,-100},{-50,-130},{-42,-130}},
      color={255,0,255}));
  connect(chiSta2.y, not1[2].u)
    annotation (Line(points={{-58,-140},{-50,-140},{-50,-130},{-42,-130}},
      color={255,0,255}));
  connect(towMaxSpe.y, swi[1].u1)
    annotation (Line(points={{-58,-40},{-40,-40},{-40,-42},{-2,-42}},
      color={0,0,127}));
  connect(towMaxSpe1.y, swi[2].u1)
    annotation (Line(points={{-58,-70},{-40,-70},{-40,-42},{-2,-42}},
      color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-18,-90},{-6,-90},{-6,-58},{-2,-58}}, color={0,0,127}));
  connect(not1.y, swi.u2)
    annotation (Line(points={{-18,-130},{-12,-130},{-12,-50},{-2,-50}},
      color={255,0,255}));
  connect(swi.y, lesCouTowSpe.uMaxTowSpeSet)
    annotation (Line(points={{22,-50},{32,-50},{32,75},{58,75}}, color={0,0,127}));
  connect(not1.y, lesCouTowSpe.uChi)
    annotation (Line(points={{-18,-130},{38,-130},{38,73},{58,73}}, color={255,0,255}));
  connect(plrTowMaxSpe.y, lesCouTowSpe.plrTowMaxSpe)
    annotation (Line(points={{72,-130},{80,-130},{80,60},{44,60},{44,70},
      {58,70}}, color={0,0,127}));
  connect(plaEna.y, lesCouTowSpe.uPla) annotation (Line(points={{2,80},{14,80},{
          14,85},{58,85}}, color={255,0,255}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/FanSpeed/ReturnWaterTemperature/Subsequences/Validation/LessCoupled.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.LessCoupled\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.LessCoupled</a>.
</p>
<p>
It shows the calculation of the condenser water supply temperature setpoint and
the tower fan speed setpoint.
</p>
<ul>
<li>
At the first 5 minutes when the plant just enabled, the condenser water supply
temperature setpoint equals to the condenser water return temperature setpoint
minus 50% of the difference between design condenser water supply 
(<code>TConWatSup_nominal</code>) and return (<code>TConWatRet_nominal</code>)
temperature of the enabled chiller. Note that in this period,
the chiller are not enabled so the fan speed setpoint is 0.
</li>
<li>
After 5 minutes, the condenser water supply temperature setpoint equals to
condenser water return temperature setpoint TConWatRetSet minus a temperature
difference that equals 5 minute rolling average of common condenser water
return temperature <code>TConWatRet</code> less condenser water supply
temperature <code>TConWatSup</code>, sampled at minimum once every 30
seconds.
</li>
<li>
The fan speed setpoint is the minimum of:
<ul>
<li>
the maximum cooling tower speed setpoint from head pressure control loop
of the enabled chiller, <code>uMaxTowSpeSet</code>,
</li>
<li>
the tower maximum speed that reset based on plant partial load ratio,
<code>plrTowMaxSpe</code>,
</li>
<li>
and the tower speed from the loop mapping based on the PID control
for maintaining the condenser water supply temperature to be at its
setpoint.
</li>
</ul>
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,160}})));
end LessCoupled;
