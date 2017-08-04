within Buildings.Experimental.ScalableModels.ThermalZones.BaseClasses;
model ThermalZoneFluctuatingIHG_North
  "Thermal zone model: North exterior wall"
  extends
    Buildings.Experimental.ScalableModels.ThermalZones.BaseClasses.ThermalZoneFluctuatingIHG(
    roo(
      datConExtWin(
        azi={N_})));
  annotation (Documentation(info="<html>
<p>
This model consist a building enveloped model which is extented from 
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a>. The external window is oriented to north.
</p>
<p>
Internal heat gain which includes radiative heat gain <code>qRadGai_flow</code>,
convective heat gain <code>qConGai_flow</code>, and latent heat gain 
<code>qLatGai_flow</code> are referenced from ASHRAE Handbook fundamental. 
The factor <code>gainFactor</code> is used to scale down the heat gain.
The gain schdule is specified by <code>intLoad</code>.
A constant air infiltration from outside is assumed.
</p>
</html>", revisions="<html>
<ul>
<li>
April 10, 2016, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalZoneFluctuatingIHG_North;
