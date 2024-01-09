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
templates and/or for generating custom system models.  Generally, the 
models are capable of representing any generation of DHC (1st-5th), 
though template models are not specifically available for all system types.  
</p>
<p>
The structure of the package is such that it decomposes a DHC into four 
primary sub-systems each with their own sub-packages 
as described in the Table below: 
Energy Transfer Stations, Loads, Networks, and Plants.  
In addition to these sub-packages, the sub-package 
<a href=\"modelica://Buildings.Experimental.DHC.Examples\">
Buildings.Experimental.DHC.Examples</a>
contains system level models which may be used as examples or templates.
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Sub-Package</th>
<th>Description</th>
</tr>
<tr>
  <td><a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations\">
      Buildings.Experimental.DHC.EnergyTransferStations</a></td>
  <td>Connection point between a building and district network which contain 
      physical components such as heat exchangers, heat pumps, pipes, valves, 
      sensors, and pumps, as well as control logic based on flow, 
      temperature, and/or pressure measurements.</td>
</tr>
<tr>
  <td><a href=\"modelica://Buildings.Experimental.DHC.Loads\">
      Buildings.Experimental.DHC.Loads</a></td>
  <td>Timeseries or physics-based representation of space heating and cooling 
      as well as domestic hot water loads in buildings.</td>
</tr>
<tr>
  <td><a href=\"modelica://Buildings.Experimental.DHC.Networks\">
      Buildings.Experimental.DHC.Networks</a></td>
  <td>Distribution system between buildings and plants which contains 
      long-distance pipes, ground-heat exchange, and service lines to the 
      energy transfer stations.</td>
</tr>
<tr>
  <td><a href=\"modelica://Buildings.Experimental.DHC.Plants\">
      Buildings.Experimental.DHC.Plants</a></td>
  <td>Sources of cooling or heating for the DHC including boilers, chillers, 
      heat pumps, waste heat, tank storage, and geothermal storage. </td>
</tr>
</table>
<p>
The Figure below further illustrates the abstract relationship between the 
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
help a user navigate.  However, refer to the specific 
documentation of the model and subpackages for further modeling and implementation
details.
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
    <a href=\"modelica://Buildings.Experimental.DHC.Loads\">
    Buildings.Experimental.DHC.Loads</a>
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"2\">Combined
    </td>
    <td valign=\"top\">BuildingTimeSeriesWithETS
    </td>
    <td valign=\"top\">Model of a building with loads provided as time series, connected to an ETS.
    </td>
</tr>
<tr><td valign=\"top\">BuildingTimeSeriesWithETSWithDHWTank
    </td>
    <td valign=\"top\">Model of a building with loads provided as time series, connected to an ETS with domestic hot water storage tank.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Cooling
    </td>
    <td valign=\"top\">BuildingTimeSeriesWithETS
    </td>
    <td valign=\"top\">Model of a building with loads provided as time series, connected to an ETS for cooling.
    </td>
</tr>       
<tr><td valign=\"top\" rowspan=\"1\">Heating
    </td>
    <td valign=\"top\">BuildingTimeSeriesWithETS
    </td>
    <td valign=\"top\">Model of a building with loads provided as time series, connected to an ETS for heating.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"3\">HotWater
    </td>
    <td valign=\"top\">DirectHeatExchangerWithElectricHeat
    </td>
    <td valign=\"top\">A model for generating hot water using a district heat exchanger and supplemental electric resistance.
    </td>
</tr>
<tr><td valign=\"top\">StorageTankWithExternalHeatExchanger
    </td>
    <td valign=\"top\">A model of a storage tank with external heat exchanger to produce hot water.
    </td>
</tr>
<tr><td valign=\"top\">ThermostaticMixingValve
    </td>
    <td valign=\"top\">A model for a thermostatic mixing valve.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Steam
    </td>
    <td valign=\"top\">BuildingTimeSeriesAtETS
    </td>
    <td valign=\"top\">Steam heating building interconnection with the district piping only and the load at the ETS provided as a time series.
    </td>
</tr>

