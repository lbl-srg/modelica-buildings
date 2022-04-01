within Buildings.Controls.OBC.CDL.Continuous;
block PIDWithAutoTuning "P, PI, PD, and PID controller with an auto tuning component"
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Buildings.Controls.OBC.CDL.Types.PIDAutoTuner tuningMethodType=Buildings.Controls.OBC.CDL.Types.PIDAutoTuner.tau "Type of controller";
  parameter Buildings.Controls.OBC.CDL.Types.PIDAutoTuneModel tuningModeType=Buildings.Controls.OBC.CDL.Types.PIDAutoTuneModel.FOTD "Type of tune model"
      annotation (Dialog(enable=tuningMethodType == Buildings.Controls.OBC.CDL.Types.PIDAutoTuner.tau));
  parameter Real k_start(
    min=100*Constants.eps)=1
    "Start value of the Gain of controller"
    annotation (Dialog(group="Control gains"));
  parameter Real Ti_start(
    final quantity="Time",
    final unit="s",
    min=100*Constants.eps)=0.5
    "Start value of the Time constant of integrator block"
    annotation (Dialog(group="Control gains",enable=controllerType == CDL.Types.SimpleController.PI or controllerType == CDL.Types.SimpleController.PID));
  parameter Real Td_start(
    final quantity="Time",
    final unit="s",
    min=100*Constants.eps)=0.1
    "Start value of the Time constant of derivative block"
    annotation (Dialog(group="Control gains",enable=controllerType == CDL.Types.SimpleController.PD or controllerType == CDL.Types.SimpleController.PID));
  parameter Real yHigher = 1 "Higher value of the output";
  parameter Real yLower = -0.5 "Lower value of the output";
  parameter Real deadBand = 0.5 "Deadband for holding the relay output value in the relay tuner";

  Real k(
    min=100*Constants.eps,
    start=k_start)
    "Gain of controller";
  Real Ti(
    min=100*Constants.eps,
    start=Ti_start)
    "Time constant of integrator block";
  Real Td(
    min=100*Constants.eps,
    start=Td_start)
    "Time constant of derivative block";
  parameter Real r(
    min=100*Constants.eps)=1
    "Typical range of control error, used for scaling the control error";
  parameter Real yMax=1
    "Upper limit of output"
    annotation (Dialog(group="Limits"));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(group="Limits"));
  parameter Real Ni(
    min=100*Constants.eps)=0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation (Dialog(tab="Advanced",group="Integrator anti-windup",enable=controllerType == CDL.Types.SimpleController.PI or controllerType == CDL.Types.SimpleController.PID));
  parameter Real Nd(
    min=100*Constants.eps)=10
    "The higher Nd, the more ideal the derivative block"
    annotation (Dialog(tab="Advanced",group="Derivative block",enable=controllerType == CDL.Types.SimpleController.PD or controllerType == CDL.Types.SimpleController.PID));
  parameter Real xi_start=0
    "Initial value of integrator state"
    annotation (Dialog(tab="Advanced",group="Initialization",enable=controllerType == CDL.Types.SimpleController.PI or controllerType == CDL.Types.SimpleController.PID));
  parameter Real yd_start=0
    "Initial value of derivative output"
    annotation (Dialog(tab="Advanced",group="Initialization",enable=controllerType == CDL.Types.SimpleController.PD or controllerType == CDL.Types.SimpleController.PID));
  parameter Boolean reverseActing=true
    "Set to true for reverse acting, or false for direct acting control action";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-220},extent={{20,-20},{-20,20}},rotation=270),iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract controlError "Control error (set point - measurement)"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset I(final k=1,
    final y_start=xi_start) if with_I
    "Integral term"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Derivative D(
    final k=1,
    final T=Td_start/Nd,
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
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract errI2 if with_I
    "I error (after anti-windup compensation)"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter lim(
    final uMax=yMax,
    final uMin=yMin)
    "Limiter"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));

  Modelica.Blocks.Sources.RealExpression P(y=errP.y*k) annotation (Placement(transformation(extent={{-50,130},{-30,150}})));
  Modelica.Blocks.Sources.RealExpression gainD(y=Td*k*errD.y) if
                                                               with_D annotation (Placement(transformation(extent={{-106,60},{-86,80}})));
  Modelica.Blocks.Sources.RealExpression gainI(y=errI2.y*k/Ti) if
                                                               with_I
                                                          annotation (Placement(transformation(extent={{-106,22},{-86,42}})));
  Modelica.Blocks.Sources.RealExpression antWinGai(y=antWinErr.y/(k*Ni)) if
                                                               with_I annotation (Placement(transformation(extent={{178,-34},{158,-14}})));
  Buildings.Controls.OBC.CDL.Discrete.Relay
        relay(
    yHigher=yHigher,
    yLower=yLower,
    deadBand=deadBand)
              annotation (Placement(transformation(extent={{92,154},{112,174}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch switch annotation (Placement(transformation(extent={{138,142},{158,122}})));
  Modelica.Blocks.Sources.BooleanExpression tunePeriodEnd(y=relay.dtON > 0 and relay.dtOFF > 0) annotation (Placement(transformation(extent={{98,122},{118,142}})));

  Buildings.Controls.OBC.CDL.Continuous.AMIGOWithFOTD FOTDTuneModel(
    yHigher=yHigher,
    yLower=yLower,
    deadBand=deadBand,
    controllerType=controllerType) if tuningModeType==Buildings.Controls.OBC.CDL.Types.PIDAutoTuneModel.FOTD
    annotation (Placement(transformation(extent={{120,-100},{100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.NormalizedDelay tauTuner(gamma=max(yHigher, abs(yLower))/min(yHigher, abs(yLower))) if tuningMethodType == Buildings.Controls.OBC.CDL.Types.PIDAutoTuner.tau
    annotation (Placement(transformation(extent={{170,-100},{150,-80}})));
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
    annotation (Evaluate=true,HideResult=true,Placement(transformation(extent={{-20,110},{0,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter uS_revAct(
    final k=revAct/r) "Set point multiplied by reverse action sign"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter uMea_revAct(
    final k=revAct/r) "Set point multiplied by reverse action sign"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addPD
    "Outputs P and D gains added"
    annotation (Placement(transformation(extent={{20,116},{40,136}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addPID
    "Outputs P, I and D gains added"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract antWinErr if with_I
    "Error for anti-windup compensation"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cheYMinMax(
    final k=yMin < yMax)
    "Check for values of yMin and yMax"
    annotation (Placement(transformation(extent={{120,-160},{140,-140}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesYMinMax(
    message="LimPID: Limits must be yMin < yMax")
    "Assertion on yMin and yMax"
    annotation (Placement(transformation(extent={{160,-160},{180,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Izero(
    final k=0) if not with_I
    "Zero input signal"
    annotation (Placement(transformation(extent={{40,74},{60,94}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0) if with_I
    "Constant zero"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false) if with_I
    "Constant false"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  block Derivative
    "Block that approximates the derivative of the input"
    parameter Real k(
      unit="1")=1
      "Gains";
    parameter Real T(
      final quantity="Time",
      final unit="s",
      min=1E-60)=0.01
      "Time constant (T>0 required)";
    parameter Real y_start=0
      "Initial value of output (= state)"
      annotation (Dialog(group="Initialization"));
    Interfaces.RealInput u
      "Connector of Real input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Interfaces.RealOutput y
      "Connector of Real output signal"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));
    output Real x
      "State of block";

  protected
    parameter Boolean zeroGain=abs(k) < 1E-17
      "= true, if gain equals to zero";

  initial equation
    if zeroGain then
      x=u;
    else
      x=u-T*y_start/k;
    end if;

  equation
    der(x)=
      if zeroGain then
        0
      else
        (u-x)/T;
    y=if zeroGain then
        0
      else
        (k/T)*(u-x);
    annotation (
      defaultComponentName="der",
      Documentation(
        info="<html>
<p>
This blocks defines the transfer function between the
input <code>u</code> and the output <code>y</code>
as <i>approximated derivative</i>:
</p>
<pre>
             k * s
     y = ------------ * u
            T * s + 1
</pre>
<p>
If <code>k=0</code>, the block reduces to <code>y=0</code>.
</p>
</html>",
        revisions="<html>
<ul>
<li>
April 30, 2021, by Michael Wetter:<br/>
Refactored implementation to have separate blocks that show the P, I and D contribution,
each with the control gain applied.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2475\">issue 2475</a>.
</li>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
August 7, 2020, by Michael Wetter:<br/>
Moved to protected block in PID controller because the derivative block is no longer part of CDL.
</li>
<li>
April 21, 2020, by Michael Wetter:<br/>
Removed option to not set the initialization method or to set the initial state.
The new implementation only allows to set the initial output, from which
the initial state is computed.
<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1887\">issue 1887</a>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
March 24, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
      Icon(
        coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80.0,78.0},{-80.0,-90.0}},
            color={192,192,192}),
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
          Line(
            points={{-90.0,-80.0},{82.0,-80.0}},
            color={192,192,192}),
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
          Line(
            origin={-24.667,-27.333},
            points={{-55.333,87.333},{-19.333,-40.667},{86.667,-52.667}},
            color={0,0,127},
            smooth=Smooth.Bezier),
          Text(
            extent={{-150.0,-150.0},{150.0,-110.0}},
            textString="k=%k"),
          Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            textColor={0,0,255}),
          Text(
            extent={{226,60},{106,10}},
            textColor={0,0,0},
            textString=DynamicSelect("",String(y,
              leftJustified=false,
              significantDigits=3)))}));
  end Derivative;

equation
  when tunePeriodEnd.y then
    if tuningMethodType == Buildings.Controls.OBC.CDL.Types.PIDAutoTuner.tau and tuningModeType==Buildings.Controls.OBC.CDL.Types.PIDAutoTuneModel.FOTD then
    k=FOTDTuneModel.k;
    Td=FOTDTuneModel.Td;
    Ti=FOTDTuneModel.Ti;
   end if;
  end when;
  connect(u_s,uS_revAct.u)
    annotation (Line(points={{-240,0},{-212,0},{-212,40},{-202,40}},color={0,0,127}));
  connect(u_m,uMea_revAct.u)
    annotation (Line(points={{0,-220},{0,-160},{-190,-160},{-190,-40},{-182,-40}},color={0,0,127}));
  connect(errI1.u1,uS_revAct.y)
    annotation (Line(points={{-142,6},{-170,6},{-170,40},{-178,40}},color={0,0,127}));
  connect(addPID.u1,addPD.y)
    annotation (Line(points={{78,96},{70,96},{70,126},{42,126}},color={0,0,127}));
  connect(addPD.u2,Dzero.y)
    annotation (Line(points={{18,120},{2,120}},                      color={0,0,127}));
  connect(D.y,addPD.u2)
    annotation (Line(points={{-28,70},{10,70},{10,120},{18,120}},  color={0,0,127}));
  connect(addPID.u2,I.y)
    annotation (Line(points={{78,84},{72,84},{72,0},{-28,0}},color={0,0,127}));
  connect(antWinErr.u2,lim.y)
    annotation (Line(points={{158,54},{150,54},{150,90},{142,90}},         color={0,0,127}));
  connect(errI1.y,errI2.u1)
    annotation (Line(points={{-118,0},{-100,0},{-100,6},{-92,6}},
                                              color={0,0,127}));
  connect(cheYMinMax.y,assMesYMinMax.u)
    annotation (Line(points={{142,-150},{158,-150}},color={255,0,255}));
  connect(Izero.y,addPID.u2)
    annotation (Line(points={{62,84},{78,84}},                color={0,0,127}));
  connect(con.y,I.y_reset_in)
    annotation (Line(points={{-78,-40},{-60,-40},{-60,-8},{-52,-8}},color={0,0,127}));
  connect(con1.y,I.trigger)
    annotation (Line(points={{-78,-80},{-40,-80},{-40,-12}},color={255,0,255}));
  connect(uS_revAct.y,errP.u1)
    annotation (Line(points={{-178,40},{-170,40},{-170,146},{-142,146}},color={0,0,127}));
  connect(errD.u1,uS_revAct.y)
    annotation (Line(points={{-142,76},{-170,76},{-170,40},{-178,40}},color={0,0,127}));
  connect(addPID.y, lim.u)
    annotation (Line(points={{102,90},{118,90}},color={0,0,127}));
  connect(addPID.y, antWinErr.u1) annotation (Line(points={{102,90},{110,90},{
          110,66},{158,66}},
                         color={0,0,127}));
  connect(u_s, controlError.u1) annotation (Line(points={{-240,0},{-212,0},{
          -212,6},{-202,6}}, color={0,0,127}));
  connect(u_m, controlError.u2) annotation (Line(points={{0,-220},{0,-160},{
          -212,-160},{-212,-6},{-202,-6}}, color={0,0,127}));
  connect(uMea_revAct.y, errP.u2) annotation (Line(points={{-158,-40},{-150,-40},
          {-150,134},{-142,134}}, color={0,0,127}));
  connect(uMea_revAct.y, errD.u2) annotation (Line(points={{-158,-40},{-150,-40},
          {-150,64},{-142,64}}, color={0,0,127}));
  connect(uMea_revAct.y, errI1.u2) annotation (Line(points={{-158,-40},{-150,
          -40},{-150,-6},{-142,-6}}, color={0,0,127}));
  connect(P.y, addPD.u1) annotation (Line(points={{-29,140},{10,140},{10,132},{18,132}}, color={0,0,127}));
  connect(gainD.y, D.u) annotation (Line(points={{-85,70},{-52,70}}, color={0,0,127}));
  connect(gainI.y, I.u) annotation (Line(points={{-85,32},{-60,32},{-60,0},{-52,0}}, color={0,0,127}));
  connect(antWinGai.y, errI2.u2) annotation (Line(points={{157,-24},{-102,-24},{-102,-6},{-92,-6}}, color={0,0,127}));
  connect(tunePeriodEnd.y,switch. u2) annotation (Line(points={{119,132},{136,132}},
                                                                                 color={255,0,255}));
  connect(relay.u1, errP.u1) annotation (Line(points={{91,168},{0,168},{0,192},{-170,192},{-170,146},{-142,146}}, color={0,0,127}));
  connect(relay.u2, errP.u2) annotation (Line(points={{91,159.6},{-12,159.6},{-12,186},{-150,186},{-150,134},{-142,134}}, color={0,0,127}));
  connect(switch.y, y) annotation (Line(points={{160,132},{200,132},{200,0},{240,0}}, color={0,0,127}));
  connect(relay.y, switch.u3) annotation (Line(points={{113,162},{130,162},{130,140},{136,140}}, color={0,0,127}));
  if tuningMethodType == Buildings.Controls.OBC.CDL.Types.PIDAutoTuner.tau then
  connect(tauTuner.dtON, relay.dtON) annotation (Line(points={{172,-84},{212,-84},{212,166},{113,166}}, color={0,0,127}));
  connect(tauTuner.dtOFF, relay.dtOFF) annotation (Line(points={{172,-96},{208,-96},{208,158},{113,158}}, color={0,0,127}));
  end if;
  if tuningModeType==Buildings.Controls.OBC.CDL.Types.PIDAutoTuneModel.FOTD then
  connect(FOTDTuneModel.RelayOutput, switch.u3)
    annotation (Line(points={{122,-90},{134,-90},{134,56},{60,56},{60,148},{130,148},{130,140},{136,140}}, color={0,0,127}));
  connect(FOTDTuneModel.dtON, relay.dtON)
    annotation (Line(points={{122,-95.8},{134,-95.8},{134,-96},{144,-96},{144,-106},{188,-106},{188,-84},{212,-84},{212,166},{113,166}}, color={0,0,127}));
  connect(FOTDTuneModel.dtOFF, relay.dtOFF)
    annotation (Line(points={{122,-100},{134,-100},{134,-114},{200,-114},{200,-96},{208,-96},{208,158},{113,158}}, color={0,0,127}));
  connect(relay.experimentStart, FOTDTuneModel.experimentStart) annotation (Line(points={{113,170},{194,170},{194,-46},{115.6,-46},{115.6,-78}}, color={255,0,255}));
  connect(relay.experimentEnd, FOTDTuneModel.experimentEnd) annotation (Line(points={{113,174},{204,174},{204,-54},{104.6,-54},{104.6,-78}}, color={255,0,255}));
  connect(relay.uDiff, FOTDTuneModel.ProcessOutput) annotation (Line(points={{113,154},{186,154},{186,-64},{128,-64},{128,-85.2},{122,-85.2}}, color={0,0,127}));
  connect(tauTuner.y, FOTDTuneModel.tau) annotation (Line(points={{148,-90},{138,-90},{138,-80},{122,-80}}, color={0,0,127}));
  end if;
  connect(lim.y, switch.u1) annotation (Line(points={{142,90},{172,90},{172,110},{130,110},{130,124},{136,124}}, color={0,0,127}));
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
<p>PID controller with an autotuning feature.</p>
<p><br>This module is modified based on <a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.PID\">Buildings.Controls.OBC.CDL.Continuous.PID</a>. We added the automatic controller tuning using relay-based model identification.</p>
<p>It allows users to select the tuning methods and the corrsponding model for PID tuning.</p>
<p><br><h4>References</h4></p>
<p>R. Montgomery and R. McDowall (2008). &quot;Fundamentals of HVAC Control Systems.&quot; American Society of Heating Refrigerating and Air-Conditioning Engineers Inc. Atlanta, GA. </p>
</html>",
      revisions="<html>
<ul>
<li>March 30, 2022, by Sen Huang:<br>First implementation. </li>
</ul>
</html>"));
end PIDWithAutoTuning;
