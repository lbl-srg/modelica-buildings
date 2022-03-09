within Buildings.Fluid.MixingVolumes.Validation;
model MixingVolumeSteadyStateMass "Test model for steady state mass dynamics"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Flow source and sink"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1) "Boundary condition"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={92,-10})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=1,
    redeclare package Medium = Medium,
    m_flow_nominal=0.01,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=true,
    nPorts=2,
    mSenFac=2)
    "Mixing volume with steady state mass dynamics"
     annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    offset=1,
    height=-2) "Ramp input"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));

  Modelica.Blocks.Math.Gain gain(k=0.01) "Gain for nominal mass flow rate"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=0.01,
    dp_nominal=1000) "Pressure drop"
    annotation (Placement(transformation(extent={{50,-20},{70,0}})));
equation
  connect(ramp.y, gain.u) annotation (Line(
      points={{-69,-10},{-62,-10}},
      color={0,0,127}));
  connect(gain.y, sou.m_flow_in) annotation (Line(
      points={{-39,-10},{-31.5,-10},{-31.5,-2},{-22,-2}},
      color={0,0,127}));
  connect(sou.ports[1], vol.ports[1]) annotation (Line(
      points={{0,-10},{39,-10},{39,20}},
      color={0,127,255}));
  connect(vol.ports[2], res.port_a) annotation (Line(
      points={{41,20},{41,-10},{50,-10}},
      color={0,127,255}));
  connect(res.port_b, bou.ports[1]) annotation (Line(
      points={{70,-10},{82,-10}},
      color={0,127,255}));
  annotation (Documentation(
        info="<html>
<p>
This model shows that steady state mass dynamics are correctly simulated.
A change in pressure does not lead to an exchange and/or creation of mass.
The mixing volume temperature is also unaffected by a pressure change.
</p>
</html>", revisions="<html>
<ul>
<li>
March 9, 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1E-6, StopTime=1.0),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MixingVolumeSteadyStateMass.mos"
        "Simulate and plot"));
end MixingVolumeSteadyStateMass;
