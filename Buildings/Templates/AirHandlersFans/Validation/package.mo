within Buildings.Templates.AirHandlersFans;
package Validation
  extends Modelica.Icons.ExamplesPackage;

  annotation (
  preferredView="info",
  Documentation(info="<html>
<p>
This package contains models validating the templates from
<a href=\"modelica://Buildings.Templates.AirHandlersFans\">
Buildings.Templates.AirHandlersFans</a>
for different system configurations.
</p>
<p>
Each system configuration is specified by extending the original template class
to create a so-called configuration class (under 
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject\">
Buildings.Templates.AirHandlersFans.Validation.UserProject</a>),
that is instantiated in the validation model.
</p>
<p>
The models also illustrate parameter propagation from a top-level 
HVAC system record.
</p>
</html>"));
end Validation;
