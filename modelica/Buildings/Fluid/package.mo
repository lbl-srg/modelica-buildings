within Buildings;
package Fluid "Package with models for fluid flow systems"


package UsersGuide "User's Guide"

  annotation (DocumentationClass=true, Documentation(info="<html>
The package <b>Buildings.Fluid</b> consists of models
for pressure driven mass flow rate.
The models have the same interface as models of the package
<a href=\"Modelica:Modelica.Fluid\">Modelica.Fluid</a>, 
but have in general a simpler set of parameters that may be better 
suited if the models are used in early design of building systems. 
For example, in addition to the detailed pipe model from Modelica.Fluid, 
this package also contains models for which a user has to specify 
the mass flow and pressure drop at a nominal flow rate, 
which is typically more readily available prior to the detailed 
HVAC system design.
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
