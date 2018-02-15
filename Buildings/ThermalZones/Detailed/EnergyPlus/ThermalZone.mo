within Buildings.ThermalZones.Detailed.EnergyPlus;
model ThermalZone "Model to connect to an EnergyPlus thermal zone"
  parameter String fmuName "Name of the FMU file that contains this zone";

  parameter String zoneName "Name of the thermal zone as specified in the EnergyPlus input";
  parameter Integer nFluPor(min=2) "Number of fluid ports (Set to 2 for one inlet and one outlet)";

  Modelica.Blocks.Interfaces.RealInput Q_flow "Heat flow rate"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.SIunits.Temperature TAir(start=293.15, fixed=true) "Zone air temperature";

protected
  Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.FMUZoneAdapter
    adapter=
      Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.FMUZoneAdapter(
      fmuName = fmuName,
      zoneName = zoneName,
      nFluPor = nFluPor)
    "Class to communicate with EnergyPlus";
initial equation
  assert(fmuName <> "", "Must provide the name of the fmu file.");
  assert(zoneName <> "", "Must provide the name of the zone.");
equation
  der(TAir) = Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.exchangeValues(
    adapter=adapter,
    TAir=TAir,
    Q_flow=Q_flow);
  annotation (
  defaultComponentName="zon",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThermalZone;
