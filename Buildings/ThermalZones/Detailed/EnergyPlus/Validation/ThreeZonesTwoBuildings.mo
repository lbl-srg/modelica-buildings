within Buildings.ThermalZones.Detailed.EnergyPlus.Validation;
model ThreeZonesTwoBuildings
  "Validation model for three zones that are in two buildings"
  extends Modelica.Icons.Example;

  parameter String fmuName = "aaa.fmu" "Name of the FMU file that contains this zone";
  ThermalZone zon1(
    nFluPor=2,
    fmuName="bld1.fmu",
    zoneName="Zone 1.1") "Zone 1"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.Ramp Q_flow(duration=1) "Heat flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  ThermalZone zon2(
    nFluPor=4,
    fmuName="bld1.fmu",
    zoneName="Zone 1.2") "Zone 2"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  ThermalZone zon3(
    fmuName="bld2.fmu",
    zoneName="Zone 2.1",
    nFluPor=6) "Zone 2"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

equation
  connect(Q_flow.y,zon1. Q_flow) annotation (Line(points={{-59,0},{-40,0},{-40,
          30},{-22,30}},
                     color={0,0,127}));
  connect(Q_flow.y,zon2. Q_flow) annotation (Line(points={{-59,0},{-22,0}},
                     color={0,0,127}));
  connect(zon3.Q_flow, Q_flow.y) annotation (Line(points={{-22,-30},{-40,-30},{
          -40,0},{-59,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Simple test case for two buildings with three thermal zones.
</p>
</html>", revisions="<html>
<ul><li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/EnergyPlus/Validation/TwoZones.mos"
        "Simulate and plot"),
 experiment(
      StopTime=86400,
      Tolerance=1e-06));
end ThreeZonesTwoBuildings;
