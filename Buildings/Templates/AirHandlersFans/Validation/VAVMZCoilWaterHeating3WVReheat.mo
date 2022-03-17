within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZCoilWaterHeating3WVReheat
  extends VAVMZNoEconomizer(redeclare
      UserProject.AirHandlersFans.VAVMZCoilWaterHeating3WVReheat VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVMZCoilWaterHeating3WVReheat;
