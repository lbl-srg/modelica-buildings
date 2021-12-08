within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilHeatingEffectivenessNTU2WV
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    id="VAV_1",
    redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
        redeclare replaceable
        Buildings.Templates.Components.HeatExchangers.DryCoilEffectivenessNTU
        hex "Epsilon-NTU heat exchanger model",
        redeclare replaceable Buildings.Templates.Components.Valves.TwoWay val)
                                                "Water-based",
    nZon=2,
    nGro=1);
  annotation (
    defaultComponentName="ahu");
end CoilHeatingEffectivenessNTU2WV;
