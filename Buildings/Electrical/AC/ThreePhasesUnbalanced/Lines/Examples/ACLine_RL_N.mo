within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Examples;
model ACLine_RL_N
  "Test model for a three-phase unbalanced inductive-resistive line with neutral cable"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Resistance Rbase=3*10
    "Base value for the line resistance";
  parameter Modelica.Units.SI.Inductance Lbase=Rbase/2/Modelica.Constants.pi/60
    "Base value for the line inductance";
  Sources.FixedVoltage_N E(
    definiteReference=true,
    f=60,
    V=100*sqrt(3)) "Voltage source"
    annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));
  Loads.Impedance_N load_sc_1(R=0) "Short circuit 1"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Loads.Impedance_N load_sc_2(R=0) "Short circuit 2"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Lines.TwoPortRL_N RL_2(
    R=Rbase,
    L=Lbase,
    Rn=0.5*Rbase,
    Ln=0.5*Lbase) "Resistive-Inductive line connected to short circuit 2"
    annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));
  Lines.TwoPortResistance_N R_1(R=Rbase, Rn=0.5*Rbase)
    "Resistance line connected to short circuit 1"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Lines.TwoPortInductance_N L_1(L=Lbase, Ln=0.5*Lbase)
    "Inductance line connected to short circuit 1"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
equation
  connect(RL_2.terminal_p, load_sc_2.terminal) annotation (Line(
      points={{-28,0},{0,0}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(L_1.terminal_p, load_sc_1.terminal) annotation (Line(
      points={{-10,30},{0,30}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(L_1.terminal_n, R_1.terminal_p) annotation (Line(
      points={{-30,30},{-40,30}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(R_1.terminal_n, E.terminal) annotation (Line(
      points={{-60,30},{-70,30},{-70,0},{-76,0}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(E.terminal, RL_2.terminal_n) annotation (Line(
      points={{-76,0},{-48,0}},
      color={127,0,127},
      smooth=Smooth.None));
  annotation (  experiment(StopTime=1.0,Tolerance=1e-06),
  __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Lines/Examples/ACLine_RL_N.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
March 20, 2015, by Michael Wetter:<br/>
Removed dynamic load model as this caused divergence.
(Dassault SR00259003.)
</li>
<li>
March 19, 2015, by Marco Bonvini:<br/>
Added initial conditions for the dynamic load model.
</li>
<li>
January 14, 2015, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>", info="<html>
<p>
This example demonstrates how to use a resistive-inductive line model with neutral cable to connect
a source to a load.
</p>
<p>
The model has two loads <code>load_sc_1</code> and <code>load_sc_2</code>
representing short circuits <i>R=0</i>.
The current that flows through the load depends on the impedance of the line.
</p>
<p>
Each load is connected to the source with different configurations,
but the equivalent impedance between each load and the source is the same.
Since the equivalent impedances are the same, each load draw the same current.
</p>
</html>"));
end ACLine_RL_N;
