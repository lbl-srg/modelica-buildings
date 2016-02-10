within Buildings.Fluid.MixingVolumes;
model MixingVolumeMoistAir
  "Mixing volume with heat port for latent heat exchange, to be used with media that contain water"
  extends BaseClasses.PartialMixingVolume(
    redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialCondensingGases,
    dynBal(final use_mWat_flow = true),
    steBal(final use_mWat_flow = true));

  Modelica.Blocks.Interfaces.RealInput mWat_flow(final quantity="MassFlowRate",
                                                 final unit = "kg/s")
    "Water flow rate added into the medium"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TWat(final quantity="ThermodynamicTemperature",
                                            final unit = "K", displayUnit = "degC", min=260)
    "Temperature of liquid that is drained from or injected into volume"
    annotation (Placement(transformation(extent={{-140,28},{-100,68}})));
  Modelica.Blocks.Interfaces.RealOutput X_w "Species composition of medium"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));
  Modelica.Blocks.Math.Product QLat_flow
    "Latent heat flow rate added to the fluid stream"
    annotation (Placement(transformation(extent={{20,62},{40,82}})));
protected
  parameter Integer i_w(fixed=false) "Index for water substance";
  parameter Real s[Medium.nXi] = {
  if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                            string2="Water",
                                            caseSensitive=false) then 1 else 0
                                            for i in 1:Medium.nXi}
    "Vector with zero everywhere except where species is";

  Modelica.Blocks.Sources.RealExpression hLiq(y=Medium.enthalpyOfLiquid(TWat))
    "Enthalpy of water at the given temperature"
    annotation (Placement(transformation(extent={{-40,62},{0,86}})));
  Modelica.Blocks.Math.Add Q_flow(final k1=1, final k2=1)
    "Sensible and latent heat added to the volume"
    annotation (Placement(transformation(extent={{68,68},{88,88}})));
  Modelica.Blocks.Sources.RealExpression XLiq(y=s*Xi)
    "Species composition of the medium"
    annotation (Placement(transformation(extent={{60,-52},{82,-28}})));
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
  connect(mWat_flow, steBal.mWat_flow) annotation (Line(
      points={{-120,80},{-50,80},{-50,66},{-10,66},{-10,14},{8,14}},
      color={0,0,127}));
  connect(mWat_flow, dynBal.mWat_flow) annotation (Line(
      points={{-120,80},{-50,80},{-50,60},{52,60},{52,12},{58,12}},
      color={0,0,127}));
  connect(mWat_flow,QLat_flow. u2) annotation (Line(
      points={{-120,80},{-50,80},{-50,66},{18,66}},
      color={0,0,127}));
  connect(hLiq.y,QLat_flow. u1) annotation (Line(
      points={{2,74},{2,74},{4,74},{10,74},{10,78},{18,78}},
      color={0,0,127}));
  connect(Q_flow.y, steBal.Q_flow) annotation (Line(
      points={{89,78},{94,78},{94,40},{0,40},{0,18},{8,18}},
      color={0,0,127}));
  connect(Q_flow.y, dynBal.Q_flow) annotation (Line(
      points={{89,78},{94,78},{94,40},{54,40},{54,16},{58,16}},
      color={0,0,127}));
  connect(XLiq.y, X_w) annotation (Line(
      points={{83.1,-40},{120,-40}},
      color={0,0,127}));
  connect(QLat_flow.y, Q_flow.u2) annotation (Line(
      points={{41,72},{50,72},{66,72}},
      color={0,0,127}));
  connect(QSen_flow.y, Q_flow.u1) annotation (Line(
      points={{-19,88},{50,88},{50,84},{66,84}},
      color={0,0,127}));
  annotation (defaultComponentName="vol",
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
<p>
To increase the numerical robustness of the model, the constant
<code>prescribedHeatFlowRate</code> can be set by the user.
This constant only has an effect if the model has exactly two fluid ports connected,
and if it is used as a steady-state model.
Use the following settings:
</p>
<ul>
<li>Set <code>prescribedHeatFlowRate=true</code> if the <i>only</i> means of heat transfer
at the <code>heatPort</code> is a prescribed heat flow rate that
is <i>not</i> a function of the temperature difference
between the medium and an ambient temperature. Examples include an ideal electrical heater,
a pump that rejects heat into the fluid stream, or a chiller that removes heat based on a performance curve.
If the <code>heatPort</code> is not connected, then set <code>prescribedHeatFlowRate=true</code> as
in this case, <code>heatPort.Q_flow=0</code>.
</li>
<li>Set <code>prescribedHeatFlowRate=false</code> if there is heat flow at the <code>heatPort</code>
computed as <i>K * (T-heatPort.T)</i>, for some temperature <i>T</i> and some conductance <i>K</i>,
which may itself be a function of temperature or mass flow rate.<br/>
If there is a combination of <i>K * (T-heatPort.T)</i> and a prescribed heat flow rate,
for example a solar collector that dissipates heat to the ambient and receives heat from
the solar radiation, then set <code>prescribedHeatFlowRate=false</code>.
</li>
</ul>
<h4>Options</h4>
<p>
The parameter <code>mSenFac</code> can be used to increase the thermal mass of this model
without increasing its volume. This way, species concentrations are still calculated
correctly even though the thermal mass increases. The additional thermal mass is calculated
based on the density and the value of the function <code>HeatCapacityCp</code>
of the medium state <code>state_default</code>. <br/>
This parameter can for instance be useful in a pipe model when the developer wants to
lump the pipe thermal mass to the fluid volume. By default <code>mSenFac = 1</code>, hence
the mass is unchanged. For higher values of <code>mSenFac</code>, the mass will be scaled proportionally.
</p>
<p>
Set the parameter <code>use_C_flow = true</code> to enable an input connector for the trace substance flow rate.
This allows to directly add or subtract trace substances such as
CO2 to the volume.
See
<a href=\"modelica://Buildings.Fluid.Sensors.Examples.PPM\">Buildings.Fluid.Sensors.Examples.PPM</a>
for an example.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2016 by Michael Wetter:<br/>
Removed assignment of <code>sensibleOnly</code> in <code>steBal</code>
as this constant is no longer used.
</li>
<li>
January 19, 2016, by Michael Wetter:<br/>
Updated documentation due to the addition of an input for trace substance
in the mixing volume.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/372\">
issue 372</a>.
</li>
<li>
February 11, 2014 by Michael Wetter:<br/>
Redesigned implementation of latent and sensible heat flow rates
as port of the correction of issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/197\">#197</a>.
</li>
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
