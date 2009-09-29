within Buildings.Fluid.MixingVolumes;
model MixingVolumeMoistAir
  "Mixing volume with heat port for latent heat exchange, to be used with media that conatin water"
  extends BaseClasses.PartialMixingVolumeWaterPort;
  // redeclare Medium with a more restricting base class. This improves the error
  // message if a user selects a medium that does not contain the function
  // enthalpyOfLiquid(.)
  replaceable package Medium = Modelica.Media.Interfaces.PartialCondensingGases
      annotation (choicesAllMatching = true);
  annotation (Diagram(graphics),
                       Icon(graphics),
Documentation(info="<html>
Model for an ideally mixed fluid volume with <tt>nP</tt> ports and the ability 
to store mass and energy. The volume is fixed, 
and latent and sensible heat can be exchanged.
<p>
This model represents the same physics as 
<a href=\"Modelica:Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>, but in addition, it allows
adding (or subtracting) water in liquid phase, which causes a change in 
enthalpy and species concentration. 
The water flow rate is assumed to be added or extracted at the
temperature of the input port <tt>TWat</tt>, or 
if this port is not connected, at the medium default temperature as
defined by <tt>Medium.T_default</tt>.
</p>
<p>
Note that this model can only be used with medium models that include water
as a substance. In particular, the medium model need to provide the function
<tt>enthalpyOfLiquid(T)</tt> and the integer variable <tt>Water</tt> that
contains the index to the water substance. For medium that do not provide this
functionality, use instead the model
<a href=\"Modelica:Buildings.Fluid.MixingVolumes.MixingVolumeDryAir\">
Buildings.Fluid.MixingVolumes.MixingVolumeDryAir</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

protected
  parameter Integer iWat(min=1, fixed=false) "Index for water substance";
initial algorithm
  iWat :=1;
  if cardinality(mWat_flow) > 0 then
    for i in 1:Medium.nXi loop
      if Modelica.Utilities.Strings.isEqual(Medium.substanceNames[i], "Water") then
        iWat :=i;
      end if;
    end for;
  end if;
equation
  if cardinality(mWat_flow) == 0 then
    mWat_flow = 0;
    HWat_flow = 0;
    mXi_flow  = zeros(Medium.nXi);
  else
    if cardinality(TWat) == 0 then
       HWat_flow = mWat_flow * Medium.enthalpyOfLiquid(Medium.T_default);
    else
       HWat_flow = mWat_flow * Medium.enthalpyOfLiquid(TWat);
    end if;
    for i in 1:Medium.nXi loop
      mXi_flow[i] = if ( i == iWat) then mWat_flow else 0;
    end for;
  end if;
// Medium species concentration
  XWat = medium.X[iWat];
end MixingVolumeMoistAir;
