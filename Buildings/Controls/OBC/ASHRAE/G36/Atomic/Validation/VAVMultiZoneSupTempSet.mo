within Buildings.Controls.OBC.ASHRAE.G36.Atomic.Validation;
model VAVMultiZoneSupTempSet
  "Validate model for calculating supply air temperature of multizone VAV AHU"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.G36.Atomic.VAVMultiZoneSupTempSet
    supplyAirTempSet_MultiZone
    "Supply air temperature setpoint for multizone system"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant setZonTem(
    k=22.5 + 273.15) "Average of heating and cooling setpoint"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp maxSupTem(
    height=4,
    duration=86400,
    offset=14 + 273.15) "Maximum cooling supply temperature "
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Sine outTem(
    amplitude=5,
    freqHz=1/86400,
    offset=18 + 273.15) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFanSta(
    period=28800) "Supply fan status"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp opeMod(
    duration=86400,
    offset=1,
    height=1) "Operation mode"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Truncation tru
    "Discards the fractional portion of input and outputs its integer value"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
equation
  connect(opeMod.y, tru.u)
    annotation (Line(points={{-59,-70},{-42,-70}}, color={0,0,127}));
  connect(tru.y, supplyAirTempSet_MultiZone.opeMod)
    annotation (Line(points={{-19,-70},{-4,-70},{12,-70},{12,-8},{18,-8}},
      color={255,127,0}));
  connect(supFanSta.y, supplyAirTempSet_MultiZone.uSupFan)
    annotation (Line(points={{-59,-30},{-28,-30},{6,-30},{6,-4},{18,-4}},
      color={255,0,255}));
  connect(outTem.y, supplyAirTempSet_MultiZone.TOut)
    annotation (Line(points={{-59,10},{-59,10},{0,10},{0,0},{18,0}},
      color={0,0,127}));
  connect(maxSupTem.y, supplyAirTempSet_MultiZone.TMax)
    annotation (Line(points={{-59,40},{-59,40},{6,40},{6,4},{18,4}},
      color={0,0,127}));
  connect(setZonTem.y, supplyAirTempSet_MultiZone.TSetZones)
    annotation (Line(points={{-59,70},{-59,70},{12,70},{12,8},{18,8}},
      color={0,0,127}));
  annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Atomic/Validation/VAVMultiZoneSupTempSet.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Atomic.VAVMultiZoneSupTempSet\">
Buildings.Controls.OBC.ASHRAE.G36.Atomic.VAVMultiZoneSupTempSet</a>
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
end VAVMultiZoneSupTempSet;
