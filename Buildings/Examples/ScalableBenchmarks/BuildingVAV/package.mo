within Buildings.Examples.ScalableBenchmarks;
package BuildingVAV "Scalable model for building with VAV system"

annotation (Documentation(
info="<html>
<p>
The models in this package include scalable building envelope model that
extends from
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a>, HVAC system model with variable
air volume (VAV) flow system with economizer and heating and cooling coil
in the air handler unit.
</p>
<p>
The building envelope model is formulated in <code>ThermalZones</code> package.
Models in <code>Examples</code> package demonstrate the model scalability. The
necessary base models are included in <code>BaseClasses</code> package.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 16, 2017, by Jianjun Hu:<br/>
Firt implementation.
</li>
</ul>
</html>"));
end BuildingVAV;
