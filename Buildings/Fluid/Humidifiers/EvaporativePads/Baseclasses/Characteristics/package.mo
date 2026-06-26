within Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses;
package Characteristics "Performance curves for evaporative pad characteristics"
  annotation (Documentation(info="<html>
<p>
This package implements performance curves for evaporative pads, and records for
parameters that can be used with these performance curves.
</p>
<p>
A performance curve for evaporative pads computes saturation efficiency as a
function of the air velocity through cubic hermite splines. The following
performance curve is implemented:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Independent variable</th>
<th>Dependent variable</th>
<th>Record for performance data</th>
<th>Function</th>
</tr>
<tr>
<td>Air velocity</td>
<td>Saturation efficiency</td>
<td><a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics.saturationEfficiencyParameters\">
saturationEfficiencyParameters</a></td>
<td><a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics.saturationEfficiency\">
saturationEfficiency</a></td>
</tr>
</table>
</html>"));
end Characteristics;
