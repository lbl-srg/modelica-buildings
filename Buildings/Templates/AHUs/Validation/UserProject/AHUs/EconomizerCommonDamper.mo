within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerCommonDamper
  extends VAVSingleDuct(
    redeclare BaseClasses.Sensors.Temperature TMix "Temperature sensor",
    redeclare BaseClasses.Sensors.VolumeFlowRate VOut_flow
      "Volume flow rate sensor",
    redeclare BaseClasses.Dampers.Modulated damRel "Modulated damper",
    redeclare BaseClasses.Dampers.Modulated damOut "Modulated damper",
    redeclare BaseClasses.Dampers.Modulated damRet "Modulated damper",
    final id="VAV_1");

  annotation (
    defaultComponentName="ahu");
end EconomizerCommonDamper;
