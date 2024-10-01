within Buildings.Fluid.Storage.Ice_ntu.BaseClasses.Tests;
model brine
  Real cp;

  Modelica.Blocks.Sources.Ramp ramp(
    height=35,
    duration=35,
    offset=273.15 - 5,
    startTime=5)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  cp = Buildings.Media.Antifreeze.Validation.BaseClasses.PropyleneGlycolWater.testSpecificHeatCapacityCp_TX_a(T=ramp.y, X_a=0.3);

end brine;
