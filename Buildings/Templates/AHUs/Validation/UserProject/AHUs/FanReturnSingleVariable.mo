within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model FanReturnSingleVariable
  extends VAVSingleDuct(
    nZon=1,
    final id="VAV_1",
    redeclare replaceable Buildings.Templates.BaseClasses.Fans.SingleVariable
      fanRet);

  annotation (
    defaultComponentName="ahu");
end FanReturnSingleVariable;
