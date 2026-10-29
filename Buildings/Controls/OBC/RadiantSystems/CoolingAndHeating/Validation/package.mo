within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating;
package Validation "Validation for radiant control"
annotation (Documentation(info="<html>
  <p>
  This package contains three validation models for the radiant control module. </p>
  <p>The module, Controls.OBC.RadiantSystems.CoolingAndHeating.ControlPlusLockouts, determines heating and cooling control for a radiant slab.</p>
   
   <p> The three validation models included in this package are as follows:</p>
   <ul>
   <li>1. ControlPlusLockout demonstrates radiant control based on example inputs</li>
   <li>2. ControlPlusLockoutPerimeter demonstrates radiant control for a simple perimeter room model served by a radiant slab, 
   with a simple hot water source, cold water source, and associated valves and pumps. </li>
   <li>3. ControlPlusLockoutPerimeter demonstrates radiant control for a simple core room model 
   (i.e., no surfaces exposed to the outdoors) served by a radiant slab, 
   with a simple hot water source, cold water source, and associated valves and pumps.</li>
   </ul>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation.
</li>
</ul>
</html>"));
end Validation;
