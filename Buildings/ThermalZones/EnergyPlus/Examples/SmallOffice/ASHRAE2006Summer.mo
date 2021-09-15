within Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice;
model ASHRAE2006Summer
  "Variable air volume flow system with terminal reheat and five thermal zones using a control sequence published by ASHRAE in 2006"
  extends Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.ASHRAE2006Winter;
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/SmallOffice/ASHRAE2006Summer.mos" "Simulate and plot"),
    experiment(
      StartTime=16848000,
      StopTime=17280000,
      Tolerance=1e-07),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-400,-320},{1380,680}})),
    Documentation(
      info="<html>
<p>
This is the same model as
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.ASHRAE2006Winter\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.ASHRAE2006Winter</a>
but configured for simulation of a few days in spring.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 23, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ASHRAE2006Summer;
