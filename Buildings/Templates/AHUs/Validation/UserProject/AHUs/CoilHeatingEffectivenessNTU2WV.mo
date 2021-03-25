within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilHeatingEffectivenessNTU2WV
  extends VAVSingleDuct(
    final id="VAV_1",
    nZon=1,
    nGro=1,
    redeclare
      Buildings.Templates.BaseClasses.Coils.WaterBased coiHea(redeclare
        Buildings.Templates.BaseClasses.Coils.Actuators.TwoWayValve act,
        redeclare
        Buildings.Templates.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU
        hex));
  annotation (
    defaultComponentName="ahu");
end CoilHeatingEffectivenessNTU2WV;
