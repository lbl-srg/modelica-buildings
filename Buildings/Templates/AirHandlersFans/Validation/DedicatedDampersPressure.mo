within Buildings.Templates.AirHandlersFans.Validation;
model DedicatedDampersPressure
  extends NoEconomizer(    redeclare
      UserProject.AirHandlersFans.DedicatedDampersPressure VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end DedicatedDampersPressure;
