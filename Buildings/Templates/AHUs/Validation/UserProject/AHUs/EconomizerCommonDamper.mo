within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerCommonDamper
  extends VAVSingleDuct(
    nZon=1,
    nGro=1,
    final id="VAV_1",
    redeclare Buildings.Templates.BaseClasses.Sensors.Temperature TMix
      "Temperature sensor",
    redeclare Buildings.Templates.BaseClasses.Sensors.VolumeFlowRate VOut_flow
      "Volume flow rate sensor",
    redeclare Buildings.Templates.BaseClasses.Dampers.Modulated damRel
      "Modulated damper",
    redeclare Buildings.Templates.BaseClasses.Dampers.Modulated damOut
      "Modulated damper",
    redeclare Buildings.Templates.BaseClasses.Dampers.Modulated damRet
      "Modulated damper");

  annotation (
    defaultComponentName="ahu");
end EconomizerCommonDamper;
