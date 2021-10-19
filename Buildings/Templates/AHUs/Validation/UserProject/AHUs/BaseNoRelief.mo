within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model BaseNoRelief
  extends VAVMultiZone(
    redeclare
      .Buildings.Templates.AHUs.BaseClasses.OutdoorReliefReturnSection.NoRelief
      secOutRel,
    final id="VAV_1",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end BaseNoRelief;
