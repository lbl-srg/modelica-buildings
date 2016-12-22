within Buildings.Experimental.OpenBuildingControl.CDL;
package Discrete "Library of discrete input/output blocks with fixed sample period"

  extends Modelica.Icons.Package;








  annotation (Documentation(info="<html>
<p>
This package contains <b>discrete control blocks</b>
with <b>fixed sample period</b>.
Every component of this package is structured in the following way:
</p>
<ol>
<li> A component has <b>continuous real</b> input and output signals.</li>
<li> The <b>input</b> signals are <b>sampled</b> by the given sample period
     defined via parameter <b>samplePeriod</b>.
     The first sample instant is defined by parameter <b>startTime</b>.</li>
<li> The <b>output</b> signals are computed from the sampled input signals.</li>
</ol>
<p>
A <b>sampled data system</b> may consist of components of package <b>Discrete</b>
and of every other purely <b>algebraic</b> input/output block, such
as the components of packages <b>Modelica.Blocks.Math</b>,
<b>Modelica.Blocks.Nonlinear</b> or <b>Modelica.Blocks.Sources</b>.
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
