within Buildings.Fluid.Interfaces;
model StaticTwoPortHeatMassExchanger
  "Partial model transporting fluid between two ports without storing mass or energy"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));

  constant Boolean sensibleOnly "Set to true if sensible exchange only";
  constant Boolean prescribedHeatFlowRate
    "Set to true if the heat flow rate is not a function of the component temperature";

  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  // Model inputs
  // Q_flow is the sensible plus latent heat flow rate
  input Modelica.SIunits.HeatFlowRate Q_flow "Heat transferred into the medium";
  input Modelica.SIunits.MassFlowRate mWat_flow
    "Moisture mass flow rate added to the medium";

  // Models for conservation equations and pressure drop
  Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation vol(
    redeclare final package Medium = Medium,
    final use_mWat_flow = not sensibleOnly,
    final prescribedHeatFlowRate = prescribedHeatFlowRate,
    final m_flow_nominal = m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small)
    "Control volume for steady-state energy and mass balance"
    annotation (Placement(transformation(extent={{15,-10}, {35,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop preDro(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final deltaM=deltaM,
    final allowFlowReversal=allowFlowReversal,
    final show_T=false,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp_nominal) "Flow resistance"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  // Outputs that are needed in models that extend this model
  Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg")
    "Leaving temperature of the component";

  Modelica.Blocks.Interfaces.RealOutput XiOut[Medium.nXi](each unit="1",
                                                          each min=0,
                                                          each max=1)
    "Leaving species concentration of the component";
  Modelica.Blocks.Interfaces.RealOutput COut[Medium.nC](each min=0)
    "Leaving trace substances of the component";

protected
  Modelica.Blocks.Sources.RealExpression heaInp(y=Q_flow)
    "Block to set heat input into volume"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.RealExpression
    masExc(final y=mWat_flow) "Block to set moisture exchange in volume"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
equation
  connect(vol.hOut, hOut);
  connect(vol.XiOut, XiOut);
  connect(vol.COut, COut);
  connect(port_a,preDro. port_a) annotation (Line(
      points={{-100,0},{-50,0}},
      color={0,127,255}));
  connect(preDro.port_b, vol.port_a) annotation (Line(
      points={{-30,0},{15,0}},
      color={0,127,255}));

  connect(vol.port_b, port_b) annotation (Line(
      points={{35,0},{67,0},{100,5.55112e-16}},
      color={0,127,255}));

  connect(heaInp.y, vol.Q_flow) annotation (Line(
      points={{1,50},{6,50},{6,8},{13,8}},
      color={0,0,127}));
  connect(masExc.y, vol.mWat_flow) annotation (Line(
      points={{1,30},{4,30},{4,4},{13,4}},
      color={0,0,127}));
  annotation (
    preferredView="info",
    Documentation(info="<html>
<p>
This component transports fluid between its two ports, without
storing mass or energy. It is based on
<a href=\"modelica://Modelica.Fluid.Interfaces.PartialTwoPortTransport\">
Modelica.Fluid.Interfaces.PartialTwoPortTransport</a> but it does
use a different implementation for handling reverse flow because
in this component, mass flow rate can be added or removed from
the medium.
</p>
<p>
If <code>dp_nominal &gt; Modelica.Constants.eps</code>, this component computes
pressure drop due to flow friction.
The pressure drop is defined by a quadratic function that goes through
the point <code>(m_flow_nominal, dp_nominal)</code>. At <code>|m_flow| &lt; deltaM * m_flow_nominal</code>,
the pressure drop vs. flow relation is linearized.
If the parameter <code>linearizeFlowResistance</code> is set to true,
then the whole pressure drop vs. flow resistance curve is linearized.
</p>
<h4>Implementation</h4>
This model uses inputs and constants that need to be set by models
that extend or instantiate this model.
The following inputs need to be assigned:
<ul>
<li>
<code>Q_flow</code>, which is the sensible and latent heat flow rate added to the medium.
</li>
<li>
<code>mWat_flow</code>, which is the moisture mass flow rate added to the medium.
</li>
</ul>

<p>
Set the constant <code>sensibleOnly=true</code> if the model that extends
or instantiates this model sets <code>mWat_flow = 0</code>.
</p>
<p>
To increase the numerical robustness of the model, the constant
<code>prescribedHeatFlowRate</code> can be set.
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
<p>
If <code>prescribedHeatFlow=true</code>, then energy and mass balance
equations are formulated to guard against numerical problems near
zero flow that can occur if <code>Q_flow</code> or <code>m_flow</code>
are the results of an iterative solver.
</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2017, by Michael Wetter:<br/>
Updated documentation to make clear that <code>Q_flow</code>
includes latent heat flow rate.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
December 1, 2016, by Michael Wetter:<br/>
Updated model as <code>use_dh</code> is no longer a parameter in the pressure drop model.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/480\">#480</a>.
</li>
<li>
January 22, 2016 by Michael Wetter:<br/>
Removed assignment of <code>sensibleOnly</code> in <code>bal1</code> and <code>bal2</code>
as this constant has been removed in
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>.
</li>
<li>
November 19, 2015, by Michael Wetter:<br/>
Removed assignment of parameter
<code>showDesignFlowDirection</code> in <code>extends</code> statement.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/349\">#349</a>.
</li>
<li>
July 2, 2015 by Michael Wetter:<br/>
Revised implementation of conservation equations,
added default values for outlet quantities at <code>port_a</code>
if <code>allowFlowReversal=false</code> and
updated documentation.
See
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/281\">
issue 281</a> for a discussion.
</li>
<li>
July 1, 2015 by Filip Jorissen:<br/>
Renamed <code>use_safeDivision</code> into
<code>prescribedHeatFlowRate</code>.
See
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/282\">
issue 282</a> for a discussion.
</li>
<li>
November 13, 2013 by Michael Wetter:<br/>
Added parameter <code>homotopyInitialization</code> as
it has been removed in the base class.
</li>
<li>
October 8, 2013 by Michael Wetter:<br/>
Removed propagation of <code>show_V_flow</code>
to pressure drop calculation, as this model no longer has
that parameter.
</li>
<li>
July 30, 2013 by Michael Wetter:<br/>
Changed connector <code>mXi_flow[Medium.nXi]</code>
to a scalar input connector <code>mWat_flow</code>.
The reason is that <code>mXi_flow</code> does not allow
to compute the other components in <code>mX_flow</code> and
therefore leads to an ambiguous use of the model.
By only requesting <code>mWat_flow</code>, the mass balance
and species balance can be implemented correctly.
</li>
<li>
March 27, 2013 by Michael Wetter:<br/>
Removed wrong unit attribute of <code>COut</code>,
and added min and max attributes for <code>XiOut</code>.
</li>
<li>
February 8, 2012 by Michael Wetter:<br/>
Changed model to use graphical modeling.
</li>
<li>
December 14, 2011 by Michael Wetter:<br/>
Changed assignment of <code>hOut</code>, <code>XiOut</code> and
<code>COut</code> to no longer declare that it is continuous.
The declaration of continuity, i.e, the
<code>smooth(0, if (port_a.m_flow >= 0) then ...)</code> declaration,
was required for Dymola 2012 to simulate, but it is no longer needed
for Dymola 2012 FD01.
</li>
<li>
August 19, 2011, by Michael Wetter:<br/>
Changed assignment of <code>hOut</code>, <code>XiOut</code> and
<code>COut</code> to declare that it is not differentiable.
</li>
<li>
August 4, 2011, by Michael Wetter:<br/>
Moved linearized pressure drop equation from the function body to the equation
section. With the previous implementation,
the symbolic processor may not rearrange the equations, which can lead
to coupled equations instead of an explicit solution.
</li>
<li>
March 29, 2011, by Michael Wetter:<br/>
Changed energy and mass balance to avoid a division by zero if <code>m_flow=0</code>.
</li>
<li>
March 27, 2011, by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
August 19, 2010, by Michael Wetter:<br/>
Fixed bug in energy and moisture balance that affected results if a component
adds or removes moisture to the air stream.
In the old implementation, the enthalpy and species
outflow at <code>port_b</code> was multiplied with the mass flow rate at
<code>port_a</code>. The old implementation led to small errors that were proportional
to the amount of moisture change. For example, if the moisture added by the component
was <code>0.005 kg/kg</code>, then the error was <code>0.5%</code>.
Also, the results for forward flow and reverse flow differed by this amount.
With the new implementation, the energy and moisture balance is exact.
</li>
<li>
March 22, 2010, by Michael Wetter:<br/>
Added constant <code>sensibleOnly</code> to
simplify species balance equation.
</li>
<li>
April 10, 2009, by Michael Wetter:<br/>
Added model to compute flow friction.
</li>
<li>
April 22, 2008, by Michael Wetter:<br/>
Revised to add mass balance.
</li>
<li>
March 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end StaticTwoPortHeatMassExchanger;
