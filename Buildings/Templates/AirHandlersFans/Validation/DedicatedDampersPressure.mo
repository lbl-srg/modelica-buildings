within Buildings.Templates.AirHandlersFans.Validation;
model DedicatedDampersPressure
  extends NoEconomizer(             redeclare
      UserProject.AHUs.DedicatedDampersPressure ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end DedicatedDampersPressure;
