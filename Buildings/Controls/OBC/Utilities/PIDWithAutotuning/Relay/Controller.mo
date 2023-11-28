within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay;
block Controller
  "Output relay signals for tuning PID controllers"
  parameter Real yHig(min=1E-6) = 1
    "Higher value for the relay output";
  parameter Real yLow(min=1E-6) = 0.5
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
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOn
    "Relay switch output, true when control output switches to the higher value"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yErr
    "Control error"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
    iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.OnOffController greMeaSet(
    final bandwidth=deaBan*2,
    final pre_y_start=true)
    "Check if the measured value is larger than the reference, by default the relay control is on"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between a higher value and a lower value"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant higVal(
    final k=yHig)
    "Higher value for the output"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant lowVal(
    final k=-yLow)
    "Lower value for the output"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract conErr
    "Control error (set point - measurement)"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Switch between a higher value and a lower value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
    origin={-50,-50})));
initial equation
  assert(
    yHig-yLow>1E-6,
    "In " + getInstanceName() + "The higher value for the relay output should
    be larger than that of the lower value.");

equation
  connect(swi.y, y)
    annotation (Line(points={{82,0},{88,0},{88,60},{120,60}},  color={0,0,127}));
  connect(higVal.y, swi.u1)
    annotation (Line(points={{22,60},{40,60},{40,8},{58,8}},color={0,0,127}));
  connect(lowVal.y, swi.u3) annotation (Line(points={{22,-40},{40,-40},{40,-8},{
          58,-8}}, color={0,0,127}));
  connect(yOn, swi.u2) annotation (Line(points={{120,-60},{50,-60},{50,0},{58,0}},
        color={255,0,255}));
  connect(conErr.y, yErr) annotation (Line(points={{-38,20},{120,20}},
         color={0,0,127}));
  connect(greMeaSet.y, swi.u2)
    annotation (Line(points={{22,0},{58,0}},color={255,0,255}));
  connect(swi1.u3, u_s) annotation (Line(points={{-62,-58},{-90,-58},{-90,0},{-120,
          0}}, color={0,0,127}));

  connect(trigger, swi1.u2) annotation (Line(points={{-80,-120},{-80,-50},{-62,-50}},
        color={255,0,255}));
  connect(u_m, swi1.u1) annotation (Line(points={{0,-120},{0,-80},{-70,-80},{-70,
          -42},{-62,-42}}, color={0,0,127}));
   connect(swi1.y, conErr.u1) annotation (Line(points={{-38,-50},{-20,-50},{-20,-6},
          {-70,-6},{-70,26},{-62,26}}, color={0,0,127}));
   connect(conErr.u2, u_s) annotation (Line(points={{-62,14},{-90,14},{-90,0},{-120,
          0}}, color={0,0,127}));
  if reverseActing then

   connect(greMeaSet.reference, u_s)
    annotation (Line(points={{-2,6},{-40,6},{-40,0},{-120,0}},  color={0,0,127}));
   connect(swi1.y, greMeaSet.u) annotation (Line(points={{-38,-50},{-20,-50},{-20,
          -6},{-2,-6}}, color={0,0,127}));

  else

   connect(greMeaSet.reference, swi1.y)
    annotation (Line(points={{-2,6},{-40,6},{-40,-50},{-38,-50}},
                                                                color={0,0,127}));
   connect(u_s, greMeaSet.u) annotation (Line(points={{-120,0},{-20,0},{-20,-6},
            {-2,-6}},   color={0,0,127}));

  end if;
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
This block generates a real control output <code>y</code>, a
boolean relay switch output <code>yOn</code>, and the control error
<code>yErr</code>. They are calculated as below:
</p>
<ul>
<li>
<code>yErr = u_m - u_s</code>,
</li>
<li>
if <code>yErr &lt; -deaBan</code> and <code>trigger</code> is <code>true</code>,
then <code>y = yHig</code> (-yLow if the parameter <code>reverseActing = false</code>), <code>yOn = true</code>
 (<code>false</code> if the <code>reverseActing = false</code>),
</li>
<li>
if <code>yErr &gt; deaBan</code> and <code>trigger</code> is <code>true</code>,
then <code>y = -yLow</code> (yHig if the  <code>reverseActing = false</code>), 
<code>yOn = false</code> (<code>true</code> if the <code>reverseActing = false</code>),
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
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"));
end Controller;
