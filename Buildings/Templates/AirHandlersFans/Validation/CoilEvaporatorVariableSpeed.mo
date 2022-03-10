within Buildings.Templates.AirHandlersFans.Validation;
model CoilEvaporatorVariableSpeed
  extends NoEconomizer(    redeclare
      UserProject.AirHandlersFans.CoilEvaporatorVariableSpeed VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilEvaporatorVariableSpeed;
