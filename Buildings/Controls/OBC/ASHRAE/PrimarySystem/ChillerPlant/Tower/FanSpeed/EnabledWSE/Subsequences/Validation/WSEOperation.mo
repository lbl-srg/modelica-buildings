within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.EnabledWSE.Subsequences.Validation;
model WSEOperation
  "Validation sequence of controlling tower fan speed when waterside economizer is running alone"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.EnabledWSE.Subsequences.WSEOperation
    wseOpe(
    minSpe=minSpe,
    maxSpe=maxSpe,
    chiWatCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Tower fan speed control when there is only waterside economizer is running"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.05,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not chiSta "First chiller status"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiSup(
    final amplitude=0.5,
    final freqHz=1/1800,
    final offset=273.15 + 7.3) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  CDL.Continuous.Sources.Constant chiSupSet(final k=273.15 + 7)
    "Chilled water supply water setpoint"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  CDL.Logical.Switch                        swi
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  CDL.Continuous.Sources.Constant                        con(final k=minSpe)
    "Minimum fan speed"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  parameter Real minSpe=0.1 "Minimum tower fan speed";
  parameter Real maxSpe=1 "Maximum tower fan speed";
  CDL.Continuous.Sources.Ramp ram(
    height=0.2,
    duration=3600,
    offset=0.1,
    startTime=1750)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
protected
  parameter Integer nChi=2 "Total number of chillers";
  parameter Modelica.SIunits.HeatFlowRate minUnLTon[nChi]={1e4,1e4}
    "Minimum cyclining load below which chiller will begin cycling";

equation
  connect(booPul.y, chiSta.u)
    annotation (Line(points={{-58,80},{-42,80}}, color={255,0,255}));

  connect(con.y, swi.u3) annotation (Line(points={{-58,0},{-20,0},{-20,12},{18,
          12}}, color={0,0,127}));
  connect(chiSta.y, swi.u2) annotation (Line(points={{-18,80},{0,80},{0,20},{18,
          20}}, color={255,0,255}));
  connect(swi.y, wseOpe.uTowSpe)
    annotation (Line(points={{42,20},{50,20},{50,8},{58,8}}, color={0,0,127}));
  connect(chiSup.y, wseOpe.TChiWatSup) annotation (Line(points={{-38,-30},{40,
          -30},{40,0},{58,0}}, color={0,0,127}));
  connect(chiSupSet.y, wseOpe.TChiWatSupSet) annotation (Line(points={{-38,-70},
          {50,-70},{50,-8},{58,-8}}, color={0,0,127}));
  connect(ram.y, swi.u1) annotation (Line(points={{-58,40},{-20,40},{-20,28},{
          18,28}}, color={0,0,127}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Tower/FanSpeed/EnabledWSE/Subsequences/Validation/WSEOperation.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.EnabledWSE.Subsequences.WSEOperation\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.EnabledWSE.Subsequences.WSEOperation</a>.
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
