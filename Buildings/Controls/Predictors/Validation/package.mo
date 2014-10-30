within Buildings.Controls.Predictors;
package Validation "Collection of models that validate the load predictors"
  extends Modelica.Icons.ExamplesPackage;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains models that use the load predictor with
simple input data which may not be realistic, but for which the correct
output can be obtained through inspection.
The examples plot various outputs, which have been verified against these
exact outputs. These model outputs are stored as reference data to
allow continuous validation whenever models in the library change.
</p>
</html>"));
end Validation;
