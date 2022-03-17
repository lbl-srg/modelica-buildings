within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZDedicatedDampersAirflow "Validation model for multiple-zone VAV"
  extends VAVMZNoEconomizer(redeclare
      UserProject.AirHandlersFans.VAVMZDedicatedDampersAirflow VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVMZDedicatedDampersAirflow;
