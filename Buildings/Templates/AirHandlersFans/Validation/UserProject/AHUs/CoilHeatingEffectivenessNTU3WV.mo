within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilHeatingEffectivenessNTU3WV
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    id="VAV_1",
    redeclare .Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
        redeclare
        .Buildings.Templates.Components.HeatExchangers.DryCoilEffectivenessNTU
        hex "Epsilon-NTU heat exchanger model",
        redeclare Buildings.Templates.Components.Valves.ThreeWay val)
                                                "Water-based",
    nZon=2,
    nGro=1);
  annotation (
    defaultComponentName="ahu");
end CoilHeatingEffectivenessNTU3WV;
