within Buildings.Controls.SetPoints;
model Table
  "Model for a set point that is interpolated based on a user-specified table"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real table[:,2]=fill(0.0, 1, 2)
    "Table matrix ( e.g., table=[u1, y1; u2, y2; u3, y3])";

  parameter Real offset=0 "Offset of output signal";

  parameter Boolean constantExtrapolation = true
    "If true, then y=y1 for u<u1, and y=yMax for u>uMax";

protected
  final parameter Integer nRow = if constantExtrapolation then
                        size(table,1)+2 else
                        size(table,1) "Number of rows";
  final parameter Real[nRow,2] offsetVector = [zeros(nRow), offset*ones(nRow)]
    "Vector to take offset of output signal into account";
  Modelica.Blocks.Tables.CombiTable1Dv tab(tableOnFile=false, final table=(if
        constantExtrapolation then cat(
        1,
        [table[1, 1] - 1,table[1, 2]],
        table,
        [table[end, 1] + 1,table[end, 2]]) else table) + offsetVector)
    "Table used for interpolation"
    annotation (Placement(transformation(extent={{-20,-10},{2,10}})));
equation
  connect(u, tab.u[1]) annotation (Line(
      points={{-120,0},{-70,0},{-70,0},{-22,0}},
      color={0,0,127}));

  connect(tab.y[1], y) annotation (Line(
      points={{3.1,0},{53.55,0},{53.55,0},{110,0}},
      color={0,0,127}));

  annotation (
defaultComponentName="tab",
Documentation(info="<html>
<p>
This block can be used to schedule a set-point by using piecewise linear functions.
For example, the instances
</p>
<pre>
Buildings.Controls.SetPoints.Table tabLinExt(constantExtrapolation=false,
                                             table=[20, 0.0;
                                                    22, 0.5;
                                                    25, 0.5;
                                                    26, 1.0]);
Buildings.Controls.SetPoints.Table tabConExt(constantExtrapolation=true,
                                             table=[20, 0.0;
                                                    22, 0.5;
                                                    25, 0.5;
                                                    26, 1.0]);
</pre>
<p>
will cause the following output:
</p>
<p>
<img src=\"modelica://Buildings/Resources/Images/Controls/SetPoints/Table.png\" border=\"1\" alt=\"Table output.\"/>
</p>
<p>
For the default setting <code>constantExtrapolation=true</code>, the
block outputs
<code>y=y1+offset</code> for <code>u &le; u1</code>, and
<code>y=yMax+offset</code> for <code>u &ge; uMax</code>.
Otherwise, the table is linearly extrapolated with a constant derivative.
</p>
<p>
Note that the first column must be strictly increasing.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 30, 2016, by Michael Wetter:<br/>
Changed protected final parameter <code>nCol</code> to <code>nRow</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/555\">issue 555</a>.
</li>
<li>
April 5, 2011, by Michael Wetter:<br/>
Fixed wrong table declaration.
</li>
<li>
July 13, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
    Text(
      extent={{-78,-45},{-40,-56}},
      textColor={0,0,0},
      textString="offset"),
    Line(
      points={{-42,-24},{-42,-74}},
      color={95,95,95},
      thickness=0.25,
      arrow={Arrow.None,Arrow.None}),
    Line(
      points={{-82,-24},{-22,-24},{26,24}},
      color={0,0,255},
      thickness=0.5),
    Line(points={{-82,64},{-82,-84}}, color={95,95,95}),
    Text(
      extent={{-80,88},{-39,68}},
      textColor={0,0,0},
      textString="y"),
    Polygon(
      points={{-82,86},{-88,64},{-76,64},{-82,86}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{88,-74},{66,-68},{66,-80},{88,-74}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(points={{-92,-74},{80,-74}}, color={95,95,95}),
    Text(
      extent={{68,-84},{92,-95}},
      textColor={0,0,0},
          textString="u"),
    Polygon(
      points={{-42,-24},{-44,-34},{-39,-34},{-42,-24}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{-42,-74},{-45,-64},{-40,-64},{-42,-74},{-42,-74}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(
      points={{26,24},{77,24}},
      color={0,0,255},
      thickness=0.5)}));
end Table;
