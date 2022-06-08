within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses;
model LoadTwoWayValveControl
  "Model of a load on hydronic circuit with flow rate modulation by two-way valve"
  extends PartialLoadValveControl(
    redeclare HydronicConfigurations.ActiveNetworks.Throttle con);
  annotation (
  defaultComponentName="loa",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LoadTwoWayValveControl;
