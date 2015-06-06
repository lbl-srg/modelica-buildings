within Buildings;
package Fluid "Package with models for fluid flow systems"
  extends Modelica.Icons.Package;


package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The package <code>Buildings.Fluid</code> consists of models
for pressure driven mass flow rate and for heat and moisture
exchange in fluid flow networks.
</p>
<p>
The models have the same interface as models of the package
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a>,
but have in general a simpler set of parameters that may be better
suited if the models are used in early design of building systems.
For example, in addition to the detailed pipe model from
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a>,
this package also contains models for which a user has to specify
the mass flow and pressure drop at a nominal flow rate,
which is typically more readily available prior to the detailed
HVAC system design.
</p>

<h4>Port variables</h4>
<p>
Component models of this package have fluid ports, which
are a subclass of
<a href=\"modelica://Modelica.Fluid.Interfaces.FluidPort\">
Modelica.Fluid.Interfaces.FluidPort</a>.
Fluid ports declare the variables listed in the table below.
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Variable</th>
<th>Description</th>
</tr>
<tr>
  <td><code>m_flow</code></td>
  <td>Mass flow rate <i>m&#775;</i>.<br/>
      The convention is that <code>m_flow &ge; 0</code>
      if at this port, mass flows into the component.</td>
</tr>
<tr>
  <td><code>p</code></td>
  <td>Absolute total pressure <i>p</i>.<br/>
      The absolute total pressure is the sum of
      the static pressure and the dynamic pressure.
      As the total pressure is used in the connector, components
      do not need to specify the area of the port or the velocity at the port.
      This convention is consistent with the Modelica Standard Library.
      Note that component models typically simplify the pressure balance
      by not taking into account the static pressure that is caused by
      the height of the medium column, i.e., the term
      <i>&Delta;p = &Delta;h &rho; g,</i>
      where
      <i>&Delta;h</i> is the height of the medium column,
      <i>&rho;</i> is the mass density and
      <i>g = 9.81</i> m/s<sup>2</sup> is the gravity acceleration,
      is ignored.</td>
</tr>
<tr>
  <td><code>h_outflow</code></td>
  <td>Specific enthalpy <i>h</i> of the outflowing fluid, i.e.,
      assuming <i>m&#775; &lt; 0.</i><br/>
      The specific enthalpy in the fluid port always carries the value
      of the enthalpy that the medium would have if it was leaving
      the component.
      Users who need to access the actual enthalpy for the given flow
      direction can do so using the sensor
      <a href=\"modelica://Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort\">
      Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort</a>.</td>
</tr>
<tr>
  <td><code>Xi_outflow[Medium.nXi]</code></td>
  <td>Independent mixture mass fractions
      <i>m<sub>i</sub>/m</i> close to the connection point, i.e.,
      assuming <i>m&#775; &lt; 0.</i><br/>
      The independent mixture mass fraction in the fluid port always carries the value
      that the medium would have if it was leaving
      the component.
      Users who need to access the actual value for the given flow
      direction can do so using the sensor
      <a href=\"modelica://Buildings.Fluid.Sensors.MassFractionTwoPort\">
      Buildings.Fluid.Sensors.MassFractionTwoPort</a>.
      Note that this variable is only present for fluids that are a mixture
      of different substances such as moist air. For water,
      this variable is automatically removed when a model is translated.</td>
</tr>
<tr>
  <td><code>C_outflow[Medium.nC]</code></td>
  <td>Trace substances <i>c<sub>i</sub>/m</i> close to the connection point, i.e.,
      assuming <i>m&#775; &lt; 0.</i><br/>
      The trace substances in the fluid port always carries the value
      that the medium would have if it was leaving
      the component.
      Users who need to access the actual value for the given flow
      direction can do so using the sensor
      <a href=\"modelica://Buildings.Fluid.Sensors.TraceSubstancesTwoPort\">
      Buildings.Fluid.Sensors.TraceSubstancesTwoPort</a>.
      Note that this variable is only present for fluids that declare
      a trace substance such as CO<sub>2</sub>.
      See for example
      <a href=\"modelica://Buildings.Fluid.Sensors.Examples.TraceSubstances\">
      Buildings.Fluid.Sensors.Examples.TraceSubstances</a>.</td>
