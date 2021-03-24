within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilCoolingCounterFlow
  extends VAVSingleDuct(
    final id="VAV_1",
    nZon=1,
    nGro=1,
    redeclare
      Buildings.Templates.BaseClasses.Coils.WaterBased coiCoo(redeclare replaceable
        Buildings.Templates.BaseClasses.Coils.HeatExchangers.WetCoilCounterFlow
        hex));

  annotation (
    defaultComponentName="ahu");
end CoilCoolingCounterFlow;
