within Buildings.Templates.AirHandlersFans.Validation;
model FanReturnSingleVariable
  extends NoFanNoReliefSingleDamper(
     redeclare UserProject.AHUs.FanReturnSingleVariable ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanReturnSingleVariable;
