within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CompleteAHU
  extends Buildings.Templates.AHUs.VAVSingleDuct(
    redeclare BaseClasses.Sensors.VolumeFlowRate VOut_flow
      "Volume flow rate sensor",
    redeclare BaseClasses.Fans.SingleVariable fanRet,
    redeclare BaseClasses.Sensors.DifferentialPressure pSup_rel
      "Differential pressure sensor",
    redeclare BaseClasses.Sensors.Temperature TSup "Temperature sensor",
    redeclare BaseClasses.Fans.SingleVariable fanSupDra,
    redeclare BaseClasses.Coils.WaterBased coiCoo(redeclare
        Buildings.Templates.BaseClasses.Coils.Actuators.TwoWayValve act,
        redeclare
        Buildings.Templates.BaseClasses.Coils.HeatExchangers.WetCoilCounterFlow
        hex),
    redeclare BaseClasses.Sensors.Temperature THea "Temperature sensor",
    redeclare BaseClasses.Coils.WaterBased coiHea(redeclare
        Buildings.Templates.BaseClasses.Coils.Actuators.TwoWayValve act,
        redeclare
        Buildings.Templates.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU
        hex),
    redeclare BaseClasses.Sensors.Temperature TMix "Temperature sensor",
    redeclare BaseClasses.Sensors.Temperature TOut "Temperature sensor",
    redeclare BaseClasses.Dampers.Modulated damRel "Modulated damper",
    redeclare BaseClasses.Dampers.Modulated damOut "Modulated damper",
    redeclare BaseClasses.Dampers.Modulated damRet "Modulated damper",
    nZon=1,
    nGro=1,
    id="VAV_1");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CompleteAHU;
