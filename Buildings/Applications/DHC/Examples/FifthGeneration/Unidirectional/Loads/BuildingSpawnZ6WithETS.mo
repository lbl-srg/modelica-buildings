within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Loads;
model BuildingSpawnZ6WithETS
  "Model of a building (Spawn 6 zones) with an energy transfer station"
  extends BaseClasses.PartialBuildingWithETS(
    redeclare DHC.Loads.Examples.BaseClasses.BuildingSpawnZ6 bui(
      final idfPat=idfPat, final weaPat=weaPat));
  parameter String idfPat=
    "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/RefBldgSmallOfficeNew2004_Chicago.idf"
    "Library path of the IDF file"
    annotation(Dialog(group="Building model parameters"));
  parameter String weaPat=
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Path of the weather file"
    annotation(Dialog(group="Building model parameters"));
  annotation (Icon(graphics={
          Bitmap(extent={{-72,-62},{62,74}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/EnergyPlusLogo.png")}));
end BuildingSpawnZ6WithETS;
