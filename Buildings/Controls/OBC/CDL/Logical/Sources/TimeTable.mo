within Buildings.Controls.OBC.CDL.Logical.Sources;
block TimeTable
  "Table look-up with respect to time with constant segments"

  parameter Real table[:,:]
    "Table matrix with time as a first column (in seconds, unless timeScale is not 1) and Booleans in all other columns";
  parameter Real timeScale(
    final unit="1")=1
    "Time scale of first table column. Set to 3600 if time in table is in hours";

  Interfaces.BooleanOutput y[nout] "Output of the table"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  final parameter Integer nout=size(table, 2)-1
    "Dimension of output vector";
  final parameter Integer n=size(table, 1)
    "Number of table points";
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";

  Modelica.Blocks.Sources.CombiTimeTable tab(
    final tableOnFile=false,
    final table=table,
    final columns=2:size(tab.table, 2),
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final startTime=integer(t0/86400)*86400,
    final timeScale=timeScale) "Time table"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Continuous.GreaterThreshold greThr[nout](
    final t=fill(0.5, nout))
    "Conversion to boolean"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

initial equation
  t0=time;
  assert(n > 0, "No table values defined.");

  // Check that all values in the second column are Integer values
  for i in 1:n loop
    for j in 2:size(table, 2) loop
      assert(rem(table[i, j], 1) == 0.0 and (table[i, j] == 1.0 or table[i, j] == 0.0),
        "Table value is not an Integer in row " + String(i) + " and column " + String(j));
    end for;
  end for;

equation
  connect(tab.y, greThr.u)
    annotation (Line(points={{-79,0},{-2,0}}, color={0,0,127}));
  connect(greThr.y, y)
    annotation (Line(points={{22,0},{140,0}}, color={255,0,255}));
  annotation (
defaultComponentName = "intTimTab",
Documentation(info="<html>
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
         18*3600, 1;
         24*3600, 1];
</pre>
<p>
where the first column is time, and the remaining column(s) are the table values.
The time column contains <code>Real</code> values that are in units of seconds when <code>timeScale</code> equals <code>1</code>.
<code>timeScale</code> may be used to scale the time values, such that for <code>timeScale = 3600</code> the values 
in the first column of the table are interpreted as hours.
<p>
Any number of columns can be specified.
</p>
<p>
The values in all columns apart from the first column must equal to either <code>0</code> or <code>1</code>, 
to represent <code>false</code> or <code>true</code>, respectively, otherwise a warning is issued.
</p>
<p>
Until a new tabulated value is set, the previous tabulated value is returned.
</p>
<p>
The table scope is repeated periodically with periodicity
      <code>(max(table[:, 1]-min(table[:, 1]))*timeScale)</code>.
</p>
<p>
If the table has only one row the table values of this row are returned.
</p>
<p>
The simulation can start at any time,
whether it is a multiple of a day or not, and positive or negative.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 14, 2020, by Milica Grahovac:<br/>
Initial CDL implementation based on continuous time table implementation in CDL.
</li>
</ul>
</html>"),
    Icon(
      graphics={                         Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised,
          lineColor={0,0,0}),           Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
    Polygon(lineColor={217,67,180},
      fillColor={217,67,180},
      fillPattern=FillPattern.Solid,
      points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
    Line(points={{-80.0,68.0},{-80.0,-80.0}}, color={255,0,255}),
    Line(points={{-90.0,-70.0},{82.0,-70.0}},
      color={255,0,255}),
    Polygon(lineColor={255,0,255},
      fillColor={255,0,255},
      fillPattern=FillPattern.Solid,
      points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
    Rectangle(lineColor={255,255,255},
      fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-48.0,-50.0},{2.0,70.0}}),
    Line(points={{-48.0,-50.0},{-48.0,70.0},{52.0,70.0},{52.0,-50.0},
        {-48.0,-50.0},{-48.0,-20.0},{52.0,-20.0},{52.0,10.0},{-48.0,10.0},
        {-48.0,40.0},{52.0,40.0},{52.0,70.0},{2.0,70.0},{2.0,-51.0}}),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", if (nout==1) then String(y[1], leftjustified=false, significantDigits=3) else ""))}),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end TimeTable;
