within Buildings.Templates.AirHandlersFans.Validation;
model EconomizerCommonOA
  extends BaseNoEquipment(redeclare UserProject.AHUs.EconomizerCommonOA ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end EconomizerCommonOA;
