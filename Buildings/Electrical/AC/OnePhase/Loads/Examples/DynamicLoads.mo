within Buildings.Electrical.AC.OnePhase.Loads.Examples;
model DynamicLoads "Example that illustrates the use of dynamic loads"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage
                                                     source(f=50, V=220)
    "Voltage source"        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,10})));
  Buildings.Electrical.AC.OnePhase.Loads.CapacitiveLoadP
                                             dynRC(
    pf=0.8,
    V_nominal=220,
    P_nominal=-2000,
    mode=Buildings.Electrical.Types.Assumption.FixedZ_dynamic)
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Electrical.AC.OnePhase.Lines.TwoPortResistance line(R=0.1)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Electrical.AC.OnePhase.Loads.InductiveLoadP
                                             dynRL(
    pf=0.8,
    V_nominal=220,
    P_nominal=-2000,
    mode=Buildings.Electrical.Types.Assumption.FixedZ_dynamic)
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
equation
  connect(source.terminal, line.terminal_n) annotation (Line(
      points={{-60,10},{-40,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line.terminal_p, dynRC.terminal) annotation (Line(
      points={{-20,10},{-10,10},{-10,-10},{-4.44089e-16,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(dynRL.terminal, line.terminal_p) annotation (Line(
      points={{-4.44089e-16,20},{-10,20},{-10,10},{-20,10}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This model illustrates the use of the load models.
The first two lines are inductive loads, followed by two capacitive loads and a resistive load.
At time equal to <i>1</i> second, all loads consume the same actual power as specified by the
nominal condition. Between <i>t = 0...1</i>, the power is increased from zero to one.
Consequently, the power factor is highest at <i>t=0</i> but decreases to its nominal value
at <i>t=1</i> second.
</p>
</html>",
    revisions="<html>
<ul>
<li>
January 3, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Loads/Examples/DynamicLoads.mos"
        "Simulate and plot"));
end DynamicLoads;
