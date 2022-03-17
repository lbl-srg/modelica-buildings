within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZCoilEvaporatorVariable
  extends VAVMZNoEconomizer(
                           redeclare
      UserProject.AirHandlersFans.VAVMZCoilEvaporatorVariable VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVMZCoilEvaporatorVariable;
