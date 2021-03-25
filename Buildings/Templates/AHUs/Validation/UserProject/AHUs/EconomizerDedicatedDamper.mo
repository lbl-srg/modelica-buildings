within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerDedicatedDamper
  extends VAVSingleDuct(
    nZon=1,
    nGro=1,
    redeclare Buildings.Templates.BaseClasses.Sensors.DifferentialPressure
      dpOutMin "Differential pressure sensor",
    redeclare Buildings.Templates.BaseClasses.Sensors.VolumeFlowRate
      VOutMin_flow "Volume flow rate sensor",
    redeclare Buildings.Templates.BaseClasses.Dampers.Modulated damRel
      "Modulated damper",
    redeclare Buildings.Templates.BaseClasses.Dampers.Modulated damOut
      "Modulated damper",
    redeclare Buildings.Templates.BaseClasses.Dampers.TwoPosition damOutMin
      "Two-position damper",
    redeclare Buildings.Templates.BaseClasses.Dampers.Modulated damRet
      "Modulated damper",
    final id="VAV_1");

  annotation (
    defaultComponentName="ahu");
end EconomizerDedicatedDamper;
