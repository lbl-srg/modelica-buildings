within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay;
block Controller
  "Output relay signals for tuning PID controllers"
  parameter Real r(min=100*Buildings.Controls.OBC.CDL.Constants.eps) = 1
    "Typical range of control error, used for scaling the control error";
  parameter Real yHig(
    final min=1E-6)
    "Higher value for the relay output";
  parameter Real yLow(
    final min=1E-6,
    final max=yHig)
    "Lower value for the relay output";
  parameter Real deaBan(min=1E-6)
    "Deadband for holding the relay output";
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
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant lowVal(
    final k=yLow)
    "Lower value for the output"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Switch between a higher value and a lower value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
    origin={-50,-40})));
  Buildings.Controls.OBC.CDL.Reals.Subtract revActErr if reverseActing
    "Control error when reverse acting, setpoint - measurement"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=-deaBan,
    final uHigh=deaBan,
    final pre_y_start=true)
    "Check if the input difference exceeds the thresholds, by default the relay control is on"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dirActErr if not reverseActing
    "Control error when direct acting, measurement - setpoint"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract meaSetDif
    "Inputs difference, (measurement - setpoint)"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiYDif(final k=1/r)
    "Gain to normalized control error by r"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiRevActErr(final k=1/r) if reverseActing
    "Gain to normalized control error by r"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiDirActErr(final k=1/r) if not reverseActing
    "Gain to normalized control error by r"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
equation
  connect(swi.y, y)
    annotation (Line(points={{82,50},{120,50}}, color={0,0,127}));
  connect(higVal.y, swi.u1)
    annotation (Line(points={{-58,70},{-20,70},{-20,58},{58,58}},color={0,0,127}));
  connect(lowVal.y, swi.u3) annotation (Line(points={{-58,30},{-20,30},{-20,42},
          {58,42}},color={0,0,127}));
  connect(swi1.u3, u_s) annotation (Line(points={{-62,-48},{-90,-48},{-90,0},{-120,
          0}}, color={0,0,127}));
  connect(trigger, swi1.u2) annotation (Line(points={{-80,-120},{-80,-40},{-62,-40}},
          color={255,0,255}));
  connect(u_m, swi1.u1) annotation (Line(points={{0,-120},{0,-90},{-70,-90},{-70,
          -32},{-62,-32}}, color={0,0,127}));
  connect(u_s, revActErr.u1) annotation (Line(points={{-120,0},{-90,0},{-90,-24},
          {-22,-24}}, color={0,0,127}));
  connect(u_s, dirActErr.u2) annotation (Line(points={{-120,0},{-90,0},{-90,-76},
          {-22,-76}}, color={0,0,127}));
  connect(swi1.y, revActErr.u2) annotation (Line(points={{-38,-40},{-30,-40},{-30,
          -36},{-22,-36}}, color={0,0,127}));
  connect(swi1.y, dirActErr.u1) annotation (Line(points={{-38,-40},{-30,-40},{-30,
          -64},{-22,-64}}, color={0,0,127}));
  connect(hys.y, swi.u2) annotation (Line(points={{82,-60},{90,-60},{90,34},{50,
          34},{50,50},{58,50}}, color={255,0,255}));
  connect(hys.y, yOn) annotation (Line(points={{82,-60},{120,-60}}, color={255,0,255}));
  connect(swi1.y, meaSetDif.u1) annotation (Line(points={{-38,-40},{-30,-40},{
          -30,6},{-22,6}},
                         color={0,0,127}));
  connect(u_s, meaSetDif.u2) annotation (Line(points={{-120,0},{-72,0},{-72,-6},
          {-22,-6}},
                color={0,0,127}));
  connect(meaSetDif.y, gaiYDif.u)
    annotation (Line(points={{2,0},{18,0}}, color={0,0,127}));
  connect(gaiYDif.y, yDif)
    annotation (Line(points={{42,0},{120,0}}, color={0,0,127}));
  connect(revActErr.y, gaiRevActErr.u)
    annotation (Line(points={{2,-30},{18,-30}}, color={0,0,127}));
  connect(gaiRevActErr.y, hys.u) annotation (Line(points={{42,-30},{48,-30},{48,
          -60},{58,-60}}, color={0,0,127}));
  connect(dirActErr.y, gaiDirActErr.u)
    annotation (Line(points={{2,-70},{18,-70}}, color={0,0,127}));
  connect(gaiDirActErr.y, hys.u) annotation (Line(points={{42,-70},{48,-70},{48,
          -60},{58,-60}}, color={0,0,127}));
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
        Line(points={{-70,24},{-34,24},{-34,58},{38,58},{38,24},{66,24}}, color
            ={28,108,200})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This block generates a relay output <code>yDif</code> which equals to
<code>(u_m - u_s)/r</code>.
<code>u_m</code> and <code>u_s</code>
are the measurement and the setpoint, respectively.
<code>r</code> is the typical range of control error.
</p>
<p>
This block also generates the control output <code>y</code>,
and a boolean relay switch output <code>yOn</code> using the following
procedure.
</p>
<p>
Step 1: Calculate control error,
</p>
<ul>
<li>
If the parameter <code>reverseActing = true</code>, set the control error <code>err</code> to
<code>(u_s - u_m)/r</code>,
else set it to <code>(u_m - u_s)/r</code>.
</li>
</ul>
<p>
Step 2: Calculate <code>y</code> and <code>yOn</code>,
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
<p>
J. Berner (2017).
<a href=\"https://lucris.lub.lu.se/ws/portalfiles/portal/33100749/ThesisJosefinBerner.pdf\">
\"Automatic Controller Tuning using Relay-based Model Identification.\"</a>
Department of Automatic Control, Lund University.
</p>
</html>", revisions="<html>
<ul>
<li>
March 8, 2024, by Michael Wetter:<br/>
Changed deadband to be consistent within the package.
</li>
<li>
March 8, 2024, by Michael Wetter:<br/>
Propagated range of control error <code>r</code> to relay controller.
</li>
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
