within Buildings.Fluid.MixingVolumes.Validation;
model MixingVolumeMFactor
  "A check for verifying the implementation of the parameter mSenFac"
  extends Buildings.Fluid.MixingVolumes.Validation.MixingVolumeMassFlow(
  sou(X={0.02,0.98},
      T=Medium.T_default),
  vol(mSenFac=10),
    bou(nPorts=3));
  Buildings.Fluid.MixingVolumes.MixingVolume volMFactor(
    redeclare package Medium = Medium,
    mSenFac=10,
    V=1,
    nPorts=2,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Mixing volume using mSenFac = 10"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    V=10,
    nPorts=2,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "MixingVolume with V = 10 instead of mSenFac = 10"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundaryMFactor(
    redeclare package Medium = Medium,
    T=300,
    nPorts=1,
    m_flow=1,
    X={0.02,0.98}) "Flow source for mixing volume using mSenFac"
              annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    T=300,
    nPorts=1,
    m_flow=1,
    X={0.02,0.98}) "Flow source for mixing volume using larger volume"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
equation
  connect(boundaryMFactor.ports[1],volMFactor. ports[1]) annotation (Line(
      points={{-40,-40},{-2,-40}},
      color={0,127,255}));
  connect(boundary.ports[1], vol1.ports[1]) annotation (Line(
      points={{-40,-80},{-2,-80}},
      color={0,127,255}));
  connect(bou.ports[2], volMFactor.ports[2]) annotation (Line(points={{40,
          1.33227e-15},{20,1.33227e-15},{20,-40},{2,-40}}, color={0,127,255}));
  connect(bou.ports[3], vol1.ports[2]) annotation (Line(points={{40,1.33227e-15},
          {20,1.33227e-15},{20,-80},{2,-80}}, color={0,127,255}));
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
<p>
See
<a href=\"modelica://Buildings.Fluid.MixingVolumes.Validation.MixingVolumeMassFlow\">
Buildings.Fluid.MixingVolumes.Validation.MixingVolumeMassFlow</a>
for the rational of the selected initial conditions for the volumes.
</p>
</html>", revisions="<html>
<ul>
<li>
March 27, 2015 by Michael Wetter:<br/>
Set the mass dynamics of the volume to
<code>Modelica.Fluid.Types.Dynamics.DynamicFreeInitial</code>
to avoid an overspecified but consistent initial value problem.
The previous implementation caused a warning in Dymola 2015 FD01, and caused
in Dymola 2016 beta 2 to not translate the model.
The problem was that the boundary condition and the volume
both declared an equation for the initial pressure.
</li>
<li>
December, 2014 by Filip Jorissen:<br/>
Added temperature verification.
</li>
<li>
November 25, 2014 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1E-6, StopTime=100),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MixingVolumeMFactor.mos"
        "Simulate and plot"));
end MixingVolumeMFactor;
