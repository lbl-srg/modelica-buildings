within Buildings.Fluid.MixingVolumes.Examples;
model MixingVolume
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air;

    Modelica.Blocks.Sources.Ramp P(
    duration=0.5,
    startTime=0.5,
    height=-10,
    offset=101330)
                 annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium, T=293.15,
    use_p_in=true,
    nPorts=3)                                       annotation (Placement(
        transformation(extent={{-70,48},{-50,68}})));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    nPorts=3,
    use_p_in=false,
    p=101325,
    T=283.15)                                       annotation (Placement(
        transformation(extent={{130,48},{110,68}})));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(
    redeclare each package Medium = Medium,
    from_dp=true,
    m_flow_nominal=2,
    dp_nominal=2.5)
             annotation (Placement(transformation(extent={{-36,50},{-16,70}})));
  MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    V=0.1,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=2)
          annotation (Placement(transformation(extent={{0,10},{20,30}})));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res2(
    redeclare each package Medium = Medium,
    from_dp=true,
    m_flow_nominal=2,
    dp_nominal=2.5)
             annotation (Placement(transformation(extent={{80,50},{100,70}})));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res11(
    redeclare each package Medium = Medium,
    from_dp=true,
    m_flow_nominal=2,
    dp_nominal=2.5)
             annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res12(
    redeclare each package Medium = Medium,
    from_dp=true,
    m_flow_nominal=2,
    dp_nominal=2.5)
             annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Modelica.Fluid.Vessels.ClosedVolume vol(
    redeclare package Medium = Medium,
    V=0.1,
    nPorts=2,
    h_start=45300.945,
    use_portsData=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
         annotation (Placement(transformation(extent={{0,60},{22,80}})));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality
    annotation (Placement(transformation(extent={{160,72},{180,92}})));
  Buildings.Fluid.Sensors.EnthalpyFlowRate entFloRat(redeclare package Medium =
        Medium, m_flow_nominal=2) "Enthalpy flow rate"
                                     annotation (Placement(transformation(
          extent={{40,50},{60,70}})));
  Buildings.Fluid.Sensors.EnthalpyFlowRate entFloRat1(redeclare package Medium =
        Medium, m_flow_nominal=2) "Enthalpy flow rate"
                                     annotation (Placement(transformation(
          extent={{40,0},{60,20}})));
  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol2(
    redeclare package Medium = Medium,
    V=0.1,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=2)
          annotation (Placement(transformation(extent={{0,-82},{20,-62}})));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res21(
    redeclare each package Medium = Medium,
    from_dp=true,
    m_flow_nominal=2,
    dp_nominal=2.5)
             annotation (Placement(transformation(extent={{-40,-92},{-20,-72}})));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res22(
    redeclare each package Medium = Medium,
    from_dp=true,
    m_flow_nominal=2,
    dp_nominal=2.5)
             annotation (Placement(transformation(extent={{80,-92},{100,-72}})));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality1
    annotation (Placement(transformation(extent={{156,10},{176,30}})));
  Buildings.Fluid.Sensors.EnthalpyFlowRate entFloRat2(redeclare package Medium =
        Medium, m_flow_nominal=2) "Enthalpy flow rate"
                                     annotation (Placement(transformation(
          extent={{40,-92},{60,-72}})));
    Modelica.Blocks.Sources.Constant zero(k=0)
      annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
    Modelica.Blocks.Sources.Constant TLiq(k=283.15)
      annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
equation
  connect(P.y, sou.p_in) annotation (Line(points={{-79,70},{-72,70},{-72,66}},
                    color={0,0,127}));
  connect(res2.port_a, entFloRat.port_b) annotation (Line(points={{80,60},{60,
          60}}, color={0,127,255}));
  connect(entFloRat2.H_flow, assertEquality1.u2) annotation (Line(points={{50,-71},
          {50,-24},{140,-24},{140,14},{154,14}},
                                    color={0,0,127}));
  connect(zero.y, vol2.mWat_flow) annotation (Line(points={{-19,-20},{-12,-20},
          {-12,-64},{-2,-64}}, color={0,0,127}));
  connect(TLiq.y, vol2.TWat) annotation (Line(points={{-19,-50},{-14,-50},{-14,
          -67.2},{-2,-67.2}},
                          color={0,0,127}));
  connect(sou.ports[1], res1.port_a) annotation (Line(
      points={{-50,60.6667},{-43,60.6667},{-43,60},{-36,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], res11.port_a) annotation (Line(
      points={{-50,58},{-44,58},{-44,10},{-40,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[3], res21.port_a) annotation (Line(
      points={{-50,55.3333},{-46,55.3333},{-46,-82},{-40,-82}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin.ports[1], res2.port_b) annotation (Line(
      points={{110,60.6667},{104,60.6667},{104,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin.ports[2], res12.port_b) annotation (Line(
      points={{110,58},{104,58},{104,10},{100,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res22.port_b, sin.ports[3]) annotation (Line(
      points={{100,-82},{106,-82},{106,55.3333},{110,55.3333}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, vol.ports[1]) annotation (Line(
      points={{-16,60},{8.8,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], entFloRat.port_a) annotation (Line(
      points={{13.2,60},{40,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res11.port_b, vol1.ports[1]) annotation (Line(
      points={{-20,10},{8,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol1.ports[2], entFloRat1.port_a) annotation (Line(
      points={{12,10},{40,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res21.port_b, vol2.ports[1]) annotation (Line(
      points={{-20,-82},{8,-82}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol2.ports[2], entFloRat2.port_a) annotation (Line(
      points={{12,-82},{40,-82}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(entFloRat2.port_b, res22.port_a) annotation (Line(
      points={{60,-82},{80,-82}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(entFloRat1.port_b, res12.port_a) annotation (Line(
      points={{60,10},{80,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(entFloRat.H_flow, assertEquality.u1) annotation (Line(
      points={{50,71},{50,88},{158,88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(entFloRat.H_flow, assertEquality1.u1) annotation (Line(
      points={{50,71},{50,88},{140,88},{140,26},{154,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(entFloRat1.H_flow, assertEquality.u2) annotation (Line(
      points={{50,21},{50,40},{146,40},{146,76},{158,76}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{180,100}}),      graphics),
experiment(StopTime=2),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Examples/MixingVolume.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the implementation of the mixing volumes.
It compares the results from the mixing volume of the Modelica
Standard Library with the implementation in the <code>Buildings</code>
library. If the changes are bigger than a prescribed limit,
the simulation stops with an error.
</p>
</html>", revisions="<html>
<ul>
<li>
October 24, 2013, by Michael Wetter:<br/>
Set <code>vol(h_start=45300.945)</code>.
This avoids a cyclic assignment of <code>vol.T_start</code>
and <code>vol.h_start</code> in
<code>Modelica.Fluid.Vessels.ClosedVolume</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MixingVolume;
