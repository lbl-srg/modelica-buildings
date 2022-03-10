within Buildings.Templates.AirHandlersFans.Validation;
model NoRelief
  extends NoEconomizer(    redeclare UserProject.AirHandlersFans.NoRelief VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end NoRelief;
