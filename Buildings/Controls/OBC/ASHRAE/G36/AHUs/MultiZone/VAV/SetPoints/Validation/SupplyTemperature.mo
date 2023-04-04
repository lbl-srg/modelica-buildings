within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.Validation;
model SupplyTemperature
  "Validate model for calculating supply air temperature of multi zone VAV AHU"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature conTSupSet
    "Supply air temperature setpoint for multi zone system"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine outTem(
    final amplitude=5,
    final freqHz=1/86400,
    final offset=18 + 273.15) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFanSta(
    final period=43200)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp opeMod(
    final offset=1,
    final height=1,
    final duration=90000) "Operation mode"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    final amplitude=6,
    final freqHz=1/86400)
    "Block generates sine signal"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{32,-40},{52,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

equation
  connect(supFanSta.y, conTSupSet.u1SupFan) annotation (Line(points={{-58,30},{
          30,30},{30,-3},{68,-3}}, color={255,0,255}));
  connect(outTem.y, conTSupSet.TOut)
    annotation (Line(points={{-58,70},{40,70},{40,7},{68,7}},
      color={0,0,127}));
  connect(sine.y, abs.u)
    annotation (Line(points={{-58,-30},{-42,-30}}, color={0,0,127}));
  connect(opeMod.y, round2.u)
    annotation (Line(points={{-58,-70},{-42,-70}}, color={0,0,127}));
  connect(round2.y, reaToInt2.u)
    annotation (Line(points={{-18,-70},{-12,-70},{-12,-70},{-2,-70}},
      color={0,0,127}));
  connect(abs.y, round1.u)
    annotation (Line(points={{-18,-30},{-2,-30}}, color={0,0,127}));
  connect(round1.y, reaToInt1.u)
    annotation (Line(points={{22,-30},{30,-30}}, color={0,0,127}));
  connect(reaToInt1.y, conTSupSet.uZonTemResReq)
    annotation (Line(points={{54,-30},{60,-30},{60,3},{68,3}},
      color={255,127,0}));
  connect(reaToInt2.y, conTSupSet.uOpeMod)
    annotation (Line(points={{22,-70},{66,-70},{66,-7},{68,-7}},
      color={255,127,0}));

annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/SetPoints/Validation/SupplyTemperature.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature</a>
for a change of outdoor temperature, operation mode, supply fan status, maximum
supply temperature, to specify the supply air temperature for systems with multiple
zones.
</p>
</html>", revisions="<html>
<ul>
<li>
July 11, 2017, by Jianjun Hu:<br/>
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
end SupplyTemperature;
