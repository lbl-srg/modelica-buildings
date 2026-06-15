within Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses;
package Characteristics "Functions for evaporative pad characteristics"
  annotation (Documentation(info="<html>
<p>
This package implements performance curves for evaporative pads,
and records for parameters that can be used with these performance
curves.
</p>
<p>
Performance curves for evaporative pads compute pressure drop and saturation efficiency as a function
of the air velocity.
The following performance curves are implemented:
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
<td>Pressure</td>
<td><a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics.pressureParameters\">
pressureParameters</a></td>
<td><a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics.pressure\">
pressure</a></td>
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
