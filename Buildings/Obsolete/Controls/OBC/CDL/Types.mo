within Buildings.Obsolete.Controls.OBC.CDL;
package Types "Package with type definitions"

  type Reset = enumeration(
      Disabled "Disabled",
      Parameter "Use parameter value",
      Input "Use input signal") "Options for integrator reset" annotation (
      Documentation(info="<html>
<p>
Enumeration to define the choice of integrator reset.
Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>Disabled</code></td>
<td>
Use this setting to disable the integrator reset.
</td></tr>
<tr><td><code>Parameter</code></td>
<td>
Use this setting to use reset the integrator to the value of the parameter.
</td></tr>
<tr><td><code>Input</code></td>
<td>Use this setting to reset the integrator to the value obtained
from the input signal.
</td></tr>
 </table>
</html>",   revisions="<html>
<ul>
<li>
March 23, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
annotation (Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"), Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),                  Polygon(
          origin={-12.167,-23},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{12.167,65},{14.167,93},{36.167,89},{24.167,20},{4.167,-30},
              {14.167,-30},{24.167,-30},{24.167,-40},{-5.833,-50},{-15.833,
              -30},{4.167,20},{12.167,65}},
          smooth=Smooth.Bezier,
          lineColor={0,0,0}), Polygon(
          origin={2.7403,1.6673},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{49.2597,22.3327},{31.2597,24.3327},{7.2597,18.3327},{-26.7403,
            10.3327},{-46.7403,14.3327},{-48.7403,6.3327},{-32.7403,0.3327},{-6.7403,
            4.3327},{33.2597,14.3327},{49.2597,14.3327},{49.2597,22.3327}},
          smooth=Smooth.Bezier)}));
end Types;
