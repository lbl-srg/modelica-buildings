within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZDedicatedDampersPressure
  extends VAVMZNoEconomizer(redeclare
      UserProject.AirHandlersFans.VAVMZDedicatedDampersPressure VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVMZDedicatedDampersPressure;
