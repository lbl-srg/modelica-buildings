within Buildings;
package Fluids "Package with models for fluid flow systems"
annotation (
  __Dymola_classOrder={
"UsersGuide",
"Actuators",
"Boilers",
"Chillers",
"Delays",
"FixedResistances",
"HeatExchangers",
"MassExchangers",
"MixingVolumes",
"Movers",
"Sensors",
"Sources",
"Storage",
"Types",
"Utilities",
"BaseClasses",
"Interfaces",
"Images"},
preferedView="info", Documentation(info="<html>
This package contains components for fluid flow systems such as
pumps, valves and sensors. For other fluid flow models, see 
<a href=\"Modelica:Modelica.Fluid\">Modelica.Fluid</a>.
</html>"));


package UsersGuide "User's Guide"

  annotation (DocumentationClass=true, Documentation(info="<html>
The package <b>Building.Fluids</b> consists of models
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
end Fluids;
