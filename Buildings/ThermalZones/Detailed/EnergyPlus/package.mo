within Buildings.ThermalZones.Detailed;
package EnergyPlus "Package with models to connect to the EnergyPlus SOEP thermal zone model"
  extends Modelica.Icons.Library;

  annotation (Icon(graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://Buildings/Resources/Images/ThermalZones/Detailed/EnergyPlus/EnergyPlusLogo.png")}),
    Documentation(info="<html>
<p>
Package with a thermal zone model that connects to the zone heat balance
of EnergyPlus.
For each thermal zone of EnergyPlus, one instance of
<a href=\"modelica://Buildings.ThermalZones.Detailed.EnergyPlus.ThermalZone\">
Buildings.ThermalZones.Detailed.EnergyPlus.ThermalZone</a>
needs to be used.
</p>
<p>
See <a href=\"modelica://Buildings.ThermalZones.Detailed.EnergyPlus.ThermalZone\">
Buildings.ThermalZones.Detailed.EnergyPlus.ThermalZone</a>
for more information.
</p>
</html>"));
end EnergyPlus;
