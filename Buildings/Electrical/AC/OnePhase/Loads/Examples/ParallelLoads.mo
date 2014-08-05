within Buildings.Electrical.AC.OnePhase.Loads.Examples;
model ParallelLoads
  "Example that illustrates the use of the load models at constant voltage"
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Loads.InductiveLoadP varRL(mode=
        Buildings.Electrical.Types.Assumption.VariableZ_P_input, P_nominal=-1e3)
    "Variable inductor and resistor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,50})));
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage
                                                     source(f=60, V=110)
    "Voltage source"        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,10})));
  Modelica.Blocks.Sources.Ramp load_y(duration=0.5, startTime=0.2)
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  Buildings.Electrical.AC.OnePhase.Loads.InductiveLoadP
                               RL(P_nominal=-1e3)
    "Constant inductor and resistor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,30})));
  Buildings.Electrical.AC.OnePhase.Loads.CapacitiveLoadP varRC(              mode=
        Buildings.Electrical.Types.Assumption.VariableZ_y_input, P_nominal=-1e3)
    "Variable conductor and resistor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,10})));
  Buildings.Electrical.AC.OnePhase.Loads.CapacitiveLoadP
                                RC(               mode=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
      P_nominal=-1e3) "Constant conductor and resistor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-10})));
  Buildings.Electrical.AC.OnePhase.Loads.ResistiveLoadP
                       R(P_nominal=-1e3, linear=true,
    mode=Buildings.Electrical.Types.Assumption.FixedZ_steady_state)
    "Resistive load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-30})));
  Modelica.Blocks.Sources.Ramp load_P(
    startTime=0.2,
    height=2000,
    duration=0.5,
    offset=-1000)
    annotation (Placement(transformation(extent={{60,40},{40,60}})));
equation
  connect(source.terminal, varRL.terminal)  annotation (Line(
      points={{-60,10},{-30,10},{-30,50},{0,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(source.terminal, RL.terminal)  annotation (Line(
      points={{-60,10},{-30,10},{-30,30},{0,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(source.terminal, varRC.terminal)  annotation (Line(
      points={{-60,10},{0,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(source.terminal, R.terminal)
                                      annotation (Line(
      points={{-60,10},{-30,10},{-30,-30},{0,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RC.terminal, R.terminal) annotation (Line(
      points={{0,-10},{-30,-10},{-30,-30},{-5.55112e-16,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load_y.y, varRC.y)
                           annotation (Line(
      points={{39,10},{20,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load_P.y, varRL.Pow)
                              annotation (Line(
      points={{39,50},{20,50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    experiment(StopTime=1.0, Tolerance=1e-06),
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
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Loads/Examples/ParallelLoads.mos"
        "Simulate and plot"),
    __Dymola_experimentSetupOutput);
end ParallelLoads;