</tr>
</table>

<h4>Computation of flow resistance</h4>
<p>
Most component models compute pressure drop as a function of flow rate.
If their pressure drop at the nominal conditions is set to zero,
for example by setting the parameter value <code>dp_nominal=0</code>, then the
equation for the pressure drop is removed from the model.
This allows, for example,
to model a heating and a cooling coil in series, and lump their pressure drops
into a single element, thereby reducing the dimension of the nonlinear system
of equations.
</p>

<p>
The flow resistance is computed as</p>
<p align=\"center\" style=\"font-style:italic;\">
  k = m&#775; &frasl; &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
where <i>m&#775;</i> is the mass flow rate and <i>&Delta;p</i> is the pressure drop.
For <i>|m&#775;| &lt; &delta;<sub>m&#775;</sub> m&#775;<sub>0</sub></i>,
where <i>&delta;<sub>m&#775;</sub></i> is equal to the parameter <code>deltaM</code> and
<i>m&#775;<sub>0</sub></i> is the mass flow rate at the nominal operating point, as
set by the parameter <code>m_flow_nominal</code>, the
equation is linearized.
The pressure drop is computed as a function of mass flow rate instead of
volume flow rate as this often leads to fewer equations. Otherwise,
the pressure drop would depend on the density and hence on temperature.
</p>

<p>
The flow coefficient <i>k</i> is typically computed based
on nominal values for the mass flow rate and the pressure drop, i.e.,
<i>k = m&#775;<sub>0</sub> &frasl; &radic;&nbsp;&Delta;p<sub>0</sub> &nbsp;
</i>.
This functional form has been used as in building HVAC systems, a more exact
computation of the pressure drop would require detailed knowledge of the duct or pipe
dimensions and the flow bends and junctions. This information is often not available during
early design. However, if a more detailed pressure drop calculation is required, then models from
<a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a> can be used in conjunction with models from the <code>Buildings</code> library.
</p>

<p>
In actuators such as valves and air dampers, <i>k</i> is a function of the control signal.
</p>

<h4>Computation of mass and energy balance</h4>
<p>
Most models have parameters
<code>massDynamics</code> and <code>energyDynamics</code>
that allow using a dynamic or a
steady-state equation for the mass and energy balance.
The table below shows the different settings and how they affect the
mass and energy balance equations.
For the mass balance, the following configurations can be selected:
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Parameter</th>
<th>Initialization problem<br/>
    If density depends on pressure</th>
<th>Initialization problem<br/>
    If density is independent of pressure</th>
<th>Equation used during time integration</th>
</tr>
<tr>
  <td>DynamicsFreeInitial</td>
  <td>Unspecified</td>
  <td>Unspecified</td>
  <td><i>dm(t)/dt = &sum; m&#775;(t)</i></td>
</tr>
<tr>
  <td>FixedInitial</td>
  <td><i>p(0)=p<sub>0</sub></i></td>
  <td>Unspecified</td>
  <td><i>dm(t)/dt = &sum; m&#775;(t)</i></td>
</tr>
<tr>
  <td>SteadyStateInitial</td>
  <td><i>dp(0)/dt</i></td>
  <td>Unspecified</td>
  <td><i>dm(t)/dt = &sum; m&#775;(t)</i></td>
</tr>
<tr>
  <td>SteadyState</td>
  <td>Unspecified</td>
  <td>Unspecified</td>
  <td><i>0 = &sum; m&#775;(t)</i></td>
</tr>
</table>

