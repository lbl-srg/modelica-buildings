within Buildings.Templates.AirHandlersFans.Validation;
model NoRelief
  extends NoEconomizer(             redeclare
      UserProject.AHUs.NoRelief ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end NoRelief;
