within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Networks.BaseClasses;
partial model BasePipe "Base model for pipes"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    allowFlowReversal=false);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BasePipe;
