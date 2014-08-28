within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.Examples;
model ParallelLoads
  extends Modelica.Icons.Example;
  Sources.FixedVoltage E "Voltage source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Resistive R(P_nominal=-6000)
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Inductive RL(
    mode=Types.Assumption.FixedZ_steady_state,
    pf=0.8,
    P_nominal=-5000)
    annotation (Placement(transformation(extent={{-20,16},{0,36}})));
  Modelica.Blocks.Sources.Ramp load(duration=0.5, startTime=0.2)
    annotation (Placement(transformation(extent={{60,-30},{40,-10}})));
  Inductive varRL(
    mode=Types.Assumption.VariableZ_y_input,
    pf=0.9,
    P_nominal=-8000)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Capacitive varRC(
    mode=Types.Assumption.VariableZ_y_input,
    pf=0.8,
    P_nominal=-10000)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Inductive dynRL(
    mode=Types.Assumption.FixedZ_dynamic, P_nominal=-2000)
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Inductive Load(
    pf=0.8,
    mode=Types.Assumption.VariableZ_P_input,
    P_nominal=-5000)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Ramp pow(
    duration=0.5,
    startTime=0.2,
    height=5000,
    offset=-2500)
    annotation (Placement(transformation(extent={{60,40},{40,60}})));
equation
  connect(E.terminal, R.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,80},{-20,80}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, RL.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,26},{-20,26}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, varRL.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-20,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, varRC.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,-30},{-20,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load.y, varRL.y) annotation (Line(
      points={{39,-20},{20,-20},{20,8.88178e-16},{4.44089e-16,8.88178e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(load.y, varRC.y) annotation (Line(
      points={{39,-20},{20,-20},{20,-30},{4.44089e-16,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(E.terminal, dynRL.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,-60},{-20,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, Load.terminal) annotation (Line(
      points={{-60,0},{-40,0},{-40,50},{-20,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(pow.y, Load.Pow) annotation (Line(
      points={{39,50},{4.44089e-16,50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),        graphics));
end ParallelLoads;
