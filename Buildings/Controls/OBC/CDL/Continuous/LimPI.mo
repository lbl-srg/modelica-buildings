within Buildings.Controls.OBC.CDL.Continuous;
block LimPI
  "P and PI controller with limited output, anti-windup compensation and setpoint weighting"
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
         Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller";
  parameter Real k(
    min=0,
    unit="1") = 1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Constants.small) = 0.5
    "Time constant of integrator block"
    annotation (Dialog(enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real yMax "Upper limit of output";
  parameter Real yMin=-yMax "Lower limit of output";
  parameter Real wp(min=0) = 1 "Set-point weight for Proportional block (0..1)";
  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Buildings.Controls.OBC.CDL.Types.Init initType=
    Buildings.Controls.OBC.CDL.Types.Init.InitialState
    "Type of initialization"
    annotation(Evaluate=true,  Dialog(group="Initialization"));
  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization",
                enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real y_start=0 "Initial value of output"
    annotation(Dialog(enable=initType == Buildings.Controls.OBC.CDL.Types.Init.InitialOutput, group=
          "Initialization"));
  parameter Boolean reverseAction = false
    "Set to true for throttling the water flow rate through a cooling coil controller";
  // parameter Buildings.Controls.OBC.CDL.Types.Reset reset = Buildings.Controls.OBC.CDL.Types.Reset.Disabled
  parameter Buildings.Controls.OBC.CDL.Types.Reset reset = Buildings.Controls.OBC.CDL.Types.Reset.Disabled
    "Type of controller output reset"
    annotation(Evaluate=true, Dialog(group="Integrator reset"));
  parameter Real y_reset=xi_start
    "Value to which the controller output is reset if the boolean trigger has a rising edge, used if reset == CDL.Types.Reset.Parameter"
    annotation(Dialog(enable=reset == Buildings.Controls.OBC.CDL.Types.Reset.Parameter, group="Integrator reset"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput trigger if reset <> Buildings.Controls.OBC.CDL.Types.Reset.Disabled
    "Resets the controller output when trigger becomes true"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90, origin={-80,-120}),
     visible=reset <> Buildings.Controls.OBC.CDL.Types.Reset.Disabled));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y_reset_in if reset == Buildings.Controls.OBC.CDL.Types.Reset.Input
    "Input signal for state to which integrator is reset, enabled if reset = CDL.Types.Reset.Input"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
    visible=reset == Buildings.Controls.OBC.CDL.Types.Reset.Input));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-120}, extent={{20,-20},{-20,20}},
      rotation=270)));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yErr
    "Control error (set point - measurement)"
    annotation (Placement(transformation(extent={{100,-110},{140,-70}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Add addP(
    final k1=revAct*wp,
    final k2=-revAct)
    "Adder for P gain"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain P(final k=1) "Proportional term"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset I(
    final reset=if reset == Buildings.Controls.OBC.CDL.Types.Reset.Disabled
      then reset else Buildings.Controls.OBC.CDL.Types.Reset.Input,
    final y_reset=y_reset,
    final k=unitTime/Ti,
    final y_start=xi_start,
    final initType=if initType == Buildings.Controls.OBC.CDL.Types.Init.InitialState
          then Buildings.Controls.OBC.CDL.Types.Init.InitialState
          else Buildings.Controls.OBC.CDL.Types.Init.NoInit) if with_I "Integral term"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addPI(final k1=1, final k2=1)
    "Adder for the gains"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Izer(final k=0) if not with_I
    "Zero input signal"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=revAct, final k2=-revAct) if with_I
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addI if with_I "Adder for I gain"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain recGai(final k=1/k) if
       reset <> Buildings.Controls.OBC.CDL.Types.Reset.Disabled
    "Reciprocal of gain value"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add intRes(final k1=-1) if
       reset <> Buildings.Controls.OBC.CDL.Types.Reset.Disabled
    "Signal source for integrator reset"
    annotation (Placement(transformation(extent={{-12,-20},{8,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Add conErr(final k2=-1) "Control error"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));

protected
  constant Real unitTime(unit="s")=1 annotation (HideResult=true);
  final parameter Real revAct = if reverseAction then -1 else 1
    "Switch for sign for reverse action";
  parameter Boolean with_I = controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Boolean flag to enable integral action"
    annotation(Evaluate=true, HideResult=true);

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outRes(final k=y_reset) if
       reset == Buildings.Controls.OBC.CDL.Types.Reset.Parameter
    "Reset value of controller output"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addSat(
    final k1=+1,
    final k2=-1) if with_I
    "Adder for integrator feedback"
    annotation (Placement(transformation(origin={80,-10},extent={{-10,-10},{10,10}},
      rotation=270)));
  Buildings.Controls.OBC.CDL.Continuous.Gain gainPI(final k=k)
    "Multiplier for control gain"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gainTrack(final k=1/(k*Ni)) if with_I
    "Gain for anti-windup compensation"
    annotation (Placement(transformation(extent={{60,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter limiter(
    final uMax=yMax,
    final uMin=yMin) "Output limiter"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));

initial equation
  if initType==Buildings.Controls.OBC.CDL.Types.Init.InitialOutput then
    gainPI.y = y_start;
  end if;

equation
  assert(yMax >= yMin, "LimPID: Limits must be consistent. However, yMax (=" + String(yMax) +
                       ") < yMin (=" + String(yMin) + ")");
  if initType == Buildings.Controls.OBC.CDL.Types.Init.InitialOutput and (y_start < yMin or y_start > yMax) then
      Modelica.Utilities.Streams.error("LimPID: Start value y_start (=" + String(y_start) +
         ") is outside of the limits of yMin (=" + String(yMin) +") and yMax (=" + String(yMax) + ")");
  end if;

  connect(u_s, addP.u1)
    annotation (Line(points={{-120,0},{-96,0},{-96,86},{-82,86}},
      color={0,0,127}));
  connect(addP.y, P.u)
    annotation (Line(points={{-58,80},{-42,80}}, color={0,0,127}));
  connect(P.y, addPI.u1) annotation (Line(points={{-18,80},{-10,80},{-10,66},{-2,
          66}}, color={0,0,127}));
  connect(addPI.y, gainPI.u)
    annotation (Line(points={{22,60},{28,60}}, color={0,0,127}));
  connect(gainPI.y, addSat.u2) annotation (Line(points={{52,60},{60,60},{60,20},
          {74,20},{74,2}},    color={0,0,127}));
  connect(gainPI.y, limiter.u)
    annotation (Line(points={{52,60},{68,60}}, color={0,0,127}));
  connect(limiter.y, addSat.u1)
    annotation (Line(points={{92,60},{94,60},{94,20},{86,20},{86,2}},
      color={0,0,127}));
  connect(limiter.y, y)
    annotation (Line(points={{92,60},{94,60},{94,0},{120,0}},
                                              color={0,0,127}));
  connect(addSat.y, gainTrack.u)
    annotation (Line(points={{80,-22},{80,-40},{62,-40}},
      color={0,0,127}));
  connect(u_m, addP.u2)
    annotation (Line(points={{0,-120},{0,-92},{-92,-92},{-92,74},{-82,74}},
      color={0,0,127}, thickness=0.5));
  connect(trigger, I.trigger)
    annotation (Line(points={{-80,-120},{-80,-88},{30,-88},{30,8}},
      color={255,0,255}));
  connect(Izer.y, addPI.u2) annotation (Line(points={{-18,40},{-10,40},{-10,54},
          {-2,54}}, color={0,0,127}));
  connect(u_s, add2.u1) annotation (Line(points={{-120,0},{-96,0},{-96,46},{-82,
          46}},
        color={0,0,127}));
  connect(u_m, add2.u2) annotation (Line(points={{0,-120},{0,-92},{-92,-92},{-92,
          34},{-82,34}}, color={0,0,127}));
  connect(addI.y, I.u)
    annotation (Line(points={{-58,0},{-40,0},{-40,20},{18,20}},
                                                   color={0,0,127}));
  connect(add2.y, addI.u1) annotation (Line(points={{-58,40},{-50,40},{-50,20},{
          -88,20},{-88,6},{-82,6}},  color={0,0,127}));
  connect(gainTrack.y, addI.u2) annotation (Line(points={{38,-40},{-88,-40},{-88,
          -6},{-82,-6}},   color={0,0,127}));
  connect(recGai.y, intRes.u2) annotation (Line(points={{-28,-20},{-20,-20},{-20,
          -16},{-14,-16}}, color={0,0,127}));
  connect(intRes.y, I.y_reset_in) annotation (Line(points={{10,-10},{14,-10},{14,
          12},{18,12}}, color={0,0,127}));
  connect(add2.y, intRes.u1) annotation (Line(points={{-58,40},{-50,40},{-50,-4},
          {-14,-4}},  color={0,0,127}));
  connect(I.y, addPI.u2) annotation (Line(points={{42,20},{50,20},{50,40},{-10,40},
          {-10,54},{-2,54}}, color={0,0,127}));
  connect(u_s, conErr.u1) annotation (Line(points={{-120,0},{-96,0},{-96,-84},{58,
          -84}}, color={0,0,127}));
  connect(u_m, conErr.u2)
    annotation (Line(points={{0,-120},{0,-96},{58,-96}}, color={0,0,127}));
  connect(conErr.y, yErr)
    annotation (Line(points={{82,-90},{120,-90}}, color={0,0,127}));
  connect(outRes.y, recGai.u) annotation (Line(points={{-58,-60},{-56,-60},{-56,
          -20},{-52,-20}}, color={0,0,127}));
  connect(y_reset_in, recGai.u) annotation (Line(points={{-120,-80},{-84,-80},{-84,
          -20},{-52,-20}}, color={0,0,127}));
annotation (defaultComponentName="conPI",
Documentation(info="<html>
<p>
PI controller in the standard form
</p>
<p align=\"center\" style=\"font-style:italic;\">
y = k &nbsp; ( e(t) + 1 &frasl; T<sub>i</sub> &nbsp; &int; e(s) ds),
</p>
<p>
where
<i>y</i> is the control signal,
<i>e(t) = u<sub>s</sub> - u<sub>m</sub></i> is the control error,
with <i>u<sub>s</sub></i> being the set point and <i>u<sub>m</sub></i> being
the measured quantity,
<i>k</i> is the gain,
<i>T<sub>i</sub></i> is the time constant of the integral term and
</p>
<p>
Note that the units of <i>k</i> are the inverse of the units of the control error,
while the units of <i>T<sub>i</sub></i> are seconds.
</p>
<p>
For detailed treatment of integrator anti-windup, set-point weights and output limitation, see
<a href=\"modelica://Modelica.Blocks.Continuous.LimPID\">Modelica.Blocks.Continuous.LimPID</a>.
The model is similar to
<a href=\"modelica://Modelica.Blocks.Continuous.LimPID\">Modelica.Blocks.Continuous.LimPID</a>,
except for the following changes:
</p>

<ol>
<li>
<p>
It can be configured to have a reverse action.
</p>
<p>If the parameter <code>reverseAction=false</code> (the default), then
<code>u_m &lt; u_s</code> increases the controller output,
otherwise the controller output is decreased. Thus,
</p>
<ul>
  <li>for a heating coil with a two-way valve, set <code>reverseAction = false</code>, </li>
  <li>for a cooling coils with a two-way valve, set <code>reverseAction = true</code>. </li>
</ul>
</li>

<li>
<p>
It can be configured to enable an input port that allows resetting the controller
output. The controller output can be reset as follows:
</p>
<ul>
  <li>
  If <code>reset = CDL.Types.Reset.Disabled</code>, which is the default,
  then the controller output is never reset.
  </li>
  <li>
  If <code>reset = CDL.Types.Reset.Parameter</code>, then a boolean
  input signal <code>trigger</code> is enabled. Whenever the value of
  this input changes from <code>false</code> to <code>true</code>,
  the controller output is reset by setting <code>y</code>
  to the value of the parameter <code>y_reset</code>.
  </li>
  <li>
  If <code>reset = CDL.Types.Reset.Input</code>, then a boolean
  input signal <code>trigger</code> is enabled. Whenever the value of
  this input changes from <code>false</code> to <code>true</code>,
  the controller output is reset by setting <code>y</code>
  to the value of the input signal <code>y_reset_in</code>.
  </li>
</ul>
<p>
Note that this controller implements an integrator anti-windup. Therefore,
for most applications, keeping the default setting of
<code>reset = CDL.Types.Reset.Disabled</code> is sufficient.
Examples where it may be beneficial to reset the controller output are situations
where the equipment control input should continuously increase as the equipment is
switched on, such as as a light dimmer that may slowly increase the luminance, or
a variable speed drive of a motor that should continuously increase the speed.
</p>
</li>

<li>
The parameter <code>limitsAtInit</code> has been removed.
</li>

<li>
Some parameters assignments in the instances have been made final.
</li>

</ol>
<p>
For recommendations regarding tuning of closed loop control, see
<a href=\"modelica://Modelica.Blocks.Continuous.LimPID\">Modelica.Blocks.Continuous.LimPID</a>
or the control literature.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 14, 2020, by Jianjun Hu:<br/>
Removed derivative controller and reimplemented to use CDL elementary blocks. 
See <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1700\">issue 1700</a>.
</li>
<li>
October 19, 2019, by Michael Wetter:<br/>
Disabled homotopy to ensure bounded outputs
by copying the implementation from MSL 3.2.3 and by
hardcoding the implementation for <code>homotopyType=NoHomotopy</code>.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1221\">issue 1221</a>.
</li>
<li>
November 13, 2017, by Michael Wetter:<br/>
Changed default controller type from PID to PI.
</li>
<li>
November 6, 2017, by Michael Wetter:<br/>
Explicitly declared types and used integrator with reset from CDL.
</li>
<li>
October 22, 2017, by Michael Wetter:<br/>
Added to CDL to have a PI controller with integrator reset.
</li>
<li>
September 29, 2016, by Michael Wetter:<br/>
Refactored model.
</li>
<li>
August 25, 2016, by Michael Wetter:<br/>
Removed parameter <code>limitsAtInit</code> because it was only propagated to
the instance <code>limiter</code>, but this block no longer makes use of this parameter.
This is a non-backward compatible change.<br/>
Revised implemenentation, added comments, made some parameter in the instances final.
</li>
<li>July 18, 2016, by Philipp Mehrfeld:<br/>
Added integrator reset.
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/494\">issue 494</a>.
</li>
<li>
March 15, 2016, by Michael Wetter:<br/>
Changed the default value to <code>strict=true</code> in order to avoid events
when the controller saturates.
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/433\">issue 433</a>.
</li>
<li>
February 24, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={      Rectangle(
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
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
    Text(
      extent={{-150,150},{150,110}},
      textString="%name",
      lineColor={0,0,255}),
        Line(points={{-80,-80},{-80,-22}}, color={0,0,0}),
        Line(points={{-80,-22},{6,56}}, color={0,0,0}),
        Line(points={{6,56},{68,56}}, color={0,0,0})}),
    Diagram(graphics={                             Text(
            extent={{-102,34},{-142,24}},
            textString="(setpoint)",
            lineColor={0,0,255}),Text(
            extent={{-83,-112},{-33,-102}},
            textString=" (measurement)",
            lineColor={0,0,255}),Text(
            extent={{100,34},{140,24}},
            textString="(actuator)",
            lineColor={0,0,255})}));
end LimPI;
