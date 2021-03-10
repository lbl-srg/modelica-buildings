within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model HeatingCoilEffectivenessNTU3WayValve
  extends VAVSingleDuct(final id="VAV_1", redeclare
      BaseClasses.Coils.WaterBased coiHea2(redeclare
        Buildings.Templates.AHUs.BaseClasses.Coils.Valves.ThreeWayValve act,
        redeclare
        Buildings.Templates.AHUs.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU
        hex));
  annotation (
    defaultComponentName="ahu");
end HeatingCoilEffectivenessNTU3WayValve;
