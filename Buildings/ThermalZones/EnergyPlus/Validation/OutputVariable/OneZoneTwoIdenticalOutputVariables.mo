within Buildings.ThermalZones.EnergyPlus.Validation.OutputVariable;
model OneZoneTwoIdenticalOutputVariables
  "Validation model for one zone with two identical output variables"
  extends OneZoneOneOutputVariable;
  Buildings.ThermalZones.EnergyPlus.OutputVariable equEle2(
    name="Zone Electric Equipment Electricity Rate",
    key="LIVING ZONE",
    y(
      final unit="W"))
    "Block that reads output from EnergyPlus"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  annotation (
    Documentation(
      info="<html>
<p>
Simple test case for one building with one thermal zone and two identical output variables.
This test case validates that the outputs are correct even if requested twice
from the same EnergyPlus variable.
</p>
</html>",
      revisions="<html>
<ul><li>
December 13, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/OutputVariable/OneZoneTwoIdenticalOutputVariables.mos" "Simulate and plot"),
    experiment(
      StopTime=432000,
      Tolerance=1e-06));
end OneZoneTwoIdenticalOutputVariables;
