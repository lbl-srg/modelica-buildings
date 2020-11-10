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
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput TMix(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured outside air temperature"
    annotation (Placement(
        transformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput cooSta "Cooling status"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealInput TRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Return air temperature"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput minOAFra(
    final min = 0,
    final max = 1,
    final unit="1")
    "Minimum outside air fraction"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealOutput yOutAirFra(
    final unit="1")
    "Control signal for outside air fraction"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Nonlinear.VariableLimiter Limiter(
    final strict=true)
    "Signal limiter"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant const(
    final k=1)
    "Constant output signal with value 1"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Logical.Switch switch1 "Switch to select control output"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Modelica.Blocks.MathBoolean.And and1(
    final nu=3) "Logical and"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Controls.Continuous.LimPID con(
    final controllerType=controllerTypeEco,
    final k=kEco,
    final Ti=TiEco,
    final Td=TdEco,
    final reverseActing=false,
    final yMax=Modelica.Constants.inf,
    final yMin=-Modelica.Constants.inf)
    "Controller"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Modelica.Blocks.Math.Feedback feedback "Control error"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Math.Feedback feedback1
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysChiPla(
    final uLow=0.95,
    final uHigh=0.98)
    "Hysteresis with delay to switch on cooling"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Modelica.Blocks.Logical.Or or1 "Saturated ecnomizer or no economizer"
    annotation (Placement(transformation(extent={{70,-90},{90,-70}})));
  Modelica.Blocks.Interfaces.BooleanOutput yCoiSta "Cooling coil status"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Logical.Not not1 "No economizer"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  Controls.OBC.CDL.Continuous.Hysteresis hysCooPot(
    final uLow=0,
    final uHigh=0.5)
    "Hysteresis with delay to check for cooling potential of outside air"
    annotation (Placement(transformation(extent={{-54,20},{-34,40}})));
  Controls.OBC.CDL.Logical.TrueFalseHold truFalHolCooPot(
    final trueHoldDuration=60*15)
    "True/false hold for cooling potential"
    annotation (Placement(transformation(extent={{-26,20},{-6,40}})));
  Controls.OBC.CDL.Logical.TrueFalseHold truFalHolTMix(
    final trueHoldDuration=60*15)
    "True/false hold for mixing temperature"
    annotation (Placement(transformation(extent={{-24,-40},{-4,-20}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysTMix(
    final uLow=-0.5,
    final uHigh=0.5)
    "Hysteresis with delay for mixed air temperature"
    annotation (Placement(transformation(extent={{-52,-40},{-32,-20}})));
equation
  connect(Limiter.limit2, minOAFra) annotation (Line(points={{58,-8},{-20,-8},{
          -20,-8},{-94,-8},{-94,-20},{-110,-20},{-110,-20}},
                                color={0,0,127}));
  connect(const.y, Limiter.limit1) annotation (Line(points={{41,70},{50,70},{50,
          8},{58,8}},           color={0,0,127}));
  connect(minOAFra, switch1.u3) annotation (Line(points={{-110,-20},{-94,-20},{
          -94,12},{18,12}},  color={0,0,127}));
  connect(switch1.y, Limiter.u) annotation (Line(points={{41,20},{46,20},{46,0},
          {58,0}},          color={0,0,127}));
  connect(and1.y, switch1.u2) annotation (Line(points={{41.5,-50},{48,-50},{48,
          -6},{10,-6},{10,20},{18,20}},
                                     color={255,0,255}));
  connect(con.u_s, TMixSet)   annotation (Line(points={{-92,80},{-92,80},{-110,80}}, color={0,0,127}));
  connect(TMix, con.u_m)    annotation (Line(points={{-110,50},{-80,50},{-80,68}}, color={0,0,127}));
  connect(con.y, switch1.u1) annotation (Line(points={{-69,80},{12,80},{12,28},
          {18,28}}, color={0,0,127}));
  connect(TOut, feedback.u2) annotation (Line(points={{-110,-50},{-70,-50},{-70,
          -38}}, color={0,0,127}));
  connect(feedback.u1, TMix) annotation (Line(points={{-78,-30},{-90,-30},{-90,50},
          {-110,50}},     color={0,0,127}));
  connect(Limiter.y, yOutAirFra)    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(feedback1.u1, TRet)   annotation (Line(points={{-78,30},{-96,30},{-96,
          20},{-110,20}},                         color={0,0,127}));
  connect(feedback1.u2,TOut)    annotation (Line(points={{-70,22},{-70,16},{-86,
          16},{-86,-50},{-110,-50}},                                                     color={0,0,127}));
  connect(Limiter.y, hysChiPla.u) annotation (Line(points={{81,0},{90,0},{90,
          -20},{52,-20},{52,-50},{58,-50}}, color={0,0,127}));
  connect(or1.y, yCoiSta)    annotation (Line(points={{91,-80},{110,-80}}, color={255,0,255}));
  connect(not1.y, or1.u2) annotation (Line(points={{61,-90},{64,-90},{64,-88},{
          68,-88}}, color={255,0,255}));
  connect(and1.y, not1.u) annotation (Line(points={{41.5,-50},{48,-50},{48,-70},
          {30,-70},{30,-90},{38,-90}}, color={255,0,255}));
  connect(hysChiPla.y, or1.u1) annotation (Line(points={{82,-50},{88,-50},{88,
          -64},{62,-64},{62,-80},{68,-80}}, color={255,0,255}));

  connect(feedback.y, hysTMix.u)
    annotation (Line(points={{-61,-30},{-54,-30}}, color={0,0,127}));
  connect(hysTMix.y, truFalHolTMix.u)
    annotation (Line(points={{-30,-30},{-26,-30}}, color={255,0,255}));
  connect(feedback1.y, hysCooPot.u)
    annotation (Line(points={{-61,30},{-56,30}}, color={0,0,127}));
  connect(hysCooPot.y, truFalHolCooPot.u)
    annotation (Line(points={{-32,30},{-28,30}}, color={255,0,255}));
  connect(truFalHolCooPot.y, and1.u[1]) annotation (Line(points={{-4,30},{8,30},
          {8,-45.3333},{20,-45.3333}}, color={255,0,255}));
  connect(truFalHolTMix.y, and1.u[2]) annotation (Line(points={{-2,-30},{4,-30},
          {4,-50},{20,-50}}, color={255,0,255}));
  connect(cooSta, and1.u[3]) annotation (Line(points={{-110,-80},{-44,-80},{-44,
          -54.6667},{20,-54.6667}}, color={255,0,255}));
   annotation (
  defaultComponentName="conEco",
  Documentation(info="<html>
<p>
Economizer controller.
</p>
</html>", revisions="<html>
<ul>
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
</html>"));
end ControllerEconomizer;
