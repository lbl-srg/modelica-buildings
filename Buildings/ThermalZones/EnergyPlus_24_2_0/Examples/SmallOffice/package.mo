within Buildings.ThermalZones.EnergyPlus_24_2_0.Examples;
package SmallOffice "Package with VAV models for a small office building"
  extends Modelica.Icons.ExamplesPackage;

  annotation (
    preferredView="info",
    Documentation(
      info="<html>
<p>
This package contains variable air volume flow models
for a office building.
</p>
<h4>Note</h4>
<p>
The models
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.ASHRAE2006Winter\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.ASHRAE2006Winter</a>
and
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.Guideline36Winter\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.Guideline36Winter</a>
appear to be quite similar to
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>
and
<a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
Buildings.Examples.VAVReheat.Guideline36</a>,
respectively, because they all have the same HVAC system, control sequences,
and all have five thermal zones.
However, the models in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice</a>
are from the
<i>DOE Commercial Reference Building,
Small Office, new construction, ASHRAE 90.1-2004,
Version 1.3_5.0</i>,
whereas the models in
<a href=\"modelica://Buildings.Examples.VAVReheat\">
Buildings.Examples.VAVReheat</a>
are from the
<i>DOE Commercial Building Benchmark,
Medium Office, new construction, ASHRAE 90.1-2004,
version 1.2_4.0</i>.
Therefore, the dimensions of the thermal zones in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice</a>
are considerably smaller than in
<a href=\"modelica://Buildings.Examples.VAVReheat\">
Buildings.Examples.VAVReheat</a>.
As the sizing is scaled with the volumes of the thermal zones, the model <i>structure</i>
is the same, but the design capacities are different, as is the energy consumption.
</p>
</html>"));
end SmallOffice;
