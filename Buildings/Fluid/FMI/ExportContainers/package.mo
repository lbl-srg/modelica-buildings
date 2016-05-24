within Buildings.Fluid.FMI;
package ExportContainers "Package with containers to export thermofluid flow models"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains containers that can be used, either with replaceable models
or through object inheritance, to export HVAC models, HVAC systems and
thermal zones.
See the <a href=\"modelica://Buildings.Fluid.FMI.UsersGuide\">
Buildings.Fluid.FMI.UsersGuide</a> for instructions.
</p>
</html>"),
  Icon(graphics={
      Rectangle(
        extent={{-80,-76},{80,-50}},
        pattern=LinePattern.None,
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{2,-50},{-60,6},{60,6},{2,-50}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-8,84},{10,-14}},
        pattern=LinePattern.None,
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid)}));
end ExportContainers;
