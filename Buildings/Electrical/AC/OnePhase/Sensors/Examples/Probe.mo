within Buildings.Electrical.AC.OnePhase.Sensors.Examples;
model Probe "Example model for a probe"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Loads.Capacitive loaRC(
    V_nominal=120,
    P_nominal=-100,
    mode=Buildings.Electrical.Types.Assumption.FixedZ_steady_state)
    "Constant load"
    annotation (Placement(transformation(extent={{8,0},{28,20}})));
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage sou(V=120)
    "Voltage source"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Electrical.AC.OnePhase.Lines.TwoPortResistance res1(R=0.05)
    annotation (Placement(transformation(extent={{-26,0},{-6,20}})));
  Buildings.Electrical.AC.OnePhase.Sensors.Probe probe_source
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Electrical.AC.OnePhase.Sensors.Probe probe_loadRC
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Electrical.AC.OnePhase.Lines.TwoPortResistance res2(
                                                               R=0.05)
    annotation (Placement(transformation(extent={{-26,-70},{-6,-50}})));
  Buildings.Electrical.AC.OnePhase.Loads.Inductive loaRL(
    V_nominal=120,
    P_nominal=-100,
    mode=Buildings.Electrical.Types.Assumption.FixedZ_steady_state)
    "Constant load"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Electrical.AC.OnePhase.Sensors.Probe probe_loadRL
    annotation (Placement(transformation(extent={{-10,-28},{10,-8}})));
equation
  connect(sou.terminal, res1.terminal_n) annotation (Line(
      points={{-40,-20},{-40,10},{-26,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(res1.terminal_p, loaRC.terminal) annotation (Line(
      points={{-6,10},{8,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou.terminal, probe_source.term) annotation (Line(
      points={{-40,-20},{-40,31}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(loaRC.terminal, probe_loadRC.term) annotation (Line(
      points={{8,10},{6.66134e-16,10},{6.66134e-16,31}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou.terminal, res2.terminal_n) annotation (Line(
      points={{-40,-20},{-40,-60},{-26,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(res2.terminal_p, loaRL.terminal) annotation (Line(
      points={{-6,-60},{10,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(loaRL.terminal, probe_loadRL.term) annotation (Line(
      points={{10,-60},{6.66134e-16,-60},{6.66134e-16,-27}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=0.1, Tolerance=1e-05),
  Documentation(
  info="<html>
<p>
This example illustrates the use of the probe model.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Sensors/Examples/GeneralizedSensor.mos"
        "Simulate and plot"));
end Probe;
