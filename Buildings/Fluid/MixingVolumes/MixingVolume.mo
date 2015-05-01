within Buildings.Fluid.MixingVolumes;
model MixingVolume
  "Mixing volume with inlet and outlet ports (flow reversal is allowed)"
  extends Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume;
protected
  Modelica.Blocks.Sources.Constant masExc(final k=0)
    "Block to set mass exchange in volume"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(masExc.y, dynBal.mWat_flow) annotation (Line(
      points={{-59,60},{20,60},{20,12},{38,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masExc.y, steBal.mWat_flow) annotation (Line(
      points={{-59,60},{-40,60},{-40,14},{-22,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QSen_flow.y, steBal.Q_flow) annotation (Line(
      points={{-59,88},{-30,88},{-30,18},{-22,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QSen_flow.y, dynBal.Q_flow) annotation (Line(
      points={{-59,88},{28,88},{28,16},{38,16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
defaultComponentName="vol",
Documentation(info="<html>
<p>
This model represents an instantaneously mixed volume.
Potential and kinetic energy at the port are neglected,
and there is no pressure drop at the ports.
The volume can exchange heat through its <code>heatPort</code>.
</p>
<p>
The volume can be parameterized as a steady-state model or as
dynamic model.</p>
<p>
To increase the numerical robustness of the model, the parameter
<code>prescribedHeatFlowRate</code> can be set by the user.
This parameter only has an effect if the model has exactly two fluid ports connected,
and if it is used as a steady-state model.
Use the following settings:
</p>
<ul>
<li>Set <code>prescribedHeatFlowRate=true</code> if there is a model connected to <code>heatPort</code>
that computes the heat flow rate <i>not</i> as a function of the temperature difference
between the medium and an ambient temperature. Examples include an ideal electrical heater,
a pump that rejects heat into the fluid stream, or a chiller that removes heat based on a performance curve.
</li>
<li>Set <code>prescribedHeatFlowRate=true</code> if the only means of heat flow at the <code>heatPort</code>
is computed as <i>K * (T-heatPort.T)</i>, for some temperature <i>T</i> and some conductance <i>K</i>,
which may itself be a function of temperature or mass flow rate.
</li>
</ul>
<h4>Options</h4>
<ul>
<li>Parameter <code>mSenFac</code> can be used to increase the thermal mass of this model
without increasing its volume. This way, species concentrations are still calculated
correctly even though the thermal mass increases. The additional thermal mass is calculated
based on the density and the value of the function <code>HeatCapacityCp</code>
of the medium state <code>state_default</code>. <br/>
This parameter can for instance be useful in a pipe model when the developer wants to
lump the pipe thermal mass to the fluid volume. By default <code>mSenFac = 1</code>, hence
the mass is unchanged. For higher values of <code>mSenFac</code>, the mass will be scaled proportionally.
</li>
</ul>
<h4>Implementation</h4>
<p>
If the model is operated in steady-state and has two fluid ports connected,
then the same energy and mass balance implementation is used as in
steady-state component models, i.e., the use of <code>actualStream</code>
is not used for the properties at the port.
</p>
<p>
The implementation of these balance equations is done in the instances
<code>dynBal</code> for the dynamic balance and <code>steBal</code>
for the steady-state balance. Both models use the same input variables:
</p>
<ul>
<li>
The variable <code>Q_flow</code> is used to add sensible <i>and</i> latent heat to the fluid.
For example, <code>Q_flow</code> participates in the steady-state energy balance<pre>
    port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
</pre>
where <code>m_flowInv</code> approximates the expression <code>1/m_flow</code>.
</li>
<li>
The variable <code>mXi_flow</code> is used to add a species mass flow rate to the fluid.
</li>
</ul>

<p>
For simple models that uses this model, see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed\">
Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed</a> and
<a href=\"modelica://Buildings.Fluid.MassExchangers.HumidifierPrescribed\">
Buildings.Fluid.MassExchangers.HumidifierPrescribed</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
May 1, 2015 by Michael Wetter<br/>
Set <code>final</code> keyword for <code>masExc(final k=0)</code>.
This addresses
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/230\">
issue 230</a>.
</li>
<li>
February 11, 2014 by Michael Wetter:<br/>
Redesigned implementation of latent and sensible heat flow rates
as port of the correction of issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/197\">#197</a>.
</li>
<li>
February 7, 2012 by Michael Wetter:<br/>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
September 17, 2011 by Michael Wetter:<br/>
Removed instance <code>medium</code> as this is already used in <code>dynBal</code>.
Removing the base properties led to 30% faster computing time for a solar thermal system
that contains many fluid volumes.
</li>
<li>
September 13, 2011 by Michael Wetter:<br/>
Changed in declaration of <code>medium</code> the parameter assignment
<code>preferredMediumStates=true</code> to
<code>preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)</code>.
Otherwise, for a steady-state model, Dymola 2012 may differentiate the model to obtain <code>T</code>
as a state. See ticket Dynasim #13596.
</li>
<li>
July 26, 2011 by Michael Wetter:<br/>
Revised model to use new declarations from
<a href=\"Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
</li>
<li>
July 14, 2011 by Michael Wetter:<br/>
Added start values for mass and internal energy of dynamic balance
model.
</li>
<li>
May 25, 2011 by Michael Wetter:<br/>
<ul>
<li>
Changed implementation of balance equation. The new implementation uses a different model if
exactly two fluid ports are connected, and in addition, the model is used as a steady-state
component. For this model configuration, the same balance equations are used as were used
for steady-state component models, i.e., instead of <code>actualStream(...)</code>, the
<code>inStream(...)</code> formulation is used.
This changed required the introduction of a new parameter <code>m_flow_nominal</code> which
is used for smoothing in the steady-state balance equations of the model with two fluid ports.
</li>
<li>
Another revision was the removal of the parameter <code>use_HeatTransfer</code> as there is
no noticable overhead in always having the <code>heatPort</code> connector present.
</li>
</ul>
</li>
<li>
July 30, 2010 by Michael Wetter:<br/>
Added nominal value for <code>mC</code> to avoid wrong trajectory
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
February 7, 2010 by Michael Wetter:<br/>
Simplified model and its base classes by removing the port data
and the vessel area.
Eliminated the base class <code>PartialLumpedVessel</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br/>
Changed base class to
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume\">
Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume</a>.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Ellipse(
          extent={{-100,98},{100,-102}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={170,213,255}), Text(
          extent={{-58,14},{58,-18}},
          lineColor={0,0,0},
          textString="V=%V"),         Text(
          extent={{-152,100},{148,140}},
          textString="%name",
          lineColor={0,0,255})}));
end MixingVolume;
