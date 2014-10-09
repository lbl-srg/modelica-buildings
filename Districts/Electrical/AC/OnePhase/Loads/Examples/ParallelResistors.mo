within Districts.Electrical.AC.OnePhase.Loads.Examples;
model ParallelResistors
  "Example that illustrates the use of the load models at constant voltage"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.AC.OnePhase.Sources.FixedVoltage
                                                     source(f=50, V=220)
    "Voltage source"        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,10})));
  Modelica.Blocks.Sources.Ramp load(duration=0.5, startTime=0.2,
    height=2000,
    offset=-1000)
    annotation (Placement(transformation(extent={{40,0},{20,20}})));
  Districts.Electrical.AC.OnePhase.Loads.ResistiveLoadP
                       R(
    P_nominal=1e3,
    mode=Districts.Electrical.Types.Assumption.VariableZ_P_input,
    V_nominal=220) "Resistive load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-22,10})));
  Districts.Electrical.AC.OnePhase.Loads.ResistiveLoadP
                       R1(
    P_nominal=1e3,
    mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state,
    V_nominal=220) "Resistive load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-22,-10})));
equation
  connect(source.terminal, R.terminal) annotation (Line(
      points={{-60,10},{-32,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load.y, R.Pow) annotation (Line(
      points={{19,10},{-12,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(source.terminal, R1.terminal) annotation (Line(
      points={{-60,10},{-46,10},{-46,-10},{-32,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
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
January 3, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/Electrical/AC/Loads/Examples/ParallelLoads.mos"
        "Simulate and plot"));
end ParallelResistors;
