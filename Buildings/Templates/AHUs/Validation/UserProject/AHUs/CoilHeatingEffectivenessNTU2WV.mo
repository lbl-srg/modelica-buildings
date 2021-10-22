within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilHeatingEffectivenessNTU2WV
  extends VAVMultiZone(
    redeclare .Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
        redeclare Buildings.Templates.Components.Actuators.TwoWayValve act,
        redeclare
        .Buildings.Templates.Components.HeatExchangers.DryCoilEffectivenessNTU
        hex "Epsilon-NTU heat exchanger model") "Water-based",
    final id="VAV_1",
    nZon=1,
    nGro=1);
  annotation (
    defaultComponentName="ahu");
end CoilHeatingEffectivenessNTU2WV;
