within Buildings.DHC.Loads.Heating;
model BuildingTimeSeriesWithETS
  "Model of a building with loads provided as time series, connected to an ETS for heating"
  extends BaseClasses.PartialBuildingWithETS(
    redeclare Buildings.DHC.Loads.BaseClasses.Examples.BaseClasses.BuildingTimeSeries bui(
      final have_heaWat=true,
      final have_chiWat=false,
      final have_hotWat=false,
      final filNam=filNam,
      T_aHeaWat_nominal=THeaWatSup_nominal,
      T_bHeaWat_nominal=THeaWatRet_nominal),
      mBui_flow_nominal=QHea_flow_nominal/(cp*dT_nominal),
          ets(
      QHeaWat_flow_nominal=QHea_flow_nominal));

  final parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=
    bui.facMul * bui.QHea_flow_nominal
    "Space heating design load (>=0)";
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(min=0)=10
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=50 + 273.15
    "Heating water supply temperature"
    annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.Units.SI.Temperature THeaWatRet_nominal=
    THeaWatSup_nominal - dT_nominal
    "Heating water return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Boolean use_inputFilter=false
    "= true, if pump speed is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Pump"));
  parameter String filNam
    "Library path of the file with thermal loads as time series";
protected
  parameter Modelica.Units.SI.SpecificHeatCapacity cp=MediumSer.specificHeatCapacityCp(
    MediumSer.setState_pTX(
      MediumSer.p_default,
      MediumSer.T_default,
      MediumSer.X_default))
    "Default specific heat capacity of medium";
  annotation (
  defaultComponentName="loa",
  Documentation(info="<html>
<p>
This model is composed of a direct controlled energy transfer station model for heating
<a href=\"modelica://Buildings/Experimental/DHC/EnergyTransferStations/Heating/Direct.mo\">
Buildings.DHC.EnergyTransferStations.Heating.Direct</a>
connected to a simplified building model <a href=\"modelica://Buildings/Experimental/DHC/Loads/Heating/BaseClasses/BuildingTimeSeries.mo\">
Buildings.DHC.Loads.Heating.BaseClasses.BuildingTimeSeries</a>
where the space heating loads are provided as time series.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2023, by Michael Wetter:<br/>
Removed unused parameter <code>riseTime</code>.
</li>
<li>
January 2, 2023, by Kathryn Hinkelman:<br/>
Propagated energy dynamics and a filter for the (variable) secondary pumps.
</li>
<li>
December 23, 2022, by Kathryn Hinkelman:<br>
Revised ETS from direct uncontrolled to direct controlled.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2912\">#2912</a>.
</li>
<li>
December 21, 2022 by Kathryn Hinkelman:<br>
Removed in-building pumping because of coupling with the direct/uncontrolled ETS.<br>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2912\">#2912</a>.
</li>
</ul>
<ul>
<li>March 20, 2022 by Chengnan Shi:<br>First implementation. </li>
</ul>
</html>"));
end BuildingTimeSeriesWithETS;
