within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay;
block Controller
  "Output relay signals for tuning PID controllers"
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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput trigger
    "Resets the controller output when trigger becomes true"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={-80,-120}), iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Control output"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOn
    "Control switch output"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yErr
    "Control error"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.OnOffController greMeaSet(
    final bandwidth=deaBan*2, final pre_y_start=true)
    "Check if the measured value is larger than the reference, by default the relay control is on"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch between a higher value and a lower value"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant higVal(
    final k=yHig)
    "Higher value for the output"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowVal(
    final k=-yLow)
    "Lower value for the output"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract conErr
    "Control error (set point - measurement)"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Switch between a higher value and a lower value"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-48,-48})));
initial equation
  assert(
    yHig-yLow>1E-6,
    "In " + getInstanceName() + "The higher value for the relay output should
    be larger than that of the lower value.");

equation
  connect(swi.y, y)
    annotation (Line(points={{82,0},{88,0},{88,60},{120,60}},  color={0,0,127}));
  connect(greMeaSet.reference, u_s)
    annotation (Line(points={{-22,6},{-40,6},{-40,0},{-120,0}}, color={0,0,127}));
  connect(higVal.y, swi.u1)
    annotation (Line(points={{2,60},{20,60},{20,8},{58,8}}, color={0,0,127}));
  connect(lowVal.y, swi.u3) annotation (Line(points={{2,-40},{20,-40},{20,-8},{58,
          -8}}, color={0,0,127}));
  connect(yOn, swi.u2) annotation (Line(points={{120,-60},{40,-60},{40,0},{58,0}},
        color={255,0,255}));
  connect(conErr.y, yErr) annotation (Line(points={{-38,20},{120,20}},
                    color={0,0,127}));
  connect(greMeaSet.y, swi.u2)
    annotation (Line(points={{2,0},{58,0}}, color={255,0,255}));
  connect(conErr.u2, u_s) annotation (Line(points={{-62,14},{-80,14},{-80,0},{
          -120,0}}, color={0,0,127}));
  connect(swi1.u2, trigger) annotation (Line(points={{-48,-60},{-48,-80},{-80,
          -80},{-80,-120}}, color={255,0,255}));
  connect(swi1.y, greMeaSet.u)
    annotation (Line(points={{-48,-36},{-48,-6},{-22,-6}}, color={0,0,127}));
  connect(swi1.u1, u_m) annotation (Line(points={{-40,-60},{-40,-80},{0,-80},{0,
          -120}}, color={0,0,127}));
  connect(swi1.u3, u_s) annotation (Line(points={{-56,-60},{-56,-70},{-80,-70},
          {-80,0},{-120,0}}, color={0,0,127}));
  connect(conErr.u1, greMeaSet.u) annotation (Line(points={{-62,26},{-94,26},{
          -94,-20},{-48,-20},{-48,-6},{-22,-6}}, color={0,0,127}));
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
          visible=(controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI),
          extent={{-62,-10},{84,-52}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="Relay"),
        Line(points={{-70,24},{-34,24},{-34,58},{38,58},{38,24},{66,24}}, color
            ={28,108,200})}),                                    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This block generates a real control output <code>y</code>, a
boolean control switch output <code>y<sub>On</sub></code>, and the control error
<code>yErr</code>. They are calculated as below:
</p>
<ul>
<li>
<code>yErr = u<sub>s</sub>(t) - u<sub>m</sub>(t)</code>,
</li>
<li>
if <code>yErr &lt; - &delta;</code> and <code>trigger</code> is true, then <code>y(t) = y<sub>hig</sub>, y<sub>On</sub>(t) = true</code>,
</li>
<li>
if <code>yErr &gt; &delta;</code> and <code>trigger</code> is true, then <code>y(t) = -y<sub>low</sub>, y<sub>On</sub>(t) = false</code>,
</li>
<li>
else, <code>y(t) and y<sub>On</sub>(t) are kept unchanged</code>,
</li>
</ul>
<p>where <code>&delta;</code> is a dead band, <code>y<sub>hig</sub></code>
and <code>y<sub>low</sub></code>
are the higher value and the lower value of the output <code>y</code>, respectively.
</p>
<p>
Note that this block generates an asymmetric output, meaning <code>y<sub>hig</sub> &ne; y<sub>low</sub></code>.
</p>
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
