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
        extent={{-72,66},{68,-74}},
        lineColor={95,95,95},
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
        extent={{-24,10},{24,-10}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255},
        origin={0,56},
        rotation=180),
      Rectangle(
        extent={{-50,46},{46,-56}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255}),
      Rectangle(
        extent={{-24,11},{24,-11}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255},
        origin={-61,0},
        rotation=270),
      Polygon(
        points={{-84,6},{-44,6},{-44,18},{-24,0},{-44,-18},{-44,-6},{-84,-6},{
            -84,6}},
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
        origin={0,62},
        rotation=90)}));
end Airflow;
