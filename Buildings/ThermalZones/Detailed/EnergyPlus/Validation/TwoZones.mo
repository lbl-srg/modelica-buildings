within Buildings.ThermalZones.Detailed.EnergyPlus.Validation;
model TwoZones "Validation model for two zones"
  extends Modelica.Icons.Example;

  parameter String fmuName = "aaa.fmu" "Name of the FMU file that contains this zone";

  Modelica.Blocks.Sources.Ramp Q_flow(duration=1) "Heat flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  ThermalZone zon2(
    zoneName="Zone 2",
    nFluPor=4,
    fmuName="bld.fmu") "Zone 2"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  ThermalZone zon1(
    zoneName="Zone 1",
    nFluPor=2,
    fmuName="bld.fmu") "Zone 1"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
equation
  connect(Q_flow.y, zon1.Q_flow) annotation (Line(points={{-59,0},{-40,0},{-40,
          30},{-22,30}}, color={0,0,127}));
  connect(Q_flow.y, zon2.Q_flow)
    annotation (Line(points={{-59,0},{-22,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Simple test case for one buildings with two thermal zones.
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
      Tolerance=1e-05,
      __Dymola_Algorithm="Cvode"));
end TwoZones;
