within Buildings.Experimental.DHC.Loads.Combined;
model BuildingTimeSeriesWithETSWithDHWTank
  extends BuildingTimeSeriesWithETS(
     redeclare
      Buildings.Experimental.DHC.EnergyTransferStations.Combined.HeatPumpHeatExchangerDHWTank
      ets(
      have_hotWat=true,
      QChiWat_flow_nominal=QCoo_flow_nominal,
      QHeaWat_flow_nominal=QHea_flow_nominal,
      QHotWat_flow_nominal=QHot_flow_nominal,
      datWatHea=datWatHea));
  parameter HotWater.Data.GenericHeatPumpWaterHeater datWatHea
    "Performance data"
    annotation (Placement(transformation(extent={{-246,244},{-234,256}})));
end BuildingTimeSeriesWithETSWithDHWTank;
