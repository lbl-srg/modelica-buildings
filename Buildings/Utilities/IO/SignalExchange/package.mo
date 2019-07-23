within Buildings.Utilities.IO;
package SignalExchange "External Signal Exchange Package"
  extends Modelica.Icons.Package;


  annotation (Documentation(info="<html>
<p>
Package to allow overwriting of control signals by external programs and
reading of measurement signals by external programs.
</p>
</html>", Icon(graphics={Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,
              0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,10},{-10,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,10},{30,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-10,0},{10,0}}, color={0,0,0}),
        Line(
          points={{-60,0},{-30,0}},
          color={0,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{30,0},{60,0}},
          color={0,0,0},
          pattern=LinePattern.Dot),
        Polygon(
          points={{-80,10},{-80,-10},{-60,0},{-80,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{60,10},{60,-10},{80,0},{60,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)})));
end SignalExchange;
