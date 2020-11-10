within Buildings.Fluid.Sensors.Examples;
model MassFraction "Test model for the mass fraction sensor"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air
    "Medium model";

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1,
    T=293.15) "Flow boundary condition" annotation (Placement(
        transformation(extent={{90,-10},{70,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloRat(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    use_T_in=false,
    X={0.02,0.98},
    m_flow=10,
    nPorts=1) "Flow boundary condition"  annotation (Placement(transformation(
          extent={{-80,0},{-60,20}})));

  Buildings.Fluid.Sensors.MassFraction senMasFra2(
    redeclare package Medium = Medium, warnAboutOnePortConnection=false)
                                       "Mass fraction sensor for the volume"
    annotation (Placement(transformation(extent={{20,36},{40,56}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    V=1,
    nPorts=3,
    m_flow_nominal=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Volume"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp(
    redeclare package Medium = Medium,
    m_flow_nominal=10,
    dp_nominal=200) "Flow resistance"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFra1(
    redeclare package Medium = Medium, m_flow_nominal=10)
    "Mass fraction sensor for the flowing medium"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(dp.port_b, sin.ports[1]) annotation (Line(
      points={{60,0},{70,0}},
      color={0,127,255}));
  connect(masFloRat.ports[1], senMasFra1.port_a) annotation (Line(
      points={{-60,10},{-40,10}},
      color={0,127,255}));
  connect(senMasFra1.port_b, vol.ports[1]) annotation (Line(
      points={{-20,10},{7.33333,10}},
      color={0,127,255}));
  connect(vol.ports[2], dp.port_a) annotation (Line(
      points={{10,10},{10,6.66134e-16},{40,6.66134e-16}},
      color={0,127,255}));
  connect(vol.ports[3], senMasFra2.port) annotation (Line(
      points={{12.6667,10},{30,10},{30,36}},
      color={0,127,255}));
    annotation (experiment(Tolerance=1e-6, StopTime=10),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Examples/MassFraction.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the mass fraction sensors.
</p>
</html>", revisions="<html>
<ul>
<li>
April 7, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MassFraction;
