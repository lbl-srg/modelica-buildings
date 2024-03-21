within Buildings.Experimental.DHC;
package UsersGuide
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<h4>Overview</h4>
<p>
The package <code>Buildings.Experimental.DHC</code> consists of models
for district heating and cooling (DHC) systems. The package contains models
at the component, sub-system, and system level, which can be used as
templates or for generating custom system models. Generally, the
model structures are capable of representing any generation of DHC (1st-5th),
though template models are not specifically available for all system types
and combinations of technology. Note also that some components typically
seen in district networks have been implemented elsewhere in the
library (e.g. <a href=\"modelica://Buildings.Fluid.Geothermal\">geothermal storage</a>).
</p>
<p>
The structure of the package is such that it decomposes a DHC into four
primary sub-systems each with their own sub-packages
as described in the table below:
Energy Transfer Stations (ETS), Loads, Networks, and Plants.
In addition to these sub-packages, the sub-package
<a href=\"modelica://Buildings.Experimental.DHC.Examples\">
Buildings.Experimental.DHC.Examples</a>
contains system models which may be used as examples or templates.
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Sub-Package</th>
<th>Description</th>
</tr>
<tr>
  <td><a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations\">
      Buildings.Experimental.DHC.EnergyTransferStations</a></td>
  <td>Connection point between a building and district network which contains
      physical components such as heat exchangers, heat pumps, pipes, valves,
      sensors, and pumps, as well as control logic based on flow rate,
      temperature, and/or pressure measurements.</td>
</tr>
<tr>
  <td><a href=\"modelica://Buildings.Experimental.DHC.Loads\">
      Buildings.Experimental.DHC.Loads</a></td>
  <td>Timeseries or physics-based representation of space heating and cooling
      and domestic hot water loads in buildings, and connected to an ETS.</td>
</tr>
<tr>
  <td><a href=\"modelica://Buildings.Experimental.DHC.Networks\">
      Buildings.Experimental.DHC.Networks</a></td>
  <td>Distribution system between buildings and plants which contains
      distribution pipes and service lines to the
      energy transfer stations.</td>
</tr>
<tr>
  <td><a href=\"modelica://Buildings.Experimental.DHC.Plants\">
      Buildings.Experimental.DHC.Plants</a>
  </td>
  <td>Sources of cooling or heating for the DHC such as boilers, chillers,
      heat pumps, waste heat, tank storage, and geothermal storage.
  </td>
</tr>
</table>
<p>
The figure below further illustrates the abstract relationship between the
sub-systems and offers concrete example systems which can be modeled
with concrete implementation of the abstractions.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Experimental/DHC/UserGuide/DHC_Package_Concept.png\"/>
</p>

<p>
Further sub-packages divide the application of each model based on the
terms in the table below:
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Further Sub-Package</th>
<th>Description</th>
</tr>
<tr>
  <td>Combined</td>
  <td>Water-based heating and cooling</td>
</tr>
<tr>
  <td>Cooling</td>
  <td>Water-based cooling only</td>
</tr>
<tr>
  <td>Heating</td>
  <td>Water-based heating only</td>
</tr>
<tr>
  <td>HotWater</td>
  <td>Domestic hot water</td>
</tr>
<tr>
  <td>Steam</td>
  <td>Steam-based heating only</td>
</tr>
</table>

<h4>Content Summary</h4>

<p>
This section provides a summary of the models available in the package to
help a user navigate. However, refer to the specific
documentation of the model and subpackages for further modeling and implementation details.
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td valign=\"top\"><b>Sub-Package Name</b>
    </td>
    <td valign=\"top\"><b>Model Name</b>
    </td>
    <td valign=\"top\"><b>Model Description</b>
    </td>
</tr>
<tr><td colspan=\"3\">
    <a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations\">
    Buildings.Experimental.DHC.EnergyTransferStations</a>
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"3\">Combined
    </td>
    <td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.ChillerBorefield\">ChillerBorefield</a>
    </td>
    <td valign=\"top\">ETS with heat recovery chiller and optional borefield.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.HeatPumpHeatExchanger\">HeatPumpHeatExchanger</a>
    </td>
    <td valign=\"top\">ETS with heat pump for heating, heat pump for domestic hot water, and compressor-less cooling by heat exchanger.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.HeatPumpHeatExchangerDHWTank\">
    HeatPumpHeatExchangerDHWTank</a>
    </td>
    <td valign=\"top\">
    ETS with heat pump for heating, heat pump with storage tank and heat exchanger for domestic hot water, and
    compressor-less cooling by heat exchanger.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"2\">Cooling
    </td>
    <td valign=\"top\"><a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Cooling.Direct\">Direct</a>
    </td>
    <td valign=\"top\">ETS with direct connection and district return water temperature control. In-building pumping not modeled.
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Cooling.Indirect\">Indirect</a>
    </td>
    <td valign=\"top\">ETS with indirect connection with heat exchanger and building supply water temperature control.
    In-building pumping not modeled.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"2\">Heating
    </td>
    <td valign=\"top\"><a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Heating.Direct\">Direct</a>
    </td>
    <td valign=\"top\">ETS with direct connection and district return water temperature control. In-building pumping not modeled.
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Heating.Indirect\">Indirect</a>
    </td>
    <td valign=\"top\">ETS with indirect connection with heat exchanger and building supply water temperature control.
    In-building pumping not modeled.
    </td>
</tr>

<tr><td colspan=\"3\">
    <a href=\"modelica://Buildings.Experimental.DHC.Loads\">
    Buildings.Experimental.DHC.Loads</a>
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"2\">Combined
    </td>
    <td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Loads.Combined.BuildingTimeSeriesWithETS\">BuildingTimeSeriesWithETS</a>
    </td>
    <td valign=\"top\">
    Building with loads provided as time series, connected to an ETS with heat pump for space heating, heat pump for domestic hot water,
    and a heat exchanger for cooling water.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Loads.Combined.BuildingTimeSeriesWithETSWithDHWTank\">
    BuildingTimeSeriesWithETSWithDHWTank</a>
    </td>
    <td valign=\"top\">
    Building with loads provided as time series, connected to an ETS with heat pump for space heating,
    heat pump with storage tank and heat exchanger for domestic hot water, and a heat exchanger for cooling water.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Cooling
    </td>
    <td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Loads.Cooling.BuildingTimeSeriesWithETS\">BuildingTimeSeriesWithETS</a>
    </td>
    <td valign=\"top\">
    Building with loads provided as time series, connected to an ETS with direct connection for chilled water supply to the building.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Heating
    </td>
    <td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Loads.Heating.BuildingTimeSeriesWithETS\">BuildingTimeSeriesWithETS</a>
    </td>
    <td valign=\"top\">
    Building with loads provided as time series, connected to an ETS with direct connection for heating water supply to the building.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"3\">HotWater
    </td>
    <td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Loads.HotWater.DirectHeatExchangerWithElectricHeat\">
    DirectHeatExchangerWithElectricHeat</a>
    </td>
    <td valign=\"top\">
    A model for generating hot water using a district heat exchanger and supplemental electric resistance.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Loads.HotWater.StorageTankWithExternalHeatExchanger\">
    StorageTankWithExternalHeatExchanger</a>
    </td>
    <td valign=\"top\">
    A model of a storage tank with external heat exchanger to produce hot water.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Loads.HotWater.ThermostaticMixingValve\">ThermostaticMixingValve</a>
    </td>
    <td valign=\"top\">A model for a thermostatic mixing valve.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Steam
    </td>
    <td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Loads.Steam.BuildingTimeSeriesAtETS\">BuildingTimeSeriesAtETS</a>
    </td>
    <td valign=\"top\">
    Steam heating building interconnection with the district piping only and the load at the ETS provided as a time series.
    </td>
</tr>

<tr><td colspan=\"3\">
    <a href=\"modelica://Buildings.Experimental.DHC.Networks\">
    Buildings.Experimental.DHC.Networks</a>
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"4\">
    </td>
    <td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Networks.Distribution1PipePlugFlow_v\">Distribution1PipePlugFlow_v</a>
    </td>
    <td valign=\"top\">
    1-Pipe distribution network with fluid heat transfer modeled in the main lines between ETS determined by external model (e.g. ground) and flow friction by nominal velocity.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Networks.Distribution1Pipe_R\">Distribution1Pipe_R</a>
    </td>
    <td valign=\"top\">
    1-Pipe distribution network with flow friction modeled in the main lines between ETS determined by pressure drop per length.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Networks.Distribution2PipePlugFlow_v\">Distribution2PipePlugFlow_v</a>
    </td>
    <td valign=\"top\">
    2-Pipe distribution network with fluid heat transfer modeled in the main lines between ETS determined by external model (e.g. ground) and flow friction by nominal velocity.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Networks.Distribution2Pipe_R\">Distribution2Pipe_R</a>
    </td>
    <td valign=\"top\">
    2-Pipe distribution network with flow friction modeled in the main lines between ETS determined by pressure drop per length.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Steam
    </td>
    <td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Networks.Steam.DistributionCondensatePipe\">DistributionCondensatePipe</a>
    </td>
    <td valign=\"top\">
    2-Pipe distribution network with steam supply and condensate return using a fixed resistance pipe model for condensate returns.
    </td>
</tr>

<tr><td colspan=\"3\">
    <a href=\"modelica://Buildings.Experimental.DHC.Plants\">
    Buildings.Experimental.DHC.Plants</a>
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Combined
    </td>
    <td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Plants.Combined.AllElectricCWStorage\">AllElectricCWStorage</a>
    </td>
    <td valign=\"top\">
    All-electric chilled water and heating water production plant with heat recovery chillers and condenser water storage.
    </td>
</tr>     
<tr><td valign=\"top\" rowspan=\"2\">Cooling
    </td>
    <td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Plants.Cooling.ElectricChillerParallel\">ElectricChillerParallel</a>
    </td>
    <td valign=\"top\">Chilled water production plant with parallel chillers and parallel cooling towers.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Plants.Cooling.StoragePlant\">StoragePlant</a>
    </td>
    <td valign=\"top\">
    Chilled water storage tank system which can be charged by local chiller or remotely from district.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Heating
    </td>
    <td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Plants.Heating.SewageHeatRecovery\">SewageHeatRecovery</a>
    </td>
    <td valign=\"top\">Heating water production plant using sewage heat recovery.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Steam
    </td>
    <td valign=\"top\"><a href=\"modelica://Buildings.Experimental.DHC.Plants.Steam.SingleBoiler\">SingleBoiler</a>
    </td>
    <td valign=\"top\">Steam plant with a single boiler that discharges saturated steam.
    </td>
</tr>

<tr><td colspan=\"3\">
    <a href=\"modelica://Buildings.Experimental.DHC.Examples\">
    Buildings.Experimental.DHC.Examples</a>
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"3\">Combined
    </td>
    <td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Examples.Combined.SeriesConstantFlow\">SeriesConstantFlow</a>
    </td>
    <td valign=\"top\">Example of ambient network, so-called <i>Reservoir Network</i>, with constant district water mass flow rate.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Examples.Combined.SeriesVariableFlow\">SeriesVariableFlow</a>
    </td>
    <td valign=\"top\">Example of ambient network, so-called <i>Reservoir Network</i>, with variable district water mass flow rate.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Examples.Combined.SeriesVariableFlowAgentControl\">SeriesVariableFlowAgentControl</a>
    </td>
    <td valign=\"top\">Example of ambient network, so-called <i>Reservoir Network</i>,
    with variable district water mass flow rate with updated agent controller.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Cooling
    </td>
    <td valign=\"top\">
    <a href=\"modelica://Buildings.Experimental.DHC.Examples.Cooling.ElectricChillersDirectETS\">ElectricChillersDirectETS</a>
    </td>
    <td valign=\"top\">
    Example model for district cooling system with an electric chiller plant and a direct controlled ETS at each building.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Steam
    </td>
    <td valign=\"top\"><a href=\"modelica://Buildings.Experimental.DHC.Examples.Steam.SingleBoiler\">SingleBoiler</a>
    </td>
    <td valign=\"top\">
    Example model for a steam district heating system with a central plant boiler producing steam that is distributed to each building.
    </td>
</tr>

</table>

</html>"));
end UsersGuide;
