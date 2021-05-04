within Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice;
model Guideline36Spring
  "Variable air volume flow system with terminal reheat and five thermal zones controlled using an ASHRAE G36 controller"
  extends Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.Guideline36Winter;
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/SmallOffice/Guideline36Spring.mos" "Simulate and plot"),
    experiment(
      StartTime=7344000,
      StopTime=7776000,
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
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.Guideline36Winter\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.Guideline36Winter</a>
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
end Guideline36Spring;
