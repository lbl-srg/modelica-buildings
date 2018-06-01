within Buildings.Fluid.FixedResistances;
model Junction
  "Flow splitter with fixed resistance at each port"
    extends Buildings.Fluid.BaseClasses.PartialThreeWayResistance(
    mDyn_flow_nominal = sum(abs(m_flow_nominal[:])/3),
    redeclare Buildings.Fluid.FixedResistances.PressureDrop res1(
      from_dp=from_dp,
      final m_flow_nominal=m_flow_nominal[1],
      final dp_nominal=dp_nominal[1],
      linearized=linearized,
      homotopyInitialization=homotopyInitialization,
      deltaM=deltaM),
    redeclare Buildings.Fluid.FixedResistances.PressureDrop res2(
      from_dp=from_dp,
      final m_flow_nominal=m_flow_nominal[2],
      final dp_nominal=dp_nominal[2],
      linearized=linearized,
      homotopyInitialization=homotopyInitialization,
      deltaM=deltaM),
    redeclare Buildings.Fluid.FixedResistances.PressureDrop res3(
      from_dp=from_dp,
      final m_flow_nominal=m_flow_nominal[3],
      final dp_nominal=dp_nominal[3],
      linearized=linearized,
      homotopyInitialization=homotopyInitialization,
      deltaM=deltaM));

  parameter Modelica.SIunits.MassFlowRate[3] m_flow_nominal
    "Mass flow rate. Set negative at outflowing ports."
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.Pressure[3] dp_nominal(each displayUnit = "Pa")
    "Pressure drop at nominal mass flow rate, set to zero or negative number at outflowing ports."
    annotation(Dialog(group = "Nominal condition"));

  parameter Real deltaM(min=0) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Dialog(group = "Transition to laminar",
                         enable = not linearized));

  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Advanced"));

  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics={
        Polygon(
          points={{-100,-46},{-32,-40},{-32,-100},{30,-100},{30,-36},{100,-30},
              {100,38},{-100,52},{-100,-46}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,-34},{-18,-28},{-18,-100},{18,-100},{18,-26},{100,-20},
              {100,22},{-100,38},{-100,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,128,255}),
        Ellipse(
          visible=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState,
          extent={{-38,36},{40,-40}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,142},{149,102}},
          lineColor={0,0,255},
          textString="%name")}),
defaultComponentName="jun",
    Documentation(info="<html>
<p>
Model of a flow junction with an optional fixed resistance in each flow leg
and an optional mixing volume at the junction.
</p>
<p>
The pressure drop is implemented using the model
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a>.
If its nominal pressure drop is set to zero, then the pressure drop
model will be removed.
For example, the pressure drop declaration
</p>
<pre>
  m_flow_nominal={ 0.1, 0.1,  -0.2},
  dp_nominal =   {500,    0, -6000}
</pre>
<p>
would model a flow mixer that has the nominal flow rates and associated pressure drops
as shown in the figure below. Note that <code>port_3</code> is set to negative values.
The negative values indicate that at the nominal conditions, fluid is leaving the component.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/FixedResistances/Junction.png\"/>
</p>
<p>
If
<code>energyDynamics &lt;&gt; Modelica.Fluid.Types.Dynamics.SteadyState</code>,
then at the flow junction, a fluid volume is modeled.
The fluid volume is implemented using the model
<a href=\"modelica://Buildings.Fluid.Delays.DelayFirstOrder\">
Buildings.Fluid.Delays.DelayFirstOrder</a>.
The fluid volume has the size
</p>
<pre>
  V = sum(abs(m_flow_nominal[:])/3)*tau/rho_nominal
</pre>
<p>
where <code>tau</code> is a parameter and <code>rho_nominal</code> is the density
of the medium in the volume at nominal condition.
Setting <code>energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial</code>
can help reducing the size of the nonlinear
system of equations.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2018 by Filip Jorissen:<br/>
Removed <code>final allowFlowReversal=true</code> from all resistances 
since this overrides the default simplification when the flow
is not bidirectional.
This change can lead to smaller algebraic loops.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/898\">issue 898</a>.
</li>
<li>
December 1, 2016, by Michael Wetter:<br/>
Renamed model from <code>SplitterFixedResistanceDpM</code> to
<code>FlowJunction</code> and removed the parameters
<code>use_dh</code>, <code>dh</code> and <code>ReC</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/451\">issue 451</a>.
</li>
<li>
October 14, 2016 by Michael Wetter:<br/>
Added to Annex 60 library.<br/>
Updated comment for parameter <code>use_dh</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/451\">issue 451</a>.
</li>
<li>
Removed parameter <code>dynamicBalance</code> that overwrote the setting
of <code>energyDynamics</code> and <code>massDynamics</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/411\">
Annex 60, issue 411</a>.
</li>
<li>
February 1, 2012 by Michael Wetter:<br/>
Expanded documentation.
</li>
<li>
August 4, 2011 by Michael Wetter:<br/>
Added <code>final allowFlowReversal=true</code> to all resistances since it is impractical
to avoid flow reversal in large flow networks where such a setting may be useful.
</li>
<li>
June 11, 2008 by Michael Wetter:<br/>
Based class on
<a href=\"modelica://Buildings.Fluid.BaseClasses.PartialThreeWayFixedResistance\">
PartialThreeWayFixedResistance</a>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Junction;
