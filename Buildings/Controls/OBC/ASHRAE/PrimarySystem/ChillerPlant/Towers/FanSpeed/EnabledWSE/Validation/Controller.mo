within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Validation;
model Controller
  "Validation sequence of controlling tower fan speed when waterside economizer is enabled"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Controller
    wseOpe(
    kWSE=0.1,
    TiWSE=5)
    "Tower fan speed control when waterside economizer is enabled"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiSupSet(
    k=273.15 + 7)
    "Chilled water supply water setpoint"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    amplitude=0.1*1e4,
    freqHz=1/1200,
    offset=1.05*1e4,
    startTime=180) "Chiller load"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    width=0.5,
    period=4000)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not chiSta1 "First chiller status"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiSta2(
    k=false) "Second chiller status"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    width=0.95,
    period=3700)
    "Waterside economizer enabling status"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay fanSpe(
    samplePeriod=1)
    "Current fan speed"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable timTab(
    table=[0,280.4; 400,279.9; 1000,281.65; 1600,280.4],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));

equation
  connect(booPul1.y, chiSta1.u)
    annotation (Line(points={{-78,40},{-42,40}}, color={255,0,255}));
  connect(con1.y, swi1.u3)
    annotation (Line(points={{-78,90},{-60,90},{-60,102},{18,102}}, color={0,0,127}));
  connect(sin.y, swi1.u1)
    annotation (Line(points={{-78,130},{-60,130},{-60,118},{18,118}}, color={0,0,127}));
  connect(chiSta1.y, swi1.u2)
    annotation (Line(points={{-18,40},{0,40},{0,110},{18,110}}, color={255,0,255}));
  connect(chiSta2.y, wseOpe.uChi[2])
    annotation (Line(points={{42,70},{70,70},{70,6},{98,6}}, color={255,0,255}));
  connect(chiSta1.y, wseOpe.uChi[1])
    annotation (Line(points={{-18,40},{70,40},{70,6},{98,6}}, color={255,0,255}));
  connect(swi1.y, wseOpe.chiLoa[1])
    annotation (Line(points={{42,110},{80,110},{80,9},{98,9}}, color={0,0,127}));
  connect(con1.y, wseOpe.chiLoa[2])
    annotation (Line(points={{-78,90},{-60,90},{-60,9},{98,9}}, color={0,0,127}));
  connect(wseSta.y, wseOpe.uWse)
    annotation (Line(points={{-18,-30},{40,-30},{40,2},{98,2}}, color={255,0,255}));
  connect(chiSupSet.y, wseOpe.TChiWatSupSet)
    annotation (Line(points={{-78,-130},{70,-130},{70,-9},{98,-9}},  color={0,0,127}));
  connect(wseOpe.ySpeSet, fanSpe.u) annotation (Line(points={{122,0},{130,0},{130,
          -80},{-110,-80},{-110,-60},{-102,-60}}, color={0,0,127}));
  connect(fanSpe.y, wseOpe.uFanSpe) annotation (Line(points={{-78,-60},{50,-60},
          {50,-2},{98,-2}},color={0,0,127}));
  connect(timTab.y[1], wseOpe.TChiWatSup) annotation (Line(points={{-38,-100},{60,
          -100},{60,-6},{98,-6}},color={0,0,127}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/FanSpeed/EnabledWSE/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Controller</a>.
</p>
<p>
In this example, at 2000 seconds the plant changes from economizer-only mode to integration mode which
have both the chiller and economizer operating. It then changes to chiller-only mode at 3530 seconds.
It implements following processes:
</p>
<ul>
<li>
From 0 to 400 seconds, the chilled water supply temperature is greater than the setpoint. The direct PID controller
increases the output to the maximum output and the fan speed setpoint becomes 1.
</li>
<li>
From 400 to 1000 seconds, the chilled water supply temperature becomes lower than the setpoint. The PID controller decreases
the output to the minimum and the fan speed setpoint becomes the minimum. After the fan stays at minimum speed for 300
seconds and the chilled water supply temperature is lower than the setpoint, the fan cycles off.
</li>
<li>
From 1000 to 1600 seconds, the chilled water supply temperature becomes greater than the setpoint by 1.5 &deg;C. In the
meantime, the fan has been cycled off for 180 seconds (ranging from 895 seconds to 1075 seconds). The fan starts to run
again and the PID control increases the output to maximum and the fan speed setpoint becomes 1.
</li>
<li>
From 1600 to 2000 seconds, the chilled water supply temperature is reduced but still keeps higher than
the setpoint and the fan speed setpoint keeps to be 1.
</li>
<li>
At 2000 seconds, the plant changes from economizer-only mode to integration mode. It keeps the fan speed
setpoint to be maximum for 10 minutes (ranging from 2000 seconds to 2600 seconds).
</li>
<li>
From 2600 to 3515 seconds, the direct acting PID maintains to the chiller load at 110% of the sum of the minimum
cycling load for the operating chiller. 
</li>
<li>
After the 3515 seconds, it becomes chiller only mode and the fan speed control becomes invalide.
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,160}})));
end Controller;
