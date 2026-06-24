within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating;
package Lockouts "Blocks to lock out radiant slab"
 annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains the radiant slab lockout control blocks, which indicate when heating or cooling of the radiant slab is locked out. 
This includes a single block, which combines all lockouts, and a sublockouts package, which includes each individual lockout on its own. 
</p>
<p>
Lockouts are due to out-of-range room air temperature (for heating or cooling), hysteresis (for heating or cooling), chilled water return temperature (for cooling), and night flush (for heating). 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation.
</li> 
</ul>
</html>"));
end Lockouts;
