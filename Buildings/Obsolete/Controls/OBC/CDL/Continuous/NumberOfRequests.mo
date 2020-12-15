within Buildings.Obsolete.Controls.OBC.CDL.Continuous;
block NumberOfRequests
  "Outputs the number of signals that are above/below a certain threshold"
  extends Modelica.Icons.ObsoleteModel;

  parameter Integer nin "Number of inputs";
  parameter Real t=0 "Threshold";
  parameter Integer kind
    "Set to 0 for u>threShold, to 1 for >=, to 2 for <= or to 3 for <";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Number of input signals that violate the threshold"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u[nin] "Input signals"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
algorithm
  y := 0;
  for i in 1:nin loop
    if kind == 0 then
      if u[i] > t then
        y := y+1;
      end if;
    end if;
    if kind == 1 then
      if u[i] >= t then
        y := y+1;
      end if;
    end if;
    if kind == 2 then
      if u[i] <= t then
        y := y+1;
      end if;
    end if;
    if kind == 3 then
      if u[i] < t then
        y := y+1;
      end if;
    end if;
  end for;
  annotation (
defaultComponentName="numReq",
obsolete = "Obsolete model, this will be removed in future versions.",
Documentation(info="<html>
<p>
Block that outputs the number of inputs that exceed a threshold.
The parameter <code>kind</code> is used to determine the kind of the
inequality. The table below shows the allowed settings.
</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\" summary=\"Allowed parameter settings.\">
<tr>
<th>Value of parameter <code>kind</code></th>
<th>Output signal incremented by 1 for each <i>i &isin; {1, ..., nin}</i> if</th>
</tr>
<tr>
<td>0</td>
<td><code>u[i] &gt; t</code></td>
</tr>
<tr>
<td>1</td>
<td><code>u[i] &ge; t</code></td>
</tr>
<tr>
<td>2</td>
<td><code>u[i] &le; t</code></td>
</tr>
<tr>
<td>3</td>
<td><code>u[i] &lt; threShold</code></td>
</tr>
</table>
<p>
This model may be used to check how many rooms
exceed a temperature threshold.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 8, 2020, by Michael Wetter:<br/>
Moved the block to the obsolete package.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2124\">issue 2124</a>.
</li>
<li>
August 6, 2020, by Michael Wetter:<br/>
Renamed <code>threshold</code> to <code>t</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2076\">issue 2076</a>.
</li>
<li>
January 10, 2017, by Milica Grahovac:<br/>
Initial CDL implementation.
</li>
<li>
November 21, 2011, by Michael Wetter:<br/>
Improved documentation.
</li>
<li>
November 25, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-128,88},{-6,28}},
          lineColor={0,0,255},
          textString="%t"),
        Line(points={{-62,-6},{-4,24}}, color={0,0,255}),
        Line(points={{-4,24},{64,60}}, color={255,0,0}),
        Line(
          points={{-78,24},{78,24}},
          pattern=LinePattern.Dot),
        Line(points={{-86,4},{-18,24}}, color={0,0,255}),
        Line(points={{-18,24},{66,54}}, color={255,0,0}),
        Line(points={{-78,-50},{78,-50}}),
        Line(points={{70,-46},{78,-50}}),
        Line(points={{70,-54},{78,-50}}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}));
end NumberOfRequests;
