within Buildings.Experimental.DHC.Loads.Combined;
model BuildingTimeSeriesWithETSWithDHWTank
  "Model of a building with loads provided as time series, connected to an ETS with domestic hot water storage tank"
  extends BuildingTimeSeriesWithETS(
     redeclare
      Buildings.Experimental.DHC.EnergyTransferStations.Combined.HeatPumpHeatExchangerDHWTank
      ets(
      have_hotWat=true,
      QChiWat_flow_nominal=QCoo_flow_nominal,
      QHeaWat_flow_nominal=QHea_flow_nominal,
      QHotWat_flow_nominal=QHot_flow_nominal,
      datWatHea=datWatHea));
  parameter HotWater.Data.GenericDomesticHotWaterWithHeatExchanger datWatHea
    "Performance data"
    annotation (Placement(transformation(extent={{-250,232},{-230,252}})));
  annotation (Documentation(info="<html>
<p>
This model is the same as 
<a href=\"modelica://Buildings.Experimental.DHC.Loads.Combined.BuildingTimeSeriesWithETS\">
Buildings.Experimental.DHC.Loads.Combined.BuildingTimeSeriesWithETS</a>
except that it implements an ETS that uses a heat pump with hot water 
storage tank for production of domestic hot water.  That ETS model is
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.HeatPumpHeatExchangerDHWTank\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.HeatPumpHeatExchangerDHWTank</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 13, 2022, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingTimeSeriesWithETSWithDHWTank;
