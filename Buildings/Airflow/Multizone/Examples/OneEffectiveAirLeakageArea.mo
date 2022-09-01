within Buildings.Airflow.Multizone.Examples;
model OneEffectiveAirLeakageArea "Model with an effective air leakage area"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;

  Buildings.Fluid.MixingVolumes.MixingVolume volA(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01) "Control volume"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volB(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    nPorts=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01) "Control volume"
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow rate boundary condition"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.Sine heaFloBou(f=1/3600)
    "Signal for heat flow rate boundary condition"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Math.Gain gai(k=100)
    "Gain for heat flow rate boundary condition"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Airflow.Multizone.EffectiveAirLeakageArea cra(redeclare package
      Medium = Medium, L=20E-4)
    "Crack model, parameterized with effective leakage area"
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true) "Prescribed mass flow rate boundary condition"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Sources.Ramp ramSou(
    duration=3600,
    height=0.01,
    offset=0,
    startTime=1800)
    "Ramp signal for prescribed mass flow rate boundary condition"
                    annotation (Placement(transformation(extent={{-80,-32},{-60,
            -12}})));
equation
  connect(sou.ports[1], volA.ports[1]) annotation (Line(
      points={{5.55112e-16,-30},{28,-30},{28,-20},{28,-20}},
      color={0,127,255}));
  connect(ramSou.y, sou.m_flow_in) annotation (Line(
      points={{-59,-22},{-22,-22}},
      color={0,0,127}));
  connect(volB.ports[1], cra.port_b) annotation (Line(
      points={{80,20},{80,-30},{70,-30}},
      color={0,127,255}));
  connect(volA.ports[2], cra.port_a) annotation (Line(
      points={{32,-20},{32,-30},{50,-30}},
      color={0,127,255}));
  connect(preHeaFlo.port, volB.heatPort) annotation (Line(
      points={{20,30},{70,30}},
      color={191,0,0}));
  connect(gai.y, preHeaFlo.Q_flow)
    annotation (Line(points={{-19,30},{-5.55112e-16,30}}, color={0,0,127}));
  connect(gai.u, heaFloBou.y)
    annotation (Line(points={{-42,30},{-59,30}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/OneEffectiveAirLeakageArea.mos"
        "Simulate and plot"),
        experiment(
      StopTime=7200,
      Tolerance=1e-08),
    Documentation(info="<html>
<p>
This model consists of a model for an effective air leakage area
that is connected to two air volumes.
Air flows due to the addition of air to the volume <code>volA</code>
and because heat is exchanged with <code>volB</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2021 by Michael Wetter:<br/>
Updated comments for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/515\">IBPSA, #515</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
November 10, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end OneEffectiveAirLeakageArea;
