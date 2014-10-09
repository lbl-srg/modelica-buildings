within Districts.Electrical.AC.OnePhase.Lines.Examples;
model ACSimpleGrid
  extends Modelica.Icons.Example;
  Network network
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Loads.InductiveLoadP load(P_nominal=2500, mode=Districts.Electrical.Types.Assumption.VariableZ_P_input)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Sources.FixedVoltage source(
    f=50,
    V=220,
    Phi=0.26179938779915) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,10})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=5000,
    duration=2,
    offset=-2000,
    startTime=0.5)
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
equation
  connect(load.terminal, network.terminal[2]) annotation (Line(
      points={{20,30},{10,30},{10,10},{0,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(source.terminal, network.terminal[1]) annotation (Line(
      points={{20,10},{4.44089e-16,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ramp.y, load.Pow) annotation (Line(
      points={{59,30},{40,30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end ACSimpleGrid;
