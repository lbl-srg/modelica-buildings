within Buildings.Controls.OBC.Utilities.PIDWithAutotuning;
block FirstOrderAMIGO
  "Autotuning PID controller with an AMIGO tuner that employs a first-order time delayed system model"

  parameter Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController controllerType=
    Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PI
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
  parameter Real u_s_start
    "Start value of the set point"
    annotation (Dialog(tab="Advanced",group="Initialization"));
  parameter Real r(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Typical range of control error, used for scaling the control error";
  parameter Real yHig(
     final min = 0,
     final max = 1) = 1
    "Higher value for the relay output";
  parameter Real yLow(
     final min = 0,
     final max = 1)
    "Lower value for the relay output";
  parameter Real deaBan(
    final min=1E-6)
    "Deadband for holding the relay output";
  parameter Real yRef
    "Reference output for the tuning process. It should be greater than the lower and less than the higher value of the relay output";
  parameter Real yMax = 1
    "Upper limit of output"
    annotation (Dialog(group="Limits"));
  parameter Real yMin = 0
    "Lower limit of output"
    annotation (Dialog(group="Limits"));
  parameter Real Ni(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation (Dialog(tab="Advanced",group="Integrator anti-windup"));
  parameter Real Nd(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=10
    "The higher the Nd, the more ideal the derivative block"
    annotation (Dialog(tab="Advanced",group="Derivative block",
      enable=controllerType ==Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID));
  parameter Real xi_start=0
    "Initial value of integrator state"
    annotation (Dialog(tab="Advanced",group="Initialization"));
  parameter Real yd_start=0
    "Initial value of derivative output"
    annotation (Dialog(tab="Advanced",group="Initialization",
      enable=controllerType == Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID));
  parameter Boolean reverseActing=true
    "Set to true for reverse acting, or false for direct acting control action";
  parameter Real y_reset=xi_start
    "Value to which the controller output is reset if the boolean trigger has a rising edge"
    annotation (Dialog(group="Integrator reset"));
  parameter Real setHys = 0.05*r
    "Hysteresis for checking set point";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-220,-40},{-180,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={-20,-140},extent={{20,-20},{-20,20}},rotation=270),
        iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triRes
    "Connector for resetting the controller output"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-140}),
        iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triTun
    "Connector for starting the autotuning"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={60,-140}),
        iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector for actuator output signal"
    annotation (Placement(transformation(extent={{180,-40},{220,0}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.CivilTime modTim
    "Simulation time"
    annotation (Placement(transformation(extent={{-160,180},{-140,200}})));
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
    final y_reset=xi_start)
    "PI or P controller with the gains as inputs"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PID PIDPar
    if with_D "Autotuner of gains for a PID controller"
    annotation (Placement(transformation(extent={{80,92},{100,112}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PI PIPar
    if not with_D "Autotuner of gains for a PI controller"
    annotation (Placement(transformation(extent={{84,156},{104,176}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller rel(
    final r=r,
    final yHig=yHig,
    final yLow=yLow,
    final deaBan=deaBan,
    final reverseActing=reverseActing)
    "Relay controller"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess resPro(
    final yHig=yHig - yRef,
    final yLow=yRef - yLow)
    "Identify the on and off period length, the half period ratio, 
    and the moments when the tuning starts and ends"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between a PID controller and a relay controller"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samk(
    final y_start=k_start) "Recording the proportional control gain"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samTi(
    final y_start=Ti_start)
    "Recording the integral time"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samTd(
    final y_start=Td_start) if with_D
    "Recording the derivative time"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-110}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel
    conProMod(
    final yHig=yHig - yRef,
    final yLow=yRef - yLow,
    final deaBan=deaBan)
    "Calculates the parameters of a first-order time delayed model"
    annotation (Placement(transformation(extent={{32,154},{52,174}})));
  Buildings.Controls.OBC.CDL.Logical.Latch inTunPro
    "Outputs true if the controller is conducting the autotuning process"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Check if the setpoint changes during an autotuning process"
    annotation (Placement(transformation(extent={{-148,220},{-128,240}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if the autotuning is completed or aborted"
    annotation (Placement(transformation(extent={{-84,220},{-64,240}})));
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
    message="*** Warning: the relay output needs to be asymmetric. Check the value of yHig, yLow and yRef.")
    "Warning message when the relay output is symmetric"
    annotation (Placement(transformation(extent={{150,370},{170,390}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(final k=yHig)
    "Higher value for the relay output"
    annotation (Placement(transformation(extent={{-160,390},{-140,410}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(final k=yRef)
    "Reference value for the relay output"
    annotation (Placement(transformation(extent={{-160,360},{-140,380}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(final k=yLow)
    "Lower value for the relay output"
    annotation (Placement(transformation(extent={{-160,330},{-140,350}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Difference between the higher value and the reference value of the relay output"
    annotation (Placement(transformation(extent={{-100,370},{-80,390}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Difference between the reference value and the lower value of the relay output"
    annotation (Placement(transformation(extent={{-100,330},{-80,350}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Symmetricity level of the relay output"
    annotation (Placement(transformation(extent={{-40,350},{-20,370}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1
    "Absolute value"
    annotation (Placement(transformation(extent={{0,338},{20,358}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre
    "Check if the relay output is asymmetric"
    annotation (Placement(transformation(extent={{60,390},{80,370}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con4(final k=1e-3)
    "Threshold for checking if the input is larger than 0"
    annotation (Placement(transformation(extent={{0,378},{20,398}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter yRel(
    final k=yMax - yMin)
    "Relay output multiplied by the possible range of the output"
    annotation (Placement(transformation(extent={{40,210},{60,230}})));
  Buildings.Controls.OBC.CDL.Logical.Nand nand
    "Check if an autotuning is ongoing while a new autotuning request is received"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    message="*** Warning: An autotuning is ongoing and the new tuning request is ignored.")
    "Warning message when an autotuning tuning is ongoing while a new autotuning request is received"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgReq
    "True only when a new request is received"
    annotation (Placement(transformation(extent={{12,-50},{32,-30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tunStaDel(
    final delayTime=0.001)
    "A small time delay for the autotuning start time to avoid false alerts"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=yMin)
    "Sums the inputs"
    annotation (Placement(transformation(extent={{80,210},{100,230}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler sam_u_s(
    final y_start=u_s_start)
    "Recording the setpoint"
    annotation (Placement(transformation(extent={{-122,284},{-102,304}})));
  Buildings.Controls.OBC.CDL.Logical.Nand nand1
    "Check if an autotuning is ongoing while the setpoint changes"
    annotation (Placement(transformation(extent={{94,290},{114,310}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub3
    "Change of the setpoint"
    annotation (Placement(transformation(extent={{-40,264},{-20,284}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs2
    "Absolute value of the setpoint change"
    annotation (Placement(transformation(extent={{0,284},{20,304}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=setHys,
    final h=0.5*setHys)
    "Check if the setpoint changes"
    annotation (Placement(transformation(extent={{40,290},{60,310}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes3(message="In " +
        getInstanceName() +
        ": the setpoint must not change when an autotuning tuning is ongoing. This ongoing autotuning will thus abort.")
    "Warning message when the setpoint changes during tuning process"
    annotation (Placement(transformation(extent={{150,290},{170,310}})));

equation
  connect(con.u_s, u_s) annotation (Line(points={{-52,-60},{-60,-60},{-60,-20},{
          -200,-20}}, color={0,0,127}));
  connect(con.trigger, triRes) annotation (Line(points={{-46,-72},{-46,-110},{-60,
          -110},{-60,-140}}, color={255,0,255}));
  connect(samk.y,con. k) annotation (Line(points={{-78,-40},{-66,-40},{-66,-52},
          {-52,-52}},color={0,0,127}));
  connect(con.Ti, samTi.y) annotation (Line(points={{-52,-56},{-66,-56},{-66,-70},
          {-98,-70}}, color={0,0,127}));
  connect(samTd.y,con. Td) annotation (Line(points={{-118,-100},{-60,-100},{-60,
          -64},{-52,-64}}, color={0,0,127}));
  connect(resPro.on, rel.yOn) annotation (Line(points={{-2,110},{-30,110},{-30,
          124},{-38,124}},
                    color={255,0,255}));
  connect(modTim.y, resPro.tim) annotation (Line(points={{-138,190},{-4,190},{
          -4,126},{-10,126},{-10,116},{-2,116}},
                       color={0,0,127}));
  connect(resPro.tau, conProMod.tau) annotation (Line(points={{22,110},{30,110},
          {30,156}},    color={0,0,127}));
  connect(conProMod.tOff, resPro.tOff) annotation (Line(points={{30,160},{26,
          160},{26,114},{22,114}},
                           color={0,0,127}));
  connect(resPro.tOn, conProMod.tOn) annotation (Line(points={{22,118},{22,168},
          {30,168}},    color={0,0,127}));
  connect(rel.yDif, conProMod.u) annotation (Line(points={{-38,130},{18,130},{
          18,172},{30,172}},
                        color={0,0,127}));
  connect(PIDPar.kp, conProMod.k) annotation (Line(points={{78,108},{64,108},{
          64,172},{54,172}},
                    color={0,0,127}));
  connect(PIDPar.T, conProMod.T) annotation (Line(points={{78,102},{60,102},{60,
          148},{62,148},{62,168},{54,168}},
                    color={0,0,127}));
  connect(PIDPar.L, conProMod.L) annotation (Line(points={{78,96},{58,96},{58,
          150},{60,150},{60,160},{54,160}},
                    color={0,0,127}));
  connect(PIDPar.k, samk.u) annotation (Line(points={{102,109},{102,110},{146,
          110},{146,78},{-154,78},{-154,-40},{-102,-40}},
                                           color={0,0,127}));
  connect(PIDPar.Ti, samTi.u) annotation (Line(points={{102,102},{118,102},{118,
          -6},{-124,-6},{-124,-70},{-122,-70}},
                                           color={0,0,127}));
  connect(PIPar.kp, conProMod.k) annotation (Line(points={{82,172},{54,172}},
                    color={0,0,127}));
  connect(PIPar.T, conProMod.T) annotation (Line(points={{82,166},{62,166},{62,
          168},{54,168}},
                    color={0,0,127}));
  connect(PIPar.L, conProMod.L) annotation (Line(points={{82,160},{54,160}},
                    color={0,0,127}));
  connect(PIPar.k, samk.u) annotation (Line(points={{106,172},{156,172},{156,70},
          {-148,70},{-148,-40},{-102,-40}},color={0,0,127}));
  connect(PIPar.Ti, samTi.u) annotation (Line(points={{106,160},{166,160},{166,
          48},{-140,48},{-140,-70},{-122,-70}},
                                            color={0,0,127}));
  connect(resPro.triSta, conProMod.triSta) annotation (Line(points={{22,106},{
          36,106},{36,152}},
                        color={255,0,255}));
  connect(PIDPar.Td, samTd.u) annotation (Line(points={{102,95},{102,94},{112,
          94},{112,88},{-162,88},{-162,-100},{-142,-100}},
                                              color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{162,-20},{200,-20}}, color={0,0,127}));
  connect(u_m,con. u_m) annotation (Line(points={{-20,-140},{-20,-110},{-40,-110},
          {-40,-72}}, color={0,0,127}));
  connect(swi.u3,con. y) annotation (Line(points={{138,-28},{56,-28},{56,-60},{
          -28,-60}},
                 color={0,0,127}));
  connect(inTunPro.y, swi.u2) annotation (Line(points={{-18,30},{-6,30},{-6,-20},
          {138,-20}}, color={255,0,255}));
  connect(inTunPro.u, triTun) annotation (Line(points={{-42,30},{-56,30},{-56,
          46},{-14,46},{-14,-90},{60,-90},{60,-140}},
                               color={255,0,255}));
  connect(rel.trigger, triTun) annotation (Line(points={{-56,118},{-56,108},{
          -90,108},{-90,56},{60,56},{60,-140}},
                                        color={255,0,255}));
  connect(resPro.trigger, triTun) annotation (Line(points={{-2,104},{-14,104},{
          -14,-90},{60,-90},{60,-140}},
                               color={255,0,255}));
  connect(nand.y, assMes1.u)
    annotation (Line(points={{102,30},{138,30}}, color={255,0,255}));
  connect(nand.u2, edgReq.y)
    annotation (Line(points={{78,22},{40,22},{40,-40},{34,-40}}, color={255,0,255}));
  connect(edgReq.u, triTun)
    annotation (Line(points={{10,-40},{-14,-40},{-14,-90},{60,-90},{60,-140}},
                                                           color={255,0,255}));
  connect(tunStaDel.y, nand.u1) annotation (Line(points={{32,30},{78,30}}, color={255,0,255}));
  connect(tunStaDel.u, inTunPro.y) annotation (Line(points={{8,30},{-18,30}},
                          color={255,0,255}));
  connect(con1.y, sub.u1) annotation (Line(points={{-138,400},{-108,400},{-108,
          386},{-102,386}}, color={0,0,127}));
  connect(con2.y, sub.u2) annotation (Line(points={{-138,370},{-110,370},{-110,
          374},{-102,374}}, color={0,0,127}));
  connect(sub1.u1, con2.y) annotation (Line(points={{-102,346},{-122,346},{-122,
          370},{-138,370}}, color={0,0,127}));
  connect(sub1.u2, con3.y) annotation (Line(points={{-102,334},{-120,334},{-120,
          340},{-138,340}}, color={0,0,127}));
  connect(sub.y, sub2.u1) annotation (Line(points={{-78,380},{-60,380},{-60,366},
          {-42,366}}, color={0,0,127}));
  connect(sub1.y, sub2.u2)
    annotation (Line(points={{-78,340},{-60,340},{-60,354},{-42,354}}, color={0,0,127}));
  connect(abs1.u, sub2.y)
    annotation (Line(points={{-2,348},{-12,348},{-12,360},{-18,360}}, color={0,0,127}));
  connect(abs1.y, gre.u1)
    annotation (Line(points={{22,348},{52,348},{52,380},{58,380}}, color={0,0,127}));
  connect(gre.y, assMes2.u)
    annotation (Line(points={{82,380},{148,380}},color={255,0,255}));
  connect(con4.y, gre.u2) annotation (Line(points={{22,388},{58,388}},
                 color={0,0,127}));
  connect(rel.y, yRel.u) annotation (Line(points={{-38,136},{-6,136},{-6,220},{
          38,220}}, color={0,0,127}));
  connect(yRel.y, addPar.u)
    annotation (Line(points={{62,220},{78,220}}, color={0,0,127}));
  connect(addPar.y, swi.u1) annotation (Line(points={{102,220},{130,220},{130,
          -12},{138,-12}}, color={0,0,127}));
  connect(rel.u_m, u_m) annotation (Line(points={{-50,118},{-50,-44},{-20,-44},
          {-20,-140}}, color={0,0,127}));
  connect(rel.u_s, u_s) annotation (Line(points={{-62,130},{-158,130},{-158,-20},
          {-200,-20}},color={0,0,127}));
  connect(sam_u_s.u, u_s) annotation (Line(points={{-124,294},{-142,294},{-142,
          254},{-170,254},{-170,-20},{-200,-20}}, color={0,0,127}));
  connect(sam_u_s.y, sub3.u1) annotation (Line(points={{-100,294},{-48,294},{
          -48,280},{-42,280}}, color={0,0,127}));
  connect(sub3.u2, u_s) annotation (Line(points={{-42,268},{-60,268},{-60,254},
          {-170,254},{-170,-20},{-200,-20}},color={0,0,127}));
  connect(sub3.y, abs2.u)
    annotation (Line(points={{-18,274},{-10,274},{-10,294},{-2,294}}, color={0,0,127}));
  connect(nand1.y, assMes3.u)
    annotation (Line(points={{116,300},{148,300}}, color={255,0,255}));
  connect(greThr.y, nand1.u1)
    annotation (Line(points={{62,300},{92,300}}, color={255,0,255}));
  connect(conProMod.tunSta, samk.trigger) annotation (Line(points={{54,156},{54,
          -14},{-110,-14},{-110,-22},{-90,-22},{-90,-28}}, color={255,0,255}));
  connect(samTi.trigger, conProMod.tunSta) annotation (Line(points={{-110,-58},
          {-110,-42},{-130,-42},{-130,-14},{54,-14},{54,156}}, color={255,0,255}));
  connect(samTd.trigger, conProMod.tunSta) annotation (Line(points={{-130,-88},
          {-130,-14},{54,-14},{54,156}}, color={255,0,255}));
  connect(sam_u_s.trigger, triTun) annotation (Line(points={{-112,282},{-112,56},
          {-14,56},{-14,-90},{60,-90},{60,-140}},    color={255,0,255}));
  connect(abs2.y, greThr.u)
    annotation (Line(points={{22,294},{30,294},{30,300},{38,300}}, color={0,0,127}));
  connect(nand1.u2, triTun) annotation (Line(points={{92,292},{80,292},{80,260},
          {-112,260},{-112,56},{60,56},{60,-140}}, color={255,0,255}));
  connect(falEdg.u, nand1.y) annotation (Line(points={{-150,230},{-156,230},{
          -156,316},{124,316},{124,300},{116,300}}, color={255,0,255}));
  connect(falEdg.y, or2.u1)
    annotation (Line(points={{-126,230},{-86,230}}, color={255,0,255}));
  connect(resPro.triEnd, or2.u2) annotation (Line(points={{22,102},{24,102},{24,
          64},{-98,64},{-98,222},{-86,222}},   color={255,0,255}));
  connect(or2.y, inTunPro.clr) annotation (Line(points={{-62,230},{-62,146},{
          -70,146},{-70,24},{-42,24}}, color={255,0,255}));
  connect(conProMod.triEnd, resPro.triEnd)
    annotation (Line(points={{48,152},{48,102},{22,102}}, color={255,0,255}));
annotation (defaultComponentName = "PIDWitTun",
Documentation(info="<html>
<p>
This block implements a rule-based PID tuning method.
</p>
<p>
The PID tuning method approximates the control process with a
first-order time delayed (FOTD) model.
It then determines the gain and delay of this FOTD model based on the responses of
the control process to asymmetric relay feedback.
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
</p>

<h4>Autotuning Process</h4>
<p>
To use this block, place it in a control loop as any other PID controllers.
Before the PID tuning process starts, this block is equivalent to
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithInputGains\">
Buildings.Controls.OBC.Utilities.PIDWithInputGains</a>.
This block starts the PID tuning process when a request for performing autotuning occurs, i.e.,
when the value of the boolean input signal <code>triTun</code> changes from
<code>false</code> to <code>true</code>.
During the autotuning process, the output of the block changes into that of a relay controller
(see <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller</a>).
The PID tuning process ends automatically
(see details in
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.TuningMonitor\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.BaseClasses.Relay.TunMonitor</a>),
at which point this block turns back to a PID controller but with tuned PID parameters.
</p>
<p>
<b>Note:</b> If an autotuning is ongoing, i.e., <code>inTunPro.y = true</code>,
a new request for performing autotuning will be ignored.
In addition, the set point should not be changed during the autotuning process.
</p>
<h4>Guidance for setting the parameters</h4>
<p>
The performance of the autotuning is affected by the parameters, including the
typical range of control error, <code>r</code>, 
the reference output for the tuning process, <code>yRef</code>, the higher and the lower values for
the relay output, <code>yHig</code> and <code>yLow</code>, and the deadband, <code>deaBan</code>.
The following procedure can be used to determine the values of those parameters. 
</p>
<ol>
<li>
Perform a \"test run\" to determine the maximum and the minimum values of measurement.
In this test run, the autotuning is disabled and the set point is constant.
This test run should stop after the system is stable.
Record the maximum and the minimum values of measurement after the system is stable.
</li>
<li>
The <code>r</code> should be adjusted so that the output of the relay controller,
<code>rel.yDif</code>, is within the range from 0 to 1.
</li>
<li>
The <code>yRef</code> can be determined by dividing the set point by the sum of the
minimum and the maximum values of the measurement.
</li>
<li>
The <code>yHig</code> and <code>yLow</code> should be adjusted to realize an asymmetric relay output, 
i.e., <code>yHig - yRef &ne; yRef - yLow</code>.
</li>
<li>
When determining the <code>deaBan</code>, we first divide the maximum and the 
minimum difference of measurement from the setpoint by the typical range of control error <code>r</code>, 
then find the absolute value of the two deviations. 
The <code>deaBan</code> can be set as half of the smaller one between the two absolute deviations.
</li>
</ol>
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
April 3, 2024, by Sen Huang:<br/>
Made <code>yMax</code> and <code>yMin</code> changeable.
</li>
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
Diagram(coordinateSystem(extent={{-180,-120},{180,420}})));
end FirstOrderAMIGO;
