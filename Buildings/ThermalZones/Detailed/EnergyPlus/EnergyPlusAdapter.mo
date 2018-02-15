within Buildings.ThermalZones.Detailed.EnergyPlus;
model EnergyPlusAdapter
  "Top level model to connect to EnergyPlus building model"
  extends Modelica.Blocks.Icons.Block;

  inner parameter String fmuName = "" "Name of the FMU file"
  annotation (
    Dialog(loadSelector(filter="FMU files (*.fmu)",
                        caption="Select fmu file")));
protected
  Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.FMUBuildingAdapter
    adapter=
      Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.FMUBuildingAdapter(
      fmuName = fmuName)
    "Class to communicate with EnergyPlus";
  annotation (
  defaultComponentName = "energyPlusAdapter",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-98,-98},{98,98}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/Detailed/EnergyPlus/EnergyPlusLogo.png")}),
  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
initial equation
  assert(fmuName <> "", "Must provide the name of the fmu file.");
end EnergyPlusAdapter;
