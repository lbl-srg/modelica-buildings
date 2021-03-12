within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilHeatingEffectivenessNTU3WV
  extends VAVSingleDuct(redeclare BaseClasses.Coils.WaterBased coiHea(
        redeclare
        Buildings.Templates.AHUs.BaseClasses.Coils.Valves.ThreeWayValve act,
        redeclare
        Buildings.Templates.AHUs.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU
        hex), final id="VAV_1");
  annotation (
    defaultComponentName="ahu");
end CoilHeatingEffectivenessNTU3WV;
