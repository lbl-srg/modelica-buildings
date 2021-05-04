within Buildings.Controls.OBC.CDL.Logical;
package Validation
  "Collection of models that validate the logical blocks of the CDL"
  annotation (
    preferredView="info",
    Documentation(
      info="<html>
<p>
This package contains models that validate the blocks in
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical\">
Buildings.Controls.OBC.CDL.Logical</a>.
</p>
<p>
The examples plot various outputs, which have been verified against
analytical solutions. These model outputs are stored as reference data to
allow continuous validation whenever models in the library change.
</p>
</html>"),
    Icon(
      graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Polygon(
          origin={8.0,14.0},
          lineColor={78,138,73},
          fillColor={78,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}));
end Validation;
