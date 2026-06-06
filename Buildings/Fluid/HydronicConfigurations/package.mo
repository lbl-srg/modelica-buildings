within Buildings.Fluid;
package HydronicConfigurations "Package with common hydronic configurations"
  extends Modelica.Icons.Package;

  annotation (Documentation(info="<html>
<p>
This package contains models for hydronic configurations commonly 
used in HVAC or DHC systems.
</p>
</html>"), Icon(graphics={
        Ellipse(
          extent={{8,66},{-46,14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),           Polygon(
        points={{7,28},{7,-26},{33,2},{7,28}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
          origin={-18,33},
          rotation=90),
        Polygon(
          points={{-20,-40},{-38,-14},{-2,-14},{-20,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-20,-14},{-20,14}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-20,66},{-20,80}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{40,-80},{40,80}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-20,-80},{-20,-66}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{0,-30},{0,10}},
          color={0,0,0},
          thickness=0.5,
          origin={10,-40},
          rotation=90),
        Line(
          points={{0,-30},{0,-12}},
          color={0,0,0},
          thickness=0.5,
          origin={-50,-40},
          rotation=90),
        Rectangle(
          extent={{-38,-30},{-58,-50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-40},{-38,-66},{-2,-66},{-20,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{1,-12},{-18,13},{18,13},{1,-12}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-8,-39},
          rotation=270)}));
end HydronicConfigurations;
