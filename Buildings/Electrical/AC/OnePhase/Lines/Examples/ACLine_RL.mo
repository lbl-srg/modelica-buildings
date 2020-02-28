within Buildings.Electrical.AC.OnePhase.Lines.Examples;
model ACLine_RL "Test model for a single phase inductive-resistive line"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Resistance Rbase=10
    "Base value for the line resistance";
  parameter Modelica.Units.SI.Inductance Lbase=Rbase/2/Modelica.Constants.pi/60
    "Base value for the line inductance";
  Sources.FixedVoltage E(      definiteReference=true,
    f=60,
    V=120) "Voltage source"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Loads.Impedance load_sc_1(R=0) "Short circuit 1"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Loads.Impedance load_sc_2(R=0) "Short circuit 2"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  TwoPortRL RL_2(R=Rbase, L=Lbase)
    "Resistive-Inductive line connected to short circuit 2"
    annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));
  TwoPortResistance R_1(R=Rbase) "Resistance line connected to short circuit 1"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  TwoPortInductance L_1(L=Lbase) "Inductance line connected to short circuit 1"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  TwoPortRL RL_3(
    R=Rbase,
    L=Lbase,
    mode=Buildings.Electrical.Types.Load.FixedZ_dynamic,
    i_start={0,0})
    "Dynamic resistive-inductive line connected to short circuit 3"
    annotation (Placement(transformation(extent={{-48,-40},{-28,-20}})));
  Loads.Impedance load_sc_3(R=0) "Short circuit 3"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
equation
  connect(E.terminal, R_1.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,30},{-60,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(R_1.terminal_p, L_1.terminal_n) annotation (Line(
      points={{-40,30},{-30,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(L_1.terminal_p, load_sc_1.terminal) annotation (Line(
      points={{-10,30},{0,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, RL_2.terminal_n) annotation (Line(
      points={{-80,0},{-48,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RL_2.terminal_p, load_sc_2.terminal) annotation (Line(
      points={{-28,0},{0,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, RL_3.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-30},{-48,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RL_3.terminal_p, load_sc_3.terminal) annotation (Line(
      points={{-28,-30},{0,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Lines/Examples/ACLine_RL.mos"
        "Simulate and plot"),
  Documentation(revisions="<html>
<ul>
<li>
August 24, 2014, by Marco Bonvini:<br/>
Documentation and example revised.
</li>
</ul>
</html>", info="<html>
<p>
This example demonstrates how to use a resistive-inductive line model to connect
a source to a load.
</p>
<p>
The model has three loads <code>load_sc_1</code>, <code>load_sc_2</code>,
and <code>load_sc_3</code> representing short circuits <i>R=0</i>.
The current that flows through the load depends on the impedance of the line.
</p>
<p>
Each load is connected to the source with different configurations,
however the equivalent impedance between each load and the source is the same.
Since the equivalent impedances are the same, each load draw the same current.
</p>
<p>
<b>Note:</b>
The line model <code>RL_3</code> is the same as <code>RL_2</code> but it uses
dynamic phasors.
</p>
</html>"));
end ACLine_RL;
