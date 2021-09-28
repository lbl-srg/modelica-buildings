within Buildings.Experimental.RadiantControl;
package SlabTemperatureSignal "Blocks that determine slab temperature setpoint and heating/cooling signal"




  annotation (preferredView="info", Documentation(info="<html>

This package contains the blocks that determine the slab setpoint as well as calls for radiant slab heating or cooling.
<li> This package includes three blocks: 
<li> 1. DeadbandControl: determines the slab heating or cooling signal based on the slab temperature error.
<li> 2. Error: calculates the slab temperature error (i.e., slab temperature distance from setpoint)
<li> 3. SlabSetpointPerimeter:: determines the slab setpoint from the outdoor air temperature forecast high. 
<li> These blocks are used together in the ControlPlusLockouts block (<a href=\"modelica://Buildings.Experimental.RadiantControl.ControlPlusLockouts\">
Buildings.Experimental.RadiantControl.ControlPlusLockouts</a>)
<li> to determine the slab setpoint and calls for heating & cooling. 
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
