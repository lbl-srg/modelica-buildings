within Buildings.Electrical.AC.ThreePhasesBalanced;
package Lines "Package with line models for three-phase balanced AC systems"
  extends Modelica.Icons.Package;


  annotation (Icon(graphics={
      Ellipse(
        extent={{44,6},{20,-30}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Line(
        points={{32,6},{-50,6},{-60,6},{-68,-12},{-60,-30},{-48,-30},{32,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{-66,-12},{-84,-12}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{58,-12},{32,-12}},
        color={0,0,0},
        smooth=Smooth.None)}), Documentation(info="<html>
<p>
This package contains models for transmission lines and electrical networks.
</p>
</html>", revisions="<html>
<ul>
<li>
August 24, 2014, by Marco Bonvini:<br/>
Revised User's guide.
</li>
</ul>
</html>"));
end Lines;
