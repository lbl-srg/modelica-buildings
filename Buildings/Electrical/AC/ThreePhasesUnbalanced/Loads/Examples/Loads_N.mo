within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Examples;
model Loads_N
  "This model tests unbalanced load models with neutral cable connection"
  extends Modelica.Icons.Example;
  Sources.FixedVoltage_N
                       sou(definiteReference=true,
    f=60,
    V=480) "Voltage source"
    annotation (Placement(transformation(extent={{-94,-10},{-74,10}})));
  Modelica.Blocks.Sources.Ramp ph_1(
    offset=-1000,
    duration=0.5,
    startTime=0.25,
    height=-500) "Power signal for loads on phase 1"
               annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Modelica.Blocks.Sources.Constant ph_23(k=-1000)
    "Power signal for loads on phase 2 and 3"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Resistive_N loaR_N(mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    V_nominal=480,
    P_nominal=0) "Resistive load with neutral cable"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Inductive_N loaRL_N(mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      pf=0.9,
    V_nominal=480,
    P_nominal=0) "Inductive load with neutral cable"
    annotation (Placement(transformation(extent={{-8,-40},{12,-20}})));
  Capacitive_N loaRC_N(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    pf=0.7,
    V_nominal=480,
    P_nominal=0) "Capacitive load with neutral cable"
    annotation (Placement(transformation(extent={{-8,-80},{12,-60}})));
  Sensors.GeneralizedSensor_N
                            sen "Power sensor with neutral cable"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(ph_1.y, loaR_N.Pow1) annotation (Line(
      points={{59,40},{54,40},{54,6},{12,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_23.y, loaR_N.Pow3) annotation (Line(
      points={{79,4.44089e-16},{68,4.44089e-16},{68,-6},{12,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_23.y, loaR_N.Pow2) annotation (Line(
      points={{79,4.44089e-16},{68,4.44089e-16},{68,6.66134e-16},{12,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(ph_1.y, loaRL_N.Pow1) annotation (Line(
      points={{59,40},{54,40},{54,-24},{12,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_1.y, loaRC_N.Pow1) annotation (Line(
      points={{59,40},{54,40},{54,-64},{12,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_23.y, loaRL_N.Pow2) annotation (Line(
      points={{79,4.44089e-16},{68,4.44089e-16},{68,-30},{12,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_23.y, loaRL_N.Pow3) annotation (Line(
      points={{79,4.44089e-16},{68,4.44089e-16},{68,-36},{12,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_23.y, loaRC_N.Pow2) annotation (Line(
      points={{79,4.44089e-16},{68,4.44089e-16},{68,-70},{12,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_23.y, loaRC_N.Pow3) annotation (Line(
      points={{79,4.44089e-16},{68,4.44089e-16},{68,-76},{12,-76}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(sou.terminal, sen.terminal_n) annotation (Line(
      points={{-74,0},{-60,0}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(sen.terminal_p, loaR_N.terminal) annotation (Line(
      points={{-40,0},{-8,0}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(sen.terminal_p, loaRL_N.terminal) annotation (Line(
      points={{-40,0},{-26,0},{-26,-30},{-8,-30}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(sen.terminal_p, loaRC_N.terminal) annotation (Line(
      points={{-40,0},{-26,0},{-26,-70},{-8,-70}},
      color={127,0,127},
      smooth=Smooth.None));
  annotation ( Documentation(info="<html>
<p>
This example model shows how three-phase unbalanced loads with the neutral cable can be used.
</p>
<p>
This model contains three different loads of different type. They start in a balanced configuration
and at time <i>t = 0.25 s</i> the loads on the first phase start to increase their power consumption.
</p>
<p>
When the loads start to be unbalanced the sensors starts to measure a current in the neutral cable
<code>sen.I[4]</code>. This is the current necessary to satisfy the Kirchoff Current Law (KCL)
such that the algebraic sum of the phase current in each load is equal to zero.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Loads/Examples/unbalancedLoads.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Created model from previus version and added documentation.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-05, StopTime=1.0),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Loads/Examples/Loads_N.mos"
        "Simulate and plot"));
end Loads_N;
