within Buildings.Fluid.BaseClasses;
package FlowModels "Flow models for pressure drop calculations"
  extends Modelica.Icons.BasesPackage;
annotation (Documentation(info="<html>
This package contains a basic flow model that is used by the
various models that compute pressure drop.
Because the density does not change signficantly in heating,
ventilation and air conditioning systems for buildings,
this model computes the pressure drop based on the mass flow
rate and not the volume flow rate. This typically leads to simpler
equations because it does not require
the mass density, which changes when the flow is reversed.
Although, for conceptual design of building energy system, there is
in general not enough information available that would warrant a more
detailed pressure drop calculation.
If a more detailed computation of the flow resistance is needed,
then a user can use models from the
<code>Modelica.Fluid</code> library.
</html>", revisions="<html>
<ul>
<li>
April 10, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowModels;
