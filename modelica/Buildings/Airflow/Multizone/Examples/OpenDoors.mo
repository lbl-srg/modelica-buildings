within Buildings.Airflow.Multizone.Examples;
model OpenDoors
  extends Modelica.Icons.Example; 
  package Medium = Buildings.Media.IdealGases.SimpleAir;

  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooAB(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    forceErrorControlOnFlow=true) "Discretized door" annotation (Placement(
        transformation(extent={{10,-28},{30,-8}}, rotation=0)));

  Buildings.Fluid.MixingVolumes.MixingVolume volA(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    nPorts=4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(extent={{-80,0},{-60,20}}, rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volB(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    use_HeatTransfer=true,
    nPorts=4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(extent={{40,40},{60,60}}, rotation=0)));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow PrescribedHeatFlow1
    annotation (Placement(transformation(extent={{4,40},{24,60}}, rotation=0)));
  Modelica.Blocks.Sources.Sine Sine1(freqHz=1/3600) annotation (Placement(
        transformation(extent={{-68,40},{-48,60}}, rotation=0)));
  Modelica.Blocks.Math.Gain Gain1(k=100) annotation (Placement(transformation(
          extent={{-28,40},{-8,60}}, rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volC(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    nPorts=4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(extent={{70,-40},{90,-20}}, rotation=0)));
  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooAC(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    forceErrorControlOnFlow=true) "Discretized door" annotation (Placement(
        transformation(extent={{10,-56},{30,-36}}, rotation=0)));
  Modelica.Blocks.Sources.Constant open(k=0) annotation (Placement(
        transformation(extent={{-60,-84},{-40,-64}}, rotation=0)));
  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooBC(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    forceErrorControlOnFlow=true) "Discretized door" annotation (Placement(
        transformation(extent={{10,-92},{30,-72}}, rotation=0)));
equation
  connect(Gain1.y, PrescribedHeatFlow1.Q_flow)
    annotation (Line(points={{-7,50},{4,50}}, color={0,0,255}));
  connect(Sine1.y, Gain1.u)
    annotation (Line(points={{-47,50},{-30,50}}, color={0,0,255}));
  connect(open.y, dooAB.y) annotation (Line(points={{-39,-74},{-34,-74},{-34,
          -18},{9,-18}}, color={0,0,255}));
  connect(open.y, dooAC.y) annotation (Line(points={{-39,-74},{-34,-74},{-34,
          -46},{9,-46}}, color={0,0,255}));
  connect(open.y, dooBC.y)
    annotation (Line(points={{-39,-74},{9,-74},{9,-82}}, color={0,0,255}));
  connect(PrescribedHeatFlow1.port, volB.heatPort) annotation (Line(
      points={{24,50},{40,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(volC.ports[1], dooAC.port_b1) annotation (Line(
      points={{77,-40},{30,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volC.ports[2], dooAC.port_a2) annotation (Line(
      points={{79,-40},{56,-40},{56,-52},{30,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volC.ports[3], dooBC.port_b1) annotation (Line(
      points={{81,-40},{56,-40},{56,-76},{30,-76}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volC.ports[4], dooBC.port_a2) annotation (Line(
      points={{83,-40},{56,-40},{56,-88},{30,-88}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volB.ports[1], dooAB.port_b1) annotation (Line(
      points={{47,40},{47,-10},{30,-10},{30,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volB.ports[2], dooAB.port_a2) annotation (Line(
      points={{49,40},{49,-22},{30,-22},{30,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volB.ports[3], dooBC.port_a1) annotation (Line(
      points={{51,40},{50,40},{50,2},{-20,2},{-20,-76},{10,-76}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volB.ports[4], dooBC.port_b2) annotation (Line(
      points={{53,40},{53,2},{-20,2},{-20,-88},{10,-88}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volA.ports[1], dooAC.port_b2) annotation (Line(
      points={{-73,-5.55112e-16},{-72.6667,-5.55112e-16},{-72,-52},{10,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volA.ports[2], dooAC.port_a1) annotation (Line(
      points={{-71,-5.55112e-16},{-71,-40},{10,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volA.ports[3], dooAB.port_b2) annotation (Line(
      points={{-69,-5.55112e-16},{-72,-5.55112e-16},{-72,-24},{10,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volA.ports[4], dooAB.port_a1) annotation (Line(
      points={{-67,-5.55112e-16},{-67,-12},{10,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Commands(file="OpenDoors.mos" "run"),
    Diagram);
end OpenDoors;
