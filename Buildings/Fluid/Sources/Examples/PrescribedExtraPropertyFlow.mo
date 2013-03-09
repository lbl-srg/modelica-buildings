within Buildings.Fluid.Sources.Examples;
model PrescribedExtraPropertyFlow
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir(extraPropertiesNames={"CO2"});
 // package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir;

  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    V=100,
    m_flow_nominal=1,
    nPorts=2) "Mixing volume"
                          annotation (Placement(transformation(extent={{100,40},
            {120,60}}, rotation=0)));
  PrescribedExtraPropertyFlowRate sou(redeclare package Medium = Medium,
      use_m_flow_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-46,30},{-26,50}}, rotation=0)));
  Modelica.Blocks.Sources.Step step(          startTime=0.5,
    height=-2,
    offset=2)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}}, rotation=
            0)));
  FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1)
    "Resistance, used to check if species are transported between ports"
    annotation (Placement(transformation(extent={{60,2},{82,22}},   rotation=0)));
  MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    V=100,
    m_flow_nominal=1,
    nPorts=2) "Mixing volume"
                          annotation (Placement(transformation(extent={{100,12},
            {120,32}}, rotation=0)));
  PrescribedExtraPropertyFlowRate sou1(
                                      redeclare package Medium = Medium,
      use_m_flow_in=true)
    annotation (Placement(transformation(extent={{-46,2},{-26,22}},   rotation=
            0)));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu(threShold=1E-4,
      startTime=100000)
    "Assert that both volumes have the same concentration. Fixme: change StartTime to zero, see annotation of model"
    annotation (Placement(transformation(extent={{210,60},{230,80}}, rotation=0)));
  MixingVolumes.MixingVolume vol2(
    redeclare package Medium = Medium,
    p_start=Medium.p_default,
    V=100,
    m_flow_nominal=1,
    nPorts=3) "Mixing volume"
                          annotation (Placement(transformation(extent={{60,-40},
            {80,-20}}, rotation=0)));
  MixingVolumes.MixingVolume vol3(
    redeclare package Medium = Medium,
    p_start=Medium.p_default,
    V=100,
    m_flow_nominal=1,
    nPorts=3) "Mixing volume"
                          annotation (Placement(transformation(extent={{60,-80},
            {80,-60}}, rotation=0)));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1},
    dp_nominal={1,1,1},
    from_dp=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                   annotation (Placement(transformation(
        origin={42,-60},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu1(
                                                     threShold=1E-4)
    "Assert that both volumes have the same concentration"
    annotation (Placement(transformation(extent={{212,-20},{232,0}},
                                                                   rotation=0)));
  MixingVolumes.MixingVolume vol4(
    redeclare package Medium = Medium,
    nPorts=3,
    p_start=Medium.p_default,
    V=100,
    m_flow_nominal=1) "Mixing volume"
                          annotation (Placement(transformation(extent={{-4,-60},
            {16,-40}}, rotation=0)));
  PrescribedExtraPropertyFlowRate sou2(
                                      redeclare package Medium = Medium,
      use_m_flow_in=true)
    annotation (Placement(transformation(extent={{-46,-70},{-26,-50}}, rotation=
           0)));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    p=101325,
    nPorts=1,
    T=293.15) annotation (Placement(transformation(extent={{-60,-100},{-40,-80}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    nPorts=2,
    p=101320,
    T=293.15) annotation (Placement(transformation(extent={{160,-70},{140,-50}},
          rotation=0)));
  FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1)
    "Resistance, used to check if species are transported between ports"
    annotation (Placement(transformation(extent={{98,-50},{120,-30}}, rotation=
            0)));
  FixedResistances.FixedResistanceDpM res2(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1)
    "Resistance, used to check if species are transported between ports"
    annotation (Placement(transformation(extent={{98,-90},{120,-70}}, rotation=
            0)));
  FixedResistances.FixedResistanceDpM res3(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1)
    "Resistance, used to check if species are transported between ports"
    annotation (Placement(transformation(extent={{-26,-100},{-4,-80}}, rotation=
           0)));
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Sensors.TraceSubstances C(redeclare package Medium = Medium)
    "Trace substance sensor"
    annotation (Placement(transformation(extent={{120,66},{140,86}})));
  Sensors.TraceSubstances C1(redeclare package Medium = Medium)
    "Trace substance sensor"
    annotation (Placement(transformation(extent={{130,18},{150,38}})));
  Sensors.TraceSubstances C2(redeclare package Medium = Medium)
    "Trace substance sensor"
    annotation (Placement(transformation(extent={{140,-14},{160,6}})));
  Sensors.TraceSubstances C3(redeclare package Medium = Medium)
    "Trace substance sensor"
    annotation (Placement(transformation(extent={{170,-70},{190,-50}})));
equation
  connect(vol4.ports[2], spl.port_3) annotation (Line(points={{6,-60},{32,-60}},
                     color={0,127,255}));
  connect(res3.port_b, vol4.ports[3])
                                     annotation (Line(points={{-4,-90},{8.66667,
          -90},{8.66667,-60}},                        color={0,127,255}));
  connect(res1.port_b, bou1.ports[1]) annotation (Line(
      points={{120,-40},{130,-40},{130,-58},{140,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_b, bou1.ports[2]) annotation (Line(
      points={{120,-80},{130,-80},{130,-62},{140,-62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[1], res3.port_a) annotation (Line(
      points={{-40,-90},{-26,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[1], res.port_a) annotation (Line(
      points={{-26,12},{60,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], vol4.ports[1]) annotation (Line(
      points={{-26,-60},{3.33333,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y, sou.m_flow_in) annotation (Line(
      points={{-79,40},{-48.1,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, sou1.m_flow_in) annotation (Line(
      points={{-79,40},{-64,40},{-64,12},{-48.1,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, sou2.m_flow_in) annotation (Line(
      points={{-79,40},{-64,40},{-64,-60},{-48.1,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEqu.u1, C.C) annotation (Line(
      points={{208,76},{141,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(C1.C, assEqu.u2) annotation (Line(
      points={{151,28},{177.5,28},{177.5,64},{208,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEqu1.u1, C2.C) annotation (Line(
      points={{210,-4},{161,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(C3.C, assEqu1.u2) annotation (Line(
      points={{191,-60},{200,-60},{200,-16},{210,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], vol.ports[1]) annotation (Line(
      points={{-26,40},{108,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], C.port) annotation (Line(
      points={{112,40},{130,40},{130,66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, vol1.ports[1]) annotation (Line(
      points={{82,12},{108,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol1.ports[2], C1.port) annotation (Line(
      points={{112,12},{140,12},{140,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_1, vol2.ports[1]) annotation (Line(
      points={{42,-50},{42,-40},{67.3333,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol2.ports[2], res1.port_a) annotation (Line(
      points={{70,-40},{98,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_2, vol3.ports[1]) annotation (Line(
      points={{42,-70},{44,-70},{44,-80},{67.3333,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol3.ports[2], res2.port_a) annotation (Line(
      points={{70,-80},{98,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(C2.port, vol2.ports[3]) annotation (Line(
      points={{150,-14},{152,-14},{152,-20},{90,-20},{90,-40},{72.6667,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(C3.port, vol3.ports[3]) annotation (Line(
      points={{180,-70},{180,-98},{72.6667,-98},{72.6667,-80}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{240,180}}), graphics={Text(
          extent={{-38,156},{212,100}},
          lineColor={255,0,0},
          textString=
              "fixme: vol and vol1 have different trace substances. If res is removed, then they are equal. Check prior to release, and then change startTime of assEqu ")}),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sources/Examples/PrescribedExtraPropertyFlow.mos"
        "Simulate and plot"));
end PrescribedExtraPropertyFlow;
