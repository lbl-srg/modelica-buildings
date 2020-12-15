within Buildings.ThermalZones;
package EnergyPlus
  "Package with models to connect to the EnergyPlus SOEP thermal zone model"
  extends Modelica.Icons.Package;
  annotation (
    Icon(
      graphics={
        Bitmap(
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/spawn_icon_alonelowres.png")}),
    Documentation(
      info="<html>
<p align=\"right\">
<img alt=\"Spawn logo\" src=\"modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/spawn_icon_darkbluetxlowres.png\"  style=\"float:right;height=203px;width:587px;\"/>
</p>
<p>
Package for Spawn of EnergyPlus that couples Modelica directly
to the EnergyPlus envelope model.<br/>
This allows simulating the envelope heat transfer
of one or several buildings in EnergyPlus, and simulating HVAC and controls
in Modelica. EnergyPlus objects are represented graphically as any other Modelica
models, and the coupling and co-simulation is done automatically based on these models.
</p>
<p>
Models are provided to connect to EnergyPlus thermal zones, actuators, output variables and schedules.
</p>
<p>
See <a href=\"modelica://Buildings.ThermalZones.EnergyPlus.UsersGuide\">
Buildings.ThermalZones.EnergyPlus.UsersGuide</a>
for more information.
</p>
</html>"));
end EnergyPlus;
