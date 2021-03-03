within Buildings.Experimental.Templates.AHUs;
package Validation
  extends Modelica.Icons.ExamplesPackage;

annotation (Documentation(info="<html>
<p>
This package contains models validating the AHU templates for different 
system configurations.
Two types of configuring workflow are illustrated:
</p>
<ul>
<li>
one where the configuration happens when extending from the template to
create a specialized class (under UserProject), that the validation model
then instantiates (this is most likely the preferred workflow),
</li>
<li>
another one where the configuration happens when instantiating the template
directly in the validation model.
</li>
</ul>
<p>
The preferred workflow also illustrates parameter propagation from a top
level AHU record, relying on specialized record classes that could be 
generated along the specialized system models.
</p>
</html>"));
end Validation;
