within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Loads;
model BuildingRCZ1WithETS
  "Model of a building (RC 1 zone) with an energy transfer station"
  extends BaseClasses.PartialBuildingWithETS(
    redeclare DHC.Loads.Examples.BaseClasses.BuildingRCZ1Valve bui,
    redeclare EnergyTransferStations.ETSSimplified ets(
      final dT_nominal=dT_nominal,
      final TChiWatSup_nominal=TChiWatSup_nominal,
      final TChiWatRet_nominal=TChiWatRet_nominal,
      final THeaWatSup_nominal=THeaWatSup_nominal,
      final THeaWatRet_nominal=THeaWatRet_nominal,
      final dp_nominal=dp_nominal,
      final COP_nominal=COP_nominal,
      final QChiWat_flow_nominal=sum(bui.terUni.QCoo_flow_nominal),
      final QHeaWat_flow_nominal=sum(bui.terUni.QHea_flow_nominal)));
  BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(
    transformation(extent={{-18,84},{16,116}}),
    iconTransformation(extent={{-18,84},{16,116}})));
equation
  connect(weaBus, bui.weaBus)
  annotation (Line(
      points={{-1,100},{-1.7,100},{-1.7,102.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
end BuildingRCZ1WithETS;
