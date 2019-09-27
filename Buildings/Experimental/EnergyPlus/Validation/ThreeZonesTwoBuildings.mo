within Buildings.Experimental.EnergyPlus.Validation;
model ThreeZonesTwoBuildings
  "Validation model for three zones that are in two buildings"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  model OneZoneBuilding "Model with a building with one zone"
    extends Buildings.Experimental.EnergyPlus.Validation.OneZone;
    extends Modelica.Blocks.Icons.Block;
  end OneZoneBuilding;

  model TwoZoneBuilding "Model with a building with two zones"
    extends Buildings.Experimental.EnergyPlus.Validation.TwoIdenticalZones;
    extends Modelica.Blocks.Icons.Block;
  end TwoZoneBuilding;

  OneZoneBuilding zon1 "Building with one thermal zone"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  TwoZoneBuilding zon2 "Building with two thermal zones"
    annotation (Placement(transformation(extent={{-12,-40},{8,-20}})));
  annotation (Documentation(info="<html>
<p>
Simple test case for two buildings, one having one and the other having two thermal zones.
All thermal zones are free floating.
</p>
</html>", revisions="<html>
<ul><li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/Validation/ThreeZonesTwoBuildings.mos"
        "Simulate and plot"),
 experiment(
      StopTime=86400,
      Tolerance=1e-06));
end ThreeZonesTwoBuildings;
