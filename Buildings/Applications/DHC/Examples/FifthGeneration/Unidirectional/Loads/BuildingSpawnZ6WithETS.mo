within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Loads;
model BuildingSpawnZ6WithETS
  "Model of a building (Spawn 6 zones) with an energy transfer station"
  extends BaseClasses.PartialBuildingWithETS(redeclare
      Buildings.Applications.DHC.Loads.Validation.BaseClasses.BuildingSpawnZ6Pump
      bui(idfPat=idfPat, weaPat=weaPat));
  parameter String idfPat=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf"
    "Path of the IDF file"
    annotation(Dialog(group="Building model parameters"));
  parameter String weaPat=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Path of the weather file"
    annotation(Dialog(group="Building model parameters"));
  annotation (Icon(graphics={
          Bitmap(extent={{-30,-10},{30,50}},     fileName="modelica://Buildings/Resources/Images/Experimental/EnergyPlus/EnergyPlusLogo.png")}));
end BuildingSpawnZ6WithETS;
