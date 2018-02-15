within Buildings.ThermalZones.Detailed.EnergyPlus.Validation;
model TwoZones "Validation model for two zones"
  extends Modelica.Icons.Example;

  parameter String fmuName = "aaa.fmu" "Name of the FMU file that contains this zone";

  ThermalZone zon1(
    zoneName="Zone 1",
    nFluPor=2) "Zone 1"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  EnergyPlusAdapter energyPlusAdapter "Adapter to EnergyPlus"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Modelica.Blocks.Sources.Ramp Q_flow(duration=1) "Heat flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  ThermalZone zon2(
    zoneName="Zone 2",
    nFluPor=4) "Zone 2"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
equation
  connect(Q_flow.y, zon1.Q_flow) annotation (Line(points={{-59,0},{-40,0},{-40,30},
          {-22,30}}, color={0,0,127}));
  connect(Q_flow.y,zon2. Q_flow) annotation (Line(points={{-59,0},{-22,0}},
                     color={0,0,127}));
end TwoZones;
