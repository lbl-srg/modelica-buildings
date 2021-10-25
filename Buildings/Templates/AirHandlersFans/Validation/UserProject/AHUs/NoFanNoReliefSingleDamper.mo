within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model NoFanNoReliefSingleDamper
  extends VAVMultiZone(
    redeclare Buildings.Templates.Components.Fans.None fanSupDra,
    redeclare
      Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.EconomizerNoRelief
      secOutRel(redeclare
        Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleDamper
        secOut "Single common OA damper (modulated) with AFMS"),
    id="VAV_1",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end NoFanNoReliefSingleDamper;
