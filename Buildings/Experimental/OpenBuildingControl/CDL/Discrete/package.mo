within Buildings.Experimental.OpenBuildingControl.CDL;
package Discrete "Library of discrete input/output blocks with fixed sample period"

  extends Modelica.Icons.Package;








  annotation (Documentation(info="<html>
<p>
This package contains <code>discrete control blocks</code>
with <code>fixed sample period</code>.
Every component of this package is structured in the following way:
</p>
<ol>
<li> A component has <code>continuous real</code> input and output signals.</li>
<li> The <code>input</code> signals are <code>sampled</code> by the given sample period
     defined via parameter <code>samplePeriod</code>.
     The first sample instant is defined by parameter <code>startTime</code>.</li>
<li> The <code>output</code> signals are computed from the sampled input signals.</li>
</ol>
<p>
A <code>sampled data system</code> may consist of components of package <code>Discrete</code>
and of every other purely <code>algebraic</code> input/output block, such
as the components of packages <code>Modelica.Blocks.Math</code>,
<code>Modelica.Blocks.Nonlinear</code> or <code>Modelica.Blocks.Sources</code>.
</p>

</html>", revisions="<html>
<ul>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       New components TriggeredSampler and TriggeredMax added.</li>
<li><i>June 18, 2000</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized based on a corresponding library of Dieter Moormann and
       Hilding Elmqvist.</li>
</ul>
</html>"), Icon(graphics={
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
