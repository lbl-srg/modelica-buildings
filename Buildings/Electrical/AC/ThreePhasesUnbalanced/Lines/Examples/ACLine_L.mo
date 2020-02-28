within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Examples;
model ACLine_L "Test model for a three-phase unbalanced inductive line"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Inductance Lbase=10/2/Modelica.Constants.pi/60
    "Base value for the line inductances";
  Sources.FixedVoltage E(
    definiteReference=true,
    f=60,
    V=480) "Voltage source"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Loads.Impedance L1(R=0, L=Lbase) "Inductive load 1"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Loads.Impedance L2(R=0, L=Lbase) "Inductive load 2"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Loads.Impedance L3(R=0, L=Lbase) "Inductive load 3"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Loads.Impedance sc_load(R=0) "Short circuit load"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Lines.TwoPortInductance Lline_sc(L=6*Lbase)
    "Inductive line that connects to the short circuit"
    annotation (Placement(transformation(extent={{-60,60},{-40,40}})));
  Lines.TwoPortInductance Rline_1(L=3*Lbase)
    "Inductive line that connects to load 1"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Lines.TwoPortInductance Rline_2a(L=3*Lbase/2)
    "Inductive line that connects to load 2"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Lines.TwoPortInductance Rline_2b(L=3*Lbase/2)
    "Inductive line that connects to load 2"
    annotation (Placement(transformation(extent={{-36,-30},{-16,-10}})));
  Lines.TwoPortInductance Rline_3a(L=6*Lbase)
    "Inductive line that connects to load 3"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Lines.TwoPortInductance Rline_3b(L=6*Lbase)
    "Inductive line that connects to load 3"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation
  connect(E.terminal,Lline_sc. terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,50},{-60,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Lline_sc.terminal_p, sc_load.terminal) annotation (Line(
      points={{-40,50},{0,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, Rline_1.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,10},{-60,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Rline_1.terminal_p,L1. terminal) annotation (Line(
      points={{-40,10},{0,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, Rline_2a.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-20},{-60,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Rline_2a.terminal_p, Rline_2b.terminal_n) annotation (Line(
      points={{-40,-20},{-36,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Rline_2b.terminal_p,L2. terminal) annotation (Line(
      points={{-16,-20},{-4.44089e-16,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, Rline_3a.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-50},{-60,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, Rline_3b.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-70},{-60,-70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Rline_3a.terminal_p,L3. terminal) annotation (Line(
      points={{-40,-50},{-20,-50},{-20,-60},{0,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Rline_3b.terminal_p,L3. terminal) annotation (Line(
      points={{-40,-70},{-20,-70},{-20,-60},{0,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-6),
  __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Lines/Examples/ACLine_L.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates how to use a purely inductive line model to connect
a source to a load.
</p>
<p>
The model has four different loads. The load <code>sc_load</code> represents
a short circuit <i>R=0</i>. The current that flows through the load depends
on the resistance of the line.
</p>
<p>
The remaining three loads <code>L1</code>, <code>L2</code>, and <code>L3</code>
are inductive loads. Each load is connected to the source with different configurations,
but the equivalent impedance between each load and the source is the same.
Since the equivalent impedances are the same, each load draws the same current.
</p>
</html>", revisions="<html>
<ul>
<li>
October 8, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>"));
end ACLine_L;
