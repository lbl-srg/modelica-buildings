within Buildings.Examples.ScalableBenchmarks.BuildingVAV;
package ThermalZones "Scalable building envelope model"

  annotation (Documentation(info="<html>
<p>
This package includes building envelope model that extends from
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a>. The model
<a href=\"modelica://Buildings.Examples.ScalableBenchmarks.BuildingVAV.ThermalZones.MultiZone\">
Buildings.Examples.ScalableBenchmarks.BuildingVAV.ThermalZones.MultiZone</a> is scalable
through changing the number of floors and zones.
</p>
<p>
Internal heat gain which includes radiative heat gain <code>qRadGai_flow</code>,
convective heat gain <code>qConGai_flow</code>, and latent heat gain
<code>qLatGai_flow</code> are referenced from ASHRAE Handbook fundamental.
The factor <code>gainFactor</code> is used to scale up/down the heat gain.
The gain schdule is specified by <code>intLoad</code>.
Air infiltration from outside is assumed to be 0.5 ACH.
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
end ThermalZones;
