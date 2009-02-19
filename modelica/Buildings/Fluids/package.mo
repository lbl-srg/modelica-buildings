within Buildings;
package Fluids "Package with models for fluid flow systems"
annotation (preferedView="info", Documentation(info="<html>
This package contains components for fluid flow systems such as
pumps, valves and sensors. For other fluid flow models, see 
<a href=\"Modelica:Modelica_Fluid\">Modelica_Fluid</a>.
</html>"));


package UsersGuide "User Guide"

  annotation (DocumentationClass=true, Documentation(info="<html>
<h3><font color=\"#008000\" size=5>Users Guide</font></h3>
<p>
Package <b>Fluids</b> consists of models
for pressure driven mass flow rate.
The models have the same interface as models of the package
<a href=\"Modelica:Modelica_Fluid\">Modelica_Fluid</a>, 
but have in general a simpler set of parameters that may be better 
suited if the models are used in early design of building systems. 
For example, in addition to the detailed pipe model from Modelica_Fluid, 
this package also contains models for which a user has to specify 
the mass flow and pressure drop at a nominal flow rate, 
which is typically more readily available prior to the detailed 
HVAC system design.
</p>
</html>"));

end UsersGuide;
end Fluids;
