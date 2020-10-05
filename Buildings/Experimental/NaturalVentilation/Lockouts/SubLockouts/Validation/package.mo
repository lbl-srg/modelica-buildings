within Buildings.Experimental.NaturalVentilation.Lockouts.SubLockouts;
package Validation "Validation models for individual lockouts"






annotation (preferredView="info", Documentation(info="<html>
<p> This package contains validation models for the composite sublockouts that make up the AllLockouts control block, which contains all natural ventilation lockouts.
<li> These models validate each of the lockouts:
dry bulb temperature (DryBulb),  manual override from the user (ManualOverride),  
<li>room occupancy status (Occupancy),
<li>rain (Rain), wet bulb temperature (WetBulb), and wind speed (Wind), respectively.
</p>
</html>"));
end Validation;
