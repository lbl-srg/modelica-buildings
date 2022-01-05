within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Examples;
model ACLine_RLC "Test model for a three-phase unbalanced RLC line"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Resistance RBase=3*10
    "Base value for the line resistance";
  parameter Modelica.Units.SI.Inductance LBase=RBase/(2*Modelica.Constants.pi*
      60) "Base value for the line inductances";
  parameter Modelica.Units.SI.Capacitance CBase=3*0.1/(2*Modelica.Constants.pi*
      60) "Base value for the line inductances";
  Sources.FixedVoltage E(
    definiteReference=true,
    f=60,
    V=100*sqrt(3)) "Voltage source"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Loads.Impedance sc_load1(R=0, L=0) "Short circuit load"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Loads.Impedance sc_load2(R=0, L=0) "Short circuit load"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Loads.Impedance sc_load3(R=0, L=0) "Short circuit load"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Loads.Impedance sc_load(R=0, L=0) "Short circuit load"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Lines.TwoPortRLC RLCLine_sc(
    R=RBase,
    C=CBase,
    L=LBase,
    mode=Buildings.Electrical.Types.Load.FixedZ_dynamic,
    V_nominal=480) "RLC line that connects to the short circuit"
    annotation (Placement(transformation(extent={{-60,60},{-40,40}})));
  Lines.TwoPortRLC RLCLine_1(
    R=RBase,
    C=CBase,
    L=LBase,
    V_nominal=480) "RLC line that connects to load 1"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Lines.TwoPortRLC RLCLine_2a(
    V_nominal=480,
    R=RBase/2,
    L=LBase/2,
    C=CBase/2) "RLC line that connects to load 2"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Lines.TwoPortRLC RLCLine_2b(
    V_nominal=480,
    R=RBase/2,
    L=LBase/2,
    C=CBase/2) "RLC line that connects to load 2"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Lines.TwoPortRLC RLCLine_3a(
    R=2*RBase,
    L=2*LBase,
    V_nominal=480,
    C=CBase/2) "RLC line that connects to load 3"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Lines.TwoPortRLC RLCLine_3b(
    R=2*RBase,
    L=2*LBase,
    V_nominal=480,
    C=CBase/2) "RLC line that connects to load 3"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation
  connect(E.terminal, RLCLine_sc.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,50},{-60,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RLCLine_sc.terminal_p, sc_load.terminal) annotation (Line(
      points={{-40,50},{0,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, RLCLine_1.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,10},{-60,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RLCLine_1.terminal_p, sc_load1.terminal) annotation (Line(
      points={{-40,10},{0,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, RLCLine_2a.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-20},{-60,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RLCLine_2a.terminal_p, RLCLine_2b.terminal_n) annotation (Line(
      points={{-40,-20},{-30,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RLCLine_2b.terminal_p, sc_load2.terminal) annotation (Line(
      points={{-10,-20},{-4.44089e-16,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, RLCLine_3a.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-50},{-60,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, RLCLine_3b.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-70},{-60,-70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RLCLine_3a.terminal_p, sc_load3.terminal) annotation (Line(
      points={{-40,-50},{-20,-50},{-20,-60},{0,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RLCLine_3b.terminal_p, sc_load3.terminal) annotation (Line(
      points={{-40,-70},{-20,-70},{-20,-60},{0,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (  experiment(StopTime=1.0,Tolerance=1e-6),
  __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Lines/Examples/ACLine_RLC.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates how to use an RLC line model to connect
a source to a load.
</p>
<p>
The model has four different loads. The loads <code>sc_load</code>,
<code>sc_load1</code>, <code>sc_load2</code>, <code>sc_load3</code> represent
short circuits <i>R=0</i>. The current that flows through the load depends
on the resistance, inductance and capacitance of the line.
</p>
<p>
The parameter <i>R</i>, <i>L</i> and <i>C</i> are such that at the nominal
frequency <i>f<sub>nom</sub> = 60 Hz</i> the respective resistance and
reactances are all equal to 10 &Omega;.
</p>
<p>
The lines used in this example have a T model (see
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortRLC\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortRLC</a>).
The equivalent impedance of the line on each phase is equal to
</p>
<p align=\"center\" style=\"font-style:italic;\">
Z<sub>EQ</sub> = R/2 +jX<sub>L</sub>/2 + (R/2 +jX<sub>L</sub>/2)(-jX<sub>C</sub>)/
(R/2 +jX<sub>L</sub>/2 -jX<sub>C</sub>)
</p>
<p>
that in this case is equal to <i>Z<sub>EQ</sub> = 15 + j5 </i> &Omega;.
</p>
<p>
Given the equivalent impedance of each phase, and a voltage
with an RMS value of 100 V produces a current equal to
<i>I = 6 - j2 </i> A flowing through phase 1.
</p>
<h4>Notes</h4>
<p>
<b>(1) Note:</b>
The line model <code>RLCLine_sc</code> is the same as <code>RLCLine_1</code> but it uses
dynamic phasors.
</p>

<p>
<b>(2) Note:</b>
The line model <code>RLCLine_2a</code> has a current that is different
from the one passing in <code>RLCLine_1</code> because the series of two T
line models is different from the sum of the two separate line models.
</p>

<p>
<b>(3) Note:</b>
The line models <code>RLCLine_3a</code> and <code>RLCLine_3b</code> have currents that are
50% of the other lines because they are in parallel.
</p>
</html>", revisions="<html>
<ul>
<li>
October 8, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>"));
end ACLine_RLC;
