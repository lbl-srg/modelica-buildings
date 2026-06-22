within Buildings.Fluid;
package MixingVolumes "Package with mixing volumes"
  extends Modelica.Icons.Package;

annotation (Documentation(info="<html>
<p>
This package contains models for completely mixed volumes.
</p>
<p>
For most situations, the model
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a> should be used.
The other models are only of interest if water should be added to
or subtracted from the fluid volume, such as in a
coil with water vapor condensation.
</p>
</html>"), Icon(graphics={
        Ellipse(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-58,10},{0,-8}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Ellipse(
          extent={{0,10},{58,-8}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{0,0},{0,42}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier)}));
end MixingVolumes;
