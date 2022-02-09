within Buildings.Templates.AirHandlersFans.Validation;
model DedicatedDampersAirflow
  extends BaseNoEconomizer(redeclare UserProject.AHUs.DedicatedDampersAirflow
      VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end DedicatedDampersAirflow;
