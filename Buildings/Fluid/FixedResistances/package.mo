within Buildings.Fluid;
package FixedResistances "Package with models for fixed flow resistances"
  extends Modelica.Icons.VariantsPackage;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains component models for fixed flow resistances.
By fixed flow resistance, we mean resistances that do not change the
flow coefficient
</p>
<p align=\"center\" style=\"font-style:italic;\">
k = m &frasl;
&radic;<span style=\"text-decoration:overline;\">&Delta;p</span>.
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
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a>
is a fixed flow resistance that takes as parameter a nominal flow rate and a nominal pressure drop. The actual resistance is scaled using the above equation.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.HydraulicDiameter\">
Buildings.Fluid.FixedResistances.HydraulicDiameter</a>
is a fixed flow resistance that takes as parameter a nominal flow rate and
a hydraulic diameter. The actual resistance is scaled using the above equation.
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
<a href=\"modelica://Buildings.Fluid.FixedResistances.Junction\">
Buildings.Fluid.FixedResistances.Junction</a>
can be used to model flow splitters or flow merges.
</p>
</html>"));
end FixedResistances;
