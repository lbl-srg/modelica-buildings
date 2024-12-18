within Buildings.Fluid.HeatExchangers.ThermalWheels;
package Sensible "Package with sensible heat recovery devices"
  extends Modelica.Icons.Package;

annotation (Documentation(info="<html>
<p>
This package contains component models for sensible heat recovery wheels.
</p>
</html>"), Icon(graphics={
        Rectangle(
          extent={{-80,63},{88,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-82,-57},{86,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{8,88},{40,-90}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,88},{24,-90}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-36,88},{-2,-90}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-18,88},{24,88}}, color={28,108,200}),
        Line(points={{-20,-90},{24,-90}}, color={28,108,200})}));
end Sensible;
