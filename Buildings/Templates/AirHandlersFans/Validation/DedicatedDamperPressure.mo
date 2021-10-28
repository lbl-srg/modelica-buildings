within Buildings.Templates.AirHandlersFans.Validation;
model DedicatedDamperPressure
  extends NoFanNoReliefSingleDamper(redeclare
      UserProject.AHUs.DedicatedDamperPressure ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end DedicatedDamperPressure;
