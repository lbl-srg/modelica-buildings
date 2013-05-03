within Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir;
model SingleSpeed "Single speed air to air heat pump"
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses.PartialAirToAir;
public
  Modelica.Blocks.Interfaces.IntegerInput mode(final min=0, final max=2)
    "Set to 1 for heating mode and 2 for cooling mode and to 0 to turn off"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Sources.Constant speRat(final k=1) "Speed ratio"
    annotation (Placement(transformation(extent={{-72,28},{-60,40}})));
  Buildings.Utilities.Math.IntegerReplicator intRep(nout=2)
    annotation (Placement(transformation(extent={{8,84},{20,96}})));
equation
  connect(mode, heaMasFlo.mode) annotation (Line(
      points={{-120,100},{-30,100},{-30,10},{-5,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speRat.y, heaMasFlo.speRat) annotation (Line(
      points={{-59.4,34},{-36,34},{-36,7.6},{-5,7.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, intRep.u) annotation (Line(
      points={{-120,100},{-30,100},{-30,90},{6.8,90}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(intRep.y, dynStaSto.mode) annotation (Line(
      points={{20.6,90},{38,90},{38,10}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end SingleSpeed;
