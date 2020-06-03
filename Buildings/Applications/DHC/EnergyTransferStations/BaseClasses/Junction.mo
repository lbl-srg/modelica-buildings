within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model Junction "Fluid junction"
  extends Fluid.FixedResistances.Junction(
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final dp_nominal=fill(0, 3),
    final from_dp=false);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Junction;
