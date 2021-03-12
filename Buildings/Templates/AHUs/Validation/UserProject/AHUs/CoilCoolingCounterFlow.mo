within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilCoolingCounterFlow
  extends VAVSingleDuct(final id="VAV_1", redeclare
      BaseClasses.Coils.WaterBased coiCoo(redeclare replaceable
        BaseClasses.Coils.HeatExchangers.WetCoilCounterFlow hex));

  annotation (
    defaultComponentName="ahu");
end CoilCoolingCounterFlow;
