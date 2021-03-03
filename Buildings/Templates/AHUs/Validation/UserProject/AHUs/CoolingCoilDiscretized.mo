within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoolingCoilDiscretized
  extends VAVSingleDuct(
    redeclare Coils.WaterBased coiCoo(
      redeclare
      Buildings.Templates.AHUs.Coils.HeatExchangers.Discretized
      coi),
    redeclare replaceable record RecordCoiCoo = Coils.Data.WaterBased (
      redeclare
      Buildings.Templates.AHUs.Coils.HeatExchangers.Data.Discretized
      datHex));

  annotation (
    defaultComponentName="ahu");
end CoolingCoilDiscretized;
