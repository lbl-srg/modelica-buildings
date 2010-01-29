within Buildings.Fluid.Sensors.Examples;
model MassFraction

  import Buildings;

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

// package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model" annotation 1;
 package Medium = Modelica.Media.Air.MoistAir;
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    nPorts=1,
    T=293.15)                                       annotation (Placement(
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
equation
  connect(masFloRat.ports[1], vol.ports[1]) annotation (Line(
      points={{-16,8},{17.3333,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], sin.ports[1]) annotation (Line(
      points={{20,8},{70,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFra.port, vol.ports[3]) annotation (Line(
      points={{44,32},{44,-4},{22.6667,-4},{22.6667,8}},
      color={0,127,255},
      smooth=Smooth.None));
end MassFraction;
