within Buildings.Experimental.RadiantControl;
package Lockouts "Blocks to lock out radiant slab"



 annotation (preferredView="info", Documentation(info="<html>

This package contains the radiant slab lockout control blocks, which indicate when heating or cooling of the radiant slab is locked out.
<li> This includes a single block, which combines all lockouts, and a sublockouts package, which includes each individual lockout on its own. 
<li> Lockouts are due to out-of-range room air temperature (for heating or cooling), hysteresis (for heating or cooling), 
<li> chilled water return temperature (for cooling), and night flush (for heating). 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated package description.<br/>
</li> 
</html>"));
end Lockouts;
