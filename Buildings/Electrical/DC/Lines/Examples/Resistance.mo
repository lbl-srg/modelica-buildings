within Buildings.Electrical.DC.Lines.Examples;
model Resistance "Example model to test for the DC resistance two port model"
  extends Modelica.Icons.Example;

  TwoPortResistance lineR(R=10) "Line resistance"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Sources.ConstantVoltage constantVoltage(V=50) "Voltage source"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-72,-16},{-52,4}})));
  Loads.Resistor short_circuit(V_nominal=50, R=0) "Short circuit load"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Sensors.GeneralizedSensor sen "Power sensor"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
equation
  connect(ground.p, constantVoltage.n) annotation (Line(
      points={{-62,4},{-62,20},{-60,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(constantVoltage.terminal, lineR.terminal_n) annotation (Line(
      points={{-40,20},{-30,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(lineR.terminal_p, sen.terminal_n) annotation (Line(
      points={{-10,20},{0,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen.terminal_p, short_circuit.terminal) annotation (Line(
      points={{20,20},{30,20}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation ( Documentation(info="<html>
<p>
This model shows how to use a two port resistance.
In this example the resistance connects an ideal constant voltage source with
a short circuit. The current flowing through the circuit depends just
on the value of the two port resistance.
</p>
</html>", revisions="<html>
<ul>
<li>
June 4, 2014, by Marco Bonvini:<br/>
Added model, documentation and results for regression test.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Lines/Examples/Resistance.mos"
        "Simulate and plot"));
end Resistance;
