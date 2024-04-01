within Buildings.Controls.OBC.CDL.Integers.Sources;
block TimeTable
  "Table look-up with respect to time with constant segments"
  parameter Real table[:,:]
    "Table matrix with time as a first table column (in seconds, unless timeScale is not 1) and Integers in all other columns";
  parameter Real timeScale(
    final unit="1")=1
    "Time scale of first table column. Set to 3600 if time in table is in hours";
  parameter Real period(
    final quantity="Time",
    final unit="s",
    min=1E-6)
    "Periodicity of table";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y[nout]
    "Output of the table"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  final parameter Integer nout=size(
    table,
    2)-1
    "Dimension of output vector";
  final parameter Integer nT=size(
    table,
    1)
    "Number of time stamps";
  parameter Real t0(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "First sample time instant";
  final parameter Real timeStamps[:](
    each final quantity="Time",
    each final unit="s")=timeScale*table[1:end,1]
    "Time stamps";
  final parameter Integer val[:,:]=integer(
    table[1:end,2:end]+ones(
      nT,
      nout)*Constants.small)
    "Table values as Integer";
  Integer idx(
    fixed=false)
    "Index for table lookup";
  function getIndex
    "Function to get the index for the table look-up"
    input Real t(
      final quantity="Time",
      final unit="s")
      "Current time";
    input Real period(
      final quantity="Time",
      final unit="s")
      "Time period";
    input Real x[:](
      each final quantity="Time",
      each final unit="s")
      "Time stamps";
    output Integer k
      "Index in table";

  protected
    Real tS(
      final quantity="Time",
      final unit="s")
      "Time shifted so it is within the period";

  algorithm
    tS := mod(
      t,
      period);
    k :=-1;
    for i in size(
      x,
      1):-1:1 loop
      if tS >= x[i]-1E-6 then
        k := i;
        break;
      end if;
    end for;
  end getIndex;

initial equation
  t0=Buildings.Utilities.Math.Functions.round(
    x=integer(time/period)*period,
    n=6);
  assert(
    nT > 0,
    "No table values defined.");
  // Check that all values in the second column are Integer values
  for i in 1:nT loop
    for j in 2:size(
      table,
      2) loop
      assert(
        abs(
          table[i,j]-integer(
            table[i,j])) < Constants.small,
        "In "+getInstanceName()+": Table value table["+String(i)+", "+String(j)+"] = "+String(
          table[i,j])+" is not an Integer.");
    end for;
  end for;
  assert(
    abs(
      table[1,1]) < Constants.small,
    "In "+getInstanceName()+": First time stamp must be zero as otherwise no data is defined for the start of the table.");
  assert(
    period-table[1,end] > Constants.small,
    "In "+getInstanceName()+": Last time stamp in table must be smaller than period.");
  idx=getIndex(
    time,
    period,
    timeStamps);
  y[:]=val[idx,:];

equation
  when {sample(t0+timeStamps[i],period) for i in 1:nT} then
    idx=getIndex(
      time,
      period,
      timeStamps);
    y[:]=val[idx,:];
  end when;
  annotation (
    defaultComponentName="intTimTab",
    Documentation(
      info="<html>
<p>
Block that outputs <code>Integer</code> time table values.
</p>
<p>
The block takes as a parameter a time table of a format:
</p>
<pre>
table = [ 0*3600, 2;
          6*3600, 1;
         18*3600, 8];
period = 24*3600;
</pre>
<p>
where the first column of <code>table</code> is time and the remaining column(s) are the table values.
The time column contains <code>Real</code> values that are in units of seconds if <code>timeScale = 1</code>.
The parameter <code>timeScale</code> can be used to scale the time values, for example, use
<code>timeScale = 3600</code> if the values in the first column are interpreted as hours.
</p>
<p>
The values in column two and higher must be of type <code>Integer</code>, otherwise the model stops with an error.
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
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
October 19, 2020, by Michael Wetter:<br/>
Revised to call <code>round()</code> as a function.<br/>
For <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2170\">#2170</a>.
</li>
<li>
October 7, 2020, by Michael Wetter:<br/>
Revised implementation to add <code>timeSpan</code> and to guard against rounding errors.
Refactored to avoid non-needed event-triggering functions.
Removed parameter <code>offset</code> as I don't see a use case that justifies this complexity.
</li>
<li>
September 14, 2020, by Milica Grahovac:<br/>
Initial CDL implementation based on continuous time table implementation in CDL.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={244,125,35},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Polygon(
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
        Line(
          points={{-80.0,68.0},{-80.0,-80.0}},
          color={192,192,192}),
        Line(
          points={{-90.0,-70.0},{82.0,-70.0}},
          color={192,192,192}),
        Polygon(
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
        Rectangle(
          lineColor={255,255,255},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          extent={{-48.0,-50.0},{2.0,70.0}}),
        Line(
          points={{-48.0,-50.0},{-48.0,70.0},{52.0,70.0},{52.0,-50.0},{-48.0,-50.0},{-48.0,-20.0},{52.0,-20.0},{52.0,10.0},{-48.0,10.0},{-48.0,40.0},{52.0,40.0},{52.0,70.0},{2.0,70.0},{2.0,-51.0}})}));
end TimeTable;
