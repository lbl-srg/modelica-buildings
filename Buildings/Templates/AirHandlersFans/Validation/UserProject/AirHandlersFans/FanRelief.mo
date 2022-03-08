within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model FanRelief
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    secOutRel(redeclare replaceable
        Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReliefFan
        secRel "Relief fan with two-position relief damper"),
    nZon=2);

  annotation (
    defaultComponentName="ahu");
end FanRelief;
