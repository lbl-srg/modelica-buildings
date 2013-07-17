within Districts.Electrical.DC.Loads.Examples;
model VariableLoad
  extends Modelica.Icons.Example;
  Conductor Load1(P_nominal=50)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Sources.ConstantVoltage E(V=12)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-70,-2},{-50,18}})));
  Conductor Load2(P_nominal=50, mode=Districts.Electrical.Types.Assumption.VariableZ_y_input)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Ramp varLoad_y(
    height=0.8,
    duration=0.5,
    startTime=0.3,
    offset=0)
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  Conductor Load3(P_nominal=50, mode=Districts.Electrical.Types.Assumption.VariableZ_P_input)
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.Ramp varLoad_P(
    duration=0.5,
    startTime=0.3,
    height=120,
    offset=-20)
    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
equation
  connect(ground.p, E.n) annotation (Line(
      points={{-60,18},{-60,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(E.terminal, Load1.terminal) annotation (Line(
      points={{-40,30},{0,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(E.terminal, Load2.terminal) annotation (Line(
      points={{-40,30},{-20,30},{-20,10},{0,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(varLoad_y.y, Load2.y) annotation (Line(
      points={{39,10},{20,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(E.terminal, Load3.terminal) annotation (Line(
      points={{-40,30},{-20,30},{-20,-10},{0,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(varLoad_P.y, Load3.Pow) annotation (Line(
      points={{39,-30},{30,-30},{30,-10},{20,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end VariableLoad;
