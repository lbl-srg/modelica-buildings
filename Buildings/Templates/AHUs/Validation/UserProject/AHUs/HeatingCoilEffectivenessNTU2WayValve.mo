within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model HeatingCoilEffectivenessNTU2WayValve
  extends VAVSingleDuct(redeclare BaseClasses.Coils.WaterBased coiHea(
        redeclare Buildings.Templates.AHUs.BaseClasses.Coils.Valves.TwoWayValve
        act, redeclare
        Buildings.Templates.AHUs.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU
        hex), final id="VAV_1");
  annotation (
    defaultComponentName="ahu");
end HeatingCoilEffectivenessNTU2WayValve;
