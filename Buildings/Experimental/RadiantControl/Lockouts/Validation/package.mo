within Buildings.Experimental.RadiantControl.Lockouts;
package Validation "Collection of validation models for grouped lockouts"

 annotation (preferredView="info", Documentation(info="<html>

This package contains the validation model for the radiant slab lockout control block that combines all sublockouts
<li> to indicate when heating or cooling of the radiant slab is locked out.
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
end Validation;
