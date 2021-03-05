within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoolingCoilDiscretized
  extends VAVSingleDuct(
    final id="VAV_1",
    redeclare Coils.WaterBased coiCoo(redeclare replaceable
        Coils.HeatExchangers.WetCoilCounterFlow hex));

  annotation (
    defaultComponentName="ahu");
end CoolingCoilDiscretized;
