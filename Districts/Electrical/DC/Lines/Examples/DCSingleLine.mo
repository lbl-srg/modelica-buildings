within Districts.Electrical.DC.Lines.Examples;
model DCSingleLine
  extends Modelica.Icons.Example;
  Line line(
    P_nominal=500,
    V_nominal=50,
    Length=1000)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Sources.ConstantVoltage E(V=50)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Loads.Conductor load1(P_nominal=50, mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state)
    annotation (Placement(transformation(extent={{32,0},{52,20}})));
equation
  connect(E.terminal, line.terminal_n) annotation (Line(
      points={{-60,10},{-20,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ground.p, E.n) annotation (Line(
      points={{-80,4.44089e-16},{-80,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(load1.terminal, line.terminal_p) annotation (Line(
      points={{32,10},{4.44089e-16,10}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end DCSingleLine;
