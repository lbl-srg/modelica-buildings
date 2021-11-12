within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilCoolingEffectivenessNTU
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare .Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
      dpAir_nominal(displayUnit="Pa"),
      dpWat_nominal(displayUnit="Pa"),
      redeclare
        .Buildings.Templates.Components.HeatExchangers.WetCoilEffectivenessNTU
        hex "Effectiveness-NTU wet heat exchanger model") "Water-based",
    id="VAV_1",
    nZon=2,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end CoilCoolingEffectivenessNTU;
