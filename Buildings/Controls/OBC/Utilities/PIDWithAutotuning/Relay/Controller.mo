within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay;
block Controller
  "Output relay signals for tuning PID controllers"
  parameter Real yHig(
    final min=1E-6) = 1
    "Higher value for the relay output";
  parameter Real yLow(
    final min=1E-6,
    final max=yHig) = 0.5
    "Lower value for the output";
  parameter Real deaBan(min=1E-6) = 0.5
    "Deadband for holding the output value";
  parameter Boolean reverseActing=true
    "Set to true for reverse acting, or false for direct acting control action";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Measurement input signal"
    annotation (Placement(transformation(origin={0,-120},extent={{20,-20},{-20,20}},rotation=270),
    iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput trigger
    "Connector for enabling the relay controller"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={-80,-120}),
    iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Control output"
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOn
    "Relay switch output, true when control output switches to the higher value"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yErr
    "Control error"
    annotation (Placement(transformation(extent={{100,-10},{140,30}}),
    iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between a higher value and a lower value"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant higVal(
    final k=yHig)
    "Higher value for the output"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant lowVal(
    final k=-yLow)
    "Lower value for the output"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract conErr
    "Control error (measurement - set point)"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Switch between a higher value and a lower value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
    origin={-50,-60})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    if reverseActing "Inputs difference for reverse acting"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=-deaBan,
    final uHigh=deaBan,
    final pre_y_start=true)
    "Check if the measured value is larger than the reference, by default the relay control is on"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    if not reverseActing "Inputs difference for direct acting"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre
    "Check if the higher value is greater than the lower value"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=-1) "Gain"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: The higher value for the relay output should be greater than that of the lower value.")
    "Warning when the higher value is set to be less than the lower value"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));

equation
  connect(swi.y, y)
    annotation (Line(points={{82,50},{120,50}}, color={0,0,127}));
  connect(higVal.y, swi.u1)
    annotation (Line(points={{-58,80},{-20,80},{-20,58},{58,58}},color={0,0,127}));
  connect(lowVal.y, swi.u3) annotation (Line(points={{-58,30},{-20,30},{-20,42},
          {58,42}},color={0,0,127}));
  connect(conErr.y, yErr) annotation (Line(points={{62,10},{120,10}},
                color={0,0,127}));
  connect(swi1.u3, u_s) annotation (Line(points={{-62,-68},{-90,-68},{-90,0},{
          -120,0}},color={0,0,127}));
  connect(trigger, swi1.u2) annotation (Line(points={{-80,-120},{-80,-60},{-62,
          -60}},color={255,0,255}));
  connect(u_m, swi1.u1) annotation (Line(points={{0,-120},{0,-90},{-70,-90},{
          -70,-52},{-62,-52}},color={0,0,127}));
  connect(swi1.y, conErr.u1) annotation (Line(points={{-38,-60},{-20,-60},{-20,
          16},{38,16}}, color={0,0,127}));
  connect(conErr.u2, u_s) annotation (Line(points={{38,4},{-42,4},{-42,0},{
          -120,0}},color={0,0,127}));
  connect(sub1.y, hys.u) annotation (Line(points={{22,-70},{30,-70},{30,-50},{
          38,-50}},color={0,0,127}));
  connect(sub.y, hys.u) annotation (Line(points={{22,-40},{30,-40},{30,-50},{38,
          -50}}, color={0,0,127}));
  connect(u_s, sub.u1) annotation (Line(points={{-120,0},{-90,0},{-90,-34},{-2,
          -34}},color={0,0,127}));
  connect(u_s, sub1.u2) annotation (Line(points={{-120,0},{-90,0},{-90,-76},{-2,
          -76}}, color={0,0,127}));
  connect(swi1.y, sub.u2) annotation (Line(points={{-38,-60},{-20,-60},{-20,-46},
          {-2,-46}}, color={0,0,127}));
  connect(swi1.y, sub1.u1) annotation (Line(points={{-38,-60},{-20,-60},{-20,
          -64},{-2,-64}},color={0,0,127}));
  connect(hys.y, swi.u2) annotation (Line(points={{62,-50},{80,-50},{80,30},{50,
          30},{50,50},{58,50}}, color={255,0,255}));
  connect(gre.y, assMes.u)
    annotation (Line(points={{22,80},{38,80}}, color={255,0,255}));
  connect(lowVal.y, gai.u) annotation (Line(points={{-58,30},{-50,30},{-50,50},{
          -42,50}}, color={0,0,127}));
  connect(gai.y, gre.u2) annotation (Line(points={{-18,50},{-10,50},{-10,72},{-2,
          72}}, color={0,0,127}));
  connect(higVal.y, gre.u1)
    annotation (Line(points={{-58,80},{-2,80}}, color={0,0,127}));
  connect(hys.y, yOn) annotation (Line(points={{62,-50},{80,-50},{80,-60},{120,
          -60}},
        color={255,0,255}));
    annotation (defaultComponentName = "relCon",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255}),
        Polygon(
          points={{-70,92},{-78,70},{-62,70},{-70,92}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{84,-70},{62,-62},{62,-78},{84,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-70,78},{-70,-90}},
          color={192,192,192}),
        Line(
          points={{-80,-70},{80,-70}},
          color={192,192,192}),
        Text(
          extent={{-62,-10},{84,-52}},
          textColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="Relay"),
        Line(points={{-70,24},{-34,24},{-34,58},{38,58},{38,24},{66,24}}, color=
             {28,108,200})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This block generates a real control output <code>y</code>, a
boolean relay switch output <code>yOn</code>, an input difference 
<code>yDif</code>, and a control error
<code>yErr</code>. They are calculated as below:
</p>
<ul>
<li>
<code>yErr = u_m - u_s</code>,
</li>
<li>
if the parameter <code>reverseActing = true</code>
<ul>
<li>
<code>yDif = - yErr</code>,
</li>
</ul>
</li>
<li>
else
<ul>
<li>
<code>yDif = yErr</code>,
</li>
</ul>
</li>
<li>
if <code>yDif &lt; -deaBan</code> and <code>trigger</code> is <code>true</code>,
then <code>y = yHig</code>, <code>yOn = true</code>,
</li>
<li>
else if <code>yDif &gt; deaBan</code> and <code>trigger</code> is <code>true</code>,
then <code>y = -yLow</code>, 
<code>yOn = false</code>,
</li>
<li>
else, <code>y</code> and <code>yOn</code> are kept as the initial values,
</li>
</ul>
<p>where <code>deaBan</code> is a dead band, <code>yHig</code>
and <code>yLow</code>
are the higher value and the lower value of the output <code>y</code>, respectively.
</p>
<p>
Note that this block generates an asymmetric output, meaning <code>yHig &ne; yLow</code>.
</p>
<h4>References</h4>
<p>Josefin Berner (2017)
\"Automatic Controller Tuning using Relay-based Model Identification.\"
Department of Automatic Control, Lund Institute of Technology, Lund University.</p>
</html>", revisions="<html>
<ul>
<li>
December 1, 2023, by Sen Huang:<br/>
Add a parameter <code>reverseActing</code><br/>
</li>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"));
end Controller;
