within Buildings.HeatTransfer;
package Sources "Thermal sources"
extends Modelica.Icons.SourcesPackage;

  annotation (   Documentation(info="<html>
This package is identical to
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources\">
Modelica.Thermal.HeatTransfer.Sources</a>, except that
the parameters <code>alpha</code> and <code>T_ref</code> have
been deleted in the models
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow</a> and
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>
 as these can cause division by zero in some fluid flow models.
</html>"));
end Sources;
