within Buildings.Fluid.FMI.Examples.FMUs;
package Validation "Collection of validation models"
  extends Modelica.Icons.ExamplesPackage;


annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains validation models for the classes in
<a href=\"modelica://Buildings.Fluid.FMI.Examples\">
Buildings.Fluid.FMI.Examples</a>.
The test are done for different media, with and without flow
reversal, and for air with zero, one or two contaminants.
</p>
<p>
Note that most validation models contain simple input data
or systems which may not be realistic, but are useful
to validate that the models are implemented correctly.
These model outputs are stored as reference data and
used for continuous validation whenever models in the library change.
</p>
</html>"));
end Validation;
