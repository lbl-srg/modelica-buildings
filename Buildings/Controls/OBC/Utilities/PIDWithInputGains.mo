within Buildings.Controls.OBC.Utilities;
block PIDWithInputGains
  "P, PI, PD, and PID controller with output reset and input gains"
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real r(
    min=100*CDL.Constants.eps)=1
    "Typical range of control error, used for scaling the control error";
  parameter Real yMax=1
    "Upper limit of output"
    annotation (Dialog(group="Limits"));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(group="Limits"));
  parameter Real Ni(
    min=100*CDL.Constants.eps)=0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation (Dialog(tab="Advanced",group="Integrator anti-windup",enable=controllerType == CDL.Types.SimpleController.PI or controllerType ==CDL.Types.SimpleController.PID));
  parameter Real Nd(
    min=100*CDL.Constants.eps)=10
    "The higher Nd, the more ideal the derivative block"
    annotation (Dialog(tab="Advanced",group="Derivative block",enable=controllerType == CDL.Types.SimpleController.PD or controllerType ==CDL.Types.SimpleController.PID));
  parameter Real xi_start=0
    "Initial value of integrator state"
    annotation (Dialog(tab="Advanced",group="Initialization",enable=controllerType == CDL.Types.SimpleController.PI or controllerType == CDL.Types.SimpleController.PID));
  parameter Real yd_start=0
    "Initial value of derivative output"
    annotation (Dialog(tab="Advanced",group="Initialization",enable=controllerType == CDL.Types.SimpleController.PD or controllerType == CDL.Types.SimpleController.PID));
  parameter Boolean reverseActing=true
    "Set to true for reverse acting, or false for direct acting control action";
  parameter Real y_reset=xi_start
    "Value to which the controller output is reset if the boolean trigger has a rising edge"
    annotation (Dialog(enable=controllerType == CDL.Types.SimpleController.PI or controllerType == CDL.Types.SimpleController.PID,group="Integrator reset"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector for setpoint input signal"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector for measurement input signal"
    annotation (Placement(transformation(origin={0,-220},extent={{20,-20},{-20,20}},rotation=270),iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput k(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Connector for control gain signal"
    annotation (Placement(transformation(extent={{-260,160},{-220,200}}),iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Ti(
    quantity="Time",
    unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    if with_I
    "Connector for time constant signal for the integral term"
    annotation (Placement(transformation(extent={{-260,100},{-220,140}}),
    iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Td(
    quantity="Time",
    unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    if with_D
    "Connector for time constant signal for the derivative term"
    annotation (Placement(transformation(extent={{-260,40},{-220,80}}),   iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector for actuator output signal"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput trigger
    "Resets the controller output when trigger becomes true"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={-160,-220}),iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract controlError
    "Control error (set point - measurement)"
    annotation (Placement(transformation(extent={{-200,-16},{-180,4}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply P
    "Proportional action"
    annotation (Placement(transformation(extent={{-50,130},{-30,150}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset I(
    final k=1,
    final y_start=xi_start) if with_I
    "Integral term"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Derivative D(
    final y_start=yd_start) if with_D
    "Derivative term"
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract errP
    "P error"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract errD if with_D
    "D error"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract errI1 if with_I
    "I error (before anti-windup compensation)"
    annotation (Placement(transformation(extent={{-140,-4},{-120,16}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract errI2 if with_I
    "I error (after anti-windup compensation)"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter lim(
    final uMax=yMax,
    final uMin=yMin)
    "Limiter"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide antWinGai2 "Outputs of anti-windup compensation"
    annotation (Placement(transformation(extent={{100,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide gaiI if with_I "Gain of the integral term"
    annotation (Placement(transformation(extent={{-200,116},{-180,136}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply errIWithGai if with_I
    "I error (after multiplying with the gain of the integral term)"
    annotation (Placement(transformation(extent={{-84,28},{-64,48}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulkTd if with_D
    "Product of k and Td"
    annotation (Placement(transformation(extent={{-200,150},{-180,170}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThrkTd(
    t=1E-6,
    h=1E-6/2)
    if with_D
    "Check if k*Td is larger than 0"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));

protected
  final parameter Real revAct=
    if reverseActing then
      1
    else
      -1
    "Switch for sign for reverse or direct acting controller";
  final parameter Boolean with_I=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Boolean flag to enable integral action"
    annotation (Evaluate=true,HideResult=true);
  final parameter Boolean with_D=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Boolean flag to enable derivative action"
    annotation (Evaluate=true,HideResult=true);
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Dzero(
    final k=0) if not with_D
    "Zero input signal"
    annotation (Evaluate=true,HideResult=true,Placement(transformation(extent={{-50,90},
            {-30,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Izero(
    final k=0) if not with_I
    "Zero input signal"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter uS_revAct(
    final k=revAct/r) "Set point multiplied by reverse action sign"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter uMea_revAct(
    final k=revAct/r)
    "Set point multiplied by reverse action sign"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addPD
    "Outputs P and D gains added"
    annotation (Placement(transformation(extent={{20,124},{40,144}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addPID
    "Outputs P, I and D gains added"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract antWinErr if with_I
    "Error for anti-windup compensation"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter antWinGai1(k=1/Ni)
    if with_I "Gain for anti-windup compensation without the proportional gain"
    annotation (Placement(transformation(extent={{180,-30},{160,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yResSig(
    final k=y_reset) if with_I
    "Signal for y_reset"
    annotation (Placement(transformation(extent={{-140,-84},{-120,-64}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract addRes if with_I
    "Adder for integrator reset"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cheYMinMax(
    final k=yMin < yMax) "Check for values of yMin and yMax"
    annotation (Placement(transformation(extent={{140,120},{160,140}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesYMinMax(
    message="LimPID: Limits must be yMin < yMax") "Assertion on yMin and yMax"
    annotation (Placement(transformation(extent={{180,120},{200,140}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMeskTd(
    message="LimPIDWithInputGains: Limits must be k*Td > 0")
    if with_D
    "Assertion on k and Td"
    annotation (Placement(transformation(extent={{180,160},{200,180}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gaiT(final k=1/Nd) if with_D
    "Gain to compute time constant for derivative action"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

equation
  connect(trigger,I.trigger)
    annotation (Line(points={{-160,-220},{-160,-140},{-40,-140},{-40,-12}},color={255,0,255}));
  connect(u_s,uS_revAct.u)
    annotation (Line(points={{-240,0},{-210,0},{-210,40},{-202,40}},color={0,0,127}));
  connect(u_m,uMea_revAct.u)
    annotation (Line(points={{0,-220},{0,-160},{-210,-160},{-210,-40},{-202,-40}},color={0,0,127}));
  connect(errD.u2,uMea_revAct.y)
    annotation (Line(points={{-142,64},{-150,64},{-150,-40},{-178,-40}}, color={0,0,127}));
  connect(D.u,errD.y)
    annotation (Line(points={{-52,70},{-118,70}}, color={0,0,127}));
  connect(errI1.u1,uS_revAct.y)
    annotation (Line(points={{-142,12},{-170,12},{-170,40},{-178,40}},
                                                                    color={0,0,127}));
  connect(addPID.u1,addPD.y)
    annotation (Line(points={{78,96},{50,96},{50,134},{42,134}},color={0,0,127}));
  connect(lim.y,y)
    annotation (Line(points={{142,90},{200,90},{200,0},{240,0}},color={0,0,127}));
  connect(antWinErr.y, antWinGai1.u)
    annotation (Line(points={{182,60},{190,60},{190,-20},{182,-20}}, color={0,0,127}));
  connect(addPD.u2,Dzero.y)
    annotation (Line(points={{18,128},{-10,128},{-10,100},{-28,100}},
                                                color={0,0,127}));
  connect(D.y,addPD.u2)
    annotation (Line(points={{-28,70},{-10,70},{-10,128},{18,128}},color={0,0,127}));
  connect(addPID.u2,I.y)
    annotation (Line(points={{78,84},{68,84},{68,0},{-28,0}},color={0,0,127}));
  connect(addRes.y,I.y_reset_in)
    annotation (Line(points={{-78,-80},{-60,-80},{-60,-8},{-52,-8}},color={0,0,127}));
  connect(antWinErr.u2,lim.y)
    annotation (Line(points={{158,54},{150,54},{150,90},{142,90}},  color={0,0,127}));
  connect(errI1.y,errI2.u1)
    annotation (Line(points={{-118,6},{-102,6}},                  color={0,0,127}));
  connect(controlError.u1,u_s)
    annotation (Line(points={{-202,0},{-240,0}},                   color={0,0,127}));
  connect(cheYMinMax.y,assMesYMinMax.u)
    annotation (Line(points={{162,130},{178,130}},  color={255,0,255}));
  connect(Izero.y,addPID.u2)
    annotation (Line(points={{-28,30},{58,30},{58,84},{78,84}},
                                               color={0,0,127}));
  connect(errP.u1,uS_revAct.y)
    annotation (Line(points={{-142,146},{-170,146},{-170,40},{-178,40}},color={0,0,127}));
  connect(errD.u1,uS_revAct.y)
    annotation (Line(points={{-142,76},{-170,76},{-170,40},{-178,40}},color={0,0,127}));
  connect(addPD.u1, P.y)
    annotation (Line(points={{18,140},{-28,140}},                   color={0,0,127}));
  connect(addPID.y, lim.u)
    annotation (Line(points={{102,90},{118,90}},color={0,0,127}));
  connect(addPID.y, antWinErr.u1)
    annotation (Line(points={{102,90},{114,90},{114,66},{158,66}},color={0,0,127}));
  connect(addRes.u1, yResSig.y)
    annotation (Line(points={{-102,-74},{-118,-74}},                       color={0,0,127}));
  connect(u_m, controlError.u2)
    annotation (Line(points={{0,-220},{0,-160},{-210,-160},{-210,-12},{-202,-12}},
                                                                                 color={0,0,127}));
  connect(uMea_revAct.y, errP.u2)
    annotation (Line(points={{-178,-40},{-150,-40},{-150,134},{-142,134}}, color={0,0,127}));
  connect(uMea_revAct.y, errI1.u2)
    annotation (Line(points={{-178,-40},{-150,-40},{-150,0},{-142,0}},   color={0,0,127}));
  connect(addPD.y, addRes.u2)
    annotation (Line(points={{42,134},{50,134},{50,-100},{-110,-100},{-110,-86},
          {-102,-86}},                                                                       color={0,0,127}));
  connect(errP.y, P.u2)
    annotation (Line(points={{-118,140},{-74,140},{-74,134},{-52,134}},  color={0,0,127}));
  connect(P.u1, k)
    annotation (Line(points={{-52,146},{-70,146},{-70,188},{-212,188},{-212,180},
          {-240,180}},                                                                         color={0,0,127}));
  connect(antWinGai1.y, antWinGai2.u1)
    annotation (Line(points={{158,-20},{140,-20},{140,-14},{102,-14}},
                                                   color={0,0,127}));
  connect(antWinGai2.u2, k)
    annotation (Line(points={{102,-26},{108,-26},{108,188},{-212,188},{-212,180},
          {-240,180}},                                                               color={0,0,127}));
  connect(antWinGai2.y, errI2.u2)
    annotation (Line(points={{78,-20},{-110,-20},{-110,-6},{-102,-6}},
                                                                     color={0,0,127}));
  connect(gaiI.u1, k)
    annotation (Line(points={{-202,132},{-212,132},{-212,180},{-240,180}}, color={0,0,127}));
  connect(gaiI.u2, Ti)
    annotation (Line(points={{-202,120},{-240,120}},                      color={0,0,127}));
  connect(gaiI.y, errIWithGai.u1)
    annotation (Line(points={{-178,126},{-100,126},{-100,44},{-86,44}},color={0,0,127}));
  connect(errI2.y, errIWithGai.u2)
    annotation (Line(points={{-78,0},{-70,0},{-70,20},{-100,20},{-100,32},{-86,
          32}},                                                                    color={0,0,127}));
  connect(errIWithGai.y, I.u)
    annotation (Line(points={{-62,38},{-60,38},{-60,0},{-52,0}}, color={0,0,127}));
  connect(mulkTd.u1, k)
    annotation (Line(points={{-202,166},{-212,166},{-212,180},{-240,180}},color={0,0,127}));
  connect(greThrkTd.y, assMeskTd.u)
    annotation (Line(points={{162,170},{178,170}},   color={255,0,255}));
  connect(mulkTd.y, greThrkTd.u)
    annotation (Line(points={{-178,160},{-168,160},{-168,184},{132,184},{132,
          170},{138,170}},                                                                 color={0,0,127}));
  connect(mulkTd.u2, Td)
    annotation (Line(points={{-202,154},{-206,154},{-206,60},{-240,60}},color={0,0,127}));
  connect(Td, gaiT.u)
    annotation (Line(points={{-240,60},{-180,60},{-180,110},{-142,110}}, color={0,0,127}));
  connect(gaiT.y, D.T)
    annotation (Line(points={{-118,110},{-84,110},{-84,74},{-52,74}},   color={0,0,127}));
  connect(mulkTd.y, D.k) annotation (Line(points={{-178,160},{-168,160},{-168,
          184},{-80,184},{-80,78},{-52,78}}, color={0,0,127}));
  annotation (
    defaultComponentName="conPID",
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,-20},{66,-66}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          visible=(controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.P),
          extent={{-32,-22},{68,-62}},
          lineColor={0,0,0},
          textString="P",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(
          visible=(controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI),
          extent={{-26,-22},{74,-62}},
          lineColor={0,0,0},
          textString="PI",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(
          visible=(controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD),
          extent={{-16,-22},{88,-62}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="P D"),
        Text(
          visible=(controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID),
          extent={{-14,-22},{86,-62}},
          lineColor={0,0,0},
          textString="PID",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Polygon(
          points={{-80,82},{-88,60},{-72,60},{-80,82}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,68},{-80,-100}},
          color={192,192,192}),
        Line(
          points={{-90,-80},{70,-80}},
          color={192,192,192}),
        Polygon(
          points={{74,-80},{52,-72},{52,-88},{74,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{-80,-80},{-80,-22}},
          color={0,0,0}),
        Line(
          points={{-80,-22},{6,56}},
          color={0,0,0}),
        Line(
          points={{6,56},{68,56}},
          color={0,0,0}),
        Rectangle(
          extent=DynamicSelect({{100,-100},{84,-100}},{{100,-100},{84,-100+(y-yMin)/(yMax-yMin)*200}}),
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),
    Diagram(
      coordinateSystem(
        extent={{-220,-200},{220,200}}), graphics={Rectangle(
          extent={{-56,180},{-24,-16}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{-52,184},{-28,156}},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          textString="PID")}),
    Documentation(
      info="<html>
<p>
PID controller in the standard form
</p>
<p align=\"center\" style=\"font-style:italic;\">
y<sub>u</sub> = k/r &nbsp; (e(t) + 1 &frasl; T<sub>i</sub> &nbsp; &int; e(&tau;) d&tau; + T<sub>d</sub> d&frasl;dt e(t)),
</p>
<p>
with output reset,
where
<i>y<sub>u</sub></i> is the control signal before output limitation,
<i>e(t) = u<sub>s</sub>(t) - u<sub>m</sub>(t)</i> is the control error,
with <i>u<sub>s</sub></i> being the set point and <i>u<sub>m</sub></i> being
the measured quantity,
<i>k</i> is the gain,
<i>T<sub>i</sub></i> is the time constant of the integral term,
<i>T<sub>d</sub></i> is the time constant of the derivative term,
<i>r</i> is a scaling factor, with default <i>r=1</i>.
The scaling factor should be set to the typical order of magnitude of the range of the error <i>e</i>.
For example, you may set <i>r=100</i> to <i>r=1000</i>
if the control input is a pressure of a heating water circulation pump in units of Pascal, or
leave <i>r=1</i> if the control input is a room temperature.
</p>
<p>
Note that the units of <i>k</i> are the inverse of the units of the control error,
while the units of <i>T<sub>i</sub></i> and <i>T<sub>d</sub></i> are seconds.
</p>
<p>
The actual control output is
</p>
<p align=\"center\" style=\"font-style:italic;\">
y = min( y<sub>max</sub>, max( y<sub>min</sub>, y)),
</p>
<p>
where <i>y<sub>min</sub></i> and <i>y<sub>max</sub></i> are limits for the control signal.
</p>
<p>
This block is identical to
<a href=\"Buildings.Controls.OBC.CDL.Continuous.PIDWithReset\">
Buildings.Controls.OBC.CDL.Continuous.PIDWithReset</a>,
except that the controller gains
<i>k</i>, <i>T<sub>i</sub></i> and <i>T<sub>d</sub></i> are inputs rather than parameters.
</p>
<h4>P, PI, PD, or PID action</h4>
<p>
Through the parameter <code>controllerType</code>, the controller can be configured
as P, PI, PD or PID controller. The default configuration is PI.
</p>
<h4>Reverse or direct action</h4>
<p>
Through the parameter <code>reverseActing</code>, the controller can be configured to
be reverse or direct acting.
The above standard form is reverse acting, which is the default configuration.
For a reverse acting controller, for a constant set point,
an increase in measurement signal <code>u_m</code> decreases the control output signal <code>y</code>
(Montgomery and McDowall, 2008).
Thus,
</p>
<ul>
  <li>
  for a heating coil with a two-way valve, leave <code>reverseActing = true</code>, but
  </li>
  <li>
  for a cooling coil with a two-way valve, set <code>reverseActing = false</code>.
  </li>
</ul>
<p>
If <code>reverseAction=false</code>, then the error <i>e</i> above is multiplied by <i>-1</i>.
</p>
<h4>Anti-windup compensation</h4>
<p>
The controller anti-windup compensation is as follows:
Instead of the above basic control law, the implementation is
</p>
<p align=\"center\" style=\"font-style:italic;\">
y<sub>u</sub> = k &nbsp; (e(t) &frasl; r + 1 &frasl; T<sub>i</sub> &nbsp; &int; (-&Delta;y + e(&tau;) &frasl; r) d&tau; + T<sub>d</sub> &frasl; r d&frasl;dt e(t)),
</p>
<p>
where the anti-windup compensation <i>&Delta;y</i> is
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Delta;y = (y<sub>u</sub> - y) &frasl; (k N<sub>i</sub>),
</p>
<p>
where
<i>N<sub>i</sub> &gt; 0</i> is the time constant for the anti-windup compensation.
To accelerate the anti-windup, decrease <i>N<sub>i</sub></i>.
</p>
<p>
Note that the anti-windup term <i>(-&Delta;y + e(&tau;) &frasl; r)</i> shows that the range of
the typical control error <i>r</i> should be set to a reasonable value so that
</p>
<p align=\"center\" style=\"font-style:italic;\">
e(&tau;) &frasl; r = (u<sub>s</sub>(&tau;) - u<sub>m</sub>(&tau;)) &frasl; r
</p>
<p>
has order of magnitude one, and hence the anti-windup compensation should work well.
</p>
<h4>Reset of the controller output</h4>
<p>
Whenever the value of boolean input signal <code>trigger</code> changes from
<code>false</code> to <code>true</code>, the controller output is reset by setting
<code>y</code> to the value of the parameter <code>y_reset</code>.
</p>
<h4>Approximation of the derivative term</h4>
<p>
The derivative of the control error <i>d &frasl; dt e(t)</i> is approximated using
</p>
<p align=\"center\" style=\"font-style:italic;\">
d&frasl;dt x(t) = (e(t)-x(t)) N<sub>d</sub> &frasl; T<sub>d</sub>,
</p>
<p>
and
</p>
<p align=\"center\" style=\"font-style:italic;\">
d&frasl;dt e(t) &asymp; N<sub>d</sub> (e(t)-x(t)),
</p>
<p>
where <i>x(t)</i> is an internal state.
</p>
<h4>Guidance for tuning the control gains</h4>
<p>
The parameters of the controller can be manually adjusted by performing
closed loop tests (= controller + plant connected
together) and using the following strategy:
</p>
<ol>
<li> Set very large limits, e.g., set <i>y<sub>max</sub> = 1000</i>.
</li>
<li>
Select a <strong>P</strong>-controller and manually enlarge the parameter <code>k</code>
(the total gain of the controller) until the closed-loop response
cannot be improved any more.
</li>
<li>
Select a <strong>PI</strong>-controller and manually adjust the parameters
<code>k</code> and <code>Ti</code> (the time constant of the integrator).
The first value of <code>Ti</code> can be selected such that it is in the
order of the time constant of the oscillations occurring with
the P-controller. If, e.g., oscillations in the order of <i>100</i> seconds
occur in the previous step, start with <code>Ti=1/100</code> seconds.
</li>
<li>
If you want to make the reaction of the control loop faster
(but probably less robust against disturbances and measurement noise)
select a <strong>PID</strong>-controller and manually adjust parameters
<code>k</code>, <code>Ti</code>, <code>Td</code> (time constant of derivative block).
</li>
<li>
Set the limits <code>yMax</code> and <code>yMin</code> according to your specification.
</li>
<li>
Perform simulations such that the output of the PID controller
goes in its limits. Tune <code>Ni</code> (<i>N<sub>i</sub> T<sub>i</sub></i> is the time constant of
the anti-windup compensation) such that the input to the limiter
block (= <code>lim.u</code>) goes quickly enough back to its limits.
If <code>Ni</code> is decreased, this happens faster. If <code>Ni</code> is very large, the
anti-windup compensation is not effective and the controller works bad.
</li>
</ol>
<h4>References</h4>
<p>
R. Montgomery and R. McDowall (2008).
\"Fundamentals of HVAC Control Systems.\"
American Society of Heating Refrigerating and Air-Conditioning Engineers Inc. Atlanta, GA.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 17, 2022, by Sen Huang:<br/>
Changing the gains from parameters to inputs<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2993\">issue 2993</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Corrected error in non-released development version
when reset trigger is <code>true</code>.<br/>
Refactored implementation to have separate blocks that show the P, I and D contribution,
each with the control gain applied.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2475\">issue 2475</a>.
</li>
</ul>
</html>"));
end PIDWithInputGains;
