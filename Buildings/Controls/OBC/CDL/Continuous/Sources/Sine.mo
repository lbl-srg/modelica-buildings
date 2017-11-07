within Buildings.Controls.OBC.CDL.Continuous.Sources;
block Sine "Generate sine signal"
  import Buildings.Controls.OBC.CDL.Constants.pi;
  parameter Real amplitude=1 "Amplitude of sine wave";
  parameter Modelica.SIunits.Frequency freqHz(start=1) "Frequency of sine wave";
  parameter Modelica.SIunits.Angle phase=0 "Phase of sine wave";
  parameter Real offset=0 "Offset of output signal";
  parameter Modelica.SIunits.Time startTime=0 "Output = offset for time < startTime";

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = offset + (if time < startTime then 0 else amplitude*Modelica.Math.sin(2
    *pi*freqHz*(time - startTime) + phase));
  annotation (
    defaultComponentName="sin",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-80},{100,100}}),graphics={
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
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,-90},{-80,84}}, color={95,95,95}),
        Polygon(
          points={{-80,97},{-84,81},{-76,81},{-80,97}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-99,-40},{85,-40}}, color={95,95,95}),
        Polygon(
          points={{97,-40},{81,-36},{81,-45},{97,-40}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-41,-2},{-31.6,34.2},{-26.1,53.1},{-21.3,66.4},{-17.1,74.6},
              {-12.9,79.1},{-8.64,79.8},{-4.42,76.6},{-0.201,69.7},{4.02,59.4},
              {8.84,44.1},{14.9,21.2},{27.5,-30.8},{33,-50.2},{37.8,-64.2},{
              42,-73.1},{46.2,-78.4},{50.5,-80},{54.7,-77.6},{58.9,-71.5},{
              63.1,-61.9},{67.9,-47.2},{74,-24.8},{80,0}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-41,-2},{-80,-2}},
          color={0,0,255},
          thickness=0.5),
        Text(
          extent={{-87,12},{-40,0}},
          lineColor={0,0,0},
          textString="offset"),
        Line(points={{-41,-2},{-41,-40}}, color={95,95,95}),
        Text(
          extent={{-60,-43},{-14,-54}},
          lineColor={0,0,0},
          textString="startTime"),
        Text(
          extent={{75,-47},{100,-60}},
          lineColor={0,0,0},
          textString="time"),
        Text(
          extent={{-80,99},{-40,82}},
          lineColor={0,0,0},
          textString="y"),
        Line(points={{-9,80},{43,80}}, color={95,95,95}),
        Line(points={{-41,-2},{50,-2}}, color={95,95,95}),
        Polygon(
          points={{33,80},{30,67},{36,67},{33,80}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{37,57},{83,39}},
          lineColor={0,0,0},
          textString="amplitude"),
        Polygon(
          points={{33,-2},{30,11},{36,11},{33,-2},{33,-2}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{33,80},{33,-2}}, color={95,95,95})}),
    Documentation(info="<html>
<p>
The Real output y is a sine signal:
</p>

<p>
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Continuous/Sources/Sine.png\"
     alt=\"Sine.png\">
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
