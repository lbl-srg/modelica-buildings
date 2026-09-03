within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating;
package SlabTemperatureSignal "Blocks that determine slab temperature setpoint and heating/cooling signal"




  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains the blocks that determine the slab setpoint as well as calls for radiant slab heating or cooling. This package includes three blocks: </p>
<ul>
<li> <a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal.DeadbandControl\">
Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal.DeadbandControl</a>: determines the slab heating or cooling signal based on the slab temperature error.</li>
<li> <a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal.Error\">
Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal.Error</a>: calculates the slab temperature error (i.e., slab temperature distance from setpoint) </li>
<li> <a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal.SlabSetpointPerimeter\">
Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal.SlabSetpointPerimeter</a>: determines the slab setpoint from the outdoor air temperature forecast high. </li>
</ul>
<p>
These blocks are used together in the <a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.ControlPlusLockouts\">
Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.ControlPlusLockouts</a> block to determine the slab setpoint and calls for heating and cooling.
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation.
</li>
</ul> 
</html>"));
end SlabTemperatureSignal;
