within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model FanReturnSingleVariable
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    secOutRel(redeclare
        Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan
        secRel(redeclare Buildings.Templates.Components.Fans.SingleVariable
          fanRet "Single fan - Variable speed")
        "Return fan - Modulated relief damper"),
    nZon=1,
    nGro=1,
    id="VAV_1");

  annotation (
    defaultComponentName="ahu");
end FanReturnSingleVariable;
