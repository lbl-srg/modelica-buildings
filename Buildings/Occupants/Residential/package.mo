within Buildings.Occupants;
package Residential "Package with models to simulate occupant behaviors in resident buildings"
    extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains models to simulate occupant behaviors in residential buildings.
</p>
</html>"),
  Icon(graphics={
      Rectangle(
        extent={{-64,34},{64,-74}},
        lineColor={150,150,150},
        fillPattern=FillPattern.Solid,
        fillColor={150,150,150}),
      Polygon(
        points={{0,76},{-78,34},{80,34},{0,76}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
        extent={{12,-36},{42,-2}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-50,-74},{-12,-2}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}));
end Residential;
