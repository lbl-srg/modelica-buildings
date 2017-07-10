within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences;
package Validation "Package with validation models"
  extends Modelica.Icons.ExamplesPackage;


annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Polygon(
          origin={8,14},
          lineColor={78,138,73},
          fillColor={78,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}),
Documentation(revisions="<html>
</html>", info="<html>
<p>
This package contains models that validate the control sequences.
The examples plot various outputs, which have been verified against
analytical solutions. These model outputs are stored as reference data to
allow continuous validation whenever models in the library change.
</p>
</html>"));
end Validation;
