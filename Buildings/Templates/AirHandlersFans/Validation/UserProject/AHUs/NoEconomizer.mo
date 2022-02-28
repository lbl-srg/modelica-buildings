within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model NoEconomizer
  extends VAVMultiZone(
    redeclare replaceable Buildings.Templates.Components.Fans.None fanSupDra,
    redeclare replaceable
      Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.NoEconomizer
      secOutRel "No air economizer",
    nZon=2);

  annotation (
    defaultComponentName="ahu");
end NoEconomizer;
