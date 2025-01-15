within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.Validation;
model WSEOperation
  "Validates cooling tower fan speed control sequence for WSE running only"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.WSEOperation
    wseOpe(
    fanSpeMin=0.1,
    fanSpeMax=1,
    chiWatCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.1,
    Ti=5)
    "Tower fan speed control when there is only waterside economizer is running"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin chiSup(
    amplitude=0.5,
    freqHz=1/1800,
    offset=273.15 + 7.1)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiSupSet(
    k=273.15 + 7)
    "Chilled water supply water setpoint"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram1(
    height=3,
    duration=3600,
    startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 "Add real inputs"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay fanSpe(
    samplePeriod=1)
    "Current fan speed"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

equation
  connect(chiSupSet.y, wseOpe.TChiWatSupSet)
    annotation (Line(points={{42,-30},{50,-30},{50,22},{58,22}}, color={0,0,127}));
  connect(chiSup.y, add2.u1)
    annotation (Line(points={{-58,20},{-40,20},{-40,6},{-22,6}}, color={0,0,127}));
  connect(ram1.y, add2.u2)
    annotation (Line(points={{-58,-20},{-40,-20},{-40,-6},{-22,-6}}, color={0,0,127}));
  connect(add2.y, wseOpe.TChiWatSup)
    annotation (Line(points={{2,0},{20,0},{20,30},{58,30}}, color={0,0,127}));
  connect(wseOpe.ySpeSet, fanSpe.u) annotation (Line(points={{82,30},{90,30},{90,
          80},{-30,80},{-30,60},{-22,60}}, color={0,0,127}));
  connect(fanSpe.y, wseOpe.uFanSpe) annotation (Line(points={{2,60},{20,60},{20,
          38},{58,38}}, color={0,0,127}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/FanSpeed/EnabledWSE/Subsequences/Validation/WSEOperation.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.WSEOperation\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.WSEOperation</a>.
It shows following control process:
</p>
<ul>
<li>
In the begining period, the chilled water supply temperature is greater than the setpoint.
The direct acting PID controller increases the output to the maximum output so that
the fan speed setpoint is 1. The measured fan speed becomes 1.
</li>
<li>
In the following period, the chilled water supply temperature gradually reduces and
till to becomes lower than the setpoint, the PID controller decreases the output to
the minimum so that the fan speed setpoint becomes the minimum. The measured speed
becomes the minimum as well.
</li>
<li>
In the next period, after a 300 seconds during which both the chilled water supply
temperature is lower than the setpoint and the fan speed stays at minimum value,
the fan cycles off that the fan speed setpoint becomes zero. Thus the measured
speed becomes zero.
</li>
<li>
After the fan has cycled off for more than 180 seconds, and the chilled water supply
temperature becomes greater than the setpoint plus 1 &deg;F, the fan turns on and
the direct PID controller increases the output to the maximum output
and so the fan speed setpoint becomes 1. The measured speed becomes 1.
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
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{120,100}}),
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
end WSEOperation;
