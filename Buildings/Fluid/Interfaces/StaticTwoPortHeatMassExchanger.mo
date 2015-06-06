within Buildings.Fluid.Interfaces;
model StaticTwoPortHeatMassExchanger
  "Partial model transporting fluid between two ports without storing mass or energy"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
  showDesignFlowDirection = false);
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));

  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  // Model inputs
  input Modelica.SIunits.HeatFlowRate Q_flow "Heat transferred into the medium";
  input Modelica.SIunits.MassFlowRate mWat_flow
    "Moisture mass flow rate added to the medium";

  // Models for conservation equations and pressure drop
  Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation vol(
    sensibleOnly = sensibleOnly,
    use_safeDivision = use_safeDivision,
    redeclare final package Medium = Medium,
    final m_flow_nominal = m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small)
    "Control volume for steady-state energy and mass balance"
    annotation (Placement(transformation(extent={{15,-10}, {35,10}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM preDro(
    redeclare final package Medium = Medium,
    final use_dh=false,
    final m_flow_nominal=m_flow_nominal,
    final deltaM=deltaM,
    final allowFlowReversal=allowFlowReversal,
    final show_T=false,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp_nominal) "Pressure drop model"
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

  constant Boolean sensibleOnly "Set to true if sensible exchange only";
  constant Boolean use_safeDivision=true
    "Set to true to improve numerical robustness";
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
      color={0,127,255},
      smooth=Smooth.None));
  connect(preDro.port_b, vol.port_a) annotation (Line(
      points={{-30,0},{15,0}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(vol.port_b, port_b) annotation (Line(
      points={{35,0},{67,0},{100,5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(heaInp.y, vol.Q_flow) annotation (Line(
      points={{1,50},{6,50},{6,8},{13,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masExc.y, vol.mWat_flow) annotation (Line(
      points={{1,30},{4,30},{4,4},{13,4}},
      color={0,0,127},
      smooth=Smooth.None));
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
<code>Q_flow</code>, which is the heat flow rate added to the medium.
</li>
<li>
<code>mWat_flow</code>, which is the moisture mass flow rate added to the medium.
</li>
</ul>

<p>
Set the constant <code>sensibleOnly=true</code> if the model that extends
or instantiates this model sets <code>mWat_flow = 0</code>.
</p>
</html>", revisions="<html>
<ul>
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
<code>smooth(0, if (port_a.m_flow >= 0) then ...</code> declaration,
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
