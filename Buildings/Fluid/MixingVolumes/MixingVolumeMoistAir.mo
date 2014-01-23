within Buildings.Fluid.MixingVolumes;
model MixingVolumeMoistAir
  "Mixing volume with heat port for latent heat exchange, to be used with media that contain water"
  extends BaseClasses.PartialMixingVolume(
    redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialCondensingGases,
    steBal(final sensibleOnly = false));

  Modelica.Blocks.Interfaces.RealInput mWat_flow(final quantity="MassFlowRate",
                                                 final unit = "kg/s")
    "Water flow rate added into the medium"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}},rotation=
           0)));
  Modelica.Blocks.Interfaces.RealInput TWat(final quantity="ThermodynamicTemperature",
                                            final unit = "K", displayUnit = "degC", min=260)
    "Temperature of liquid that is drained from or injected into volume"
    annotation (Placement(transformation(extent={{-140,28},{-100,68}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput X_w "Species composition of medium"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}, rotation=
           0)));

  Modelica.SIunits.HeatFlowRate HWat_flow = mWat_flow * Medium.enthalpyOfLiquid(TWat)
    "Enthalpy flow rate of extracted water";
protected
  parameter Integer i_w(fixed=false) "Index for water substance";
  parameter Real s[Medium.nXi] = {
  if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                            string2="Water",
                                            caseSensitive=false) then 1 else 0
                                            for i in 1:Medium.nXi}
    "Vector with zero everywhere except where species is";

  Modelica.Blocks.Sources.RealExpression heaInp(final y=
     heatPort.Q_flow + HWat_flow) "Block to set heat input into volume"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
initial algorithm
  i_w := 0;
  for i in 1:Medium.nXi loop
    if s[i] > 1e-5 then
      i_w  := i;
    end if;
  end for;
  assert(Medium.nXi == 0 or i_w > 0,
    "Substance 'water' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check medium model.");

equation
// Medium species concentration
  X_w = s * Xi;

  connect(heaInp.y, steBal.Q_flow) annotation (Line(
      points={{-59,50},{-32,50},{-32,18},{-22,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaInp.y, dynBal.Q_flow) annotation (Line(
      points={{-59,50},{26,50},{26,16},{38,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWat_flow, steBal.mWat_flow) annotation (Line(
      points={{-120,80},{-40,80},{-40,14},{-22,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWat_flow, dynBal.mWat_flow) annotation (Line(
      points={{-120,80},{20,80},{20,12},{38,12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
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
temperature of the input port <code>TWat</code>.
Adding water causes a change in 
enthalpy and species concentration in the volume. 
</p>
<p>
Note that this model can only be used with medium models that include water
as a substance. In particular, the medium model needs to implement the function
<code>enthalpyOfLiquid(T)</code> and the integer variable <code>Water</code> that
contains the index to the water substance. For medium that do not provide this
functionality, use
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 18, 2013 by Michael Wetter:<br/>
Changed computation of <code>s</code> to allow this model to also be used
with <code>Buildings.Media.Water</code>.
</li>
<li>
October 21, 2013 by Michael Wetter:<br/>
Removed dublicate declaration of medium model.
</li>
<li>
September 27, 2013 by Michael Wetter:<br/>
Reformulated assignment of <code>i_w</code> to avoid a warning in OpenModelica.
</li>
<li>
September 17, 2013 by Michael Wetter:<br/>
Changed model to no longer use the obsolete model <code>Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort</code>.
</li>
<li>
July 30, 2013 by Michael Wetter:<br/>
Changed connector <code>mXi_flow[Medium.nXi]</code>
to a scalar input connector <code>mWat_flow</code>
in the conservation equation model.
The reason is that <code>mXi_flow</code> does not allow
to compute the other components in <code>mX_flow</code> and
therefore leads to an ambiguous use of the model.
By only requesting <code>mWat_flow</code>, the mass balance
and species balance can be implemented correctly.
</li>
<li>
April 18, 2013 by Michael Wetter:<br/>
Removed the use of the deprecated
<code>cardinality</code> function.
Therefore, all input signals must be connected.
</li>
<li>
February 7, 2012 by Michael Wetter:<br/>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
February 22, by Michael Wetter:<br/>
Improved the code that searches for the index of 'water' in the medium model.
</li>
<li>
May 29, 2010 by Michael Wetter:<br/>
Rewrote computation of index of water substance.
For the old formulation, Dymola 7.4 failed to differentiate the 
model when trying to reduce the index of the DAE.
</li>
<li>
August 7, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MixingVolumeMoistAir;
