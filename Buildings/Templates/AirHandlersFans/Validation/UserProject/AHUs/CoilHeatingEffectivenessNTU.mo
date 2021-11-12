within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilHeatingEffectivenessNTU
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    id="VAV_1",
    redeclare .Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
        redeclare
        .Buildings.Templates.Components.HeatExchangers.DryCoilEffectivenessNTU
        hex "Epsilon-NTU heat exchanger model") "Water-based",
    nZon=1,
    nGro=1);
  annotation (
    defaultComponentName="ahu");
end CoilHeatingEffectivenessNTU;
