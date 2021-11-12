within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model NoEconomizer
  extends VAVMultiZone(
    redeclare Buildings.Templates.Components.Fans.None fanSupDra,
    redeclare
      Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.NoEconomizer
      secOutRel "No air economizer",
    id="VAV_1",
    nZon=2,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end NoEconomizer;
