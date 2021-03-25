within Buildings.Templates.AHUs.Validation;
model WrapperEconomizerDampers
  extends BaseNoEquipment(redeclare
      UserProject.AHUs.WrapperEconomizerDampers ahu);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WrapperEconomizerDampers;
