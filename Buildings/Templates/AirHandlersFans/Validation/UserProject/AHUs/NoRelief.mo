within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model NoRelief
  extends VAVMultiZone(
    redeclare replaceable Buildings.Templates.Components.Fans.None fanSupDra,
    redeclare replaceable
      Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.EconomizerNoRelief
      secOutRel "Air economizer - No relief branch",
    id="VAV_1",
    nZon=2,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end NoRelief;
