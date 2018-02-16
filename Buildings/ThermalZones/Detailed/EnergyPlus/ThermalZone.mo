within Buildings.ThermalZones.Detailed.EnergyPlus;
model ThermalZone "Model to connect to an EnergyPlus thermal zone"
  extends Modelica.Blocks.Icons.Block;
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
   Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-72},{96,124}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/Detailed/EnergyPlus/EnergyPlusLogo.png"),
        Text(
          extent={{-52,-32},{52,-62}},
          lineColor={0,0,0},
          textString="%fmuName"),
        Text(
          extent={{-52,-66},{52,-96}},
          lineColor={0,0,0},
          textString="%zoneName")}),
   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Model for a thermal zone that is implemented in EnergyPlus.
</p>
<p>
This model instantiates the FMU with the name <code>fmuName</code> and
connects to the thermal zone with name <code>zoneName</code>.
If the FMU is already instantiated by another instance of this model,
it will use the already instantiated FMU.
</p>
</html>"));
end ThermalZone;
