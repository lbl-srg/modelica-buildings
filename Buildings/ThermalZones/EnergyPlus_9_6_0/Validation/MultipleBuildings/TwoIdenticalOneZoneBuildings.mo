within Buildings.ThermalZones.EnergyPlus_9_6_0.Validation.MultipleBuildings;
model TwoIdenticalOneZoneBuildings
  "Validation model with two identical buildings, each having one thermal zone"
  extends Modelica.Icons.Example;
  constant Integer n=2
    "Number of buildings";
  Zone bui[n]
    "Buildings"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  model Zone
    "Model of a thermal zone"
    extends Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.Unconditioned;
    extends Modelica.Blocks.Icons.Block;
  end Zone;
  annotation (
    Documentation(
      info="<html>
<p>
Model that validates that multiple buildings can be simulated that use the same EnergyPlus idf file.
The model has two identical buildings, each having one thermal zone.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 1, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Validation/MultipleBuildings/TwoIdenticalOneZoneBuildings.mos" "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06));
end TwoIdenticalOneZoneBuildings;
