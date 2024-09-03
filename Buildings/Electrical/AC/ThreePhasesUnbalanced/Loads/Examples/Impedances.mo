within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Examples;
model Impedances
  "This model tests three-phase unbalanced impedances with and without neutral cable"
  extends Modelica.Icons.Example;
  Sources.FixedVoltage_N sou_N(definiteReference=true,
    f=60,
    V=480) "Voltage source with neutral cable"
    annotation (Placement(transformation(extent={{-94,-50},{-74,-30}})));
  Sensors.GeneralizedSensor_N sen_N "Power sensor with neutral cable"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Impedance_N imp_N(
    plugPhase2=false,
    use_R_in=true,
    RMin=1,
    RMax=10,
    use_L_in=true,
    LMin=0.1,
    LMax=1) "Impedance with neutral cable"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Sources.FixedVoltage sou(definiteReference=true,
    f=60,
    V=480) "Voltage source without neutral cable"
    annotation (Placement(transformation(extent={{-94,30},{-74,50}})));
  Sensors.GeneralizedSensor sen "Power sensor without neutral cable"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Impedance imp(
    plugPhase2=false,
    use_R_in=true,
    RMin=1,
    RMax=10,
    use_L_in=true,
    LMin=0.1,
    LMax=1) "Impedance without neutral cable"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Sources.Ramp var_RL(
    duration=0.5,
    startTime=0.25,
    height=1,
    offset=0) "Power signal for loads on phase 1"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
equation

  connect(sou.terminal, sen.terminal_n) annotation (Line(
      points={{-74,40},{-60,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen.terminal_p, imp.terminal) annotation (Line(
      points={{-40,40},{0,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(var_RL.y, imp.y_R) annotation (Line(
      points={{39,0},{36,0},{36,70},{6,70},{6,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(var_RL.y, imp.y_L) annotation (Line(
      points={{39,6.66134e-16},{26,6.66134e-16},{26,62},{14,62},{14,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(var_RL.y, imp_N.y_R) annotation (Line(
      points={{39,0},{6,0},{6,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(var_RL.y, imp_N.y_L) annotation (Line(
      points={{39,0},{14,0},{14,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou_N.terminal, sen_N.terminal_n) annotation (Line(
      points={{-74,-40},{-60,-40}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(sen_N.terminal_p, imp_N.terminal) annotation (Line(
      points={{-40,-40},{0,-40}},
      color={127,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics={Text(
          extent={{-80,80},{0,74}},
          textColor={0,0,0},
          pattern=LinePattern.Dash,
          textString="Without neutral"), Text(
          extent={{-80,-10},{0,-16}},
          textColor={0,0,0},
          pattern=LinePattern.Dash,
          textString="With neutral")}),        Documentation(info="<html>
<p>
This example model shows how to use three-phase unbalanced impedances with and without neutral cable.
</p>
<p>
This model contains two identical inductive impedances with and without neutral cable.
The impedances have inputs that allow to change the value of their resistances and inductances
externally. The values start to change from their minimum to their maximum values at time
<i>t = 0.25 s</i>.
</p>
<p>
The unbalanced impedance that has the neutral cable
<code>sen_N.I[4]</code> is able to measure the current in the neutral. that is
the current necessary to satisfy the Kirchoff Current Law (KCL)
such that the algebraic sum of the phase current in each impedance is equal to zero.
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Created model from previus version and added documentation.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Loads/Examples/Impedances.mos"
        "Simulate and plot"));
end Impedances;
