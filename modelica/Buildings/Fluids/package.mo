package Fluids "Library to model fluid flow systems"
annotation (uses(Modelica(version="2.2.1")), Documentation(info="<html>

</html>"));


package UsersGuide "User Guide" 
  
  annotation (DocumentationClass=true, Documentation(info="<html>
<h3><font color=\"#008000\" size=5>Users Guide</font></h3>
<p>
Package <b>Fluids</b> consists of models
for pressure driven mass flow rate.
The models make use of Modelica_Fluid, but many models have a simpler
set of parameters that may be better suited if the models are used in early design of building systems. For example, in addition to the detailed pipe model from Modelica_Fluid, this package also contains models for which a user has to specify the mass flow and pressure drop at a nominal flow rate, which is typically more readily available prior to the detailed HVAC system design.
</html>"));
  
end UsersGuide;

end Fluids;
