within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model FanReturnSingleVariable
  extends VAVSingleDuctWithEconomizer(
    redeclare BaseClasses.ReliefReturnSection.ReturnFan secRel(redeclare
        Templates.BaseClasses.Fans.SingleVariable fanRet
        "Single fan - Variable speed"),
    nZon=1,
    nGro=1,
    final id="VAV_1");

  annotation (
    defaultComponentName="ahu");
end FanReturnSingleVariable;
