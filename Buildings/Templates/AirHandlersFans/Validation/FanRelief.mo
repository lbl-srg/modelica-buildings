within Buildings.Templates.AirHandlersFans.Validation;
model FanRelief
  extends NoEconomizer(redeclare UserProject.AHUs.FanRelief ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanRelief;
