within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model BaseNoRelief
  extends VAVSingleDuctWithEconomizer(
    redeclare BaseClasses.ReliefReturnSection.NoRelief secRel
      "No relief branch",
    final id="VAV_1",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end BaseNoRelief;
