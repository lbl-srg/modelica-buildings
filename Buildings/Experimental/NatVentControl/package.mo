within Buildings.Experimental;
package NatVentControl "Natural ventilation control sequences"



annotation (Icon(graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={217,67,180},
        lineThickness=1,
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-60,60},{60,-60}},
        lineColor={217,67,180},
        lineThickness=1,
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Line(
        points={{0,60},{0,-60}},
        color={217,67,180},
        thickness=1),
      Line(
        points={{-60,0},{60,0}},
        color={217,67,180},
        thickness=1)}));
end NatVentControl;
