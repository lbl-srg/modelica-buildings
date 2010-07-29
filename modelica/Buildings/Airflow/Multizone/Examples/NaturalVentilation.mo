within Buildings.Airflow.Multizone.Examples;
model NaturalVentilation

  package Medium = Buildings.Media.IdealGases.SimpleAir;

  Buildings.Fluid.MixingVolumes.MixingVolume volA(
    redeclare package Medium = Medium,
    V=2.5*10*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 18,
    use_HeatTransfer=true,
    nPorts=2)
    annotation (Placement(transformation(extent={{0,-20},{20,0}}, rotation=0)));

  Buildings.Airflow.Multizone.Orifice oriOutBot(
    redeclare package Medium = Medium,
    A=0.1,
    m=0.5,
    dp_turbulent=0.1) annotation (Placement(transformation(extent={{38,-30},{58,
            -10}}, rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colOut(
    redeclare package Medium = Medium,
    h=3,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{89,10},{109,30}}, rotation=0)));
  Buildings.Airflow.Multizone.Orifice oriOutTop(
    redeclare package Medium = Medium,
    A=0.1,
    m=0.5,
    dp_turbulent=0.1) annotation (Placement(transformation(extent={{41,40},{61,
            60}}, rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colRooTop(
    redeclare package Medium = Medium,
    h=3,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{-23,10},{-3,30}},rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volOut(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=1E10,
    T_start=273.15 + 20,
    nPorts=2) annotation (Placement(transformation(extent={{75,-20},{95,0}},
          rotation=0)));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{-49,-20},{-29,0}}, rotation=0)));
  Modelica.Blocks.Sources.Step q_flow(
    height=-100,
    offset=100,
    startTime=3600) annotation (Placement(transformation(extent={{-84,-20},{-64,
            0}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
equation
  connect(q_flow.y, preHeaFlo.Q_flow)
    annotation (Line(points={{-63,-10},{-49,-10}}, color={0,0,255}));
  connect(oriOutBot.port_b, volOut.ports[1]) annotation (Line(
      points={{58,-20},{83,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preHeaFlo.port, volA.heatPort) annotation (Line(
      points={{-29,-10},{-5.55112e-16,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(volA.ports[1], oriOutBot.port_a) annotation (Line(
      points={{8,-20},{38,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{200,
            100}}), graphics),
    Commands(file="NaturalVentilation.mos" "run"),
    Diagram);
  connect(volA.ports[2], colRooTop.port_b) annotation (Line(
      points={{12,-20},{-14,-20},{-14,10},{-13,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colRooTop.port_a, oriOutTop.port_a) annotation (Line(
      points={{-13,30},{-14,30},{-14,50},{41,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volOut.ports[2], colOut.port_b) annotation (Line(
      points={{87,-20},{99,-20},{99,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOut.port_a, oriOutTop.port_b) annotation (Line(
      points={{99,30},{100,30},{100,50},{61,50}},
      color={0,127,255},
      smooth=Smooth.None));
end NaturalVentilation;
