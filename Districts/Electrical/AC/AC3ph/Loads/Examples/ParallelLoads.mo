within Districts.Electrical.AC.AC3ph.Loads.Examples;
model ParallelLoads
  extends Modelica.Icons.Example;
  Sources.FixedVoltage V(
    f=50,
    V=380,
    Phi=0)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  LoadR R(P_nominal=6000)
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  LoadRL RL(
    mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state,
    P_nominal=5000,
    pf=0.8)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.Ramp load(duration=0.5, startTime=0.2)
    annotation (Placement(transformation(extent={{60,-24},{40,-4}})));
  LoadRL varRL(
    mode=Districts.Electrical.Types.Assumption.VariableZ_y_input,
    P_nominal=8000,
    pf=0.9)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  LoadRC varRC(
    mode=Districts.Electrical.Types.Assumption.VariableZ_y_input,
    P_nominal=10000,
    pf=0.8)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  LoadRL dynRL(
    mode=Districts.Electrical.Types.Assumption.FixedZ_dynamic,
    P_nominal=2000,
    V_nominal=380)
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
equation
  connect(V.terminal, R.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,60},{-20,60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, RL.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,30},{-20,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, varRL.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-20,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, varRC.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,-30},{-20,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load.y, varRL.y) annotation (Line(
      points={{39,-14},{20,-14},{20,6.66134e-16},{4.44089e-16,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(load.y, varRC.y) annotation (Line(
      points={{39,-14},{20,-14},{20,-30},{4.44089e-16,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(V.terminal, dynRL.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,-60},{-20,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent=
            {{-100,-100},{100,100}}), graphics));
end ParallelLoads;
