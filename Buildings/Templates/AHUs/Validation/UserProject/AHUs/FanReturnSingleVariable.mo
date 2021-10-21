within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model FanReturnSingleVariable
  extends VAVMultiZone(
    redeclare
      .Buildings.Templates.AHUs.Components.OutdoorReliefReturnSection.Economizer
      secOutRel(redeclare
        .Buildings.Templates.AHUs.Components.ReliefReturnSection.ReturnFan
        secRel(redeclare .Buildings.Templates.Components.Fans.SingleVariable
          fanRet "Single fan - Variable speed")
        "Return fan - Modulated relief damper"),
    nZon=1,
    nGro=1,
    final id="VAV_1");

  annotation (
    defaultComponentName="ahu");
end FanReturnSingleVariable;
