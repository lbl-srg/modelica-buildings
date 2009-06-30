within Buildings.Fluids.Sources.Examples;
model PrescribedExtraPropertyFlow
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{180,180}}),
                        graphics),
                         Commands(file=
            "PrescribedExtraPropertyFlow.mos" "run"));
 package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir(extraPropertiesNames={"CO2"});
 // package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir;

  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    nPorts=1,
    V=100) "Mixing volume" 
                          annotation (Placement(transformation(extent={{100,40},
            {120,60}}, rotation=0)));
  annotation (Diagram, Coordsys(extent=[-100,-100; 180,180]));
  PrescribedExtraPropertyFlowRate sou(redeclare package Medium = Medium,
      use_m_flow_in=true) 
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
    nPorts=1,
    V=100) "Mixing volume" 
                          annotation (Placement(transformation(extent={{100,12},
            {120,32}}, rotation=0)));
  PrescribedExtraPropertyFlowRate sou1(
                                      redeclare package Medium = Medium,
      use_m_flow_in=true) 
    annotation (Placement(transformation(extent={{-46,2},{-26,22}},   rotation=
            0)));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu(threShold=1E-4)
    "Assert that both volumes have the same concentration" 
    annotation (Placement(transformation(extent={{60,130},{80,150}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression reaExp(y=vol.mC[1]) 
    annotation (Placement(transformation(extent={{0,150},{20,170}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression reaExp1(y=vol1.mC[1]) 
    annotation (Placement(transformation(extent={{0,110},{20,130}}, rotation=0)));
  MixingVolumes.MixingVolume vol2(
    redeclare package Medium = Medium,
    nPorts=2,
    p_start=Medium.p_default,
    V=100) "Mixing volume" 
                          annotation (Placement(transformation(extent={{60,-40},
            {80,-20}}, rotation=0)));
  MixingVolumes.MixingVolume vol3(
    redeclare package Medium = Medium,
    nPorts=2,
    p_start=Medium.p_default,
    V=100) "Mixing volume" 
                          annotation (Placement(transformation(extent={{60,-80},
            {80,-60}}, rotation=0)));
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM spl(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1},
    dp_nominal={1,1,1},
    from_dp=false) annotation (Placement(transformation(
        origin={42,-60},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu1(
                                                     threShold=1E-4)
    "Assert that both volumes have the same concentration" 
    annotation (Placement(transformation(extent={{60,70},{80,90}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression reaExp2(y=vol2.mC[1]) 
    annotation (Placement(transformation(extent={{0,90},{20,110}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression reaExp3(y=vol3.mC[1]) 
    annotation (Placement(transformation(extent={{0,50},{20,70}}, rotation=0)));
  MixingVolumes.MixingVolume vol4(
    redeclare package Medium = Medium,
    nPorts=3,
    p_start=Medium.p_default,
    V=100) "Mixing volume" 
                          annotation (Placement(transformation(extent={{-4,-60},
            {16,-40}}, rotation=0)));
  PrescribedExtraPropertyFlowRate sou2(
                                      redeclare package Medium = Medium,
      use_m_flow_in=true) 
    annotation (Placement(transformation(extent={{-46,-70},{-26,-50}}, rotation=
           0)));
  Modelica.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    p=101325,
    nPorts=1,
    T=293.15) annotation (Placement(transformation(extent={{-60,-100},{-40,-80}},
          rotation=0)));
  Modelica.Fluid.Sources.Boundary_pT bou1(
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
  inner Modelica.Fluid.System system 
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
equation
  connect(reaExp.y, assEqu.u1) 
    annotation (Line(points={{21,160},{40,160},{40,146},{58,146}}, color={0,0,
          127}));
  connect(reaExp1.y, assEqu.u2) 
    annotation (Line(points={{21,120},{40,120},{40,134},{58,134}}, color={0,0,
          127}));
  connect(reaExp2.y, assEqu1.u1) 
    annotation (Line(points={{21,100},{40,100},{40,86},{58,86}}, color={0,0,127}));
  connect(reaExp3.y, assEqu1.u2) 
    annotation (Line(points={{21,60},{40,60},{40,74},{58,74}}, color={0,0,127}));
  connect(vol4.ports[2], spl.port_3) annotation (Line(points={{6,-60},{32,-60}},
                     color={0,127,255}));
  connect(spl.port_1, vol2.ports[1]) 
                                    annotation (Line(points={{42,-50},{42,-40},
          {68,-40}},   color={0,127,255}));
  connect(spl.port_2, vol3.ports[1]) 
                                    annotation (Line(points={{42,-70},{42,-80},
          {68,-80}},   color={0,127,255}));
  connect(res2.port_a, vol3.ports[2]) 
                                     annotation (Line(points={{98,-80},{72,-80}},
                                  color={0,127,255}));
  connect(res1.port_a, vol2.ports[2]) 
                                     annotation (Line(points={{98,-40},{72,-40}},
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
  connect(sou.ports, vol.ports) annotation (Line(
      points={{-26,40},{110,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[1], res.port_a) annotation (Line(
      points={{-26,12},{60,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, vol1.ports[1]) annotation (Line(
      points={{82,12},{110,12}},
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
end PrescribedExtraPropertyFlow;
