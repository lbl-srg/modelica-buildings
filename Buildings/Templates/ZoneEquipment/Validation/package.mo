within Buildings.Templates.ZoneEquipment;
package Validation "Package with validation models"
  extends Modelica.Icons.ExamplesPackage;

  annotation (
  preferredView="info",
  Documentation(info="<html>
<p>
This package contains models validating the templates within
<a href=\"modelica://Buildings.Templates.ZoneEquipment\">
Buildings.Templates.ZoneEquipment</a>
for various system configurations.
</p>
<p>
Each system configuration is specified by extending the original template class
to create a so-called configuration class (under
<a href=\"modelica://Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment\">
Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment</a>),
that is instantiated in the validation model.
</p>
</html>"));
end Validation;
