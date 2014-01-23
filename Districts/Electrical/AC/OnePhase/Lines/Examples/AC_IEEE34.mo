within Districts.Electrical.AC.OnePhase.Lines.Examples;
model AC_IEEE34
  extends Modelica.Icons.Example;
  Network network(redeclare
      Districts.Electrical.Transmission.Grids.IEEE_34_AL120 grid)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Loads.InductiveLoadP load[33](each P_nominal=2500, each mode=Districts.Electrical.Types.Assumption.VariableZ_P_input,
    each linear=false)
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
  connect(source.terminal, network.terminal[1]) annotation (Line(
      points={{20,10},{4.44089e-16,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(network.terminal[2:34], load[1:33].terminal) annotation (Line(
      points={{0,10},{10,10},{10,30},{20,30}},
      color={0,120,120},
      smooth=Smooth.None));
  for i in 1:33 loop
    connect(ramp.y, load[i].Pow) annotation (Line(
      points={{59,30},{40,30}},
      color={0,0,127},
      smooth=Smooth.None));
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end AC_IEEE34;
