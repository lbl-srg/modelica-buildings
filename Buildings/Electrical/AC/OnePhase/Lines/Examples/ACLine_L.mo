within Buildings.Electrical.AC.OnePhase.Lines.Examples;
model ACLine_L "Test model for a single phase inductive line"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Inductance Lbase=10/2/Modelica.Constants.pi/60
    "Base value for the line inductances";
  Sources.FixedVoltage E(      definiteReference=true,
    f=60,
    V=120) "Voltage source"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Loads.Impedance R1(R=10) "Resistive load 1"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Loads.Impedance R2(
    R=10) "Resistive load 2"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Loads.Impedance R3(
    R=10) "Resistive load 3"
    annotation (Placement(transformation(extent={{0,-62},{20,-42}})));
  Loads.Impedance load_sc(R=0) "Short circuit"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  TwoPortInductance Lline_sc(L=Lbase)
    "Inductive line connected to the short circuit"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  TwoPortInductance Lline_1(L=Lbase) "Inductive line connected to load 1"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  TwoPortInductance Lline_2a(L=0.5*Lbase) "Inductive line connected to load 2"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  TwoPortInductance Lline_2b(L=0.5*Lbase) "Inductive line connected to load 2"
    annotation (Placement(transformation(extent={{-36,-30},{-16,-10}})));
  TwoPortInductance Lline_3(L=2*Lbase) "Inductive line connected to load 3"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  TwoPortInductance Lline_3b(L=2*Lbase) "Inductive line connected to load 3"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
equation
  connect(E.terminal, Lline_sc.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,50},{-60,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Lline_sc.terminal_p, load_sc.terminal) annotation (Line(
      points={{-40,50},{0,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, Lline_1.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,10},{-60,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Lline_1.terminal_p, R1.terminal) annotation (Line(
      points={{-40,10},{0,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, Lline_2a.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-20},{-60,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Lline_2a.terminal_p, Lline_2b.terminal_n) annotation (Line(
      points={{-40,-20},{-36,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Lline_2b.terminal_p, R2.terminal) annotation (Line(
      points={{-16,-20},{-4.44089e-16,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, Lline_3.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-40},{-60,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, Lline_3b.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-60},{-60,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Lline_3.terminal_p, R3.terminal) annotation (Line(
      points={{-40,-40},{-20,-40},{-20,-52},{0,-52}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Lline_3b.terminal_p, R3.terminal) annotation (Line(
      points={{-40,-60},{-20,-60},{-20,-52},{0,-52}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Lines/Examples/ACLine_L.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates how to use a purely inductive line model to connect
a source to a load.
</p>
<p>
The model has four different loads. The load <code>sc_load</code> represents
a short circuit <i>R=0</i>. The current that flows through the load depends
on the inductance of the line.
</p>
<p>
The remaining three loads <code>R1</code>, <code>R2</code>, and <code>R3</code>
are resistive loads. Each load is connected to the source with different configurations,
however the equivalent impedance between each load and the source is the same.
Since the equivalent impedances are the same, each load draw the same current.
</p>
</html>", revisions="<html>
<ul>
<li>
August 24, 2014, by Marco Bonvini:<br/>
Documentation and example revised.
</li>
</ul>
</html>"));
end ACLine_L;
