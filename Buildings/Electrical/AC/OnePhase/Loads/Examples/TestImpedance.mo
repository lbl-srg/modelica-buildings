within Buildings.Electrical.AC.OnePhase.Loads.Examples;
model TestImpedance "Example that illustrates the use of the impedances"
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage V(f=60, V=120)
           annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Z1(R=0,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60)) "Inductive impedance"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Z2(R=0,
    inductive=false,
    C=1/(2*Modelica.Constants.pi*60)) "Capacitive impedance"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Z3(R=1)
    "Resistive impedance"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Z4(
    R=1,
    L=1/(2*Modelica.Constants.pi*60)) "Inductive-resistive impedance"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Z5(
    R=1,
    inductive=false,
    C=1/(2*Modelica.Constants.pi*60)) "Capacitive-resistive impedance"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
equation
  connect(V.terminal, Z1.terminal)  annotation (Line(
      points={{-60,30},{-20,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z2.terminal) annotation (Line(
      points={{-60,30},{-40,30},{-40,10},{-20,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z3.terminal) annotation (Line(
      points={{-60,30},{-40,30},{-40,-10},{-20,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z4.terminal) annotation (Line(
      points={{-60,30},{-40,30},{-40,-30},{-20,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z5.terminal) annotation (Line(
      points={{-60,30},{-40,30},{-40,-50},{-20,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Loads/Examples/TestImpedance.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model shows how to use the impedance model in different configurations:
</p>
<ul>
<li>Resistive (model <code>Z3</code>)</li>
<li>Inductive (model <code>Z1</code>)</li>
<li>Capacitive (model <code>Z2</code>)</li>
<li>Resistive-Inductive (model <code>Z4</code>)</li>
<li>Resistive-Capacitive (model <code>Z5</code>)</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
</ul>
</html>"));
end TestImpedance;
