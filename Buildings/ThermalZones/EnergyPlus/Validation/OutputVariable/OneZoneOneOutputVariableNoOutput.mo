within Buildings.ThermalZones.EnergyPlus.Validation.OutputVariable;
model OneZoneOneOutputVariableNoOutput
  "Failing example caused by missing Output:Variable in the idf"
  extends
    Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.UnconditionedNoOutput;
  Buildings.ThermalZones.EnergyPlus.OutputVariable equEle(
    name="Zone Electric Equipment Electricity Rate",
    key="LIVING ZONE",
    y(final unit="W"))
    "Block that reads output from EnergyPlus"
    annotation (Placement(transformation(extent={{60,30},{80,50}})),
    experiment(
      StopTime=432000,
      Tolerance=1e-06));
end OneZoneOneOutputVariableNoOutput;
