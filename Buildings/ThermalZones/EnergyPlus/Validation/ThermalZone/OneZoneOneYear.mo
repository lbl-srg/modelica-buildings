within Buildings.ThermalZones.EnergyPlus.Validation.ThermalZone;
model OneZoneOneYear
  "Validation model for one zone"
  extends Buildings.ThermalZones.EnergyPlus.Validation.ThermalZone.OneZone;

  annotation (
    Documentation(
      info="<html>
<p>
Simple test case that simulates a building with
one thermal zone for one year.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/ThermalZone/OneZoneOneYear.mos" "Simulate and plot"),
    experiment(
      StartTime=31276800,
      StopTime=31536000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end OneZoneOneYear;
