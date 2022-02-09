within Buildings.Templates.AirHandlersFans.Validation;
model NoRelief
  extends BaseNoEconomizer(redeclare UserProject.AHUs.NoRelief VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end NoRelief;
