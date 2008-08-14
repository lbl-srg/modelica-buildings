model MixingVolumeDryAir 
  "Mixing volume with heat port for latent heat exchange, to be used with dry air" 
  extends BaseClasses.PartialMixingVolumeWaterPort;
  annotation (Diagram, Icon,
Documentation(info="<html>
Model for an ideally mixed fluid volume with <tt>nP</tt> ports and the ability 
to store mass and energy. The volume is fixed, 
and latent and sensible heat can be exchanged.
<p>
This model represents the same physics as 
<a href=\"Modelica:Buildings.Fluids.MixingVolumes.MixingVolume\">
Buildings.Fluids.MixingVolumes.MixingVolume</a>, but in addition, it allows
adding (or subtracting) water in liquid phase, which causes a change in 
enthalpy and species concentration. 
The water flow rate is assumed to be added or extracted at the
temperature of the input port <tt>TWat</tt>, or 
if this port is not connected at the medium default temperature as
returned by <tt>Medium.T_default</tt>.
</p>
<p>
Note that this model can only be used with medium models that include water
as a substance. In particular, the medium model need to provide the function
<tt>enthalpyOfLiquid(T)</tt> and the integer variable <tt>Water</tt> that
contains the index to the water substance. For medium that do not provide this
functionality, use instead the model
<a href=\"Modelica:Buildings.Fluids.MixingVolumes.MixingVolumeDryAir\">
Buildings.Fluids.MixingVolumes.MixingVolumeDryAir</a>.
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
