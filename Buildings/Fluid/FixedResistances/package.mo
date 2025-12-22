within Buildings.Fluid;
package FixedResistances "Package with models for fixed flow resistances"
  extends Modelica.Icons.Package;

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
A similar model is
<a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PressureDropNotFullyTurbulent\">
Buildings.Fluid.FixedResistances.Validation.PressureDropNotFullyTurbulent</a>
except that the actual resistance can be scaled using the equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
k = m &frasl;
&Delta;p<sup>1/m</sup>,
</p>
<p>
where <i>m &isin; [0.5, 1]</i> is a flow exponent, allowing setting values between <i>0.5</i>,
which would be fully turbulent, and <i>1</i>, which would be fully laminar,
as such intermediate values are typical for air filters and data center cold plates.
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
</html>"),
    Icon(graphics={
        Ellipse(
          extent={{-45,19},{45,-19}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=180,
          origin={59,1},
          rotation=90),
        Rectangle(
          extent={{-60,46},{60,-44}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,46},{-40,-44}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{52,45.4},{60,-43.2}},
          lineColor={255,255,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end FixedResistances;
