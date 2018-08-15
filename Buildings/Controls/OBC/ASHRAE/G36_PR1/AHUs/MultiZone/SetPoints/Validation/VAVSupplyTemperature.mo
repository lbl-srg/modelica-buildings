within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.Validation;
model VAVSupplyTemperature
  "Validate model for calculating supply air temperature of multi zone VAV AHU"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyTemperature
    conTSetSup
    "Supply air temperature setpoint for multi zone system"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant setZonTem(
    k=22.5 + 273.15) "Average of heating and cooling setpoint"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine outTem(
    amplitude=5,
    freqHz=1/86400,
    offset=18 + 273.15) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFanSta(period=43200)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp opeMod(
    offset=1,
    height=1,
    duration=90000) "Operation mode"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    amplitude=6, freqHz=1/86400)
    "Block generates sine signal"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{32,-50},{52,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

equation
  connect(supFanSta.y, conTSetSup.uSupFan)
    annotation (Line(points={{-59,0},{69,0}},
      color={255,0,255}));
  connect(outTem.y, conTSetSup.TOut)
    annotation (Line(points={{-59,40},{40,40},{40,4},{69,4}},
      color={0,0,127}));
  connect(setZonTem.y, conTSetSup.TSetZones)
    annotation (Line(points={{-59,70},{60,70},{60,8},{69,8}},
      color={0,0,127}));
  connect(sine.y, abs.u)
    annotation (Line(points={{-59,-40},{-42,-40}}, color={0,0,127}));
  connect(opeMod.y, round2.u)
    annotation (Line(points={{-59,-70},{-42,-70}}, color={0,0,127}));
  connect(round2.y, reaToInt2.u)
    annotation (Line(points={{-19,-70},{-12,-70},{-12,-70},{-2,-70}},
      color={0,0,127}));
  connect(abs.y, round1.u)
    annotation (Line(points={{-19,-40},{-2,-40}}, color={0,0,127}));
  connect(round1.y, reaToInt1.u)
    annotation (Line(points={{21,-40},{30,-40}}, color={0,0,127}));
  connect(reaToInt1.y, conTSetSup.uZonTemResReq)
    annotation (Line(points={{53,-40},{60,-40},{60,-4},{69,-4}},
      color={255,127,0}));
  connect(reaToInt2.y, conTSetSup.uOpeMod)
    annotation (Line(points={{21,-70},{66,-70},{66,-8},{69,-8}},
      color={255,127,0}));

annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/SetPoints/Validation/VAVSupplyTemperature.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyTemperature\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyTemperature</a>
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
end VAVSupplyTemperature;
