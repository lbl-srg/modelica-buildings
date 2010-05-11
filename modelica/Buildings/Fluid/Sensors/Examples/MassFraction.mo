within Buildings.Fluid.Sensors.Examples;
model MassFraction

  import Buildings;

 package Medium = Buildings.Media.PerfectGases.MoistAirUnsaturated
    "Medium model";

  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    T=293.15,
    nPorts=1)                                       annotation (Placement(
        transformation(extent={{90,-2},{70,18}}, rotation=0)));
  Buildings.Fluid.Sources.MassFlowSource_T masFloRat(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=false,
    use_T_in=false,
    X={0.02,0.98},
    m_flow=10)                           annotation (Placement(transformation(
          extent={{-36,-2},{-16,18}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Buildings.Fluid.Sensors.MassFraction masFra(redeclare package Medium =
        Medium) "Mass fraction"
    annotation (Placement(transformation(extent={{34,32},{54,52}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    nPorts=3,
    V=1) "Volume"
    annotation (Placement(transformation(extent={{10,8},{30,28}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dp(
    redeclare package Medium = Medium,
    m_flow_nominal=10,
    dp_nominal=200)
    annotation (Placement(transformation(extent={{38,-2},{58,18}})));
equation
  connect(masFloRat.ports[1], vol.ports[1]) annotation (Line(
      points={{-16,8},{17.3333,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFra.port, vol.ports[2]) annotation (Line(
      points={{44,32},{44,-4},{20,-4},{20,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp.port_b, sin.ports[1]) annotation (Line(
      points={{58,8},{70,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp.port_a, vol.ports[3]) annotation (Line(
      points={{38,8},{22.6667,8}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                        graphics),
                         Commands(file=
            "MassFraction.mos" "run"),
    Documentation(info="<html>
This examples is a unit test for the mass fraction sensor.
</html>", revisions="<html>
<ul>
<li>
April 7, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end MassFraction;
