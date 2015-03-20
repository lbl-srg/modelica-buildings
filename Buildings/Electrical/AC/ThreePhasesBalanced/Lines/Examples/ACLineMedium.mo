within Buildings.Electrical.AC.ThreePhasesBalanced.Lines.Examples;
model ACLineMedium
  "Test model for a single phase line that uses medium voltage commercial cable information "
  extends Modelica.Icons.Example;
  ThreePhasesBalanced.Sources.FixedVoltage E(definiteReference=true, V=15000,
    f=60) "Voltage source"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  ThreePhasesBalanced.Loads.Impedance R1(R=10) "Resistive load 1"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  ThreePhasesBalanced.Lines.Line line_1(
    P_nominal=5000,
    l=2000,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    V_nominal=15000) "Resistive line that connects to load 1"
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  ThreePhasesBalanced.Lines.Line line_2a(
    P_nominal=5000,
    l=1000,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    V_nominal=15000) "Resistive line that connects to load 2"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  ThreePhasesBalanced.Loads.Impedance R2(R=10) "Resistive load 2"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  ThreePhasesBalanced.Lines.Line line_2b(
    P_nominal=5000,
    l=1000,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    V_nominal=15000) "Resistive line that connects to load 2"
    annotation (Placement(transformation(extent={{-32,-30},{-12,-10}})));
  ThreePhasesBalanced.Lines.Line line_3a(
    P_nominal=5000,
    l=4000,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    V_nominal=15000) "Resistive line that connects to load 3"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  ThreePhasesBalanced.Lines.Line line_3b(
    P_nominal=5000,
    l=4000,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    V_nominal=15000) "Resistive line that connects to load 3"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  ThreePhasesBalanced.Loads.Impedance R3(R=10) "Resistive load 3"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  ThreePhasesBalanced.Lines.Line line_sc(
    P_nominal=5000,
    l=2000,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    V_nominal=15000) "Line that connects the source and the short circuit"
    annotation (Placement(transformation(extent={{-58,20},{-38,40}})));
  ThreePhasesBalanced.Loads.Impedance load_sc(R=0) "Short circuit"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
equation
  connect(line_1.terminal_p, R1.terminal) annotation (Line(
      points={{-38,0},{-24,0},{-24,6.66134e-16},{-4.44089e-16,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, line_1.terminal_n) annotation (Line(
      points={{-80,4.44089e-16},{-58,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, line_2a.terminal_n) annotation (Line(
      points={{-80,4.44089e-16},{-70,4.44089e-16},{-70,-20},{-60,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line_2a.terminal_p, line_2b.terminal_n) annotation (Line(
      points={{-40,-20},{-32,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line_2b.terminal_p, R2.terminal) annotation (Line(
      points={{-12,-20},{0,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line_3a.terminal_p, R3.terminal) annotation (Line(
      points={{-40,-40},{-20,-40},{-20,-50},{0,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line_3b.terminal_p, R3.terminal) annotation (Line(
      points={{-40,-60},{-20,-60},{-20,-50},{-5.55112e-16,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, line_3a.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-40},{-60,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, line_3b.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,-60},{-60,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line_sc.terminal_p, load_sc.terminal) annotation (Line(
      points={{-38,30},{-4.44089e-16,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, line_sc.terminal_n) annotation (Line(
      points={{-80,0},{-70,0},{-70,30},{-58,30}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Lines/Examples/ACLineMedium.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Documentation and example added.
</li>
</ul>
</html>", info="<html>
<p>
This example demonstrates how to use a line model to connect
a source to a load that uses medium voltage commercial cable information.
</p>
<p>
The model has four different loads. The load <code>sc_load</code> represents
a short circuit <i>R=0</i>. The current that flows through the load depends
on the impedance of the line.
</p>
<p>
The remaining three loads <code>R1</code>, <code>R2</code>, and <code>R3</code>
are resistive loads. Each load is connected to the source with different configurations,
however the equivalent impedance between each load and the source is the same.
Since the equivalent impedances are the same, each load draws the same current.
</p>

<h4>Note:</h4>

<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">
<span style=\" font-family:'Courier New,courier'; color:#ff0000;\">ThreePhasesBalanced.Lines.Line</span>
<span style=\" font-family:'Courier New,courier';\"> line_1(</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier';\">    V_nominal=220,</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier';\">    P_nominal=5000,</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier';\">    l=2000,</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier'; color:#0000ff;\">redeclare </span>
<span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.Electrical.Transmission.MediumVoltageCables.Generic</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier';\">          commercialCable =</span>
<span style=\" font-family:'Courier New,courier'; color:#ff0000;\"> Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10</span>
<span style=\" font-family:'Courier New,courier';\">()) </span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier'; color:#006400;\">    &quot;Resistive line that connects to load 1&quot;</span>
</p>

<p>
The code snippet shows how a line model <code>line_1</code> redeclared its
record type in order to be <code>Buildings.Electrical.Transmission.MediumVoltageCables.Generic</code>.
</p>

</html>"));
end ACLineMedium;
