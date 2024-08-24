within Buildings.ThermalZones.EnergyPlus_24_1_0.Examples.SmallOffice;
model Guideline36Spring
  "Variable air volume flow system with terminal reheat and five thermal zones controlled using an ASHRAE G36 controller"
  extends Buildings.ThermalZones.EnergyPlus_24_1_0.Examples.SmallOffice.Guideline36Winter;
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_1_0/Examples/SmallOffice/Guideline36Spring.mos" "Simulate and plot"),
    experiment(
      StartTime=7344000,
      StopTime=7776000,
      Tolerance=1e-07),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true)),
    Documentation(
      info="<html>
<p>
This is the same model as
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_1_0.Examples.SmallOffice.Guideline36Winter\">
Buildings.ThermalZones.EnergyPlus_24_1_0.Examples.SmallOffice.Guideline36Winter</a>
but configured for simulation of a few days in spring.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 20, 2021, by Michael Wetter:<br/>
Changed parameter declarations and added optimal start up.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2829\">issue #2829</a>.
</li>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
<li>
December 23, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Guideline36Spring;
