within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilHeatingEffectivenessNTU
  extends VAVSingleDuct(redeclare BaseClasses.Coils.WaterBased coiHea(
        redeclare replaceable
        Buildings.Templates.AHUs.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU
        hex), final id="VAV_1");
  annotation (
    defaultComponentName="ahu");
end CoilHeatingEffectivenessNTU;
