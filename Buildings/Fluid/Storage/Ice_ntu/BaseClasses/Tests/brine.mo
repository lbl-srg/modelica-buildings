within Buildings.Fluid.Storage.Ice_ntu.BaseClasses.Tests;
model brine
  Real cp_propylene;
  Real cp_ethylene;

  Modelica.Blocks.Sources.Ramp ramp(
    height=35,
    duration=35,
    offset=273.15 - 5,
    startTime=5)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Interfaces.RealOutput y(unit="K",
                                          displayUnit = "degC")
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
equation
  cp_propylene = Buildings.Media.Antifreeze.Validation.BaseClasses.PropyleneGlycolWater.testSpecificHeatCapacityCp_TX_a(T=ramp.y, X_a=0.3);
  cp_ethylene = Buildings.Media.Antifreeze.Validation.BaseClasses.EthyleneGlycolWater.testSpecificHeatCapacityCp_TX_a(T=ramp.y, X_a=0.3);

  connect(ramp.y, y) annotation (Line(points={{-59,10},{-40,10},{-40,0},{-10,0}},
        color={0,0,127}));
end brine;
