within Districts.Electrical.DC.Loads.Examples;
model Resistor "Example model for resistor"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.DC.Loads.Resistor res2(R=2) "Resistor"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Sources.ConstantVoltage sou(V=12) "Voltage source"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Electrical.Analog.Basic.Ground gro "Ground"
    annotation (Placement(transformation(extent={{-90,-2},{-70,18}})));
  Lines.TwoPortResistance res(R=2) "Resistance"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Sensors.GeneralizedSensor sen
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Districts.Electrical.DC.Loads.Resistor res1(R=2) "Resistor"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Sensors.GeneralizedSensor sen1
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
equation
  connect(gro.p, sou.n)  annotation (Line(
      points={{-80,18},{-80,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.terminal, res.terminal_n)
                                      annotation (Line(
      points={{-60,30},{-40,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(res.terminal_p, sen.terminal_n) annotation (Line(
      points={{-20,30},{0,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen.terminal_p,res2. terminal) annotation (Line(
      points={{20,30},{40,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(res1.terminal, sen1.terminal_p) annotation (Line(
      points={{40,60},{20,60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen1.terminal_n, res.terminal_n) annotation (Line(
      points={{0,60},{-40,60},{-40,30}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (            Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/Electrical/DC/Loads/Examples/Resistor.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates the use of the resistor model.
</p>
</html>", revisions="<html>
<ul>
<li>
August 16, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Resistor;
