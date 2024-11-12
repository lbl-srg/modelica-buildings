within Buildings.ThermalZones.EnergyPlus_24_2_0.Validation.MultipleBuildings;
model TwoIdenticalTwoZoneBuildings
  "Validation model with two identical buildings, each having two thermal zones"
  extends Modelica.Icons.Example;
  constant Integer n=2
    "Number of buildings";
  Zone bui[n]
    "Buildings"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  model Zone
    "Model of a thermal zone"
    extends Buildings.ThermalZones.EnergyPlus_24_2_0.Validation.ThermalZone.TwoIdenticalZones;
    extends Modelica.Blocks.Icons.Block;
  end Zone;
  annotation (
    Documentation(
      info="<html>
<p>
Model that validates that multiple buildings can be simulated that use the same EnergyPlus idf file.
The model has two identical buildings, each having two thermal zones.
</p>
<p>
This model has been added because a building with multiple thermal zones executes
C code that is not executed if there is only one thermal zone, as is the case in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Validation.MultipleBuildings.TwoIdenticalOneZoneBuildings\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Validation.MultipleBuildings.TwoIdenticalOneZoneBuildings</a>.
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
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_2_0/Validation/MultipleBuildings/TwoIdenticalTwoZoneBuildings.mos" "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06));
end TwoIdenticalTwoZoneBuildings;
