within Buildings.Examples.ScalableBenchmarks.ZoneScaling.MixedAir;
model LargeBuilding
  "Model of a large building with MixedAir zone models"
  extends Modelica.Icons.Example;
  extends
    Buildings.Examples.ScalableBenchmarks.ZoneScaling.BaseClasses.HVACMultiFloorBuilding(
    bldgSize=Buildings.Examples.ScalableBenchmarks.ZoneScaling.BaseClasses.Types.BuildingSize.TwoFloors,
    redeclare final Buildings.Examples.ScalableBenchmarks.ZoneScaling.MixedAir.BaseClasses.LargeOfficeFloor flo(
      each sampleModel=true),
    redeclare final Buildings.Examples.VAVReheat.BaseClasses.Guideline36 hvac);

    annotation (
experiment(
      StopTime=432000,
      Tolerance=1e-05),
Documentation(info="<html>
<p>
Example model of a large office building with 10 thermal zones
that are supplied by 2 multizone VAV air handling units.<br/>
The thermal zones are modeled using
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a> objects.
</p>
</html>", revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end LargeBuilding;
