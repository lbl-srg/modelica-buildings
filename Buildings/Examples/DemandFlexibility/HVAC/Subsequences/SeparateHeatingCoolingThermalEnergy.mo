within Buildings.Examples.DemandFlexibility.HVAC.Subsequences;
block SeparateHeatingCoolingThermalEnergy
  Modelica.Blocks.Interfaces.RealOutput HeatingThermalEnergy annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,36})));
  Modelica.Blocks.Interfaces.RealOutput CoolingThermalEnergy annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-58})));
  Modelica.Blocks.Interfaces.RealInput EffectiveThermalEnergy annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
equation
  HeatingThermalEnergy = if EffectiveThermalEnergy>=0 then EffectiveThermalEnergy else 0;
  CoolingThermalEnergy = if EffectiveThermalEnergy<0 then -1*EffectiveThermalEnergy else 0;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SeparateHeatingCoolingThermalEnergy;
