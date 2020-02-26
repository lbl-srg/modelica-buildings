within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Loads;
model BuildingSpawnZ6WithETS
  "Model of a building (Spawn 6 zones) with an energy transfer station"
  extends BaseClasses.PartialBuildingWithETS(redeclare
    Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingSpawnZ6
    bui(idfPat=idfPat, weaPat=weaPat),
    ets(
      QCoo_flow_nominal=sum(bui.terUni.QCoo_flow_nominal),
      QHea_flow_nominal=sum(bui.terUni.QHea_flow_nominal)));
  parameter String idfPat=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf"
    "Library path of the IDF file"
    annotation(Dialog(group="Building model parameters"));
  parameter String weaPat=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Path of the weather file"
    annotation(Dialog(group="Building model parameters"));
  annotation (Icon(graphics={
          Bitmap(extent={{-72,-62},{62,74}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/EnergyPlusLogo.png")}));
end BuildingSpawnZ6WithETS;
