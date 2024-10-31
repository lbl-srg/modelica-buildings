within Buildings.Fluid.Sources.Examples;
model TraceSubstancesFlowSource
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"});

  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    V=100,
    m_flow_nominal=1,
    nPorts=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Mixing volume"
                          annotation (Placement(transformation(extent={{100,120},
            {120,140}})));
  Sources.TraceSubstancesFlowSource sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-46,110},{-26,130}})));
  Modelica.Blocks.Sources.Step step(
    startTime=0.5,
    height=-2,
    offset=2)
    annotation (Placement(transformation(extent={{-92,30},{-72,50}})));
  FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1)
    "Resistance, used to check if species are transported between ports"
    annotation (Placement(transformation(extent={{60,70},{82,90}})));
  MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    V=100,
    m_flow_nominal=1,
    nPorts=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Mixing volume"
                          annotation (Placement(transformation(extent={{100,80},
            {120,100}})));
  Sources.TraceSubstancesFlowSource sou1(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-46,70},{-26,90}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu(threShold=1E-4)
    "Assert that both volumes have the same concentration"
    annotation (Placement(transformation(extent={{210,128},{230,148}})));
  MixingVolumes.MixingVolume vol2(
    redeclare package Medium = Medium,
    p_start=Medium.p_default,
    V=100,
    m_flow_nominal=1,
    nPorts=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Mixing volume"
                          annotation (Placement(transformation(extent={{90,-20},
            {110,0}})));
  MixingVolumes.MixingVolume vol3(
    redeclare package Medium = Medium,
    p_start=Medium.p_default,
    V=100,
    m_flow_nominal=1,
    nPorts=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Mixing volume"
                          annotation (Placement(transformation(extent={{88,-60},
            {108,-40}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu1(threShold=1E-4)
    "Assert that both volumes have the same concentration"
    annotation (Placement(transformation(extent={{210,0},{230,20}})));
  MixingVolumes.MixingVolume vol4(
    redeclare package Medium = Medium,
    nPorts=4,
    p_start=Medium.p_default,
    V=100,
    m_flow_nominal=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Mixing volume"
                          annotation (Placement(transformation(extent={{-16,-40},
            {4,-20}})));
  Sources.TraceSubstancesFlowSource sou2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-48,-50},{-28,-30}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    p=101325,
    nPorts=1,
    T=293.15) annotation (Placement(transformation(extent={{-62,-80},{-42,-60}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=2,
    p=101320,
    T=293.15) "Sink boundary conditions"
              annotation (Placement(transformation(extent={{188,-50},{168,-30}})));
  FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1)
    "Resistance, used to check if species are transported between ports"
    annotation (Placement(transformation(extent={{126,-30},{148,-10}})));
  FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1)
    "Resistance, used to check if species are transported between ports"
    annotation (Placement(transformation(extent={{126,-70},{148,-50}})));
  FixedResistances.PressureDrop res3(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1)
    "Resistance, used to check if species are transported between ports"
    annotation (Placement(transformation(extent={{-28,-80},{-6,-60}})));

  Sensors.TraceSubstances C(
    redeclare package Medium = Medium,
    warnAboutOnePortConnection = false)
    "Trace substance sensor"
    annotation (Placement(transformation(extent={{120,134},{140,154}})));
  Sensors.TraceSubstances C1(
    redeclare package Medium = Medium,
    warnAboutOnePortConnection = false)
    "Trace substance sensor"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Sensors.TraceSubstances C2(
    redeclare package Medium = Medium,
    warnAboutOnePortConnection = false)
    "Trace substance sensor"
    annotation (Placement(transformation(extent={{168,6},{188,26}})));
  Sensors.TraceSubstances C3(
    redeclare package Medium = Medium,
    warnAboutOnePortConnection = false)
    "Trace substance sensor"
    annotation (Placement(transformation(extent={{188,-50},{208,-30}})));
  FixedResistances.PressureDrop res4(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1)
    "Resistance, used to check if species are transported between ports"
    annotation (Placement(transformation(extent={{58,-30},{80,-10}})));
  FixedResistances.PressureDrop res6(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1)
    "Resistance, used to check if species are transported between ports"
    annotation (Placement(transformation(extent={{58,-70},{80,-50}})));
  FixedResistances.PressureDrop res5(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1)
    "Resistance, used to check if species are transported between ports"
    annotation (Placement(transformation(extent={{138,110},{160,130}})));
  FixedResistances.PressureDrop res7(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1)
    "Resistance, used to check if species are transported between ports"
    annotation (Placement(transformation(extent={{138,70},{160,90}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    nPorts=2,
    p=101320,
    T=293.15) "Sink boundary conditions"
              annotation (Placement(transformation(extent={{220,90},{200,110}})));
equation
  connect(res3.port_b, vol4.ports[2])
                                     annotation (Line(points={{-6,-70},{-6,-40},
          {-7,-40}},                                  color={0,127,255}));
  connect(res1.port_b, sin.ports[1])  annotation (Line(
      points={{148,-20},{158,-20},{158,-38},{168,-38}},
      color={0,127,255}));
  connect(res2.port_b, sin.ports[2])  annotation (Line(
      points={{148,-60},{158,-60},{158,-42},{168,-42}},
      color={0,127,255}));
  connect(bou.ports[1], res3.port_a) annotation (Line(
      points={{-42,-70},{-28,-70}},
      color={0,127,255}));
  connect(sou1.ports[1], res.port_a) annotation (Line(
      points={{-26,80},{60,80}},
      color={0,127,255}));
  connect(sou2.ports[1], vol4.ports[1]) annotation (Line(
      points={{-28,-40},{-9,-40}},
      color={0,127,255}));
  connect(step.y, sou.m_flow_in) annotation (Line(
      points={{-71,40},{-60,40},{-60,120},{-48.1,120}},
      color={0,0,127}));
  connect(step.y, sou1.m_flow_in) annotation (Line(
      points={{-71,40},{-60,40},{-60,80},{-48.1,80}},
      color={0,0,127}));
  connect(step.y, sou2.m_flow_in) annotation (Line(
      points={{-71,40},{-60,40},{-60,-40},{-50.1,-40}},
      color={0,0,127}));
  connect(assEqu.u1, C.C) annotation (Line(
      points={{208,144},{141,144}},
      color={0,0,127}));
  connect(C1.C, assEqu.u2) annotation (Line(
      points={{141,100},{166,100},{166,132},{208,132}},
      color={0,0,127}));
  connect(assEqu1.u1, C2.C) annotation (Line(
      points={{208,16},{189,16}},
      color={0,0,127}));
  connect(C3.C, assEqu1.u2) annotation (Line(
      points={{209,-40},{220,-40},{220,-20},{200,-20},{200,4},{208,4}},
      color={0,0,127}));
  connect(sou.ports[1], vol.ports[1]) annotation (Line(
      points={{-26,120},{107.333,120}},
      color={0,127,255}));
  connect(vol.ports[2], C.port) annotation (Line(
      points={{110,120},{130,120},{130,134}},
      color={0,127,255}));
  connect(res.port_b, vol1.ports[1]) annotation (Line(
      points={{82,80},{107.333,80}},
      color={0,127,255}));
  connect(vol1.ports[2], C1.port) annotation (Line(
      points={{110,80},{130,80},{130,90}},
      color={0,127,255}));
  connect(vol2.ports[1], res1.port_a) annotation (Line(
      points={{97.3333,-20},{126,-20}},
      color={0,127,255}));
  connect(vol3.ports[1], res2.port_a) annotation (Line(
      points={{95.3333,-60},{126,-60}},
      color={0,127,255}));
  connect(C2.port, vol2.ports[2]) annotation (Line(
      points={{178,6},{178,0},{118,0},{118,-20},{100,-20}},
      color={0,127,255}));
  connect(C3.port, vol3.ports[2]) annotation (Line(
      points={{198,-50},{198,-78},{98,-78},{98,-60}},
      color={0,127,255}));
  connect(vol4.ports[3], res4.port_a) annotation (Line(
      points={{-5,-40},{26,-40},{26,-20},{58,-20}},
      color={0,127,255}));
  connect(vol4.ports[4], res6.port_a) annotation (Line(
      points={{-3,-40},{26,-40},{26,-60},{58,-60}},
      color={0,127,255}));
  connect(res6.port_b, vol3.ports[3]) annotation (Line(
      points={{80,-60},{100.667,-60}},
      color={0,127,255}));
  connect(res4.port_b, vol2.ports[3]) annotation (Line(
      points={{80,-20},{92,-20},{92,-20},{102.667,-20}},
      color={0,127,255}));
  connect(vol.ports[3], res5.port_a) annotation (Line(
      points={{112.667,120},{138,120}},
      color={0,127,255}));
  connect(res5.port_b, sin1.ports[1]) annotation (Line(
      points={{160,120},{170,120},{170,102},{200,102}},
      color={0,127,255}));
  connect(vol1.ports[3], res7.port_a) annotation (Line(
      points={{112.667,80},{138,80}},
      color={0,127,255}));
  connect(res7.port_b, sin1.ports[2]) annotation (Line(
      points={{160,80},{180,80},{180,98},{200,98}},
      color={0,127,255}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{240,180}}), graphics),
            experiment(Tolerance=1e-6, StopTime=600),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sources/Examples/TraceSubstancesFlowSource.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This model demonstrates the use of trace substances that are added
to a volume of air.
The source is a step function of <i>2</i> kg/s CO<sub>2</sub> from <i>t=0</i> second
to <i>t=0.5</i> second.
The sensors <code>C</code> and <code>C1</code> measure the same concentration that initially increases
and then remains constant as there is no flow through the volumes <code>vol</code> and <code>vol1</code>.
The sensors
<code>C2</code> and
<code>C3</code> first meaure an increase in concentration, which then decays to zero
as there is a mass flow rate with zero CO<sub>2</sub> from the source <code>bou</code> to the sink <code>sin</code>.
</html>", revisions="<html>
<ul>
<li>
March 26, 2024, by Michael Wetter:<br/>
Configured the sensor parameter to suppress the warning about being a one-port connection.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1857\">IBPSA, #1857</a>.
</li>
<li>
November 27, 2013 by Michael Wetter:<br/>
Added pressure boundary condition to model.
This is required for the new air model,
which is incompressible. Otherwise, there will be no pressure reference
in the system.
</li>
<li>
September 19, 2013, by Michael Wetter:<br/>
Simplified example.
</li>
<li>
April 29, 2013, by Michael Wetter:<br/>
Changed the initialization of the medium volumes from free initial conditions
to <code>Modelica.Fluid.Types.Dynamics.FixedInitial</code>.
This was required for <code>vol</code> and <code>vol1</code> to have the same
computations for the initial states.
</li>
<li>
September 18, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TraceSubstancesFlowSource;
