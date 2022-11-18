within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay;
block Controller
  "Outputs relay signals for tuning PID controllers"
  parameter Real yHig(min=1E-6) = 1
    "Higher value for the relay output";
  parameter Real yLow(min=1E-6) = 0.5
    "Lower value for the output";
  parameter Real deaBan(min=1E-6) = 0.5
    "Deadband for holding the output value";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Measurement input signal"
    annotation (Placement(transformation(origin={0,-120},extent={{20,-20},{-20,20}},rotation=270),
    iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Control output"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOn
    "Control switch output"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yErr
    "Control error"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.OnOffController greMeaSet(
    final bandwidth=deaBan*2,
    final pre_y_start=true)
    "Check if the measured value is larger than the reference, by default the relay control is On"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch between a higher value and a lower value"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yHigSig(
    final k=yHig)
    "Higher value for the output"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yLowSig(
    final k=-yLow)
    "Lower value for the output"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract conErr
    "Control error (set point - measurement)"
    annotation (Placement(transformation(extent={{-76,10},{-56,30}})));

initial equation
  assert(
    yHig-yLow>1E-6,
    "The absulte values of the higher value for the relay output should be larger than that of the lower value. Check parameters.");

equation
  connect(swi.y, y)
    annotation (Line(points={{82,0},{88,0},{88,60},{120,60}},
                                                            color={0,0,127}));
  connect(greMeaSet.reference, u_s)
    annotation (Line(points={{-22,6},{-40,6},{-40,0},{-120,0}},
                                               color={0,0,127}));
  connect(greMeaSet.u, u_m)
    annotation (Line(points={{-22,-6},{-64,-6},{-64,-94},
          {0,-94},{0,-120}}, color={0,0,127}));
  connect(yHigSig.y, swi.u1)
    annotation (Line(points={{-18,50},{50,50},{50,8},{58,
          8}}, color={0,0,127}));
  connect(yLowSig.y, swi.u3)
    annotation (Line(points={{-18,-40},{50,-40},{50,-8},
          {58,-8}}, color={0,0,127}));
  connect(yOn, swi.u2) annotation (Line(points={{120,-60},{52,-60},{52,0},{58,0}},
        color={255,0,255}));
  connect(conErr.y, yErr) annotation (Line(points={{-54,20},{94,20},{94,0},{120,
          0}}, color={0,0,127}));
  connect(greMeaSet.y, swi.u2)
    annotation (Line(points={{2,0},{58,0}}, color={255,0,255}));
  connect(conErr.u1, u_m) annotation (Line(points={{-78,26},{-90,26},{-90,-6},{
          -64,-6},{-64,-94},{0,-94},{0,-120}}, color={0,0,127}));
  connect(conErr.u2, u_s) annotation (Line(points={{-78,14},{-80,14},{-80,0},{-120,
          0}}, color={0,0,127}));
  annotation (defaultComponentName = "relCon",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-148,154},{152,114}},
          textString="%name",
          textColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This block grenerates a real control output signal, y, and a boolean control switch signal, y<sub>On</sub>, as described below:</p>
<p>if e(t) &lt; - &delta;, then y(t) = y<sub>hig</sub>, y<sub>On</sub>(t) = true</p>
<p>if e(t) &gt; &delta;, then y(t) = -y<sub>low</sub>, y<sub>On</sub>(t) = false</p>
<p>otherwise, y(t) = y(t-&Delta;t), y<sub>On</sub>(t) = y<sub>On</sub>(t-&Delta;t)</p>
<p>where <i>&delta;</i> is a dead band, <i>e(t) = u<sub>s</sub>(t) - u<sub>m</sub>(t)</i> is the control error, <i>y<sub>hig</sub></i> and <i>y<sub>low</sub></i> are the higher value and the lower value of the output <i>y,</i> respectively.</p>
<p><i>t-&Delta;t</i> is the previous time step.</p>
<p>Note that this block generates an asymmetric signal, meaning <i>y<sub>hig</sub> &ne; y<sub>low</sub></i>.</p>
<h4>References</h4>
<p>Josefin Berner (2017)
\"Automatic Controller Tuning using Relay-based Model Identification.\"
Department of Automatic Control, Lund Institute of Technology, Lund University.</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"));
end Controller;
