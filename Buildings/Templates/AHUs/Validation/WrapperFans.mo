within Buildings.Templates.AHUs.Validation;
model WrapperFans
  extends BaseNoEquipment(redeclare
    UserProject.AHUs.WrapperFans ahu);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WrapperFans;
