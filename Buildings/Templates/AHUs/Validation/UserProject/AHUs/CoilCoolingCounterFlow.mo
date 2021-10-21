within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilCoolingCounterFlow
  extends VAVMultiZone(
    redeclare .Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
        redeclare
        .Buildings.Templates.Components.Coils.HeatExchangers.WetCoilCounterFlow
        hex "Discretized heat exchanger model") "Water-based",
    final id="VAV_1",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end CoilCoolingCounterFlow;
