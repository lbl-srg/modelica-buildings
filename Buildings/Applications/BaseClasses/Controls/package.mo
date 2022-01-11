within Buildings.Applications.BaseClasses;
package Controls "Package with control components for Buildings.Applications examples"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
Collection of models for the control of equipment in
<a href=\"modelica://Buildings.Applications\">Buildings.Applications</a>.
</p>
</html>"),
  Icon(graphics={
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
      Rectangle(
        origin={0,35.1488},
        fillColor={255,255,255},
        extent={{-30.0,-20.1488},{30.0,20.1488}}),
      Polygon(
        origin={-40,35},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{10.0,0.0},{-5.0,5.0},{-5.0,-5.0}}),
      Line(
        origin={-51.25,0},
        points={{21.25,-35.0},{-13.75,-35.0},{-13.75,35.0},{6.25,35.0}}),
      Line(
        origin={51.25,0},
        points={{-21.25,35.0},{13.75,35.0},{13.75,-35.0},{-6.25,-35.0}}),
      Rectangle(
        origin={0,-34.851},
        fillColor={255,255,255},
        extent={{-30.0,-20.1488},{30.0,20.1488}})}));
end Controls;
