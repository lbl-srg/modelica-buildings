within Buildings.Fluid;
package Movers "Package with fan and pump models"
annotation (Documentation(info="<html>
<p>This package contains models that can be used for fans and pumps. </p>
<p>The models with names FlowMachine_* are similar to the pump models in the package <a href=\"Modelica.Fluid.Machines\">Modelica.Fluid.Machines</a>. However, the models in this package differ primarily in the following points:
<ul>
<li>
For the model with prescribed pressure, the input signal is the 
pressure difference between the two ports, and not the absolute
pressure at <code>port_b</code>.
</li>
<li>
The pressure calculations are based on total pressure in Pascals instead of the pump head in meters. This change was done to avoid ambiguities in the parameterization if the models are used as a fan with air as the medium. The original formulation in <a href=\"Modelica.Fluid.Machines\">Modelica.Fluid.Machines</a> converts head to pressure using the density <code>medium.d</code>. Therefore, for fans, head would be converted to pressure using the density of air. However, for fans, manufacturers typically publish the head in millimeters water (mmH20). Therefore, to avoid confusion when using these models with media other than water, they have been changed to use total pressure in Pascals instead of head in meters.
</li>
<li>
Additional performance curves have been added to the package <a href=\"Modelica:Buildings.Fluid.Movers.BaseClasses.Characteristics\">Buildings.Fluid.Movers.BaseClasses.Characteristics</a>.
</li>
</ul>
</p>
<p>
For a detailed description of the models with names <code>FlowMachine_*</code>,
see their base class <a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine\">
Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine.</a>
</p>.
The model <a href=\"Modelica://Buildings.Fluid.Movers.FlowMachinePolynomial\">
Buildings.Fluid.Movers.FlowMachinePolynomial</a> is in this package for compatibility 
with older versions of this library. It is recommended to use the other models as they optionally
allow use of a medium volume that provides state variables which are needed in some models 
when the flow rate is zero.
</html>"));
end Movers;
