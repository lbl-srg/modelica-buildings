within Buildings.Obsolete.Controls.OBC.CDL.Continuous;
block Derivative "Block that approximates the derivative of the input"
  extends Modelica.Icons.ObsoleteModel;

  parameter Real k(unit="1") = 1 "Gains";
  parameter Modelica.Units.SI.Time T(min=1E-60) = 0.01
    "Time constant (T>0 required)";
  parameter Real x_start=0 "Initial or guess value of state"
    annotation (Dialog(group="Initialization"));
  parameter Real y_start=0 "Initial value of output (= state)"
    annotation(Dialog(group="Initialization"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  output Real x "State of block";

protected
  parameter Boolean zeroGain = abs(k) < 1E-17
    "= true, if gain equals to zero";
initial equation
  if zeroGain then
     x = u;
  else
     x = u - T*y_start/k;
  end if;

equation
  der(x) = if zeroGain then 0 else (u - x)/T;
  y = if zeroGain then 0 else (k/T)*(u - x);

annotation (
  defaultComponentName="der",
  obsolete = "This model is obsolete",
  Documentation(info="<html>
<p>
This blocks defines the transfer function between the
input <code>u</code> and the output <code>y</code>
as <i>approximated derivative</i>:
</p>
<pre>
             k * s
     y = ------------ * u
            T * s + 1
</pre>
<p>
If <code>k=0</code>, the block reduces to <code>y=0</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 4, 2020, by Jianjun Hu:<br/>
Moved the block to 
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Continous\">Buildings.Obsolete.Controls.OBC.CDL.Continous</a>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2056\">issue 2056</a>.
</li>
<li>
April 21, 2020, by Michael Wetter:<br/>
Removed option to not set the initialization method or to set the initial state.
The new implementation only allows to set the initial output, from which
the initial state is computed.
<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1887\">issue 1887</a>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
March 24, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"), Icon(
    coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
  graphics={
    Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
    Line(points={{-80.0,78.0},{-80.0,-90.0}},
      color={192,192,192}),
  Polygon(lineColor={192,192,192},
    fillColor={192,192,192},
    fillPattern=FillPattern.Solid,
    points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
  Line(points={{-90.0,-80.0},{82.0,-80.0}},
    color={192,192,192}),
  Polygon(lineColor={192,192,192},
    fillColor={192,192,192},
    fillPattern=FillPattern.Solid,
    points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
  Line(origin = {-24.667,-27.333},
    points = {{-55.333,87.333},{-19.333,-40.667},{86.667,-52.667}},
    color = {0,0,127},
    smooth = Smooth.Bezier),
  Text(textColor={192,192,192},
    extent={{-30.0,14.0},{86.0,60.0}},
    textString="DT1"),
  Text(extent={{-150.0,-150.0},{150.0,-110.0}},
    textString="k=%k"),
  Text(
    extent={{-150,150},{150,110}},
    textString="%name",
    textColor={0,0,255}),
  Text(
    extent={{226,60},{106,10}},
    textColor={0,0,0},
    textString=DynamicSelect("", String(y, leftJustified=false, significantDigits=3)))}));
end Derivative;
