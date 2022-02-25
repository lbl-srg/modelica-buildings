within Buildings.Templates.AirHandlersFans.Validation;
model CoilEvaporatorVariableSpeed
  extends BaseNoEconomizer(redeclare
      UserProject.AHUs.CoilEvaporatorVariableSpeed VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilEvaporatorVariableSpeed;
