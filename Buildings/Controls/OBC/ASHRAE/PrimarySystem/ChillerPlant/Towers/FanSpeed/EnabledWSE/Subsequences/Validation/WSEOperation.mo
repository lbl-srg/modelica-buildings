within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.Validation;
model WSEOperation
  "Validates cooling tower fan speed control sequence for WSE running only"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.WSEOperation
    wseOpe(
    final fanSpeMin=0.1,
    final fanSpeMax=1,
    final chiWatCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Tower fan speed control when there is only waterside economizer is running"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.05,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not fanSpeSwi "Two fan speed switch"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin chiSup(
    final amplitude=0.5,
    final freqHz=1/1800,
    final offset=273.15 + 7.1) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiSupSet(
    final k=273.15 + 7)
    "Chilled water supply water setpoint"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0.1)
    "Minimum fan speed"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final height=0.2,
    final duration=3600,
    final offset=0.1,
    final startTime=1750) "Tower speed"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram1(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Add real inputs"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

equation
  connect(booPul.y, fanSpeSwi.u)
    annotation (Line(points={{-58,80},{-42,80}}, color={255,0,255}));
  connect(con.y, swi.u3)
    annotation (Line(points={{-58,0},{-20,0},{-20,12},{18,12}}, color={0,0,127}));
  connect(fanSpeSwi.y, swi.u2)
    annotation (Line(points={{-18,80},{0,80},{0,20},{18,20}}, color={255,0,255}));
  connect(swi.y,wseOpe.uFanSpe)
    annotation (Line(points={{42,20},{50,20},{50,8},{58,8}}, color={0,0,127}));
  connect(chiSupSet.y, wseOpe.TChiWatSupSet)
    annotation (Line(points={{42,-80},{50,-80},{50,-8},{58,-8}},  color={0,0,127}));
  connect(ram.y, swi.u1)
    annotation (Line(points={{-58,40},{-20,40},{-20,28},{18,28}}, color={0,0,127}));
  connect(chiSup.y, add2.u1)
    annotation (Line(points={{-58,-30},{-40,-30},{-40,-44},{-22,-44}}, color={0,0,127}));
  connect(ram1.y, add2.u2)
    annotation (Line(points={{-58,-70},{-40,-70},{-40,-56},{-22,-56}}, color={0,0,127}));
  connect(add2.y, wseOpe.TChiWatSup)
    annotation (Line(points={{2,-50},{20,-50},{20,0},{58,0}}, color={0,0,127}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/FanSpeed/EnabledWSE/Subsequences/Validation/WSEOperation.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.WSEOperation\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences.WSEOperation</a>.
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
end WSEOperation;
