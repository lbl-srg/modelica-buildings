within Buildings.Fluid.FMI;
package Conversion "Package with blocks that convert between different connectors"
  extends Modelica.Icons.Package;


  annotation (Icon(graphics={
        Polygon(
          points={{90,0},{30,20},{30,-20},{90,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{30,0}}, color={191,0,0})}), Documentation(info="<html>
<p>
This package contains blocks to convert between scalar input-output signals
and the composite input-output connectors
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces.Inlet\">
Buildings.Fluid.FMI.Interfaces.Inlet</a>
and
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces.Outlet\">
Buildings.Fluid.FMI.Interfaces.Outlet</a>.
</p>
</html>"));
end Conversion;
