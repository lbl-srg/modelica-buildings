within Buildings.Controls.OBC.CDL.Reals;
block Derivative
  "Block that approximates the derivative of the input"
  parameter Real y_start=0
    "Initial value of output (= state)"
    annotation (Dialog(group="Initialization"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput k
    "Connector for gain signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant (T>0 required; T=0 is ideal derivative block)"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Input to be differentiated"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Approximation of derivative du/dt"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
protected
  Real T_nonZero(final unit="s") "Non-zero value for T";

  output Real x
    "State of block";

initial equation
  x= if abs(k) < Buildings.Controls.OBC.CDL.Constants.eps then u else u - T*y_start/k;

equation
  T_nonZero = max(T, 100*Buildings.Controls.OBC.CDL.Constants.eps);
  der(x) = (u-x)/T_nonZero;
  y = (k/T_nonZero)*(u-x);

  annotation (
    defaultComponentName="der",
    Documentation(
      info="<html>
<p>
This blocks defines the transfer function between the
input <code>u</code> and the output <code>y</code>
as <i>approximated derivative</i>:
</p>
<pre>
                s
  y = k * ------------ * u
            T * s + 1
</pre>
<p>
If <code>k=0</code>, the block reduces to <code>y=0</code>.
</p>
</html>",
        revisions="<html>
<ul>
<li>
May 20, 2022, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3022\">issue 3022</a>.
</li>
</ul>
</html>"),
      Icon(
        coordinateSystem(
          extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-56,78},{-56,-90}},
            color={192,192,192}),
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{-56,90},{-64,68},{-48,68},{-56,90}}),
          Line(
            points={{-64,-80},{82,-80}},
            color={192,192,192}),
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
          Line(
            origin={-24.667,-27.333},
            points={{-31.333,89.333},{-19.333,-40.667},{86.667,-52.667}},
            color={0,0,127},
            smooth=Smooth.Bezier),
          Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            textColor={0,0,255}),
          Text(
            extent={{226,60},{106,10}},
            textColor={0,0,0},
            textString=DynamicSelect("",String(y,
              leftJustified=false,
              significantDigits=3))),
        Text(
          extent={{-106,14},{-62,-12}},
          textColor={0,0,0},
          textString="u"),
        Text(
          extent={{46,14},{90,-12}},
          textColor={0,0,0},
          textString="y=du/dt"),
        Text(
          extent={{-108,94},{-64,68}},
          textColor={0,0,0},
          textString="k"),
        Text(
          extent={{-108,54},{-64,28}},
          textColor={0,0,0},
          textString="T")}));
end Derivative;
