within Buildings.Templates.AirHandlersFans.Validation;
model FanReturnSingleVariable
  extends NoEconomizer(
     redeclare UserProject.AHUs.FanReturnSingleVariable ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanReturnSingleVariable;
