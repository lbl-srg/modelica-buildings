within Buildings.Templates.AirHandlersFans.Validation;
model DedicatedDampersAirflow
  extends NoEconomizer(             redeclare
      UserProject.AHUs.DedicatedDampersAirflow ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end DedicatedDampersAirflow;
