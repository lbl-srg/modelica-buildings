within Buildings.Examples.ScalableBenchmarks.ZoneScaling.EnergyPlus;
model Large2Floors
  "Model of a large building with 2 floors and 10 conditioned zones"
  extends Modelica.Icons.Example;
  extends
    Buildings.Examples.ScalableBenchmarks.ZoneScaling.BaseClasses.HVACMultiFloorBuilding(
    numFlo=2,
    redeclare final Buildings.Examples.ScalableBenchmarks.ZoneScaling.EnergyPlus.BaseClasses.LargeOfficeFloor flo(floId=0:(numFlo - 1)),
    redeclare final Buildings.Examples.VAVReheat.BaseClasses.Guideline36 hvac);

protected
  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/Examples/ZoneScaling/" +
    "ScaledLargeOfficeNew2004_Chicago_" + String(numFlo) + "floors.idf")
    "Name of the IDF file";

  inner Buildings.ThermalZones.EnergyPlus.Building building(
    idfName=idfName,
    weaName=weaName,
    computeWetBulbTemperature=false)
    "Building-level declarations"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

    annotation (
experiment(
      StopTime=432000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Cvode"),
Documentation(revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Example model of a large office building with 10 thermal zones
that are supplied by 2 multizone VAV air handling units.<br/>
The thermal zones are modeled using
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.ThermalZone\">
Buildings.ThermalZones.EnergyPlus.ThermalZone</a> objects.
</p>
</html>"));
end Large2Floors;
