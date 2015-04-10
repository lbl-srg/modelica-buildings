within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Examples;
model ACLine_N
  "Test model for a three-phase unbalanced commercial cable with neutral"
  extends Modelica.Icons.Example;
  Sources.FixedVoltage_N E(
    definiteReference=true,
    f=60,
    V=480) "Voltage source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Loads.Impedance_N R1(R=10) "Resistive load 1"
    annotation (Placement(transformation(extent={{22,20},{42,40}})));
  Loads.Impedance_N R2(R=10) "Resistive load 2"
    annotation (Placement(transformation(extent={{22,-10},{42,10}})));
  Loads.Impedance_N R3(R=10) "Resistive load 3"
    annotation (Placement(transformation(extent={{22,-50},{42,-30}})));
  Line_N line_1(
    l=1000,
    P_nominal=2000,
    V_nominal=480,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.LowVoltageCables.Cu35
      commercialCable) "Cable that connects to load 1"
    annotation (Placement(transformation(extent={{-38,20},{-18,40}})));
  Line_N line_2a(
    l=500,
    P_nominal=2000,
    V_nominal=480,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.LowVoltageCables.Cu35
      commercialCable) "Cable that connects to load 2"
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
  Line_N line_2b(
    l=500,
    P_nominal=2000,
    V_nominal=480,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.LowVoltageCables.Cu35
      commercialCable) "Cable that connects to load 2"
    annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Line_N line_3a(
    l=2000,
    P_nominal=1000,
    V_nominal=480,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.LowVoltageCables.Cu35
      commercialCable) "Cable that connects to load 3"
    annotation (Placement(transformation(extent={{-38,-40},{-18,-20}})));
  Line_N line_3b(
    l=2000,
    P_nominal=1000,
    V_nominal=480,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.LowVoltageCables.Cu35
      commercialCable) "Cable that connects to load 3"
    annotation (Placement(transformation(extent={{-38,-60},{-18,-40}})));
equation
  connect(E.terminal, line_2a.terminal_n) annotation (Line(
      points={{-60,0},{-44,0}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(E.terminal, line_1.terminal_n) annotation (Line(
      points={{-60,0},{-50,0},{-50,30},{-38,30}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(line_1.terminal_p, R1.terminal) annotation (Line(
      points={{-18,30},{22,30}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(E.terminal, line_3a.terminal_n) annotation (Line(
      points={{-60,0},{-50,0},{-50,-30},{-38,-30}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(E.terminal, line_3b.terminal_n) annotation (Line(
      points={{-60,4.44089e-16},{-50,4.44089e-16},{-50,-50},{-38,-50}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(line_2a.terminal_p, line_2b.terminal_n) annotation (Line(
      points={{-24,0},{-14,0}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(line_3a.terminal_p, R3.terminal) annotation (Line(
      points={{-18,-30},{2,-30},{2,-40},{22,-40}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(line_3b.terminal_p, R3.terminal) annotation (Line(
      points={{-18,-50},{2,-50},{2,-40},{22,-40}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(line_2b.terminal_p, R2.terminal) annotation (Line(
      points={{6,0},{22,0}},
      color={127,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Lines/Examples/ACLine_N.mos"
        "Simulate and plot"),
 Documentation(info="<html>
<p>
This example demonstrates how to use a cable line model with
neutral to connect a source to a load.
</p>
<p>
The model has three resistive loads <code>R1</code>, <code>R2</code>, and <code>R3</code>.
Each load is connected to the source with different configurations,
but the equivalent resistance between each load and the source is the same.
Since the equivalent resistances are the same, each load draws the same current.
</p>
</html>", revisions="<html>
<ul>
<li>
October 8, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>"));
end ACLine_N;
