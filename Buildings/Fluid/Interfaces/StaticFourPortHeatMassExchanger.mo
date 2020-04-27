within Buildings.Fluid.Interfaces;
model StaticFourPortHeatMassExchanger
  "Partial model transporting two fluid streams between four ports without storing mass or energy"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
   final computeFlowResistance1=(dp1_nominal > Modelica.Constants.eps),
   final computeFlowResistance2=(dp2_nominal > Modelica.Constants.eps));

  constant Boolean prescribedHeatFlowRate1 = false
    "Set to true if the heat flow rate into fluid 1 is not a function of the component temperature";
  constant Boolean prescribedHeatFlowRate2 = false
    "Set to true if the heat flow rate into fluid 2 is not a function of the component temperature";

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  // Q1_flow is sensible plus latent heat flow rate
  input Modelica.SIunits.HeatFlowRate Q1_flow
    "Heat transferred into the medium 1";
  input Medium1.MassFlowRate mWat1_flow
    "Moisture mass flow rate added to the medium 1";
  // Q2_flow is sensible plus latent heat flow rate
  input Modelica.SIunits.HeatFlowRate Q2_flow
    "Heat transferred into the medium 2";
  input Medium2.MassFlowRate mWat2_flow
    "Moisture mass flow rate added to the medium 2";
  constant Boolean sensibleOnly1
    "Set to true if sensible exchange only for medium 1";
  constant Boolean sensibleOnly2
    "Set to true if sensible exchange only for medium 2";

protected
  Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger bal1(
    redeclare final package Medium=Medium1,
    final sensibleOnly = sensibleOnly1,
    final prescribedHeatFlowRate=prescribedHeatFlowRate1,
    final m_flow_nominal = m1_flow_nominal,
    final dp_nominal = dp1_nominal,
    final allowFlowReversal = allowFlowReversal1,
    final m_flow_small = m1_flow_small,
    final homotopyInitialization = homotopyInitialization,
    final from_dp = from_dp1,
    final linearizeFlowResistance = linearizeFlowResistance1,
    final deltaM = deltaM1,
    final Q_flow = Q1_flow,
    final mWat_flow = mWat1_flow)
    "Model for heat, mass, species, trace substance and pressure balance of stream 1";
  Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger bal2(
    redeclare final package Medium=Medium2,
    final sensibleOnly = sensibleOnly2,
    final prescribedHeatFlowRate=prescribedHeatFlowRate2,
    final m_flow_nominal = m2_flow_nominal,
    final dp_nominal = dp2_nominal,
    final allowFlowReversal = allowFlowReversal2,
    final m_flow_small = m2_flow_small,
    final homotopyInitialization = homotopyInitialization,
    final from_dp = from_dp2,
    final linearizeFlowResistance = linearizeFlowResistance2,
    final deltaM = deltaM2,
    final Q_flow = Q2_flow,
    final mWat_flow = mWat2_flow)
    "Model for heat, mass, species, trace substance and pressure balance of stream 2";

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(bal1.port_a, port_a1);
  connect(bal1.port_b, port_b1);
  connect(bal2.port_a, port_a2);
  connect(bal2.port_b, port_b2);
  annotation (
    preferredView="info",
    Documentation(info="<html>
<p>
This component transports two fluid streams between four ports, without
storing mass or energy. It is similar to
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>,
but it has four ports instead of two.
</p>
<p>
If <code>dp<i>N</i>_nominal &gt; Modelica.Constants.eps</code>,
where <code><i>N</i></code> denotes the fluid <i>1</i> or <i>2</i>,
then the model computes
pressure drop due to flow friction in the respective fluid stream.
The pressure drop is defined by a quadratic function that goes through
the point <code>(m<i>N</i>_flow_nominal, dp<i>N</i>_nominal)</code>.
At <code>|m<i>N</i>_flow| &lt; deltaM<i>N</i> * m<i>N</i>_flow_nominal</code>,
the pressure drop vs. flow relation is linearized.
If the parameter <code>linearizeFlowResistance<i>N</i></code> is set to true,
then the whole pressure drop vs. flow resistance curve is linearized.
</p>

<h4>Implementation</h4>
<p>
This model uses inputs and constants that need to be set by models
that extend or instantiate this model.
The following inputs need to be assigned, where <code><i>N</i></code> denotes <code>1</code> or
<code>2</code>:</p>
<ul>
<li>
<code>Q<i>N</i>_flow</code>, which is the sensible and latent heat flow rate added to the medium <i>N</i>.
</li>
<li>
<code>mWat<i>N</i>_flow</code>, which is the moisture mass flow rate added to the medium <i>N</i>.
</li>
</ul>
<p>
Set the constant <code>sensibleOnly<i>N</i>=true</code> if the model that extends
or instantiates this model sets <code>mWat<i>N</i>_flow = 0</code>.
</p>
<p>
     Note that the model does not implement <code>0 = Q1_flow + Q2_flow</code> or
     <code>0 = mXi1_flow + mXi2_flow</code>. If there is no heat or mass transfer
     with the environment, then a model that extends this model needs to provide these
     equations.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">Buildings, #1341</a>.
</li>
<li>
April 11, 2017, by Michael Wetter:<br/>
Updated documentation to make clear that <code>Q1_flow</code> and <code>Q2_flow</code>
include latent heat flow rate.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
January 22, 2016 by Michael Wetter:<br/>
Removed assignment of <code>sensibleOnly</code> in <code>bal1</code> and <code>bal2</code>
as this constant has been removed in
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>.
</li>
<li>
November 13, 2013 by Michael Wetter:<br/>
Added parameter <code>homotopyInitialization</code> as
it has been removed in the base class.
</li>
<li>
November 13, 2013, by Michael Wetter:<br/>
Removed <code>import Modelica.Constants;</code> statement.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
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
Added constants <code>sensibleOnly1</code> and
<code>sensibleOnly2</code> to
simplify species balance equations.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
Added model to compute flow friction.
</li>
<li>
March 25, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,65},{101,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end StaticFourPortHeatMassExchanger;
