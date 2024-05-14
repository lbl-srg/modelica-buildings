within ;
package Buildings "Library with models for building energy and control systems"
  extends Modelica.Icons.Package;


annotation (
preferredView="info",
version="11.1.0",
versionDate="2024-04-09",
dateModified="2024-04-09",
uses(Modelica(version="4.0.0")),
conversion(
  noneFromVersion="11.0.0",
  from(
    version={"10.0.0", "10.1.0"},
    script="modelica://Buildings/Resources/Scripts/Conversion/ConvertBuildings_from_10_to_11.0.0.mos"),
  from(
    version={"9.0.0", "9.1.0", "9.1.1", "9.1.2"},
    script="modelica://Buildings/Resources/Scripts/Conversion/ConvertBuildings_from_9_to_10.0.0.mos"),
  from(
    version={"8.0.0", "8.1.0", "8.1.1", "8.1.2", "8.1.3"},
    to="9.0.0",
    script="modelica://Buildings/Resources/Scripts/Conversion/ConvertBuildings_from_8_to_9.0.0.mos")),
preferredView="info",
Documentation(info="<html>
<p>
The <code>Buildings</code> library is a free library
for modeling building energy and control systems.
Many models are based on models from the package
<code>Modelica.Fluid</code> and use
the same ports to ensure compatibility with the Modelica Standard
Library.
</p>
<p>
The figure below shows a section of the schematic view of the model
<a href=\"modelica://Buildings.Examples.HydronicHeating\">
Buildings.Examples.HydronicHeating</a>.
In the lower part of the figure, there is a dynamic model of a boiler, a pump and a stratified energy storage tank. Based on the temperatures of the storage tank, a finite state machine switches the boiler and its pump on and off.
The heat distribution is done using a hydronic heating system with a three way valve and a pump with variable revolutions. The upper right hand corner shows a room model that is connected to a radiator whose flow is controlled by a thermostatic valve.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/UsersGuide/HydronicHeating.png\" border=\"1\"/>
</p>
<p>
The web page for this library is
<a href=\"http://simulationresearch.lbl.gov/modelica\">http://simulationresearch.lbl.gov/modelica</a>,
and the development page is
<a href=\"https://github.com/lbl-srg/modelica-buildings\">https://github.com/lbl-srg/modelica-buildings</a>.
Contributions to further advance the library are welcomed.
Contributions may not only be in the form of model development, but also
through model use, model testing,
requirements definition or providing feedback regarding the model applicability
to solve specific problems.
</p>
</html>"));
end Buildings;
