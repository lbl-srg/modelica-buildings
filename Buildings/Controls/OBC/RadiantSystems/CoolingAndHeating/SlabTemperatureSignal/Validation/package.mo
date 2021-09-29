within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal;
package Validation "Validation models for slab temperature blocks"




  annotation (preferredView="info", Documentation(info="<html>

This package contains validation models blocks that determine the slab setpoint as well as calls for radiant slab heating or cooling.
<li> This package includes three models that validate the three blocks: 
<li> 1. DeadbandControl: determines the slab heating or cooling signal based on the slab temperature error.
<li> 2. Error: calculates the slab temperature error (i.e., slab temperature distance from setpoint)
<li> 3. SlabSetpointPerimeter:: determines the slab setpoint from the outdoor air temperature forecast high. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation.
</li>
</ul>
</html>"));
end Validation;
