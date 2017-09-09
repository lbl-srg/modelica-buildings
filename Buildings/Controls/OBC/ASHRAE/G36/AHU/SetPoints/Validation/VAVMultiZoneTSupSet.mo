within Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.Validation;
model VAVMultiZoneTSupSet
  "Validate model for calculating supply air temperature of multizone VAV AHU"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.VAVMultiZoneTSupSet
    supplyAirTempSet_MultiZone
    "Supply air temperature setpoint for multizone system"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant setZonTem(
    k=22.5 + 273.15) "Average of heating and cooling setpoint"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Sine outTem(
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
  Buildings.Controls.OBC.CDL.Continuous.Truncation tru
    "Discards the fractional portion of input and outputs its integer value"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=6, freqHz=1/86400)
    "Block generates sine signal"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Truncation tru1
    "Discards the fractional portion of input and provides a whole number output"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

equation
  connect(opeMod.y, tru.u)
    annotation (Line(points={{-59,-70},{-42,-70}}, color={0,0,127}));
  connect(tru.y, supplyAirTempSet_MultiZone.uOpeMod)
    annotation (Line(points={{-19,-70},{60,-70},{60,-8},{79,-8}},
      color={255,127,0}));
  connect(supFanSta.y, supplyAirTempSet_MultiZone.uSupFan)
    annotation (Line(points={{-59,0},{79,0}},
      color={255,0,255}));
  connect(outTem.y, supplyAirTempSet_MultiZone.TOut)
    annotation (Line(points={{-59,40},{40,40},{40,4},{79,4}},
      color={0,0,127}));
  connect(setZonTem.y, supplyAirTempSet_MultiZone.TSetZones)
    annotation (Line(points={{-59,70},{60,70},{60,8},{79,8}},
      color={0,0,127}));
  connect(sine.y, abs.u)
    annotation (Line(points={{-59,-40},{-42,-40}}, color={0,0,127}));
  connect(abs.y, tru1.u)
    annotation (Line(points={{-19,-40},{-2,-40}}, color={0,0,127}));
  connect(tru1.y, supplyAirTempSet_MultiZone.uZonTemResReq)
    annotation (Line(points={{21,-40},{40,-40},{40,-4},{79,-4}},
      color={255,127,0}));

annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHU/SetPoints/Validation/VAVMultiZoneTSupSet.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.VAVMultiZoneTSupSet\">
Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.VAVMultiZoneTSupSet</a>
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
</html>"));
end VAVMultiZoneTSupSet;
