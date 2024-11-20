within Buildings.Controls.OBC.CDL.Reals;
block Atan2
  "Output atan(u1/u2) of the inputs u1 and u2"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1
    "Input u1 for the atan2(u1/u2) function"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2
    "Input u2 for the atan2(u1/u2) function"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="rad",
    displayUnit="deg")
    "Output with atan2(u1/u2)"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=Modelica.Math.atan2(u1, u2);
  annotation (
    defaultComponentName="atan2",
    Documentation(
      info="<html>
<p>
Block that outputs the tangent-inverse <code>y = atan2(u1, u2)</code>
of the input <code>u1</code> divided by the input <code>u2</code>.
</p>
<p>
<code>u1</code> and <code>u2</code> shall not be zero at the same time instant.
<code>Atan2</code> uses the sign of <code>u1</code> and <code>u2</code>
in order to construct the solution in the range
<i>-&pi; &le; y &le; &pi;</i>, whereas
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Atan\">
Buildings.Controls.OBC.CDL.Reals.Atan</a>
gives a solution in the range
<i>-&pi;/2 &le; y &le; &pi;/2</i>.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Reals/Atan2.png\"
     alt=\"atan2.png\" />
</p>

</html>",
      revisions="<html>
<ul>
<li>
November 8, 2024, by Michael Wetter:<br/>
Added <code>final</code> keyword to unit declaration as block is only valid for this unit.<br/>
Also added <code>displayUnit</code> keyword.
</li>
<li>
March 7, 2023, by Jianjun Hu:<br/>
Added unit <code>rad</code> to the output.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3277\">issue 3277</a>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{0,-80},{0,68}},
          color={192,192,192}),
        Line(
          points={{-90,0},{68,0}},
          color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-34.9},{-46.1,-31.4},{-29.4,-27.1},{-18.3,-21.5},{-10.3,-14.5},{-2.03,-3.17},{7.97,11.6},{15.5,19.4},{24.3,25},{39,30},{62.1,33.5},{80,34.9}},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,45.1},{-45.9,48.7},{-29.1,52.9},{-18.1,58.6},{-10.2,65.8},{-1.82,77.2},{0,80}},
          smooth=Smooth.Bezier),
        Line(
          points={{0,-80},{8.93,-67.2},{17.1,-59.3},{27.3,-53.6},{42.1,-49.4},{69.9,-45.8},{80,-45.1}},
          smooth=Smooth.Bezier),
        Text(
          extent={{-90,-46},{-18,-94}},
          textColor={192,192,192},
          textString="atan2"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}));
end Atan2;
