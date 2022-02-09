within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilHeatingEffectivenessNTU3WV
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedHeating coiHeaReh(
        redeclare Buildings.Templates.Components.Valves.ThreeWayModulating val,
        redeclare replaceable
        Buildings.Templates.Components.HeatExchangers.DryCoilEffectivenessNTU
        hex "Epsilon-NTU dry heat exchanger model") "Hot water coil",
    redeclare replaceable Buildings.Templates.Components.Coils.None coiHeaPre(
        final mAir_flow_nominal=mAirSup_flow_nominal) "No coil",
    nZon=2,
    nGro=1);
  annotation (
    defaultComponentName="ahu");
end CoilHeatingEffectivenessNTU3WV;
