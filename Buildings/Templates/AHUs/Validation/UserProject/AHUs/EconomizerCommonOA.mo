within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerCommonOA
  extends VAVSingleDuctWithEconomizer(
    secOutRel(redeclare BaseClasses.OutdoorSection.SingleCommon secOut
        "Single common OA damper (modulated) with AFMS"),
    nZon=1,
    nGro=1,
    final id="VAV_1");

  annotation (
    defaultComponentName="ahu");
end EconomizerCommonOA;
