within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CompleteAHU
  extends Buildings.Templates.AHUs.VAVMultiZone(
    secOutRel(redeclare
        .Buildings.Templates.AHUs.Components.OutdoorSection.SingleCommon secOut
        "Single common OA damper (modulated) with AFMS", secRel(redeclare
          .Buildings.Templates.Components.Fans.SingleVariable fanRet
          "Single fan - Variable speed")),
    redeclare .Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
      dpAir_nominal(displayUnit="Pa"),
      dpWat_nominal(displayUnit="Pa"),
      redeclare Buildings.Templates.Components.Actuators.TwoWayValve act,
      redeclare
        .Buildings.Templates.Components.HeatExchangers.WetCoilEffectivenessNTU
        hex "Effectiveness-NTU wet heat exchanger model") "Water-based",
    redeclare .Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
        redeclare Buildings.Templates.Components.Actuators.TwoWayValve act,
        redeclare
        .Buildings.Templates.Components.HeatExchangers.DryCoilEffectivenessNTU
        hex "Epsilon-NTU heat exchanger model") "Water-based",
    redeclare .Buildings.Templates.Components.Fans.SingleVariable fanSupDra,
    nZon=1,
    nGro=1,
    id="VAV_1");

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CompleteAHU;
