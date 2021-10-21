within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilHeatingEffectivenessNTU3WV
  extends VAVMultiZone(
    redeclare .Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
        redeclare Buildings.Templates.Components.Coils.Actuators.ThreeWayValve
        act, redeclare
        .Buildings.Templates.Components.Coils.HeatExchangers.DryCoilEffectivenessNTU
        hex "Epsilon-NTU heat exchanger model") "Water-based",
    final id="VAV_1",
    nZon=1,
    nGro=1);
  annotation (
    defaultComponentName="ahu");
end CoilHeatingEffectivenessNTU3WV;
