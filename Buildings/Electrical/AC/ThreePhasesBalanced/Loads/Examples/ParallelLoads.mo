within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.Examples;
model ParallelLoads "Example that illustrates the use of the load models"
  extends Modelica.Icons.Example;
  Sources.FixedVoltage E(f=60, V=480) "Voltage source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Resistive R(P_nominal=-2000, V_nominal=480) "Resistive load"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Inductive RL_pf(
    pf=0.8,
    P_nominal=-2000,
    use_pf_in=true,
    V_nominal=480) "Inductive load with variable power factor"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.Ramp load(              startTime=0.2, duration=0.3)
    "Power signal profile"
    annotation (Placement(transformation(extent={{60,-50},{40,-30}})));
  Inductive varRL_y(                                   P_nominal=-2000,
    V_nominal=480,
    mode=Buildings.Electrical.Types.Load.VariableZ_y_input)
    "Inductive load with y as input"
    annotation (Placement(transformation(extent={{-20,-36},{0,-16}})));
  Capacitive varRC_y(                                   P_nominal=-2000,
    V_nominal=480,
    mode=Buildings.Electrical.Types.Load.VariableZ_y_input)
    "Capacitive load with y as input"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Inductive varRL_P(pf=0.8,
    V_nominal=480,
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input)
    "Inductive load with P as input"
    annotation (Placement(transformation(extent={{-20,14},{0,34}})));
  Modelica.Blocks.Sources.Ramp pow(
    startTime=0.2,
    duration=0.3,
    height=4000,
    offset=-2000) "Power consumption profile"
    annotation (Placement(transformation(extent={{60,14},{40,34}})));
  Modelica.Blocks.Sources.Ramp pf(
    height=0.2,
    duration=0.2,
    offset=0.8,
    startTime=0.7) "Power factor profile"
    annotation (Placement(transformation(extent={{60,-20},{40,0}})));
equation
  connect(E.terminal, R.terminal) annotation (Line(
      points={{-60,4.44089e-16},{-40,4.44089e-16},{-40,50},{-20,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, RL_pf.terminal) annotation (Line(
      points={{-60,4.44089e-16},{-40,4.44089e-16},{-40,0},{-20,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, varRL_y.terminal) annotation (Line(
      points={{-60,4.44089e-16},{-40,4.44089e-16},{-40,-26},{-20,-26}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, varRC_y.terminal) annotation (Line(
      points={{-60,4.44089e-16},{-40,4.44089e-16},{-40,-50},{-20,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load.y, varRL_y.y) annotation (Line(
      points={{39,-40},{20,-40},{20,-26},{4.44089e-16,-26}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(load.y, varRC_y.y) annotation (Line(
      points={{39,-40},{20,-40},{20,-50},{4.44089e-16,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(E.terminal, varRL_P.terminal) annotation (Line(
      points={{-60,4.44089e-16},{-40,4.44089e-16},{-40,24},{-20,24}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(pow.y, varRL_P.Pow) annotation (Line(
      points={{39,24},{4.44089e-16,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pf.y, RL_pf.pf_in) annotation (Line(
      points={{39,-10},{30,-10},{30,6},{4.44089e-16,6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (    Documentation(revisions="<html>
<ul>
<li>
September 22, 2014 by Marco Bonvini:<br/>
Added documentation and revised the example.
</li>
</ul>
</html>", info="<html>
<p>
This model illustrates the use of the three-phase unbalanced load models.
</p>
</html>"),
    experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/Examples/ParallelLoads.mos"
        "Simulate and plot"));
end ParallelLoads;
