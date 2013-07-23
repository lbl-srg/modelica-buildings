within Districts.Electrical.AC.AC1ph.Loads.Examples;
model ParallelInductor
  "Example that illustrates the use of the load models at constant voltage"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.AC.AC1ph.Sources.FixedVoltage source(f=50, V=220)
    "Voltage source"        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,10})));
  Districts.Electrical.AC.AC1ph.Loads.LoadRL dynRL(
    P_nominal=2000,
    pf=0.8,
    V_nominal=220,
    mode=Districts.Electrical.Types.Assumption.FixedZ_dynamic)
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  Districts.Electrical.AC.AC1ph.Loads.LoadRC dynRC(
    P_nominal=2000,
    pf=0.8,
    V_nominal=220,
    mode=Districts.Electrical.Types.Assumption.FixedZ_dynamic)
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
equation
  connect(dynRL.terminal, source.terminal)          annotation (Line(
      points={{-30,10},{-60,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(source.terminal, dynRC.terminal)          annotation (Line(
      points={{-60,10},{-44,10},{-44,-10},{-30,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                    graphics),
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
January 3, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "Resources/Scripts/Dymola/Electrical/AC/Loads/Examples/ParallelLoads.mos"
        "Simulate and plot"));
end ParallelInductor;
