within Buildings;
package Fluid "Package with models for fluid flow systems"
  extends Modelica.Icons.Package;


package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (DocumentationClass=true, Documentation(info="<html>
The package <code>Buildings.Fluid</code> consists of models
for pressure driven mass flow rate and for heat and moisture
exchange in fluid flow networks.
</p>
<p>
The models have the same interface as models of the package
<a href=\"Modelica:Modelica.Fluid\">Modelica.Fluid</a>, 
but have in general a simpler set of parameters that may be better 
suited if the models are used in early design of building systems. 
For example, in addition to the detailed pipe model from 
<a href=\"Modelica:Modelica.Fluid\">Modelica.Fluid</a>,
this package also contains models for which a user has to specify 
the mass flow and pressure drop at a nominal flow rate, 
which is typically more readily available prior to the detailed 
HVAC system design.
</p>
<h4>Computation of flow resistance</h4>
<p>
Most component models compute pressure drop as a function of flow rate.
If their pressure drop at the nominal conditions is set to zero, 
for example by setting the parameter value <code>dp_nominal=0</code>, then the 
equation for the pressure drop is removed from the model.
This allows, for example, 
to model a heating and a cooling coil in series, and lump their pressure drops
into a single element, thereby reducing the dimension of the nonlinear system
of equations.
</p>
<p>
The flow resistance is computed as
<p align=\"center\" style=\"font-style:italic;\">
  k = m &frasl; &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span> 
</p>
where <i>m</i> is the mass flow rate and <i>&Delta;p</i> is the pressure drop.
For <i>|m| &lt; &delta;<sub>m</sub> m<sub>0</sub></i>, 
where <i>&delta;<sub>m</sub></i> is a parameter and 
<i>m<sub>0</sub></i> is the mass flow rate at the nominal operating point, the 
equation is linearized.
The pressure drop is computed as a function of mass flow rate instead of
volume flow rate as this often leads to fewer equations. Otherwise,
the pressure drop would depend on the density and hence on temperature.
</p>
<p>
The flow coefficient <i>k</i> is typically computed based
on nominal values for the mass flow rate and the pressure drop, i.e.,
<i>k = m<sub>0</sub> &frasl; &radic;&nbsp;&Delta;p<sub>0</sub> &nbsp;
</i>.
This functional form has been used as in building HVAC systems, a more exact
computation of the pressure drop would require detailed knowledge of the duct or pipe
dimensions and the flow bends and junctions. This information is often not available during
early design. However, if a more detailed pressure drop calculation is required, then models from
<a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a> can be used in conjuction with models from the <code>Buildings</code> library.
</p>
<p>
In actuators such as valves and air dampers, <i>k</i> is a function of the control signal.
</p>
<h4>Computation of heat and mass balance</h4>
<p>
fixme: add documentation.
</p>
</html>"));

end UsersGuide;


annotation (
preferedView="info", Documentation(info="<html>
This package contains components for fluid flow systems such as
pumps, valves and sensors. For other fluid flow models, see 
<a href=\"Modelica:Modelica.Fluid\">Modelica.Fluid</a>.
</html>"));
end Fluid;
