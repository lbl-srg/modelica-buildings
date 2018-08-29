within Buildings.Controls.OBC.CDL.Continuous;
block LimPID
  "P, PI, PD, and PID controller with limited output, anti-windup compensation and setpoint weighting"
  output Real controlError = u_s - u_m
    "Control error (set point - measurement)";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
         Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller";
  parameter Real k(
    min=0,
    unit="1") = 1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Constants.small) = 0.5
    "Time constant of integrator block"
    annotation (Dialog(enable=
          controllerType == CDL.Types.SimpleController.PI or
          controllerType == CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(
    min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(enable=
          controllerType == CDL.Types.SimpleController.PD or
          controllerType == CDL.Types.SimpleController.PID));
  parameter Real yMax "Upper limit of output";
  parameter Real yMin=-yMax "Lower limit of output";
  parameter Real wp(min=0) = 1 "Set-point weight for Proportional block (0..1)";
  parameter Real wd(min=0) = 0 "Set-point weight for Derivative block (0..1)"
       annotation(Dialog(enable=controllerType==CDL.Types.SimpleController.PD or
                                controllerType==CDL.Types.SimpleController.PID));
  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(enable=controllerType==CDL.Types.SimpleController.PI or
                              controllerType==CDL.Types.SimpleController.PID));
  parameter Real Nd(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
       annotation(Dialog(enable=controllerType==CDL.Types.SimpleController.PD or
                                controllerType==CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.Init initType=
    Buildings.Controls.OBC.CDL.Types.Init.InitialState
    "Type of initialization"
    annotation(Evaluate=true,  Dialog(group="Initialization"));
      // Removed as the Limiter block no longer uses this parameter.
      // parameter Boolean limitsAtInit = true
      //  "= false, if limits are ignored during initialization"
      // annotation(Evaluate=true, Dialog(group="Initialization"));
  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization",
                enable=controllerType==CDL.Types.SimpleController.PI or
                       controllerType==CDL.Types.SimpleController.PID));
  parameter Real xd_start=0
    "Initial or guess value for state of derivative block"
    annotation (Dialog(group="Initialization",
                         enable=controllerType==CDL.Types.SimpleController.PD or
                                controllerType==CDL.Types.SimpleController.PID));
  parameter Real y_start=0 "Initial value of output"
    annotation(Dialog(enable=initType == CDL.Types.Init.InitialOutput, group=
          "Initialization"));
  parameter Boolean strict=true "= true, if strict limits with noEvent(..)"
    annotation (Evaluate=true, choices(checkBox=true), Dialog(tab="Advanced"));
  parameter Boolean reverseAction = false
    "Set to true for throttling the water flow rate through a cooling coil controller";
  parameter Buildings.Controls.OBC.CDL.Types.Reset reset = Buildings.Controls.OBC.CDL.Types.Reset.Disabled
    "Type of controller output reset"
    annotation(Evaluate=true, Dialog(group="Integrator reset"));
  parameter Real y_reset=xi_start
    "Value to which the controller output is reset if the boolean trigger has a rising edge, used if reset == CDL.Types.Reset.Parameter"
    annotation(Dialog(enable=reset == CDL.Types.Reset.Parameter, group="Integrator reset"));

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
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Add addP(
    k1=revAct*wp,
    k2=-revAct)
    "Adder for P gain"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addD(
    k1=revAct*wd,
    k2=-revAct) if with_D
    "Adder for D gain"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain P(k=1) "Proportional term"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset I(
    final reset=if reset == Buildings.Controls.OBC.CDL.Types.Reset.Disabled
      then reset else Buildings.Controls.OBC.CDL.Types.Reset.Input,
    final y_reset=y_reset,
    final k=unitTime/Ti,
    final y_start=xi_start,
    final initType=if initType == Buildings.Controls.OBC.CDL.Types.Init.InitialState
          then Buildings.Controls.OBC.CDL.Types.Init.InitialState
          else Buildings.Controls.OBC.CDL.Types.Init.NoInit) if with_I "Integral term"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Derivative D(
    final k=Td/unitTime,
    final T=max([Td/Nd,1.e-14]),
    final x_start=xd_start,
    final initType=
               if initType == Buildings.Controls.OBC.CDL.Types.Init.InitialState then
                 Buildings.Controls.OBC.CDL.Types.Init.InitialState
               else
                 Buildings.Controls.OBC.CDL.Types.Init.NoInit) if with_D "Derivative term"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Math.Add3 addPID(
    final k1=1,
    final k2=1,
    final k3=1) "Adder for the gains"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

protected
  constant Modelica.SIunits.Time unitTime=1 annotation (HideResult=true);
  final parameter Real revAct = if reverseAction then -1 else 1
    "Switch for sign for reverse action";
  parameter Boolean with_I = controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                             controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Boolean flag to enable integral action"
    annotation(Evaluate=true, HideResult=true);
  parameter Boolean with_D = controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                             controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Boolean flag to enable derivative action"
    annotation(Evaluate=true, HideResult=true);

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Dzero(
    final k=0) if not with_D
    "Zero input signal"
    annotation(Evaluate=true, HideResult=true,
               Placement(transformation(extent={{-30,20},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Izero(
    final k=0) if not with_I
    "Zero input signal"
    annotation(Evaluate=true, HideResult=true,
               Placement(transformation(extent={{10,-55},{0,-45}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y_reset_internal
   "Internal connector for controller output reset"
    annotation(Evaluate=true);
  Modelica.Blocks.Math.Add3 addI(
    final k1=revAct,
    final k2=-revAct) if with_I
    "Adder for I gain"
       annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addSat(
    final k1=+1,
    final k2=-1) if with_I
    "Adder for integrator feedback"
    annotation (Placement(transformation(origin={80,-50},extent={{-10,-10},{10,10}},
      rotation=270)));
  Buildings.Controls.OBC.CDL.Continuous.Gain gainPID(
    final k=k) "Multiplier for control gain"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gainTrack(k=1/(k*Ni)) if with_I
    "Gain for anti-windup compensation"
    annotation (
      Placement(transformation(extent={{60,-80},{40,-60}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(
    final uMax=yMax,
    final uMin=yMin,
    final strict=strict) "Output limiter"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Sources.RealExpression intRes(
    final y=y_reset_internal/k - addPID.u1 - addPID.u2) if
       reset <> Buildings.Controls.OBC.CDL.Types.Reset.Disabled
    "Signal source for integrator reset"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));


initial equation
  if initType==Buildings.Controls.OBC.CDL.Types.Init.InitialOutput then
     gainPID.y = y_start;
  end if;

equation
  assert(yMax >= yMin, "LimPID: Limits must be consistent. However, yMax (=" + String(yMax) +
                       ") < yMin (=" + String(yMin) + ")");
  if initType == Buildings.Controls.OBC.CDL.Types.Init.InitialOutput and (y_start < yMin or y_start > yMax) then
      Modelica.Utilities.Streams.error("LimPID: Start value y_start (=" + String(y_start) +
         ") is outside of the limits of yMin (=" + String(yMin) +") and yMax (=" + String(yMax) + ")");
  end if;

  // Equations for conditional connectors
  connect(y_reset_in, y_reset_internal);

  if reset <> Buildings.Controls.OBC.CDL.Types.Reset.Input then
    y_reset_internal = y_reset;
  end if;

  connect(u_s, addP.u1)
    annotation (Line(points={{-120,0},{-96,0},{-96,56},{-82,56}},
      color={0,0,127}));
  connect(u_s, addD.u1)
    annotation (Line(points={{-120,0},{-96,0},{-96,6},{-82,6}},
      color={0,0,127}));
  connect(u_s, addI.u1)
    annotation (Line(points={{-120,0},{-96,0},{-96,-42},{-82,-42}},
      color={0,0,127}));
  connect(addP.y, P.u)
    annotation (Line(points={{-59,50},{-42,50}}, color={0,0,127}));
  connect(addD.y, D.u)
    annotation (Line(points={{-59,0},{-42,0}}, color={0,0,127}));
  connect(addI.y, I.u)
    annotation (Line(points={{-59,-50},{-42,-50}},
      color={0,0,127}));
  connect(P.y, addPID.u1)
    annotation (Line(points={{-19,50},{-10,50},{-10,8},{-2,8}},
      color={0,0,127}));
  connect(D.y, addPID.u2)
    annotation (Line(points={{-19,0},{-2,0}}, color={0,0,127}));
  connect(I.y, addPID.u3)
    annotation (Line(points={{-19,-50},{-10,-50},{-10,-8},{-2,-8}},
      color={0,0,127}));
  connect(addPID.y, gainPID.u)
    annotation (Line(points={{21,0},{28,0}}, color={0,0,127}));
  connect(gainPID.y, addSat.u2)
    annotation (Line(points={{51,0},{60,0},{60,-20},{74,-20},{74,-38}},
      color={0,0,127}));
  connect(gainPID.y, limiter.u)
    annotation (Line(points={{51,0},{68,0}}, color={0,0,127}));
  connect(limiter.y, addSat.u1)
    annotation (Line(points={{91,0},{94,0},{94,-20},{86,-20},{86,-38}},
      color={0,0,127}));
  connect(limiter.y, y)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(addSat.y, gainTrack.u)
    annotation (Line(points={{80,-61},{80,-70},{62,-70}},
      color={0,0,127}));
  connect(gainTrack.y, addI.u3)
    annotation (Line(points={{39,-70},{-88,-70},{-88,-58},{-82,-58}},
      color={0,0,127}));
  connect(u_m, addP.u2)
    annotation (Line(points={{0,-120},{0,-92},{-92,-92},{-92,44},{-82,44}},
      color={0,0,127}, thickness=0.5));
  connect(u_m, addD.u2)
    annotation (Line(points={{0,-120},{0,-92},{-92,-92},{-92,-6},{-82,-6}},
      color={0,0,127}, thickness=0.5));
  connect(u_m, addI.u2)
    annotation (Line(points={{0,-120},{0,-92},{-92,-92},{-92,-50},{-82,-50}},
      color={0,0,127}, thickness=0.5));
  connect(Dzero.y, addPID.u2)
    annotation (Line(points={{-19.5,25},{-14,25},{-14,0},{-2,0}},
      color={0,0,127}));
  connect(Izero.y, addPID.u3)
    annotation (Line(points={{-0.5,-50},{-10,-50},{-10,-8},{-2,-8}},
      color={0,0,127}));
  connect(trigger, I.trigger)
    annotation (Line(points={{-80,-120},{-80,-88},{-30,-88},{-30,-62}},
      color={255,0,255}));
  connect(intRes.y, I.y_reset_in)
    annotation (Line(points={{-59,-80},{-50,-80},{-50,-58},{-42,-58}},
      color={0,0,127}));

annotation (defaultComponentName="conPID",
Documentation(info="<html>
<p>
PID controller in the standard form
</p>
<p align=\"center\" style=\"font-style:italic;\">
y = k &nbsp; ( e(t) + 1 &frasl; T<sub>i</sub> &nbsp; &int; e(s) ds + T<sub>d</sub> de(t)&frasl;dt ),
</p>
<p>
where
<i>y</i> is the control signal,
<i>e(t) = u<sub>s</sub> - u<sub>m</sub></i> is the control error,
with <i>u<sub>s</sub></i> being the set point and <i>u<sub>m</sub></i> being
the measured quantity,
<i>k</i> is the gain,
<i>T<sub>i</sub></i> is the time constant of the integral term and
<i>T<sub>d</sub></i> is the time constant of the derivative term.
</p>
<p>
Note that the units of <i>k</i> are the inverse of the units of the control error,
while the units of <i>T<sub>i</sub></i> and <i>T<sub>d</sub></i> are seconds.
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
            extent={{100,24},{140,14}},
            textString="(actuator)",
            lineColor={0,0,255})}));
end LimPID;
