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
primary sub-systems each with an associated sub-package as described in the 
table below: Energy Transfer Stations, Loads, Networks, and Plants.  
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

</html>"));
end UsersGuide;
