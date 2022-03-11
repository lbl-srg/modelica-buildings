within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model VAVMultiZoneOpenLoop
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    nZon=2,
    redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedHeating coiHeaPre(
        redeclare final package MediumHeaWat = MediumHeaWat,
        redeclare replaceable
        Buildings.Templates.Components.Valves.TwoWayModulating val),
    redeclare replaceable
      Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Economizer
      secOutRel(redeclare replaceable
        Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleDamper
        secOut "Single common OA damper (modulating) with AFMS", redeclare replaceable
        Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan
        secRel "Return fan with modulating relief damper"),
    redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
      redeclare final package MediumChiWat = MediumChiWat,
      redeclare replaceable
        Buildings.Templates.Components.Valves.TwoWayModulating val)
      "Chilled water coil",
    redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable
      fanSupDra);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVMultiZoneOpenLoop;
