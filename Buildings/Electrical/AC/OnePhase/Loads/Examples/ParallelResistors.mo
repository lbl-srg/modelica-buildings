within Buildings.Electrical.AC.OnePhase.Loads.Examples;
model ParallelResistors
  "Example that illustrates the use of the load models at constant voltage"
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage
    source(f=60, V=120) "Voltage source"
                            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-70,10})));
  Modelica.Blocks.Sources.Ramp load(duration=0.5, startTime=0.2,
    height=2400,
    offset=-1200) "Power signal for load R"
    annotation (Placement(transformation(extent={{40,0},{20,20}})));
  Buildings.Electrical.AC.OnePhase.Loads.Resistive R(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    P_nominal=-1e3,
    V_nominal=120) "Variable resistive load"
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-22,10})));
  Buildings.Electrical.AC.OnePhase.Loads.Resistive R1(
    mode=Buildings.Electrical.Types.Load.FixedZ_steady_state, P_nominal=-1.2e3,
    V_nominal=120) "Fixed resistive load"
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
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
    experiment(StopTime=1.0, Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model compares two resistive loads. Model <code>R</code> consumes or produces
a variable amount of power, while model <code>R1</code> consumes a fixed power.
</p>
<p>
At time <i>t=0</i> <code>R</code> and <code>R1</code> consumes the same amount of power
while at <i>t=1</i> <code>R</code> produces the same power consumed by <code>R1</code>.
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
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Loads/Examples/ParallelResistors.mos"
        "Simulate and plot"));
end ParallelResistors;
