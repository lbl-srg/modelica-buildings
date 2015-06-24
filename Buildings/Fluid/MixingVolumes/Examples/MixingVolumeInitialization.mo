within Buildings.Fluid.MixingVolumes.Examples;
model MixingVolumeInitialization "Test model for mixing volume initialization"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Air;

  Buildings.Fluid.Sources.Boundary_pT sou1(redeclare package Medium =
        Medium,
    p=101330,
    nPorts=1,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(redeclare package Medium =
        Medium,
    p=101320,
    nPorts=1,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{120,10},{100,30}})));
  Modelica.Fluid.Pipes.StaticPipe pipe1(
    redeclare package Medium = Medium,
    length=1,
    diameter=0.25,
    flowModel(m_flow_nominal=2)) annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Modelica.Fluid.Pipes.StaticPipe pipe2(
    redeclare package Medium = Medium,
    length=1,
    diameter=0.25,
    flowModel(m_flow_nominal=2)) annotation (Placement(transformation(extent={{60,10},{80,30}})));
  MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    V=0.1,
    nPorts=2,
    m_flow_nominal=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
equation
  connect(sou1.ports[1], pipe1.port_a) annotation (Line(
      points={{-40,20},{-20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe1.port_b, vol1.ports[1]) annotation (Line(
      points={{0,20},{28,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol1.ports[2], pipe2.port_a) annotation (Line(
      points={{32,20},{60,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe2.port_b, sin1.ports[1]) annotation (Line(
      points={{80,20},{100,20}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{180,100}}),      graphics),
experiment(StopTime=0.001,
           Tolerance=1e-6),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Examples/MixingVolumeInitialization.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the initialization of the mixing volume.
</p>
</html>", revisions="<html>
<ul>
<li>
October 24, 2013 by Michael Wetter:<br/>
Set <code>flowModel(m_flow_nominal=2)</code> in the pipe models to
avoid a cyclic definition of
<code>pipe1.flowModel.m_flow_nominal</code>
and
<code>pipe2.flowModel.m_flow_nominal</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MixingVolumeInitialization;
