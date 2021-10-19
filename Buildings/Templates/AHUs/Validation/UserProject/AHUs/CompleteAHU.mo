within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CompleteAHU
  extends Buildings.Templates.AHUs.VAVMultiZone(
    secOutRel(redeclare
        .Buildings.Templates.AHUs.BaseClasses.OutdoorSection.SingleCommon
        secOut "Single common OA damper (modulated) with AFMS",
                                                         secRel(redeclare
          Templates.BaseClasses.Fans.SingleVariable fanRet
          "Single fan - Variable speed")),
    redeclare Templates.BaseClasses.Coils.WaterBasedCooling coiCoo(
      dpAir_nominal(displayUnit="Pa"),
      dpWat_nominal(displayUnit="Pa"),
      redeclare Buildings.Templates.BaseClasses.Coils.Actuators.TwoWayValve act,

      redeclare
        Templates.BaseClasses.Coils.HeatExchangers.WetCoilEffectivenessNTU hex
        "Effectiveness-NTU wet heat exchanger model") "Water-based",
    redeclare Templates.BaseClasses.Coils.WaterBasedHeating coiHea(redeclare
        Buildings.Templates.BaseClasses.Coils.Actuators.TwoWayValve act,
        redeclare
        Templates.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU hex
        "Epsilon-NTU heat exchanger model") "Water-based",
    redeclare .Buildings.Templates.BaseClasses.Fans.SingleVariable fanSupDra,
    nZon=1,
    nGro=1,
    id="VAV_1");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CompleteAHU;
