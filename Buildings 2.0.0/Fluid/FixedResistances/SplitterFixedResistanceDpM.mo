within Buildings.Fluid.FixedResistances;
model SplitterFixedResistanceDpM
  "Flow splitter with fixed resistance at each port"
    extends Buildings.BaseClasses.BaseIcon;
    extends Buildings.Fluid.BaseClasses.PartialThreeWayResistance(
    mDyn_flow_nominal = sum(abs(m_flow_nominal[:])/3),
      redeclare Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(
         redeclare package Medium=Medium,
            final allowFlowReversal=true,
            from_dp=from_dp,
            final m_flow_nominal=m_flow_nominal[1],
            final dp_nominal=dp_nominal[1],
            final ReC=ReC[1],
            final dh=dh[1],
            linearized=linearized,
            homotopyInitialization=homotopyInitialization,
            deltaM=deltaM),
      redeclare Buildings.Fluid.FixedResistances.FixedResistanceDpM res2(
         redeclare package Medium=Medium,
            final allowFlowReversal=true,
            from_dp=from_dp,
            final m_flow_nominal=m_flow_nominal[2],
            final dp_nominal=dp_nominal[2],
            final ReC=ReC[2],
            final dh=dh[2],
            linearized=linearized,
            homotopyInitialization=homotopyInitialization,
            deltaM=deltaM),
      redeclare Buildings.Fluid.FixedResistances.FixedResistanceDpM res3(
         redeclare package Medium=Medium,
            final allowFlowReversal=true,
            from_dp=from_dp,
            final m_flow_nominal=m_flow_nominal[3],
            final dp_nominal=dp_nominal[3],
            final ReC=ReC[3],
            final dh=dh[3],
            linearized=linearized,
            homotopyInitialization=homotopyInitialization,
            deltaM=deltaM));

  parameter Boolean use_dh = false "Set to true to specify hydraulic diameter"
    annotation(Evaluate=true, Dialog(enable = not linearized));
  parameter Modelica.SIunits.MassFlowRate[3] m_flow_nominal
    "Mass flow rate. Set negative at outflowing ports." annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure[3] dp_nominal(each displayUnit = "Pa")
    "Pressure. Set negative at outflowing ports."
    annotation(Dialog(group = "Nominal condition"));
  parameter Real deltaM(min=0) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Dialog(enable = not use_dh and not linearized));

  parameter Modelica.SIunits.Length[3] dh={1, 1, 1} "Hydraulic diameter"
    annotation(Dialog(enable = use_dh and not linearized));
  parameter Real[3] ReC(each min=0)={4000, 4000, 4000}
    "Reynolds number where transition to turbulent starts"
      annotation(Dialog(enable = use_dh and not linearized));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Advanced"));
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  annotation (                       Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
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
          visible=dynamicBalance,
          extent={{-38,36},{40,-40}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
defaultComponentName="spl",
    Documentation(info="<html>
<p>
Model of a flow splitter or mixer with a fixed resistance in each flow leg.
In each flow lag, a pressure drop can be modeled, and at the fluid junction,
a mixing volume can be modeled.
</p>
<p>
The pressure drop is implemented using the model
<a href=\"modelica://Buildings.Fluid.FixedResistances.FixedResistanceDpM\">
Buildings.Fluid.FixedResistances.FixedResistanceDpM</a>.
If its nominal pressure drop is set to zero, then the pressure drop
model will be removed.
For example, the pressure drop declaration
</p>
<pre>
  m_flow_nominal={ 0.1, 0.1,  -0.2},
  dp_nominal =   {500,    0, -6000}
</pre>
<p>
would model a mixer that has the nominal flow rates and associated pressure drops
as shown in the figure below. Note that <code>port_3</code> is set to negative values.
The negative values indicate that at the nominal conditions, fluid is leaving the component.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/FixedResistances/SplitterFixedResistanceDpM.png\"/>
</p>
<p>
Optionally, at the fluid junction, a control volume can be modeled.
This is implemented using the model
<a href=\"modelica://Buildings.Fluid.Delays.DelayFirstOrder\">
Buildings.Fluid.Delays.DelayFirstOrder</a>.
The fluid volume is modeled if
<code>dynamicBalance=true</code>, and it is removed if
<code>dynamicBalance=false</code>.
The control volume has the size
</p>
<pre>
  V = sum(abs(m_flow_nominal[:])/3)*tau/rho_nominal
</pre>
<p>
where <code>tau</code> is a parameter and <code>rho_nominal</code> is the density
of the medium in the volume at nominal condition.
Setting <code>dynamicBalance=true</code> can help reducing the size of the nonlinear
system of equations.
</p>
</html>", revisions="<html>
<ul>
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
end SplitterFixedResistanceDpM;
