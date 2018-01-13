within Buildings.Controls.OBC.CDL.Continuous.Sources;
block TimeTable
  "Table look-up with respect to time and linear or periodic extrapolation"

  parameter Real table[:,:]
  "Table matrix (time = first column is time in seconds, unless timeScale <> 1)";
  parameter CDL.Types.Smoothness smoothness=CDL.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation";
  parameter CDL.Types.Extrapolation extrapolation=CDL.Types.Extrapolation.Periodic
    "Extrapolation of data outside the definition range";
  parameter Real offset[:]={0} "Offsets of output signals";
  parameter Modelica.SIunits.Time timeScale=1
    "Time scale of first table column. Set to 3600 if time in table is in hours";

  Interfaces.RealOutput y[nout] "Output of the table"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  final parameter Integer nout=size(table, 2)-1
    "Dimension of output vector";

  // CDL uses different enumerations for smoothness and for extrapolation
  // than the Modelica Standard Library. Hence, we cast the CDL
  // enumeration to the MSL enumaration.
  Modelica.Blocks.Sources.CombiTimeTable tab(
    final tableOnFile=false,
    final table=table,
    final columns=2:size(tab.table, 2),
    final smoothness=if smoothness == CDL.Types.Smoothness.LinearSegments then
                        Modelica.Blocks.Types.Smoothness.LinearSegments
                     else
                        Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final extrapolation=if extrapolation == CDL.Types.Extrapolation.HoldLastPoint then
                          Modelica.Blocks.Types.Extrapolation.HoldLastPoint
                        elseif extrapolation == CDL.Types.Extrapolation.LastTwoPoints then
                          Modelica.Blocks.Types.Extrapolation.LastTwoPoints
                        else
                          Modelica.Blocks.Types.Extrapolation.Periodic,
    final offset=offset,
    final startTime=0,
    final timeScale=timeScale) "Time table"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));

equation
  connect(tab.y, y) annotation (Line(points={{9,0},{110,0}}, color={0,0,127}));

annotation (
Documentation(info="<html>
<p>
Block that outputs values of a time table.
</p>
<p>
The block takes as a parameter a time table of the format
</p>
<pre>
table = [ 0*3600, 0;
          6*3600, 0;
          6*3600, 1;
         18*3600, 1;
         18*3600, 0;
         24*3600, 0];
</pre>
<p>
where the first column is time in seconds, and the remaining
column(s) are the table values.
Any number of columns can be specified.
The parameter <code>smoothness</code> determines how the table values
are interpolated. The following settings are allowed:
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><th><code>smoothness</code></th><th>Description</th></tr>
<tr>
  <td><code>CDL.Types.LinearSegments</code></td>
  <td>Table points are linearly interpolated.</td>
</tr>
<tr>
  <td><code>CDL.Types.ConstantSegments</code></td>
  <td>Table points are not interpolated,
      but the previous tabulated value is returned.</td>
</tr>
</table>

<p>
The parameter <code>extrapolation</code> determines how the table
values are extrapolated. The following settings are allowed:
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><th><code>extrapolation</code></th><th>Description</th></tr>
<tr>
  <td><code>CDL.Types.HoldLastPoint</code></td>
  <td>Hold the first or last table point outside of the table scope.</td>
</tr>
<tr>
  <td><code>CDL.Types.LastTwoPoints</code></td>
  <td>Extrapolate by using the derivative at the first or last table points
      outside of the table scope.</td>
</tr>
<tr>
  <td><code>CDL.Types.Periodic</code></td>
  <td>Repeat the table scope periodically with periodicity
      <code>(max(table[:, 1]-min(table[:, 1]))*timeScale)</code>.</td>
</tr>
</table>

<p>
The value of the parameter <code>offset</code> is added to the tabulated
values.
The parameters <code>timeScale</code> is used to scale the first column
of the table. For example, set <code>timeScale = 3600</code> if the first
column is in hour (because in CDL, the time unit is seconds).
</p>
<p>
If the table has only one row, no interpolation is performed and
the table values of this row are just returned.
</p>
<p>
An interval boundary is defined by two identical time values
following each other. For example
</p>
<pre>
   table = [0, 0;
            1, 0;
            1, 1;
            2, 3;
            3, 5;
            3, 2;
            4, 4;
            5, 5];
</pre>
<p>
defines three intervalls: 0..1, 1..3, 3..5. Within an interval the defined
interpolation method is applied (so the table outputs within an interval are
continuous if <code>smoothness = CDL.Types.LinearSegments</code>).
</p>
<p>
Example:
</p>
<pre>
  table = [0, 0;
           1, 0;
           1, 1;
           2, 4;
           3, 9;
           4, 16];
  smoothness = CDL.Types.LinearSegments;

If, e.g., time = 1.0, the output y =  0.0 (before event), 1.0 (after event)
    e.g., time = 1.5, the output y =  2.5,
    e.g., time = 2.0, the output y =  4.0,
    e.g., time = 5.0, the output y = 23.0 (i.e., extrapolation via last 2 points).
</pre>
<h4>Implementation</h4>
<p>
For simulation,
no time events are generated within an interval
in order that also intervals with many points do not reduce the simulation efficiency.
If the table points are largely changing, it is adviseable to force
time events by duplicating every time point (especially, if the model in which
the table is present allows the variable step integrator to make large
integrator steps). For example, if a sawtooth signal is defined with the table,
it is more reliable to define the table as:
</p>
<pre>
   table = [0, 0;
            1, 2;
            1, 2;
            2, 0;
            2, 0;
            3, 2;
            3, 2];
</pre>
<p>
instead of
</p>
<pre>
   table = [0, 0;
            1, 2;
            2, 0;
            3, 2];
</pre>
<p>
because time events are then generated at every time point.
</p>
<p>
Building automation systems typically have discrete time semantics
with fixed sampling times, and no notion of superdense time (in which
a tabulated value can change without advancing time).
Therefore, to implement a table with two equal time stamps,
a CDL translator may parameterize
a table in the building automation in such a way that the step change happens
at the time indicated in the first column, whereas previous sampling times
output the tabulated value at the last transition. For example,
</p>
<pre>
table = [0, 0;
         1, 0;
         1, 1];
smoothness = CDL.Types.ConstantSegments;
</pre>
<p>
may be converted such that a building automation system with a sampling time
of <i>0.5</i> seconds outputs
</p>
<pre>
  t = 0, 0.5, 1, ...
  y = 0, 0  , 1, ...
</pre>
</html>",
revisions="<html>
<ul>
<li>
March 14, 2017, by Michael Wetter:<br/>
Refactored and simplified implementation.
</li>
<li>
February 23, 2017, by Milica Grahovac:<br/>
Initial CDL implementation.
</li>
</ul>
</html>"),
    Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
    Polygon(lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid,
      points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
    Line(points={{-80.0,68.0},{-80.0,-80.0}},
      color={192,192,192}),
    Line(points={{-90.0,-70.0},{82.0,-70.0}},
      color={192,192,192}),
    Polygon(lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid,
      points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
    Rectangle(lineColor={255,255,255},
      fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-48.0,-50.0},{2.0,70.0}}),
    Line(points={{-48.0,-50.0},{-48.0,70.0},{52.0,70.0},{52.0,-50.0},{-48.0,-50.0},{-48.0,-20.0},{52.0,-20.0},{52.0,10.0},{-48.0,10.0},{-48.0,40.0},{52.0,40.0},{52.0,70.0},{2.0,70.0},{2.0,-51.0}})}));
end TimeTable;
