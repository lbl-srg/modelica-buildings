within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Examples;
model ACLineMatrix_RLC_N
  "Test model for a three-phase unbalanced RLC line with neutral cable specified by Z and B matrices"
  extends Modelica.Icons.Example;
  Sources.FixedVoltage_N E(
    definiteReference=true,
    f=60,
    V=100*sqrt(3)) "Voltage source"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Loads.Impedance_N sc_load1(R=0, L=0) "Short circuit load"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Lines.TwoPortMatrixRLC_N Rline_1(
    Z11={10,10},
    Z12={0,0},
    Z13={0,0},
    Z22={10,10},
    Z23={0,0},
    Z33={10,10},
    V_nominal=100*sqrt(3),
    B12=0,
    B13=0,
    B23=0,
    B11=10,
    B22=10,
    B33=10,
    Z14={0,0},
    Z24={0,0},
    Z34={0,0},
    Z44={10,10},
    B14=0,
    B24=0,
    B34=0,
    B44=10) "RL line that connects to load 1"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Lines.TwoPortMatrixRLC_N Rline_2(
    Z12={0,0},
    Z13={0,0},
    Z23={0,0},
    V_nominal=100*sqrt(3),
    B12=0,
    B13=0,
    B23=0,
    Z11={0,0},
    Z22={0,0},
    Z33={0,0},
    B11=0.1,
    B22=0.1,
    B33=0.1,
    Z14={0,0},
    Z24={0,0},
    B14=0,
    B24=0,
    B34=0,
    B44=0.1,
    Z34={0,0},
    Z44={0,0}) "RL line that connects to load 2"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(E.terminal, Rline_1.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,30},{-60,30}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(E.terminal, Rline_2.terminal_n) annotation (Line(
      points={{-80,0},{-60,0}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(Rline_1.terminal_p, sc_load1.terminal) annotation (Line(
      points={{-40,30},{0,30}},
      color={127,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Lines/Examples/ACLineMatrix_RLC_N.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates how to use a RLC line model with neutral line to connect
a source to a load. The model is parameterized using the impedance matrix Z
and the admittance matrix B.
</p>
<p>
The example shows two configurations to test a zero and non-zero matrix <i>B</i>.
In the second case the impedance matrix <i>Z</i> has been set to zero.
Therefore, the line model does not have a load connected to it.
</p>
</html>", revisions="<html>
<ul>
<li>
January 14, 2015, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>"));
end ACLineMatrix_RLC_N;
