within Buildings.ThermalZones.EnergyPlus_24_1_0.Validation.OutputVariable;
model OneZoneOneOutputVariable
  "Validation model for one zone with one output variable"
  extends Buildings.ThermalZones.EnergyPlus_24_1_0.Examples.SingleFamilyHouse.Unconditioned;
  Buildings.ThermalZones.EnergyPlus_24_1_0.OutputVariable equEle(
    name="Zone Electric Equipment Electricity Rate",
    key="LIVING ZONE",
    y(final unit="W"))
    "Block that reads output from EnergyPlus"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  annotation (
    Documentation(
      info="<html>
<p>
Simple test case for one building with one thermal zone and one output variable.
</p>
<p>
The room air temperature is free floating.
</p>
</html>",
      revisions="<html>
<ul><li>
October 7, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_1_0/Validation/OutputVariable/OneZoneOneOutputVariable.mos" "Simulate and plot"),
    experiment(
      StopTime=432000,
      Tolerance=1e-06));
end OneZoneOneOutputVariable;
