within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Agents;
model SpawnBuildingWithETS
  "Model of a building (Spawn) with an energy transfer station"
  extends Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Agents.BaseClasses.PartialBuildingWithETS(
    redeclare Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui(
      nZon=nZon,
      idfPath=idfPath,
      weaPath=weaPath));
  parameter String idfPath=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf"
    "Path of the IDF file"
    annotation(Dialog(group="Building model parameters"));
  parameter String weaPath=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Path of the weather file"
    annotation(Dialog(group="Building model parameters"));
  parameter Integer nZon = 6
    "Number of thermal zones"
    annotation(Dialog(group="Building model parameters"), Evaluate=true);

end SpawnBuildingWithETS;
