within Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SingleFamilyHouse;
model EquipmentSchedule
  "Example model with a schedule that overrides a schedule in EnergyPlus"
  extends Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SingleFamilyHouse.Unconditioned;
  Buildings.ThermalZones.EnergyPlus_24_2_0.Schedule schInt(
    name="INTERMITTENT",
    unit=Buildings.ThermalZones.EnergyPlus_24_2_0.Types.Units.Normalized)
    "Block that writes to the EnergyPlus schedule INTERMITTENT"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse intLoaFra(
    shift(
      displayUnit="h")=25200,
    period(
      displayUnit="d")=86400)
    "Schedule for fraction of internal loads"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

equation
  connect(schInt.u,intLoaFra.y)
    annotation (Line(points={{-42,80},{-58,80}},color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
Example model that demonstrates how to override a schedule in EnergyPlus.
The model overrides the EnergyPlus schedule <code>INTERMITTENT</code>,
which is used by EnergyPlus to control the equipment in the thermal zone.
</p>
</html>",
      revisions="<html>
<ul><li>
May 21, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_2_0/Examples/SingleFamilyHouse/EquipmentSchedule.mos" "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06));
end EquipmentSchedule;
