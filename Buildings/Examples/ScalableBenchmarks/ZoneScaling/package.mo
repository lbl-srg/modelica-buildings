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
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone\">
Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone</a> or the
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a> classes.
</p>
<p>
The models were used in the experiments described in Wetter et. al. (2021).
</p>
<p>
The models in the 
<a href=\"modelica://Buildings.Examples.ScalableBenchmarks.ZoneScaling.EnergyPlus\">
Buildings.Examples.ScalableBenchmarks.ZoneScaling.EnergyPlus</a>
and in the
<a href=\"modelica://Buildings.Examples.ScalableBenchmarks.ZoneScaling.MixedAir\">
Buildings.Examples.ScalableBenchmarks.ZoneScaling.MixedAir</a> are equivalent,
with the exception of the thermal zone class being used.
The models can be simulated with either 2, 4 or 10 floors.
(Other numbers of floors are not supported as each model requires its specific EnergyPlus Input Data File.)
Each floor has five thermal zones and its own air handling unit with a variable air volume flow system
that is controlled using ASHRAE Guideline 36 control sequence.
</p>
<h4>References</h4>
<p>
Michael Wetter, Kyle Benne and Baptiste Ravache.<br/>
<a href=\"https://doi.org/10.3384/ecp21181325\">Software Architecture and Implementation of Modelica Buildings Library Coupling for Spawn of EnergyPlus.</a><br/>
Proc. of the 14th International Modelica Conference, p. 325–334, Linkoping, Sweden, September 2021.
</p>
</html>"));
end ZoneScaling;
