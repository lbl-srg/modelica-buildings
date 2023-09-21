within Buildings.Controls.OBC.Utilities.PIDWithAutotuning;
block FirstOrderAMIGO
  "An autotuning PID controller with an AMIGO tuner that employs a first-order time delayed system model"
  parameter Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController controllerType=Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PI
    "Type of controller";
  parameter Real r(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Typical range of control error, used for scaling the control error";
  final parameter Real yMax=1
    "Upper limit of output"
    annotation (Dialog(group="Limits"));
  final parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(group="Limits"));
  parameter Real Ni(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation (Dialog(tab="Advanced",group="Integrator anti-windup"));
  parameter Real Nd(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=10
    "The higher Nd, the more ideal the derivative block"
    annotation (Dialog(tab="Advanced",group="Derivative block",enable=controllerType ==Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID));
  parameter Real xi_start=0
    "Initial value of integrator state"
    annotation (Dialog(tab="Advanced",group="Initialization"));
  parameter Real yd_start=0
    "Initial value of derivative output"
    annotation (Dialog(tab="Advanced",group="Initialization",enable=controllerType == Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID));
  parameter Boolean reverseActing=true
    "Set to true for reverse acting, or false for direct acting control action";
  parameter Real y_reset=xi_start
    "Value to which the controller output is reset if the boolean trigger has a rising edge"
    annotation (Dialog(group="Integrator reset"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-120},  extent={{20,-20},{-20,20}},rotation=270),
        iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triRes
    "Connector for reseting the controller output"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120}),
        iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triTun
    "Connector for starting the autotuning"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={60,-120}),
        iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector for actuator output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.ModelTime modTim
    "Simulation time"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Buildings.Controls.OBC.Utilities.PIDWithInputGains PID(
    final controllerType=conTyp,
    final r=r,
    final yMax=yMax,
    final yMin=yMin,
    final Ni=Ni,
    final Nd= Nd,
    final xi_start=xi_start,
    final yd_start=yd_start,
    final reverseActing=reverseActing,
    final y_reset=xi_start) "PID controller with the gains as inputs"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PID PIDPar
    if with_D "Parameters of a PID controller"
    annotation (Placement(transformation(extent={{-60,40},{-80,60}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PI PIPar
    if not with_D "Parameters of a PI controller"
    annotation (Placement(transformation(extent={{-60,70},{-80,90}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller rel(
    final yHig=yHig,
    final yLow=yLow,
    final deaBan=deaBan) "Relay controller"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess resPro(
    final yHig=yHig - yRef,
    final yLow=yRef + yLow)
    "Identify the on and off period length, the half period ratio, and the moments when the tuning starts and ends"
    annotation (Placement(transformation(extent={{20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between a PID controller and a relay controller"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samk(y_start=k_start)
    "Recording the control gain"
    annotation (Placement(transformation(extent={{-40,-10},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samTi(y_start=Ti_start)
    "Recording the integral time"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samTd(y_start=Td_start) if with_D
    "Recording the derivative time"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-80}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel
    conProMod(
    final yHig=yHig - yRef,
    final yLow=yRef + yLow,
    final deaBan=deaBan)
    "Calculates the parameters of a first-order time delayed model"
    annotation (Placement(transformation(extent={{-20,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Logical.Latch inTunPro
    "True: it is in an autotuning process"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Nand nand
    "Check if an autotuning is ongoing while a new autotuning request is received"
    annotation (Placement(transformation(extent={{90,60},{70,80}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(final message="An autotuning is ongoing and an autotuning request is ignored")
    "Error message when an autotuning tuning is ongoing while a new autotuning request is received"
    annotation (Placement(transformation(extent={{60,60},{40,80}})));

protected
  final parameter Real k_start(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Start value of the gain of controller"
    annotation (Dialog(group="Control gains"));
  final parameter Real Ti_start(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.5
    "Start value of the time constant of integrator block"
    annotation (Dialog(group="Control gains"));
  final parameter Real Td_start(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.1
    "Start value of the time constant of derivative block"
    annotation (Dialog(group="Control gains",enable=controllerType == Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID));
  final parameter Real yHig(min=1E-6) = 1
    "Higher value for the relay output";
  final parameter Real yLow(min=1E-6) = 0.1
    "Lower value for the relay output";
  final parameter Real deaBan(min=1E-6) = 0.1
    "Deadband for holding the output value";
  final parameter Real yRef(min=1E-6) = 0.8
    "Reference output for the tuning process";
  final parameter Boolean with_D=controllerType == Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID
    "Boolean flag to enable derivative action"
    annotation (Evaluate=true,HideResult=true);
  final parameter Buildings.Controls.OBC.CDL.Types.SimpleController conTyp=
    if controllerType==Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PI
      then Buildings.Controls.OBC.CDL.Types.SimpleController.PI
      else Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Type of controller";

equation
   connect(PID.u_s, u_s) annotation (Line(points={{-2,-40},{-54,-40},{-54,0},{-120,
          0}}, color={0,0,127}));
  connect(rel.u_s, u_s) annotation (Line(points={{18,10},{0,10},{0,0},{-120,0}},
               color={0,0,127}));
  connect(PID.trigger, triRes) annotation (Line(points={{4,-52},{4,-90},{-60,-90},
          {-60,-120}}, color={255,0,255}));
  connect(samk.y,PID. k) annotation (Line(points={{-18,-20},{-14,-20},{-14,-32},
          {-2,-32}}, color={0,0,127}));
  connect(PID.Ti, samTi.y) annotation (Line(points={{-2,-36},{-14,-36},{-14,-50},
          {-58,-50}}, color={0,0,127}));
  connect(samTd.y,PID. Td) annotation (Line(points={{-18,-70},{-6,-70},{-6,-44},
          {-2,-44}}, color={0,0,127}));
  connect(rel.u_m, u_m) annotation (Line(points={{30,-2},{30,-60},{10,-60},{10,
          -96},{0,-96},{0,-120}}, color={0,0,127}));
  connect(resPro.on, rel.yOn) annotation (Line(points={{22,40},{58,40},{58,4},{42,
          4}}, color={255,0,255}));
  connect(modTim.y, resPro.tim) annotation (Line(points={{12,70},{28,70},{28,46},
          {22,46}}, color={0,0,127}));
  connect(resPro.tau, conProMod.tau) annotation (Line(points={{-2,40},{-10,40},{
          -10,42},{-18,42}}, color={0,0,127}));
  connect(conProMod.tOff, resPro.tOff) annotation (Line(points={{-18,46},{-10,46},
          {-10,44},{-2,44}}, color={0,0,127}));
  connect(resPro.tOn, conProMod.tOn) annotation (Line(points={{-2,48},{-10,48},{
          -10,54},{-18,54}}, color={0,0,127}));
  connect(rel.yErr, conProMod.u) annotation (Line(points={{42,10},{48,10},{48,58},
          {-18,58}}, color={0,0,127}));
  connect(PIDPar.kp, conProMod.k)
    annotation (Line(points={{-58,56},{-50,56},{-50,56},{-42,56}}, color={0,0,127}));
  connect(PIDPar.T, conProMod.T)
    annotation (Line(points={{-58,50},{-42,50}}, color={0,0,127}));
  connect(PIDPar.L, conProMod.L) annotation (Line(points={{-58,44},{-54,44},{
          -54,44},{-42,44}}, color={0,0,127}));
  connect(PIDPar.k, samk.u) annotation (Line(points={{-82,57},{-94,57},{-94,-20},
          {-42,-20}}, color={0,0,127}));
  connect(PIDPar.Ti, samTi.u) annotation (Line(points={{-82,50},{-90,50},{-90,-50},
          {-82,-50}}, color={0,0,127}));
  connect(PIPar.kp, conProMod.k) annotation (Line(points={{-58,86},{-46,86},{
          -46,56},{-42,56}}, color={0,0,127}));
  connect(PIPar.T, conProMod.T) annotation (Line(points={{-58,80},{-50,80},{-50,
          50},{-42,50}}, color={0,0,127}));
  connect(PIPar.L, conProMod.L) annotation (Line(points={{-58,74},{-54,74},{-54,
          44},{-42,44}}, color={0,0,127}));
  connect(PIPar.k, samk.u) annotation (Line(points={{-82,86},{-94,86},{-94,-20},
          {-42,-20}}, color={0,0,127}));
  connect(PIPar.Ti, samTi.u) annotation (Line(points={{-82,74},{-90,74},{-90,
          -50},{-82,-50}}, color={0,0,127}));
  connect(resPro.triEnd, conProMod.triEnd) annotation (Line(points={{-2,32},{-36,
          32},{-36,38}}, color={255,0,255}));
  connect(resPro.triSta, conProMod.triSta) annotation (Line(points={{-2,36},{-24,
          36},{-24,38}}, color={255,0,255}));
  connect(resPro.triEnd, samTi.trigger) annotation (Line(points={{-2,32},{-10,
          32},{-10,10},{-70,10},{-70,-38}}, color={255,0,255}));
  connect(resPro.triEnd, samk.trigger) annotation (Line(points={{-2,32},{-10,32},
          {-10,10},{-30,10},{-30,-8}},color={255,0,255}));
  connect(resPro.triEnd, samTd.trigger) annotation (Line(points={{-2,32},{-10,
          32},{-10,-44},{-30,-44},{-30,-58}}, color={255,0,255}));
  connect(PIDPar.Td, samTd.u) annotation (Line(points={{-82,43},{-86,43},{-86,-70},
          {-42,-70}}, color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{82,-20},{90,-20},{90,0},{120,0}}, color={0,0,127}));
  connect(u_m, PID.u_m) annotation (Line(points={{0,-120},{0,-96},{10,-96},{10,
          -52}}, color={0,0,127}));
  connect(rel.y, swi.u1) annotation (Line(points={{42,16},{54,16},{54,-12},{58,-12}},
        color={0,0,127}));
  connect(swi.u3, PID.y) annotation (Line(points={{58,-28},{40,-28},{40,-40},{22,
          -40}}, color={0,0,127}));
  connect(inTunPro.y, swi.u2) annotation (Line(points={{62,-70},{68,-70},{68,-40},
          {52,-40},{52,-20},{58,-20}}, color={255,0,255}));
  connect(inTunPro.u, triTun) annotation (Line(points={{38,-70},{30,-70},{30,-92},
          {60,-92},{60,-120}}, color={255,0,255}));
  connect(inTunPro.clr, resPro.triEnd) annotation (Line(points={{38,-76},{-10,-76},
          {-10,32},{-2,32}}, color={255,0,255}));
  connect(rel.trigger, triTun) annotation (Line(points={{24,-2},{24,-92},{60,-92},
          {60,-120}}, color={255,0,255}));
  connect(resPro.trigger, triTun) annotation (Line(points={{22,34},{96,34},{96,-92},
          {60,-92},{60,-120}}, color={255,0,255}));
  connect(nand.y, assMes.u)
    annotation (Line(points={{68,70},{62,70}}, color={255,0,255}));
  connect(nand.u2, triTun) annotation (Line(points={{92,62},{96,62},{96,-92},{60,
          -92},{60,-120}}, color={255,0,255}));
  connect(nand.u1, inTunPro.y) annotation (Line(points={{92,70},{98,70},{98,-70},
          {62,-70}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This block implements a rule-based PID tuning method.
Specifically, this PID tuning method approximates the control process with a
first-order time delayed (FOTD) model.
It then determines the parameters of this FOTD model based on the responses of
the control process to an asymmetric relay feedback.
After that, taking the parameters of this FOTD mode as inputs, this PID tuning
method calculates the PID parameters with an Approximate M-constrained Integral Gain Optimization (AMIGO) Tuner.
This block is built based on
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithInputGains\">
Buildings.Controls.OBC.Utilities.PIDWithInputGains</a>
and inherits most of the parameters of the latter. However, through the parameter
<code>controllerType</code>, the controller can only be configured as PI or
PID controller.
In addition, the output of this block is limited from 0 to 1.
</p>

<h4>Brief guidance</h4>
<p>
To use this block, connect it with a control loop.
Before the PID tuning process starts, this block is equivalent to <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithInputGains\">
Buildings.Controls.OBC.Utilities.PIDWithInputGains</a>.
This block starts the PID tuning process when a request for performing autotuning occurs, i.e., the value of the boolean input signal <code>triTun</code> changes from
<code>false</code> to <code>true</code>.
During the autotuning process, the output of the block changes into that of a relay controller (see <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller</a>).
The PID tuning process ends automatically (see details in <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.TuningMonitor\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.BaseClasses.Relay.TunMonitor</a>).
Since then, this block turns back to a PID controller but with tuned PID parameters.
</p>

<p>
<b>Note:</b> If an autotuning is ongoing, i.e., <code>inTunPro.y</code> is true, a request for performing autotuning will be ignored.
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
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"),
        defaultComponentName = "PIDWitTun",
        Icon(graphics={
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255}),
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
          extent={{-26,-22},{74,-62}},
          textString= if controllerType == Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID then "PID" else "PI",
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
          extent={{100,-100},{84,-100}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}));
end FirstOrderAMIGO;
