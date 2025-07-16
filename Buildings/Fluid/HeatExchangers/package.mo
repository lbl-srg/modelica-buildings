within Buildings.Fluid;
package HeatExchangers "Package with heat exchanger models"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
This package contains models for heat exchangers with and without humidity condensation.
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-82,63},{86,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-84,-57},{84,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,88},{56,-84}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(points={{56,88},{-54,-84}}, color={0,0,0})}));
end HeatExchangers;
