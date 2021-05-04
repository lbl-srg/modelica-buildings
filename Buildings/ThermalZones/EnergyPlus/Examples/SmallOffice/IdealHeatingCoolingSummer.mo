within Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice;
model IdealHeatingCoolingSummer
  "Building with constant fresh air and ideal heating/cooling that exactly meets set point"
  extends Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.IdealHeatingCoolingWinter;
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/SmallOffice/IdealHeatingCoolingSummer.mos" "Simulate and plot"),
    experiment(
      StartTime=16848000,
      StopTime=17280000,
      Tolerance=1e-06),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true)),
    Documentation(
      info="<html>
<p>
This is the same model as
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.IdealHeatingCoolingWinter\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.IdealHeatingCoolingWinter</a>
but configured for simulation of a few days in summer.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 5, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end IdealHeatingCoolingSummer;
