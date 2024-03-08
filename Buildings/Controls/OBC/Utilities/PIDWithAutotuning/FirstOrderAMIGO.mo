within Buildings.Controls.OBC.Utilities.PIDWithAutotuning;
block FirstOrderAMIGO
  "Autotuning PID controller with an AMIGO tuner that employs a first-order time delayed system model"
  parameter Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController controllerType=Buildings.Controls.OBC.Utilities.PIDWithAutotuning.
       Types.SimpleController.PI
    "Type of controller";
  parameter Real k_start(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Start value of the gain of controller"
    annotation (Dialog(group="Initial control gains, used prior to first tuning"));
  parameter Real Ti_start(unit="s")=0.5
    "Start value of the time constant of integrator block"
    annotation (Dialog(group="Initial control gains, used prior to first tuning"));
  parameter Real Td_start(unit="s")=0.1
    "Start value of the time constant of derivative block"
    annotation (Dialog(group="Initial control gains, used prior to first tuning",
      enable=controllerType == Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID));
  parameter Real r(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Typical range of control error, used for scaling the control error";
  parameter Real yHig = 1
    "Higher value for the relay output";
  parameter Real yLow = 0.1
    "Lower value for the relay output";
  parameter Real deaBan(min=1E-6) = 0.1
    "Deadband for holding the output value";
  parameter Real yRef = 0.8
    "Reference output for the tuning process";
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
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={-20,-120},extent={{20,-20},{-20,20}},rotation=270),
        iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triRes
    "Connector for resetting the controller output"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120}),
        iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triTun
    "Connector for starting the autotuning"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={60,-120}),
        iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector for actuator output signal"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.CivilTime modTim
    "Simulation time"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.Utilities.PIDWithInputGains con(
    final controllerType=conTyp,
    final r=r,
    final yMax=yMax,
    final yMin=yMin,
    final Ni=Ni,
    final Nd= Nd,
    final xi_start=xi_start,
    final yd_start=yd_start,
    final reverseActing=reverseActing,
    final y_reset=xi_start) "PI or P controller with the gains as inputs"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PID PIDPar
    if with_D "Autotuner of gains for a PID controller"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PI PIPar
    if not with_D "Autotuner of gains for a PI controller"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller rel(
    final r=r,
    final yHig=yHig,
    final yLow=yLow,
    final deaBan=deaBan,
    final reverseActing=reverseActing)
    "Relay controller"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess resPro(
    final yHig=yHig - yRef,
    final yLow=yRef - yLow)
    "Identify the on and off period length, the half period ratio, and the moments when the tuning starts and ends"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between a PID controller and a relay controller"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samk(final y_start=k_start)
    "Recording the proportional control gain"
    annotation (Placement(transformation(extent={{-100,-10},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samTi(final y_start=Ti_start)
    "Recording the integral time"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samTd(final y_start=Td_start) if with_D
    "Recording the derivative time"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-90}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel
    conProMod(
    final yHig=yHig - yRef,
    final yLow=yRef - yLow,
    final deaBan=deaBan)
    "Calculates the parameters of a first-order time delayed model"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Logical.Latch inTunPro
    "Outputs true if the controller is conducting the autotuning process"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Nand nand
    "Check if an autotuning is ongoing while a new autotuning request is received"
    annotation (Placement(transformation(extent={{120,-72},{140,-52}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    message="*** Warning: An autotuning is ongoing and the new autotuning request is ignored.")
    "Error message when an autotuning tuning is ongoing while a new autotuning request is received"
    annotation (Placement(transformation(extent={{148,-72},{168,-52}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgReq
    "True only when a new request is received"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tunStaDel(final delayTime=0.001)
    "A small time delay for the autotuning start time to avoid false alerts"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

protected
  final parameter Boolean with_D=controllerType == Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID
    "Boolean flag to enable derivative action"
    annotation (Evaluate=true,HideResult=true);
  final parameter Buildings.Controls.OBC.CDL.Types.SimpleController conTyp=
    if controllerType==Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PI
      then Buildings.Controls.OBC.CDL.Types.SimpleController.PI
      else Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Type of controller";
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes2(
     message="*** Warning: the relay output needs to be asymmetric.
     Check the value of yHig, yLow and yRef.")
    "Error message when the relay output is symmetric"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(final k=yHig)
    "Higher value for the relay output"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(final k=yRef)
    "Reference value for the relay output"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(final k=yLow)
    "Lower value for the relay output"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Difference between the higher value and the reference value of the relay output"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Difference between the reference value and the lower value of the relay output"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Symmetricity level of the relay output"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1
    "Absolute value"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre
    "Check if the relay output is asymmetric"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con4(final k=1e-3)
    "Threshold for checking the symmetricity of the relay output"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));

equation
  connect(con.u_s, u_s) annotation (Line(points={{-52,-40},{-60,-40},{-60,0},{-200,
          0}}, color={0,0,127}));
  connect(rel.u_s, u_s) annotation (Line(points={{-52,30},{-160,30},{-160,0},{-200,
          0}}, color={0,0,127}));
  connect(con.trigger, triRes) annotation (Line(points={{-46,-52},{-46,-90},{-60,
          -90},{-60,-120}},color={255,0,255}));
  connect(samk.y,con. k) annotation (Line(points={{-78,-20},{-66,-20},{-66,-32},
          {-52,-32}},color={0,0,127}));
  connect(con.Ti, samTi.y) annotation (Line(points={{-52,-36},{-66,-36},{-66,-50},
          {-98,-50}}, color={0,0,127}));
  connect(samTd.y,con. Td) annotation (Line(points={{-118,-80},{-60,-80},{-60,-44},
          {-52,-44}},color={0,0,127}));
  connect(rel.u_m, u_m) annotation (Line(points={{-40,18},{-40,-10},{-20,-10},{-20,
          -120}}, color={0,0,127}));
  connect(resPro.on, rel.yOn) annotation (Line(points={{-2,40},{-10,40},{-10,24},
          {-28,24}},color={255,0,255}));
  connect(modTim.y, resPro.tim) annotation (Line(points={{-38,70},{-26,70},{-26,
          46},{-2,46}},color={0,0,127}));
  connect(resPro.tau, conProMod.tau) annotation (Line(points={{22,40},{34,40},{34,
          62},{38,62}},color={0,0,127}));
  connect(conProMod.tOff, resPro.tOff) annotation (Line(points={{38,66},{30,66},
          {30,44},{22,44}},color={0,0,127}));
  connect(resPro.tOn, conProMod.tOn) annotation (Line(points={{22,48},{26,48},{26,
          74},{38,74}},color={0,0,127}));
  connect(rel.yDif, conProMod.u) annotation (Line(points={{-28,30},{-14,30},{-14,
          78},{38,78}}, color={0,0,127}));
  connect(PIDPar.kp, conProMod.k) annotation (Line(points={{78,36},{66,36},{66,76},
          {62,76}}, color={0,0,127}));
  connect(PIDPar.T, conProMod.T) annotation (Line(points={{78,30},{70,30},{70,70},
          {62,70}}, color={0,0,127}));
  connect(PIDPar.L, conProMod.L) annotation (Line(points={{78,24},{74,24},{74,64},
          {62,64}}, color={0,0,127}));
  connect(PIDPar.k, samk.u) annotation (Line(points={{102,37},{110,37},{110,96},
          {-148,96},{-148,-20},{-102,-20}},color={0,0,127}));
  connect(PIDPar.Ti, samTi.u) annotation (Line(points={{102,30},{112,30},{112,98},
          {-150,98},{-150,-50},{-122,-50}},color={0,0,127}));
  connect(PIPar.kp, conProMod.k) annotation (Line(points={{78,76},{62,76}},
          color={0,0,127}));
  connect(PIPar.T, conProMod.T) annotation (Line(points={{78,70},{62,70}},
          color={0,0,127}));
  connect(PIPar.L, conProMod.L) annotation (Line(points={{78,64},{62,64}},
          color={0,0,127}));
  connect(PIPar.k, samk.u) annotation (Line(points={{102,76},{110,76},{110,96},{
          -148,96},{-148,-20},{-102,-20}}, color={0,0,127}));
  connect(PIPar.Ti, samTi.u) annotation (Line(points={{102,64},{112,64},{112,98},
          {-150,98},{-150,-50},{-122,-50}}, color={0,0,127}));
  connect(resPro.triEnd, conProMod.triEnd) annotation (Line(points={{22,32},{56,
          32},{56,58}}, color={255,0,255}));
  connect(resPro.triSta, conProMod.triSta) annotation (Line(points={{22,36},{44,
          36},{44,58}}, color={255,0,255}));
  connect(resPro.triEnd, samTi.trigger) annotation (Line(points={{22,32},{30,32},
          {30,10},{-110,10},{-110,-38}}, color={255,0,255}));
  connect(resPro.triEnd, samk.trigger) annotation (Line(points={{22,32},{30,32},
          {30,10},{-90,10},{-90,-8}}, color={255,0,255}));
  connect(resPro.triEnd, samTd.trigger) annotation (Line(points={{22,32},{30,32},
          {30,10},{-130,10},{-130,-68}}, color={255,0,255}));
  connect(PIDPar.Td, samTd.u) annotation (Line(points={{102,23},{114,23},{114,94},
          {-146,94},{-146,-80},{-142,-80}}, color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{162,0},{200,0}}, color={0,0,127}));
  connect(u_m,con. u_m) annotation (Line(points={{-20,-120},{-20,-90},{-40,-90},
          {-40,-52}}, color={0,0,127}));
  connect(rel.y, swi.u1) annotation (Line(points={{-28,36},{-20,36},{-20,88},{130,
          88},{130,8},{138,8}}, color={0,0,127}));
  connect(swi.u3,con. y) annotation (Line(points={{138,-8},{60,-8},{60,-40},{-28,
          -40}}, color={0,0,127}));
  connect(inTunPro.y, swi.u2) annotation (Line(points={{42,-20},{50,-20},{50,0},
          {138,0}}, color={255,0,255}));
  connect(inTunPro.u, triTun) annotation (Line(points={{18,-20},{-6,-20},{-6,-70},
          {60,-70},{60,-120}}, color={255,0,255}));
  connect(inTunPro.clr, resPro.triEnd) annotation (Line(points={{18,-26},{12,-26},
          {12,10},{30,10},{30,32},{22,32}},color={255,0,255}));
  connect(rel.trigger, triTun) annotation (Line(points={{-46,18},{-46,0},{-6,0},
          {-6,-70},{60,-70},{60,-120}}, color={255,0,255}));
  connect(resPro.trigger, triTun) annotation (Line(points={{-2,34},{-6,34},{-6,-70},
          {60,-70},{60,-120}}, color={255,0,255}));
  connect(nand.y, assMes1.u)
    annotation (Line(points={{142,-62},{146,-62}}, color={255,0,255}));
  connect(nand.u2, edgReq.y)
    annotation (Line(points={{118,-70},{102,-70}}, color={255,0,255}));
  connect(edgReq.u, triTun)
    annotation (Line(points={{78,-70},{60,-70},{60,-120}}, color={255,0,255}));
  connect(tunStaDel.y, nand.u1) annotation (Line(points={{102,-30},{110,-30},{110,
          -62},{118,-62}}, color={255,0,255}));
  connect(tunStaDel.u, inTunPro.y) annotation (Line(points={{78,-30},{50,-30},{50,
          -20},{42,-20}}, color={255,0,255}));
  connect(con1.y, sub.u1) annotation (Line(points={{-118,180},{-108,180},{-108,176},
          {-102,176}}, color={0,0,127}));
  connect(con2.y, sub.u2) annotation (Line(points={{-138,150},{-108,150},{-108,164},
          {-102,164}}, color={0,0,127}));
  connect(sub1.u1, con2.y) annotation (Line(points={{-102,136},{-108,136},{-108,
          150},{-138,150}}, color={0,0,127}));
  connect(sub1.u2, con3.y) annotation (Line(points={{-102,124},{-108,124},{-108,
          120},{-118,120}}, color={0,0,127}));
  connect(sub.y, sub2.u1) annotation (Line(points={{-78,170},{-68,170},{-68,156},
          {-62,156}}, color={0,0,127}));
  connect(sub1.y, sub2.u2) annotation (Line(points={{-78,130},{-68,130},{-68,144},
          {-62,144}}, color={0,0,127}));
  connect(abs1.u, sub2.y)
    annotation (Line(points={{-22,150},{-38,150}}, color={0,0,127}));
  connect(abs1.y, gre.u1)
    annotation (Line(points={{2,150},{18,150}}, color={0,0,127}));
  connect(gre.y, assMes2.u)
    annotation (Line(points={{42,150},{58,150}}, color={255,0,255}));
  connect(con4.y, gre.u2) annotation (Line(points={{2,120},{10,120},{10,142},{18,
          142}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This block implements a rule-based PID tuning method.
</p>
<p>
The PID tuning method approximates the control process with a
first-order time delayed (FOTD) model.
It then determines the gain and delay of this FOTD model based on the responses of
the control process to an asymmetric relay feedback.
After that, taking the gain and delay of this FOTD mode as inputs, this PID tuning
method calculates the PID gains with an Approximate M-constrained Integral Gain Optimization (AMIGO) Tuner.
</p>
<p>
This block is implemented using
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithInputGains\">
Buildings.Controls.OBC.Utilities.PIDWithInputGains</a>
and inherits most of its configuration. However, through the parameter
<code>controllerType</code>, the controller can only be configured as PI or
PID controller.
In addition, the output of this block is limited from <i>0</i> to <i>1</i>.
</p>

<h4>Brief guidance</h4>
<p>
To use this block, place it in an control loop as any other PID controller.
Before the PID tuning process starts, this block is equivalent to <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithInputGains\">
Buildings.Controls.OBC.Utilities.PIDWithInputGains</a>.
This block starts the PID tuning process when a request for performing autotuning occurs, i.e.,
when the value of the boolean input signal <code>triTun</code> changes from
<code>false</code> to <code>true</code>.
During the autotuning process, the output of the block changes into that of a relay controller
(see <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller</a>).
The PID tuning process ends automatically
(see details in <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.TuningMonitor\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.BaseClasses.Relay.TunMonitor</a>),
at which point this block turns back to a PID controller but with tuned PID parameters.
</p>

<p>
<b>Note:</b> If an autotuning is ongoing, i.e., <code>inTunPro.y = true</code>,
a request for performing autotuning will be ignored.
</p>
<p>
In addition, this block requires an asymmetric relay output, meaning <code>yHig - yRef &ne; yRef - yLow</code>.
</p>
<p>
Besides, one need to adjust <code>deaBan</code> based on the response from the control loop.
e.g., decrease <code>deaBan</code> when the system response is slow to facilitate the tuning process.
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
Propagated range of control error <code>r</code> to relay controller.
</li>
<li>
October 23, 2023, by Michael Wetter:<br/>
Revised implmenentation. Made initial control gains public so that a stable operation can be made
prior to the first tuning.
</li>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"),
        defaultComponentName = "PIDWitTun",
        Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
             graphics={
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
          extent={{-56,100},{36,70}},
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
          extent=DynamicSelect({{100,-100},{84,-100}},{{100,-100},{84,-100+(y-yMin)/(yMax-yMin)*200}}),
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3))),
        Text(
          extent={{24,50},{-74,12}},
          textColor={0,0,0},
          textString=DynamicSelect(
            "k = " + String(k_start,
            leftJustified=false,
            significantDigits=3),
            "k = " + String(con.k,
            leftJustified=false,
            significantDigits=3))),
        Text(
          extent={{40,8},{-68,-28}},
          textColor={0,0,0},
          textString=DynamicSelect(
            "Ti = " + String(Ti_start,
            leftJustified=false,
            significantDigits=3),
            "Ti = " + String(con.Ti,
            leftJustified=false,
            significantDigits=3))),
        Text(
          visible = controllerType == Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID,
          extent={{44,-34},{-62,-70}},
          textColor={0,0,0},
          textString=DynamicSelect(
            "Td = " + String(Td_start,
            leftJustified=false,
            significantDigits=3),
            "Td = " + String(con.Td,
            leftJustified=false,
            significantDigits=3)))}),
    Diagram(coordinateSystem(extent={{-180,-100},{180,200}})));
end FirstOrderAMIGO;
