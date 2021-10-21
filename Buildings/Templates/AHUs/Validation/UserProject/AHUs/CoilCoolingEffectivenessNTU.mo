within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilCoolingEffectivenessNTU
  extends VAVMultiZone(
    redeclare .Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
      dpAir_nominal(displayUnit="Pa"),
      dpWat_nominal(displayUnit="Pa"),
      redeclare
        .Buildings.Templates.Components.Coils.HeatExchangers.WetCoilEffectivenessNTU
        hex "Effectiveness-NTU wet heat exchanger model") "Water-based",
    final id="VAV_1",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end CoilCoolingEffectivenessNTU;
