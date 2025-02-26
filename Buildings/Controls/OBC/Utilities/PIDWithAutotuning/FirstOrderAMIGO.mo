within Buildings.Controls.OBC.Utilities.PIDWithAutotuning;
block FirstOrderAMIGO
  "Autotuning PID controller with an AMIGO tuner that employs a first-order system model"

  parameter Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController controllerType=
    Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PI
    "Type of controller";
  parameter Real k_start(
    final min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Gain of controller used before the first tuning"
    annotation (Dialog(group="Initial control gains, used prior to first tuning"));
  parameter Real Ti_start(unit="s")=0.5
    "Time constant of integrator block used before the first tuning"
    annotation (Dialog(group="Initial control gains, used prior to first tuning"));
  parameter Real Td_start(unit="s")=0.1
    "Time constant of derivative block used before the first tuning"
    annotation (Dialog(group="Initial control gains, used prior to first tuning",
      enable=controllerType == Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID));

  parameter Real r(
    final min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Typical range of control error, used for scaling the control error";
  parameter Real yHig(
     final min = 0,
     final max = 1)
    "Higher value for the relay output";
  parameter Real yLow(
     final min = 0,
     final max = 1)
    "Lower value for the relay output";
  parameter Real deaBan(
    final min=1E-6)
    "Deadband for holding the relay output";
  parameter Real yRef
    "Reference output for the tuning process. It must be between yLow and yHig";
  parameter Real yMax = 1
    "Upper limit of output"
    annotation (Dialog(group="Limits"));
  parameter Real yMin = 0
    "Lower limit of output"
    annotation (Dialog(group="Limits"));
  parameter Real Ni(
    final min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation (Dialog(tab="Advanced",group="Integrator anti-windup"));
  parameter Real Nd(
    final min=100*Buildings.Controls.OBC.CDL.Constants.eps)=10
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
    annotation (Placement(transformation(extent={{-320,-20},{-280,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-300}, extent={{20,-20},{-20,20}},rotation=270),
        iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triRes
    "Connector for resetting the controller output"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-300}),
        iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triTun
    "Connector for starting the autotuning"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={100,-300}),
        iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector for actuator output signal"
    annotation (Placement(transformation(extent={{280,-220},{320,-180}}),
      iconTransformation(extent={{100,-20},{140,20}})));

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
    annotation (Placement(transformation(extent={{-50,-230},{-30,-210}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PID PIDPar
    if with_D "Autotuner of gains for a PID controller"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PI PIPar
    if not with_D "Autotuner of gains for a PI controller"
    annotation (Placement(transformation(extent={{160,0},{180,20}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller rel(
    final r=r,
    final yHig=yHig,
    final yLow=yLow,
    final deaBan=deaBan,
    final reverseActing=reverseActing)
    "Relay controller"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess resPro(
    final yHig=yHig - yRef,
    final yLow=yRef - yLow)
    "Identify the on and off period length, the half period ratio, 
    and the moments when the tuning starts and ends"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimeDelay.ControlProcessModel
    conProMod(
    final yHig=yHig - yRef,
    final yLow=yRef - yLow,
    final deaBan=deaBan)
    "Calculates the parameters of a first-order time delayed model"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Logical.Latch inTunPro
    "Outputs true if the controller is conducting the autotuning process"
    annotation (Placement(transformation(extent={{60,-150},{80,-130}})));

protected
  final parameter Boolean with_D=controllerType == Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID
    "Boolean flag to enable derivative action"
    annotation (Evaluate=true,HideResult=true);
  final parameter Buildings.Controls.OBC.CDL.Types.SimpleController conTyp=
    if controllerType==Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PI
      then Buildings.Controls.OBC.CDL.Types.SimpleController.PI
      else Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Type of controller";
  Buildings.Controls.OBC.CDL.Reals.Sources.CivilTime modTim
    "Simulation time"
    annotation (Placement(transformation(extent={{-240,-10},{-220,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between a PID controller and a relay controller"
    annotation (Placement(transformation(extent={{240,-210},{260,-190}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samk(
    final y_start=k_start) "Recording the proportional control gain"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-210}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samTi(
    final y_start=Ti_start)
    "Recording the integral time"
    annotation (Placement(transformation(extent={{-190,-220},{-170,-240}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samTd(
    final y_start=Td_start) if with_D
    "Recording the derivative time"
    annotation (Placement(transformation(extent={{-240,-250},{-220,-270}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes2(
    final message="The relay output needs to be asymmetric. Check the value of yHig, yLow and yRef.")
    "Warning message when the relay output is symmetric"
    annotation (Placement(transformation(extent={{160,210},{180,230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(final k=yHig)
    "Higher value for the relay output"
    annotation (Placement(transformation(extent={{-160,250},{-140,270}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(final k=yRef)
    "Reference value for the relay output"
    annotation (Placement(transformation(extent={{-160,210},{-140,230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(final k=yLow)
    "Lower value for the relay output"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Difference between the higher value and the reference value of the relay output"
    annotation (Placement(transformation(extent={{-80,230},{-60,250}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Difference between the reference value and the lower value of the relay output"
    annotation (Placement(transformation(extent={{-80,190},{-60,210}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Symmetricity level of the relay output"
    annotation (Placement(transformation(extent={{0,210},{20,230}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1
    "Absolute value"
    annotation (Placement(transformation(extent={{40,210},{60,230}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre
    "Check if the relay output is asymmetric"
    annotation (Placement(transformation(extent={{100,210},{120,230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con4(final k=1e-3)
    "Threshold for checking if the input is larger than 0"
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter yRel(
    final k=yMax - yMin)
    "Relay output multiplied by the possible range of the output"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Logical.Nand nand
    "Check if an autotuning is ongoing while a new autotuning request is received"
    annotation (Placement(transformation(extent={{200,-150},{220,-130}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="A new tuning request is ignored as the autotuning is ongoing.")
    "Warning message when an autotuning tuning is ongoing while a new autotuning request is received"
    annotation (Placement(transformation(extent={{240,-150},{260,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgReq
    "True only when a new request is received"
    annotation (Placement(transformation(extent={{120,-250},{140,-230}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tunStaDel(
    final delayTime=0.001)
    "A small time delay for the autotuning start time to avoid false alerts"
    annotation (Placement(transformation(extent={{140,-150},{160,-130}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=yMin)
    "Sums the inputs"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler sam_u_s(final y_start=0)
    "Recording the setpoint. Not that y_start does not influence the tuning."
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Logical.Nand nand1
    "Check if an autotuning is ongoing while the setpoint changes"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub3
    "Change of the setpoint"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs2
    "Absolute value of the setpoint change"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=setHys,
    final h=0.5*setHys)
    "Check if the setpoint changes"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes3(
    final message="The setpoint must not change when an autotuning tuning is ongoing. 
    This ongoing autotuning will be aborted and the control gains will not be changed.")
    "Warning message when the setpoint changes during tuning process"
    annotation (Placement(transformation(extent={{160,100},{180,120}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Check if the setpoint changes during an autotuning process"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if the autotuning is completed or aborted"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if an autotuning is completed with no error"
    annotation (Placement(transformation(extent={{-200,-150},{-180,-130}})));
equation
  connect(con.u_s, u_s) annotation (Line(points={{-52,-220},{-88,-220},{-88,-30},
          {-260,-30},{-260,0},{-300,0}},
                        color={0,0,127}));
  connect(con.trigger, triRes) annotation (Line(points={{-46,-232},{-46,-260},{-60,
          -260},{-60,-300}}, color={255,0,255}));
  connect(samk.y,con. k) annotation (Line(points={{-118,-200},{-100,-200},{-100,
          -212},{-52,-212}}, color={0,0,127}));
  connect(con.Ti, samTi.y) annotation (Line(points={{-52,-216},{-100,-216},{-100,
          -230},{-168,-230}}, color={0,0,127}));
  connect(samTd.y,con. Td) annotation (Line(points={{-218,-260},{-80,-260},{-80,
          -224},{-52,-224}}, color={0,0,127}));
  connect(resPro.on, rel.yOn) annotation (Line(points={{-22,-50},{-40,-50},{-40,
          -36},{-58,-36}}, color={255,0,255}));
  connect(modTim.y, resPro.tim) annotation (Line(points={{-218,0},{-30,0},{-30,-44},
          {-22,-44}}, color={0,0,127}));
  connect(resPro.tau, conProMod.tau) annotation (Line(points={{2,-50},{30,-50},{
          30,2},{58,2}}, color={0,0,127}));
  connect(conProMod.tOff, resPro.tOff) annotation (Line(points={{58,6},{20,6},{20,
          -46},{2,-46}}, color={0,0,127}));
  connect(resPro.tOn, conProMod.tOn) annotation (Line(points={{2,-42},{10,-42},{
          10,14},{58,14}}, color={0,0,127}));
  connect(rel.yDif, conProMod.u) annotation (Line(points={{-58,-30},{-20,-30},{-20,
          18},{58,18}}, color={0,0,127}));
  connect(PIDPar.kp, conProMod.k) annotation (Line(points={{158,-34},{120,-34},{
          120,18},{82,18}}, color={0,0,127}));
  connect(PIDPar.T, conProMod.T) annotation (Line(points={{158,-40},{110,-40},{110,
          14},{82,14}}, color={0,0,127}));
  connect(PIDPar.L, conProMod.L) annotation (Line(points={{158,-46},{100,-46},{100,
          6},{82,6}}, color={0,0,127}));
  connect(PIDPar.Ti, samTi.u) annotation (Line(points={{182,-40},{240,-40},{240,
          -110},{-210,-110},{-210,-230},{-192,-230}}, color={0,0,127}));
  connect(PIPar.kp, conProMod.k) annotation (Line(points={{158,16},{120,16},{120,
          18},{82,18}}, color={0,0,127}));
  connect(PIPar.T, conProMod.T) annotation (Line(points={{158,10},{110,10},{110,
          14},{82,14}}, color={0,0,127}));
  connect(PIPar.L, conProMod.L) annotation (Line(points={{158,4},{100,4},{100,6},
          {82,6}}, color={0,0,127}));
  connect(PIPar.k, samk.u) annotation (Line(points={{182,16},{230,16},{230,-80},
          {-160,-80},{-160,-200},{-142,-200}}, color={0,0,127}));
  connect(PIPar.Ti, samTi.u) annotation (Line(points={{182,4},{240,4},{240,-110},
          {-210,-110},{-210,-230},{-192,-230}}, color={0,0,127}));
  connect(resPro.triSta, conProMod.triSta) annotation (Line(points={{2,-54},{64,
          -54},{64,-2}}, color={255,0,255}));
  connect(swi.y, y) annotation (Line(points={{262,-200},{300,-200}}, color={0,0,127}));
  connect(u_m,con. u_m) annotation (Line(points={{0,-300},{0,-240},{-40,-240},{-40,
          -232}},color={0,0,127}));
  connect(swi.u3,con. y) annotation (Line(points={{238,-208},{80,-208},{80,-220},
          {-28,-220}}, color={0,0,127}));
  connect(inTunPro.y, swi.u2) annotation (Line(points={{82,-140},{120,-140},{120,
          -200},{238,-200}}, color={255,0,255}));
  connect(inTunPro.u, triTun) annotation (Line(points={{58,-140},{40,-140},{40,-240},
          {100,-240},{100,-300}},
          color={255,0,255}));
  connect(rel.trigger, triTun) annotation (Line(points={{-78,-42},{-78,-170},{40,
          -170},{40,-240},{100,-240},{100,-300}},
                            color={255,0,255}));
  connect(resPro.trigger, triTun) annotation (Line(points={{-22,-56},{-40,-56},{
          -40,-170},{40,-170},{40,-240},{100,-240},{100,-300}},
                                          color={255,0,255}));
  connect(nand.y, assMes1.u)
    annotation (Line(points={{222,-140},{238,-140}}, color={255,0,255}));
  connect(nand.u2, edgReq.y)
    annotation (Line(points={{198,-148},{180,-148},{180,-240},{142,-240}},
          color={255,0,255}));
  connect(edgReq.u, triTun)
    annotation (Line(points={{118,-240},{100,-240},{100,-300}},
                                                              color={255,0,255}));
  connect(tunStaDel.y, nand.u1) annotation (Line(points={{162,-140},{198,-140}},
          color={255,0,255}));
  connect(tunStaDel.u, inTunPro.y) annotation (Line(points={{138,-140},{82,-140}},
          color={255,0,255}));
  connect(con1.y, sub.u1) annotation (Line(points={{-138,260},{-120,260},{-120,246},
          {-82,246}}, color={0,0,127}));
  connect(con2.y, sub.u2) annotation (Line(points={{-138,220},{-100,220},{-100,234},
          {-82,234}}, color={0,0,127}));
  connect(sub1.u1, con2.y) annotation (Line(points={{-82,206},{-100,206},{-100,220},
          {-138,220}}, color={0,0,127}));
  connect(sub1.u2, con3.y) annotation (Line(points={{-82,194},{-120,194},{-120,180},
          {-138,180}}, color={0,0,127}));
  connect(sub.y, sub2.u1) annotation (Line(points={{-58,240},{-40,240},{-40,226},
          {-2,226}}, color={0,0,127}));
  connect(sub1.y, sub2.u2)
    annotation (Line(points={{-58,200},{-40,200},{-40,214},{-2,214}}, color={0,0,127}));
  connect(abs1.u, sub2.y)
    annotation (Line(points={{38,220},{22,220}}, color={0,0,127}));
  connect(abs1.y, gre.u1)
    annotation (Line(points={{62,220},{98,220}}, color={0,0,127}));
  connect(gre.y, assMes2.u)
    annotation (Line(points={{122,220},{158,220}}, color={255,0,255}));
  connect(con4.y, gre.u2) annotation (Line(points={{62,180},{80,180},{80,212},{98,
          212}}, color={0,0,127}));
  connect(rel.y, yRel.u) annotation (Line(points={{-58,-24},{-40,-24},{-40,60},{
          -2,60}}, color={0,0,127}));
  connect(yRel.y, addPar.u)
    annotation (Line(points={{22,60},{78,60}}, color={0,0,127}));
  connect(addPar.y, swi.u1) annotation (Line(points={{102,60},{130,60},{130,-192},
          {238,-192}},color={0,0,127}));
  connect(rel.u_m, u_m) annotation (Line(points={{-70,-42},{-70,-160},{0,-160},{
          0,-300}}, color={0,0,127}));
  connect(rel.u_s, u_s) annotation (Line(points={{-82,-30},{-260,-30},{-260,0},{
          -300,0}},     color={0,0,127}));
  connect(sam_u_s.u, u_s) annotation (Line(points={{-142,130},{-260,130},{-260,0},
          {-300,0}},    color={0,0,127}));
  connect(sam_u_s.y, sub3.u1) annotation (Line(points={{-118,130},{-100,130},{-100,
          116},{-82,116}}, color={0,0,127}));
  connect(sub3.u2, u_s) annotation (Line(points={{-82,104},{-260,104},{-260,0},{
          -300,0}},     color={0,0,127}));
  connect(sub3.y, abs2.u)
    annotation (Line(points={{-58,110},{-42,110}}, color={0,0,127}));
  connect(nand1.y, assMes3.u)
    annotation (Line(points={{102,110},{158,110}}, color={255,0,255}));
  connect(greThr.y, nand1.u1)
    annotation (Line(points={{22,110},{78,110}}, color={255,0,255}));
  connect(sam_u_s.trigger, triTun) annotation (Line(points={{-130,118},{-130,-140},
          {40,-140},{40,-240},{100,-240},{100,-300}},
                                color={255,0,255}));
  connect(abs2.y, greThr.u)
    annotation (Line(points={{-18,110},{-2,110}}, color={0,0,127}));
  connect(nand1.u2, triTun) annotation (Line(points={{78,102},{40,102},{40,-240},
          {100,-240},{100,-300}},
          color={255,0,255}));
  connect(falEdg.u, nand1.y) annotation (Line(points={{-222,50},{-240,50},{-240,
          80},{120,80},{120,110},{102,110}}, color={255,0,255}));
  connect(falEdg.y, or2.u1)
    annotation (Line(points={{-198,50},{-182,50}},  color={255,0,255}));
  connect(resPro.triEnd, or2.u2) annotation (Line(points={{2,-58},{76,-58},{76,-90},
          {-190,-90},{-190,42},{-182,42}},  color={255,0,255}));
  connect(or2.y, inTunPro.clr) annotation (Line(points={{-158,50},{-140,50},{-140,
          -146},{58,-146}}, color={255,0,255}));
  connect(conProMod.triEnd, resPro.triEnd)
    annotation (Line(points={{76,-2},{76,-58},{2,-58}},  color={255,0,255}));
  connect(PIDPar.k, samk.u) annotation (Line(points={{182,-33},{230,-33},{230,-80},
          {-160,-80},{-160,-200},{-142,-200}}, color={0,0,127}));
  connect(PIDPar.Td, samTd.u) annotation (Line(points={{182,-47},{220,-47},{220,
          -70},{-250,-70},{-250,-260},{-242,-260}}, color={0,0,127}));
  connect(conProMod.tunSta, and2.u2) annotation (Line(points={{82,2},{102,2},{
          102,-180},{-216,-180},{-216,-148},{-202,-148}},             color={255,
          0,255}));
  connect(and2.y, samk.trigger) annotation (Line(points={{-178,-140},{-148,-140},
          {-148,-170},{-130,-170},{-130,-188}}, color={255,0,255}));
  connect(samTi.trigger, and2.y) annotation (Line(points={{-180,-218},{-180,-160},
          {-168,-160},{-168,-140},{-178,-140}}, color={255,0,255}));
  connect(samTd.trigger, and2.y) annotation (Line(points={{-230,-248},{-230,-196},
          {-186,-196},{-186,-156},{-172,-156},{-172,-140},{-178,-140}}, color={255,
          0,255}));
  connect(and2.u1, nand1.y) annotation (Line(points={{-202,-140},{-248,-140},{-248,
          88},{112,88},{112,110},{102,110}}, color={255,0,255}));
  connect(resPro.inTun, inTunPro.y) annotation (Line(points={{-10,-62},{-10,
          -120},{96,-120},{96,-140},{82,-140}}, color={255,0,255}));
  connect(conProMod.inTun, inTunPro.y) annotation (Line(points={{70,-2},{70,
          -100},{90,-100},{90,-140},{82,-140}}, color={255,0,255}));
annotation (defaultComponentName = "conPIDWitTun",
Documentation(info="<html>
<p>
This block implements a rule-based tuning method for a PI or a PID controller, with the following
steps:
</p>
<p>
Step 1: Introducing a periodic disturbance
</p>
<ul>
<li>
During the tuning process, the relay controller
switches the output between two constants (<code>yHig</code> and <code>yLow</code>), based
on the control error <i>e(t) = u<sub>s</sub>(t) - u<sub>m</sub>(t)</i>.
Details can be found in
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller</a>.
</li>
</ul>
<p>
Step 2: Extracting parameters of a first-order plus time-delay (FOPTD) model
</p>
<ul>
<li>
Based on the inputs and outputs from the relay controller during the tuning process, the
parameters of the FOPTD model is calculated (see 
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification</a>).
The FOPTD is a simplified representation of the control process.
</li>
</ul>
<p>
Step 3: Calculating the PID gains
</p>
<ul>
<li>
The PID gains are calculated with the Approximate M-constrained Integral Gain Optimization (AMIGO) method
based on the FOPTD model parameters (see 
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO</a>).
</li>
</ul>
<p>
This block is implemented using
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithInputGains\">
Buildings.Controls.OBC.Utilities.PIDWithInputGains</a>
and inherits most of its configuration. However, through the parameter
<code>controllerType</code>, the controller can only be configured as PI or
PID controller.
</p>
<h4>Autotuning process</h4>
<p>
Before the tuning process starts, this block has output from
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithInputGains\">
Buildings.Controls.OBC.Utilities.PIDWithInputGains</a>.
The PID tuning process starts when a request for performing autotuning occurs,
i.e., when the value of the boolean input signal <code>triTun</code> changes from
<code>false</code> to <code>true</code>.
During the tuning process, the block has the output from a relay controller
(see <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller</a>).
The PID tuning process ends automatically
(see details in
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.TuningMonitor\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.BaseClasses.Relay.TunMonitor</a>),
at which point this block reverts the output from the PID controller that uses the
tuned PID parameters.
</p>
<p>Note:</p>
<ul>
<li>
If an autotuning is ongoing, i.e., <code>inTunPro.y = true</code>,
a new request for performing autotuning will be ignored and a warning
will be generated.
</li>
<li>
If the set point is changed during an autotuning process, a warning will be
generated. The ongoing tuning process will be halted, and no adjustments will be made
to the PID parameters.
</li>
</ul>
<h4>Guidance for setting the parameters</h4>
<p>
The performance of the autotuning is affected by the parameters including the
typical range of the control error <code>r</code>,
the reference output for the tuning process <code>yRef</code>, the higher and
lower values for the relay output <code>yHig</code> and <code>yLow</code>, and the
deadband <code>deaBan</code>.
These parameters can be specified as follows.
</p>
<p>
Step 1: conducting a &quot;test run&quot;
</p>
<ul>
<li>
In the test run, the autotuning must be disabled and the set point
must be constant.
</li>
<li>
During the test run, <code>r</code> must be adjusted so that the 
output of the relay controller <code>rel.yDif</code>,
stays between 0 and 1.
</li>
<li>
This test run must stop after the system is stable.
</li>
<li>
Once stable, note the highest and lowest values of the measurement.
</li>
</ul>
<p>
Step 2: calculating <code>yRef</code> and <code>deaBan</code>
</p>
<ul>
<li>
The <code>yRef</code> is calculated by dividing the set point by the sum of the
minimum and the maximum values of the measurement.
</li>
<li>
To calculate <code>deaBan</code>, first divide the maximum and the
minimum control errors during the test run by <code>r</code>.
The <code>deaBan</code> can then be set as half of the smaller absolute value
of those two deviations.
</li>
</ul>
<p>
Step 3: determining <code>yHig</code> and <code>yLow</code>
</p>
<ul>
<li>
The <code>yHig</code> and <code>yLow</code> should be adjusted so that the relay
output is asymmetric, i.e., <code>yHig - yRef &ne; yRef - yLow</code>.
</li>
</ul>
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
February 10, 2025, by Michael Wetter:<br/>
Removed parameter <code>u_s_start</code> as it does not influence the auto-tuning.
</li>
<li>
March 8, 2024, by Michael Wetter:<br/>
Propagated range of control error <code>r</code> to relay controller.
</li>
<li>
October 23, 2023, by Michael Wetter:<br/>
Revised implmenentation. Made initial control gains public so that a stable
operation can be made prior to the first tuning.
</li>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation.<br/>
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
          extent={{-56,96},{36,66}},
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
            leftJustified=true,
            significantDigits=3),
            "k = " + String(con.k,
            leftJustified=true,
            significantDigits=3))),
        Text(
          extent={{24,8},{-74,-28}},
          textColor={0,0,0},
          textString=DynamicSelect(
            "Ti = " + String(Ti_start,
            leftJustified=true,
            significantDigits=3),
            "Ti = " + String(con.Ti,
            leftJustified=true,
            significantDigits=3))),
        Text(
          visible = controllerType == Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID,
          extent={{24,-34},{-74,-70}},
          textColor={0,0,0},
          textString=DynamicSelect(
            "Td = " + String(Td_start,
            leftJustified=true,
            significantDigits=3),
            "Td = " + String(con.Td,
            leftJustified=true,
            significantDigits=3)))}),
Diagram(coordinateSystem(extent={{-280,-280},{280,280}})));
end FirstOrderAMIGO;
