within Buildings.Electrical.AC.OnePhase.Loads.Examples;
model ParallelLoads
  "Example that illustrates the use of the load models at constant voltage"
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Loads.Inductive varRL(
    mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    P_nominal=-1e3,
    linearized=false) "Variable inductor and resistor"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,50})));
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage source "Voltage source"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,10})));
  Modelica.Blocks.Sources.Ramp load_y(duration=0.5, startTime=0.2)
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  Buildings.Electrical.AC.OnePhase.Loads.Inductive RL(
    P_nominal=-1e3,
    linearized=false) "Constant inductor and resistor"
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,30})));
  Buildings.Electrical.AC.OnePhase.Loads.Capacitive varRC(mode=Buildings.Electrical.Types.Assumption.VariableZ_y_input,
      P_nominal=-1e3,
    linearized=false) "Variable conductor and resistor"     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,10})));
  Buildings.Electrical.AC.OnePhase.Loads.Capacitive RC(mode=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
      P_nominal=-1e3,
    linearized=false) "Constant conductor and resistor"     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-10})));
  Buildings.Electrical.AC.OnePhase.Loads.Resistive R(
    P_nominal=-1e3,
    mode=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
    linearized=false) "Resistive load"
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-30})));
  Modelica.Blocks.Sources.Ramp load_P(
    startTime=0.2,
    duration=0.5,
    height=-2000,
    offset=1000)
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

The inductive load <code>varRL</code> and the capacitive load <code>varRC</code>
have a variable load specified by the inputs <code>Pow</code> and <code>y</code>
respectively.

All the loads have a nominal power of 1kW, and <code>varRL</code> is the only one
that at <i>t=0</i> produces power 1kW and as the time increases it start to 
consume up to 1kW.

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
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Loads/Examples/ParallelLoads.mos"
        "Simulate and plot"),
    __Dymola_experimentSetupOutput);
end ParallelLoads;
