within Buildings.Fluid.ZoneEquipment.BaseClasses;
model ModularController
  extends Buildings.Fluid.ZoneEquipment.BaseClasses.ControllerInterfaces;
  VariableFan conVarFanConWat(has_hea=has_hea, has_coo=has_coo)
    annotation (Placement(transformation(extent={{-14,-94},{14,-66}})));
  CyclingFan conFanCyc
    annotation (Placement(transformation(extent={{-14,-44},{14,-16}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ModularController;
