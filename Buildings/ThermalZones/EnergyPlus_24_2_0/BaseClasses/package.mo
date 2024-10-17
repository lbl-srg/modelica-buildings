within Buildings.ThermalZones.EnergyPlus_24_2_0;
package BaseClasses "Package with base classes for Buildings.ThermalZones.EnergyPlus_24_2_0"
  extends Modelica.Icons.BasesPackage;
    constant String buildingsRootFileLocation=
      Modelica.Utilities.Files.loadResource("modelica://Buildings/legal.html")
      "Path to top-level legal.html of the Buildings library (used to find the spawn executable)";

    annotation (
    preferredView="info",
    Documentation(
      info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0\">Buildings.ThermalZones.EnergyPlus_24_2_0</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 21, 2022, by Michael Wetter:<br/>
Addressed platform incompatibility in assignment of <code>buildingsLibraryRootFileLocation</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2927\">issue 2927</a>.
</li>
<li>
December 11, 2021, by Michael Wetter:<br/>
Removed call to impure function <code>Modelica.Utilities.Files.FullPathName</code>.
This is for MSL 4.0.0.
</li>
</ul>
</html>"));
end BaseClasses;
