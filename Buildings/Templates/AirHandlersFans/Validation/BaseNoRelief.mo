within Buildings.Templates.AirHandlersFans.Validation;
model BaseNoRelief
  extends BaseNoEquipment(redeclare UserProject.AHUs.BaseNoRelief ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end BaseNoRelief;
