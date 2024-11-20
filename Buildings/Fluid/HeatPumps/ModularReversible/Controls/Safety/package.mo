within Buildings.Fluid.HeatPumps.ModularReversible.Controls;
package Safety "Contains typical safety controllers for heat pumps"
  extends Modelica.Icons.Package;

  annotation (Icon(graphics={
        Ellipse(
          extent={{-48,-12},{48,80}},
          lineColor={0,0,0},
          fillColor={91,91,91},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,0},{36,68}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,34},{60,-66}},
          lineColor={0,0,0},
          fillColor={91,91,91},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,-16},{10,-56}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,-26},{16,2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>
  Package with safety controls typically
  applied in heat pumps and chiller devices.
</p>
</html>"));
end Safety;
