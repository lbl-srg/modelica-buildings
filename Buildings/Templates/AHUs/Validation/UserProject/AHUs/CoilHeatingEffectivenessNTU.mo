within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilHeatingEffectivenessNTU
  extends VAVSingleDuct(
    final id="VAV_1",
    nZon=1,
    redeclare
      Buildings.Templates.BaseClasses.Coils.WaterBased coiHea(redeclare replaceable
        Buildings.Templates.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU
        hex));
  annotation (
    defaultComponentName="ahu");
end CoilHeatingEffectivenessNTU;
