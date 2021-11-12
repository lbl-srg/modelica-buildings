within Buildings.Templates.AirHandlersFans.Validation;
model DedicatedDamperAirflow
  extends NoEconomizer(             redeclare
      UserProject.AHUs.DedicatedDamperAirflow ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end DedicatedDamperAirflow;
