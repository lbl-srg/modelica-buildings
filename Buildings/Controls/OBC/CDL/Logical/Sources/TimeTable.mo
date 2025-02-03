within Buildings.Controls.OBC.CDL.Logical.Sources;
block TimeTable
  "Table look-up with respect to time with constant segments"
  parameter Real table[:,:]
    "Table matrix with time as a first column (in seconds, unless timeScale is not 1) and 0 for False or 1 for True in all other columns";
  parameter Real timeScale(
    final unit="1")=1
    "Time scale of first table column. Set to 3600 if time in table is in hours";
  parameter Real period(
    final quantity="Time",
    final unit="s")
    "Periodicity of table";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[nout]
    "Output with tabulated values"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),iconTransformation(extent={{100,-20},{140,20}})));

protected
  final parameter Integer nout=size(table, 2)-1
    "Dimension of output vector";
  final parameter Integer nT=size(table, 1)
    "Number of table points";
  Integers.Sources.TimeTable intTimTab(
    final table=table,
    final timeScale=timeScale,
    final period=period)
    "Time table"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Integers.GreaterThreshold intGreThr[nout](each t=0)
    "Converts to boolean"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

initial equation
  // Check that all values in the second column are Integer values
  for i in 1:nT loop
    for j in 2:size(table, 2) loop
      assert((abs(table[i,j]) < Constants.small) or
             (abs(table[i,j]-1.0) < Constants.small),
             "Table value table[" + String(i) + ", " + String(j) + "] = "
               + String(table[i,j]) + " does not equal either 0 or 1.");
    end for;
  end for;

equation
  connect(intTimTab.y,intGreThr.u)
    annotation (Line(points={{10,0},{38,0}},color={255,127,0}));
  connect(intGreThr.y,y)
    annotation (Line(points={{62,0},{96,0},{96,0},{140,0}},color={255,0,255}));
  annotation (
    defaultComponentName="booTimTab",
    Documentation(
      info="<html>
<p>
Block that outputs <code>true</code>/<code>false</code> time table values.
</p>
<p>
The block takes as a parameter a time table of a format:
</p>
<pre>
table = [ 0*3600, 0;
          6*3600, 1;
          6*3600, 0;
         18*3600, 1;
         18*3600, 1];
period = 24*3600;
</pre>
<p>
where the first column of <code>table</code> is time and the remaining column(s) are the table values.
The time column contains <code>Real</code> values that are in units of seconds if <code>timeScale = 1</code>.
The parameter <code>timeScale</code> can be used to scale the time values, for example, use
<code>timeScale = 3600</code> if the values in the first column are interpreted as hours.
</p>
<p>
The values in column two and higher must be <code>0</code> or <code>1</code>, otherwise the model stops with an error.
</p>
<p>
Until a new tabulated value is set, the previous tabulated value is returned.
</p>
<p>
The table scope is repeated periodically with periodicity <code>period</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 21, 2021, by Michael Wetter:<br/>
Removed writing output value in icon (as it is an array of values).
</li>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">Buildings, issue 2243</a>.
</li>
<li>
October 8, 2020, by Michael Wetter:<br/>
Revised implementation to use integer time table for its implementation.
</li>
<li>
September 14, 2020, by Milica Grahovac:<br/>
Initial CDL implementation based on continuous time table implementation in CDL.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised,
          lineColor={0,0,0}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Polygon(
          lineColor={217,67,180},
          fillColor={217,67,180},
          fillPattern=FillPattern.Solid,
          points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
        Line(
          points={{-80.0,68.0},{-80.0,-80.0}},
          color={255,0,255}),
        Line(
          points={{-90.0,-70.0},{82.0,-70.0}},
          color={255,0,255}),
        Polygon(
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid,
          points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
        Rectangle(
          lineColor={255,255,255},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          extent={{-48.0,-50.0},{2.0,70.0}}),
        Line(
          points={{-48.0,-50.0},{-48.0,70.0},{52.0,70.0},{52.0,-50.0},{-48.0,-50.0},{-48.0,-20.0},{52.0,-20.0},{52.0,10.0},{-48.0,10.0},{-48.0,40.0},{52.0,40.0},{52.0,70.0},{2.0,70.0},{2.0,-51.0}})}),
    Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end TimeTable;
