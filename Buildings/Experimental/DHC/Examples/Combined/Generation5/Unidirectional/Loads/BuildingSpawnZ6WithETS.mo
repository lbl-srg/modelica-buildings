within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Loads;
model BuildingSpawnZ6WithETS
  "Model of a building (Spawn 6 zones) with an energy transfer station"
  extends BaseClasses.PartialBuildingWithETS(
    redeclare DHC.Loads.Examples.BaseClasses.BuildingSpawnZ6 bui(
      final idfName=idfName, final weaName=weaName),
    ets(
      have_hotWat=false,
      QChiWat_flow_nominal=sum(bui.terUni.QCoo_flow_nominal),
      QHeaWat_flow_nominal=sum(bui.terUni.QHea_flow_nominal)),
    reqHeaCoo(y={bui.disFloHea.mReqTot_flow,bui.disFloCoo.mReqTot_flow}),
    enaHeaCoo(t=1e-4 .* {ets.mHeaWat_flow_nominal,ets.mChiWat_flow_nominal}));
  parameter String idfName=
    "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.idf"
    "Name of the IDF file"
    annotation(Dialog(group="Building model parameters"));
  parameter String weaName=
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Name of the weather file"
    annotation(Dialog(group="Building model parameters"));
equation
  connect(enaHeaCoo[1].y, ets.uHea) annotation (Line(points={{-58,-100},{-48,
          -100},{-48,-46},{-34,-46}}, color={255,0,255}));
  connect(enaHeaCoo[2].y, ets.uCoo) annotation (Line(points={{-58,-100},{-44,
          -100},{-44,-50},{-34,-50}}, color={255,0,255}));
  annotation (Icon(graphics={
          Bitmap(extent={{-72,-62},{62,74}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/EnergyPlusLogo.png")}));
end BuildingSpawnZ6WithETS;
