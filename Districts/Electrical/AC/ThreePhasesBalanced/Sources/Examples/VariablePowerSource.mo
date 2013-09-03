within Districts.Electrical.AC.ThreePhasesBalanced.Sources.Examples;
model VariablePowerSource
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine generation(
    amplitude=50,
    offset=200,
    startTime=1,
    freqHz=0.1)
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Generator gen(f=50, Phi=0.5235987755983)
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Grid grid(
    f=50,
    V=380,
    Phi=0)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Trapezoid load(
    rising=2,
    width=3,
    falling=3,
    period=10,
    startTime=1,
    amplitude=0.8,
    offset=0.2)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Loads.InductiveLoadP
               RL(mode=Districts.Electrical.Types.Assumption.VariableZ_y_input,
      P_nominal=3000)
    annotation (Placement(transformation(extent={{24,-10},{44,10}})));
equation
  connect(generation.y, gen.P) annotation (Line(
      points={{-67,0},{-58,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load.y, RL.y) annotation (Line(
      points={{59,0},{44,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RL.terminal, gen.terminal) annotation (Line(
      points={{24,0},{-38,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(RL.terminal, grid.terminal) annotation (Line(
      points={{24,0},{-10,0},{-10,40}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent=
            {{-100,-100},{100,100}}), graphics));
end VariablePowerSource;
