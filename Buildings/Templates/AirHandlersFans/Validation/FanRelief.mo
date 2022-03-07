within Buildings.Templates.AirHandlersFans.Validation;
model FanRelief
  extends BaseNoEconomizer(
    redeclare UserProject.AHUs.FanRelief VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanRelief;
