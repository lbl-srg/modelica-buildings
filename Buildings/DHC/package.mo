within Buildings;
package DHC "Models for district heating and cooling systems"
  extends Modelica.Icons.Package;

  annotation (
    preferredView="info",
    Documentation(
      info="<html>
<p>
This package contains models for district heating and cooling (DHC) systems.
</p>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{30,72},{70,34}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-70,72},{-30,34}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-70,-34},{-30,-72}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{30,-34},{70,-72}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-60,34},{-60,20}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-40,34},{-40,20}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{60,34},{60,20}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{40,34},{40,20}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-60,-20},{-60,-34}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-40,-20},{-40,-34}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{40,-20},{40,-34}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{60,-20},{60,-34}},
          color={0,0,0},
          thickness=0.5),
        Rectangle(
          extent={{-80,20},{80,-20}},
          lineColor={0,0,0},
          lineThickness=0.5)}));
end DHC;
