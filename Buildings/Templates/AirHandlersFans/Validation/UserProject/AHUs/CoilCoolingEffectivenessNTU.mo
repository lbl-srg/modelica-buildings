within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilCoolingEffectivenessNTU
  extends NoFanNoReliefSingleDamper(
    redeclare .Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
      dpAir_nominal(displayUnit="Pa"),
      dpWat_nominal(displayUnit="Pa"),
      redeclare
        .Buildings.Templates.Components.HeatExchangers.WetCoilEffectivenessNTU
        hex "Effectiveness-NTU wet heat exchanger model") "Water-based",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end CoilCoolingEffectivenessNTU;
