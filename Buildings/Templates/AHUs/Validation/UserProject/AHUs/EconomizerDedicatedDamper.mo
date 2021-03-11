within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerDedicatedDamper
  extends VAVSingleDuct(
    redeclare BaseClasses.Sensors.DifferentialPressure dpOut
      "Differential pressure sensor",
    redeclare BaseClasses.Sensors.VolumeFlowRate VOut1
      "Volume flow rate sensor",
    redeclare BaseClasses.Dampers.Modulated damRel "Modulated damper",
    redeclare BaseClasses.Dampers.Modulated damOut "Modulated damper",
    redeclare BaseClasses.Dampers.Modulated damOutMin "Modulated damper",
    redeclare BaseClasses.Dampers.Modulated damRet "Modulated damper",
                        final id="VAV_1");

  annotation (
    defaultComponentName="ahu");
end EconomizerDedicatedDamper;
