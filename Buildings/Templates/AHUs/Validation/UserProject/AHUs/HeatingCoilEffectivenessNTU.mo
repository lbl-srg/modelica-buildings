within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model HeatingCoilEffectivenessNTU
  extends VAVSingleDuct(
    final id="VAV_1",
    redeclare Coils.WaterBased coiHea2(redeclare replaceable
      Buildings.Templates.AHUs.Coils.HeatExchangers.DryCoilEffectivenessNTU
      hex));
  annotation (
    defaultComponentName="ahu");
end HeatingCoilEffectivenessNTU;