<tr><td colspan=\"3\">
    <a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations\">
    Buildings.Experimental.DHC.EnergyTransferStations</a>
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"3\">Combined
    </td>
    <td valign=\"top\">ChillerBorefield
    </td>
    <td valign=\"top\">ETS model for 5GDHC systems with heat recovery chiller and optional borefield.
    </td>
</tr>
<tr><td valign=\"top\">HeatPumpHeatExchanger
    </td>
    <td valign=\"top\">Model of a substation with heat pump for heating, heat pump for domestic hot water, and compressor-less cooling.
    </td>
</tr>
<tr><td valign=\"top\">HeatPumpHeatExchangerDHWTank
    </td>
    <td valign=\"top\">Model of a substation with heat pump for heating, heat pump with storage tank for domestic hot water, and compressor-less cooling.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"2\">Cooling
    </td>
    <td valign=\"top\">Direct
    </td>
    <td valign=\"top\">Direct cooling ETS model for district energy systems with in-building pumping and deltaT control.
    </td>
</tr>
<tr><td valign=\"top\">Indirect
    </td>
    <td valign=\"top\">Indirect cooling energy transfer station for district energy systems.
    </td>
</tr>    
<tr><td valign=\"top\" rowspan=\"2\">Heating
    </td>
    <td valign=\"top\">Direct
    </td>
    <td valign=\"top\">Direct heating ETS model for district energy systems with in-building pumping and deltaT control.
    </td>
</tr>
<tr><td valign=\"top\">Indirect
    </td>
    <td valign=\"top\">Indirect heating energy transfer station for district energy systems.
    </td>
</tr>

<tr><td colspan=\"3\">
    <a href=\"modelica://Buildings.Experimental.DHC.Networks\">
    Buildings.Experimental.DHC.Networks</a>
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"2\">xxxx
    </td>
    <td valign=\"top\">xxxx
    </td>
    <td valign=\"top\">This is a description.
    </td>
</tr>
<tr><td valign=\"top\">xxxx
    </td>
    <td valign=\"top\">This is a description.
    </td>
</tr>        
    
<tr><td colspan=\"3\">
    <a href=\"modelica://Buildings.Experimental.DHC.Plants\">
    Buildings.Experimental.DHC.Plants</a>
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Combined
    </td>
    <td valign=\"top\">AllElectricCWStorage
    </td>
    <td valign=\"top\">All-electric CHW and HW plant with CW storage.
    </td>
</tr>     
<tr><td valign=\"top\" rowspan=\"2\">Cooling
    </td>
    <td valign=\"top\">ElectricChillerParallel
    </td>
    <td valign=\"top\">District cooling plant model.
    </td>
</tr>
<tr><td valign=\"top\">StoragePlant
    </td>
    <td valign=\"top\">Model of a storage plant with a chiller and a CHW tank.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Heating
    </td>
    <td valign=\"top\">SewageHeatRecovery
    </td>
    <td valign=\"top\">Model for sewage heat recovery plant.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Steam
    </td>
    <td valign=\"top\">SingleBoiler
    </td>
    <td valign=\"top\">A generic steam plant with a single boiler that discharges saturated steam.
    </td>
</tr>

<tr><td colspan=\"3\">
    <a href=\"modelica://Buildings.Experimental.DHC.Examples\">
    Buildings.Experimental.DHC.Examples</a>
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"2\">Combined
    </td>
    <td valign=\"top\">SeriesConstantFlow
    </td>
    <td valign=\"top\">Example of series connection with constant district water mass flow rate.
    </td>
</tr>
<tr><td valign=\"top\">SeriesVariableFlow
    </td>
    <td valign=\"top\">Example of series connection with variable district water mass flow rate.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Cooling
    </td>
    <td valign=\"top\">ElectricChillersDirectETS
    </td>
    <td valign=\"top\">Example model for district cooling system with an electric chiller plant and a direct controlled ETS at each building.
    </td>
</tr>
<tr><td valign=\"top\" rowspan=\"1\">Steam
    </td>
    <td valign=\"top\">SingleBoiler
    </td>
    <td valign=\"top\">Example model for a complete steam district heating system with a central plant that contains a single boiler.
    </td>
</tr>

</table>
    
</html>"));
end UsersGuide;
