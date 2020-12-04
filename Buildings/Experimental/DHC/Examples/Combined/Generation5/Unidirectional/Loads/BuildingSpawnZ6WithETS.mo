within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Loads;
model BuildingSpawnZ6WithETS
  "Model of a building (Spawn 6 zones) with an energy transfer station"
  extends BaseClasses.PartialBuildingWithETS(
    redeclare DHC.Loads.Examples.BaseClasses.BuildingSpawnZ6 bui(
      final idfName=idfName, final weaName=weaName),
    ets(
      have_hotWat=false,
      QChiWat_flow_nominal=sum(bui.terUni.QCoo_flow_nominal),
      QHeaWat_flow_nominal=sum(bui.terUni.QHea_flow_nominal)));
  parameter String idfName=
    "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.idf"
    "Name of the IDF file"
    annotation(Dialog(group="Building model parameters"));
  parameter String weaName=
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Name of the weather file"
    annotation(Dialog(group="Building model parameters"));
  annotation (Icon(graphics={
          Bitmap(extent={{-72,-62},{62,74}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/EnergyPlusLogo.png")}));
end BuildingSpawnZ6WithETS;
