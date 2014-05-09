within Buildings;
package Airflow "Package to compute airflow and contaminant transport between rooms"
  extends Modelica.Icons.Package;


annotation (
  preferredView="info",
  Documentation(info="<html>
This package provides
models to compute the air flow between different rooms and between
a room and the exterior environment.
For models that compute airflow in duct networks, see
<a href=\"modelica://Buildings.Fluid\">
Buildings.Fluid</a>.
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
      Rectangle(
        extent={{-72,66},{76,-80}},
        lineColor={95,95,95},
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
        extent={{-22.5,7},{22.5,-7}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255},
        origin={3.5,57},
        rotation=180),
      Rectangle(
        extent={{-52,48},{54,-62}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255}),
      Rectangle(
        extent={{-23.5,8},{23.5,-8}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255},
        origin={-61.5,-2},
        rotation=270),
      Polygon(
        points={{-82,2},{-42,2},{-42,14},{-22,-4},{-42,-22},{-42,-10},{-82,-10},
            {-82,2}},
        lineColor={0,0,0},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={0,0,0}),
      Polygon(
        points={{-30,6},{10,6},{10,18},{30,0},{10,-18},{10,-6},{-30,-6},{-30,6}},

        lineColor={0,0,0},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={0,0,0},
        origin={4,58},
        rotation=90)}));
end Airflow;
