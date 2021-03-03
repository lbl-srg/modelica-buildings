within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoolingCoilDiscretized
  extends VAVSingleDuct(
    final id="VAV_1",
    redeclare Coils.WaterBased coiCoo(
      redeclare replaceable
      Buildings.Templates.AHUs.Coils.HeatExchangers.Discretized
      hex));

  annotation (
    defaultComponentName="ahu");
end CoolingCoilDiscretized;
