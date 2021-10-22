within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model BaseNoRelief
  extends VAVMultiZone(
    redeclare
      .Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.NoRelief
      secOutRel,
    final id="VAV_1",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end BaseNoRelief;
