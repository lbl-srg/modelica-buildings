within Buildings.Electrical.AC.OnePhase.Loads.Examples;
model DynamicLoads "Example that illustrates the use of dynamic loads"
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage source(
    f=60,
    V=120) "Voltage source" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-70,10})));
  Buildings.Electrical.AC.OnePhase.Loads.Capacitive dynRC(
    pf=0.8,
    mode=Buildings.Electrical.Types.Load.FixedZ_dynamic,
    P_nominal=-1200,
    V_nominal=120) "Dynamic RC load"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Electrical.AC.OnePhase.Lines.TwoPortResistance line(R=0.1)
    "Line resistance"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Electrical.AC.OnePhase.Loads.Inductive dynRL(
    pf=0.8,
    mode=Buildings.Electrical.Types.Load.FixedZ_dynamic,
    P_nominal=-1200,
    V_nominal=120) "Dynamic RL load"
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
    Documentation(info="<html>
<p>
This model compares two dynamic load models that use the dynamic
phasors.
</p>
<p>
The loads at nominal conditions should consume an active power equal
to <i>1.2</i> kW. Because of the line resistance the voltage at the load is
attenuated and they consume less power.
</p>
<p>
As expected the real part of the current vector drawn by the loads are
the same while the complex parts have opposite signs.
</p>
</html>",
    revisions="<html>
<ul>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
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
