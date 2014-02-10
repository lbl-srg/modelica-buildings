within Buildings.Electrical.AC.OnePhase.Lines.Examples;
model ACline
  extends Modelica.Icons.Example;
  Sources.FixedVoltage E(      definiteReference=true,
    f=50,
    Phi=0,
    V=220)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Loads.Impedance R1(R=10)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Line line1(
    V_nominal=220,
    P_nominal=5000,
    l=2000,
    mode=Types.CableMode.commercial,
    commercialCable_low=Transmission.LowVoltageCables.Cu50())
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Line line2(
    V_nominal=220,
    P_nominal=5000,
    mode=Types.CableMode.commercial,
    commercialCable_low=Transmission.LowVoltageCables.Cu50(),
    l=1000)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Loads.Impedance R2(
    R=10)
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Line line3(
    V_nominal=220,
    P_nominal=5000,
    mode=Types.CableMode.commercial,
    commercialCable_low=Transmission.LowVoltageCables.Cu50(),
    l=1000)
    annotation (Placement(transformation(extent={{-32,-30},{-12,-10}})));
  Line line4(
    V_nominal=220,
    P_nominal=5000,
    mode=Types.CableMode.commercial,
    commercialCable_low=Transmission.LowVoltageCables.Cu50(),
    l=4000)
    annotation (Placement(transformation(extent={{-60,-54},{-40,-34}})));
  Line line5(
    V_nominal=220,
    P_nominal=5000,
    mode=Types.CableMode.commercial,
    commercialCable_low=Transmission.LowVoltageCables.Cu50(),
    l=4000)
    annotation (Placement(transformation(extent={{-60,-66},{-40,-46}})));
  Loads.Impedance R3(
    R=10)
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Line line6(
    V_nominal=220,
    P_nominal=5000,
    l=2000,
    mode=Types.CableMode.commercial,
    commercialCable_low=Transmission.LowVoltageCables.Cu50())
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Loads.Impedance ShortCircuit(R=0)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
equation
  connect(line1.terminal_p, R1.terminal)    annotation (Line(
      points={{-40,0},{-24,0},{-24,6.66134e-16},{-4.44089e-16,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, line1.terminal_n) annotation (Line(
      points={{-80,4.44089e-16},{-60,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, line2.terminal_n) annotation (Line(
      points={{-80,4.44089e-16},{-70,4.44089e-16},{-70,-20},{-60,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_p, line3.terminal_n) annotation (Line(
      points={{-40,-20},{-32,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line3.terminal_p, R2.terminal) annotation (Line(
      points={{-12,-20},{0,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line4.terminal_p, R3.terminal) annotation (Line(
      points={{-40,-44},{-20,-44},{-20,-50},{0,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line5.terminal_p, R3.terminal) annotation (Line(
      points={{-40,-56},{-20,-56},{-20,-50},{-5.55112e-16,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, line4.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-44},{-60,-44}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, line5.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-56},{-60,-56}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line6.terminal_p, ShortCircuit.terminal) annotation (Line(
      points={{-40,30},{-20,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, line6.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,30},{-60,30}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
  __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Lines/Examples/ACline.mos"
        "Simulate and plot"));
end ACline;