<p>
where <i>m(t)</i> is the mass of the control volume,
<i>m&#775;(t)</i> is the mass flow rate,
<i>p</i> is the pressure and
<i>p<sub>0</sub></i> is the initial pressure, which is a parameter.
<i>Unspecified</i> means that no equation is declared for
<i>p(0)</i>. In this situation, there can be two cases:
</p>
<ol>
<li>
If a system model sets the pressure, such as if the volume is connected
to a model that sets the pressure, e.g.,
<a href=\"modelica://Buildings.Fluid.Sources.FixedBoundary\">
Buildings.Fluid.Sources.FixedBoundary</a>,
then due to the connection between the models, the
pressure of the volume is the same as the pressure of the
model for the boundary condition.
</li>
<li>
If a system model does not set the pressure, then the pressure starts
at the value set by
<code>p(start=Medium.p_default)</code>,
where <code>Medium</code> is the medium model.
</li>
</ol>

<p>
Similarly, for the energy balance, the following configurations can be selected:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Parameter</th>
<th>Initialization problem</th>
<th>Equation used during time integration</th>
</tr>
<tr>
  <td>DynamicsFreeInitial</td>
  <td>Unspecified</td>
  <td><i>dU(t)/dt = &sum; m&#775;(t) &nbsp; h(t) + Q&#775;(t)</i></td>
</tr>
<tr>
  <td>FixedInitial</td>
  <td><i>T(0)=T<sub>0</sub></i></td>
  <td><i>dU(t)/dt = &sum; m&#775;(t) &nbsp; h(t) + Q&#775;(t)</i></td>
</tr>
<tr>
  <td>SteadyStateInitial</td>
  <td><i>dT(0)/dt=0</i></td>
  <td><i>dU(t)/dt = &sum; m&#775;(t) &nbsp; h(t) + Q&#775;(t)</i></td>
</tr>
<tr>
  <td>SteadyState</td>
  <td>Unspecified</td>
  <td><i>0 = &sum; m&#775;(t) &nbsp; h(t) + Q&#775;(t)</i></td>
</tr>
</table>

<p>
where <i>U(t)</i> is the internal energy of the control volume,
<i>h(t)</i> is the enthalpy carried by the medium and
<i>Q&#775;(t)</i> is the heat flow rate that is added to the medium through the heat port.
<i>Unspecified</i> means that no equation is declared for
<i>T(0)</i>. In this situation, there can be two cases:
</p>
<ol>
<li>
If a system model sets the temperature, such as if the heat port of the
volume is connected to a fixed temperature,
then <i>T(0)</i> of the volume would be equal to the temperature connected
to this port.
</li>
<li>
If a system model does not set the temperature, then the temperature starts
at the value <code>T(start=Medium.T_default)</code>,
where <code>Medium</code> is the medium model
</li>
</ol>

<p>
In most models, the size of volume is configured using the parameter <code>tau</code>.
This parameter is equal to the time constant that the volume has if the mass flow rate is
at its nominal value, as set by the parameter <code>m_flow_nominal</code>.
Using the time constant, as opposed to the actual fluid volume, allows in many cases an
easier parametrization, since the volume is automatically enlarged if the nominal mass
flow rate is increased. This allows an easy adjustment of the component size.
The actual size of the control volume is then set as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  V = m&#775;<sub>0</sub> &tau;/&rho;<sub>0</sub>
</p>
<p>
where
<i>m&#775;<sub>0</sub></i> is the nominal mass flow rate,
<i>&tau;</i> is the time constant, and
<i>&rho;<sub>0</sub></i> is the mass density at the nominal condition.
</p>

