within Buildings.Fluid.BaseClasses;
package FlowModels "Flow models for pressure drop calculations"
  extends Modelica.Icons.BasesPackage;


annotation (Documentation(info="<html>
<p>
This package contains a basic flow model that is used by the
various models that compute pressure drop.
</p>
<h4>Assumption and limitations</h4>
<p>
Because the density does not change signficantly in heating,
ventilation and air conditioning systems for buildings,
the flow models compute the pressure drop based on the mass flow
rate and not the volume flow rate. This typically leads to simpler
equations because it does not require
the mass density, which changes when the flow is reversed.
Although, for conceptual design of building energy system, there is
in general not enough information available that would warrant a more
detailed pressure drop calculation.
If a more detailed computation of the flow resistance is needed,
then a user can use models from the
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a> library.
</p>
<p>
All functions have an argument <code>m_flow_turbulent</code> that determines where the
flow transitions to fully turbulent flow. For smaller mass flow rates,
the quadratic relation is replaced by a function that has finite slope
near zero pressure drop. This is done for numerical reasons, and to approximate
laminar flow, although the implementation does not use a linear function.
</p>
<h4>Implementation</h4>
<p>
The two main functions are
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>
and
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>
that compute the mass flow rate or the pressure drop, respectively.
Both functions are two times continuously differentiable.
First and second order derivatives are provided
in the function that have the suffix <code>_der</code> and <code>_der2</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 10, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowModels;
