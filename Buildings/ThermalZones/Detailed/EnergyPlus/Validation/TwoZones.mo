within Buildings.ThermalZones.Detailed.EnergyPlus.Validation;
model TwoZones "Validation model for two zones"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  parameter String fmuName = "aaa.fmu" "Name of the FMU file that contains this zone";

  ThermalZone zon2(
    redeclare package Medium = Medium,
    zoneName="Zone 2",
    fmuName="bld.fmu") "Zone 2"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  ThermalZone zon1(
    redeclare package Medium = Medium,
    zoneName="Zone 1",
    fmuName="bld.fmu") "Zone 1"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
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
      Tolerance=1e-06));
end TwoZones;
