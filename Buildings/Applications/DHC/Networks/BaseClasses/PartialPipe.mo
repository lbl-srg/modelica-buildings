within Buildings.Applications.DHC.Networks.BaseClasses;
partial model PartialPipe "Base model for pipes"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    allowFlowReversal=false);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialPipe;
