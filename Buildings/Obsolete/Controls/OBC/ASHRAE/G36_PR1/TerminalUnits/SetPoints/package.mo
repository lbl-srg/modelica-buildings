within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits;
package SetPoints "Generic sequences of generating setpoints for terminal units control"

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains generic sequences for generating setpoints for various
terminal units control, according to ASHRAE Guideline 36, Part 5.B.
</p>
</html>"),
  Icon(graphics={
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
      Text(
        extent={{-100,100},{100,-100}},
        textColor={0,0,0},
        textString="S")}));
end SetPoints;
