within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilCoolingCounterFlow
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
      redeclare replaceable
        Buildings.Templates.Components.HeatExchangers.WetCoilCounterFlow hex
        "Discretized heat exchanger model") "Chilled water coil",
    tag="VAV_1",
    nZon=2,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end CoilCoolingCounterFlow;
