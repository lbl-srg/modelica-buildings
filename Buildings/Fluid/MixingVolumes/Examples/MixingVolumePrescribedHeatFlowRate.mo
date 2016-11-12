within Buildings.Fluid.MixingVolumes.Examples;
model MixingVolumePrescribedHeatFlowRate
  "Test model for heat transfer to volume"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Air;
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo
    "Heat flow sensor"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=313.15) "Flow source and sink"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Fluid.Sources.FixedBoundary bou(
    redeclare package Medium = Medium,
    nPorts=1,
    T=303.15) "Boundary condition"                         annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-10})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    V=1,
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=0.01,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=true,
    prescribedHeatFlowRate=true)
              annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    offset=1,
    height=-2)
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));

  Modelica.Blocks.Math.Gain gain(k=0.01)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
equation
  connect(sou.ports[1], vol.ports[1])         annotation (Line(
      points={{0,-10},{38,-10},{38,20}},
      color={0,127,255}));
  connect(ramp.y, gain.u) annotation (Line(
      points={{-69,-10},{-62,-10}},
      color={0,0,127}));
  connect(gain.y, sou.m_flow_in) annotation (Line(
      points={{-39,-10},{-31.5,-10},{-31.5,-2},{-20,-2}},
      color={0,0,127}));
  connect(vol.ports[2], bou.ports[1]) annotation (Line(
      points={{42,20},{43,20},{43,-10},{60,-10}},
      color={0,127,255}));
  connect(preHeaFlo.port, heaFlo.port_a) annotation (Line(
      points={{-20,30},{0,30}},
      color={191,0,0}));
  connect(preHeaFlo.Q_flow, const.y) annotation (Line(
      points={{-40,30},{-59,30}},
      color={0,0,127}));
  connect(heaFlo.port_b, vol.heatPort) annotation (Line(
      points={{20,30},{30,30}},
      color={191,0,0}));
  annotation (Documentation(
        info="<html>
<p>
This model demonstrates the use of the mixing volume with a prescribed heat flow rate.
The mixing volume is configured as a steady-state model.
The heat flow rate is set to a very small value. This model is used to test
convergence for the case the prescribed heat flow rate should be zero,
but due to numerical solutions, it may have a small error that causes the signal to be
non-zero.
</p>
</html>", revisions="<html>
<ul>
<li>
October 12, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Examples/MixingVolumePrescribedHeatFlowRate.mos"
        "Simulate and plot"));
end MixingVolumePrescribedHeatFlowRate;
