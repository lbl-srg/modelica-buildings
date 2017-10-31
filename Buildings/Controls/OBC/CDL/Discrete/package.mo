within Buildings.Controls.OBC.CDL;
package Discrete "Package with discrete input/output blocks with fixed sample period"

  extends Modelica.Icons.Package;

  annotation (Documentation(info="<html>
<p>
This package contains discrete control blocks
with fixed sample period.
Every component of this package is structured in the following way:
</p>
<ol>
<li> A component has continuous Real input and output signals.</li>
<li> The input signals are sampled by the given sample period
     defined via parameter <code>samplePeriod</code>.
     The first sample instant is defined by the parameter <code>startTime</code>.
</li>
<li> The output signals are computed from the sampled input signals.
</li>
</ol>

</html>",
revisions="<html>
<ul>
<li>
December 22, 2016, by Michael Wetter:<br/>
Firt implementation, based on the blocks from the Modelica Standard Library.
</li>
</ul>
</html>"),
Icon(graphics={
        Line(points={{-88,0},{-45,0}}, color={95,95,95}),
        Ellipse(
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-45,-10},{-25,10}}),
        Line(points={{-35,0},{24,52}}, color={95,95,95}),
        Ellipse(
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{25,-10},{45,10}}),
        Line(points={{45,0},{82,0}}, color={95,95,95})}));
end Discrete;
