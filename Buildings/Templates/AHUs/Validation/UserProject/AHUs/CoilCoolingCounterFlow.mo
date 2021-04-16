within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilCoolingCounterFlow
  extends VAVSingleDuct(
    redeclare Templates.BaseClasses.Coils.WaterBasedCooling coiCoo(redeclare
        Templates.BaseClasses.Coils.HeatExchangers.WetCoilCounterFlow hex
        "Discretized heat exchanger model") "Water-based",
    final id="VAV_1",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end CoilCoolingCounterFlow;
