within Buildings.Obsolete;
package Media "Package with medium models"
  extends Modelica.Icons.Package;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains obsolete media models.
They will be removed in future releases.
</p>
<p>
The media models in this package are
compatible with
<a href=\"modelica://Modelica.Media\">
Modelica.Media</a>
but the implementation is in general simpler, which often
leads to easier numerical problems and better convergence of the
models.
Due to the simplifications, the media model of this package
are generally accurate for a smaller temperature range than the
models in <a href=\"modelica://Modelica.Media\">
Modelica.Media</a>, but the smaller temperature range may often be
sufficient for building HVAC applications.
</p>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(
          points = {{-76,-80},{-62,-30},{-32,40},{4,66},{48,66},{73,45},{62,-8},{48,-50},{38,-80}},
          color={64,64,64},
          smooth=Smooth.Bezier),
        Line(
          points={{-40,20},{68,20}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-40,20},{-44,88},{-44,88}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{68,20},{86,-58}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-60,-28},{56,-28}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-60,-28},{-74,84},{-74,84}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{56,-28},{70,-80}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-76,-80},{38,-80}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-76,-80},{-94,-16},{-94,-16}},
          color={175,175,175},
          smooth=Smooth.None)}));
end Media;
