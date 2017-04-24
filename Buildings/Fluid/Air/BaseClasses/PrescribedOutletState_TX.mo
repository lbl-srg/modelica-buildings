within Buildings.Fluid.Air.BaseClasses;
model PrescribedOutletState_TX
   "Component that assigns the outlet fluid property at port_a based on an input signal for temperature and mass fraction"
   extends Buildings.Fluid.Interfaces.PrescribedOutletState;


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PrescribedOutletState_TX;
