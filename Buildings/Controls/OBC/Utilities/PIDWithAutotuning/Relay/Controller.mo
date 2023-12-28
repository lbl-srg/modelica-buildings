within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay;
block Controller
  "Output relay signals for tuning PID controllers"
  parameter Real yHig(
    final min=1E-6) = 1
    "Higher value for the relay output";
  parameter Real yLow(
    final min=1E-6,
    final max=yHig) = 0.5
    "Lower value for the relay output";
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
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDif
    "Input difference, measurement - setpoint"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
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
    final k=yLow)
    "Lower value for the output"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Switch between a higher value and a lower value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
    origin={-50,-40})));
  Buildings.Controls.OBC.CDL.Reals.Subtract revActErr if reverseActing
    "Control error when reverse acting, setpoint - measurement"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=-deaBan,
    final uHigh=deaBan,
    final pre_y_start=true)
    "Check if the input difference exceeds the thresholds, by default the relay control is on"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dirActErr if not reverseActing
    "Control error when direct acting, measurement - setpoint"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract meaSetDif
    "Inputs difference, (measurement - setpoint)"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(swi.y, y)
    annotation (Line(points={{82,50},{120,50}}, color={0,0,127}));
  connect(higVal.y, swi.u1)
    annotation (Line(points={{-58,80},{-20,80},{-20,58},{58,58}},color={0,0,127}));
  connect(lowVal.y, swi.u3) annotation (Line(points={{-58,20},{-20,20},{-20,42},
          {58,42}},color={0,0,127}));
  connect(swi1.u3, u_s) annotation (Line(points={{-62,-48},{-90,-48},{-90,0},{-120,
          0}}, color={0,0,127}));
  connect(trigger, swi1.u2) annotation (Line(points={{-80,-120},{-80,-40},{-62,-40}},
          color={255,0,255}));
  connect(u_m, swi1.u1) annotation (Line(points={{0,-120},{0,-90},{-70,-90},{-70,
          -32},{-62,-32}}, color={0,0,127}));
  connect(dirActErr.y, hys.u) annotation (Line(points={{2,-70},{10,-70},{10,-60},
          {18,-60}}, color={0,0,127}));
  connect(revActErr.y, hys.u) annotation (Line(points={{2,-20},{10,-20},{10,-60},
          {18,-60}}, color={0,0,127}));
  connect(u_s, revActErr.u1) annotation (Line(points={{-120,0},{-90,0},{-90,-14},
          {-22,-14}}, color={0,0,127}));
  connect(u_s, dirActErr.u2) annotation (Line(points={{-120,0},{-90,0},{-90,-76},
          {-22,-76}}, color={0,0,127}));
  connect(swi1.y, revActErr.u2) annotation (Line(points={{-38,-40},{-30,-40},{-30,
          -26},{-22,-26}}, color={0,0,127}));
  connect(swi1.y, dirActErr.u1) annotation (Line(points={{-38,-40},{-30,-40},{-30,
          -64},{-22,-64}}, color={0,0,127}));
  connect(hys.y, swi.u2) annotation (Line(points={{42,-60},{50,-60},{50,50},{58,
          50}},  color={255,0,255}));
  connect(hys.y, yOn) annotation (Line(points={{42,-60},{120,-60}}, color={255,0,255}));
  connect(swi1.y, meaSetDif.u1) annotation (Line(points={{-38,-40},{20,-40},{20,
          6},{58,6}}, color={0,0,127}));
  connect(u_s, meaSetDif.u2) annotation (Line(points={{-120,0},{40,0},{40,-6},{58,
          -6}}, color={0,0,127}));
  connect(meaSetDif.y, yDif)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
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
This block generates a relay output <code>yDif</code> which equals to
<code>u_m - u_s</code>. It also generates the control output <code>y</code>,
and a boolean relay switch output <code>yOn</code>,
which are calculated as below.
</p>
<p>
Step 1: calculate control error, 
</p>
<ul>
<li>
If the parameter <code>reverseActing = true</code>, then the control error
(<code>err = u_s - u_m</code>),
else the control error (<code>err = u_m - u_s</code>).
</li>
</ul>
<p>
Step 2: calculate <code>y</code> and <code>yOn</code>,
</p>
<ul>
<li>
If <code>err &gt; deaBan</code> and <code>trigger</code> is <code>true</code>,
then <code>y = yHig</code> and <code>yOn = true</code>,
</li>
<li>
else if <code>err &lt; -deaBan</code> and <code>trigger</code> is <code>true</code>,
then <code>y = yLow</code> and
<code>yOn = false</code>,
</li>
<li>
else, <code>y</code> and <code>yOn</code> are kept as the initial values.
</li>
</ul>
<p>
where <code>deaBan</code> is a dead band, <code>yHig</code>
and <code>yLow</code>
are the higher value and the lower value of the output <code>y</code>, respectively.
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
