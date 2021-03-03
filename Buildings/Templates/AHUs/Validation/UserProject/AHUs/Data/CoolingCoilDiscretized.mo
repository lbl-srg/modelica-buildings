within Buildings.Templates.AHUs.Validation.UserProject.AHUs.Data;
record CoolingCoilDiscretized =
  Buildings.Templates.AHUs.Data.VAVSingleDuct (
    typEco=Types.Economizer.None,
    typCoiCoo=Types.Coil.WaterBased,
    typFanSup=Types.Fan.None,
    redeclare replaceable record RecordCoiCoo=Coils.Data.WaterBased (
      redeclare
        Buildings.Templates.AHUs.Coils.HeatExchangers.Data.Discretized
        datHex))
  annotation (
  defaultComponentName="datAhu", Documentation(info="<html>
</html>"));
