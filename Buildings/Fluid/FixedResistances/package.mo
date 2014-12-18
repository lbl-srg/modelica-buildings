within Buildings.Fluid;
package FixedResistances "Package with models for fixed flow resistances (pipes, diffusers etc.)"
  extends Modelica.Icons.VariantsPackage;
annotation (preferredView="info", Documentation(info="<html>
This package contains components models for fixed flow resistances.
By fixed flow resistance, we mean resistances that do not change the
flow coefficient
<p align=\"center\" style=\"font-style:italic;\">
k = m &frasl;
&radic;<span style=\"text-decoration:overline;\">&Delta;P</span>.
</p>
<p>
For models of valves and air dampers, see
<a href=\"modelica://Buildings.Fluid.Actuators\">
Buildings.Fluid.Actuators</a>.
For models of flow resistances as part of the building constructions, see
<a href=\"modelica://Buildings.Airflow.Multizone\">
Buildings.Airflow.Multizone</a>.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.FixedResistanceDpM\">
Buildings.Fluid.FixedResistances.FixedResistanceDpM</a>
is a fixed flow resistance that takes as parameter a nominal flow rate and a nominal pressure drop. The actual resistance is scaled using the above equation.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.LosslessPipe\">
Buildings.Fluid.FixedResistances.LosslessPipe</a>
is an ideal pipe segment with no pressure drop. It is primarily used
in models in which the above pressure drop model need to be replaced by a model with no pressure drop.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM\">
Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM</a>
can be used to model flow splitters or flow merges.
</p>
</html>"));

end FixedResistances;
