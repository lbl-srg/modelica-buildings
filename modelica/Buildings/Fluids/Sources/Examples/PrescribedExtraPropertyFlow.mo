model PrescribedExtraPropertyFlow 
    annotation (Diagram, Commands(file=
            "PrescribedExtraPropertyFlow.mos" "run"));
 package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir(extraPropertiesNames={"CO2"});
 // package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir;
  
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    initType=Modelica_Fluid.Types.Init.InitialValues,
    nP=1, 
    V=100) "Mixing volume" 
                          annotation (extent=[102,30; 122,50]);
  annotation (Diagram, Coordsys(extent=[-100,-100; 180,180]));
  inner Modelica_Fluid.Ambient ambient annotation (extent=[-100,-100; -80,-80]);
  PrescribedExtraPropertyFlowRate sou(redeclare package Medium = Medium) 
    annotation (extent=[-46,30; -26,50]);
  Modelica.Blocks.Sources.Step step(          startTime=0.5,
    height=-2,
    offset=2) 
    annotation (extent=[-100,30; -80,50]);
  FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium,
    m0_flow=1,
    dp0=1) "Resistance, used to check if species are transported between ports"
    annotation (extent=[60,-10; 82,10]);
  MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    initType=Modelica_Fluid.Types.Init.InitialValues,
    nP=1, 
    V=100) "Mixing volume" 
                          annotation (extent=[102,-10; 122,10]);
  PrescribedExtraPropertyFlowRate sou1(
                                      redeclare package Medium = Medium) 
    annotation (extent=[-46,-10; -26,10]);
  Buildings.Utilities.Controls.AssertEquality assEqu(threShold=1E-4) 
    "Assert that both volumes have the same concentration" 
    annotation (extent=[60,130; 80,150]);
  Modelica.Blocks.Sources.RealExpression reaExp(y=vol.mC[1]) 
    annotation (extent=[0,150; 20,170]);
  Modelica.Blocks.Sources.RealExpression reaExp1(y=vol1.mC[1]) 
    annotation (extent=[0,110; 20,130]);
  MixingVolumes.MixingVolume vol2(
    redeclare package Medium = Medium,
    nP=2,
    initType=Modelica_Fluid.Types.Init.SteadyState,
    p_start=Medium.p_default, 
    V=100) "Mixing volume" 
                          annotation (extent=[60,-50; 80,-30]);
  MixingVolumes.MixingVolume vol3(
    redeclare package Medium = Medium,
    nP=2,
    initType=Modelica_Fluid.Types.Init.SteadyState,
    p_start=Medium.p_default, 
    V=100) "Mixing volume" 
                          annotation (extent=[60,-90; 80,-70]);
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM spl(
    redeclare package Medium = Medium,
    m0_flow={1,1,1},
    dp0={1,1,1},
    from_dp=false) annotation (extent=[22,-70; 42,-50], rotation=270);
  Buildings.Utilities.Controls.AssertEquality assEqu1(
                                                     threShold=1E-4) 
    "Assert that both volumes have the same concentration" 
    annotation (extent=[60,70; 80,90]);
  Modelica.Blocks.Sources.RealExpression reaExp2(y=vol2.mC[1]) 
    annotation (extent=[0,90; 20,110]);
  Modelica.Blocks.Sources.RealExpression reaExp3(y=vol3.mC[1]) 
    annotation (extent=[0,50; 20,70]);
  MixingVolumes.MixingVolume vol4(
    redeclare package Medium = Medium,
    nP=3,
    initType=Modelica_Fluid.Types.Init.SteadyState,
    p_start=Medium.p_default, 
    V=100) "Mixing volume" 
                          annotation (extent=[-10,-70; 10,-50]);
  PrescribedExtraPropertyFlowRate sou2(
                                      redeclare package Medium = Medium) 
    annotation (extent=[-46,-70; -26,-50]);
  PrescribedBoundary_pTX bou(
    redeclare package Medium = Medium,
    p=101325,
    T=293.15) annotation (extent=[-60,-100; -40,-80]);
  FixedBoundary_pTX bou1(
    redeclare package Medium = Medium,
    T=293.15,
    p=101320) annotation (extent=[160,-50; 140,-30], rotation=0);
  FixedBoundary_pTX bou2(
    redeclare package Medium = Medium,
    T=293.15,
    p=101320) annotation (extent=[160,-90; 140,-70], rotation=0);
  FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = Medium,
    m0_flow=1,
    dp0=1) "Resistance, used to check if species are transported between ports"
    annotation (extent=[98,-50; 120,-30]);
  FixedResistances.FixedResistanceDpM res2(
    redeclare package Medium = Medium,
    m0_flow=1,
    dp0=1) "Resistance, used to check if species are transported between ports"
    annotation (extent=[98,-90; 120,-70]);
  FixedResistances.FixedResistanceDpM res3(
    redeclare package Medium = Medium,
    m0_flow=1,
    dp0=1) "Resistance, used to check if species are transported between ports"
    annotation (extent=[-26,-100; -4,-80]);
