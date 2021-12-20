within Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses;
model Junction
  "Fluid junction with zero pressure drop"
  extends Fluid.FixedResistances.Junction(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
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
This is a model of a fluid junction with zero pressure drop.
By default the model is configured in steady-state. 
</p>
</html>"));
end Junction;
