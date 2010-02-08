within Buildings.Fluid.MixingVolumes;
model MixingVolumeDryAir
  "Mixing volume with heat port for latent heat exchange, to be used with dry air"
  extends BaseClasses.PartialMixingVolumeWaterPort;
  annotation (Diagram(graphics),
                       Icon(graphics={Text(
          extent={{-152,102},{148,142}},
          textString="%name",
          lineColor={0,0,255})}),
Documentation(info="<html>
Model for an ideally mixed fluid volume and the ability 
to store mass and energy. The volume is fixed, 
and sensible heat can be exchanged.
<p>
This model has the same ports as
<a href=\"Modelica:Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir\">
Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir</a>.
However, there is no mass exchange with the medium other than through the port
<code>ports</code>.
</p>
<p>
For media that do provide water as a species, use the model
<a href=\"Modelica:Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir\">
Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

equation
  if cardinality(mWat_flow) == 0 then
    mWat_flow = 0;
  end if;
  if cardinality(TWat) == 0 then
    TWat = Medium.T_default;
  end if;
  HWat_flow = 0;
  mXi_flow  = zeros(Medium.nXi);
// Assign output port
  XWat = 0;
end MixingVolumeDryAir;
