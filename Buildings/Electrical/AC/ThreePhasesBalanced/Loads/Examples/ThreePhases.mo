within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.Examples;
model ThreePhases
  "Example that provides a comparison between AC one phase and three-phase balanced"
  extends Modelica.Icons.Example;
  Modelica.Units.SI.Power errorY=sqrt((sen_Y.S[1] - (sen_a.S[1] + sen_b.S[1] +
      sen_c.S[1]))^2 + (sen_Y.S[2] - (sen_a.S[2] + sen_b.S[2] + sen_c.S[2]))^2)
    "Difference of the power consumption in the star (Y) connection";
  Modelica.Units.SI.Power errorD=sqrt((sen_D.S[1] - (sen_ab.S[1] + sen_bc.S[1]
       + sen_ca.S[1]))^2 + (sen_D.S[2] - (sen_ab.S[2] + sen_bc.S[2] + sen_ca.S[
      2]))^2)
    "Difference of the power consumption in the triangle (D) connection";
  Sources.FixedVoltage sou(definiteReference=true,
    f=60,
    V=480) "Three phases balanced voltage source"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Impedance RL_star(
    R=1,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60)) "Impedance with Y connection"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  OnePhase.Sources.FixedVoltage sou_a(V=480/sqrt(3), definiteReference=true,
    f=60) "Voltage source phase a"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  OnePhase.Sources.FixedVoltage sou_b(
    V=480/sqrt(3),
    definiteReference=true,
    phiSou=2.0943951023932,
    f=60) "Voltage source phase b"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  OnePhase.Sources.FixedVoltage sou_c(
    V=480/sqrt(3),
    definiteReference=true,
    phiSou=-2.0943951023932,
    f=60) "Voltage source phase c"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  OnePhase.Loads.Impedance RL_a(
    R=1,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60)) "Impedance on phase A"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  OnePhase.Loads.Impedance RL_b(
    R=1,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60)) "Impedance on phase B"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  OnePhase.Loads.Impedance RL_c(
    R=1,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60)) "Impedance on phase C"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Impedance RL_tri(
    R=1,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60),
    star=false) "Impedance with D connection"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  OnePhase.Sources.FixedVoltage sou_ab(
    V=480,
    phiSou=-0.5235987755983,
    definiteReference=true,
    f=60) "Voltage source line ab"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  OnePhase.Sources.FixedVoltage sou_bc(
    phiSou=1.5707963267949,
    V=480,
    definiteReference=true,
    f=60) "Voltage source line bc"
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
  OnePhase.Sources.FixedVoltage sou_ca(
    phiSou=-3.6651914291881,
    V=480,
    definiteReference=true,
    f=60) "Voltage source line ca"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  OnePhase.Loads.Impedance RL_ab(
    R=1,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60)) "Impedance on line AB"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  OnePhase.Loads.Impedance RL_bc(
    R=1,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60)) "Impedance on line BC"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  OnePhase.Loads.Impedance RL_c1(
    R=1,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60)) "Impedance on linease CA"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  OnePhase.Sensors.GeneralizedSensor sen_a
    "Sensor located on phase A (Y connection)"
    annotation (Placement(transformation(extent={{-66,-30},{-46,-10}})));
  OnePhase.Sensors.GeneralizedSensor sen_ab
    "Sensor located on line AB (D connection)"
    annotation (Placement(transformation(extent={{34,-30},{54,-10}})));
  Sensors.GeneralizedSensor sen_Y "Sensor for Y connection (balanced case)"
    annotation (Placement(transformation(extent={{12,50},{32,70}})));
  Sensors.GeneralizedSensor sen_D "Sensor for D connection (balanced case)"
    annotation (Placement(transformation(extent={{12,20},{32,40}})));
  OnePhase.Sensors.GeneralizedSensor sen_b
    "Sensor located on phase B (Y connection)"
    annotation (Placement(transformation(extent={{-66,-60},{-46,-40}})));
  OnePhase.Sensors.GeneralizedSensor sen_c
    "Sensor located on phase C (Y connection)"
    annotation (Placement(transformation(extent={{-66,-90},{-46,-70}})));
  OnePhase.Sensors.GeneralizedSensor sen_bc
    "Sensor located on line BC (D connection)"
    annotation (Placement(transformation(extent={{34,-60},{54,-40}})));
  OnePhase.Sensors.GeneralizedSensor sen_ca
    "Sensor located on line CA (D connection)"
    annotation (Placement(transformation(extent={{34,-90},{54,-70}})));
equation
  connect(sou_a.terminal, sen_a.terminal_n) annotation (Line(
      points={{-70,-20},{-66,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen_a.terminal_p, RL_a.terminal) annotation (Line(
      points={{-46,-20},{-40,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou_ab.terminal, sen_ab.terminal_n) annotation (Line(
      points={{30,-20},{34,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen_ab.terminal_p, RL_ab.terminal) annotation (Line(
      points={{54,-20},{60,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou.terminal, sen_Y.terminal_n) annotation (Line(
      points={{-40,60},{12,60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen_Y.terminal_p, RL_star.terminal) annotation (Line(
      points={{32,60},{40,60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou.terminal, sen_D.terminal_n) annotation (Line(
      points={{-40,60},{0,60},{0,30},{12,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen_D.terminal_p, RL_tri.terminal) annotation (Line(
      points={{32,30},{40,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou_b.terminal, sen_b.terminal_n) annotation (Line(
      points={{-70,-50},{-66,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen_b.terminal_p, RL_b.terminal) annotation (Line(
      points={{-46,-50},{-40,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou_c.terminal, sen_c.terminal_n) annotation (Line(
      points={{-70,-80},{-66,-80}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen_c.terminal_p, RL_c.terminal) annotation (Line(
      points={{-46,-80},{-40,-80}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou_bc.terminal, sen_bc.terminal_n) annotation (Line(
      points={{30,-50},{34,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen_bc.terminal_p, RL_bc.terminal) annotation (Line(
      points={{54,-50},{60,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou_ca.terminal, sen_ca.terminal_n) annotation (Line(
      points={{30,-80},{34,-80}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen_ca.terminal_p, RL_c1.terminal) annotation (Line(
      points={{54,-80},{60,-80}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),        graphics={
        Text(
          extent={{-60,100},{60,80}},
          textColor={0,0,0},
          textString="Three phases, balanced (Y and D connection) "),
        Text(
          extent={{-100,10},{-4,-10}},
          textColor={0,0,0},
          textString="Three phases, balanced (Y connection) "),
        Text(
          extent={{4,10},{100,-10}},
          textColor={0,0,0},
          textString="Three phases, balanced (D connection) ")}), Documentation(
        revisions="<html>
<ul>
<li>
September 22, 2014 by Marco Bonvini:<br/>
Added documentation and revised the example.
</li>
</ul>
</html>", info="<html>
<p>
This model illustrates the use of the impedance models and how the three-phase balanced model
can reproduce the same results obtained using three separate one phase circuits.
</p>
</html>"),
    experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/Examples/ThreePhases.mos"
        "Simulate and plot"));
end ThreePhases;
