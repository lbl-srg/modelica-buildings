within Buildings.Electrical;
package Transmission "Package with models for transmission lines"
  extends Modelica.Icons.Package;


annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
          {100,100}}), graphics={
      Ellipse(
        extent={{40,8},{16,-28}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Line(
        points={{28,8},{-54,8},{-64,8},{-72,-10},{-64,-28},{-52,-28},{28,-28}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{-70,-10},{-88,-10}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{54,-10},{28,-10}},
        color={0,0,0},
        smooth=Smooth.None)}), Documentation(info="<html>
<p>
This package contains cables that can be used
to represent a line in a electric grid. The package contains
several functions and records to parametrize cables either using
default values or values from commercial cables.
</p>
<p>
The packages
<a href=\"modelica://Buildings.Electrical.Transmission.Grids\">
Buildings.Electrical.Transmission.Grids</a>
and
<a href=\"modelica://Buildings.Electrical.Transmission.Benchmarks\">
Buildings.Electrical.Transmission.Benchmarks</a>
contain models of
electrical networks.
</p>
</html>", revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end Transmission;
