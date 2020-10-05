within Buildings.Experimental.NatVentControl.Lockouts;
package SubLockouts "Individual natural ventilation lockouts"






annotation (preferredView="info", Documentation(info="<html>
<p> This package contains the composite sublockouts that make up the AllLockouts control block, which contains all natural ventilation lockouts.
<li> These sublockouts are due to 
dry bulb temperature (DryBulbLockout),  manual override from the user (ManualOverrideLockout),  
<li>room occupancy status (OccupancyLockout),
<li>rain (RainLockout), wet bulb temperature (WetBulbLockout), and wind speed (WindLockout), respectively.
</p>
</html>"));
end SubLockouts;
