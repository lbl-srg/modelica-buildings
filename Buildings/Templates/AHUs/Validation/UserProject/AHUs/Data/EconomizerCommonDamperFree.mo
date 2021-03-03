within Buildings.Templates.AHUs.Validation.UserProject.AHUs.Data;
record EconomizerCommonDamperFree =
  Buildings.Templates.AHUs.Data.VAVSingleDuct (
    typEco=Types.Economizer.CommonDamperFree,
    typCoiCoo=Types.Coil.None,
    typFanSup=Types.Fan.None,
    redeclare replaceable record RecordEco=Economizers.Data.CommonDamperFree)
  annotation (
    defaultComponentName="datAhu");