<h4>Nominal values</h4>
<p>
Most components have a parameters for the nominal operating conditions.
These parameters have names that end in <code>_nominal</code> and
they should be set to the values that the component typically
have if they are run at full load or design conditions. Depending on the model, these
parameters are used differently, and the respective model documentation or code
should be consulted for details. However, the table below shows typical use of
parameters in various model to help the user understand how they are used.
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Parameter</th>
<th>Model</th>
<th>Functionality</th>
</tr>
<tr>
  <td>m_flow_nominal<br/>
      dp_nominal</td>
  <td>Flow resistance models</td>
  <td>These parameter may be used
      to define a point on the flow rate versus pressure drop curve. For other
      mass flow rates, the pressure drop is typically adjusted using similarity laws.
      See
      <a href=\"modelica://Buildings.Fluid.FixedResistances.FixedResistanceDpM\">
      Buildings.Fluid.FixedResistances.FixedResistanceDpM</a>.
  </td>
</tr>
<tr>
  <td>m_flow_nominal<br/>
      m_flow_small</td>
  <td>Sensors<br/>
      Volumes<br/>
      Heat exchangers<br/>
      Chillers
  </td>
  <td>Some of these models set <code>m_flow_small=1E-4*abs(m_flow_nominal)</code> as the
      default value. Then, <code>m_flow_small</code> is used to regularize, or replace,
      equations when the mass flow rate is smaller than <code>m_flow_small</code>
      in magnitude. This is needed to improve the numerical properties of the model. The error in the
      results is for typical applications negligible, because at flow rates below
      <i>0.01%</i> from the design flow rate, most model assumptions are not applicable
      anyways, and the HVAC system is not operated in this region. However, because Modelica
      simulates in the continuous-time domain, such small flow rates can occur, and therefore
      models are implemented in such a way that they are numerically well-behaved for
      zero or near-zero flow rates.
  </td>
</tr>
<tr>
  <td>tau<br/>
      m_flow_nominal</td>
  <td>Sensors<br/>
      Volumes<br/>
      Heat exchangers<br/>
      Chillers
  </td>
  <td>
     Because Modelica simulates in the continuous-time domain, dynamic models are
     in general numerically more efficient than steady-state models. However,
     dynamic models require product data that are generally not published by
     manufacturers. Examples include the volume of fluid that is contained in a
     device, and the weight of heat exchangers. In addition, other effects such
     as transport delays in pipes and heat exchangers of a chiller are generally
     unknown and require detailed geometry that is typically not available
     during the design stage.
     <br/>
      To circumvent this problem, many models take as a parameter the time constant
      <code>tau</code> and lump all its thermal mass into a fluid volume.
      The time constant <code>tau</code> can be understood as the time constant that one would
      observe if the input to the component has a step change, and the mass flow rate
      of the component is equal to <code>m_flow_nominal</code>.
      Using these two values and the fluid density <code>rho</code>,
      components adjust their fluid volume
      <code>V=m_flow_nominal tau/rho</code> because having such a volume
      gives the specified time response.
      For most components, engineering experience can be used to estimate a reasonable
      value for <code>tau</code>, and where generally applicable values can be used,
      components already set a default value for <code>tau</code>.
      See for example
      <a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilDiscretized\">
      Buildings.Fluid.HeatExchangers.WetCoilDiscretized</a>.
  </td>
</tr>
</table>

<h4>Implementation</h4>
<p>
The models are implemented using base classes from
<a href=\"modelica://Buildings.Fluid.Interfaces\">
Buildings.Fluid.Interfaces</a>
and from
<a href=\"modelica://Modelica.Fluid.Interfaces\">
Modelica.Fluid.Interfaces</a>.
This allows models to be fully compatible with
<a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a>, and it allows the implementation of
component models that reuse base classes for heat transfer, mass transfer and
flow resistance.
</p>
</html>"));

end UsersGuide;


annotation (
preferredView="info", Documentation(info="<html>
This package contains components for fluid flow systems such as
pumps, valves and sensors. For other fluid flow models, see
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a>.
</html>"),
Icon(graphics={
        Polygon(points={{-70,26},{68,-44},{68,26},{2,-10},{-70,-42},{-70,26}},
            lineColor={0,0,0}),
        Line(points={{2,42},{2,-10}}, color={0,0,0}),
        Rectangle(
          extent={{-18,50},{22,42}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end Fluid;
