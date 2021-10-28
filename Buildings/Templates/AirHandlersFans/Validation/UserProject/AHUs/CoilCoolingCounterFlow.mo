within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilCoolingCounterFlow
  extends NoFanNoReliefSingleDamper(
    redeclare .Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
        redeclare
        .Buildings.Templates.Components.HeatExchangers.WetCoilCounterFlow hex
        "Discretized heat exchanger model")     "Water-based",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end CoilCoolingCounterFlow;
