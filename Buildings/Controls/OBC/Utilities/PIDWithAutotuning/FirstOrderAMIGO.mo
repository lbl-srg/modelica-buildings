within Buildings.Controls.OBC.Utilities.PIDWithAutotuning;
block FirstOrderAMIGO
  "A autotuning PID controller with an AMIGO tuner and a first order time delayed system model"
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
  parameter Real k_start(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Start value of the gain of controller"
    annotation (Dialog(group="Control gains"));
  parameter Real Ti_start(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.5
    "Start value of the time constant of integrator block"
    annotation (Dialog(group="Control gains",enable=controllerType == CDL.Types.SimpleController.PI or controllerType == CDL.Types.SimpleController.PID));
  parameter Real Td_start(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.1
    "Start value of the time constant of derivative block"
    annotation (Dialog(group="Control gains",enable=controllerType == CDL.Types.SimpleController.PD or controllerType == CDL.Types.SimpleController.PID));
  parameter Real yHig(min=1E-6) = 1
    "Higher value for the relay output";
  parameter Real yLow(min=1E-6) = 0.5
    "Lower value for the relay output";
  parameter Real deaBan(min=1E-6) = 0.5
    "Deadband for holding the output value";
  parameter Real yRef(min=1E-6) = 0.8
    "Reference output for the tuning process";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector for measurement input signal"
    annotation (Placement(transformation(origin={30,-120}, extent={{20,-20},{-20,20}},rotation=270),
        iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput tri
    "Resets the controller output when trigger becomes true"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={4,-120}),
        iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector for actuator output signal"
    annotation (Placement(transformation(extent={{100,-40},{140,0}}), iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller rel(
    final yHig=yHig,
    final yLow=yLow,
    final deaBan=deaBan)
    "A relay controller"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.Utilities.PIDWithInputGains PID(
    final controllerType=controllerType,
    final r=r,
    final yMax=yMax,
    final yMin=yMin,
    final Ni=Ni,
    final Nd= Nd,
    final xi_start=xi_start,
    final yd_start=yd_start,
    final reverseActing=reverseActing,
    final y_reset=xi_start)
     "A PID controller"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
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
    final deaBan=deaBan) "A block to approximate the control process"
    annotation (Placement(transformation(extent={{-20,40},{-40,60}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PI PIPar
    if not with_D "Parameters of a PI controller"
    annotation (Placement(transformation(extent={{-60,70},{-80,90}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PID PIDPar
    if with_D "Parameters of a PID controller"
    annotation (Placement(transformation(extent={{-60,40},{-80,60}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess resPro(
    final yHig=yHig - yRef,
    final yLow=yRef + yLow)
    "A block to process the response from the relay controller"
    annotation (Placement(transformation(extent={{20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.ModelTime modTim
    "Simulation time"
    annotation (Placement(transformation(extent={{80,60},{60,80}})));

protected
  final parameter Boolean with_D=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
    "Boolean flag to enable derivative action"
    annotation (Evaluate=true,HideResult=true);

initial equation
  assert(
    yHig-yRef>1E-6,
    "Higher value for the relay output should be larger than the reference output. Check parameters.");
  assert(
    controllerType <> Buildings.Controls.OBC.CDL.Types.SimpleController.PD and controllerType <> Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    "Only PI and PID are supported");

equation
   connect(PID.u_s, u_s) annotation (Line(points={{-2,-40},{-54,-40},{-54,0},{-120,
          0}}, color={0,0,127}));
  connect(rel.u_s, u_s) annotation (Line(points={{18,10},{0,10},{0,0},{-120,0}},
               color={0,0,127}));
  connect(PID.trigger, tri) annotation (Line(points={{4,-52},{4,-120}}, color={255,0,255}));
  connect(samk.y,PID. k) annotation (Line(points={{-18,-20},{-14,-20},{-14,-32},
          {-2,-32}}, color={0,0,127}));
  connect(PID.Ti, samTi.y) annotation (Line(points={{-2,-36},{-14,-36},{-14,-50},
          {-58,-50}}, color={0,0,127}));
  connect(samTd.y,PID. Td) annotation (Line(points={{-18,-70},{-6,-70},{-6,-44},
          {-2,-44}}, color={0,0,127}));
  connect(rel.u_m, u_m) annotation (Line(points={{30,-2},{30,-120}}, color={0,0,127}));
  connect(swi.u3, rel.y)
    annotation (Line(points={{58,-28},{52,-28},{52,16},{42,16}}, color={0,0,127}));
  connect(swi.u1,PID. y) annotation (Line(points={{58,-12},{40,-12},{40,-40},{22,
          -40}}, color={0,0,127}));
  connect(resPro.On, rel.yOn) annotation (Line(points={{22,34},{58,34},{58,4},{42,
          4}}, color={255,0,255}));
  connect(modTim.y, resPro.tim) annotation (Line(points={{58,70},{40,70},{40,46},
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
    annotation (Line(points={{-58,56},{-50,56},{-50,56.1},{-42,56.1}}, color={0,0,127}));
  connect(PIDPar.T, conProMod.T)
    annotation (Line(points={{-58,50},{-42,50}}, color={0,0,127}));
  connect(PIDPar.L, conProMod.L) annotation (Line(points={{-58,44},{-54,44},{-54,
          42},{-42,42}}, color={0,0,127}));
  connect(PIDPar.k, samk.u) annotation (Line(points={{-82,57},{-94,57},{-94,-20},
          {-42,-20}}, color={0,0,127}));
  connect(PIDPar.Ti, samTi.u) annotation (Line(points={{-82,50},{-90,50},{-90,-50},
          {-82,-50}}, color={0,0,127}));
  connect(PIPar.kp, conProMod.k) annotation (Line(points={{-58,86},{-46,86},{
          -46,56.1},{-42,56.1}}, color={0,0,127}));
  connect(PIPar.T, conProMod.T) annotation (Line(points={{-58,80},{-50,80},{-50,
          50},{-42,50}}, color={0,0,127}));
  connect(PIPar.L, conProMod.L) annotation (Line(points={{-58,74},{-54,74},{-54,
          42},{-42,42}}, color={0,0,127}));
  connect(PIPar.k, samk.u) annotation (Line(points={{-82,86},{-94,86},{-94,-20},
          {-42,-20}}, color={0,0,127}));
  connect(PIPar.Ti, samTi.u) annotation (Line(points={{-82,77},{-90,77},{-90,-50},
          {-82,-50}}, color={0,0,127}));
  connect(resPro.triEnd, conProMod.triEnd) annotation (Line(points={{-2,32},{-36,
          32},{-36,38}}, color={255,0,255}));
  connect(resPro.triSta, conProMod.triSta) annotation (Line(points={{-2,36},{-24,
          36},{-24,38}}, color={255,0,255}));
  connect(resPro.triEnd, swi.u2) annotation (Line(points={{-2,32},{-10,32},{-10,
          -20},{58,-20}},
                     color={255,0,255}));
  connect(resPro.triEnd, samTi.trigger) annotation (Line(points={{-2,32},{-10,
          32},{-10,10},{-70,10},{-70,-38}},
                                       color={255,0,255}));
  connect(resPro.triEnd, samk.trigger) annotation (Line(points={{-2,32},{-10,32},
          {-10,10},{-30,10},{-30,-8}},color={255,0,255}));
  connect(resPro.triEnd, samTd.trigger) annotation (Line(points={{-2,32},{-10,
          32},{-10,-44},{-30,-44},{-30,-58}},
                                         color={255,0,255}));
  connect(PIDPar.Td, samTd.u) annotation (Line(points={{-82,43},{-86,43},{-86,-70},
          {-42,-70}}, color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{82,-20},{120,-20}}, color={0,0,127}));
  connect(u_m, PID.u_m) annotation (Line(points={{30,-120},{30,-60},{10,-60},{10,
          -52}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This block implements an AMIGO PID tuning method and the control process is approximated with a first-order delay (FOD) process.
</p>
<p>
Specifically, this AMIGO PID tuning method is based on asymmetric relay feedback tests, providing process excitation 
at the frequency intervals relevant for PID control;
</p>
<p>
Based on the response of the control process to the excitation, the parameters of a FODs, time delay and time constant, are calculated;
</p>
<p>
Finally, the parameters of a PID controller are determined according to the parameters of the FOD.
</p>
<p>
This block consists of a relay controller and a PID controller with input gains.
</p>
<p>
Noted that this block can only support a PI controller or a PID controller.
</p>
<h4>Breif guidance</h4>
<p>
This block is built upon PIDWithInputGains<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithInputGains\">
Buildings.Controls.OBC.Utilities.PIDWithInputGains</a> and its connections are the same as those of the latter.
</p>
<p>
All the parameters of PIDWithInputGains are also used by this block, except the controller gains
<i>k</i>, <i>T<sub>i</sub></i>, and <i>T<sub>d</sub></i>, which are replaced with the initial values of those gains.
</p>
<p>
This block provides four additional parameters, <i>yHig</i>, <i>yLow</i>, <i>deaBan</i>, and <i>yRef</i>.
</p>
<p>
Note that the default values of those four parameters assume the control output is normalized.
</p>
<p>
More information regarding how to select the values of those four parameters can be found in the reference.
</p>
<p>
To use this block, connect it to the control loop. 
It will start the auto-tuning process once the simulation starts and detects when the auto-tuning process ends.
</p>
<p>
During the tuning process, the output of this block is from the embedded relay controller.
</p>
<p>
Once the auto-tuning process ends, this block changes the parameters of the embedded PID controller based on the tuning results.
and switch its output to that of the embedded PID controller.
</p>
<h4>References</h4>
<p>
J. Berner (2017).
\"Automatic Controller Tuning using Relay-based Model Identification.\"
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
          extent={{-158,144},{142,104}},
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
          visible=(controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI),
          extent={{-26,-22},{74,-62}},
          lineColor={0,0,0},
          textString="PI",
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
