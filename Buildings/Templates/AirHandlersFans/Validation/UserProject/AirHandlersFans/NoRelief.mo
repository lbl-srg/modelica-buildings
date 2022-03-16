within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model NoRelief "Air economizer - No relief branch"
  extends VAVMultiZone(
    redeclare replaceable
      Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.EconomizerNoRelief
      secOutRel "Air economizer - No relief branch",
    nZon=2);

  annotation (
    defaultComponentName="ahu");
end NoRelief;
