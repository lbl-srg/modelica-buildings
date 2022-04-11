within Buildings.ThermalZones.EnergyPlus.Validation.SurfaceComparison;
model SurfaceComparison
  "Validation model for reference surfaces and zone surfaces"
  extends Modelica.Icons.Example;

  Buildings.ThermalZones.EnergyPlus.Validation.SurfaceComparison.BaseClasses.ReferenceSurfaces refSur
    "Building that models the envelope with EnergyPlus surfaces"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.ThermalZones.EnergyPlus.Validation.SurfaceComparison.BaseClasses.ZoneSurfaces zonSur
    "Building that models the envelope with Spawn surfaces"
    annotation (Placement(transformation(extent={{-12,-40},{8,-20}})));
  annotation (
    Documentation(
      info="<html>
<p>
This model validates that the <a href=\"modelica://Buildings.ThermalZones.EnergyPlus.ZoneSurface\">
Buildings.ThermalZones.EnergyPlus.ZoneSurface</a> objects results in similar surface heat
transfer to the equivalent EnergyPlus surface object.
</p>
<p>
It does so by comparing the temperature of the building in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Validation.SurfaceComparison.BaseClasses.ReferenceSurfaces\">
Buildings.ThermalZones.EnergyPlus.Validation.SurfaceComparison.BaseClasses.ReferenceSurfaces</a>
that only uses EnergyPlus surfaces, and the building in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Validation.SurfaceComparison.BaseClasses.ZoneSurfaces\">
Buildings.ThermalZones.EnergyPlus.Validation.SurfaceComparison.BaseClasses.ZoneSurfaces</a>
that uses the same envelope but replaces select surfaces with 
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.ZoneSurface\">
Buildings.ThermalZones.EnergyPlus.ZoneSurface</a> objects.
</p>
</html>",
      revisions="<html>
<ul><li>
July 21, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/SurfaceComparison/SurfaceComparison.mos"
        "Simulate and Plot"),
    experiment(
      StopTime=2592000,
      Tolerance=1e-06));
end SurfaceComparison;
