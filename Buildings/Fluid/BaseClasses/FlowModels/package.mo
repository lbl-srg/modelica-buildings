within Buildings.Fluid.BaseClasses;
package FlowModels "Flow models for pressure drop calculations"
  extends Modelica.Icons.BasesPackage;


annotation (Documentation(info="<html>
<p>
This package contains basic flow models that are used by the
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
the power-law relation is replaced by a function that has a finite slope
near zero pressure drop. This is done for numerical reasons, and to approximate
laminar flow, although the implementation does not use a linear function.
</p>
<h4>Implementation</h4>
<p>
The four main functions are
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>,
</li>
<li>
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>,
</li>
<li>
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>, and
</li>
<li>
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow</a>.
</li>
</ul>
These functions compute the mass flow rate or the pressure drop, respectively.
The first two functions assume that the flow resistance is quadratic in the mass flow rate,
and the other two functions allow for a flow exponent between <i>1</i> and <i>2</i>.
All these functions are two times continuously differentiable.
First and second order derivatives are provided
in the function that have the suffix <code>_der</code> and <code>_der2</code>.
</p>
<p>
For the <code>powerLaw</code> functions, the coefficients that are an argument to the
functions can be computed using the function
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLawData\">
Buildings.Fluid.BaseClasses.FlowModels.powerLawData</a>.
This computation is done outside the above functions because the arguments generally
are all parameters, and hence precomputing them avoid repetitive evaluation.
</p>
</html>", revisions="<html>
<ul>
<li>
June 15, 2026, by Michael Wetter:<br/>
Updated documentation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4620\">Buildings, #4620</a>.
</li>
<li>
April 10, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowModels;
