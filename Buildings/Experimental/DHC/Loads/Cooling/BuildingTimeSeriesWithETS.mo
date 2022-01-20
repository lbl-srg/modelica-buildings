within Buildings.Experimental.DHC.Loads.Cooling;
model BuildingTimeSeriesWithETS
  "Model of a building with loads provided as time series, connected to an ETS for cooling"
  replaceable package Medium=Buildings.Media.Water
    "Medium model";
  extends BaseClasses.PartialBuildingWithETS(
    redeclare BaseClasses.BuildingTimeSeries bui(
      final filNam=filNam,
      facMulCoo=40*QCoo_flow_nominal/(-1.5E5),
      T_aChiWat_nominal=TChiWatSup_nominal,
      T_bChiWat_nominal=TChiWatRet_nominal),
    ets(
      redeclare package Medium = Medium,
      QChiWat_flow_nominal=QCoo_flow_nominal),
      m_flow_nominal=mBui_flow_nominal);
  parameter String filNam = "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissOffice_20190916.mos"
    "Library path of the file with thermal loads as time series";
  final parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design cooling heat flow rate (<=0)Nominal heat flow rate, negative";
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(min=0)=9
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=7 + 273.15
    "Chilled water supply temperature"
    annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=
    TChiWatSup_nominal + dT_nominal
    "Chilled water return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mBui_flow_nominal(
    final min=0,
    final start=0.5)=-QCoo_flow_nominal/(cp*dT_nominal)
    "Nominal mass flow rate of building cooling side"
    annotation (Dialog(group="Nominal condition"));
protected
  parameter Modelica.Units.SI.SpecificHeatCapacity cp=Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default))
    "Default specific heat capacity of medium";
  annotation (Documentation(info="<html>
<p>
This model is composed of a direct uncontrolled energy transfer station model for cooling
<a href=\"modelica://Buildings/Experimental/DHC/EnergyTransferStations/Cooling/DirectUncontrolled.mo\">
Buildings.Experimental.DHC.EnergyTransferStations.Cooling.DirectUncontrolled</a> 
connected to a simplified building model <a href=\"modelica://Buildings/Experimental/DHC/Loads/Cooling/BaseClasses/BuildingTimeSeries.mo\">
Buildings.Experimental.DHC.Loads.Cooling.BaseClasses.BuildingTimeSeries</a> 
where the space cooling loads are provided as time series. 
</p>
</html>", revisions="<html>
<ul>
<li>
January 1, 2022, by Chengnan Shi:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingTimeSeriesWithETS;
