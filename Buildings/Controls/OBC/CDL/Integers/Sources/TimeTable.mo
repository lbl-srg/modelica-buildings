within Buildings.Controls.OBC.CDL.Integers.Sources;
block TimeTable "Table look-up with respect to time with constant segments"

  parameter Real table[:,:]
    "Table matrix with time as a first table column (in seconds, unless timeScale is not 1) and Integers in all other columns";

  parameter Integer offset[:]=fill(0, nout) "Offsets of output signals as a vector with length equal to number of table matrix columns less one";
  parameter Real timeScale(
     unit="1") = 1
    "Time scale of first table column. Set to 3600 if time in table is in hours";

  Interfaces.IntegerOutput y[nout] "Output of the table"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  final parameter Integer nout=size(table, 2)-1
    "Dimension of output vector";
  final parameter Integer n=size(table, 1)
    "Number of table points";
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";

  Continuous.Abs abs1[nout]
    "Absolute values"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Continuous.Add add2[nout](
    final k1=fill(1, nout),
    final k2=fill(-1, nout))
    "Subtracts inputs from their integer conversion results"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Conversions.IntegerToReal intToRea[nout] "Type conversion"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Continuous.GreaterThreshold greThr[nout](
    final t=fill(Constants.small, nout))
    "Value comparisson"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Utilities.Assert assMes(message="Scheduled values are not all of type Integer")
    "Assert all scheduled values are integer values"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Logical.MultiOr mulOr(
    final nu=nout) "Multi or"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{30,-80},{50,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger realToInteger[nout]
    "Converts scheduled values to integer"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  // CDL uses different enumerations for extrapolation
  // than the Modelica Standard Library. Hence, we cast the CDL
  // enumeration to the MSL enumeration.
  Modelica.Blocks.Sources.CombiTimeTable tab(
    final tableOnFile=false,
    final table=table,
    final columns=2:size(tab.table, 2),
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final offset=offset,
    final startTime=integer(t0/86400)*86400,
    final timeScale=timeScale) "Time table"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

initial equation
  t0=time;
  assert(n > 0, "No table values defined.");

equation
  connect(realToInteger.y, y) annotation(Line(points={{-18,0},{120,0}},        color={255,127,0}));

  connect(realToInteger.y, intToRea.u) annotation (Line(points={{-18,0},{-10,0},
          {-10,30},{-2,30}}, color={255,127,0}));
  connect(intToRea.y, add2.u1) annotation (Line(points={{22,30},{30,30},{30,-24},
          {38,-24}}, color={0,0,127}));
  connect(add2.y, abs1.u) annotation (Line(points={{62,-30},{64,-30},{64,-50},{-90,
          -50},{-90,-70},{-82,-70}}, color={0,0,127}));
  connect(abs1.y, greThr.u)
    annotation (Line(points={{-58,-70},{-42,-70}}, color={0,0,127}));
  connect(greThr.y, mulOr.u)
    annotation (Line(points={{-18,-70},{-2,-70}}, color={255,0,255}));
  connect(mulOr.y, not1.u)
    annotation (Line(points={{22,-70},{28,-70}}, color={255,0,255}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{52,-70},{58,-70}}, color={255,0,255}));
  connect(tab.y, realToInteger.u)
    annotation (Line(points={{-59,0},{-42,0}}, color={0,0,127}));
  connect(tab.y, add2.u2) annotation (Line(points={{-59,0},{-50,0},{-50,-36},{38,
          -36}}, color={0,0,127}));
  annotation (
defaultComponentName = "intTimTab",
Documentation(info="<html>
<p>
Block that outputs <code>Integer</code> time table values.
</p>
<p>
The block takes as a parameter a time table of a format:
</p>
<pre>
table = [ 0*3600, 2;
          6*3600, 0;
          6*3600, 1;
         18*3600, 8;
         18*3600, 5;
         24*3600, -2];
</pre>
<p>
where the first column is time, and the remaining column(s) are the table values.
The time column contains <code>Real</code> values that are in units of seconds when <code>timeScale</code> equals <code>1</code>.
<code>timeScale</code> may be used to scale the time values, such that for <code>timeScale = 3600</code> the values 
in the first column of the table are interpreted as hours.
</p>
<p>
The values in all columns apart from the first column must be of type <code>Integer</code>, otherwise a warning is issued.
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
<p>
The value of the parameter <code>offset</code> is added to the tabulated
values.
</p>
<p>
If the table has only one row, no interpolation is performed and
the table values of this row are just returned.
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
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={244,125,35},
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
    Line(points={{-48.0,-50.0},{-48.0,70.0},{52.0,70.0},{52.0,-50.0},
        {-48.0,-50.0},{-48.0,-20.0},{52.0,-20.0},{52.0,10.0},{-48.0,10.0},
        {-48.0,40.0},{52.0,40.0},{52.0,70.0},{2.0,70.0},{2.0,-51.0}}),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", if (nout==1) then String(y[1], leftjustified=false, significantDigits=3) else ""))}));
end TimeTable;
