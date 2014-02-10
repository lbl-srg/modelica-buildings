within Buildings.Electrical.AC.OnePhase.Lines.Examples;
model ACline_RL
  extends Modelica.Icons.Example;
  parameter Real Rbase = 10;
  parameter Real Lbase = Rbase/2/Modelica.Constants.pi/50;
  Sources.FixedVoltage E(      definiteReference=true,
    f=50,
    Phi=0,
    V=220)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Loads.Impedance R1(R=0)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Loads.Impedance R2(R=0)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  TwoPortRL RL(
    R=Rbase,
    L=Lbase,
    V_nominal=220)
    annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));
  TwoPortResistance R(R=Rbase)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  TwoPortInductance L(L=Lbase)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  TwoPortRL RL1(
    R=Rbase,
    L=Lbase,
    V_nominal=220,
    mode=Buildings.Electrical.Types.Assumption.FixedZ_dynamic)
    annotation (Placement(transformation(extent={{-48,-40},{-28,-20}})));
  Loads.Impedance R3(R=0)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
equation
  connect(E.terminal, R.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,30},{-60,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(R.terminal_p, L.terminal_n) annotation (Line(
      points={{-40,30},{-30,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(L.terminal_p, R1.terminal) annotation (Line(
      points={{-10,30},{0,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, RL.terminal_n) annotation (Line(
      points={{-80,0},{-48,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RL.terminal_p, R2.terminal) annotation (Line(
      points={{-28,0},{0,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, RL1.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-30},{-48,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RL1.terminal_p, R3.terminal) annotation (Line(
      points={{-28,-30},{0,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),            graphics),
  __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Lines/Examples/ACline_RL.mos"
        "Simulate and plot"));
end ACline_RL;
