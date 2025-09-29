within Buildings.Fluid;
package Delays "Package with delay models"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains component models for transport delays in
piping networks.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.Delays.DelayFirstOrder\">
Buildings.Fluid.Delays.DelayFirstOrder</a>
approximates transport delays using a first order differential equation.
</p>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-32,-34},{-24,-4},{-8,20},{20,34},{54,36}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-32,-34},{-52,-34}},
          color={0,0,0},
          thickness=0.5)}));
end Delays;
