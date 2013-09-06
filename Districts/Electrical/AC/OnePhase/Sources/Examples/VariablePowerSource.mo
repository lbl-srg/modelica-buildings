within Districts.Electrical.AC.OnePhase.Sources.Examples;
model VariablePowerSource
  extends Modelica.Icons.Example;
  Generator generator(      Phi(displayUnit="deg") = 0.26179938779915, f=50)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Sources.Sine generation(
    offset=200,
    startTime=1,
    amplitude=100,
    freqHz=0.05)
    annotation (Placement(transformation(extent={{-92,-10},{-72,10}})));
  Loads.InductiveLoadP   R(P_nominal=300, mode=Districts.Electrical.Types.Assumption.VariableZ_y_input)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Grid grid(
    f=50,
    Phi=0,
    V=220) annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Trapezoid load(
    rising=2,
    width=3,
    falling=3,
    period=10,
    startTime=1,
    amplitude=0.8,
    offset=0.2)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
equation
  connect(generation.y, generator.P) annotation (Line(
      points={{-71,0},{-50,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(generator.terminal, R.terminal) annotation (Line(
      points={{-30,0},{20,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(grid.terminal, R.terminal) annotation (Line(
      points={{-10,40},{-10,0},{20,0},{20,5.55112e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load.y, R.y) annotation (Line(
      points={{59,0},{40,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10, Tolerance=1e-05),
    __Dymola_experimentSetupOutput);
end VariablePowerSource;
