within Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice;
model IdealHeatingCoolingSummer_Autosizing
  "Building with constant fresh air and ideal heating/cooling that exactly meets set point with HVAC sized using autosizing"
  extends Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.IdealHeatingCoolingWinter_Autosizing;
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_2_0/Examples/SmallOffice/IdealHeatingCoolingSummer_Autosizing.mos" "Simulate and plot"),
    experiment(
      StartTime=15552000,
      StopTime=17280000,
      Tolerance=1e-07,
      __Dymola_Algorithm="Dassl"),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true)),
    Documentation(
      info="<html>
<p>
This is the same model as
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.IdealHeatingCoolingWinter_Autosizing\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.IdealHeatingCoolingWinter_Autosizing</a>
but configured for simulation of a few days in summer.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 23, 2026, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end IdealHeatingCoolingSummer_Autosizing;
