within Buildings.ThermalZones.EnergyPlus;
package BaseClasses "Package with base classes for Buildings.ThermalZones.EnergyPlus"
  extends Modelica.Icons.BasesPackage;
  constant String buildingsLibraryRoot=Modelica.Utilities.Strings.replace(
    string=Modelica.Utilities.Files.loadResource("modelica://Buildings/legal.html"),
    searchString="/legal.html",
    replaceString="")
    "Root directory of the Buildings library (used to find the spawn executable)";

  annotation (
    preferredView="info",
    Documentation(
      info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus\">Buildings.ThermalZones.EnergyPlus</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 11, 2021, by Michael Wetter:<br/>
Removed call to impure function <code>Modelica.Utilities.Files.FullPathName</code>.
This is for MSL 4.0.0.
</li>
</ul>
</html>"));
end BaseClasses;
