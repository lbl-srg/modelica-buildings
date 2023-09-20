within Buildings;
package Templates "Package with templates for various HVAC systems"
  extends Modelica.Icons.Package;

  annotation (Documentation(info="<html>
<p>
This package contains templates for common HVAC systems.
A template is defined as a user-configurable model that can represent various
configurations of the same system. The templates include closed-loop controls as
implemented within
<a href=\"modelica://Buildings.Controls.OBC\">
Buildings.Controls.OBC</a>.
</p>
</html>"), Icon(graphics={Text(
          extent={{-100,100},{100,-100}},
          textColor={0,0,0},
          fontName="monospace",
          textStyle={TextStyle.Bold},
          textString="T")}));
end Templates;
