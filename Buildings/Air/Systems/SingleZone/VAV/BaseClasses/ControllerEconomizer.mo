within Buildings.Air.Systems.SingleZone.VAV.BaseClasses;
model ControllerEconomizer "Controller for economizer"
  extends Modelica.Blocks.Icons.Block;

  parameter Real kPEco(min=Modelica.Constants.small) = 1
    "Proportional gain of controller"
    annotation(Dialog(group="Control gain"));

  Modelica.Blocks.Interfaces.RealInput T_mixSet
    "Mixed air setpoint temperature"            annotation (Placement(
        transformation(rotation=0, extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput T_mix "Measured mixed air temperature"
                                             annotation (Placement(
        transformation(rotation=0, extent={{-120,40},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput yOutAirFra
    "Control signal for outside air fraction"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput minOAFra "Minimum outside air fraction"
                                                annotation (Placement(
        transformation(rotation=0, extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Nonlinear.VariableLimiter Limiter(strict=true)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Blocks.Interfaces.RealInput T_oa "Measured outside air temperature"
                                            annotation (Placement(
        transformation(rotation=0, extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Modelica.Blocks.Interfaces.RealInput yHea(unit="1")
    "Control signal for heating coil" annotation (Placement(transformation(
          rotation=0, extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.MathBoolean.And
                              and1(nu=3)
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Controls.Continuous.LimPID con(
    final k=kPEco,
    reverseAction=true,
    yMax=Modelica.Constants.inf,
    yMin=-Modelica.Constants.inf,
    controllerType=Modelica.Blocks.Types.SimpleController.P)
                                  "Controller"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  HysteresisWithDelay hysYHea "Hysteresis with delay for heating signal"
    annotation (Placement(transformation(rotation=0, extent={{-80,-90},{-60,-70}})));
  HysteresisWithDelay hysTMix(uLow=-0.5, uHigh=0.5)
    "Hysteresis with delay for mixed air temperature"
    annotation (Placement(transformation(rotation=0, extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Modelica.Blocks.Interfaces.RealInput TRet "Return air temperature"
    annotation (Placement(transformation(rotation=0, extent={{-120,18},{-100,38}})));
  Modelica.Blocks.Math.Feedback feedback1
    annotation (Placement(transformation(extent={{-78,18},{-58,38}})));
  HysteresisWithDelay hysCooPot(uHigh=0.5, uLow=0)
    "Hysteresis with delay to check for cooling potential of outside air"
    annotation (Placement(transformation(rotation=0, extent={{-50,18},{-30,38}})));
equation
  connect(Limiter.limit2, minOAFra) annotation (Line(points={{58,-8},{26,-8},{
          26,0},{-110,0}},      color={0,0,127}));
  connect(const.y, Limiter.limit1) annotation (Line(points={{41,80},{50,80},{50,
          8},{58,8}},           color={0,0,127}));
  connect(minOAFra, switch1.u3) annotation (Line(points={{-110,0},{-12,0},{-12,
          12},{18,12}},      color={0,0,127}));
  connect(switch1.y, Limiter.u) annotation (Line(points={{41,20},{46,20},{46,0},
          {58,0}},          color={0,0,127}));
  connect(and1.y, switch1.u2) annotation (Line(points={{1.5,-20},{8,-20},{8,-4},
          {-24,-4},{-24,20},{18,20}},color={255,0,255}));
  connect(con.u_s, T_mixSet) annotation (Line(points={{-82,80},{-92,80},{-92,80},
          {-110,80}}, color={0,0,127}));
  connect(T_mix, con.u_m)
    annotation (Line(points={{-110,50},{-70,50},{-70,68}}, color={0,0,127}));
  connect(con.y, switch1.u1) annotation (Line(points={{-59,80},{12,80},{12,28},
          {18,28}}, color={0,0,127}));
  connect(T_oa, feedback.u2) annotation (Line(points={{-110,-40},{-80,-40},{-80,
          -28}}, color={0,0,127}));
  connect(feedback.u1, T_mix) annotation (Line(points={{-88,-20},{-96,-20},{-96,
          50},{-110,50}}, color={0,0,127}));
  connect(Limiter.y, yOutAirFra)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(hysYHea.u, yHea)
    annotation (Line(points={{-81,-80},{-110,-80}}, color={0,0,127}));
  connect(feedback.y, hysTMix.u)
    annotation (Line(points={{-71,-20},{-61,-20}}, color={0,0,127}));
  connect(hysYHea.on, not1.u)
    annotation (Line(points={{-59,-80},{-52,-80}}, color={255,0,255}));
  connect(feedback1.u1, TRet)
    annotation (Line(points={{-76,28},{-110,28}}, color={0,0,127}));
  connect(feedback1.u2, T_oa)
    annotation (Line(points={{-68,20},{-68,-40},{-110,-40}}, color={0,0,127}));
  connect(feedback1.y, hysCooPot.u)
    annotation (Line(points={{-59,28},{-51,28}}, color={0,0,127}));
  connect(hysCooPot.on, and1.u[1]) annotation (Line(points={{-29,28},{-26,28},{
          -26,-15.3333},{-20,-15.3333}}, color={255,0,255}));
  connect(hysTMix.on, and1.u[2]) annotation (Line(points={{-39,-20},{-30,-20},{
          -30,-20},{-20,-20}}, color={255,0,255}));
  connect(not1.y, and1.u[3]) annotation (Line(points={{-29,-80},{-26,-80},{-26,
          -24.6667},{-20,-24.6667}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ControllerEconomizer;
