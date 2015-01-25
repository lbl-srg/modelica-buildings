within Buildings.Fluid.MixingVolumes.Examples;
model MixingVolumeMFactor
  "A check for verifying the implementation of the parameter mSenFac"
  extends Buildings.Fluid.MixingVolumes.Examples.MixingVolumeMassFlow(
  sou(X={0.02,0.98},
      T=Medium.T_default),
  vol(mSenFac=10));
  Buildings.Fluid.MixingVolumes.MixingVolume volMFactor(
    redeclare package Medium = Medium,
    mSenFac=10,
    m_flow_nominal=1,
    V=1,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Mixing volume using mSenFac = 10"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=10,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "MixingVolume with V = 10 instead of mSenFac = 10"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    nPorts=2) "Sink"
              annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundaryMFactor(
    redeclare package Medium = Medium,
    T=300,
    nPorts=1,
    m_flow=1,
    X={0.02,0.98}) "Flow source for mixing volume using mSenFac"
              annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    T=300,
    nPorts=1,
    m_flow=1,
    X={0.02,0.98}) "Flow source for mixing volume using larger volume"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(vol1.ports[1], bou1.ports[1]) annotation (Line(
      points={{-12,-80},{40,-80},{40,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volMFactor.ports[1], bou1.ports[2]) annotation (Line(
      points={{-12,-40},{40,-40},{40,-62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundaryMFactor.ports[1],volMFactor. ports[2]) annotation (Line(
      points={{-60,-40},{-8,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundary.ports[1], vol1.ports[2]) annotation (Line(
      points={{-60,-80},{-8,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p>This model contains two verifications for the implementation of <code>mSenFac</code>:</p>
<ol>
<li>
The mixingVolume temperature <code>vol.T</code> should be constant. 
This is to check the correct implementation of the parameter <code>mSenFac</code> for moist air media.
</li>
<li>
The temperature response of <code>volMFactor.T</code> and <code>vol1.T</code> should be nearly identical.
Furthermore the response of the species concentration <code>Xi</code> demonstrates the 
difference between using an <code>mSenFac = 10</code> and multiplying volume by <i>10</i>.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
December, 2014 by Filip Jorissen:<br/>
Added temperature verification.
</li>
<li>
November 25, 2014 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"), __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Examples/MixingVolumeMFactor.mos"
        "Simulate and plot"));
end MixingVolumeMFactor;
