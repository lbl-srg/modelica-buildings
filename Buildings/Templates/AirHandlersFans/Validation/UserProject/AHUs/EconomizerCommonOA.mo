within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model EconomizerCommonOA
  extends VAVMultiZone(
    secOutRel(redeclare
        .Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleCommon
                                                                         secOut
        "Single common OA damper (modulated) with AFMS"),
    nZon=1,
    nGro=1,
    final id="VAV_1");

  annotation (
    defaultComponentName="ahu");
end EconomizerCommonOA;
