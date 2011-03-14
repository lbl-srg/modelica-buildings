within Buildings;
package Fluid "Package with models for fluid flow systems"


package UsersGuide "User's Guide"

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
For example, in addition to the detailed pipe model from <code>Modelica.Fluid</code>, 
this package also contains models for which a user has to specify 
the mass flow and pressure drop at a nominal flow rate, 
which is typically more readily available prior to the detailed 
HVAC system design.
</p>
<p>
Most component models compute their pressure drop. If their pressure
drop at the rating condition is set to zero, for example by setting
the parameter value <code>dp_nominal=0</code>, then the 
equation for the pressure drop is removed from the model.
This allows, for example, 
to model a heating and a cooling coil in series, and lump their pressure drops
into a single element, thereby reducing the dimension of the nonlinear system
of equations.
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
