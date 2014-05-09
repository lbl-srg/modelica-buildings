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
        extent={{-72,72},{66,-70}},
        lineColor={95,95,95},
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
        extent={{-58,60},{54,2}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255}),
      Rectangle(
        extent={{-14.5,6.5},{14.5,-6.5}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255},
        origin={-66.5,-34.5},
        rotation=90),
      Rectangle(
        extent={{-14.5,6.5},{14.5,-6.5}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255},
        origin={59.5,-34.5},
        rotation=90),
      Rectangle(
        extent={{-14.5,6.5},{14.5,-6.5}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255},
        origin={-32.5,-4.5},
        rotation=180),
      Rectangle(
        extent={{4,-10},{54,-58}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255}),
      Rectangle(
        extent={{-14.5,6.5},{14.5,-6.5}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255},
        origin={29.5,-4.5},
        rotation=180),
      Rectangle(
        extent={{-14.5,6.5},{14.5,-6.5}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255},
        origin={-4.5,65.5},
        rotation=180),
      Polygon(
        points={{-18,50},{-6,62},{-4,80},{-10,80},{0,90},{8,80},{4,80},{0,58},{
            -14,46},{-18,50}},
        lineColor={0,0,0},
        smooth=Smooth.None,
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{16,18},{28,6},{30,-12},{24,-12},{34,-22},{42,-12},{38,-12},{34,
            10},{20,22},{16,18}},
        lineColor={0,0,0},
        smooth=Smooth.None,
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{13,18},{1,6},{-1,-12},{5,-12},{-5,-22},{-13,-12},{-9,-12},{-5,
            10},{9,22},{13,18}},
        lineColor={0,0,0},
        smooth=Smooth.None,
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        origin={71,-36},
        rotation=90),
      Rectangle(
        extent={{-60,-10},{-10,-58}},
        lineColor={255,255,255},
        fillPattern=FillPattern.Solid,
        fillColor={255,255,255}),
      Polygon(
        points={{-44,-14},{-32,-2},{-30,16},{-36,16},{-26,26},{-18,16},{-22,16},
            {-26,-6},{-40,-18},{-44,-14}},
        lineColor={0,0,0},
        smooth=Smooth.None,
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-13,18},{-1,6},{1,-12},{-5,-12},{5,-22},{13,-12},{9,-12},{5,10},
            {-9,22},{-13,18}},
        lineColor={0,0,0},
        smooth=Smooth.None,
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        origin={-67,-36},
        rotation=90)}));
end Airflow;
