within Buildings.ThermalZones.EnergyPlus;
package BaseClasses "Package with base classes for Buildings.ThermalZones.EnergyPlus"
  extends Modelica.Icons.BasesPackage;
  constant String buildingsLibraryRoot=
    Modelica.Utilities.Strings.substring(
      string=legalFileLocation,
      startIndex=1,
      endIndex=Modelica.Utilities.Strings.length(legalFileLocation)-11)
    "Root directory of the Buildings library (used to find the spawn executable)";

  protected
  constant String legalFileLocation = Modelica.Utilities.Files.fullPathName(Modelica.Utilities.Files.loadResource("modelica://Buildings/legal.html"))
    "Location of legal.html file (used to find the spawn executable)";
  annotation (
    preferredView="info",
    Documentation(
      info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus\">Buildings.ThermalZones.EnergyPlus</a>.
</p>
</html>"));
end BaseClasses;
