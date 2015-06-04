within Buildings.Electrical.AC.ThreePhasesUnbalanced;
package Lines "Package with transmission line models for three-phase unbalanced AC systems"
  extends Modelica.Icons.Package;


annotation (Icon(graphics={
      Ellipse(
        extent={{42,6},{18,-30}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Line(
        points={{30,6},{-52,6},{-62,6},{-70,-12},{-62,-30},{-50,-30},{30,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{-68,-12},{-86,-12}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{56,-12},{30,-12}},
        color={0,0,0},
        smooth=Smooth.None)}), Documentation(revisions="<html>
<ul>
<li>
October 8, 2014, by Marco Bonvini:<br/>
Revised package: added examples, checked results and added unit tests.
</li>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
This package contains models for transmission lines and electrical networks
of AC three-phase unbalanced systems.
</p>
</html>"));
end Lines;
