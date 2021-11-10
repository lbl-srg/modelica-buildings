within Buildings.Examples.ScalableBenchmarks;
package ZoneScaling "Collection of scalable models for validating thermal zones"
annotation (Documentation(revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
The models in this package are used to compare the scalability
of thermal zones using either the
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.ThermalZone\">
Buildings.ThermalZones.EnergyPlus.ThermalZone</a> or the
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a> classes.
</p>
<p>
The models in the 
<a href=\"modelica://Buildings.Examples.ScalableBenchmarks.ZoneScaling.EnergyPlus\">
EnergyPlus</a> and in the <a href=\"modelica://Buildings.Examples.ScalableBenchmarks.ZoneScaling.MixedAir\">
MixedAir</a> are equivalent, with the exception of the thermal zone class being used.
Each example model represents a large office building, with 
either 2, 4 or 10 floors and with a air handling unit for each floor.
</p>
</html>"));
end ZoneScaling;
