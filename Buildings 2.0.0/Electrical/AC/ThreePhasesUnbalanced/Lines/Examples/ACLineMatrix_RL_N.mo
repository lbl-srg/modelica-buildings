within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Examples;
model ACLineMatrix_RL_N
  "Test model for a three-phase unbalanced inductive-resistive line with neutral cable specified by a Z matrix"
  extends Modelica.Icons.Example;
  Sources.FixedVoltage_N E(
    definiteReference=true,
    f=60,
    V=100*sqrt(3)) "Voltage source"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Loads.Impedance_N sc_load1(R=0, L=0) "Short circuit load"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Loads.Impedance_N sc_load2(R=0, L=0) "Short circuit load"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Loads.Impedance_N sc_load3(R=0, L=0) "Short circuit load"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Lines.TwoPortMatrixRL_N Rline_1(
    Z11={10,10},
    Z12={0,0},
    Z13={0,0},
    Z22={10,10},
    Z23={0,0},
    Z33={10,10},
    V_nominal=100*sqrt(3),
    Z14={0,0},
    Z24={0,0},
    Z34={0,0},
    Z44={10,10}) "RL line that connects to load 1"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Lines.TwoPortMatrixRL_N Rline_2a(
    Z12={0,0},
    Z13={0,0},
    Z23={0,0},
    Z11=0.5*{10,10},
    Z22=0.5*{10,10},
    Z33=0.5*{10,10},
    V_nominal=100*sqrt(3),
    Z14={0,0},
    Z24={0,0},
    Z34={0,0},
    Z44=0.5*{10,10}) "RL line that connects to load 2"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Lines.TwoPortMatrixRL_N Rline_2b(
    Z12={0,0},
    Z13={0,0},
    Z23={0,0},
    Z11=0.5*{10,10},
    Z22=0.5*{10,10},
    Z33=0.5*{10,10},
    V_nominal=100*sqrt(3),
    Z14={0,0},
    Z24={0,0},
    Z34={0,0},
    Z44=0.5*{10,10}) "RL line that connects to load 2"
    annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));
  Lines.TwoPortMatrixRL_N Rline_3a(
    Z12={0,0},
    Z13={0,0},
    Z23={0,0},
    Z11=2*{10,10},
    Z22=2*{10,10},
    Z33=2*{10,10},
    V_nominal=100*sqrt(3),
    Z14={0,0},
    Z24={0,0},
    Z34={0,0},
    Z44=2*{10,10}) "RL line that connects to load 3"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Lines.TwoPortMatrixRL_N Rline_3b(
    Z12={0,0},
    Z13={0,0},
    Z23={0,0},
    Z11=2*{10,10},
    Z22=2*{10,10},
    Z33=2*{10,10},
    V_nominal=100*sqrt(3),
    Z14={0,0},
    Z24={0,0},
    Z34={0,0},
    Z44=2*{10,10}) "RL line that connects to load 3"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(E.terminal, Rline_1.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,30},{-60,30}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(E.terminal, Rline_2a.terminal_n) annotation (Line(
      points={{-80,0},{-60,0}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(E.terminal, Rline_3a.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-30},{-60,-30}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(E.terminal, Rline_3b.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-50},{-60,-50}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(Rline_3b.terminal_p, sc_load3.terminal) annotation (Line(
      points={{-40,-50},{-20,-50},{-20,-40},{0,-40}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(Rline_3a.terminal_p, sc_load3.terminal) annotation (Line(
      points={{-40,-30},{-20,-30},{-20,-40},{0,-40}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(Rline_2b.terminal_p, sc_load2.terminal) annotation (Line(
      points={{-12,0},{0,0}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(Rline_1.terminal_p, sc_load1.terminal) annotation (Line(
      points={{-40,30},{0,30}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(Rline_2a.terminal_p, Rline_2b.terminal_n) annotation (Line(
      points={{-40,0},{-32,0}},
      color={127,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Lines/Examples/ACLineMatrix_RL_N.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates how to use an inductive resistive line model with neutral line to connect
a source to a load. The model is parameterized using the impedance matrix <i>Z</i>.
</p>
<p>
The model has three loads. The loads represent a short circuit <i>R=0</i>.
The current that flows through the load depends on the resistance of the line.
</p>
</html>", revisions="<html>
<ul>
<li>
January 14, 2015, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>"));
end ACLineMatrix_RL_N;
