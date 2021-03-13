within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerDedicatedDamper
  extends VAVSingleDuct(
    nZon=1,
    redeclare Buildings.Templates.BaseClasses.Sensors.DifferentialPressure
      dpOut "Differential pressure sensor",
    redeclare Buildings.Templates.BaseClasses.Sensors.VolumeFlowRate VOut1_flow
      "Volume flow rate sensor",
    redeclare Buildings.Templates.BaseClasses.Dampers.Modulated damRel
      "Modulated damper",
    redeclare Buildings.Templates.BaseClasses.Dampers.Modulated damOut
      "Modulated damper",
    redeclare Buildings.Templates.BaseClasses.Dampers.Modulated damOutMin
      "Modulated damper",
    redeclare Buildings.Templates.BaseClasses.Dampers.Modulated damRet
      "Modulated damper",
    final id="VAV_1");

  annotation (
    defaultComponentName="ahu");
end EconomizerDedicatedDamper;
