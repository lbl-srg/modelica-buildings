within Buildings.Experimental.NaturalVentilation;
package Lockouts "Blocks to lock out natural ventilation control sequence"



annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains the AllLockouts control block, which indicates if natural ventilation is locked out.
<li> This block combines all of the composite lockouts contained in the SubLockouts block.
<li>More detail is provided in the documentation for the block itself.
<p> This package also contains the SubLockouts package, which contains the composite sublockouts that make up this control block.
<li> These sublockouts are due to 
dry bulb temperature (DryBulbLockout),  manual override from the user (ManualOverrideLockout), 
<li>room occupancy status (OccupancyLockout),
<li>rain (RainLockout), wet bulb temperature (WetBulbLockout), and wind speed (WindLockout), respectively.
</p>
</html>"));
end Lockouts;
