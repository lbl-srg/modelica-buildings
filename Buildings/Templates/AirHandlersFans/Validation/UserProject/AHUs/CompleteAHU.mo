within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CompleteAHU
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable
      Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Economizer
      secOutRel(redeclare replaceable
        Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleDamper
        secOut "Single common OA damper (modulated) with AFMS", redeclare replaceable
        Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan
        secRel "Return fan with modulated relief damper"),
    redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
      dpAir_nominal(displayUnit="Pa"),
      dpWat_nominal(displayUnit="Pa"),
      redeclare replaceable
        Buildings.Templates.Components.HeatExchangers.WetCoilEffectivenessNTU
        hex "Effectiveness-NTU wet heat exchanger model",
      redeclare replaceable Buildings.Templates.Components.Valves.TwoWay val)
                                                          "Water-based",
    redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
      redeclare replaceable
        Buildings.Templates.Components.HeatExchangers.DryCoilEffectivenessNTU
        hex "Epsilon-NTU heat exchanger model",
        redeclare replaceable Buildings.Templates.Components.Valves.TwoWay val)
                                                "Water-based",
    redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable fanSupDra,
    nZon=2,
    nGro=1,
    id="VAV_1");

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CompleteAHU;
