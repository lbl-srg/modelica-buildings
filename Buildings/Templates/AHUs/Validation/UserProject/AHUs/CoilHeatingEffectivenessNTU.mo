within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilHeatingEffectivenessNTU
  extends VAVSingleDuct(
    redeclare Templates.BaseClasses.Coils.WaterBasedHeating coiHea(redeclare
        Templates.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU hex
        "Epsilon-NTU heat exchanger model") "Water-based",
    final id="VAV_1",
    nZon=1,
    nGro=1);
  annotation (
    defaultComponentName="ahu");
end CoilHeatingEffectivenessNTU;
