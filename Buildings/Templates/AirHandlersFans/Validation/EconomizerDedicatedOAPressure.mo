within Buildings.Templates.AirHandlersFans.Validation;
model EconomizerDedicatedOAPressure
  extends BaseNoEquipment(redeclare
      UserProject.AHUs.EconomizerDedicatedOAPressure ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end EconomizerDedicatedOAPressure;
