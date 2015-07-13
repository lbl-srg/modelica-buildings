within Buildings.Media.Specialized;
package Air "Specialized implementation of air"
  extends Modelica.Icons.Package;


annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains a specialized implementation of air.
For typical building simulations, the media
<a href=\"modelica://Buildings.Media.Air\">Buildings.Media.Air</a>
should be used as it leads generally to faster simulation.
</p>
</html>"),
  Icon(graphics={
        Ellipse(
          extent={{-76,74},{-32,30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120}),
        Ellipse(
          extent={{-16,82},{28,38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120}),
        Ellipse(
          extent={{50,54},{94,10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120}),
        Ellipse(
          extent={{-20,28},{24,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120}),
        Ellipse(
          extent={{38,-36},{82,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120}),
        Ellipse(
          extent={{-34,-34},{10,-78}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120}),
        Ellipse(
          extent={{-88,-10},{-44,-54}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120})}));
end Air;
