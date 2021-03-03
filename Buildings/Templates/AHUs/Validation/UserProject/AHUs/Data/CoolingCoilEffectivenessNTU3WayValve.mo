within Buildings.Templates.AHUs.Validation.UserProject.AHUs.Data;
record CoolingCoilEffectivenessNTU3WayValve =
  Buildings.Templates.AHUs.Data.VAVSingleDuct (
    typEco=Types.Economizer.None,
    typCoiCoo=Types.Coil.WaterBased,
    typFanSup=Types.Fan.None,
    redeclare replaceable record RecordCoiCoo=Coils.Data.WaterBased (
      redeclare
        Buildings.Templates.AHUs.Coils.HeatExchangers.Data.EffectivenessNTU
        datHex,
      redeclare
        Buildings.Templates.AHUs.Coils.Actuators.Data.ThreeWayValve
        datAct(dpValve_nominal=5000)))
  annotation (
  defaultComponentName="datAhu");
