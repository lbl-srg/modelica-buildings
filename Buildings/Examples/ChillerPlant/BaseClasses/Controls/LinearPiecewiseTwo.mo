within Buildings.Examples.ChillerPlant.BaseClasses.Controls;
block LinearPiecewiseTwo "A two-pieces linear piecewise function"
  extends Modelica.Blocks.Icons.Block;
  parameter Real x0 "First interval [x0, x1]";
  parameter Real x1 "First interval [x0, x1] and second interval (x1, x2]";
  parameter Real x2 "Second interval (x1, x2]";
  parameter Real y10 "y[1] at u = x0";
  parameter Real y11 "y[1] at u = x1";
  parameter Real y20 "y[2] at u = x1";
  parameter Real y21 "y[2] at u = x2";
  Modelica.Blocks.Interfaces.RealInput u "Set point" annotation (
  extent={{-190,80},{-150,120}}, Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[2] "Connectors of Real output signal"
    annotation (Placement(transformation(extent={{
            100,-12},{120,8}})));
  Buildings.Controls.SetPoints.Table y1Tab(table=[x0, y10; x1, y11; x2, y11])
    "Table for y[1]"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.SetPoints.Table y2Tab(table=[x0, y20; x1, y20; x2, y21])
    "Table for y[2]"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(u, y1Tab.u) annotation (Line(
      points={{-120,1.11022e-15},{-58,1.11022e-15},{-58,30},{-42,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(u, y2Tab.u) annotation (Line(
      points={{-120,1.11022e-15},{-58,1.11022e-15},{-58,-30},{-42,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(y1Tab.y, y[1]) annotation (Line(
      points={{-19,30},{26,30},{26,-7},{110,-7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(y2Tab.y, y[2]) annotation (Line(
      points={{-19,-30},{42,-30},{42,3},{110,3}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="linPieTwo",
    Documentation(info="<HTML>
<p>
This component calcuates the output according to two piecewise linear function as
</p>
<table>
<tr>
<td>
<i>x<sub>0</sub> &le; u &le; x<sub>1</sub>:</i></td>
    <td><i>y<sub>1</sub> = y<sub>10</sub> + u (y<sub>11</sub>-y<sub>10</sub>)/(x<sub>1</sub>-x<sub>0</sub>)</i><br/>
        <i>y<sub>2</sub> = y<sub>20</sub></i></td>
</tr>
<tr>
<td><i>x<sub>1</sub> &lt; u &le; x<sub>2</sub>:</i></td>
    <td><i>y<sub>1</sub> = y<sub>11</sub></i><br/>
    <i>y<sub>2</sub> = y<sub>20</sub> + (u-x<sub>1</sub>)
       (y<sub>21</sub>-y<sub>20</sub>)/(x<sub>2</sub>-x<sub>1</sub>)</i></td>
</tr>
</table>
</HTML>", revisions="<html>
<ul>
<li>
July 20, 2011, by Wangda Zuo:<br/>
Add comments and merge to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Line(
          points={{-68,62},{-68,-50},{62,-50}},
          color={0,0,0},
          smooth=Smooth.None,
          arrow={Arrow.Filled,Arrow.Filled}),
        Line(
          points={{46,-50},{46,62}},
          color={0,0,0},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{-52,6},{-42,-2}},
          textColor={0,0,0},
          textString="y[1]"),
        Text(
          extent={{24,6},{34,-2}},
          textColor={128,0,255},
          textString="y[2]",
          lineThickness=1),
        Text(
          extent={{-74,-52},{-64,-60}},
          textColor={0,0,0},
          textString="x0"),
        Text(
          extent={{-18,-52},{-8,-60}},
          textColor={0,0,0},
          textString="x1"),
        Text(
          extent={{40,-52},{50,-60}},
          textColor={0,0,0},
          textString="x2"),
        Text(
          extent={{-80,-38},{-70,-46}},
          textColor={0,0,0},
          textString="y10"),
        Text(
          extent={{-80,34},{-68,26}},
          textColor={0,0,0},
          textString="y11"),
        Text(
          extent={{48,50},{60,42}},
          textColor={128,0,255},
          textString="y21"),
        Text(
          extent={{48,-32},{58,-40}},
          textColor={128,0,255},
          textString="y20",
          lineThickness=1),
        Line(
          points={{-68,-42},{-14,30},{46,30}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-68,44},{-14,44},{46,-36}},
          color={128,0,255},
          thickness=1,
          smooth=Smooth.None),
        Line(
          points={{-14,44},{-14,-50}},
          color={175,175,175},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{-68,30},{-14,30}},
          color={175,175,175},
          pattern=LinePattern.Dash,
          smooth=Smooth.None),
        Line(
          points={{-14,44},{46,44}},
          color={175,175,175},
          pattern=LinePattern.Dash,
          smooth=Smooth.None),
        Text(
          extent={{62,-46},{72,-54}},
          textColor={0,0,0},
          textString="x")}));
end LinearPiecewiseTwo;
