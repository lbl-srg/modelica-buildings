within Buildings.Air.Systems.SingleZone.VAV.BaseClasses;
model ControllerEconomizer "Controller for economizer"
  parameter Real sensitivityGainEco = 0.25 "Controller gain";
  Modelica.Blocks.Interfaces.RealInput T_mixSet
    "Mixed air setpoint temperature"            annotation (Placement(
        transformation(rotation=0, extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput T_mix "Measured mixed air temperature"
                                             annotation (Placement(
        transformation(rotation=0, extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Math.Feedback coolError
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Math.Gain ecoGain(k=-1/sensitivityGainEco)
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Interfaces.RealOutput oaFra
    "Control signal for outside air fraction"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealInput minOAFra "Minimum outside air fraction"
                                                annotation (Placement(
        transformation(rotation=0, extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Nonlinear.VariableLimiter Limiter(strict=true)
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Interfaces.RealInput T_oa "Measured outside air temperature"
                                            annotation (Placement(
        transformation(rotation=0, extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-2,10},{18,30}})));
  Modelica.Blocks.Interfaces.RealInput heaterSet(start=0)
    "Control signal for heating coil"                     annotation (Placement(
        transformation(rotation=0, extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Logical.Greater greater
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-22,-30},{-2,-10}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=0.05, uHigh=0.15)
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
equation
  connect(T_mixSet, coolError.u1)
    annotation (Line(points={{-110,80},{-94,80},{-78,80}}, color={0,0,127}));
  connect(T_mix, coolError.u2) annotation (Line(points={{-110,40},{-90,40},{-70,
          40},{-70,72}}, color={0,0,127}));
  connect(coolError.y, ecoGain.u)
    annotation (Line(points={{-61,80},{-42,80}}, color={0,0,127}));
  connect(Limiter.limit2, minOAFra) annotation (Line(points={{38,72},{26,
          72},{26,0},{-110,0}}, color={0,0,127}));
  connect(const.y, Limiter.limit1) annotation (Line(points={{-19,50},{20,
          50},{20,88},{38,88}}, color={0,0,127}));
  connect(Limiter.y, oaFra)
    annotation (Line(points={{61,80},{110,80}}, color={0,0,127}));
  connect(ecoGain.y, switch1.u1) annotation (Line(points={{-19,80},{-12,
          80},{-12,28},{-4,28}}, color={0,0,127}));
  connect(minOAFra, switch1.u3) annotation (Line(points={{-110,0},{-12,0},
          {-12,12},{-4,12}}, color={0,0,127}));
  connect(switch1.y, Limiter.u) annotation (Line(points={{19,20},{24,20},
          {24,80},{38,80}}, color={0,0,127}));
  connect(T_mix, greater.u1) annotation (Line(points={{-110,40},{-96,40},
          {-80,40},{-80,-20},{-62,-20}}, color={0,0,127}));
  connect(T_oa, greater.u2) annotation (Line(points={{-110,-40},{-80,-40},
          {-80,-28},{-62,-28}}, color={0,0,127}));
  connect(greater.y, and1.u1)
    annotation (Line(points={{-39,-20},{-24,-20}}, color={255,0,255}));
  connect(and1.y, switch1.u2) annotation (Line(points={{-1,-20},{8,-20},{8,-4},{
          -24,-4},{-24,20},{-4,20}}, color={255,0,255}));
  connect(heaterSet, hysteresis.u) annotation (Line(points={{-110,-80},{
          -92,-80},{-72,-80}}, color={0,0,127}));
  connect(hysteresis.y, not1.u) annotation (Line(points={{-49,-80},{-46,
          -80},{-42,-80}}, color={255,0,255}));
  connect(not1.y, and1.u2) annotation (Line(points={{-19,-80},{-10,-80},{
          -10,-50},{-30,-50},{-30,-28},{-24,-28}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ControllerEconomizer;
