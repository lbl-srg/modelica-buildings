within Buildings.Fluid.BaseClasses;
partial model PartialResistance "Partial model for a hydraulic resistance"
    extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
     show_T=false,
     dp(nominal=if dp_nominal_pos > Modelica.Constants.eps
          then dp_nominal_pos else 1),
     m_flow(
        nominal=if m_flow_nominal_pos > Modelica.Constants.eps
          then m_flow_nominal_pos else 1),
     final m_flow_small = 1E-4*abs(m_flow_nominal));

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));

  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Turbulent flow if |m_flow| >= m_flow_turbulent";

protected
  parameter Medium.ThermodynamicState sta_default=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
  parameter Modelica.Units.SI.DynamicViscosity eta_default=
      Medium.dynamicViscosity(sta_default)
    "Dynamic viscosity, used to compute transition to turbulent flow regime";

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_pos=abs(
      m_flow_nominal) "Absolute value of nominal flow rate";
  final parameter Modelica.Units.SI.PressureDifference dp_nominal_pos(
      displayUnit="Pa") = abs(dp_nominal)
    "Absolute value of nominal pressure difference";
initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  // Isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = if allowFlowReversal then inStream(port_b.h_outflow) else Medium.h_default;
  port_b.h_outflow = inStream(port_a.h_outflow);

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  // Transport of substances
  port_a.Xi_outflow = if allowFlowReversal then inStream(port_b.Xi_outflow) else Medium.X_default[1:Medium.nXi];
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = if allowFlowReversal then inStream(port_b.C_outflow) else zeros(Medium.nC);
  port_b.C_outflow = inStream(port_a.C_outflow);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          visible=linearized,
          extent={{-100,22},{100,-22}},
          fillPattern=FillPattern.Backward,
          fillColor={0,128,255},
          pattern=LinePattern.None,
          lineColor={255,255,255}),
        Rectangle(
          extent=DynamicSelect({{-100,10},{-100,10}}, {{100,10},{100+200*max(-1, min(0, m_flow/(abs(m_flow_nominal)))),-10}}),
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent=DynamicSelect({{-100,10},{-100,10}}, {{-100,10},{-100+200*min(1, max(0, m_flow/abs(m_flow_nominal))),-10}}),
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
          defaultComponentName="res",
Documentation(info="<html>
<p>
Partial model for a flow resistance, possible with variable flow coefficient.
Models that extend this class need to implement an equation that relates
<code>m_flow</code> and <code>dp</code>, and they need to assign the parameter
<code>m_flow_turbulent</code>.
</p>
<p>
See for example
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a> for a model that extends
this base class.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
February 26, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
October 25, 2019, by Jianjun Hu:<br/>
Improved icon graphics annotation. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1225\">#1225</a>.
</li>
<li>
November 3, 2016, by Michael Wetter:<br/>
Removed start value for pressure difference
to simplify the parameter window.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/552\">#552</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Avoided assignment of <code>dp(nominal=0)</code> if <code>dp_nominal_pos = 0</code>
and of <code>m_flow(nominal=0)</code> if <code>m_flow_nominal_pos = 0</code>
as nominal values are not allowed to be zero.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
August 15, 2015, by Filip Jorissen:<br/>
Implemented more efficient computation of <code>port_a.Xi_outflow</code>,
<code>port_a.h_outflow</code>
and <code>port_a.C_outflow</code> when <code>allowFlowReversal=false</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/281\">#281</a>.
</li>
<li>
January 13, 2015, by Marcus Fuchs:<br/>
Revised revisions section (there were two revisions statements)
</li>
<li>
November 20, 2014 by Michael Wetter:<br/>
Removed <code>start</code> attribute for <code>m_flow</code>
as this is already set in its base class.
</li>
<li>
October 8, 2013 by Michael Wetter:<br/>
Removed propagation of <code>show_V_flow</code>
to base class as it has no longer this parameter.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
February 12, 2012, by Michael Wetter:<br/>
Removed duplicate declaration of <code>m_flow_nominal</code>.
</li>
<li>
February 3, 2012, by Michael Wetter:<br/>
Made assignment of <code>m_flow_small</code> <code>final</code> as it is no
longer used in the base class.
</li>
<li>
January 16, 2012, by Michael Wetter:<br/>
To simplify object inheritance tree, revised base classes
<code>Buildings.Fluid.BaseClasses.PartialResistance</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialActuator</code>
and model
<code>Buildings.Fluid.FixedResistances.PressureDrop</code>.
</li>
<li>
August 5, 2011, by Michael Wetter:<br/>
Moved linearized pressure drop equation from the function body to the equation
section. With the previous implementation,
the symbolic processor may not rearrange the equations, which can lead
to coupled equations instead of an explicit solution.
</li>
<li>
June 20, 2011, by Michael Wetter:<br/>
Set start values for <code>m_flow</code> and <code>dp</code> to zero, since
most HVAC systems start at zero flow. With this change, the start values
appear in the GUI and can be set by the user.
</li>
<li>
April 2, 2011 by Michael Wetter:<br/>
Added <code>m_flow_nominal_pos</code> and <code>dp_nominal_pos</code> to allow
providing negative nominal values which will be used, for example, to set start
values of flow splitters which may have negative flow rates and pressure drop
at the initial condition.
</li>
<li>
March 27, 2011, by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
March 23, 2011 by Michael Wetter:<br/>
Added homotopy operator.
</li>
<li>
March 30, 2010 by Michael Wetter:<br/>
Changed base classes to allow easier initialization.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
Extracted pressure drop computation and implemented it in the
new model
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.BasicFlowModel\">
Buildings.Fluid.BaseClasses.FlowModels.BasicFlowModel</a>.
</li>
<li>
September 18, 2008, by Michael Wetter:<br/>
Added equations for the mass balance of extra species flow,
i.e., <code>C</code> and <code>mC_flow</code>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialResistance;
