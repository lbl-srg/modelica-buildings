within Buildings.Controls.OBC.Utilities.BaseClasses;
block Derivative
  "Block that approximates the derivative of the input for implementing a PID controller with input gains"
  parameter Real y_start=0
    "Initial value of output (= state)"
    annotation (Dialog(group="Initialization"));
  parameter Real Nd(
    min=100*CDL.Constants.eps)=10
    "The higher Nd, the more ideal the derivative block";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Connector for Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput k(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Connector for gain signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Td(
    quantity="Time",
    unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Connector for time constant signal"
    annotation (Placement(transformation(extent={{-140,-40},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector for Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  output Real x
    "State of block";

initial equation
  x=u-y_start/k/Nd;

equation
  der(x)=(u-x)*Nd/Td;
  y=(k*Nd)*(u-x);
  annotation (
    defaultComponentName="der",
    Documentation(
      info="<html>
<p>This blocks defines the transfer function between the input <span style=\"font-family: Courier New;\">u</span> and the output <span style=\"font-family: Courier New;\">y</span> as <i>approximated derivative</i>: </p>
<pre>
          k * Td * s
     y = ------------ * u
         Td/Nd * s + 1
</pre>

<p>
We assume that <code>k * Td</code> is larger than 0.
</p>
</html>",
        revisions="<html>
<ul>
<li>
May 17, 2022, by Sen Huang:<br/>
Made the gain and the time constant as inputs</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2993\">issue 2993</a>.
</li>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
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
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80.0,78.0},{-80.0,-90.0}},
            color={192,192,192}),
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
          Line(
            points={{-90.0,-80.0},{82.0,-80.0}},
            color={192,192,192}),
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
          Line(
            origin={-24.667,-27.333},
            points={{-55.333,87.333},{-19.333,-40.667},{86.667,-52.667}},
            color={0,0,127},
            smooth=Smooth.Bezier),
          Text(
            extent={{-150.0,-150.0},{150.0,-110.0}},
            textString="k=%k"),
          Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            textColor={0,0,255}),
          Text(
            extent={{226,60},{106,10}},
            textColor={0,0,0},
            textString=DynamicSelect("",String(y,
              leftJustified=false,
              significantDigits=3)))}),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200})}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end Derivative;
