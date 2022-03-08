within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model NoEconomizer
  extends VAVMultiZone(
    redeclare replaceable
      Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.NoEconomizer
      secOutRel "No air economizer",
    nZon=2);

  annotation (
    defaultComponentName="ahu");
end NoEconomizer;
