within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CompleteAHU
  extends Buildings.Templates.AHUs.VAVSingleDuctWithEconomizer(
    redeclare Templates.BaseClasses.Coils.WaterBasedCooling coiCoo(redeclare
        Buildings.Templates.BaseClasses.Coils.Actuators.TwoWayValve act,
        redeclare Templates.BaseClasses.Coils.HeatExchangers.WetCoilCounterFlow
        hex "Discretized heat exchanger model") "Water-based",
    redeclare Templates.BaseClasses.Coils.WaterBasedHeating coiHea(redeclare
        Buildings.Templates.BaseClasses.Coils.Actuators.TwoWayValve act,
        redeclare
        Templates.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU hex
        "Epsilon-NTU heat exchanger model") "Water-based",
    redeclare BaseClasses.ReliefReturnSection.ReliefFan secRel(redeclare
        Templates.BaseClasses.Fans.SingleVariable fanRet
        "Single fan - Variable speed"),
    redeclare BaseClasses.OutdoorAirSection.SingleCommon secOut
      "Outdoor air section - Single common OA damper (modulated) with AFMS",
    redeclare BaseClasses.Fans.SingleVariable fanSupDra,
    nZon=1,
    nGro=1,
    id="VAV_1");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CompleteAHU;
