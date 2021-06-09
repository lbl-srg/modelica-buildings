within Buildings.Fluid.MixingVolumes.Validation.BaseClasses;
partial model MixingVolumeReverseFlow
  "Test model for mixing volume with flow reversal"
 extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Air "Medium model";

  constant Boolean prescribedHeatFlowRate = false
    "Flag that affects what steady state balance is used in the volume";
  parameter Modelica.SIunits.Pressure dp_nominal = 10 "Nominal pressure drop";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 2.0
    "Nominal mass flow rate";

  Modelica.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=m_flow_nominal,
    use_m_flow_in=true,
    T=313.15) "Flow source and sink"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    T=303.15,
    nPorts=2) "Boundary condition"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-20})));
  replaceable Buildings.Fluid.MixingVolumes.MixingVolume volDyn
    constrainedby Buildings.Fluid.MixingVolumes.MixingVolume(
        redeclare package Medium = Medium,
        V=1,
        nPorts=2,
        m_flow_nominal=m_flow_nominal,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Volume with dynamic balance"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));

  replaceable Buildings.Fluid.MixingVolumes.MixingVolume volSte
    constrainedby Buildings.Fluid.MixingVolumes.MixingVolume(
        redeclare package Medium = Medium,
        final prescribedHeatFlowRate = prescribedHeatFlowRate,
        V=1,
        nPorts=2,
        m_flow_nominal=m_flow_nominal,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Volume with steady-state balance"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));

  Modelica.Blocks.Math.Gain gain
    "Gain to add heat, moisture or trace substance flow rate"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=m_flow_nominal,
    use_m_flow_in=true,
    T=313.15) "Flow source and sink"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    height=-2*m_flow_nominal,
    duration=10,
    offset=m_flow_nominal) "Mass flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(sou.ports[1], volDyn.ports[1]) annotation (Line(points={{-20,6.66134e-16},
          {-6,6.66134e-16},{-6,-5.55112e-16},{20,-5.55112e-16}},   color={0,127,
          255}));
  connect(sou1.ports[1], volSte.ports[1])
    annotation (Line(points={{-20,-50},{20,-50}},          color={0,127,255}));
  connect(volSte.ports[2], bou.ports[1]) annotation (Line(points={{20,-50},{20,-60},
          {40,-60},{40,-22},{60,-22}}, color={0,127,255}));
  connect(volDyn.ports[2], bou.ports[2]) annotation (Line(points={{20,0},{20,-10},
          {40,-10},{40,-18},{60,-18}}, color={0,127,255}));
  connect(sou.m_flow_in, m_flow.y) annotation (Line(points={{-40,8},{-48,8},{-48,
          0},{-59,0}}, color={0,0,127}));
  connect(m_flow.y, sou1.m_flow_in) annotation (Line(points={{-59,0},{-48,0},{-48,
          -42},{-40,-42}}, color={0,0,127}));
  connect(m_flow.y, gain.u) annotation (Line(points={{-59,0},{-48,0},{-48,40},{-42,
          40}}, color={0,0,127}));
  annotation (Documentation(
        info="<html>
<p>
This model is the base class to validate
the mixing volume with air flowing into and out of the volume
and heat, moisture or trace substance added to the volume.
</p>
<p>
The model <code>volDyn</code> uses a dynamic balance,
whereas the model <code>volSte</code> uses a steady-state balance.
The mass flow rate starts positive and reverses its direction at <i>t=5</i> seconds.
</p>
</html>", revisions="<html>
<ul>
<li>
April 29, 2021, by Michael Wetter:<br/>
Reformulated constraint of replaceable model to avoid access of
component that is not in constraining type.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1473\">IBPSA, #1473</a>.
</li>
<li>
December 23, 2019, by Michael Wetter:<br/>
Changed constraining clause to ensure that heat port is present.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1268\">IBPSA, #1268</a>.
</li>
<li>
January 19, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MixingVolumeReverseFlow;
