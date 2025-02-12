within Buildings.Air.Systems.SingleZone.VAV.BaseClasses;
model ControllerEconomizer "Controller for economizer"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeEco=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Economizer control signal"));
  parameter Real kEco(final unit="1/K")=0.1
    "Gain for economizer control signal"
    annotation(Dialog(group="Economizer control signal"));
  parameter Real TiEco(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for economizer control signal"
    annotation(Dialog(group="Economizer control signal",
    enable=controllerTypeEco == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeEco == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdEco(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for economizer control signal"
    annotation (Dialog(group="Economizer control signal",
      enable=controllerTypeEco == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeEco == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Modelica.Blocks.Interfaces.RealInput TMixSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Mixed air setpoint temperature"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput TMix(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured outside air temperature"
    annotation (Placement(
        transformation(extent={{-160,-60},{-140,-40}}), iconTransformation(
          extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput cooSta "Cooling status"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealInput TRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Return air temperature"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}}),
        iconTransformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput minOAFra(
    final min = 0,
    final max = 1,
    final unit="1")
    "Minimum outside air fraction"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealOutput yOutAirFra(
    final unit="1")
    "Control signal for outside air fraction"
    annotation (Placement(transformation(extent={{140,-10},{160,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Nonlinear.VariableLimiter Limiter(
    final strict=true)
    "Signal limiter"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Sources.Constant const(
    final k=1)
    "Constant output signal with value 1"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Logical.Switch switch1 "Switch to select control output"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Modelica.Blocks.MathBoolean.And and1(
    final nu=3) "Logical and"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  Controls.Continuous.LimPID con(
    final controllerType=controllerTypeEco,
    final k=kEco,
    final Ti=TiEco,
    final Td=TdEco,
    final reverseActing=false,
    final yMax=1,
    final yMin=0)
    "Controller"
    annotation (Placement(transformation(extent={{-130,70},{-110,90}})));
  Modelica.Blocks.Math.Feedback feedback "Control error"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Modelica.Blocks.Math.Feedback feedback1
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Controls.OBC.CDL.Reals.Hysteresis hysChiPla(
    final uLow=0.95,
    final uHigh=0.98)
    "Hysteresis with delay to switch on cooling"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Logical.Or or1 "Saturated ecnomizer or no economizer"
    annotation (Placement(transformation(extent={{110,-90},{130,-70}})));
  Modelica.Blocks.Interfaces.BooleanOutput yCoiSta "Cooling coil status"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}}),
        iconTransformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Logical.Not not1 "No economizer"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));

  Controls.OBC.CDL.Reals.Hysteresis hysCooPot(
    final uLow=0,
    final uHigh=0.5)
    "Hysteresis with delay to check for cooling potential of outside air"
    annotation (Placement(transformation(extent={{-94,20},{-74,40}})));
  Controls.OBC.CDL.Logical.TrueFalseHold truFalHolCooPot(
    final trueHoldDuration=60*15)
    "True/false hold for cooling potential"
    annotation (Placement(transformation(extent={{-66,20},{-46,40}})));
  Controls.OBC.CDL.Logical.TrueFalseHold truFalHolTMix(
    final trueHoldDuration=60*15)
    "True/false hold for mixing temperature"
    annotation (Placement(transformation(extent={{-64,-40},{-44,-20}})));
  Controls.OBC.CDL.Reals.Hysteresis hysTMix(
    final uLow=-0.5,
    final uHigh=0.5)
    "Hysteresis with delay for mixed air temperature"
    annotation (Placement(transformation(extent={{-92,-40},{-72,-20}})));
protected
  Controls.OBC.CDL.Logical.Pre pre1
    "Use left-limit of signal to break algebraic loop"
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
equation
  connect(Limiter.limit2, minOAFra) annotation (Line(points={{98,-8},{-94,-8},{
          -94,-20},{-150,-20}}, color={0,0,127}));
  connect(const.y, Limiter.limit1) annotation (Line(points={{81,70},{90,70},{90,
          8},{98,8}},           color={0,0,127}));
  connect(minOAFra, switch1.u3) annotation (Line(points={{-150,-20},{-134,-20},
          {-134,12},{58,12}},color={0,0,127}));
  connect(switch1.y, Limiter.u) annotation (Line(points={{81,20},{86,20},{86,0},
          {98,0}},          color={0,0,127}));
  connect(con.u_s, TMixSet)   annotation (Line(points={{-132,80},{-150,80}},         color={0,0,127}));
  connect(TMix, con.u_m)    annotation (Line(points={{-150,50},{-120,50},{-120,
          68}},                                                                    color={0,0,127}));
  connect(con.y, switch1.u1) annotation (Line(points={{-109,80},{20,80},{20,28},
          {58,28}}, color={0,0,127}));
  connect(TOut, feedback.u2) annotation (Line(points={{-150,-50},{-110,-50},{
          -110,-38}},
                 color={0,0,127}));
  connect(feedback.u1, TMix) annotation (Line(points={{-118,-30},{-130,-30},{
          -130,50},{-150,50}},
                          color={0,0,127}));
  connect(Limiter.y, yOutAirFra)    annotation (Line(points={{121,0},{150,0}},color={0,0,127}));
  connect(feedback1.u1, TRet)   annotation (Line(points={{-118,30},{-136,30},{
          -136,20},{-150,20}},                    color={0,0,127}));
  connect(feedback1.u2,TOut)    annotation (Line(points={{-110,22},{-110,16},{
          -126,16},{-126,-50},{-150,-50}},                                               color={0,0,127}));
  connect(Limiter.y, hysChiPla.u) annotation (Line(points={{121,0},{130,0},{130,
          -20},{92,-20},{92,-50},{98,-50}}, color={0,0,127}));
  connect(or1.y, yCoiSta)    annotation (Line(points={{131,-80},{150,-80}},color={255,0,255}));
  connect(not1.y, or1.u2) annotation (Line(points={{81,-80},{90,-80},{90,-88},{
          108,-88}},color={255,0,255}));
  connect(hysChiPla.y, or1.u1) annotation (Line(points={{122,-50},{126,-50},{
          126,-64},{100,-64},{100,-80},{108,-80}},
                                            color={255,0,255}));

  connect(feedback.y, hysTMix.u)
    annotation (Line(points={{-101,-30},{-94,-30}},color={0,0,127}));
  connect(hysTMix.y, truFalHolTMix.u)
    annotation (Line(points={{-70,-30},{-66,-30}}, color={255,0,255}));
  connect(feedback1.y, hysCooPot.u)
    annotation (Line(points={{-101,30},{-96,30}},color={0,0,127}));
  connect(hysCooPot.y, truFalHolCooPot.u)
    annotation (Line(points={{-72,30},{-68,30}}, color={255,0,255}));
  connect(truFalHolCooPot.y, and1.u[1]) annotation (Line(points={{-44,30},{-40,
          30},{-40,-32.3333},{-30,-32.3333}},
                                       color={255,0,255}));
  connect(truFalHolTMix.y, and1.u[2]) annotation (Line(points={{-42,-30},{-30,
          -30}},             color={255,0,255}));
  connect(cooSta, and1.u[3]) annotation (Line(points={{-150,-80},{-38,-80},{-38,
          -27.6667},{-30,-27.6667}},color={255,0,255}));
  connect(and1.y, pre1.u)
    annotation (Line(points={{-8.5,-30},{8,-30}}, color={255,0,255}));
  connect(pre1.y, switch1.u2) annotation (Line(points={{32,-30},{40,-30},{40,20},
          {58,20}}, color={255,0,255}));
  connect(pre1.y, not1.u) annotation (Line(points={{32,-30},{40,-30},{40,-80},{
          58,-80}}, color={255,0,255}));
   annotation (
  defaultComponentName="conEco",
  Documentation(info="<html>
<p>
Economizer controller.
</p>
</html>", revisions="<html>
<ul>
<li>
June 26, 2024, by Antoine Gautier:<br/>
Added a <code>pre</code> block to break the algebraic loop involving the mixed air temperature.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3915\">#3915</a>.
</li>
<li>
September 30, 2020, by Michael Wetter:<br/>
Refactored implementation of hysteresis with hold, which was using a block that is now obsolete.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2134\">issue 2134</a>.
</li>
<li>
July 21, 2020, by Kun Zhang:<br/>
Exposed PID control parameters to allow users to tune for their specific systems.
</li>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})));
end ControllerEconomizer;
