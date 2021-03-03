within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs.Data;
record CoolingCoilDiscretized =
  Buildings.Experimental.Templates.AHUs.Data.VAVSingleDuct (
    typEco=Types.Economizer.None,
    typCoiCoo=Types.Coil.WaterBased,
    typFanSup=Types.Fan.None,
    redeclare replaceable record RecordCoiCoo=Coils.Data.WaterBased (
      redeclare
        Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Data.Discretized
        datHex))
  annotation (
  defaultComponentName="datAhu", Documentation(info="<html>
</html>"));
