within Districts.Electrical.AC.OnePhase.Sources.Examples;
model FixedSource
  extends Modelica.Icons.Example;
  FixedVoltage V(f=50, V=220,
    definiteReference=true)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Loads.ResistiveLoadP
                 R(P_nominal=200)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Loads.InductiveLoadP   RL(
    P_nominal=150,
    mode=Districts.Electrical.Types.Assumption.VariableZ_y_input)
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.Ramp load(duration=0.5, startTime=0.2)
    annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  Loads.CapacitiveLoadP   RC(P_nominal=200)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
equation
  connect(V.terminal, R.terminal)      annotation (Line(
      points={{-40,10},{-4.44089e-16,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RL.terminal, R.terminal) annotation (Line(
      points={{0,-10},{-20,-10},{-20,10},{-4.44089e-16,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RC.terminal, R.terminal) annotation (Line(
      points={{0,-30},{-20,-30},{-20,10},{-4.44089e-16,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RL.y, load.y) annotation (Line(
      points={{20,-10},{39,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end FixedSource;
