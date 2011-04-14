within Buildings.Airflow.Multizone.Examples;
model OneEffectiveAirLeakageArea
  extends Modelica.Icons.Example; 
  package Medium = Buildings.Media.IdealGases.SimpleAir;

  Buildings.Fluid.MixingVolumes.MixingVolume volA(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(extent={{60,60},{80,80}}, rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volB(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    use_HeatTransfer=true,
    nPorts=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(extent={{28,-10},{48,10}}, rotation=0)));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{-8,-10},{12,10}}, rotation=0)));
  Modelica.Blocks.Sources.Sine Sine1(freqHz=1/3600) annotation (Placement(
        transformation(extent={{-80,-10},{-60,10}}, rotation=0)));
  Modelica.Blocks.Math.Gain Gain1(k=100) annotation (Placement(transformation(
          extent={{-42,-10},{-22,10}},rotation=0)));
  Buildings.Airflow.Multizone.EffectiveAirLeakageArea cra(redeclare package
      Medium = Medium, L=20E-4) annotation (Placement(transformation(extent={{
            10,-50},{30,-30}}, rotation=0)));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true) annotation (Placement(transformation(extent={{-20,40},{
            0,60}}, rotation=0)));
  Modelica.Blocks.Sources.Ramp ramSou(
    duration=3600,
    height=0.01,
    offset=0,
    startTime=1800) annotation (Placement(transformation(extent={{-80,48},{-60,
            68}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(sou.ports[1], volA.ports[1]) annotation (Line(
      points={{5.55112e-16,50},{68,50},{68,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ramSou.y, sou.m_flow_in) annotation (Line(
      points={{-59,58},{-20,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(volB.ports[1], cra.port_b) annotation (Line(
      points={{38,-10},{40,-10},{40,-40},{30,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volA.ports[2], cra.port_a) annotation (Line(
      points={{72,60},{72,-70},{0,-70},{0,-40},{10,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preHeaFlo.port, volB.heatPort) annotation (Line(
      points={{12,6.10623e-16},{20,6.10623e-16},{20,6.10623e-16},{28,
          6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Gain1.y, preHeaFlo.Q_flow) annotation (Line(
      points={{-21,6.10623e-16},{-15.5,6.10623e-16},{-15.5,6.66134e-16},{-8,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Gain1.u, Sine1.y) annotation (Line(
      points={{-44,6.66134e-16},{-52,6.66134e-16},{-52,6.10623e-16},{-59,
          6.10623e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="OneEffectiveAirLeakageArea.mos" "run"));
end OneEffectiveAirLeakageArea;
