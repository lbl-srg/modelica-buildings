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
        transformation(rotation=0, extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.RealOutput yOutAirFra
    "Control signal for outside air fraction"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput minOAFra "Minimum outside air fraction"
                                                annotation (Placement(
        transformation(rotation=0, extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Nonlinear.VariableLimiter Limiter(strict=true)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Interfaces.RealInput T_oa "Measured outside air temperature"
                                            annotation (Placement(
        transformation(rotation=0, extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-2,10},{18,30}})));
  Modelica.Blocks.Interfaces.RealInput yHea(unit="1")
    "Control signal for heating coil" annotation (Placement(transformation(
          rotation=0, extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-22,-30},{-2,-10}})));
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
    annotation (Placement(transformation(rotation=0, extent={{-60,-90},{-40,-70}})));
  HysteresisWithDelay hysTMix "Hysteresis with delay for mixed air temperature"
    annotation (Placement(transformation(rotation=0, extent={{-60,-30},{-40,-10}})));
equation
  connect(Limiter.limit2, minOAFra) annotation (Line(points={{38,-8},{26,-8},{
          26,0},{-110,0}},      color={0,0,127}));
  connect(const.y, Limiter.limit1) annotation (Line(points={{-19,50},{28,50},{
          28,8},{38,8}},        color={0,0,127}));
  connect(minOAFra, switch1.u3) annotation (Line(points={{-110,0},{-12,0},
          {-12,12},{-4,12}}, color={0,0,127}));
  connect(switch1.y, Limiter.u) annotation (Line(points={{19,20},{32,20},{32,0},
          {38,0}},          color={0,0,127}));
  connect(and1.y, switch1.u2) annotation (Line(points={{-1,-20},{8,-20},{8,-4},{
          -24,-4},{-24,20},{-4,20}}, color={255,0,255}));
  connect(con.u_s, T_mixSet) annotation (Line(points={{-82,80},{-92,80},{-92,80},
          {-110,80}}, color={0,0,127}));
  connect(T_mix, con.u_m)
    annotation (Line(points={{-110,40},{-70,40},{-70,68}}, color={0,0,127}));
  connect(con.y, switch1.u1) annotation (Line(points={{-59,80},{-14,80},{-14,28},
          {-4,28}}, color={0,0,127}));
  connect(T_oa, feedback.u2) annotation (Line(points={{-110,-40},{-80,-40},{-80,
          -28}}, color={0,0,127}));
  connect(feedback.u1, T_mix) annotation (Line(points={{-88,-20},{-96,-20},{-96,
          40},{-110,40}}, color={0,0,127}));
  connect(Limiter.y, yOutAirFra)
    annotation (Line(points={{61,0},{110,0}}, color={0,0,127}));
  connect(hysYHea.on, and1.u2) annotation (Line(points={{-39,-80},{-28,-80},{
          -28,-28},{-24,-28}}, color={255,0,255}));
  connect(hysYHea.u, yHea)
    annotation (Line(points={{-61,-80},{-110,-80}}, color={0,0,127}));
  connect(feedback.y, hysTMix.u)
    annotation (Line(points={{-71,-20},{-61,-20}}, color={0,0,127}));
  connect(and1.u1, hysTMix.on)
    annotation (Line(points={{-24,-20},{-39,-20}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ControllerEconomizer;
