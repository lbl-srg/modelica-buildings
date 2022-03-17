within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZCoilEvaporatorVariable "Validation model for multiple-zone VAV"
  extends VAVMZNoEconomizer(
                           redeclare
      UserProject.AirHandlersFans.VAVMZCoilEvaporatorVariable VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVMZCoilEvaporatorVariable;
