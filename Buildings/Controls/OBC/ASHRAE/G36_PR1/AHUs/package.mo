within Buildings.Controls.OBC.ASHRAE.G36_PR1;
package AHUs "AHU Sequences as defined in guideline G36"
  extends Modelica.Icons.Package;

  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),      Rectangle(
            extent={{-60,60},{60,-60}},
            lineColor={0,0,127},
            lineThickness=0.5)}),
  Documentation(info="<html>
<p>
This package contains AHU control sequences from ASHRAE Guideline 36.
</p>
</html>"));
end AHUs;
