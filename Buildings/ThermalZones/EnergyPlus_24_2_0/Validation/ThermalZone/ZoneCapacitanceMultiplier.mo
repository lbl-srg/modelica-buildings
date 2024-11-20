within Buildings.ThermalZones.EnergyPlus_24_2_0.Validation.ThermalZone;
model ZoneCapacitanceMultiplier
  "Validation model for zone capacitance multiplier in Spawn"
  extends Modelica.Icons.Example;
  Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SingleFamilyHouse.Unconditioned defCap
    "Default capacitance"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SingleFamilyHouse.Unconditioned mulCap(
    building(
      idfName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_24_2_0/Examples/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/SingleFamilyHouse_TwoSpeed_ZoneAirBalance_zoneCapacitanceMultiplier.idf")))
        "Capacitance with a multiplier of 10"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  annotation (
    Documentation(
      info="<html>
<p>
This validation case simulates two instances of
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SingleFamilyHouse.Unconditioned\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SingleFamilyHouse.Unconditioned</a>.
In the instance <code>mulCap</code>, the case is modified by adding
the following snippet to the idf file:
</p>
<pre>
ZoneCapacitanceMultiplier:ResearchSpecial,
    Living zone heat capacitance multiplier,  !- Name
    LIVING ZONE,                              !- Zone or ZoneList Name
    10,                                       !- Temperature Capacity Multiplier
     ,                                        !- Humidity Capacity Multiplier
     ,                                        !- Carbon Dioxide Capacity Multiplier
     ;                                        !- Generic Contaminant Capacity Multiplier
</pre>
<p>
This model is to validate that this leads to a difference in the simulation
results as expected.
</p>
</html>",
      revisions="<html>
<ul>
<li>
August 23, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3481\">#3481</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_2_0/Validation/ThermalZone/ZoneCapacitanceMultiplier.mos" "Simulate and plot"),
    experiment(
      StopTime=432000,
      Tolerance=1e-06));
end ZoneCapacitanceMultiplier;
