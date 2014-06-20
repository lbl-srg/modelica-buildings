within Buildings.Fluid.MixingVolumes.Examples;
model MixingVolumeMassFlow "Test model for mass flow into and out of volume"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.GasesConstantDensity.SimpleAir;
  Modelica.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=false,
    m_flow=1,
    T=313.15) "Flow source and sink"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    T=303.15,
    nPorts=1) "Boundary condition"                         annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,0})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    V=1,
    redeclare package Medium = Medium,
    m_flow_nominal=0.01,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
              annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(sou.ports[1], vol.ports[1]) annotation (Line(
      points={{-40,6.66134e-16},{-26,6.66134e-16},{-26,-5.55112e-16},{-12,
          -5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], bou.ports[1]) annotation (Line(
      points={{-8,-5.55112e-16},{6,-5.55112e-16},{6,1.55431e-15},{20,
          1.55431e-15}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Documentation(
        info="<html>
<p>
This model demonstrates the use of the mixing volume with air flowing into and out of the volume.
</p>
</html>", revisions="<html>
<ul>
<li>
October 12, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Examples/MixingVolumeMassFlow.mos"
        "Simulate and plot"),
    experiment(StopTime=10));
end MixingVolumeMassFlow;
