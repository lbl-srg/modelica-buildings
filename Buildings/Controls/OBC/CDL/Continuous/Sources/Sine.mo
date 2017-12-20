within Buildings.Controls.OBC.CDL.Continuous.Sources;
block Sine "Generate sine signal"
  parameter Real amplitude=1 "Amplitude of sine wave";
  parameter Modelica.SIunits.Frequency freqHz(start=1) "Frequency of sine wave";
  parameter Modelica.SIunits.Angle phase=0 "Phase of sine wave";
  parameter Real offset=0 "Offset of output signal";
  parameter Modelica.SIunits.Time startTime=0 "Output = offset for time < startTime";

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = offset + (
    if time < startTime
    then 0 else
    amplitude*Modelica.Math.sin(2*Buildings.Controls.OBC.CDL.Constants.pi*freqHz*(time - startTime) + phase));
  annotation (
    defaultComponentName="sin",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),graphics={
        Text(
          lineColor={0,0,255},
          extent={{-148,104},{152,144}},
          textString="%name"),
        Rectangle(extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(points={{90,0},{68,8}, {68,-8},{90,0}},
          lineColor={192,192,192}, fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,
              74.6},{-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,
              59.4},{-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,
              -64.2},{29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},
              {57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}}, smooth = Smooth.Bezier),
        Text(extent={{-147,-152},{153,-112}},lineColor={0,0,0},
          textString="freqHz=%freqHz")}),
    Documentation(info="<html>
<p>
Block that outputs a <code>sine</code>.
</p>
<p>
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Continuous/Sources/Sine.png\"
     alt=\"Sine.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
November 06, 2017, by Milica Grahovac:<br/>
First CDL implementation.
</li>
</ul>
</html>"));
end Sine;
