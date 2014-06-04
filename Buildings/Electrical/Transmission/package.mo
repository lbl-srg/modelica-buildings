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
This package contains partial models of cables that can be used
to represent a generic line in a electric grid. The package contains 
several functions and records to parametrize the cables either using 
commercial or default values.
</p>
<p>
The package contains also a generalized model to represent an 
electric network.
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