equation 
  connect(sou.port, vol.port[1]) 
    annotation (points=[-26,40; 112,40],style(color=69, rgbcolor={0,127,255}));
  connect(step.y, sou.mC_flow_in[1]) annotation (points=[-79,40; -48.1,40], style(
        color=74, rgbcolor={0,0,127}));
  connect(step.y, sou1.mC_flow_in[1]) annotation (points=[-79,40; -58,40; -58,
        6.66134e-16; -48.1,6.66134e-16], style(color=74, rgbcolor={0,0,127}));
  connect(sou1.port, res.port_a) annotation (points=[-26,6.10623e-16; -12,
        -3.36456e-22; -14,0; 60,6.10623e-16],
                      style(color=69, rgbcolor={0,127,255}));
  connect(res.port_b, vol1.port[1]) annotation (points=[82,6.10623e-16; 97,
        6.10623e-16; 97,5.55112e-16; 112,5.55112e-16],style(color=69, rgbcolor=
          {0,127,255}));
  connect(reaExp.y, assEqu.u1) 
    annotation (points=[21,160; 40,160; 40,146; 58,146],
                                       style(color=74, rgbcolor={0,0,127}));
  connect(reaExp1.y, assEqu.u2) 
    annotation (points=[21,120; 40,120; 40,134; 58,134],
                                       style(color=74, rgbcolor={0,0,127}));
  connect(reaExp2.y, assEqu1.u1) 
    annotation (points=[21,100; 40,100; 40,86; 58,86],
                                       style(color=74, rgbcolor={0,0,127}));
  connect(reaExp3.y, assEqu1.u2) 
    annotation (points=[21,60; 40,60; 40,74; 58,74],
                                       style(color=74, rgbcolor={0,0,127}));
  connect(step.y, sou2.mC_flow_in[1]) annotation (points=[-79,40; -60,40; -60,-60;
        -48.1,-60], style(color=74, rgbcolor={0,0,127}));
  connect(sou2.port, vol4.port[1]) annotation (points=[-26,-60; -13,-60; -13,
        -60.6667; 5.55112e-16,-60.6667], style(color=69, rgbcolor={0,127,255}));
  connect(vol4.port[2], spl.port_3) annotation (points=[5.55112e-16,-60; 22,-60],
      style(color=69, rgbcolor={0,127,255}));
  connect(spl.port_1, vol2.port[1]) annotation (points=[32,-49; 32,-40.5; 70,
        -40.5], style(color=69, rgbcolor={0,127,255}));
  connect(spl.port_2, vol3.port[1]) annotation (points=[32,-71; 32,-80.5; 70,
        -80.5], style(color=69, rgbcolor={0,127,255}));
  connect(bou1.port, res1.port_b) annotation (points=[140,-40; 120,-40], style(
        color=69, rgbcolor={0,127,255}));
  connect(bou2.port, res2.port_b) annotation (points=[140,-80; 120,-80], style(
        color=69, rgbcolor={0,127,255}));
  connect(res2.port_a, vol3.port[2]) annotation (points=[98,-80; 84,-80; 84,
        -79.5; 70,-79.5], style(color=69, rgbcolor={0,127,255}));
  connect(res1.port_a, vol2.port[2]) annotation (points=[98,-40; 84,-40; 84,
        -39.5; 70,-39.5], style(color=69, rgbcolor={0,127,255}));
  connect(bou.port, res3.port_a) annotation (points=[-40,-90; -26,-90], style(
        color=69, rgbcolor={0,127,255}));
  connect(res3.port_b, vol4.port[3]) annotation (points=[-4,-90; 5.55112e-16,
        -90; 5.55112e-16,-59.3333], style(color=69, rgbcolor={0,127,255}));
end PrescribedExtraPropertyFlow;
