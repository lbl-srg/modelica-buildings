within Buildings.Fluid.MixingVolumes.Validation;
model MixingVolumeMassFlow "Test model for mass flow into and out of volume"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Air "Medium model";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=10
    "Nominal pressure drop";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.5
    "Nominal mass flow rate";

  Modelica.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=false,
    m_flow=m_flow_nominal,
    T=313.15) "Flow source and sink"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    T=303.15,
    nPorts=1) "Boundary condition"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,0})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    V=1,
    redeclare package Medium = Medium,
    nPorts=2,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
              annotation (Placement(transformation(extent={{-10,0},{10,20}})));

equation
  connect(sou.ports[1], vol.ports[1]) annotation (Line(
      points={{-40,6.66134e-16},{-26,6.66134e-16},{-26,-5.55112e-16},{-2,-5.55112e-16}},
      color={0,127,255}));
  connect(bou.ports[1], vol.ports[2])
    annotation (Line(points={{40,0},{2,0}}, color={0,127,255}));
  annotation (Documentation(
        info="<html>
<p>
This model demonstrates the use of the mixing volume with air flowing into and out of the volume.
</p>
<p>
The initial conditions for the volume is declared as fixed initial
values for the energy dynamics, but free initial conditions
for the mass dynamics. The reason for leaving the initial conditions
unspecified for the mass dynamics is that the sink <code>bou</code>
declares the pressure of the fluid. As there is no flow resistance
between that boundary condition and the volume,
the volume has the same pressure. Therefore, specifying an
initial condition for the mass dynamics would yield to an overspecified
initial value problem for the pressure of the medium.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
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
October 12, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MixingVolumeMassFlow.mos"
        "Simulate and plot"),
    experiment(Tolerance=1E-6, StopTime=10));
end MixingVolumeMassFlow;
