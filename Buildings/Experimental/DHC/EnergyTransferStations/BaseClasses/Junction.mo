within Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses;
model Junction
  "Fluid junction"
  extends Fluid.FixedResistances.Junction(
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final dp_nominal=fill(
      0,
      3),
    final from_dp=false);
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(
      info="<html>
<p>
This is a model of a fluid junction, configured with zero pressure drop.
</p>
</html>"));
end Junction;
