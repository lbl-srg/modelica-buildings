within Buildings.Fluid.MixingVolumes;
model MixingVolumeMoistAir
  "Mixing volume with heat port for latent heat exchange, to be used with media that contain water"
  extends BaseClasses.PartialMixingVolumeWaterPort;
  // redeclare Medium with a more restricting base class. This improves the error
  // message if a user selects a medium that does not contain the function
  // enthalpyOfLiquid(.)
  replaceable package Medium = Modelica.Media.Interfaces.PartialCondensingGases
      annotation (choicesAllMatching = true);

protected
  parameter Integer i_w(min=1, fixed=false) "Index for water substance";
  parameter Real s[Medium.nXi](fixed=false)
    "Vector with zero everywhere except where species is";
initial algorithm
  i_w:= -1;
  if cardinality(mWat_flow) > 0 then
  for i in 1:Medium.nXi loop
      if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                            string2="Water",
                                            caseSensitive=false) then
      i_w := i;
      s[i] :=1;
    else
      s[i] :=0;
    end if;
   end for;
    assert(i_w > 0, "Substance 'water' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check medium model.");
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
  // We obtain the substance concentration with a vector multiplication
  // because Dymola 7.4 cannot find the derivative in the model
  // Buildings.Fluid.HeatExchangers.Examples.WetCoilDiscretizedPControl
  // if we set mXi_flow[i] = if ( i == i_w) then mWat_flow else 0;
    mXi_flow = mWat_flow * s;
  end if;
// Medium species concentration
  X_w = s*medium.Xi;
  annotation (Diagram(graphics),
                       Icon(graphics),
defaultComponentName="vol",
Documentation(info="<html>
Model for an ideally mixed fluid volume and the ability 
to store mass and energy. The volume is fixed, 
and latent and sensible heat can be exchanged.
<p>
This model represents the same physics as 
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>, but in addition, it allows
adding or subtracting water in liquid phase.
The mass flow rate of the added or subtracted water is
specified at the port <code>mWat_flow</code>.
The water flow rate is assumed to be added or subtracted at the
temperature of the input port <code>TWat</code>, or 
if this port is not connected, at the medium default temperature as
defined by <code>Medium.T_default</code>.
Adding water causes a change in 
enthalpy and species concentration in the volume. 
</p>
<p>
Note that this model can only be used with medium models that include water
as a substance. In particular, the medium model needs to implement the function
<code>enthalpyOfLiquid(T)</code> and the integer variable <code>Water</code> that
contains the index to the water substance. For medium that do not provide this
functionality, use
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolumeDryAir\">
Buildings.Fluid.MixingVolumes.MixingVolumeDryAir</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 22, by Michael Wetter:<br>
Improved the code that searches for the index of 'water' in the medium model.
</li>
<li>
May 29, 2010 by Michael Wetter:<br>
Rewrote computation of index of water substance.
For the old formulation, Dymola 7.4 failed to differentiate the 
model when trying to reduce the index of the DAE.
</li>
<li>
August 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end MixingVolumeMoistAir;
