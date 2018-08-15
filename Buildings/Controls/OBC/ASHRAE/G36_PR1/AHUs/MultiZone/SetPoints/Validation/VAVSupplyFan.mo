within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.Validation;
model VAVSupplyFan "Validate VAVSupplyFan"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyFan
    conSupFan(numZon=4,
    Td=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    maxSet=400,
    k=0.001,
    Ti=10)   "Block outputs supply fan speed"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    duration=28800,
    height=6) "Ramp signal for generating operation mode"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
    duration=28800,
    height=1.5,
    offset=1) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
    duration=28800,
    offset=1,
    height=0.5) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo3(
    duration=28800,
    height=1,
    offset=0.3) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo4(
    duration=28800,
    height=1,
    offset=0) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-12,10},{8,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    freqHz=1/14400,
    offset=3,
    amplitude=2)    "Generate sine signal "
    annotation (Placement(transformation(extent={{-92,-40},{-72,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    freqHz=1/14400,
    offset=200,
    amplitude=150) "Generate sine signal"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-64,-40},{-44,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{2,-40},{22,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));

equation
  connect(vavBoxFlo1.y, conSupFan.VBox_flow[1])
    annotation (Line(points={{-59,40},{-46,40},{-46,0},{34,0},{34,1.5},{58,1.5}},
                 color={0,0,127}));
  connect(vavBoxFlo2.y, conSupFan.VBox_flow[2])
    annotation (Line(points={{-19,50},{30,50},{30,2.5},{58,2.5}},
      color={0,0,127}));
  connect(vavBoxFlo3.y, conSupFan.VBox_flow[3])
    annotation (Line(points={{-59,10},{-50,10},{-50,-2},{28,-2},{28,3.5},{58,
          3.5}}, color={0,0,127}));
  connect(vavBoxFlo4.y, conSupFan.VBox_flow[4])
    annotation (Line(points={{9,20},{28,20},{28,4.5},{58,4.5}},
      color={0,0,127}));
  connect(sine1.y, conSupFan.ducStaPre)
    annotation (Line(points={{-19,-70},{40,-70},{40,-8},{58,-8}},
      color={0,0,127}));
  connect(sine.y, abs1.u)
    annotation (Line(points={{-71,-30},{-66,-30}},
      color={0,0,127}));
  connect(ram.y, abs.u)
    annotation (Line(points={{-69,80},{-62,80}},
      color={0,0,127}));
  connect(abs1.y, round2.u)
    annotation (Line(points={{-43,-30},{-32,-30}}, color={0,0,127}));
  connect(round2.y, reaToInt1.u)
    annotation (Line(points={{-9,-30},{0,-30}}, color={0,0,127}));
  connect(reaToInt1.y, conSupFan.uZonPreResReq)
    annotation (Line(points={{23,-30},{34,-30},{34,-3},{58,-3}},
      color={255,127,0}));
  connect(abs.y, round1.u)
    annotation (Line(points={{-39,80},{-32,80}}, color={0,0,127}));
  connect(round1.y, reaToInt2.u)
    annotation (Line(points={{-9,80},{-2,80}},color={0,0,127}));
  connect(reaToInt2.y, conSupFan.uOpeMod)
    annotation (Line(points={{21,80},{38,80},{38,8},{58,8}},
      color={255,127,0}));

annotation (experiment(StopTime=28800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/SetPoints/Validation/VAVSupplyFan.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyFan\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyFan</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 24, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end VAVSupplyFan;
