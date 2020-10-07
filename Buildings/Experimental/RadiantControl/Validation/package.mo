within Buildings.Experimental.RadiantControl;
package Validation "Validation for radiant control"

annotation (Documentation(info="<html>
  <p>
  This package contains three validation models for the radiant control module. 
  <li> The module, ControlPlusLockouts, determines heating and cooling control for a radiant slab.
   
  <li> The three validation models included in this package are as follows:
    <p>
   <li>1. ControlPlusLockout demonstrates radiant control based on 
  dummy inputs
   <li>2. ControlPlusLockoutPerimeter demonstrates radiant control for a simple perimeter room model
  <li> served by a radiant slab, with a simple hot water source, cold water source, and associated valves and pumps. 
 <li>3. ControlPlusLockoutPerimeter demonstrates radiant control for a simple core room model 
  <li> (i.e., no surfaces exposed to the outdoors)
  <li> served by a radiant slab, with a simple hot water source, cold water source, and associated valves and pumps.

</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated package description.<br/>
</li>
</html>"));
end Validation;
